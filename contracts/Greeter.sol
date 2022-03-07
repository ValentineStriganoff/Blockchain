//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Greeter {
    address payable owner;
    address [] UserAddresses;
    uint256 [] AmountsByUserAdress;


    constructor(address [] memory addresses_)  {
        owner = payable(msg.sender);
        UserAddresses = addresses_; // Адреса пользователей, сделавших пожертвования
    }

    modifier restrictToOwner() {
        require(msg.sender == owner, 'available only to the creator of the contract');
        _;
    }

    modifier validateDestination(address payable destinationAddress) {
        require(msg.sender != destinationAddress, 'Sender and recipient cant be the same');
        _;
    }

    modifier validateAmountGreaterZero() {
        require(msg.value > 0, 'Amount has to be greater than 0');
        _;
    }

    modifier validateAmountSmallerOrEqualToBalance() {
        require(msg.value <= address(this).balance, 'Amount has to be smaller or equal to balance');
       _;
    }
    

    function deposit(address payable destinationAddress) public validateDestination(destinationAddress)
    validateAmountGreaterZero() payable {

        uint256 Deposit = msg.value;

        destinationAddress.transfer(Deposit);

        UserAddresses.push(msg.sender);

        AmountsByUserAdress.push(Deposit);

        }

    function withdraw(address payable WithdrawAddress) public validateDestination(WithdrawAddress)
    validateAmountGreaterZero() restrictToOwner() payable {

        uint256 AmountToWithdraw = msg.value;

        WithdrawAddress.transfer(AmountToWithdraw);
        }

}