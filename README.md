# IBAMR installation script on UConn cluster.
#This only use the module mpich/4.0.2 that is available on UConn cluster and everything else is installed on the local home folder
git clone https://github.com/cliu124/IBAMR_UConn.git

cd IBAMR_UConn

#change the second line into a foldername you like

#for example, export FOLDER_NAME=sfw

sh IBAMR_install.sh

#Then go to the corresonding folder

cd $HOME/$FOLDER_NAME/ibamr/ibamr-objs-opt

#Then modify the CODEDIR into the specific example you want to run

#Then the command below will submit the running job to computing node

sbatch submit_IBAMR_uconn 