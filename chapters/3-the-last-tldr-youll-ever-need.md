__TL;DR__ This Entire Guide in 1 Epic List
==========================================

## Get Access
- Obtain an [MToken](http://mtoken.umich.edu/) from the [Computer Showcase Repair Center](http://computershowcase.umich.edu/locations/north-campus.php)
in __Pierpont Commons__. All pickup locations on [the list](http://www.mais.umich.edu/mtoken/mtoken_distribution.html).
- Activate your MToken at <http://mtoken.umich.edu/>.
At the time of writing, this was done using [this Google Doc](https://docs.google.com/a/umich.edu/forms/d/1AGb6w2LbMf5wOI84SRNPEaNOXn76PgeMIp5Qiq1dTzI/viewform):
- Accept the [Synopsys off-campus license terms](http://caen.engin.umich.edu/software/access-to-synopsys-tools) using this form:
  - <https://docs.google.com/a/umich.edu/forms/d/1AGb6w2LbMf5wOI84SRNPEaNOXn76PgeMIp5Qiq1dTzI/viewform>
- Request an HPC user account with this form:
  - <https://www.engin.umich.edu/form/cacaccountapplication>
- Request a new Flux allocation (professors) or access to an existing one (students)
  - __Students__: have your professor email <hpc-support@umich.edu>
  - __Professors__: request a new allocation by emailing <hpc-support@umich.edu> the following:
    * number of cores needed
    * start date and duration needed
    * list of users (__students__) that should have access to submit jobs
    * list of users that should be admins (__you and GSIs__) and able to change user list and allocation properties
    * shortcode for funding
- __Wait one full business day (at least)__

## Running Jobs
- If you don't know the shell, __stop and go learn it__.
- From __on campus__, SSH into the [Flux login nodes](http://cac.engin.umich.edu/resources/login-nodes)
  using `flux-login.engin.umich.edu`.
- Submit a new job using `$ qsub -A prof-uniqname_flux -l qos=flux -q flux your-job-script.sh`
- See the CAC *nix Quick Reference Sheet for more commands:
  - <https://docs.google.com/a/umich.edu/viewer?a=v&pid=sites&srcid=dW1pY2guZWR1fGVuZ2luLWNhY3xneDpjYmRlMGQyMzVlY2FhYjg>
- Download the example Flux job scripts and drop them into your `scripts` directory in Better Build:
  - <https://github.com/EECS470WN14-group3/flux-practical-scripts>

## Helpful People
- Dan Barker for __general questions and getting an allocation set up__.
  - <mailto:danbarke@umich.edu>
  - (734) 763-9840
- Bennet Fauber for __Flux-specifics and issues with Synopsys__.
  - <mailto:bennet@umich.edu>
  - (734) 764-6226
- Kyle Smith's voicemail for __all the questions you have because you skipped the rest of the guide and only read this page__
- Kyle Smith for __all legitimate questions / concerns / beers__.
  - [@knksmith57](https://twitter.com/knksmith57)
  - (248) 491-3202
