# CryptoBank

A simple and secure Ethereum smart contract bank where users can deposit and withdraw Ether. The contract enforces a maximum balance per user and allows only the admin to modify this limit.

## Features

- **Multi-user support:** Each user has their own deposit balance.
- **Ether-only deposits:** Only Ether is accepted (no ERC20 tokens).
- **Withdrawal constraints:** Users can only withdraw up to their deposited amount.
- **Per-user max balance:** Each user can hold up to a maximum (default: 5 Ether, modifiable by the admin).
- **Admin controls:** The admin can update the maximum allowed balance per user.

## How It Works

1. **Deposit Ether:**  
   Users call `depositEther()` and send Ether along with the transaction.  
   - The contract enforces that a user's balance does not exceed `maxBalance`.
   - Event: `EtherDeposit(address user, uint256 etherAmount)`

2. **Withdraw Ether:**  
   Users call `withdrawEther(uint256 amount)` to withdraw their deposited Ether.  
   - Users cannot withdraw more than their current balance.
   - Event: `EtherWithdraw(address user, uint256 etherAmount)`

3. **Admin Controls:**  
   The admin can call `modifyMaxBalance(uint256 newMaxBalance)` to change the max balance per user.  
   - Only the admin address set at deployment can call this.
   - Event: `MaxBalanceChanged(uint256 newMaxBalance)`

## Security Notes

- Uses the Checks-Effects-Interactions pattern to prevent reentrancy during withdrawals.
- Only the admin can change the maximum limit.
- The contract does **not** accept Ether sent directly (must use `depositEther()`).

## Example Usage

```solidity
// Deploy with 5 ether max and your admin address
CryptoBank bank = new CryptoBank(5 ether, adminAddress);

// User deposits 1 ether
bank.depositEther{value: 1 ether}();

// User withdraws 0.5 ether
bank.withdrawEther(0.5 ether);

// Admin changes max balance to 10 ether
bank.modifyMaxBalance(10 ether);
```

## Events

- `EtherDeposit(address user, uint256 etherAmount)`
- `EtherWithdraw(address user, uint256 etherAmount)`
- `MaxBalanceChanged(uint256 newMaxBalance)`

## Deployment

1. Deploy the contract using Remix, Hardhat, or other Ethereum tools.
2. Set the desired max balance (e.g., 5 ether) and the admin address at deployment.

## License

[LGPL-3.0-only](./LICENSE)

---

**This contract is for educational/demo purposes. Use with caution and audit before deploying on mainnet.**
