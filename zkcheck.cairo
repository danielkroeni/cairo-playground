%builtins pedersen range_check ecdsa
from starkware.cairo.common.cairo_builtins import SignatureBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.hash import pedersen_hash
from starkware.cairo.common.signature import verify_ecdsa_signature
from starkware.cairo.common.math import assert_le

func main(pedersen_ptr : HashBuiltin*, range_check_ptr, ecdsa_ptr : SignatureBuiltin*) -> (
        pedersen_ptr : HashBuiltin*, range_check_ptr, ecdsa_ptr : SignatureBuiltin*):
    alloc_locals
    # my public key
    local me_pk = 3548302120635852395180622152293990753958527744231886351573097789141808091382 
    local me_yob # my secret year of birth

    local gov_sig_r # the governments signature which ...
    local gov_sig_s # ... approves my year of birth

    # the governments public key
    local gov_pk = 1756521555287228181077406164095219988860720267395919529823641723512696443533 

    %{
        # Private input
        # Only me, the prover knows my year of birth
        ids.me_yob = int(program_input['me_yob'])
        # Only me, the prover has the governments signature. But this could be public as well
        ids.gov_sig_r = int(program_input['gov_sig_r'])
        ids.gov_sig_s = int(program_input['gov_sig_s'])
    %}

    # combines my public key with mit year of birth. That's the same message which was signed by the gov.
    let (pedersen_ptr, msg_hash) = pedersen_hash(pedersen_ptr=pedersen_ptr, x=me_pk, y=me_yob)

    # assert that the government signed the msg_hash and thereby
    # confirmed that the stated year of birth belongs to me (to my public key respectively)
    let (ecdsa_ptr) = verify_ecdsa_signature(ecdsa_ptr, msg_hash, gov_pk, gov_sig_r, gov_sig_s)

    # assert that my stated year of birth means that i am least 18 years old
    let (range_check_ptr) = assert_le(range_check_ptr, 18, 2021 - me_yob)

    return (pedersen_ptr=pedersen_ptr, range_check_ptr=range_check_ptr, ecdsa_ptr=ecdsa_ptr)
end
