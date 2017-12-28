// Синтетический пример многопоточного подсчёта суммы простых чисел
import core.thread : Thread;
import std.stdio : writeln;
import std.getopt;
import std.datetime.stopwatch : StopWatch, AutoStart;

/+ synchronized заставляет компилятор обернуть каждый вызов методов
   в блок синхронизации по внутреннему mutex класса и неявно подставить
   shared для всех методов
 +/
synchronized class Summator
{
    private size_t sum;
    void add(size_t val) { sum += val; }
    size_t value() const @property { return sum; }
}

class PrimeCalcThread : Thread
{
    // объекты класса Summator должны быть отмеченны как shared
    private shared Summator sum;
    private size_t start;
    private size_t end;

    this(shared Summator sum, size_t start, size_t end)
    {
        this.sum = sum;
        this.start = start;
        this.end = end;
        writeln(start, " ", end);
        super(&run);
    }

    // собственно код потока
    private void run()
    {
        foreach (i; start..end)
            if (i.isPrime) sum.add(i);
    }
}

bool isPrime(T:ulong)(T val) pure @safe @nogc nothrow
{
    foreach_reverse (i; 2 .. val)
        if (val % i == 0) return false;
    return true;
}

void main(string[] args)
{
    size_t threadCount = 4;
    size_t maxValue = 50_000;

    /+ из командной строки можно запускать так

        rdmd calcsum.d -t8 -m20000

        rdmd calcsum.d --threads=16 -m80000

        rdmd calcsum.d -t32 --max=10000
     +/
    getopt(args, "t|threads", &threadCount, "m|max", &maxValue);

    writeln("threads: ", threadCount);
    writeln("max num: ", maxValue);

    auto sum = new shared Summator;

    Thread[] th;

    auto step = maxValue / (threadCount ? threadCount : 1);

    foreach (i; 0..threadCount)
        th ~= (cast(Thread)(new PrimeCalcThread(sum, i*step, (i+1)*step)));

    auto sw = StopWatch(AutoStart.yes);

    foreach (t; th) t.start();
    foreach (t; th) t.join();

    writeln(sw.peek);

    writeln(sum.value);
}