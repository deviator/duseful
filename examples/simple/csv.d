import std.stdio : writeln, writefln;
import std.file : readText;
import std.csv;
import std.typecons : Tuple;

void main()
{
    auto text = "example.csv".readText;

    auto csv1 = csvReader!(Tuple!(string, string, float))(text, null);

    foreach (ln; csv1)
        writeln(ln[0], " ", ln[2]);

    writeln();

    auto csv2 = csvReader!(string[string])(text, null);

    writeln();
    writeln("Заголовки столбцов");
    writefln("%(%s, %)", csv2.header);
    writeln();

    foreach (ln; csv2)
        writeln(ln["Наименование"], " ", ln["Цена за кг руб"]);
}