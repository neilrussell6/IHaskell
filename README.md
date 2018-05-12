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

The ``notebooks`` directory is ignored, which allows you to store your actual notebook files in a separate Git repo.
To add your notebooks simply clone them into the ``notebooks`` directory eg.
```bash
git clone https://github.com/YOUR_GIT_USERNAME/YOUR_NOTEBOOKS_REPO notebooks
``` 

Once you have a ``notebooks`` directory, or have cloned your notebooks repo into the ``notebooks`` directory,
you can run Jupyter with:
 
```bash
make serve
```

This will serve the notebooks in your browser, allowing you to create, edit and delete your notebooks locally.
