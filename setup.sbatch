#!/bin/bash
#
#SBATCH --job-name=jupyter        # Job name for tracking
#SBATCH --partition=gecko        # Use falcon partition
#SBATCH --ntasks=1                # Single task
#SBATCH --cpus-per-task=48        # Number of CPU threads (max available)
#SBATCH --gres=gpu:1              # Request 1 GPU (Nvidia A5000)
#SBATCH --mem=240000               # 240GB RAM
#SBATCH --time=24:00:00           # Job time limit set to 12 hours
#
#SBATCH --output=jupyter.log
#SBATCH --error=jupyter.err
#SBATCH --mail-type=BEGIN # Get email when your allocation starts

source /etc/profile.d/modules.sh
module load CUDA
module load Python/3.12.0

python3.12 -m venv myenv
source myenv/bin/activate 
python3.12 -m ipykernel install --no-user --name=myenv --display-name "myenv"
jupyter notebook --ip=0.0.0.0 --port=11888 --no-browser