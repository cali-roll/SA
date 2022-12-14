// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
abstract contract ENS {
        function resolver(bytes32 node) public virtual view returns (Resolver);
    }

    abstract contract Resolver {
        function addr(bytes32 node) public virtual view returns (address);
    }    

contract SiteAngel is  Pausable {
    // uint256 UrlCount;
    uint256 TotalTokenAmount;    
    
    struct TokenAmounts {
        uint ethreum;
        uint apecoin;
    }
    mapping (bytes32 => TokenAmounts) public UrlToTokenAmounts;
    
    event NewTip(
        bytes32 url,
        uint256 tokenamount
    );
    event ClaimTip(
        bytes32 url,
        uint256 tokenamount
    );

    //   Some string type variables to identify the token.
    string public name = "My Hardhat Token";
    string public symbol = "MHT";

    // The fixed amount of tokens stored in an unsigned integer type variable.
    uint256 public totalSupply = 1000000;

    // An address type variable is used to store ethereum accounts.
    address public owner;

    // A mapping is a key/value map. Here we store each account balance.
    mapping(address => uint256) balances;

    // The Transfer event helps off-chain aplications understand
    // what happens within your contract.
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    constructor() payable{
        console.log("This is -alpha site angel contract.");
        balances[msg.sender] = totalSupply;
        owner = msg.sender;
    }

    

    function transfer(address to, uint256 amount) external {
            // Check if the transaction sender has enough tokens.
            // If `require`'s first argument evaluates to `false` then the
            // transaction will revert.
            require(balances[msg.sender] >= amount, "Not enough tokens");

            // We can print messages and values using console.log, a feature of
            // Hardhat Network:
            console.log(
                "Transferring from %s to %s %s tokens",
                msg.sender,
                to,
                amount
            );

        // Transfer the amount.
        balances[msg.sender] -= amount;
        balances[to] += amount;

        // Notify off-chain applications of the transfer.
        emit Transfer(msg.sender, to, amount);
    }

    /**
     * Read only function to retrieve the token balance of a given account.
     *
     * The `view` modifier indicates that it doesn't modify the contract's
     * state, which allows us to call it without executing a transaction.
     */
    function balanceOf(address account) external view returns (uint256) {
        return balances[account];
    }
    //ens
    
    ENS ens = ENS(0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e);

    function resolve(bytes32 node) public view returns(address) {
        Resolver resolver = ens.resolver(node);
        return resolver.addr(node);
    }

    receive() external payable {
    }
    fallback() external payable {
    }

    
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function setEthTokenAmounts(bytes32 _url, uint256 _tokenamount) public{
    UrlToTokenAmounts[_url].ethreum= _tokenamount;
  }

    function setApeTokenAmounts(bytes32 _url, uint256 _tokenamount) public{
    UrlToTokenAmounts[_url].apecoin= _tokenamount;
  }
    function getUrlEthBalance(bytes32 _url) public view returns (uint256) {
        require(UrlToTokenAmounts[_url].ethreum != 0, "there is no donation");
         return UrlToTokenAmounts[_url].ethreum;
    }
// user call this to donate token to url who do not have DNS as ENS
    function donateEth(
        bytes32 _url,
        uint256 _amount
    ) public payable {
        //pool????????????contract?????????    
        require(msg.value == _amount);
       
        UrlToTokenAmounts[_url].ethreum += _amount;        
        TotalTokenAmount += _amount;

        //bounty???emit
        emit NewTip(_url, _amount); 
    }


    function claimEth(bytes32 _url
    ) public {
        // require(resolve(_url) == msg.sender, "you're not the owner of the DNS");
        uint claimAmount = UrlToTokenAmounts[_url].ethreum;
        require(
		    claimAmount <= address(this).balance,
    		"Trying to withdraw more money than the contract has."
	    );
    	(bool success, ) = (msg.sender).call{value: claimAmount}("");
    	require(success, "Failed to withdraw money from contract.");
        TotalTokenAmount -= claimAmount;
        UrlToTokenAmounts[_url].ethreum = 0;
        emit ClaimTip(_url, claimAmount);
}

}