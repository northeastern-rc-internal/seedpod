#!/bin/bash
### every exit != 0 fails the script
set -e

## print out help
help (){
echo "
USAGE: /opt/start.sh NOTEBOOK_DIR:/path/to/notebook 
CONFIG:"${CONFIG_FILE}" EXTRA_JUPYTER_ARGS:"${EXTRA_JUPYTER_ARGS}" 
CONDA_PATH:/path/to/conda/bin
NOTEBOOK_DIR path to the notebook/project directories.
CONFIG Jupyter cofig file. 
EXTRA_JUPYTER_ARGS only needed when you need extra arguments to be passed.
CONDA_PATH path to the conda env.
"
}

if [[ $1 =~ -h|--help ]]; then
    help
    exit 0
fi

NOTEBOOK_DIR=
CONFIG=
EXTRA_JUPYTER_ARGS=
CONDA_PATH=
for i in $*;do
    str1=`echo $i | cut -d':' -f1`
    str2=`echo $i | cut -d':' -f2`
    if [ $str1 == 'NOTEBOOK_DIR' ];then
        NOTEBOOK_DIR=$str2
    elif [ $str1 == 'CONFIG' ];then
        CONFIG=$str2
    elif [ $str1 == 'EXTRA_JUPYTER_ARGS' ];then
        EXTRA_JUPYTER_ARGS=$str2
    elif [ $str1 == 'CONDA_PATH' ];then
        CONDA_PATH=$str2
    fi
done
echo "NOTEBOOK_DIR:$NOTEBOOK_DIR "
echo "CONFIG:$CONFIG "
echo "EXTRA_JUPYTER_ARGS:$EXTRA_JUPYTER_ARGS "
echo "CONDA_PATH:$CONDA_PATH "

source activate $CONDA_PATH
jupyter lab --notebook-dir=$NOTEBOOK_DIR --debug --config=$CONFIG $EXTRA_JUPYTER_ARGS