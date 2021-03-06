#!/bin/bash



zbc_report_zones /dev/sdb | grep Implicit | awk '{ print $2}' | sed 's/://g' > temp-implicit.log

zbc_report_zones /dev/sdb | grep Explicit | awk '{ print $2}' | sed 's/://g' > temp-explicit.log

zbc_report_zones /dev/sdb | grep Full | awk '{ print $2}' | sed 's/://g' > temp-full.log

zbc_report_zones /dev/sdb | grep Closed | awk '{ print $2}' | sed 's/://g' > temp-closed.log

if [ $# -ne 1 ]; then
    echo $0: reset the write pointer for all opened zones
    echo usage: $0 dev
    exit 1
fi

#for i in `seq $2 $3`;
#do
#    echo zbc_reset_write_ptr $1 $i
#    zbc_reset_write_ptr $1 $i > /dev/null
#done

for id in `cat temp-implicit.log temp-explicit.log temp-full.log temp-closed.log`; do
	echo zbc_reset_write_ptr $1 $id
	zbc_reset_write_ptr $1 $id > /dev/null
done

echo reset `cat temp-implicit.log temp-explicit.log temp-full.log temp-closed.log|wc -l ` zones 
echo `wc -l temp-implicit.log` implicit-open zones 
echo `wc -l temp-implicit.log` explicit-open zones 
echo `wc -l temp-full.log` full-open zones 
echo `wc -l temp-closed.log` closed zones 
rm temp-implicit.log
rm temp-explicit.log
rm temp-full.log
rm temp-closed.log
