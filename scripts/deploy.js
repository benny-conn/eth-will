async function main() {
  const WillFactory = await ethers.getContractFactory("WillFactory")

  // Start deployment, returning a promise that resolves to a contract object
  const willF = await WillFactory.deploy() // Instance of the contract
  console.log("Contract deployed to address:", willF.address)
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error)
    process.exit(1)
  })
