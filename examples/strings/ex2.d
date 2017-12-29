/+ Задача:
    заменить значение в пути
 +/
import std.stdio : writeln;
import std.path : buildNormalizedPath, pathSplitter;
import std.array : array;

string ex2func(string input)
{
    // pathSplitter возвращает range, сделаем массив из него
    auto path = input.pathSplitter.array;
    if (path.length == 3)
        path[1] = "other"; // второй элемент пути меняем
    return buildNormalizedPath(path); // собираем обратно путь
}

void main()
{
    auto path = buildNormalizedPath("examples", "strings", "ex2.d");
    // для windows должны быть обратные слеши
    writeln(path, " -> ", ex2func(path));
}