#!/bin/csh -f 

## usage
# mpirun -np <nprocs> run_gdb.csh -x <cmd_file> <executable>
#
# <nprocs> is the number of processes
# <cmd_file> is a file that has a set of gdb commands, for example
#   set args nodal_oc.xml
#   catch throw
#   run
#
# <executable> is the full path to the executable



echo "Running GDB on node  `hostname`"
xterm -geometry 160x100 -hold -e gdb $* 
#xterm -geometry 160x100 -hold -e gdb -tui $* 
exit 0
