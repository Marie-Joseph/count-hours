import core.time : Duration, dur;
import std.array : split;
import std.conv : to;
import std.datetime.date : TimeOfDay;
import std.stdio : File, stderr, stdin, stdout, writeln;

void main(string[] args) {
    try {
        File fptr = args.length == 2 ? File(args[1], "r") : stdin;
        Duration acc;
        foreach (line; fptr.byLine) {
            string[2] splitLine = line.to!string.split("-");
            acc += TimeOfDay.fromISOExtString(splitLine[1] ~ ":00") -
                   TimeOfDay.fromISOExtString(splitLine[0] ~ ":00");
        }
        long hours = acc.total!"hours";
        long minutes = (acc - dur!"hours"(hours)).total!"minutes";
        stdout.writeln(hours.to!string,
                       hours == 1 ? " hour, " : " hours, ",
                       minutes.to!string,
                       minutes == 1 ? " minute" : " minutes");
    } catch (Exception e) {
        stderr.writeln("count-hours: ", e.msg);
    }
}
