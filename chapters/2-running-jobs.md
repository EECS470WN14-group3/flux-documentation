Running Jobs (_synthesis_)
==========================

Flux processes jobs using a batch system. If you've never used a batch system
before, it's useful to think of jobs as backgrounded processes (eg: `./my_script &`);
batch systems, unlike the interactive shell that you're likely accommodated to
(eg: [BASH](http://en.wikipedia.org/wiki/Bash_(Unix_shell)), queue and execute
unattended programs without requiring (or, generally speaking, allowing) user
interaction.

## The Concept
Using the login server, you'll issue a command that will submit a job to the worker
queue. Once the queue selects your job for execution, a worker node will start
whatever program you've given the job. While the worker node is executing your
program you'll have (generally speaking) very limited knowledge of what is
actually happening (eg: what state the program is in, what messages are being
printed to `STDOUT` or `STDERR`).

## The Implementation
In the context of EECS 470, this means running a synthesis build will involve
logging into Flux, issuing a command to submit `make syn` as the program to
run, and waiting until the job has completed. If all goes well, you can start
synthesis on Flux, log off, grab a bite to eat, log back in an hour or two
later, and view the `proc.rep` file to make sure everything work as expected.
__No more all-nighters in 1695 waiting for builds to complete__!

## Topics Covered
This chapter is the meat-and-potatoes of this guide and will cover the
following topics:

- Logging into Flux
- Writing scripts to run jobs
- Submitting jobs, `PBS`, and other useful tools


## Useful Links
- Batch Processing: <http://en.wikipedia.org/wiki/Batch_processing>
- Job Schedulers: <http://en.wikipedia.org/wiki/Job_scheduler>
