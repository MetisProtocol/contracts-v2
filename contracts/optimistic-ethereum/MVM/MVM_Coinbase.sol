pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Roles.sol";

contract MVM_CoinBase is ERC20, Ownable {
    using Roles for Roles.Role;

    Roles.Role private _minters;
    using SafeMath for uint256;

    address[] minters_;
    uint256 maxSupply_;

    constructor(
     	address[] memory minters,
        uint256 maxSupply,
        string memory tokenName,
        string memory tokenTicker
    )
       ERC20(tokenName, tokenTicker, 18)
       public
    {
        for (uint256 i = 0; i < minters.length; ++i) {
	    _minters.add(minters[i]);
        }
        minters_ = minters;
        maxSupply_ = maxSupply;
    }

    function mint(address target, uint256 amount) external {
        require(_minters.has(msg.sender), "ONLY_MINTER_ALLOWED_TO_DO_THIS");
        require(maxSupply == 0 || SafeMath.add(totalSupply(), amount) <= maxSupply_, "EXCEEDING_MAX_SUPPLY");
        _mint(target, amount);
    }

    function burn(address target, uint256 amount) external {
        require(_minters.has(msg.sender), "ONLY_MINTER_ALLOWED_TO_DO_THIS");
        _burn(target, amount);
    }

}
