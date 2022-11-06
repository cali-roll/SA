const namehash = require("eth-ens-namehash");
const main = async () => {
  
  const [owner] = await hre.ethers.getSigners();
  const ContractFactory = await hre.ethers.getContractFactory("SiteAngel")

  const Contract = await ContractFactory.deploy();
  const SiteAngel = await Contract.deployed();

  console.log(" SiteAmgel address: ", SiteAngel.address);
  console.log("Contract deployed by:", owner.address);

  let Txn0  = await Contract.donateEth( namehash.hash("uibounty.xyz"),  ethers.utils.parseEther("0.0001"), { value: ethers.utils.parseEther("0.0001")});
  console.log("Mining...", Txn0.hash);
  await Txn0.wait();
  let Txn1  = await Contract.donateEth( namehash.hash("xx.xyz"),  ethers.utils.parseEther("0.0001"), { value: ethers.utils.parseEther("0.0001")});
  console.log("Mining...", Txn0.hash);
  await Txn1.wait();
  
  let balance = await Contract.getUrlEthBalance( namehash.hash("xx.xyz"));
  // balance.wait();
  console.log("balance", Number(balance)/ Math.pow(10, 18));      
  let contractbalance = await Contract.getBalance();
  // await contractbalance.wait()
  console.log("contractbalance", Number(contractbalance) / Math.pow(10, 18));
  let txx = await Contract.resolve(namehash.hash("uibounty.xyz"));
  // await txx.wait()
  console.log(txx);
  txx = await Contract.getUrlEthBalance(namehash.hash("uibounty.xyz"));
  console.log("uibountybalance", Number(txx) / Math.pow(10, 18));

  let claim = await Contract.claimEth(namehash.hash("uibounty.xyz"), {gasLimit:3000000});
  await claim.wait();
  // console.log("claimed");
  contractbalance = await Contract.getBalance();
  // await contractbalance.wait()
  console.log("contractbalance", Number(contractbalance) / Math.pow(10, 18));
}

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();