/+ dub.sdl:
    name "ghi"
    type "executable"
 +/
/++ GitHub Issues

    Простая утилита для получения открытых issue с github.
    Используется только стандартная библиотека.

    Запустите в директории с проектом, который лежит на github

        rdmd /path/to/ghi.d

    Флаги:
    -u<user> --user=<user>  имя пользователя
    -p<proj> --proj=<proj>  название проекта

    Если не указаны флаги:

    имя пользователя проверяется сначала в локальном .git/config,
    затем в ~/.gitconfig, если и там нет, то используется имя пользователя

    название проекта берётся из .git/config, если там нет строки `url = ...`,
    то берётся название директории
 +/
import std.stdio;
import std.algorithm;
import std.range;
import std.string;
import std.json;
import std.getopt;
import std.format;
import std.file : exists;
import std.conv;
import std.path;
import std.process : environment;

static import std.net.curl;

int main(string[] args)
{
    string ghaddr = "https://api.github.com";

    auto prjData = getProjectData(args);

    string user = prjData[0];
    string repo = prjData[1];

    writeln();
    writefln("Issues for %s/%s ", user, repo);
    writeln();

    try
    {
        const req = "%s/repos/%s/%s/issues".format(ghaddr, user, repo);
        auto data = parseJSON(std.net.curl.get(req));
        foreach (el; data.array)
        {
            if ("pull_request" !in el && el["state"].str == "open")
            {
                auto header = text(el["number"].integer, " - ", el["title"].str);
                writeln(header);
                writefln("%-(%s%)", "-".repeat((to!(dchar[])(header)).length));
                writeln(el["body"].str);
                writeln("\n");
            }
        }
    }
    catch (Exception e)
    {
        stderr.writeln("error: ", e.msg);
        return 1;
    }
    return 0;
}

string[2] getProjectData(ref string[] args)
{
    string[2] ret;

    getopt(args, std.getopt.config.passThrough,
            "u|user", &ret[0],
            "p|proj", &ret[1]
            );

    if (ret[0].length) writeln("user from args");
    else ret[0] = getGitUser();

    if (ret[1].length) writeln("proj from args");
    else ret[1] = getProject();

    return ret;
}

string getGitUser()
{
    auto envuser = environment["USER"];

    auto cfgs =
    [
        "./.git/config",
        "/home/%s/.gitconfig".format(envuser)
    ];

    foreach (cfg; cfgs) try
    {
        auto u = readUserName(cfg);
        writefln("user from git config '%s'", cfg);
        return u;
    }
    catch (Exception e)
        stderr.writefln("check '%s': %s", cfg, e.msg);

    writeln("user from environment");
    return envuser;
}

string readUserName(string gitconfig)
{
    foreach (ln; File(gitconfig).byLine.map!strip)
        if (ln.startsWith("name = "))
            return ln.chompPrefix("name = ").strip.idup;
    throw new Exception("no name field");
}

string getProject()
{
    auto cfg = "./.git/config";
    try
    {
        foreach (ln; File(cfg).byLine.map!strip)
            if (ln.startsWith("url = "))
            {
                writeln("project from first url from local git config");
                return ln.chompPrefix("url = ")
                         .strip
                         .baseName
                         .idup
                         .stripExtension;
            }
    }
    catch (Exception e) {}

    return ".".absolutePath.dirName.baseName;
}
