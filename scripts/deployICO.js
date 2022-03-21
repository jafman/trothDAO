const hre = require("hardhat");
require('dotenv').config();
async function main() {
 
  const icoContract = await hre.ethers.getContractFactory("Crowdsale");
  const ico = await icoContract.deploy(1, process.env.PAYMENT_ADDRESS, process.env.TOKEN_ADDRESS);

  await ico.deployed();

  console.log("ICO Token deployed to:", ico.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
