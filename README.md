# count-hours
A simple program to keep track of work hours.

## Compilation
Simply get ahold of dub and run `dub build --build=release`.

## Functionality
Read a file or stdin, count the durations on each line, and print
the result. The time format is "[HH:MM]-[HH:MM]".
```
$ count-hours
> 12:15-15:21
> 15:30-19:00
> ^D
> 6 hours, 36 minutes
$ count-hours hours-test.txt
> 16 hours, 57 minutes
$ cat hours-test.txt | count-hours
> 16 hours, 57 minutes
```
