const main = async () => {
  const [owner] = await hre.ethers.getSigners();
  const ContractFactory = await hre.ethers.getContractFactory("SiteAngel")

  const Contract = await ContractFactory.deploy();
  const SiteAngel = await Contract.deployed();

  console.log(" SiteAmgel address: ", SiteAngel.address);
  console.log("Contract deployed by:", owner.address);

  let Txn0  = await Contract.donateEth("wherememe.xyz",  ethers.utils.parseEther("0.0001"), { value: ethers.utils.parseEther("0.0001")});
  console.log("Mining...", Txn0.hash);
  await Txn0.wait();
  let Txn1  = await Contract.donateEth("xx.xyz",  ethers.utils.parseEther("0.0001"), { value: ethers.utils.parseEther("0.0001")});
  console.log("Mining...", Txn0.hash);
  await Txn1.wait();
  
  let balance = await Contract.getUrlEthBalance("xx.xyz");
  console.log("balance", Number(balance)/ Math.pow(10, 18));      
  let contractbalance = await Contract.getBalance();
  console.log("contractbalance", Number(contractbalance) / Math.pow(10, 18));
  let claim = Contract.claimEth("xx.xyz");
  // console.log("claimed");
  contractbalance = await Contract.getBalance();
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