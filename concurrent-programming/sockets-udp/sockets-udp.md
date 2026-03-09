# UDP Sockets

#### Link Back To Main

[Back to Main Page](../concurrency-main.md)



## Overview

UDP sockets are unreliable:  messages sent from a process are NOT guaranteed
to be received by the destination
process, and if multiple messages are sent (or a long message that is broken up),
then it is NOT guaranteed that the multiple messages will be received 
and received in order.
If these adverse things happen, the codes just keep on running.

These jobs were run on Tinkercliffs (TC) and Owl clusters using sockets.

These are Berkeley (and as of CY 2000 also POSIX) sockets.

## Work on a Compute Node

Since we are running on the Owl cluster and Genoa nodes, that is where we want to create the
binary executable.

So the commands are:

_**Option 1:  The preferred option**_:

Option 1 is preferred because the interactive job will be cleaned up automatically.

~~~bash
## From the owl head node, issues this command to start your interactive job:
interact --time=2:00:00  --account=<your-account-name-here>  --partition=normal_q  --constraint=genoa&avx512
--nodes=1  --tasks-per-node=1  --cpus-per-task=2  
~~~


_**Option 2:  The not-preferred option**_:


~~~bash
## From the owl head node, issues this command to start your interactive job:
salloc --time=2:00:00  --account=<your-account-name-here>  --partition=normal_q  --constraint=genoa&avx512
--nodes=1  --tasks-per-node=1  --cpus-per-task=2  

## The results returned by slurm for the above command will include an owl compute node id, <cnode-id>
ssh <cnode-id>
~~~

where you have to supply your own account.

Now you can enter the compile commands and run the codes, as described below for Example 1 and 2.

When finished with these examples:

1. `exit` off of the compute node.
2. If you use Option 2 (which is not recommended), use `scancel` to cancel this interactive job.




## Example 1

Sockets are used in a client-server relationship.

The steps of execution are:

1. Server creates and binds to listening socket, to listen for UDP datagrams.
2. Server listens for datagrams from the/any client.
3. Client sends message.
4. Server gets client's address from the received message.
5. Server uses client's address to send message back to client.


This example is based on the code [here](https://www.geeksforgeeks.org/udp-server-client-implementation-c/).



#### Files (Scripts and Codes)

Each of these files should be created on TC (or Owl) and put in the 
same directory.
Just copy this text for each file and paste it into an open file
on the cluster filesystem.

We have hard-coded a port number in both _udpserver01.c_ and _udpclient01.c_
source code files.
You may have to change this number in both places and recompile and rerun.
I receive an error when I run the codes, trying to use a port that is already
in use.

We need a separate terminal for running each of the client and server codes.
The server code is started first.


Call the file below _job.02.sbatch_.

The sbatch slurm script, to run the job on TC or Owl in batch mode, is:


~~~bash
#!/bin/bash


## TC openmpi.


## -----------------------
# SLURM JOB SCRIPT OPTIONS:

## -----------------------
## EXECUTION DURATION.
# Set the time, which is the maximum time your job can run in HH:MM:SS
#SBATCH --time=0:10:00

## -----------------------
## NUM NODES AND CORES.
## Total number of compute nodes.
#SBATCH --nodes=1

## Number of MPI processes per compute node.
#SBATCH --ntasks-per-node=2

## Number of cores (total) per compute node (e.g., for hybrid threading).
#SBATCH --cpus-per-task=1

## -----------------------
## Exclusivity for nodes.
## If needed, request whole nodes by uncommenting the "#SBATCH --exclusive" line
## below.
## #SBATCH --exclusive

## -----------------------
## SLURM OUTPUT AND ERROR FILES.
#SBATCH --output slurm.udp.sockets.01.%j.out
#SBATCH --error  slurm.udp.sockets.01.%j.err


## -----------------------
## JOB QUEUE/PARTITION.
##  Set the partition to submit to (a partition is equivalent to a queue)
## #SBATCH --partition=parallel
#SBATCH --partition=normal_q
#SBATCH --constraint=genoa&avx512


## -----------------------
## ACCOUNT.
## The account to charge to.
#SBATCH --account arcadm


## -----------------------
## MEMORY.
## If need to control memory too, use a command like this:
## #SBATCH --mem=122MB



## -----------------------
## MODULES.
module reset
module load foss/2023b



## -----------------------
## WORKING DIRECTORY.
cd $SLURM_SUBMIT_DIR

## -----------------------
## EXPORTS 
## Exports and variable assignments.


## -----------------------
## JOB.
./run.02
~~~
{:  .language-bash}


The bash script that invokes the client and server codes (below) is (call this
file _run.02_):



~~~
## Start server in background.
./server01 &

## Wait three seconds.
## So we are sure the server is running and listening
## for connection requests.
sleep 3

## Now start client.
./client01
~~~
{:  .language-bash}



The C server code is _udpserver01.c_.

~~~
// Server side implementation of UDP client-server model 
#include <bits/stdc++.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>

#define PORT     8080 
#define MAXLINE 1024 

// Driver code 
int main() {
    int sockfd;
    char buffer[MAXLINE];
    const char *hello = "Message--Hello from server";
    struct sockaddr_in servaddr, cliaddr;

    // Creating socket file descriptor 
    if ( (sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0 ) {
        perror("socket creation failed");
        exit(EXIT_FAILURE);
    }

    memset(&servaddr, 0, sizeof(servaddr));
    memset(&cliaddr, 0, sizeof(cliaddr));

    // Filling server information 
    servaddr.sin_family    = AF_INET; // IPv4 
    servaddr.sin_addr.s_addr = INADDR_ANY;
    servaddr.sin_port = htons(PORT);

    // Bind the socket with the server address 
    if ( bind(sockfd, (const struct sockaddr *)&servaddr,
            sizeof(servaddr)) < 0 )
    {
        perror("bind failed");
        exit(EXIT_FAILURE);
    }

    // Waiting to receive a datagram to arrive from
    // anyone, anywhere.
    printf(" \n");
    printf("Server action:  Waiting to receive datagram from anyone, anywhere.\n");
    printf("------------------------------------------------------------------\n\n");

    socklen_t len;
    int n;

    len = sizeof(cliaddr);  //len is value/result 

    n = recvfrom(sockfd, (char *)buffer, MAXLINE,
                MSG_WAITALL, ( struct sockaddr *) &cliaddr,
                &len);
    buffer[n] = '\0';
    printf("Server action:  Received message from client.\n");
    printf("    Message content:  %s\n", buffer);
    sendto(sockfd, (const char *)hello, strlen(hello),
        MSG_CONFIRM, (const struct sockaddr *) &cliaddr,
            len);
    printf("Server action:  Send message to client.\n");
    std::cout<<"    Message content: " << hello << std::endl;


    return 0;
}
~~~
{:  .language-cpp}


The C client code is _udpclient01.c_.

~~~
// Client side implementation of UDP client-server model 
// #include <bits/stdc++.h> 
#include <iostream>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>

using namespace std;

#define PORT     8080 
#define MAXLINE 1024 

// Driver code 
int main() {
    int sockfd;
    char buffer[MAXLINE];
    const char *hello = "Message--Hello from client";
    struct sockaddr_in     servaddr;

    // Creating socket file descriptor 
    if ( (sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0 ) {
        perror("socket creation failed");
        exit(EXIT_FAILURE);
    }

    memset(&servaddr, 0, sizeof(servaddr));

    // Filling server information 
    servaddr.sin_family = AF_INET;
    servaddr.sin_port = htons(PORT);
    servaddr.sin_addr.s_addr = INADDR_ANY;

    int n;
    socklen_t len;

    sendto(sockfd, (const char *)hello, strlen(hello),
        MSG_CONFIRM, (const struct sockaddr *) &servaddr,
            sizeof(servaddr));
    std::cout<<"Client action:  Hello message sent."<<std::endl;
    std::cout<<"    Message content: " << hello <<std::endl;

    n = recvfrom(sockfd, (char *)buffer, MAXLINE,
                MSG_WAITALL, (struct sockaddr *) &servaddr,
                &len);
    buffer[n] = '\0';
    std::cout<<"Client action:  Received message from server." << std::endl;
    std::cout<<"    Message content received: " << buffer << std::endl;

    close(sockfd);
    return 0;
}
~~~
{:  .language-cpp}


The last file to create is the bash script to compile the source codes
above.


The shell script to compile and link both the _udpserver01.c_ and
_udpclient01.c_ codes is _build.sh_:


~~~
g++ udpclient01.c -o client01
g++ udpserver01.c -o server01
~~~
{:  .language-bash}


We have to change the permissions on file _run.02_ so that it is executable.
To do this, type

~~~
chmod u+x run.02
~~~
{:  .language-bash}




### C Code Compilation

The module below must be loaded at the command line before compiling,
and must be the same as that used in the sbatch script, if
there is an sbatch script.
We use here:

~~~
module reset
module load foss/2023b
~~~
{:  .language-bash}


Now buid or compile by issuing this command:

~~~
sh build.sh
~~~
{:  .language-bash}


The resulting executables will be _server_ and _client_.


### Submitting the Job to Slurm

To submit the job, type:

~~~
sbatch job.02.sbatch
~~~
{:  .language-bash}


Monitor the job using 

~~~
squeue -u $USER
~~~
{:  .language-bash}


When the job completes, the file _slurm.udp.sockets.01.SLURM_JOB_ID.out_
should contain the following (the client and server messages [in pairs]
could be in a different order):

~~~
Server action:  Waiting to receive datagram from anyone, anywhere.
------------------------------------------------------------------

Server action:  Received message from client.
    Message content:  Message--Hello from client
Server action:  Send message to client.
    Message content: Message--Hello from server
Client action:  Hello message sent.
    Message content: Message--Hello from client
Client action:  Received message from server.
    Message content received: Message--Hello from server
~~~
{:  .language-bash}


## Example 2

You build the codes _udpclient01.c_ and _udpserver01.c_ just as above,
and you compile the codes just as above.
But now we will run them from the command line, because they only
take a fraction of one second to run.

### Executing the Codes

We will not run this code in slurm batch mode.
Instead we will run the two codes on terminal screens,
one terminal for the _server_ code and a second terminal
for the _client_ code.
They will run very fast.

First, you need two terminal windows, and you must load the module specified
above in Example 1 in both terminal windows.

Then, in one window launch the server by typing:

~~~
./server01
~~~
{:  .language-bash}


In the other window, launch the client (but make sure the server is running) by typing:

~~~
./client01
~~~
{:  .language-bash}




### Output


The server output is:

~~~
 
Server action:  Waiting to receive datagram from anyone, anywhere.
------------------------------------------------------------------

Server action:  Received message from client.
    Message content:  Message--Hello from client
Server action:  Send message to client.
    Message content: Message--Hello from server
~~~
{:  .output}

The horizontal line and the blank line together denote the 
server waiting for a client to make a connection requeset.
After a connection request is received, the server continues
execution.

The client output is:

~~~
Client action:  Hello message sent.
    Message content: Message--Hello from client
Client action:  Received message from server.
    Message content received: Message--Hello from server
~~~
{:  .output}



These outputs are as those for Example 1.

{% include links.md %}

