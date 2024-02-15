# IBAMR installation script on UConn cluster.
# This only use the module mpich/4.0.2 that is available on UConn cluster and everything else is installed on the local home folder
git clone https://github.com/cliu124/IBAMR_UConn.git
cd IBAMR_UConn

#change the second line into a foldername you like
#export FOLDER_NAME=sfw

sh IBAMR_install.sh

#Then go to the corresonding folder
cd $HOME/

sbatch submit_IBAMR_uconn #This will submit the running job to computing node
 
