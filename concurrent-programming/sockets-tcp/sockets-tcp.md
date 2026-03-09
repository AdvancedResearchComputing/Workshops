# TCP Sockets

#### Link Back To Main

[Back to Main Page](../concurrency-main.md)




## Overview

TCP sockets are reliable:  messages sent from a process will be received by the destination
process, and if multiple messages are sent, then the messages will be received in order.
Otherwise, the program will die.

These jobs were run on Tinkercliffs (TC) and Owl clusters using sockets.

These are Berkeley (and as of CY 2000 also POSIX sockets).

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

Now you can enter the compile commands and run the codes, as described below for Example 1.

When finished with these examples:

1. `exit` off of the compute node.
2. If you use Option 2 (which is not recommended), use `scancel` to cancel this interactive job.


## Example 1

Sockets are used in a client-server relationship.

The steps of execution are:

1. Server creates and binds to listening socket, to listen
for connection requesets.
2. Client makes a request.
3. Server establishes new socket with the client.
4. So now the server has two socket endpoints:  the listening socket and the socket connection with the client.
5. Server listens for service requests from the client.
6. Client sends a message to the server.
7. Server receives and prints message.
8. Server sends message to client.
9. Client receives and prints message.
10. Client closes its socket connection with server.
11. Server closes its socket connection with server.
12. Server closes its listening socket endpoint.


Each of these files should be created on TC and put in the 
same directory.
Just copy this text for each file and paste it into an open file
on the cluster filesystem.

We have hard-coded a port number in both _server.c_ and _client.c_
source code files.
You may have to change this number in both places and recompile and rerun.
I receive an error when I run the codes, trying to use a port that is already
in use.

We are running these from the command line.
So there is no sbatch slurm script.
These are very small codes.

We need a separate terminal for running each of the client and server codes.
The server code is started first.

#### Files (Scripts and Codes)

Create these files and put them in the same directory.



The C server code is _server.c_.

~~~cpp
// Server side C program to demonstrate Socket
// programming
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>
// #define PORT 8080
#define PORT 34000
int main(int argc, char const* argv[])
{
    int server_fd, new_socket;
    ssize_t valread;
    struct sockaddr_in address;
    int opt = 1;
    socklen_t addrlen = sizeof(address);
    char buffer[1024] = { 0 };
    char* hello = "hello from server";

    // Creating socket file descriptor
    printf("  Server:  creating socket file descriptor.\n");
    if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
        perror("socket failed");
        exit(EXIT_FAILURE);
    }

    // Forcefully setting socket to the specified port.
    printf("  Server:  attaching socket to specified port:  %d.\n",PORT);
    if (setsockopt(server_fd, SOL_SOCKET,
                   SO_REUSEADDR | SO_REUSEPORT, &opt,
                   sizeof(opt))) {
        perror("setsockopt");
        exit(EXIT_FAILURE);
    }
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(PORT);

    // Forcefully binding socket to the port PORT.
    printf("  Server:  binding socket to specified port:  %d.\n",PORT);
    if (bind(server_fd, (struct sockaddr*)&address,
             sizeof(address))
        < 0) {
        perror("bind failed");
        exit(EXIT_FAILURE);
    }

    printf("  Server:  listening for connection request.\n");
    if (listen(server_fd, 3) < 0) {
        perror("listen");
        exit(EXIT_FAILURE);
    }

    printf("  Server:  waiting to accept new socket request.\n");
    printf("  --------------------------------------\n");
    printf("\n");
    if ((new_socket
         = accept(server_fd, (struct sockaddr*)&address,
                  &addrlen))
        < 0) {
        perror("accept");
        exit(EXIT_FAILURE);
    }
    printf("  Server:  received and accepted new socket request.\n");
    printf("  Server:  created new socket.\n");

    printf("  Server:  read message received on socket.\n");
    valread = read(new_socket, buffer,
                   1024 - 1); // subtract 1 for the null
                              // terminator at the end

    printf("  Server:  print message received: '%s'.\n");


    printf("  Server:  send new message to the client.\n");
    printf("  Server:  message payload sent:  '%s'.\n",hello);
    send(new_socket, hello, strlen(hello), 0);
    printf("  Server:  hello message sent to client.\n");

    // closing the connected socket
    printf("  Server:  closing the messaging socket.\n");
    close(new_socket);
    // closing the listening socket
    printf("  Server:  closing the listening socket.\n");
    close(server_fd);
    return 0;
}
~~~


The C server code is _client.c_.

~~~cpp
// Client side C program to demonstrate Socket
// programming
#include <arpa/inet.h>
#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>
// #define PORT 8080
#define PORT 34000

int main(int argc, char const* argv[])
{
    int status, valread, client_fd;
    struct sockaddr_in serv_addr;
    char* hello = "hello from client";
    char buffer[1024] = { 0 };

    // Creating a socket.
    if ((client_fd = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
        printf("\n Socket creation error \n");
        return -1;
    }

    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(PORT);

    // Convert IPv4 and IPv6 addresses from text to binary
    // form
    if (inet_pton(AF_INET, "127.0.0.1", &serv_addr.sin_addr)
        <= 0) {
        printf(
            "\nInvalid address/ Address not supported \n");
        return -1;
    }

    printf("  Client:  attempting to connect to socket.\n");
    if ((status
         = connect(client_fd, (struct sockaddr*)&serv_addr,
                   sizeof(serv_addr)))
        < 0) {
        printf("\nConnection Failed \n");
        return -1;
    }
    printf("  Client:  socket connection attempt successful.\n");
    printf("\n");


    printf("  Client:  sending message on socket.\n");
    printf("  Client:  message payload: '%s'.\n",hello);
    send(client_fd, hello, strlen(hello), 0);
    printf("  Client:  the hello message was sent from client to server.\n");

    printf("  Client:  waiting to receive message from server.\n");
    valread = read(client_fd, buffer,
                   1024 - 1); // subtract 1 for the null
                              // terminator at the end

    printf("  Client:  message payload received:  '%s'.\n",buffer);

    // closing the connected socket
    printf("  Client:  closing the connected socket.\n");
    close(client_fd);

    return 0;
}
~~~


The last file to create is the bash script to compile the source codes
above.


The shell script to compile and link both the _server.c_ and
_client.c_ codes is _build.sh_:


~~~bash
gcc client.c -o client
gcc server.c -o server
~~~




#### C Code Compilation

The module below must be loaded at the command line before compiling,
and must be the same as that used in the sbatch script, if
there is an sbatch script.

We use here:

~~~bash
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



#### Executing the Codes

We will not run this code in slurm batch mode.
Instead we will run the two codes on terminal screens,
one terminal for the _server_ code and a second terminal
for the _client_ code.
They will run very fast.

In one window launch the server by typing:

~~~
./server
~~~
{:  .language-bash}


In the other window, launch the client (but make sure the server is running) by typing:

~~~
./client
~~~
{:  .language-bash}




#### Output


The server output is:

~~~output
  Server:  creating socket file descriptor.
  Server:  attaching socket to specified port:  34000.
  Server:  binding socket to specified port:  34000.
  Server:  listening for connection request.
  Server:  waiting to accept new socket request.
  --------------------------------------

  Server:  received and accepted new socket request.
  Server:  created new socket.
  Server:  read message received on socket.
  Server:  print message received: 'hello from client'.
  Server:  send new message to the client.
  Server:  message payload sent:  'hello from server'.
  Server:  hello message sent to client.
  Server:  closing the messaging socket.
  Server:  closing the listening socket.
~~~


The horizontal line and the blank line together denote the 
server waiting for a client to make a connection requeset.
After a connection request is received, the server continues
execution.

The client output is:

~~~output
  Client:  attempting to connect to socket.
  Client:  socket connection attempt successful.

  Client:  sending message on socket.
  Client:  message payload: 'hello from client'.
  Client:  the hello message was sent from client to server.
  Client:  waiting to receive message from server.
  Client:  message payload received:  'hello from server'.
  Client:  closing the connected socket.

~~~




## Example 2

We are going to run the same exact two codes (almost the exact same),
but now we are going to use slurm and run in batch mode.

Two changes are needed:
1. sbatch slurm script; one script for both codes.
2. each of client and server writes output to files instead of
to standard out (i.e., the screen).

The first requirement is so that we can ensure both codes run on the
same compute node.
We need a feature to run both codes from one script, where the second code
runs before the first one completes.

The second requirement is so that the output of the two codes do not get 
interleaved.


#### Files (Scripts and Codes)

We need to create these files in a single directory.

This is the sbatch slurm job submission script _job.02.sbatch_.

~~~bash
#!/bin/bash

## owl

## -----------------------
# SLURM JOB SCRIPT OPTIONS:

## -----------------------
## EXECUTION DURATION.
# Set the time, which is the maximum time your job can run in HH:MM:SS
#SBATCH --time=1:00:00

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
#SBATCH --output slurm.sockets.02.%j.out
#SBATCH --error slurm.sockets.02.%j.err


## -----------------------
## JOB QUEUE/PARTITION.
##  Set the partition to submit to (a partition is equivalent to a queue)
## #SBATCH --partition=parallel
#SBATCH --partition=normal_q
#SBATCH --constraint=genoa&avx512


## -----------------------
## ACCOUNT.
## The account (A) to charge to.
## You will need your own account.
#SBATCH -A arcadm


## -----------------------
## MEMORY.
## If need to control memory, too (like cpus), use "-mem" switch.
## This is the amount of memory allocated PER COMPUTE NODE.
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



The bash script _run.02_ is:

~~~bash
## Start server in background.
./server02 &

## Wait three seconds.
## So we are sure the server is running and listening
## for connection requests.
sleep 3

## Now start client.
./client02
~~~


This one bash scripts runs both the client and server codes 
and further, runs them both concurrently, owing to 
the `&` at the end of line 1 (i.e., run the server in background mode).
There is a sleep period of three seconds because we want to 
makes sure that the server is launched and is listing for connection
requests before the client process starts.


The C++ code is next.
The _server02.c_ and _client092.c_ codes now have
print statements to file so that they do not comingle
output in the slurm output file. 

This is the C++ code _server02.c_.

~~~cpp
// Server side C program to demonstrate Socket
// programming
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>
// #define PORT 8080
#define PORT 34000
int main(int argc, char const* argv[])
{
    int server_fd, new_socket;
    ssize_t valread;
    struct sockaddr_in address;
    int opt = 1;
    socklen_t addrlen = sizeof(address);
    char buffer[1024] = { 0 };
    char* hello = "hello from server";

    // File pointer for output file.
    FILE *fptr;

    // Open a file in writing mode
    fptr = fopen("server.out", "w");

    // Creating socket file descriptor
    printf("  Server:  creating socket file descriptor.\n");
    fprintf(fptr, "  Server:  creating socket file descriptor.\n");
    if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
        perror("socket failed");
        exit(EXIT_FAILURE);
    }

    // Forcefully attaching socket to the specified port.
    printf("  Server:  attaching socket to specified port:  %d.\n",PORT);
    fprintf(fptr, "  Server:  attaching socket to specified port:  %d.\n",PORT);
    if (setsockopt(server_fd, SOL_SOCKET,
                   SO_REUSEADDR | SO_REUSEPORT, &opt,
                   sizeof(opt))) {
        perror("setsockopt");
        exit(EXIT_FAILURE);
    }
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(PORT);

    // Forcefully attaching socket to the port PORT.
    printf("  Server:  binding socket to specified port:  %d.\n",PORT);
    fprintf(fptr, "  Server:  binding socket to specified port:  %d.\n",PORT);
    if (bind(server_fd, (struct sockaddr*)&address,
             sizeof(address))
        < 0) {
        perror("bind failed");
        exit(EXIT_FAILURE);
    }

    printf("  Server:  listening for connection request.\n");
    fprintf(fptr, "  Server:  listening for connection request.\n");
    if (listen(server_fd, 3) < 0) {
        perror("listen");
        exit(EXIT_FAILURE);
    }

    printf("  Server:  waiting to accept new socket request.\n");
    printf("  --------------------------------------\n");
    printf("\n");
    fprintf(fptr, "  Server:  waiting to accept new socket request.\n");
    fprintf(fptr, "  ----------------------------------------------\n");
    fprintf(fptr, "\n");
    if ((new_socket
         = accept(server_fd, (struct sockaddr*)&address,
                  &addrlen))
        < 0) {
        perror("accept");
        exit(EXIT_FAILURE);
    }
    printf("  Server:  received and accepted new socket request.\n");
    printf("  Server:  created new socket.\n");
    fprintf(fptr, "  Server:  received and accepted new socket request.\n");
    fprintf(fptr, "  Server:  created new socket.\n");

    printf("  Server:  read message received on socket.\n");
    fprintf(fptr, "  Server:  read message received on socket.\n");
    valread = read(new_socket, buffer,
                   1024 - 1); // subtract 1 for the null
                              // terminator at the end

    printf("  Server:  print message received: '%s'.\n",buffer);
    fprintf(fptr, "  Server:  print message received: '%s'.\n",buffer);


    printf("  Server:  send new message to the client.\n");
    printf("  Server:  message payload sent:  '%s'.\n",hello);
    fprintf(fptr, "  Server:  send new message to the client.\n");
    fprintf(fptr, "  Server:  message payload sent:  '%s'.\n",hello);
    send(new_socket, hello, strlen(hello), 0);
    printf("  Server:  hello message sent to client.\n");
    fprintf(fptr, "  Server:  hello message sent to client.\n");

    // closing the connected socket
    printf("  Server:  closing the messaging socket.\n");
    fprintf(fptr, "  Server:  closing the messaging socket.\n");
    close(new_socket);
    // closing the listening socket
    printf("  Server:  closing the listening socket.\n");
    fprintf(fptr, "  Server:  closing the listening socket.\n");
    close(server_fd);


    fprintf(fptr, "  Server:  end.\n");
    fclose(fptr);

    return 0;
}

~~~


This is the C++ code _client02.c_.

~~~cpp
// Client side C program to demonstrate Socket
// programming
#include <arpa/inet.h>
#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>
// #define PORT 8080
#define PORT 34000

int main(int argc, char const* argv[])
{
    int status, valread, client_fd;
    struct sockaddr_in serv_addr;
    char* hello = "hello from client";
    char buffer[1024] = { 0 };

    // File pointer for output file.
    FILE *fptr;

    // Open a file in writing mode
    fptr = fopen("client.out", "w");


    if ((client_fd = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
        printf("\n Socket creation error \n");
        return -1;
    }

    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(PORT);

    // Convert IPv4 and IPv6 addresses from text to binary
    // form
    if (inet_pton(AF_INET, "127.0.0.1", &serv_addr.sin_addr)
        <= 0) {
        printf(
            "\nInvalid address/ Address not supported \n");
        return -1;
    }

    printf("  Client:  attempting to connect to socket.\n");
    fprintf(fptr,"  Client:  attempting to connect to socket.\n");
    if ((status
         = connect(client_fd, (struct sockaddr*)&serv_addr,
                   sizeof(serv_addr)))
        < 0) {
        printf("\nConnection Failed \n");
        return -1;
    }
    printf("  Client:  socket connection attempt successful.\n");
    printf("\n");
    fprintf(fptr,"  Client:  socket connection attempt successful.\n");
    fprintf(fptr,"\n");


    printf("  Client:  sending message on socket.\n");
    printf("  Client:  message payload: '%s'.\n",hello);
    fprintf(fptr,"  Client:  sending message on socket.\n");
    fprintf(fptr,"  Client:  message payload: '%s'.\n",hello);
    send(client_fd, hello, strlen(hello), 0);
    printf("  Client:  the hello message was sent from client to server.\n");
    fprintf(fptr,"  Client:  the hello message was sent from client to server.\n");

    printf("  Client:  waiting to receive message from server.\n");
    fprintf(fptr,"  Client:  waiting to receive message from server.\n");
    valread = read(client_fd, buffer,
                   1024 - 1); // subtract 1 for the null

    printf("  Client:  message payload received:  '%s'.\n",buffer);
    fprintf(fptr,"  Client:  message payload received:  '%s'.\n",buffer);

    // closing the connected socket
    printf("  Client:  closing the connected socket.\n");
    fprintf(fptr,"  Client:  closing the connected socket.\n");
    close(client_fd);

    fprintf(fptr, "  Client:  end.\n");
    fclose(fptr);

    return 0;
}
~~~


Finally, the build script for compiling the C codes is _build02.sh_.

~~~bash
gcc client02.c -o client02
gcc server02.c -o server02
~~~



Now all of the codes and files we need exist.

We have to change the permissions on file _run.02_ so that it is executable.
To do this, type

~~~
chmod u+x run.02
~~~
{:  .language-bash}



#### Compiling C Codes

You must use the `interact` command above to obtain a Genoa node on the Owl cluster
and then go to the directory with the C++ source code and compile the 
server and client codes:


~~~bash
sh build02.sh
~~~


This should produce _server02_ and _client02_ executable files.



#### Slurm Sbatch Job Submission

Back on the head node, 
to submit this job to the slurm scheduler, we execute:

~~~bash
sbatch job.02.sbatch
~~~


Monitor the progress and status of the job by typing

~~~bash
squeue -u <username>
~~~




#### Output

The output file contains the following.
The first prints are from the sbatch slurm script.
The remaining lines are from the C++ code.

Note that reading this file is a bit wonky, as is almost
always the case when there is one output file for multiple
processes.

The server output file, _server.out_, is:

~~~output
  Server:  creating socket file descriptor.
  Server:  attaching socket to specified port:  34000.
  Server:  binding socket to specified port:  34000.
  Server:  listening for connection request.
  Server:  waiting to accept new socket request.
  ----------------------------------------------

  Server:  received and accepted new socket request.
  Server:  created new socket.
  Server:  read message received on socket.
  Server:  print message received: 'hello from client'.
  Server:  send new message to the client.
  Server:  message payload sent:  'hello from server'.
  Server:  hello message sent to client.
  Server:  closing the messaging socket.
  Server:  closing the listening socket.
  Server:  end.
~~~


The client output file, _client.out_, is:

~~~output
  Client:  attempting to connect to socket.
  Client:  socket connection attempt successful.

  Client:  sending message on socket.
  Client:  message payload: 'hello from client'.
  Client:  the hello message was sent from client to server.
  Client:  waiting to receive message from server.
  Client:  message payload received:  'hello from server'.
  Client:  closing the connected socket.
  Client:  end.
~~~



These outputs are as those for Example 1.



