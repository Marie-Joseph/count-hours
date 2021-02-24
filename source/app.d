import core.time : Duration;
import std.array : split;
import std.conv : to;
import std.datetime.date : Date, TimeOfDay;
import std.datetime.systime : Clock;
import std.format : format;
import std.file : exists, isFile, readText;
import std.string : splitLines;
import std.stdio : File, readln, stderr, stdout, write, writeln;

/// Calculate hours worked
int main(string[] args) {

    bool writeOut;
    File outFile;
    if ((args.length == 2) && ((args[1] == "-w") || (args[1] == "--write"))) {
        writeOut = true;
        string date = Clock.currTime().to!Date.toISOExtString();
        outFile = File(format!"hours-%s.txt"(date), "w");
    } else if (args.length == 2) {
        stderr.writeln("Usage: ./count-hours [[-w|--write] | [-r|--read] filename]");
        return 1;
    }

    Duration timeWorked;
    if ((args.length == 3) && ((args[1] == "-r") || (args[1] == "--read"))) {
        try {
            timeWorked = readIn(args[2]);
        } catch (Exception e) {
            stderr.writeln("count-hours: ", e.msg);
            return 2;
        }
    } else if (args.length >= 3) {
        stderr.writeln("Usage: ./count-hours [[-w|--write] | [-r|--read] filename]");
        return 1;
    } else {
        while (true) {
            try {
                stdout.write("Start time (format HH:MM): ");
                TimeOfDay startTime = getTime();

                stdout.write("Finish time (format HH:MM): ");
                TimeOfDay finishTime = getTime();

                timeWorked += finishTime - startTime;

                if (writeOut)
                    outFile.writeTo(startTime, finishTime);

                stdout.write("Done? (y/n): ");
                if (readln()[0] == 'y')
                    break;

            } catch(Exception e) {
                stderr.writeln("count-hours: ", e.msg);
                continue;
            }
        }
    }
    report(timeWorked);

    return 0;
}

/**
Report the total time

Params:
    total = Duration to report
*/
void report(Duration total) {
    stdout.writeln("Total time: ", total.toString());
}

/**
Reads in a given hours file and counts the hours worked

Params:
    inFile = filename to be read
    delim = string delimeter to split lines on; defaults to "-"

Returns: Duration representing total time worked
*/
Duration readIn(string inFile, string delim = "-") {
    Duration timeWorked;
    foreach (line; readText(inFile).splitLines) {
        string[2] splitLine = line.split(delim);
        TimeOfDay start = TimeOfDay.fromISOExtString(splitLine[0] ~ ":00");
        TimeOfDay finish = TimeOfDay.fromISOExtString(splitLine[1] ~ ":00");

        timeWorked += finish - start;
    }

    return timeWorked;
}
unittest {
    import core.time : hours, minutes;
    assert(readIn("test/hours-test.txt") == (hours(16) + minutes(57)));
}

/**
Write out the given TimeOfDays in format "HH:MM-HH:MM"

Params:
    outFile = File object opened for writing
    start = TimeOfDay
    finish = TimeOfDay
*/
void writeTo(File outFile, TimeOfDay start, TimeOfDay finish) {
    string startStr = start.toISOExtString();
    startStr = startStr[0 .. startStr.length - 3];

    string finishStr = finish.toISOExtString();
    finishStr = finishStr[0 .. finishStr.length - 3];

    outFile.writeln(startStr ~ "-" ~ finishStr);
}

/**
Get an input time from user

Returns: input converted to a TimeOfDay object
*/
TimeOfDay getTime() {
    string buf = readln();
    return TimeOfDay.fromISOExtString(buf[0 .. buf.length - 1] ~ ":00");
}
