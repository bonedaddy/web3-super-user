#! /bin/bash

DATA_DIR=".."
ETH_URL=".."
PY_SUB_PROC=8

cd $HOME/pathfinder
source py/.venv/bin/activate

/bin/pathfinder --data-directory "$DATA_DIR" --python-subprocesses "$PY_SUB_PROC" --ethereum.url "$ETH_URL"
