# Creating a multisig contract in eris

The aim of this application is to build a contract in which one account creates a contract, which then requires signatures from a list of other accounts which the creator will pass in the constructor.

This could represent a scenario of a loan company for example which is making a joint loan offer to two people.

The accounts needed are as follows:

| ACCOUNT_ID    | METHODS CALLED  | DESCRIPTION                                                                                         |
| ------------- | --------------- | --------------------------------------------------------------------------------------------------- |
| EXECUTOR      | create          | The entity responsible for controlling the transaction. Could be the bank, or maybe a third party   |
| LENDER        | sign            | The entity giving out the cash, probably a bank                                                     |
| BORROWER_A    | sign            | The first entity who is receiving the cash as a joint loan                                          |
| BORROWER_B    | sign            | The second entity receiving the cash                                                                |
| COUNTER_FRAUD | sign            | The entity responsible for checking that everyone is behaving legitimately                          |
| ALL           | status          | Anyone can see wether the contract is 'effective' or not                                            |

In this example, the contract is "effective" once everyone has signed it. The interesting thing about this contract is that it allows for a very distributed setup. All the systems might be inside a single corporate entity, e.g. the bank, or they could be in completely separate organisations. 

# Installation

You will need to have eris up and running and have followed the first couple of tutorials so you have a chain called "simplechain" running and have created your first contract.

The first thing we are going to do is set up a new chain with the right number of accounts in it.

	eris chains make --account-types=Root:2,Full:5 multisig

This is going to create a chain called `multisig` with 5 full access accounts.

You can now run the script `source ./multisig-env.sh` in this folder which will set up some useful environment variables for you.

There will be 5 accounts, called :

	multisig_root_000, multisig_root_001, multisig_root_002, multisig_root_003, multisig_root_004

We will map these to the accounts above like this:

| multisig_root_000 | EXECUTOR      |
| multisig_root_001 | LENDER        |
| multisig_root_002 | BORROWER_A    |
| multisig_root_003 | BORROWER_B    |
| multisig_root_004 | COUNTER_FRAUD |

Next up we need to instantiate our chain. If you have your simplechain running, stop it first.

    eris chains stop simplechain

	eris chains new --machine=default multisig

You can check its running by doing

	eris chains ls

Or look at its log files:

	eris chains logs multisig -f

You should be able to watch it happily producing blocks at a rate of 1 every three seconds or so depending on your machine. Incidentally the block heigh is given in the source code as being an `int` which on a 64 bit architecture (like a macbook) should give a maximum number of blocks as :

	9223372036854775807 or 9.22E18 (10^18)
                                            
Which means it could last for approximately 97,490,402,892 years (if my maths is correct). To put that in perspective the universe is about 13.79 x 10^9 or 13 billion years, and this is 9.7 x 10^10 so thats about 150 times the life of the universe so far. Big enough?

Also incidentally, eris is using tendermint underneath which has its consensus protocol defined here: http://tendermint.com/docs/tendermint.pdf

https://golang.org/ref/spec#Numeric_types
https://github.com/tendermint/tendermint/blob/master/rpc/core/blocks.go#L34

Ok, now we have a chain running its time to get that contract setup. Might aswell stop the chain for now.


	eris chains stop multisig


The file we want is called `loan.sol` in this directory. You can see if it is valid solitidy, [here](https://ethereum.github.io/browser-solidity/#version=0.3.6).




# References

http://www.shakelaw.com/blog/when-does-a-contract-take-effect/


