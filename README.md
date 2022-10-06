# mmcv
Docker and singularity instructions for running mmcv on Artemis HPC


Build the singularity image from the docker repo
```
#!/bin/bash
#PBS -P Training
#PBS -l select=1:ncpus=2:mem=8gb:ngpus=1
#PBS -l walltime=0:30:00

#Change directory to where this file is, presumably /project/<YOURPROJECT>/<subfolder>
cd $PBS_O_WORKDIR

#Load in modules
module load singularity cuda/10.2.89

export SINGULARITY_TMPDIR=`pwd`
export SINGULARITY_CACHEDIR=`pwd`

singularity build mmcv_artemisGPU.img docker://nbutter/mmcv:ubuntu1604
```

Run your workflow
```
#!/bin/bash
#PBS -P Training
#PBS -l select=1:ncpus=1:mem=4gb:ngpus=1
#PBS -l walltime=0:10:00

cd $PBS_O_WORKDIR

module load singularity cuda/10.2.89

singularity run --nv mmcv_artemisGPU.img python -c 'import torch; print(torch.cuda.get_device_name(0))'
singularity run --nv mmcv_artemisGPU.img python check_imports.py
singularity run --nv mmcv_artemisGPU.img python check_installation.py
```
