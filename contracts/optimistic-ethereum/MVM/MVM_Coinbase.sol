// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract MVM_CoinBase is ERC20, AccessControl {

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    using SafeMath for uint256;

    uint256 maxSupply_;

    constructor(
     	address[] memory minters,
        uint256 maxSupply,
        string memory tokenName,
        string memory tokenTicker
    )
       ERC20(tokenName, tokenTicker)
       public
    {
        for (uint256 i = 0; i < minters.length; ++i) {
	    _setupRole(MINTER_ROLE, minters[i]);
        }
        maxSupply_ = maxSupply;
    }

    function mint(address target, uint256 amount) external {
        require(hasRole(MINTER_ROLE, msg.sender), "ONLY_MINTER_ALLOWED_TO_DO_THIS");
        require(maxSupply_ == 0 || SafeMath.add(totalSupply(), amount) <= maxSupply_, "EXCEEDING_MAX_SUPPLY");
        _mint(target, amount);
    }

    function burn(address target, uint256 amount) external {
        require(hasRole(MINTER_ROLE, msg.sender), "ONLY_MINTER_ALLOWED_TO_DO_THIS");
        _burn(target, amount);
    }
}
