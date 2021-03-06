# Generating multiple PBS files for sumission on Blue Waters using shell script

#Input file name (.in)
iName=MD
r=1 #Sampling round
a=2 #input index
b=3 #output index
Path=/u/sciteam/shamsi/Tale

# .in file address
iPath=${Path}
# .top file address
pPath=${Path}/MD${r}/top
# .crd or .rst file address for input
cPath=${Path}/MD${r}/MD${r}-${a}
# .rst (restart) file address output
rPath=${Path}/MD${r}/MD${r}-${b}
# .out file address
oPath=${Path}/MD${r}/MD${r}-${b}
# General path
path=${Path}/MD${r}/MD${r}-${b}

mkdir ${path}
mkdir ${path}/PBS
cd ${path}/PBS
cp ${Path}/MD${r}/MD${r}-${a}/PBS/strList .
while  read line
do
        cat >  PBS_${line} << EOF
#PBS -l nodes=1:ppn=1:xk
#PBS -l walltime=23:30:00
#PBS -N ${line}
#PBS -e ${line}.err 
#PBS -o ${line}.out
#PBS -q low 
#PBS -A jt3
cd ${path}

export AMBERHOME=/projects/sciteam/jt3/amber14cuda
export PATH=/projects/sciteam/jt3/amber14cuda/bin/:$PATH
export CUDA_HOME=/opt/nvidia/cudatoolkit6.5/6.5.14-1.0502.9613.6.1
export LD_LIBRARY_PATH=/opt/nvidia/cudatoolkit6.5/6.5.14-1.0502.9613.6.1/lib:/opt/nvidia/cudatoolkit6.5/6.5.14-1.0502.9613.6.1/lib64:$LD_LIBRARY_PATH

mkdir ${oPath}/${line}
aprun -n 1 -N 1 pmemd.cuda -O -i ${iPath}/${iName}.in -o ${oPath}/${line}/${line}.out -p ${pPath}/${line}.top -c ${cPath}/${line}/${line}_md${r}-${a}.rst -r ${rPath}/${line}/${line}_md${r}-${b}.rst -x ${rPath}/${line}/${line}_md${r}-${b}.mdcrd
EOF
#        qsub PBS_${line}
done<strList
