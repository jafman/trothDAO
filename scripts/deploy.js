const hre = require("hardhat");

async function main() {
 
  const TrothToken = await hre.ethers.getContractFactory("TrothToken");
  const troth = await TrothToken.deploy(500000000, "Troth", 2, "TRO");

  await troth.deployed();

  console.log("Troth Token deployed to:", troth.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
