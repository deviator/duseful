/+ Пример работы через разделяемую глобальную очередь

   см так же simpleglob.d
 +/
import std.stdio;
import core.thread;
import core.sync.mutex;

class Model
{
private:
    float _value = 0.01f;
    shared Queue!float queue;

    // эта очередь нужна только для быстрого прерывания вычислений algo
    shared Queue!bool done;

public:

    this(shared Queue!float queue, shared Queue!bool done)
    {
        this.queue = queue;
        this.done = done;
    }

    void step()
    {
        _value = algo(_value);
        queue.push(_value);
    }

    float value() const @property { return _value; }

    float algo(float v)
    {
        /+ для того чтобы алгоритм мог завершить работу при
           выставлении флага в очереди done мы проверяем его
           достаточно часто и в случае если выставлен выходим
           из метода

           иначе при выходе из программы мы будем долго ждать
         +/
        foreach (i; 0 .. 200)
        {
            if (done.length) return v;
            // эмуляция долгой работы алгоритма (200 * 10.msecs = 2.seconds)
            Thread.sleep(10.msecs);
        }
        return v * 1.01;
    }
}

// класс очереди
synchronized class Queue(T)
{
    private T[] buf;
    void push(T)(T val) { buf ~= val; }
    size_t length() const @property { return buf.length; }
    immutable(T)[] popAll()
    {
        scope(exit) buf.length = 0;
        return buf.idup;
    }
}

void runModel(shared Queue!float queue, shared Queue!bool done)
{
    auto model = new Model(queue, done);
    while (!done.length)
        model.step;
}

void main()
{
    auto queue = new shared Queue!float;
    auto done = new shared Queue!bool;

    // создаём и сразу запускаем поток
    auto th = new Thread({ runModel(queue, done); }).start;

    C: while (true)
    {
        writeln("use commands: stop(s), help(h), print(p)");
        import std.string : strip;
        auto str = stdin.readln().strip;
        switch (str)
        {
            case "stop": case "s": break C;
            case "print": case "p":
                writeln(queue.popAll);
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
    done.push(true);

    // ждём завершения второго потока
    th.join();
}
