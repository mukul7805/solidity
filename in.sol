// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract MyToken is ERC20, ERC20Permit {
    address private _owner;

    // Event to log ownership transfers
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    // Constructor to initialize the token with a name, symbol, and set the owner
    constructor(address initialOwner) ERC20("MyToken", "MTK") ERC20Permit("MyToken") {
        _owner = initialOwner;
        emit OwnershipTransferred(address(0), initialOwner);
    }

    // Custom modifier to restrict access to only the owner
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Caller is not the owner");
        _;
    }

    // Function to return the address of the current owner
    function owner() public view returns (address) {
        return _owner;
    }

    // Function to allow the current owner to transfer ownership
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "New owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

    // Function to mint tokens, can only be called by the contract owner
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // Function to burn tokens, can be called by any token holder
    function burn(uint256 amount) public {
        _burn(_msgSender(), amount);
    }
}
