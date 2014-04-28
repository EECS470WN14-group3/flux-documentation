Two Factor Authentication (2fa)
===============================

Flux is a [batch processing system](http://en.wikipedia.org/wiki/Batch_processing).
More about what that means later. For now, just understand that, in order to use
Flux, you'll need access to two things:
- The [HPC Login Nodes](http://cac.engin.umich.edu/resources/login-nodes)
  which are simply SSH login servers (like `login.engin.umich.edu`).
- A [Flux allocation](http://arc.research.umich.edu/flux-and-other-hpc-resources/flux/managing-a-flux-project/)
  to run jobs on.

In order to access [HPC Login Nodes](http://cac.engin.umich.edu/resources/login-nodes)
(covered in more detail in the next chapter), you must first obtain an
[MToken](http://www.mais.umich.edu/mtoken/about2fa.html). __Skip ahead__ if you
already have an activated MToken.

## 1. What's an MToken?
MTokens are Michigan-branded [RSA SecurID](http://en.wikipedia.org/wiki/SecurID)s,
which are the most popular hardware [security tokens](http://en.wikipedia.org/wiki/Security_token)
in mass circulation. For a quick overview of 2fa, check out
[CAEN's intro video on YouTube](https://www.youtube.com/watch?v=rNBN0m42syI)
Additionally, the [ITS MToken website](http://www.mais.umich.edu/mtoken/about2fa.html)
lists which university resources require 2fa for access.

The below instructions were lifted from the following CAEN and CAC pages:
- <http://www.itcs.umich.edu/itcsdocs/s4394/>
- <http://cac.engin.umich.edu/resources/login-nodes/tfa>

## 2. Obtain an MToken
Go to the [Computer Showcase Repair Center](http://computershowcase.umich.edu/locations/north-campus.php)
in __Pierpont Commons__. If you're not on north campus, find another Distribution Center from
[the list](http://www.mais.umich.edu/mtoken/mtoken_distribution.html)

## 3. Activate Your MToken
With your shiny new Mtoken __in hand__, open <http://mtoken.umich.edu/> and
follow the activation instructions

### *If you can't visit in person*
__Use this as a last resort__. Send an email to <4help@umich.edu> and ask real
nice. With some luck, they'll physically mail you the dongle or send a software
token via email.

<br><br><hr/>
#### Useful Links
- MToken activation / management site: <http://mtoken.umich.edu>
- ITS 2fs guide: <http://www.itcs.umich.edu/itcsdocs/s4394/>
- CAC 2fa guide: <http://cac.engin.umich.edu/resources/login-nodes/tfa>
