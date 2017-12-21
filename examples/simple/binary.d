import std.stdio : writeln;

enum fname = "example.bin";
enum MAX_DATA = 1024;

void variant1()
{
    import std.stdio : File;

    auto f = File(fname, "rb");
    scope (exit) f.close();

    auto buffer = new ubyte[](MAX_DATA);
    auto data = f.rawRead(buffer);
    writeln(data);
}

void variant2()
{
    import std.file : read;
    // read возвращает void[], поэтому кастуем к
    // типу, который можем распечатать (ubyte[])
    auto data = cast(ubyte[])fname.read(MAX_DATA);
    writeln(data);
}

void main()
{
    variant1();
    variant2();
}