// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

import { ERC20_Source } from "./ERC20_Source.sol";


/// @custom:security-contact ReceptionFM
contract SmartCoupon is Initializable, PausableUpgradeable, AccessControlUpgradeable  {
  using CountersUpgradeable for CountersUpgradeable.Counter;

  CountersUpgradeable.Counter private _contractIndex;
  address contractOwner;

  mapping(uint256 => address) public indexToAddress;
  bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

  constructor() initializer{
    
    __AccessControl_init();
    __Pausable_init();

    _grantRole(ADMIN_ROLE, msg.sender);
    _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);

    contractOwner = msg.sender;
  }
  
  function initialize() initializer external {
    __AccessControl_init();
    __Pausable_init();

    _grantRole(ADMIN_ROLE, msg.sender);
    _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
  }

  function withdrawBalance() external onlyRole(ADMIN_ROLE) {
    address payable ownerPayable = payable(contractOwner);
    // send all Ether to owner
    // Owner can receive Ether since the address of owner is payable
    ownerPayable.transfer(address(this).balance);
  }

  function createErc20Token(string calldata tokenName, string calldata symbol, uint256 supply, address to) external returns(address){
    ERC20_Source child = new ERC20_Source(tokenName, symbol, supply, to);
    //children.push(child);
    //uint256 tokenIndex = children.length;
    uint256 tokenIndex = _contractIndex.current();
    _contractIndex.increment();
    indexToAddress[tokenIndex] = address(child);

    return address(child);
  }
}