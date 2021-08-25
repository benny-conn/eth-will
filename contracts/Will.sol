// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Will {
    event WillUnlocked(address indexed owner);

    IERC20 private constant wethContract =
        IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);

    address private owner;
    mapping(address => uint256) private beneficiaries;
    bytes32 private hashedSecret;

    bool private locked = true;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    modifier onlyUnlocked() {
        require(!locked);
        _;
    }

    constructor(address _owner, bytes32 _hashedSecret) {
        owner = _owner;
        hashedSecret = _hashedSecret;
    }

    function setBeneficiaries(
        address[] memory _beneficiaries,
        uint256[] memory _amounts
    ) external onlyOwner {
        require(
            _beneficiaries.length == _amounts.length,
            "Will: amounts length does not equal beneficiaries length"
        );
        uint256 totalAllotted = 0;
        for (uint256 i = 0; i < _amounts.length; i++) {
            totalAllotted += _amounts[i];
        }
        require(
            wethContract.allowance(address(this), owner) >= totalAllotted,
            "Will: cannot allot more than you have allowed the will to use"
        );
        for (uint256 i = 0; i < _beneficiaries.length; i++) {
            beneficiaries[_beneficiaries[i]] = _amounts[i];
        }
    }

    function setSecret(bytes32 _hashedSecret) external onlyOwner {
        hashedSecret = _hashedSecret;
    }

    function unlock(bytes memory secret) external {
        require(keccak256(secret) == hashedSecret, "Will: secret is incorrect");
        require(locked, "Will: already unlocked");
        locked = false;
        emit WillUnlocked(owner);
    }

    function fulfill() external onlyUnlocked {
        require(beneficiaries[msg.sender] > 0, "Will: no amount to fulfill");
        wethContract.transferFrom(owner, msg.sender, beneficiaries[msg.sender]);
    }

    function lock(bytes32 _hashedSecret) external onlyUnlocked onlyOwner {
        locked = true;
        hashedSecret = _hashedSecret;
    }
}
