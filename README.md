# cairo-playground

## Experiments with cairo

This repository contains a program which can generate a proof, that I am at least 18 years old, without revealing my actual year of birth to the verifier. It works as follows:
The government's administration approves, that the year of birth (1980) corresponds to my public key by signing `pedersen_hash(my_public_key, my_year_of_birth)`. 
By compiling and running [zkcheck.cairo](./zkcheck.cairo) it can be verified, that the government's signature is valid for the `pedersen_hash(my_public_key, my_year_of_birth)` and rangecheck that I am at least 18 years old: `18 <= 2021 - my_year_of_birth`.


1. setup cairo https://www.cairo-lang.org/docs/quickstart.html
2. Install the starkex crypto package 
```
> source /Users/dk/cairo_venv/bin/activate
> git clone https://github.com/starkware-libs/starkex-resources.git  
> cd starkex-resources/crypto
> python setup.py build 
> python setup.py install
```
3. Run [example.py](./example.py), which 
   1. generates keys for the government and me
   2. simulates the government signing my personal data
   3. simulates me preparing the [input.json](./input.json) for cairo
4. Compile and run `zkcheck.cairo` on the prepared `input.json`.
```
> cairo-compile zkcheck.cairo --output zkcheck_compiled.json
> cairo-run --program=zkcheck_compiled.json --print_output --layout=small --program_input=input.json
```
5. TODO: let the execution generate a trace (--trace_file=zkcheck.json) and find a way to verify the trace.