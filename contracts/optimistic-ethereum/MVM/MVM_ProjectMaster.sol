pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Roles.sol";

contract MVM_CoinBase is ERC20, ERC20Detailed, Ownable {
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
       ERC20Detailed(tokenName, tokenTicker, 18)
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
    function addMinter(address minter) external onlyOwner {
        require(!_minters.has(minter), "HAVE_MINTER_ROLE_ALREADY");
        _minters.add(minter);
        minters_.push(minter);
    }


    function removeMinter(address minter) external onlyOwner {
        require(_minters.has(msg.sender), "HAVE_MINTER_ROLE_ALREADY");
        _minters.remove(minter);
        uint256 i;
        for (i = 0; i < minters_.length; ++i) {
            if (minters_[i] == minter) {
                minters_[i] = address(0);
                break;
            }
        }
    }
}
