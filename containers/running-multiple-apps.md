# Containers on ARC Clusters

# ---- IN PROGRESS ----

##### Navigate

[Back to Main Page](./main-containers.md)



## More on Exec


If one has multiple applications, and therefore multiple entry points
(one for each app),
you want to use `%apprun` rather than `%runscript` in the definition file.

For example, defining `%apprun foo` and `%apprun bar` allows you to run
them specifically using `apptainer run --app foo <container>` 
or `apptainer run --app bar <container>`.


```
https://www.google.com/search?q=can+there+be+multiple+entries+under+%25runscript+in+an+apptainer+definition+file%3F&rlz=1C5GCEM_enUS1148US1149&oq=can+there+be+multiple+entries+under+%25runscript+in+an+apptainer+definition+file%3F&gs_lcrp=EgZjaHJvbWUyBggAEEUYOTIHCAEQIRiPAjIHCAIQIRiPAtIBCTE3MzcxajBqN6gCCLACAfEFK3-ZZ7yR63k&sourceid=chrome&ie=UTF-8
```



Also show, on a separate page, multiple `%runscript` blocks.
You can have as many blocks as you want.
But they are all put in a sequence and they are ALL run with the 
`apptainer run` command.








##### Navigate

[Back to Main Page](./main-containers.md)


