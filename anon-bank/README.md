# Anonymous Bank

This folder contains a little bank which processes secret transactions on secret states.
The secret state consists of public keys mapped to their corresponding balances. Here we use a simple immutable [tree map](./treemap.cairo) for the mapping.

## How it works

* Public inputs:
  * Hash of the state before the transactions are executed
  * List of the transaction hashes
* Secret inputs:
  * The state: List of (public key -> balance) mappings
  * List of transactions

__The program verifies:__
* that the secret state has the given hash
* that each secret transaction has the corresponding hash
* that each transaction is correctly signed

Then the program applies all transactions and generates a new state.
This state is written to a json output (to be used by the next transaction batch run)

__Output to the verifier:__
* The public inputs:
  * the hash of the state before the transactions
  * the list of hashes of the processed transactions
* the hash of the state after processing the transactions

## What we gain:
A verifier can prove, that his transactions are correctly executed without revealing any information like:
* The balances of each account
* The sender and receiver of the transactions
* The transferred amounts

## How to run
Run the `example.py` to generate a an `input.json` which contains an initial state and some transactions. 
```
> python3 example.py
```
Then compile and run `bank.cairo`:

```
> cairo-compile bank.cairo --output bank_compiled.json && cairo-run --program=bank_compiled.json --print_output --layout=small --program_input=input.json
```

TODO:
* How can a verifier be sure that a state (with the hash he trusts) is available? Maybe this is the infamous state availability problem ;)
* Prevent replay attacks
  * Add a nonce to the transaction
  * Last nonce needs to be included in the state which would be become pairs of (public-key -> (nonce, amount))
  * Verify that the nonce of a transaction is greater than the corresponding nonce of the sender and update its nonce in its state mapping
* Allow transfers to yet unknown public keys
* We used a simple immutable tree map. Try a merkle tree:
https://github.com/starkware-libs/starkex-resources-wip/blob/24bb519dca808591e1c069ff9d46bdcb370b3fd1/storage/starkware/storage/merkle_tree/merkle_tree.py
