# count-hours
A simple program to keep track of work hours.

## Compilation
Simply get ahold of dub and run `dub build --build=release`.

## Functionality
Can take in input manually and optionally write it out,
or can read in a file. For example:
```
./count-hours -w
# interactive session here
ls
# file called "hours-[date].txt"
./count-hours --read hours-[date].txt
```
