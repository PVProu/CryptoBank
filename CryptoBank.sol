//License
// SPDX-License-Identifier: LGPL-3.0-only

// Solidity version
pragma solidity 0.8.24;

//Functions: 
    // 1. Diposit Ether
    // 2. Withdraw Ether

//Rules:
    // 1. Multiuser
    // 2. Only can deposit ether
    // 3. User can only withdraw previously deposited ether
    // 4. MAX balance = 5 ether
    // 5. MaxBalance modifiable by owner
    // UserA -> Deposit 5 ether
    // UserB -> Deposit 2 ether
    // Bank balance = 7 ether
    // User A -> deposit 1 ether -> deposit 4 ether -> withdraw 2 ether...

contract CryptoBank{

    // Variables
    uint256 public maxBalance;
    address public admin;

    mapping (address => uint256) public userBalance;

    //Events
    event EtherDeposit(address user_, uint256 etherAmount_);
    event EtherWithdraw(address user_, uint256 etherAmount_);
    event MaxBalanceChanged(uint256 newMaxBalance_);

    // Modifiers
    modifier onlyAdmin(){
        require (msg.sender == admin, "Not admin");
        _;
    }

    constructor(uint256 maxBalance_, address admin_){
            maxBalance = maxBalance_;
            admin = admin_;
    }

    //Functions

    // 1 . Deposit
    function depositEther() external payable{
        require(userBalance[msg.sender] + msg.value <= maxBalance, "Max balance reached");
        userBalance[msg.sender] += msg.value; // When we are sending or receiving ether, ALWAYS use msg.value due to security reasons
        emit EtherDeposit(msg.sender, msg.value);
    }

    // 2. Withdraw
    function withdrawEther(uint256 amount_) external{
        // CEI pattern: 1-checks, 2- Effects, 3-interactions, otherwise it can be vulnerable for hacking attacks (like reentrancy attacks)
        require(amount_ <= userBalance[msg.sender], "Not enough ether");
        // 1. Update state
        userBalance[msg.sender] -= amount_;
        // 2. Transfer ether
        (bool success,) = msg.sender.call{value: amount_}("");
        require(success, "Failed to send ether");

        emit EtherWithdraw(msg.sender, amount_);
    }

    // 3. Modify maxBalance
    function modifyMaxBalance(uint256 newMaxBalance_) external onlyAdmin{
        maxBalance = newMaxBalance_;
        emit MaxBalanceChanged(maxBalance);
    }
}