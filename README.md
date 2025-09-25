# ERC1155 NFT Factory

A factory contract that allows users to easily create ERC1155 NFT collections.

## 🎯 Features

- **ERC1155 Factory**: Creates new NFT collections
- **Per-Token URI**: Custom metadata URI for each token
- **Easy Minting**: Users can mint tokens in their own collections
- **OpenZeppelin**: Secure and tested contracts

## 📁 Project Structure

```
src/
├── ERC1155Factory.sol     # Main factory contract
└── ERC1155Collection.sol  # Generated NFT collections

script/
└── DeployERC1155Factory.s.sol  # Deploy script
```

## 🚀 Usage

### 1. Build Project

```bash
forge build
```

### 2. Run Tests

```bash
forge test
```

### 3. Deploy Factory Contract

```bash
forge script script/DeployERC1155Factory.s.sol --rpc-url <RPC_URL> --broadcast
```

### 4. Create New NFT Collection

After deploying the factory contract:

```solidity
// Call factory contract
address collectionAddress = factory.createNFTContract(
    "My NFT Collection",           // Collection name
    "ipfs://QmHash/metadata.json"  // First token's metadata URI
);

// Use the created collection contract
ERC1155Collection collection = ERC1155Collection(collectionAddress);

// Mint more tokens (for ID 0)
collection.mintMore(10); // Mint 10 more tokens
```

## 🔧 Contract Functions

### ERC1155Factory

- `createNFTContract(string name, string imageURI)` → Creates new collection
- `getCollectionsCount()` → Returns number of created collections
- `getCollection(uint256 index)` → Returns specific collection address

### ERC1155Collection

- `mintMore(uint256 amount)` → Mints more tokens for ID 0
- `uri(uint256 tokenId)` → Returns token's metadata URI
- `collectionName()` → Returns collection name

## 📋 Requirements

- Foundry
- OpenZeppelin Contracts v5.4.0+

## 🛠️ Development

### Local Testnet

```bash
# Start Anvil
anvil

# Deploy in another terminal
forge script script/DeployERC1155Factory.s.sol --rpc-url http://localhost:8545 --broadcast
```

### Test Networks

```bash
# Real Blockchain
forge script script/DeployERC1155Factory.s.sol --private-key <your-private-key> --rpc-url <rpc-url> --broadcast
```

## 📖 Documentation

- [Foundry Book](https://book.getfoundry.sh/)
- [OpenZeppelin ERC1155](https://docs.openzeppelin.com/contracts/4.x/erc1155)
