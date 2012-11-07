NITOS-Scheduler
===============
NITOS SCHEDULER DESCRIPTION
___________________________
NITOS scheduler relies its functionality on the OMF architecture.
As we know, in OMF the EC communicates with the resources through an XMPP server.
When an ED script is executed, the EC sends the experiment commands to the RC at the nodes through the XMPP server.
In the default OMF configuration there is only a single slice (for running experiments) at the XMPP server called "default_slice".
This slice contains all testbed nodes, so every user can run experiments with every node in the testbed, provided he/she is logged in the testbed's server.

What we have done is that the NITOS scheduler creates a slice at the XMPP server for each user of NITOS and we add and
remove resources to/from these slices dynamically, each time a reservation starts or ends.
In NITOS testbed there is no "default_slice" anymore. When we create an account for a user at the NITOS server,
we also create a slice at the XMPP server with the same name (with the help of omf_create_psnode command),
i.e. OMF/<username>.
When a user reserves a node for his/her slice from the web reservation tool and for a specific time slot,
the reservation entry is stored in scheduler's database.
At minutes 28 and 58 (reservation timeslots at NITOS have a 30min granularity) a scheduler script is executed (via crontab) and checks the database for expiring and starting reservations.
If an expiring or starting reservation is found, then the scheduler removes/adds the reservation's node(s) from/to the respective user's slice at the XMPP server (through the omf_create_psnode command again).
At an expiring reservation, the scheduler powers off the nodes that had been reserved, using their cm card.
With this setup only a user that has reserved a node can run experiments with it.
To do so, he/she runs "omf exec" at the server using the --slice option.

But still, this setup alone does not solve other authorization problems, related to ssh-access on the nodes, rebooting of nodes and
burning images on non-reserved nodes using the standard OMF procedure (omf load/save).
In general, the user accounts are disabled on the server and the default access policy for all users to the testbed nodes is deny. When a user makes a reservation, the system scheduler schedules a change on the firewall rules allowing only the user who made the reservation to have access to his nodes. The policy of allowing access only to the reserved nodes prevents experimenters from logging in testbed nodes that do not belong to them (either accidentally or on purpose) and affect the experiments execution.
Regarding the omf procedures of load/save and tell, we have also modified OMF in order to check the scheduler's database before executing each command. This way only a user who has reserved his nodes can power on them, with "omf tell", load an image on them, with "omf load" and save an image from them, with "omf save".

The TCRS service (Testbed's central reboot system) is running at NITOS testbed and manages the power control of the nodes.
Users/slices can only hard-reboot nodes they have reserved for the current time slot via TCRS.
We also follow this policy with the CM cards whose management is provided through the OMF CMC service.
___________________________
Apart from isolation of user access to the nodes, frequency slicing is also fundamental to achieving
experiment isolation in a wireless environment.
Regarding frequency slicing, we have developed a solution that works even in the case where a user does not use OMF to run his experiments.
Essentially, it constitutes of checking  the channels being used at each resource periodically.
A script runs periodically at the server (through crontab), which checks the nodes for the frequency they use (through iwlist).

In order for this to work, the server's public rsa key must be in the authorized_keys file in each
node's image (so that ssh-access is granted to the password-protected images of the nodes).
Therefore users are obligated to copy this key in their image's file system
or just not delete it, if they are using a modified version of the default NITOS baseline image.
In contrast with the password-protection of images, this is not a recommended configuration, but an obligatory one.
Misbehavior incidents (use of unreserved frequencies or use of images without the required rsa key)
are logged in a file that a parser is checking. Then the desired policy can be applied for misbehaving
users (user warning through mail, frequency switching, node rebooting etc.)
A set of sniffer nodes, collectively spanning the testbed range, will also be added in the near future,
in order to check for misbehavior.
___________________________
Summarizing, from a NITOS user's perspective the steps that he/she has to follow the first time are:
reserve nodes for his/her slice using the web application
-login to the NITOS server
-power on the reserved nodes with the "omf tell" command
-burn baseline image with the omf load command
-ssh to the node
-change slice name in the RC configuration file to match the username
-save the image through the "omf save"command and, optionally, rename the saved image to a meaningful name.

After these steps he/she can load and save his/her image with the omf commands or run an experiment with "omf exec" command.
