## Age Check

This example program can generate a proof, that I am at least 18 years old, without revealing my actual year of birth to the verifier. It works as follows:
The government's administration approves, that the year of birth (1980) corresponds to my public key by signing `pedersen_hash(my_public_key, my_year_of_birth)`. 
By compiling and running [age_check.cairo](./age_check.cairo) it can be verified, that the government's signature is valid for the `pedersen_hash(my_public_key, my_year_of_birth)` and rangecheck that I am at least 18 years old: `18 <= 2021 - my_year_of_birth`.

1. Run [example.py](./example.py), which 
   1. generates keys for the government and me
   2. simulates the government signing my personal data
   3. simulates me preparing the [input.json](./input.json) for cairo
2. Compile and run `age_check.cairo` on the prepared `input.json`.
```
> cairo-compile age_check.cairo --output age_check_compiled.json
> cairo-run --program=age_check_compiled.json --print_output --layout=small --program_input=input.json
```
3. TODO: let the execution generate a trace (--trace_file=age_check.json) and find a way to verify the trace.