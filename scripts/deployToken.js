const hre = require("hardhat");

async function main() {
 
  const TrothToken = await hre.ethers.getContractFactory("TrothToken");
  const troth = await TrothToken.deploy("TrothToken", "TRO", 18);

  await troth.deployed();

  console.log("Troth Token deployed to:", troth.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
