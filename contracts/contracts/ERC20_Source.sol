// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC20_Source is ERC20, Ownable, ERC20Permit {
    constructor(
      string memory _name,
      string memory _symbol,
      uint256 _initialSupply,
      address _owner
    ) ERC20(_name, _symbol) ERC20Permit(_name) {
      _mint(msg.sender, _initialSupply);
      transferOwnership(_owner);
    }

    function mint(address to, uint256 amount) public onlyOwner {
      _mint(to, amount);
    }

}