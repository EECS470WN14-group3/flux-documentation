Overview
========

This short guide is intended to get students, GSIs, and professors, started with synthesis builds using
[Synopsys Design Compiler](http://www.synopsys.com/Tools/Implementation/RTLSynthesis/DCGraphical) on
[Flux](http://caen.engin.umich.edu/hpc/overview).

If you haven't used [Design Compiler](http://www.synopsys.com/Tools/Implementation/RTLSynthesis/DCGraphical)
yet (`make syn` with the [Better Build System](http://www.eecs.umich.edu/eecs/courses/eecs470/Final_proj/better_build_system.tar.gz)), I'd recommend attending lab or reading through the GSI's
[Synthesis and Makefile overview](http://www.eecs.umich.edu/eecs/courses/eecs470/tools/synthesisOverview.pdf)
before proceding.

Before you get too deep in this guide, it's worth noting that the CAEN
[High Performance Computing (HPC) Group](http://cac.engin.umich.edu/home)
does a fairly reasonable job of documenting Flux on their [homepage](http://caen.engin.umich.edu/hpc/overview).
If you want to figure everything out the hard way, jump on over to
[Getting Started at the CAC](http://caen.engin.umich.edu/hpc/overview).
This guide *does* cover a lot of the same content; however, in order to get you
up and running *quickly*, I place a __heavy emphasis on EECS 470 specifics__
and leave out a lot of general working knowledge.

In case you were handed this guide and have no idea why, a bit of context:
the HPC Group describes Flux as:
> The U-M's campus Linux-based high performance computing cluster

At the time of writing (Winter 2014), Flux is comprised:
- 632 standard multi-core compute nodes (8,016 total cores)
  - 4GB of RAM per core
- 10 large-memory compute nodes (32 or 40 cores per node)
  - 1TB of total RAM per system
- 640TB of high-speed scratch storage

Full stats and configuration options are available on the HPC website:
<http://caen.engin.umich.edu/hpc/flux-configuration>.


## __TL;DR__
Flux is giant cluster of computers with lots of parallel computing power. This
guide will teach you how to run synthesis on Flux.


## Useful Links
- HPC Homepage: <http://caen.engin.umich.edu/hpc/overview>
- Flux Specs and Configuations<http://caen.engin.umich.edu/hpc/flux-configuration>
