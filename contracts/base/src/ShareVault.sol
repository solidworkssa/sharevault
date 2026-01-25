// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ShareVault {
    struct Document {
        address owner;
        string ipfsHash;
        string encryptionKey;
        uint256 timestamp;
        bool active;
    }

    mapping(uint256 => Document) public documents;
    mapping(uint256 => mapping(address => bool)) public accessControl;
    uint256 public documentCounter;

    event DocumentStored(uint256 indexed docId, address indexed owner, string ipfsHash);
    event AccessGranted(uint256 indexed docId, address indexed user);
    event AccessRevoked(uint256 indexed docId, address indexed user);

    error Unauthorized();
    error InvalidDocument();

    function storeDocument(string memory ipfsHash, string memory encryptionKey) external returns (uint256) {
        uint256 docId = documentCounter++;
        documents[docId] = Document(msg.sender, ipfsHash, encryptionKey, block.timestamp, true);
        accessControl[docId][msg.sender] = true;
        emit DocumentStored(docId, msg.sender, ipfsHash);
        return docId;
    }

    function grantAccess(uint256 docId, address user) external {
        if (documents[docId].owner != msg.sender) revert Unauthorized();
        accessControl[docId][user] = true;
        emit AccessGranted(docId, user);
    }

    function revokeAccess(uint256 docId, address user) external {
        if (documents[docId].owner != msg.sender) revert Unauthorized();
        accessControl[docId][user] = false;
        emit AccessRevoked(docId, user);
    }

    function getDocument(uint256 docId) external view returns (Document memory) {
        if (!accessControl[docId][msg.sender]) revert Unauthorized();
        return documents[docId];
    }

    function hasAccess(uint256 docId, address user) external view returns (bool) {
        return accessControl[docId][user];
    }
}
