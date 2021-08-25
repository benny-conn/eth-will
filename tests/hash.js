const { utils } = require("ethers")

function hash() {
  console.log(utils.hexlify(utils.toUtf8Bytes(process.argv[2])))
  console.log(utils.keccak256(utils.toUtf8Bytes(process.argv[2])))
}

hash()
