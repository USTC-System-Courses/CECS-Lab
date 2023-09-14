
rm -rf ./sim.cpp ./difftest.cpp ./mycpu ./picotest ./functest 

ln -s ../simulator/sim/difftest/difftest.cpp difftest.cpp
ln -s ../simulator/sim/sim.cpp sim.cpp
ln -s ../simulator/IP/mycpu mycpu
ln -s ../software/picotest picotest
ln -s ../software/functest functest

cd ../simulator/IP
git clone git@github.com:USTC-System-Courses/CECS-pipeline-BRAM.git pipeline-BRAM
