#!/bin/bash
#PBS -A nn9573k
#PBS -l walltime=49:10:60
#PBS -l select=4:ncpus=32:mpiprocs=16
 

module purge
module load intelcomp/17.0.0
module load mpt/2.14
module load gromacs/2016.1

case=$PBS_JOBNAME
cd $PBS_O_WORKDIR

 rm V_0*
 rm  LL_* NVT_vis*  J_RU*  E_RU*    Dens* density*  nvt.*  Fit* VIS*  table*   Vis*    tcaf*  Dens*  err* *table* *.dat* *.txt* *rdf* 
 rm  *#*  *pressure* box.txt 
 rm Mtot*  epsilon*   dipdist.xvg  fit.*
 rm *visc_k* t.dat p.dat  MM_* SS_* visc*
 rm *step*       *.sh.*    *#*
 rm -r FINISHED
 rm -r FINISHED-RDF

cp ../IMPUT/NVT_F.mdp NVT_F.mdp
cp ../IMPUT/NVT_vis.mdp NVT_vis.mdp
############PRESSURE#########################################################

sed "s/ dt                        =/ dt                        = 0.002;/" NVT_F.mdp -i
sed "s/ nsteps                    =/ nsteps                    = 100000000;/" NVT_F.mdp -i
sed "s/ E-x                       =/ E-x                       = 1  1.055   0;/" NVT_F.mdp -i


 gmx grompp -f NVT_F.mdp -c NVT.gro -p topol.top -o NVT_F.tpr   -maxwarn 3 
 mpiexec_mpt  mdrun   -s  NVT_F.tpr    -deffnm NVT_F   -table Table_HS_modif.xvg



sed "s/ nsteps                    =/ nsteps                    =80000000;/" NVT_vis.mdp -i
sed "s/ nstxout                   =/ nstxout                   =500;/" NVT_vis.mdp -i
sed "s/ nstvout                   =/ nstvout                   =500;/" NVT_vis.mdp -i



 gmx grompp  -f  NVT_vis.mdp   -c   NVT_F.gro   -p  topol.top  -o   NVT_vis.tpr   -maxwarn 3 -t  NVT_F.cpt
 mpiexec_mpt  mdrun   -s  NVT_vis.tpr    -deffnm NVT_vis   -table Table_HS_modif.xvg

echo 0 | gmx tcaf  -f NVT_vis.trr -s NVT_vis.tpr -normalize -b 10000  -ov  LL_4000.xvg
echo 0 | gmx tcaf  -f NVT_vis.trr -s NVT_vis.tpr -normalize -b 20000  -ov  LL_8000.xvg
echo 0 | gmx tcaf  -f NVT_vis.trr -s NVT_vis.tpr -normalize -b 30000  -ov  LL_12000.xvg
echo 0 | gmx tcaf  -f NVT_vis.trr -s NVT_vis.tpr -normalize -b 40000  -ov  LL_16000.xvg

rm *#*
rm NVT_vis.t*
rm NVT_vis.x*
rm NVT_vis.cpt
rm tcaf*


