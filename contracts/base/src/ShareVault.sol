// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ShareVault Contract
/// @author solidworkssa
/// @notice Encrypted file sharing registry.
contract ShareVault {
    string public constant VERSION = "1.0.0";


    struct FileAccess {
        string cid;
        address owner;
        mapping(address => bool) hasAccess;
    }
    
    mapping(uint256 => FileAccess) public files;
    uint256 public nextFileId;
    
    function uploadFile(string memory _cid) external {
        uint256 id = nextFileId++;
        FileAccess storage f = files[id];
        f.cid = _cid;
        f.owner = msg.sender;
    }
    
    function grantAccess(uint256 _id, address _user) external {
        require(files[_id].owner == msg.sender, "Not owner");
        files[_id].hasAccess[_user] = true;
    }
    
    function revokeAccess(uint256 _id, address _user) external {
        require(files[_id].owner == msg.sender, "Not owner");
        files[_id].hasAccess[_user] = false;
    }

}
