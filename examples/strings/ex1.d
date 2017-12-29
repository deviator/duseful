/+ Задача:
    из массива строк выбрать строки, начинающиеся на заданную подстроку,
    конвертировать оставшующся часть в CamelCase
 +/
import std.stdio : writeln;
import std.string : strip, split, chompPrefix, join, capitalize;
import std.algorithm : map, filter, startsWith;
import std.array : array;

string toCamelCase(string str, bool capFirst=false, string sep="_")
{
    auto words = str
                    .strip // убираем начальные и конечные пробельные символы
                    .split(sep); // разбиваем по sep на части

    // typeof(words).stringof -- string[] -- immutable(char)[][]
    // мы можем менять строки на новые, но не данные внутри строки

    // ref позволяет изменить элемент массива
    foreach (i, ref word; words)
    {
        if (i == 0 && !capFirst) continue;
        word = word.capitalize;
    }
    return words.join;
}

unittest
{
    assert ("hello_world".toCamelCase == "helloWorld");
    assert ("hello_world".toCamelCase(true) == "HelloWorld");
    assert ("_hello_world".toCamelCase(true) == "HelloWorld");
}

string[] ex1func(const string[] input, string pref)
{
    return input
            .filter!(a=>a.startsWith(pref)) // только те, что начинаются на pref
            .map!(a=>a.chompPrefix(pref)) // обрезаем pref
            .map!(a=>a.toCamelCase) // оставшуюся часть в CamelCase
            .array; // map вернёт range, превращаем в массив
}

void main()
{
    immutable input = [
        "gen_auto_value",
        "gen_out_temp",
        "gen_in_temp",
        "variable",
        "gen_constant",
        "other_data"
    ];

    immutable pref = "gen_";

    writeln(input.ex1func(pref));
}