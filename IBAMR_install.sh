export FOLDER_NAME=sfw_test ###define the name the folder

module load boost/1.77.0 # load boost

module load hdf5/1.21.1 # load hdf5

#Install silo
cd $HOME/$FOLDER_NAME
mkdir linux
wget https://github.com/LLNL/Silo/releases/tag/v4.11/silo-4.11-bsd.tar.gz
tar xvfz path/to/silo-4.11-bsd.tar.gz
cd silo-4.11.bsd
./configure \
  CC=gcc \
  CXX=g++ \
  FC=gfortran \
  F77=gfortran \
  --enable-optimization \
  --enable-shared=yes \
  --enable-browser=no \
  --with-hdf5=no \
  --with-sz=no \
  --prefix=$HOME/sfw/linux/silo/4.11 
make -j4
make -j4 install

module load hypre/2.25.0 #load hypre
module load petsc/3.20.0 #load petsc

# Install samrai
cd $HOME/$FOLDER_NAME
mkdir samrai
cd samrai
mkdir 2.4.4
cd 2.4.4
wget https://github.com/LLNL/SAMRAI/archive/refs/tags/2.4.4.tar.gz
tar xf 2.4.4.tar.gz
cd SAMRAI-2.4.4
wget https://github.com/IBAMR/IBAMR/releases/download/v0.13.0/samrai-2.4.4-patch-ibamr-0.13.0.patch
patch -p1 < samrai-2.4.4-patch-ibamr-0.13.0.patch

# configure and compile an debug version of samrai
cd $HOME/$FOLDER_NAME/samrai/2.4.4
mkdir objs-debug
cd objs-debug

../SAMRAI-2.4.4/configure \
  CFLAGS="-fPIC" \
  CXXFLAGS="-fPIC" \
  FFLAGS="-fPIC" \
  --prefix=$HOME/$FOLDER_NAME/samrai/2.4.4/linux-g++-debug \
  --with-CC=/cm/shared/modulefiles/mpich/4.0.2/mpicc \
  --with-CXX=/cm/shared/modulefiles/mpich/4.0.2/mpicxx \
  --with-F77=/cm/shared/modulefiles/mpich/4.0.2/mpif90 \
  --with-hdf5=/cm/shared/modulefiles/hdf5/1.12.1 \
  --without-petsc \
  --without-hypre \
  --with-silo=$HOME/$FOLDER_NAME/linux/silo/4.11 \
  --without-blaslapack \
  --without-cubes \
  --without-eleven \
  --without-kinsol \
  --without-petsc \
  --without-sundials \
  --without-x \
  --with-doxygen \
  --with-dot \
  --enable-debug \
  --disable-opt \
  --enable-implicit-template-instantiation \
  --disable-deprecated
make -j4
make -j4 install

#install optimized build of SAMRAI
cd $HOME/$FOLDER_NAME/samrai/2.4.4
mkdir objs-opt
cd objs-opt

../SAMRAI-2.4.4/configure \
  CFLAGS="-O3 -fPIC" \
  CXXFLAGS="-O3 -fPIC" \
  FFLAGS="-O3 -fPIC" \
  --prefix=$HOME/$FOLDER_NAME/samrai/2.4.4/linux-g++-opt \
  --with-CC=/cm/shared/modulefiles/mpich/4.0.2/mpicc \
  --with-CXX=/cm/shared/modulefiles/mpich/4.0.2/mpicxx \
  --with-F77=/cm/shared/modulefiles/mpich/4.0.2/mpif90 \
  --with-hdf5=/cm/shared/modulefiles/hdf5/1.12.1 \
  --without-hypre \
  --with-silo=$HOME/$FOLDER_NAME/linux/silo/4.11 \
  --without-blaslapack \
  --without-cubes \
  --without-eleven \
  --without-kinsol \
  --without-petsc \
  --without-sundials \
  --without-x \
  --with-doxygen \
  --with-dot \
  --disable-debug \
  --enable-opt \
  --enable-implicit-template-instantiation \
  --disable-deprecated
make -j4
make -j4 install

#Install libMesh to be finished


#Install IBAMR
cd $HOME/$FOLDER_NAME
mkdir ibamr
cd ibamr
wget https://github.com/IBAMR/IBAMR/archive/v0.13.0.tar.gz
tar xf v0.13.0.tar.gz
mv IBAMR-0.13.0 IBAMR

cd $HOME/$FOLDER_NAME/ibamr
mkdir ibamr-objs-dbg
cd ibamr-objs-dbg
export BOOST_ROOT=$HOME/sfw/linux/boost/1.60.0
export PETSC_ARCH=linux-debug
export PETSC_DIR=$HOME/sfw/petsc/3.17.5
../IBAMR/configure \
  CFLAGS="-g -O1 -Wall" \
  CXXFLAGS="-g -O1 -Wall" \
  FCFLAGS="-g -O1 -Wall" \
  CC=$HOME/sfw/linux/openmpi/4.0.2/bin/mpicc \
  CXX=$HOME/sfw/linux/openmpi/4.0.2/bin/mpicxx \
  FC=$HOME/sfw/linux/openmpi/4.0.2/bin/mpif90 \
  CPPFLAGS="-DOMPI_SKIP_MPICXX" \
  --with-hypre=$PETSC_DIR/$PETSC_ARCH \
  --with-samrai=$HOME/sfw/samrai/2.4.4/linux-g++-debug \
  --with-hdf5=$HOME/sfw/linux/hdf5/1.10.6 \
  --with-silo=$HOME/sfw/linux/silo/4.11 \
  --with-boost=$HOME/sfw/linux/boost/1.60.0 \
  --enable-libmesh \
  --with-libmesh=$HOME/sfw/linux/libmesh/1.6.2/1.6.2-debug \
  --with-libmesh-method=dbg
make -j4