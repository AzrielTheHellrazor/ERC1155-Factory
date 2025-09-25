// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import {ERC1155URIStorage} from "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155URIStorage.sol";

contract ERC1155Collection is ERC1155, ERC1155URIStorage {
    string public collectionName;

    constructor(string memory tokenName, string memory imageURI) ERC1155("") {
        collectionName = tokenName;
        uint256 tokenId = 0;
        _mint(msg.sender, tokenId, 1, "");
        _setURI(tokenId, imageURI);
    }

    function uri(uint256 tokenId) public view override(ERC1155, ERC1155URIStorage) returns (string memory) {
        require(balanceOf(msg.sender, tokenId) == 0, "You already have a token");
        return ERC1155URIStorage.uri(tokenId);
    }
}

contract ERC1155Factory {
    ERC1155Collection[] public collections;

    function createNFTContract(string memory tokenName, string memory imageURI) public returns (address) {
        ERC1155Collection col = new ERC1155Collection(tokenName, imageURI);
        collections.push(col);
        return address(col);
    }

    function getCollectionsCount() public view returns (uint256) {
        return collections.length;
    }

    function getCollection(uint256 index) public view returns (address) {
        require(index < collections.length, "Index out of bounds");
        return address(collections[index]);
    }
}
