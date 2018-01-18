/+ dub.sdl:
    name "rmknown"
    type "executable"
 +/
/++ Удаляет строки из файла .ssh/known_hosts, если находит в них
    переданную программе строку (по замыслу это IP адрес, но может
    быть любая строка)
 +/
import std.stdio;
import std.path;
import std.file;
import std.process : environment;
import std.algorithm;

enum knownHosts = ".ssh/known_hosts";

int main(string[] args)
{
    if (args.length != 2)
    {
        stderr.writeln("use:\nrmknown <IP>");
        return 1;
    }

    auto IP = args[1];

    auto fname = buildNormalizedPath(environment["HOME"], knownHosts);

    auto orig = fname ~ ".back";
    rename(fname, orig);

    auto src = File(orig, "r");
    auto dst = File(fname, "w");

    foreach (ln; src.byLine)
        if (!ln.canFind(IP))
            dst.writeln(ln);
    dst.close();

    return 0;
}
