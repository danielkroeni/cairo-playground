from starkware.crypto.signature import sign, verify, private_key_to_ec_point_on_stark_curve, pedersen_hash, get_random_private_key
import json

def create_key_pair():
    secret_key = get_random_private_key()
    public_key = private_key_to_ec_point_on_stark_curve(secret_key)[0] # x-Coord
    return (secret_key, public_key)


# 1. Both parties have a personal key pair
(me_sk, me_pk) = create_key_pair()
(gov_sk, gov_pk) = create_key_pair()


# My secret year of birth
me_yob = 1980


# 2. gov: sign(pedersen_hash(me_pk, me_yob))
data = pedersen_hash(me_pk, me_yob)
(sig_r, sig_s) = sign(data, gov_sk)


# 3. me: create cairo input file to generate the proof
cairo_input = {
    "private": {
        "me_yob": me_yob, 
        "gov_sig_r": sig_r, 
        "gov_sig_s": sig_s
    },
    "public": {
        "me_pk": me_pk,
        "gov_pk": gov_pk,
        "current_year": 2021
    } 
}

with open("input.json", "w") as input_file:
    input_file.write(json.dumps(cairo_input, indent=4))
