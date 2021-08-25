// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Will {
    event WillFulfilled(address indexed owner);

    struct Beneficiary {
        address addr;
        uint256 amount;
    }

    IERC20 private constant wethContract =
        IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);

    address private owner;
    Beneficiary[] private beneficiaries;
    bytes32 private hashedSecret;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor(address _owner, bytes32 _hashedSecret) {
        owner = _owner;
        hashedSecret = _hashedSecret;
    }

    function setBenficiaries(Beneficiary[] memory _beneficiaries)
        external
        onlyOwner
    {
        beneficiaries = _beneficiaries;
    }

    function getBenficiaries() public view returns (Beneficiary[] memory) {
        return beneficiaries;
    }

    function setSecret(bytes32 _hashedSecret) external onlyOwner {
        hashedSecret = _hashedSecret;
    }

    function fulfill(bytes memory secret) external {
        require(beneficiaries.length > 0, "Will: no benficiaries");
        require(keccak256(secret) == hashedSecret, "Will: secret is incorrect");
        for (uint256 i = 0; i < beneficiaries.length; i++) {
            wethContract.transferFrom(
                owner,
                beneficiaries[i].addr,
                beneficiaries[i].amount
            );
        }
        emit WillFulfilled(owner);
    }
}
