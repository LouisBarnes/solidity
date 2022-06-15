// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DemoTokenERC20 is ERC20Capped, Ownable {

    constructor(uint256 cap) ERC20("DemoToken", "DT") ERC20Capped(cap){}

    function issueToken(uint256 _tokenAmount) public onlyOwner {
            _mint(msg.sender, _tokenAmount*10**18);
    }
}
