Pseudo-daemon Monitoring with `git diff`
========================================

This is an enhancement to the code in `manual-better-build.md` that adds
intelligent `git diff` checking and a "pseudo-daemon" that runs in the
background and checks for new commits before auto-launching a new build.

There's also a section commented out that hits a remote REST server with job
status updates so that we can track status without having to hop on a terminal.
If you want implement the REST server for remote status tracking, hit me up and
I can get you the code base --> [@knksmith57](https://twitter.com/knksmith57).


## `scripts/daemon.sh`
```bash
#!/bin/bash

PBS_SCRIPT="synth.sh"
JOB_LOG_FILE="jobs-for-commits.log"

export REMOTE_NAME="origin"
export SYNTH_BRANCH="flux"

PENDING_UPDATE=0
PENDING_UPDATE_JOBID=0

while [ 1 ]; do
  # get a comma-separated list of all jobs that aren't complete
  jobs="$(qstat -u $USER | grep -vE '00 C' | grep -E '^[0-9]+' | tr -s '[:blank:]' ',')"

  # check remote git repository for a commit change
  update_detected=0
  local_commit="$(git rev-list --max-count=1 $REMOTE_NAME/$SYNTH_BRANCH)"
  remote_commit="$(git ls-remote --heads $REMOTE_NAME $SYNTH_BRANCH)"
  remote_issue="$?"
  remote_commit="$(echo "$remote_commit" | cut -f1)"
  [ "$remote_issue" -eq 0 ] && [ "$local_commit" != "$remote_commit" ] && update_detected=1;

  # send updates back to remote REST server
  # curl   --data-urlencode "v=1"                                   \
  #        --data-urlencode "jobs=${jobs}"                          \
  #        --data-urlencode "log=$(cat $JOB_LOG_FILE)"              \
  #        --data-urlencode "update_requested=${update_requested}"  \
  #        http://api.your-server.com/ &> /dev/null

  # if update detected, queue up job!
  if [ $update_detected -ne 0 ]; then
    echo "update detected!"

    # write the update activity to the local log
    echo "update detected @ $(date +%s)" >> updates.log;

    PENDING_UPDATE="$remote_commit"
    PENDING_UPDATE_JOBID=0

    # kill any queued jobs-- this one is obviously newer
    for job in $jobs; do
      # get the status of this job (Q == Queued, C == Complete, R == Running)
      status="$(echo "$job" | cut -d',' -f10)"
      jobid="$(echo "$job" | cut -d',' -f1 | cut -d'.' -f1)"

      if [ "$status" == "Q" ]; then
        echo "detected previously queued job: $jobid, killing it...";
        qdel $jobid;
      fi
    done

    # update the repo, pull down the latest
    git fetch $REMOTE_NAME
    # git reset --hard
    # git checkout $SYNTH_BRANCH
    # git reset --hard
    # git pull $REMOTE_NAME $SYNTH_BRANCH

    # grab the new commit hash to report back with
    export COMMIT_HASH="$(git rev-parse --short "$remote_commit")"

    # submit the new job using l33t h@ck5
    # NOTE: this git logic is pretty stupid and hacked together. don't just
    # blindly put this into production without testing + tweaking first.
    git checkout "${SYNTH_BRANCH}_base" $PBS_SCRIPT
    submit_result="$( ./$PBS_SCRIPT )"
    if [ "$?" -ne '0' ]; then
      echo "Error: Failed to submit job with PBS script: $PBS_SCRIPT";
    else
      # parse out the job id from the output of the PBS script
      jobid="$( echo "$submit_result" | tail -1 | cut -d'=' -f2 | cut -d'.' -f1)"
      submit_time=$(date +%s);

      # log the jobid:commit_hash relationship
      echo "$jobid,$COMMIT_HASH,$submit_time" >> $JOB_LOG_FILE;
    fi
  else
    sleep 1;
  fi

  git reset --hard "${SYNTH_BRANCH}_base"
done
```

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
