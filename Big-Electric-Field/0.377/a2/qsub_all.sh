#!/bin/bash
#!/usr/local/bin/gnuplot -persist

#array=(7 8 9 10 11 12 13 14 15 16 17 18 19 20     )


array=(14 15 16 17 18 19 20     )
for j in "${array[@]}"
do

cd V$j
cp ../V7/V_Field.sh V_Field.sh
qsub V_Field.sh


cd ..
done


