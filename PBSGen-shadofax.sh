# Generating multiple PBS files for sumission on Shadowfax using shell script

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
#nes starting with #$ will be taken as qsub arguments
#$ -S /bin/bash    # Set shell to run job
#$ -q all.q        # Choose queue to run job in
#$ -pe orte 12     # Request one processor from the OpenMPI parallel env.
#$ -o ${line}.log
###$ -cwd            # Run job from my current working directory
###$ -M 		   # set my email address
###$ -m              # Mail at beginning and end of job

module load cuda
nvidia-smi

export PATH="/home/amoffet2/amber14/bin:$PATH"
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64
export CUDA_HOME=/usr/local/cuda
export CUDA_VISIBLE_DEVICES=0

cd /home/balajis/${line}
mpirun -np 1 pmemd.cuda.MPI -O -i amd.in -o ${line}.out -p phos-NRTapo.prmtop -c phos-${line}-aMD43-new.rst -r ${line}.rst -ref phos-${line}-aMD43-new.rst -x traj_${line}.mdcrd
EOF
#        qsub PBS_${line}
done<strList
