Manually Submit (_Using Better Build System_)
=============================================

This is a [forked](http://en.wikipedia.org/wiki/Fork_(software_development)
version of [Joshua Smith](mailto:smjoshua@umich.edu)'s original `synth.sh` and
`pbs.sh` setup. It has been updated to utilize the new-er
[scratch space](http://cac.engin.umich.edu/resources/storage/flux-high-performance-storage-scratch)
that didn't exist (or he wasn't using?) in 2010.

## `scripts/synth.sh`
```bash
#!/bin/bash -l
# Created Fall 2010 by: Joshua Smith <smjoshua@umich.edu>
# Updated Winter 2014 by: Kyle Smith <kylebs@umich.edu>

SCRIPTS_DIR="$(pwd -P)"
pushd ../

PROJ_DIR="$(pwd -P)"
EECS470_LIBS_DIR="/afs/umich.edu/class/eecs470/lib"

################################################################################
## PBS Script Parameters                                                      ##
## Full reference available at:                                               ##
## http://cac.engin.umich.edu/resources/software/pbs                          ##
################################################################################
PBS_SHELL=/bin/sh
PBS_JOB_NAME="470-synth"
PBS_ACCOUNT="brehob_flux"
PBS_JOB_ATTRS="qos=flux,nodes=1:ppn=12,mem=47gb,pmem=4000mb,walltime=10:00:00"
PBS_QUEUE="flux"
PBS_EMAIL_ADDR="kylebs@umich.edu"
PBS_EMAIL_OPTS="abe"
PBS_FLAGS="-V"
PBS_FILE="${SCRIPTS_DIR}/pbs.sh"


################################################################################
## Copy EECS 470 Synopsys Libs Locally From: ${EECS470_LIBS_DIR}              ##
################################################################################
# Scratch space ftw
LOCAL_EECS470_DIR="${HOME}/eecs470-lib"
SCRATCH_DIR="/scratch/${PBS_ACCOUNT}/${USER}"
if ! [ -d "${LOCAL_EECS470_DIR}" ]; then
  echo "Warning: Local EECS 470 Synopsys library directory doesn't exist, attemping to copy..."
  cp -R "${EECS470_LIBS_DIR}" "${LOCAL_EECS470_DIR}"

  if [ "$?" -ne '0' ]; then
    echo "Error: Failed to copy EECS 470 Synopsys library to local directory:"
    echo "       ${EECS470_LIBS_DIR} -> ${LOCAL_EECS470_DIR}"
    popd
    exit 1
  fi
fi

# Export some environment variables so PBS can access them when job runs
export EECS470_LIBS_DIR
export LOCAL_EECS470_DIR
export PROJ_DIR
export PBS_ACCOUNT
export SCRATCH_DIR

# Need to load these so paths of dc_shell/vcs are found
module load synopsys/2013.03-SP1
module load vcs/2013.06-sp1

# Submit the batch job
echo "Submitting batch job..."
JOB_ID=`qsub -S $PBS_SHELL -N $PBS_JOB_NAME -A $PBS_ACCOUNT -l $PBS_JOB_ATTRS -q $PBS_QUEUE -M $PBS_EMAIL_ADDR -m $PBS_EMAIL_OPTS $PBS_FLAGS $PBS_FILE`
if [ "$?" -ne '0' ]; then
  echo "Error: Could not submit job via qsub"
  popd
  exit 1
fi
echo "Submitted batch job, id=$JOB_ID"

# clean up stuff
unset EECS470_LIBS_DIR
unset LOCAL_EECS470_DIR
unset PROJ_DIR
unset PBS_ACCOUNT
unset SCRATCH_DIR

popd

# to make parsing of result easier...
echo "jobID=$JOB_ID"
```


## `scripts/pbs.sh`
```bash
#!/bin/bash
# Created Fall 2010 by: Joshua Smith <smjoshua@umich.edu>
# Updated Winter 2014 by: Kyle Smith <kylebs@umich.edu>
#
# This script is executed to run the synthesis job on the computing node.

pushd ../

# Create a local directory for this run and copy project files into it
TMP_DIR=${SCRATCH_DIR}/${PBS_JOBID}
echo "PBS - Copying project files to scratch space: ${TMP_DIR}..."
mkdir -p $TMP_DIR
cd $TMP_DIR
rsync -avz $PROJ_DIR/ .
if [ "$?" -ne '0' ]; then
  echo "PBS - Error while trying to copy project files to tmp"
  cd
  rm -rf $TMP_DIR
  popd
  exit 1
fi

# Copy EECS470 libs for Synopsys
LIBS_DIR=${SCRATCH_DIR}/eecs470-libs
echo "PBS - Copying eecs470 Synopsys libs to scratch space..."
mkdir -p $LIBS_DIR
cd $LIBS_DIR

# this assumes you have a copy of the EECS 470 Synopsys libs in ${LOCAL_EECS470_DIR}!
rsync -avz ${LOCAL_EECS470_DIR} .

if [ "$?" -ne '0' ]; then
  echo "PBS - Error while trying to copy eecs470 Synopsys libs to scratch space using source directory: ${LOCAL_EECS470_DIR}"
  echo "PBS --- Have you copied the EECS 470 libs to your HPC home directory?"
  echo "PBS --- Try running:"
  echo "PBS --- $ cd"
  echo "PBS --- $ aklog -c umich.edu"
  echo "PBS --- $ cp -R /afs/umich.edu/class/eecs470/lib eecs470-libs"
  cd
  rm -rf $TMP_DIR
  popd
  exit 1
fi

# Find & Replace old paths with the new local one
echo "PBS - Re-linking all eecs470 Synopsys libs to the updated local path @ ${LIBS_DIR}..."
cd $TMP_DIR
find . -type f -exec sed -i "s,${EECS470_LIBS_DIR},${LIBS_DIR},g" {} \;

# Run synthesis
echo "PBS - Running synthesis..."
make syn

# Clean up simulation output
make clean

# Copy `proc.rep` result file back to home space
cd $TMP_DIR
cp syn/proc.rep ${PROJ_DIR}/proc.${PBS_JOBID}.rep
if [ "$?" -ne '0' ]; then
  echo "PBS - Error while trying to copy proc.rep back to project home"
  cd
  popd
  exit 1
fi

echo "PBS - Done!"

popd
```
