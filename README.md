Python & Haskell notebooks
===

This repo allows you to create both Python3 and Haskell notebooks with Jupyter.

It's forked from [gibiansky/IHaskell](https://github.com/gibiansky/IHaskell), check that out for more in depth info about the Haskell kernel for Jupyter.

2 step setup
---

##### 1. create a virtual env

```bash
sudo apt-get install -y python3-venv
python3 -m venv venv
source venv/bin/activate
```

##### 2. initialize the project

```bash
make init
```
This will create a local .env and setup pip and install dependencies.

usage
---

Use the various ``make serve`` commands to run jupyter.
These will serve the notebooks on your browser, allowing you to create, edit and delete your notebooks locally.

```bash
make serve
```
serve your notebooks

```bash
make servelc
```
serve your local (git ignored) notebooks. 

```bash
make serverf
```
serve the default (reference) notebooks that come with [gibiansky/IHaskell](https://github.com/gibiansky/IHaskell).
