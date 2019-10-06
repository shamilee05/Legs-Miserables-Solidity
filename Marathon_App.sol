pragma solidity ^0.5.8;

contract Marathon_App {

    uint8 totalSum;
    uint8 public participantCount = 0;
    uint8 public no_finished = 0;
    uint8 awardAmount;
    uint8 withdrawAmount;
    address[] participantsAddress;
    bool[] finished;
    
    mapping (address => uint) private balances;

    address public owner;

    event LogDepositMade(address accountAddress, uint amount);

    constructor() public Marathon_App() {
        owner = msg.sender;
    }

    //Enroll a new participant in the marathon
    function enroll() public returns (uint, address){
      
        address user = msg.sender;
        participantsAddress.push(user);
        
        balances[user] = 100;
        
        participantCount++;
        return (user.balance, user);
    }

    //Collect individual amounts for the pool
    function collect_sum() public returns (uint) {
        
        //An amount to be individually collected will be mutually decided
        //withdrawAmount;
        totalSum = 0;
        
        for (uint i = 0; i < participantCount; i++) {
            
            address partAdd = participantsAddress[i];
            
            uint bal = balances[partAdd];
            if(bal>=withdrawAmount) {
                totalSum += withdrawAmount;
            }
        }
        return totalSum;
    }
    
    //Find out who all have finished the marathon
    function finished_marathon() public {

        for (uint i = 0; i < participantCount; i++) {
            
            address partAdd = participantsAddress[i];
            
            //Obtain information from the Maps about who has completed their marathon
            //finished[i] = true/false;
            
            if (finished[i]==true) {
                no_finished++;
            }
        }
    }
    
    //Award is given only for participants who have finished the marathon
    function award_participant() public payable returns (uint) {
        
        awardAmount = totalSum/no_finished;
        
        address user = msg.sender;

        balances[user] += awardAmount;

        emit LogDepositMade(user, awardAmount);

        return balances[user];
    }

    //Amount to be withdrawn from everyone's account for the marathon
    function withdraw() public returns (uint remainingBal) {

        address user = msg.sender;
        
        require(balances[user] >= withdrawAmount);

        balances[user] -= withdrawAmount; 
       
        //user.transfer(withdrawAmount);
    
        return balances[user];
    }

    //Simply show the balance
    function balance() public view returns (uint) {
        address user = msg.sender;
        
        return balances[user];
    }
}
