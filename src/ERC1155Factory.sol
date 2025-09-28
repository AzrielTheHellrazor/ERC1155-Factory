// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

/// @notice Minimal, gas-optimized ERC1155 collection meant to be cloned via a factory.
/// - Keeps a single baseURI (no ERC1155URIStorage per-token strings)
/// - Uses initialize(...) so the implementation can be cloned cheaply
contract ERC1155Collection is ERC1155 {
    using Strings for uint256;

    // Basic collection info
    string public collectionName;
    string public baseURI; // e.g. "ipfs://Qm.../metadata/"
    address public owner;
    bool private _initialized;

    event Initialized(address indexed owner, string name, string baseURI);
    event Minted(address indexed to, uint256 indexed id, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier notInitialized() {
        require(!_initialized, "Already initialized");
        _;
    }

    constructor() ERC1155("") {
        // keep it empty so the implementation itself is cheap to deploy
    }

    /// @notice Initialize the cloned contract — MUST be called exactly once by the clone creator.
    function initialize(string memory _name, string memory _baseURI) external notInitialized {
        owner = msg.sender;
        collectionName = _name;
        baseURI = _baseURI;
        _initialized = true;
        emit Initialized(owner, _name, _baseURI);
    }

    /// @notice Owner can update baseURI if needed
    function setBaseURI(string memory _baseURI) external onlyOwner {
        baseURI = _baseURI;
    }

    /// @notice Mint function that enforces "one-per-address-per-tokenId" semantics.
    /// You can change the require if you want different rules (e.g., allow multiple).
    function mint(uint256 id, uint256 amount) external {
        require(amount > 0, "Amount 0");
        require(balanceOf(msg.sender, id) == 0, "Already owns this tokenId");
        // You can add supply limits or access control here if desired
        _mint(msg.sender, id, amount, "");
        emit Minted(msg.sender, id, amount);
    }

    /// @notice Owner-only mint to arbitrary address (for drops / reserves)
    function ownerMint(address to, uint256 id, uint256 amount) external onlyOwner {
        _mint(to, id, amount, "");
        emit Minted(to, id, amount);
    }

    /// @notice Override uri to return baseURI + tokenId (e.g. ipfs://.../1.json)
    function uri(uint256 tokenId) public view override returns (string memory) {
        // If baseURI ends with '/', you may want to avoid double slashes in production.
        return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
    }
}

/// @notice Factory that deploys cheap clones of ERC1155Collection implementation.
/// The factory deploys one implementation in its constructor and then clones it for each collection.
contract ERC1155Factory {
    using Clones for address;

    address public immutable implementation;
    address[] public collections;

    event CollectionCreated(address indexed owner, address indexed collectionAddress);

    constructor() {
        // Deploy the implementation contract once. It is uninitialized.
        ERC1155Collection impl = new ERC1155Collection();
        implementation = address(impl);
    }

    /// @notice Create a new cloned collection and initialize it in one transaction.
    /// Returns the clone address.
    function createNFTContract(string memory tokenName, string memory _baseURI) external returns (address) {
        address clone = implementation.clone();
        // Initialize the clone. We use the known interface to call initialize.
        ERC1155Collection(clone).initialize(tokenName, _baseURI);

        collections.push(clone);
        emit CollectionCreated(msg.sender, clone);
        return clone;
    }

    function getCollectionsCount() external view returns (uint256) {
        return collections.length;
    }

    function getCollection(uint256 index) external view returns (address) {
        require(index < collections.length, "Index out of bounds");
        return collections[index];
    }
}
