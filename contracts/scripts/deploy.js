/* eslint-disable no-unused-vars */
/* eslint-disable no-undef */
require("hardhat");
const ethers = require('ethers');
require("dotenv").config();

// Run local node - npx hardhat node
// local execution - npx hardhat run scripts/deploy.js --network localhost

// network deploy - npx hardhat run scripts/deploy.js --network mumbai


const deployContracts = async () => {
  
  const accounts = await hre.ethers.getSigners();
  const executor = await accounts[0].getAddress();

  // Deploy Coupon
  const couponFactory = await hre.ethers.getContractFactory('SmartCoupon');
  const coupon = await couponFactory.deploy();
  await coupon.deployed();
  
  return [coupon];
}

const main = async () => {
  try {
    //await hre.network.provider.send("hardhat_reset");
    let [coupon] = await deployContracts();
    console.log('coupon address : ', coupon.address);
    
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};


if (!String.format) {
  String.format = function(format) {
    var args = Array.prototype.slice.call(arguments, 1);
    return format.replace(/{(\d+)}/g, function(match, number) { 
      return typeof args[number] != 'undefined'
        ? args[number] 
        : match
      ;
    });
  };
}

main()