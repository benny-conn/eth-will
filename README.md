# eth-will

_Scripts and base/helper contracts brought to you by openzeppelin_
_Contract interaction with the help of Alchemy_

The purpose of these contracts are to provide a more secure method of ensuring that your loved ones are paid in the event of untimely death. With these contracts you can create an infinitely large secret that will unlock the contract and allow it's beneficiaries to retrieve their predetermined funds. The advantage of using this contract over putting private keys in a will is the fine control over what can occur after your death. This contract ensures that each person gets what you decide and no one who you did not intend to receive any funds can access anything.

**note: this contract uses WETH because ETH is not ERC20 compliant unfortunately**

## Deploy

1. Pull repo locally and copy `.env.sample` into another file called `.env`. Fill out the fields in this file with your alchemy app url and test net public and private keys.
2. Run the following script

```bash
npm run deploy-dev
```

Done! The address of your deployed contract will be printed in the console on a successful deploy.

## WillFactory Contract

### getWill(address owner)

Will return the address of the contract that represents that address's will.

### createWill(bytes32 secret)

A function that will deploy a new Will contract that represents a will for the caller. The secret parameter is a keccak256 hashed string that represents the key to unlock a will (can be changed later by the owner). It is the responsibility of the caller to input a pre-hashed secret.

# Will Contract

### setBeneficiaries(address[] beneficiaries, uint256[] amounts)

A function that takes in an array of beneficiaries and an equal in length array of amounts in WEI that represents the amounts that each beneficiary will be able to receieve in WETH after the contract is unlocked.

### setSecret(bytes32 hashedSecret)

A function that takes in a keccak256 hashed string that represents the key to unlocking the will and sets the will's secret to this hashed string.

### unlock(bytes secret)

A function that takes in the unhashed version of the will's secret in byte representation. This function will unlock the will so that funds can be retrieved by the beneficiaries.

### fullfil()

A function that is to be called by a beneficiary and will transfer them their predetermined funds. This function can only be called after the will has been unlocked.

### lock(bytes32 hashedSecret)

A safety function in the event that somehow a will is unlocked before the owner is dead, this function can be called by the owner to re-lock the contract with a new keccak256 hashed string as a secret.

_Try not to die now :)_
