import core.time : Duration, dur;
import std.algorithm : fold, map;
import std.array : split;
import std.conv : to;
import std.datetime.date : TimeOfDay;
import std.file : readText;
import std.stdio : File, stdin, stdout, writeln;
import std.string : splitLines;

void main(string[] args) {
    File fptr = args.length == 2 ? File(args[1], "r") : stdin;
    Duration acc;
    foreach (line; fptr.byLine) {
        string[2] splitLine = line.to!string.split("-");
        acc += TimeOfDay.fromISOExtString(splitLine[1] ~ ":00") -
                 TimeOfDay.fromISOExtString(splitLine[0] ~ ":00");
    }
    long hours = acc.total!"hours";
    long minutes = (acc - dur!"hours"(hours)).total!"minutes";
    string toPrint = hours == 1 ?
                     hours.to!string ~ " hour, " :
                     hours.to!string ~ " hours, ";
    toPrint ~= minutes == 1 ?
               minutes.to!string ~ " minute" :
               minutes.to!string ~ " minutes";
    stdout.writeln(toPrint);
}
