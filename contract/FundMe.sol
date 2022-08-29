// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

// OWNER == 0x1d38649F181889BF189926862784b89dFb5414F3
// GORELI == 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e

error notOwner() ;

contract fundMe {

/* @dev created an array to store
 eth and by whom funded with their address 
 and amount
*/

    address[] public funders;
    mapping (address=>uint256) public addressToEthFundedIndex;

    address public immutable I_OWNER;

    uint256 public constant MINIMUM_USD = 50 * 10 ** 18 ;// 50usd according to eth with 18 zero

/* @dev declared that one who deploy
 this contract is owner of this 
 contract, in this case owner of the contract is 
 0x1d38649F181889BF189926862784b89dFb5414F3 and
 this contract is deployed in goerli testnet
*/

    constructor() {
        I_OWNER = msg.sender;
    }

/* @dev creats fund() function that get eth(msg.value)
   from funders and converts into usd with using chainlinks"s
    AggregatorV3Interface.sol,
    if funder send eth less then MINIMUM_USD then it reverts
    and show msg that "not enough eth"
*/
    function fund() public payable {
        require(msg.value/*.getConversionRate()*/ >= MINIMUM_USD, "not enough eth ");
        addressToEthFundedIndex[msg.sender] += msg.value;
        funders.push(msg.sender);
    }
/* @dev creats modifier function to declare that msg.sender
    is owner of the contract if another person try to withraw eth 
     it revert and throws error
*/
    
    modifier isOwner() {
        // I_OWNER = msg.sender;
        if(msg.sender != I_OWNER) revert notOwner() ;
        _;
    }

/* @dev creats withdraw() function payable to one who deploys
    this contract if this function called and worked is shows "sent"
    or if this function can't send eth it will show "Failed to send Ether"
 */

    function withdraw() payable isOwner public {
         (bool sent,) = payable(msg.sender).call{value: address(this).balance }("");
        require(sent, "Failed to send Ether");
    }


    }
