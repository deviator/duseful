import std.stdio : writeln;
import std.json;
import std.file : readText;

void main()
{
    // используем UCFS -- uniform call function syntax
    // можно было бы записать так:
    //            parseJSON(readText("example.json"));
    JSONValue j = "example.json".readText.parseJSON;

    // удостоверимся, что тип поля "one" -- целое число
    assert(j["one"].type == JSON_TYPE.INTEGER);

    // используем поле "one" как целое число
    writeln(j["one"].integer + 321);
}