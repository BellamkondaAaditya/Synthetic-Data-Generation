#!/bin/bash
#
#SBATCH --job-name=jupyter
#SBATCH --partition=eagle
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
#SBATCH --gres=gpu:1
#SBATCH --mem=60000
#SBATCH --time=12:00:00
#SBATCH --output=jupyter.log
#SBATCH --error=jupyter.err
#SBATCH --mail-type=BEGIN

source /etc/profile.d/modules.sh
module load CUDA
module load Python/3.11.0

# Clean start
rm -rf myenv311

# Create virtual environment
python3.11 -m venv myenv311
source myenv311/bin/activate

# **CRITICAL FIX**: Unset PIP_USER to prevent --user flag conflicts
unset PIP_USER
export PIP_USER=false

# Verify environment
echo "Active Python: $(which python)"
echo "Python version: $(python --version)"
echo "Pip location: $(which pip)"

# Install packages (should work now)
echo "Installing pip..."
pip install --upgrade pip

echo "Installing jupyter..."
pip install jupyter

echo "Installing ipykernel..."
pip install ipykernel

# Verify installations worked
echo "Verifying installations..."
which jupyter
python -c "import ipykernel; print('ipykernel successfully imported')"

# Register kernel
python -m ipykernel install --name myenv311 --display-name "Python 3.11"

# Start jupyter
jupyter notebook --ip=0.0.0.0 --port=11888 --no-browser
