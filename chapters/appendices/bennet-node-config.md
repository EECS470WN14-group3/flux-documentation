An excerpt from an email sent to me from [Bennet Fauber](bennet@umich.edu) on April 18th, 2014.

> Kyle,
> 
> I ramble on in the first answer.  Perservere, and the question about
> interactive is answered way down there.
> 
> As I'm sure you know, there are two memory models in parallel
> computing:  the memory is shared among the processes, which all just
> use different address ranges, or it is distributed, which is just
> copying the chunk you need to where you're going to use it.
> Basically, that boils down to 'same machine' or 'many machines'.  Same
> machine is faster, almost always.
> 
> When you ask for nodes=1:ppn=12, you're asking for one machine with at
> least 12 processors per machine.  All of the machines we have in the
> public pool have at least 12 processors, so any of them will be able
> to run your job.
> 
> When you ask for nodes=1:ppn=16, you're asking for one machine with at
> least 16 processors per machine.  About 1/4 of our machines are
> configured that way, and people know those are faster processors, so
> more people ask for them by name.  You're waiting for all the
> processors on one whole machine to come free, but the scheduler is
> juggling many thousands of jobs that don't need the whole machine, so
> at least one processor on each machine is already committed for a long
> time into the future.
> 
> When you request procs=16, without any node requirements, then you're
> almost certainly now in the distributed memory situation, so the
> overhead of copying data among the machines (up to 16) will have an
> effect -- at its worst, it will take longer to copy data around than
> it will to calculate the results.  How much time it will add depends
> on the nature of the problem, how well can it be divided, and the
> efficiency of the algorithms used to partition and copy things around.
> 
> Using procs=N is the fastest because we have so many jobs running, and
> finding some combination across a bunch of machines is pretty quick
> and easy.  That's ideal for jobs where each process is, effectively, a
> job of its own and doesn't have to communicate with the other
> processes.  Many programs have a lot more chatter among the processes
> while the program is running, so they all wait on the slowest running
> processor at any given step (which may be a different processor on a
> different node for any given step).
> 
> You'll probably find that nodes=1:ppn=12 will be the best combination
> for most things, given what you've said already.
> You don't have an unlimited number of processors, so you can't simply
> increase the number of processors to compensate for the slow-down of
> using processors on different machines.  You also don't have unlimited
> time, so it's probably better to get your work done than to figure out
> how to do it faster when you get to it.
> 
> Memory can be requested by either mem=N or pmem=M, which is total
> memory across the whole job or minimum memory guaranteed to each
> processor within a job.  If you ask for only one node, then all the
> memory in the job is pooled on the one node, so they can be roughly
> equivalent, i.e., N = M*procs.  It's more complicated when you are
> using more than one node.  If you ask for mem=16gb along with
> cores=16, then the scheduler _could_ give you one processor of the
> bunch with 500 MB, one with 1.5 GB, and the rest with 1 GB.  If you're
> using one node consistently, you could use either, but remember that
> our 12 core nodes have 48 GB of memory, some of which is needed by the
> operating system and cluster management software, so you shouldn't ask
> for nodes=1:ppn=12,mem=48gb, as that will be able to run only on
> machines with more than 12 cores, so you're back to waiting in line
> for a 12 of 16 cores on a popular machine type.  Better to ask for
> either nodes=1:ppn=12,mem=47gb or nodes=1:ppn=12,pmem=4000mb, which
> will leave sufficient room for the OS overhead.

Bennet rocks.
