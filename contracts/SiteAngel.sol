// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract SiteAngel is  Pausable {
    // uint256 UrlCount;
    uint256 TotalTokenAmount;    
    
    struct TokenAmounts {
        uint ethreum;
        uint apecoin;
    }
    mapping (string => TokenAmounts) public UrlToTokenAmounts;
    
    event NewTip(
        string url,
        uint256 tokenamount
    );
    event ClaimTip(
        string url,
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



    receive() external payable {
    }
    fallback() external payable {
    }

    
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function setEthTokenAmounts(string memory _url, uint256 _tokenamount) public{
    UrlToTokenAmounts[_url].ethreum= _tokenamount;
  }

    function setApeTokenAmounts(string memory _url, uint256 _tokenamount) public{
    UrlToTokenAmounts[_url].apecoin= _tokenamount;
  }
    function getUrlEthBalance(string memory _url) public view returns (uint256) {
         return UrlToTokenAmounts[_url].ethreum;
    }
// user call this to donate token to url who do not have DNS as ENS
    function donateEth(
        string memory _url,
        uint256 _amount
    ) public payable {
        //poolの金額をcontractに追加    
        require(msg.value == _amount);
       
        UrlToTokenAmounts[_url].ethreum += _amount;        
        TotalTokenAmount += _amount;

        //bountyのemit
        emit NewTip(_url, _amount); 
    }


    function claimEth(string memory _url
    ) public {
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