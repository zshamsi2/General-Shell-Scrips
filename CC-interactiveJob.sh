# interactive job on campuscluster 
qsub -q cse -I -l walltime=00:30:00,nodes=1:ppn=12 mkCluster.py 
# size of directory
du -hcs ANC-S1/MSM/
