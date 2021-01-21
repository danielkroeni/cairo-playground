from starkware.crypto.signature import sign, verify, private_key_to_ec_point_on_stark_curve, pedersen_hash, get_random_private_key
from starkware.cairo.common.hash_chain import compute_hash_chain

from functools import reduce

import json

def create_key_pair():
    secret_key = get_random_private_key()
    public_key = private_key_to_ec_point_on_stark_curve(secret_key)[0] # x-Coord
    return (secret_key, public_key)


# 1. 3 parties have a personal key pair
(a_sk, a_pk) = create_key_pair()
(b_sk, b_pk) = create_key_pair()
(c_sk, c_pk) = create_key_pair()

# 2. This is the initial state.
# The entries are sorted by the key to compute the same hash as in cairo.
pre_state = sorted([
    {"owner": a_pk, "balance": 100},
    {"owner": b_pk, "balance": 100},
    {"owner": c_pk, "balance": 100},
], key=lambda entry: entry["owner"])


# 3. compute H(pre_state)
# TODO Dict: ADD SIZE (check https://github.com/starkware-libs/cairo-lang/blob/master/src/starkware/cairo/common/hash_chain.cairos) 
pre_state_hash = compute_hash_chain(list(map(lambda kv: pedersen_hash(kv["owner"], kv["balance"]), pre_state)))


# 4. Create demo transactions
def create_tx(from_sk, to_pk, amount):
    from_pk = private_key_to_ec_point_on_stark_curve(from_sk)[0]
    data = pedersen_hash(pedersen_hash(from_pk, to_pk), amount)
    (sig_r, sig_s) = sign(data, from_sk)
    return {
        "from_pk": from_pk,
        "to_pk": to_pk, 
        "amount": amount,
        "sig_r": sig_r,
        "sig_s": sig_s
    }

transactions = [
    create_tx(a_sk, b_pk, 5),
    create_tx(b_sk, c_pk, 3),
    create_tx(c_sk, a_pk, 2),
]


# 5. Compute transaction hashes
def hash_tx(tx):
    return pedersen_hash(pedersen_hash(pedersen_hash(pedersen_hash(tx["from_pk"], tx["to_pk"]), tx["amount"]), tx["sig_r"]), tx["sig_s"])

transaction_hashes = list(map(hash_tx, transactions))



# 6. Create cairo input file
cairo_input = {
    "private": {
        "pre_state": pre_state, 
        "transactions": transactions
    },
    "public": {
        "pre_state_hash": pre_state_hash,
        "transaction_hashes": transaction_hashes,
    } 
}

with open("input.json", "w") as input_file:
    input_file.write(json.dumps(cairo_input, indent=4))


# 7. Run the cairo program
