
rm -rf ./mycpu ./script ./paddr.cpp ./sim.cpp


ln -s ../simulator/IP/mycpu mycpu
ln -s ../simulator/script script
ln -s ../simulator/sim/memory/paddr.cpp paddr.cpp
ln -s ../simulator/sim/sim.cpp sim.cpp

cd ../simulator/IP

git clone https://github.com/USTC-System-Courses/CECS-pipeline-AXI.git pipeline-AXI
