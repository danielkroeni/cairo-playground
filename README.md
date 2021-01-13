# cairo-playground

## Experiments with cairo

This repository contains a program which can generate a proof, that I am at least 18 years old, without revealing my actual year of birth to the verifier. It works as follows:
The government's administration approves, that the year of birth (1980) corresponds to my public key by signing `pedersen_hash(my_public_key, my_year_of_birth)`. 
By compiling and running [zkcheck.cairo](./zkcheck.cairo) it can be verified, that the government's signature is valid for the `pedersen_hash(my_public_key, my_year_of_birth)` and rangecheck that the current year (2021) minus my year of birth is >= 18.


1. setup cairo https://www.cairo-lang.org/docs/quickstart.html
2. Install the starkex crypto package 
```
> source /Users/dk/cairo_venv/bin/activate
> git clone https://github.com/starkware-libs/starkex-resources.git  
> cd starkex-resources/crypto
> python setup.py build 
> python setup.py install
```

3. Create key pairs for me and the government:
```
> python create_keys.py
```
4. Let the government sign my personal data. This generates `input.json`.
```
> python sign.py
```
1. Compile and run `zkcheck.cairo`. Make sure that the generated public keys match the keys in `zkcheck.cairo`.
```
> cairo-compile zkcheck.cairo --output zkcheck_compiled.json
> cairo-run --program=zkcheck_compiled.json --print_output --layout=small --program_input=input.json
```
6. TODO: let the run generate a trace (--trace_file=zkcheck.json) and find a way to verify the trace :)