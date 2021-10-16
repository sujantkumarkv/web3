// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./zombieattack.sol";
import "./erc721.sol";
import "./safemath.sol";

/// @title Contract managing transferring zombie ownership
/// @author Sujant Kumar Krishnvanshi
/** @dev Uses SafeMath for math operations, has ERC721 standards & 
    handles functions related to transferring zombies functions-
    1.balanceOf(): returns zombie count of user,
    2.ownerOf(): returns owner of the zombie,
    3._transfer(): manages the zombie count & transfers the zombies,
    4.transferFrom(): checks the authority of transfer & then calls _transfer() to carry out transfer logic,
    5.approve(): checks that the caller is approved by the original owner to receive the zombie & emits
                  Approval event as in erc721.sol.
*/
contract ZombieOwnership is ZombieAttack, ERC721 {

  using SafeMath for uint256;

  mapping (uint => address) zombieApprovals;

  function balanceOf(address _owner) external view returns (uint256) {
    return ownerZombieCount[_owner];
  }

  function ownerOf(uint256 _tokenId) external view returns (address) {
    return zombieToOwner[_tokenId];
  }

  function _transfer(address _from, address _to, uint256 _tokenId) private {
    ownerZombieCount[_to] = ownerZombieCount[_to].add(1);
    ownerZombieCount[msg.sender] = ownerZombieCount[msg.sender].sub(1);
    zombieToOwner[_tokenId] = _to;
    emit Transfer(_from, _to, _tokenId);
  }

  function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
    require (zombieToOwner[_tokenId] == msg.sender || zombieApprovals[_tokenId] == msg.sender);
    _transfer(_from, _to, _tokenId);
  }

  function approve(address _approved, uint256 _tokenId) external payable onlyOwnerOf(_tokenId) {
    zombieApprovals[_tokenId] = _approved;
    emit Approval(msg.sender, _approved, _tokenId);
  }
 
}
