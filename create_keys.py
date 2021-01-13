from starkware.crypto.signature import get_random_private_key, private_key_to_ec_point_on_stark_curve
import json

def create_key_pair(owner):
    dk_sk = get_random_private_key()
    dk_pk = private_key_to_ec_point_on_stark_curve(dk_sk)[0] #x-Coord

    with open(owner+".sk", "w") as sk_file:
        sk_file.write(str(dk_sk))

    with open(owner+".pk", "w") as pk_file:
        pk_file.write(str(dk_pk))

create_key_pair("me")
create_key_pair("gov")