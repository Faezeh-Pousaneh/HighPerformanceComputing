#!/bin/bash 
#!/usr/local/bin/gnuplot -persist

array=(7 8 9 10 11 12 13 14 15 16 17 18 19 20     )
for j in "${array[@]}"
do

rm *#*
cd V$j

rm *fit*
rm Fit_VIS_err.*
touch Fit_VIS_err.txt

for (( i=4000; i<17000; i += 4000 ))

do

gnuplot <<- EOF
reset
vai(k,a0,a1,a2)=a0*(1-a1*k*k)+a2*k*k*k*k

set xlabel "{k}^*"
set ylabel "{/Symbol h}^*"
set key top left Left reverse
set terminal postscript color enhanced
set fit errorvariables
set print "Fit_VIS_err.txt" append
set print  "_err" appended
fit [0.001:5] vai(x,a0,a1,a2) "LL_${i}.xvg" u 1:2 via a0,a1,a2
print "", a0_err\


unset table
set output
EOF
done 
rm *#*
cd ..
done




########################
# compile summary
#touch summary_distances.dat
#for (( i=1; i<10; i++ ))
#do
 #   d=`tail -n 1 dist${i}.xvg | awk '{print $2}'`
  #  echo "${i} ${d}" >> summary_distances.dat
   # rm dist${i}.xvg
#done

