// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./Will.sol";

contract WillFactory {
    IERC20 private constant wethContract =
        IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);

    event WillCreate(address indexed owner, address indexed will);

    // owner to will contracts
    mapping(address => address) private _wills;

    function getWill(address owner) external view returns (address) {
        return _wills[owner];
    }

    function createWill(bytes32 secret) external {
        require(_wills[msg.sender] == address(0));
        Will will = new Will(msg.sender, secret);
        _wills[msg.sender] = address(will);
        emit WillCreate(msg.sender, address(will));
    }
}
