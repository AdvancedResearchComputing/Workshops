# Iterating over Collections

#### Link Back To Main

[Back to Main Page](./aa-bash-02-main.md)



## Overview

A "collection" is any list or array of items.

We restrict ourselves to one-dimensional structures.


#### Case 1:  Iterating Over A Single Collection

One can use lists or arrays.

##### A List

One approach for lists: 


~~~bash
my_list="  42 -18  63      72 9        "

echo " elements: "
for item in ${my_list}
do
    echo "${item}"

done
echo " " 
~~~

A second approach for lists:

~~~bash
my_list="  42 -18  63      72 9        "
len=${#my_list[@]}

echo " elements: "
for (( i=0; i<${len}; i++ )); do
  echo ${my_list[$i]}
done
echo " " 
~~~


##### An Array


~~~bash
varArray=( 42 -18  63      72 9  )
len=${#varArray[@]}

echo " elements: "
for (( i=0; i<${len}; i++ )); do
  echo ${varArray[$i]}
done
echo " "
~~~


#### Case 2:  Two or More Collections That Have to Remain In-Sync

The setup is as follows.

- There are multiple arrays.
- The ith element of each array go together.
- So we must step through each array in unison.

So we need indexes for each array.

One could also do this with lists, but we
choose arrays for this example.




~~~bash
#!/bin/bash


## Names of cities.
citiesArray=(
"Houston"
"Miami"
"Chicago"
     )

## Names of states.
statesArray=(
  "TX"
  "FL"
  "IL"
)

## Zip codes.
zipCodesArray=(
    12345
    78235
    61801
)


## Length of arrays.
lengtha=${#citiesArray[@]}

echo " lengtha: "  $lengtha
echo " "
echo " mail letters to: "
for (( q=0; q < lengtha; q++))
do
    echo "${citiesArray[q]}, ${statesArray[q]}    ${zipCodesArray[q]}"
done
echo " "
~~~

