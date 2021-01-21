# cairo-playground

This repository contains some experiments with [Cairo](https://www.cairo-lang.org/).

- [age-check](./age-check/README.md) proves you are at least 18, without revealing your age. 
- [anon-bank](./anon-bank/README.md) implements a bank which processes bank transfer transactions without revealing the involved parties and their balances. 
  - [treemap](./bank/treemap.cairo) implements a simple immutable tree map. 


## Required Setup:
1. Setup cairo https://www.cairo-lang.org/docs/quickstart.html
2. Install the starkex crypto package:
```
> source /Users/dk/cairo_venv/bin/activate
> git clone https://github.com/starkware-libs/starkex-resources.git  
> cd starkex-resources/crypto
> python setup.py build 
> python setup.py install
```