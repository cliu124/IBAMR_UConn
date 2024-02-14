export FOLDER_NAME=sfw_test ###define the name the folder
mkdir $HOME/$FOLDER_NAME

module load mpich/4.0.2

#Install boost
mkdir $HOME/$FOLDER_NAME/linux
cd $HOME/$FOLDER_NAME/linux
mkdir boost
cd boost
cp $HOME/IBAMR_UConn/boost_1_66_0.tar.gz $HOME/$FOLDER_NAME/linux/boost
tar xvfz boost_1_66_0.tar.gz
mv boost_1_66_0 1.66.0
export BOOST_ROOT=$HOME/$FOLDER_NAME/linux/boost/1.66.0
mkdir $BOOST_ROOT/include
ln -s $BOOST_ROOT/boost $BOOST_ROOT/include

#Install hdf5
cd $HOME/$FOLDER_NAME/linux
mkdir hdf5
cd hdf5
cp $HOME/IBAMR_UConn/hdf5-1.10.6.tar.bz2 $HOME/$FOLDER_NAME/linux/hdf5
tar xvjf path/to/hdf5-1.10.6.gz.bz2
cd hdf5-1.10.6
./configure \
  CC=gcc \
  CXX=g++ \
  FC=gfortran \
  F77=gfortran \
  --enable-build-mode=production \
  --prefix=$HOME/$FOLDER_NAME/linux/hdf5/1.10.6
make -j4
make -j4 check
make -j4 install

#Install silo
cd $HOME/$FOLDER_NAME
mkdir linux
cd linux
cp $HOME/IBAMR_UConn/silo-4.11-bsd.tar.gz $HOME/$FOLDER_NAME/linux
tar xvfz silo-4.11-bsd.tar.gz
cd silo-4.11-bsd
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
 --prefix=$HOME/$FOLDER_NAME/linux/silo/4.11 
make -j4
make -j4 install

#Intall PETSc
cd $HOME/$FOLDER_NAME
mkdir petsc
cd petsc
wget http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-3.17.5.tar.gz
tar xvfz petsc-3.17.5.tar.gz
mv petsc-3.17.5 3.17.5
cd 3.17.5

#Build PETSc debug version
export PETSC_DIR=$PWD
export PETSC_ARCH=linux-debug
./configure \
  --CC=mpicc \
  --CXX=mpicxx \
  --FC=mpif90 \
  --with-debugging=1 \
  --download-hypre=1 \
  --with-x=0
make -j4
make -j4 test

#Build PETSc optimized version
export PETSC_DIR=$PWD
export PETSC_ARCH=linux-opt
./configure \
  --CC=mpicc \
  --CXX=mpicxx \
  --FC=mpif90 \
  --COPTFLAGS="-O3" \
  --CXXOPTFLAGS="-O3" \
  --FOPTFLAGS="-O3" \
  --PETSC_ARCH=$PETSC_ARCH \
  --with-debugging=0 \
  --download-hypre=1 \
  --with-x=0
make -j4
make -j4 test


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
  --with-CC=mpicc \
  --with-CXX=mpicxx \
  --with-F77=mpif90 \
  --with-hdf5=$HOME/$FOLDER_NAME/linux/hdf5/1.10.6 \
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
  --with-CC=mpicc \
  --with-CXX=mpicxx \
  --with-F77=mpif90 \
  --with-hdf5=$HOME/$FOLDER_NAME/linux/hdf5/1.10.6 \
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
cd $HOME/$FOLDER_NAME/linux
mkdir libmesh
cd libmesh
mkdir 1.6.2
cd 1.6.2
wget https://github.com/libMesh/libmesh/releases/download/v1.6.2/libmesh-1.6.2.tar.gz
tar xvfz libmesh-1.6.2.tar.gz
mv libmesh-1.6.2 LIBMESH

#Build a debug version
cd $HOME/$FOLDER_NAME/linux/libmesh/1.6.2
mkdir objs-debug
cd objs-debug
../LIBMESH/configure \
    --prefix=$HOME/$FOLDER_NAME/linux/libmesh/1.6.2/1.6.2-debug \
    --with-methods=dbg \
    CFLAGS="-I$HOME/$FOLDER_NAME/petsc/3.17.5/linux-debug/include" \
    PETSC_DIR=$HOME/$FOLDER_NAME/petsc/3.17.5 \
    PETSC_ARCH=linux-debug \
    CC=mpicc \
    CXX=mpicxx \
    FC=mpif90 \
    F77=mpif90 \
    --enable-exodus \
    --enable-triangle \
    --enable-petsc-required \
    --disable-boost \
    --disable-eigen \
    --disable-hdf5 \
    --disable-openmp \
    --disable-perflog \
    --disable-pthreads \
    --disable-tbb \
    --disable-timestamps \
    --disable-reference-counting \
    --disable-strict-lgpl \
    --disable-glibcxx-debugging \
    --disable-vtk \
    --with-thread-model=none
make -j4
make -j4 install

#Build optimized libmesh
cd $HOME/$FOLDER_NAME/linux/libmesh/1.6.2
mkdir objs-opt
cd objs-opt
../LIBMESH/configure \
    --prefix=$HOME/$FOLDER_NAME/linux/libmesh/1.6.2/1.6.2-opt \
    --with-methods=opt \
    PETSC_DIR=$HOME/$FOLDER_NAME/petsc/3.17.5 \
    PETSC_ARCH=linux-opt \
    CFLAGS="-I$HOME/$FOLDER_NAME/petsc/3.17.5/linux-debug/include" \
    CC=mpicc \
    CXX=mpicxx \
    FC=mpif90 \
    F77=mpif90 \
    --enable-exodus \
    --enable-triangle \
    --enable-petsc-required \
    --disable-boost \
    --disable-eigen \
    --disable-hdf5 \
    --disable-openmp \
    --disable-perflog \
    --disable-pthreads \
    --disable-tbb \
    --disable-timestamps \
    --disable-reference-counting \
    --disable-strict-lgpl \
    --disable-glibcxx-debugging \
    --disable-vtk \
    --with-thread-model=none
make -j4
make -j4 install


#Install IBAMR
cd $HOME/$FOLDER_NAME
mkdir ibamr
cd ibamr
wget https://github.com/IBAMR/IBAMR/archive/v0.13.0.tar.gz
tar xf v0.13.0.tar.gz
mv IBAMR-0.13.0 IBAMR

cd $HOME/$FOLDER_NAME/ibamr
mkdir ibamr-objs-debug
cd ibamr-objs-debug
export BOOST_ROOT=$HOME/$FOLDER_NAME/linux/boost/1.60.0
export PETSC_ARCH=linux-debug
export PETSC_DIR=$HOME/$FOLDER_NAME/petsc/3.17.5
../IBAMR/configure \
  CFLAGS="-g -O1 -Wall" \
  CXXFLAGS="-g -O1 -Wall" \
  FCFLAGS="-g -O1 -Wall" \
  CC=mpicc \
  CXX=mpicxx \
  FC=mpif90 \
  CPPFLAGS="-DOMPI_SKIP_MPICXX" \
  --with-hypre=$PETSC_DIR/$PETSC_ARCH \
  --with-samrai=$HOME/$FOLDER_NAME/samrai/2.4.4/linux-g++-debug \
  --with-hdf5=$HOME/$FOLDER_NAME/linux/hdf5/1.10.6 \
  --with-silo=$HOME/$FOLDER_NAME/linux/silo/4.11 \
  --with-boost=$HOME/$FOLDER_NAME/linux/boost/1.66.0 \
  --enable-libmesh \
  --with-libmesh=$HOME/$FOLDER_NAME/linux/libmesh/1.6.2/1.6.2-debug \
  --with-libmesh-method=dbg
make -j4

#Build IBAMR optimzied version
cd $HOME/$FOLDER_NAME/ibamr
mkdir ibamr-objs-opt
cd ibamr-objs-opt
export PETSC_ARCH=linux-opt
export PETSC_DIR=$HOME/$FOLDER_NAME/petsc/3.17.5
../IBAMR/configure \
  CC=mpicc \
  CXX=mpicxx \
  F77=mpif90 \
  FC=mpif90 \
  MPICC=mpicc \
  MPICXX=mpicxx \
  CFLAGS="-O3 -pipe -Wall" \
  CXXFLAGS="-O3 -pipe -Wall" \
  FCFLAGS="-O3 -pipe -Wall" \
  CPPFLAGS="-DOMPI_SKIP_MPICXX" \
  --with-hypre=$PETSC_DIR/$PETSC_ARCH \
  --with-samrai=$HOME/$FOLDER_NAME/samrai/2.4.4/linux-g++-opt \
  --with-hdf5=$HOME/$FOLDER_NAME/linux/hdf5/1.10.6 \
  --with-silo=$HOME/$FOLDER_NAME/linux/silo/4.11 \
  --with-boost=$HOME/$FOLDER_NAME/linux/boost/1.66.0 \
  --enable-libmesh \
  --with-libmesh=$HOME/$FOLDER_NAME/linux/libmesh/1.6.2/1.6.2-opt \
  --with-libmesh-method=opt
make -j4