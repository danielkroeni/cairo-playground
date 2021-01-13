from starkware.crypto.signature import sign, verify, private_key_to_ec_point_on_stark_curve, pedersen_hash
import json

def read_sk(owner):
     return read_as_int(owner+".sk")

def read_pk(owner):
    return read_as_int(owner+".pk")

def read_as_int(filename):
    with open(filename, "r") as file:
        return int(file.read())


me_yob = 1980
print("me_pk: ", read_pk("me"))
print("gov_pk: ", read_pk("gov"))

# 1. gov: sign(pedersen_hash(me_pk, me_yob))
data = pedersen_hash(read_pk("me"), me_yob)
(sig_r, sig_s) = sign(data, read_sk("gov"))

# 2. create input file with private input
cairo_input = {"me_yob":me_yob, "gov_sig_r":sig_r, "gov_sig_s":sig_s}
with open("input.json", "w") as input_file:
    input_file.write(json.dumps(cairo_input, indent=4))
