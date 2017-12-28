/+ Пример работы через механизмы std.concurrency

   см так же glob.d и queue.d
 +/
import std.concurrency;
import std.stdio;
import std.datetime;

class Model
{
private:
    float _value = 0.01f;
public:

    this() { }
    void step() { _value = algo(_value); }
    float value() const @property { return _value; }

    // не будем усложнять по примеру glob и queue
    float algo(float v)
    {
        import core.thread;
        Thread.sleep(200.msecs);
        return v * 1.01;
    }
}

struct Finish {}
struct GetValues {}

void runModel()
{
    auto model = new Model;
    auto done = false;
    float[] values;
    while (!done)
    {
        model.step;
        values ~= model.value;
        receiveTimeout(20.msecs,
                        (Finish v){ done = true; },
                        (GetValues v)
                        {
                            send(ownerTid, values.idup);
                            values.length = 0;
                        }
                      );
    }
}

void main()
{
    auto mdltid = spawn(&runModel);

    C: while (true)
    {
        writeln("use commands: stop(s), help(h), print(p)");
        import std.string : strip;
        auto str = stdin.readln().strip;
        switch (str)
        {
            case "stop": case "s": break C;
            case "print": case "p":
                send(mdltid, GetValues.init);
                writeln(receiveOnly!(immutable(float)[]));
                break;
            case "help": case "h":
                writeln("'stop' or 's' -- exit program");
                writeln("'help' or 'h' -- show this help");
                writeln("'print' or 'p' -- print calculated model value");
                break;
            default: 
                writeln("unknown command: '", str, "'");
        }
    }

    // при выходе из ui-цикла завершаем вычисления
    send(mdltid, Finish.init);
}