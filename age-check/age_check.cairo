%builtins output pedersen range_check ecdsa
from starkware.cairo.common.cairo_builtins import SignatureBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.hash import pedersen_hash
from starkware.cairo.common.signature import verify_ecdsa_signature
from starkware.cairo.common.math import assert_le
from starkware.cairo.common.serialize import serialize_word

func main(
        output_ptr : felt*, pedersen_ptr : HashBuiltin*, 
        range_check_ptr, ecdsa_ptr : SignatureBuiltin*) -> (
            output_ptr : felt*, pedersen_ptr : HashBuiltin*, 
            range_check_ptr, ecdsa_ptr : SignatureBuiltin*):
    
    alloc_locals
    local me_pk  # my public key
    local gov_pk # the governments public key
    local current_year # the current calendar year (e.g. 2021)

    local me_yob # my secret year of birth
    local gov_sig_r # the governments signature which ...
    local gov_sig_s # ... approves my year of birth

    %{
        # Public input
        ids.me_pk = int(program_input['public']['me_pk'])
        ids.gov_pk = int(program_input['public']['gov_pk'])
        ids.current_year = int(program_input['public']['current_year'])

        # Private input
        # Only me, the prover knows my year of birth
        ids.me_yob = int(program_input['private']['me_yob'])
        # Only me, the prover has the governments signature. But this could be public as well
        ids.gov_sig_r = int(program_input['private']['gov_sig_r'])
        ids.gov_sig_s = int(program_input['private']['gov_sig_s'])
    %}

    # Output the public input for the verifier
    let (output_ptr) = serialize_word(output_ptr, me_pk)
    let (output_ptr) = serialize_word(output_ptr, gov_pk)
    let (output_ptr) = serialize_word(output_ptr, current_year)

    # combines my public key with mit year of birth. That's the same message which was signed by the gov.
    let (pedersen_ptr, msg_hash) = pedersen_hash(pedersen_ptr=pedersen_ptr, x=me_pk, y=me_yob)

    # assert that the government signed the msg_hash and thereby
    # confirmed that the stated year of birth belongs to me (to my public key respectively)
    let (ecdsa_ptr) = verify_ecdsa_signature(ecdsa_ptr, msg_hash, gov_pk, gov_sig_r, gov_sig_s)

    # assert that my stated year of birth means that i am least 18 years old
    let (range_check_ptr) = assert_le(range_check_ptr, 18, current_year - me_yob)

    return (
        output_ptr=output_ptr, 
        pedersen_ptr=pedersen_ptr, 
        range_check_ptr=range_check_ptr, 
        ecdsa_ptr=ecdsa_ptr)
end
