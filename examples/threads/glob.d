/+ Пример работы через глобальный разделяемый объект
   старый подход, чреват усложнением программы

   см так же queue.d и usestd.d
 +/
import std.stdio;
import core.thread;
import core.sync.mutex;

// shared распостраняется на все поля и методы класса
shared class Model
{
private:
    float _value = 0.01f;
    bool done = false; // флаг завершения работы

    // shared Mutex
    Mutex valMutex, // на каждую логическую единицу
          doneMutex; // по своему mutex'у

public:

    this()
    {
        valMutex = new shared Mutex;
        doneMutex = new shared Mutex;
    }

    void step()
    {
        float tmpVal;

        // чтобы надолго не занимать ресурс "значение"
        // мы копируем его в переменную
        synchronized (valMutex) tmpVal = _value;

        // используем переменную как хотим
        tmpVal = algo(tmpVal);

        // затем обратно в поле "значение"
        synchronized (valMutex) _value = tmpVal;
    }

    const @property
    {
        float value() { synchronized (valMutex) return _value; }
        // проверка завершения работы тоже защищается, но уже
        // своим собственным mutex'ом
        bool isDone() { synchronized (doneMutex) return done; }
    }

    void finish() { synchronized (doneMutex) done = true; }

    float algo(float v)
    {
        /+ для того чтобы алгоритм мог завершить работу при
           выставлении флага done мы проверяем его достаточно
           часто и в случае если выставлен выходим из метода

           иначе при выходе из программы мы будем долго ждать
         +/
        foreach (i; 0 .. 200)
        {
            synchronized (doneMutex)
                if (done) return v;
            // эмуляция долгой работы алгоритма (200 * 10.msecs = 2.seconds)
            Thread.sleep(10.msecs);
        }
        return v * 1.01;
    }
}

// глобальная разделяемая переменная (плохой подход в общем случае)
shared Model model;

void runModel() { while (!model.isDone) model.step; }

void main()
{
    model = new shared Model();

    // создаём и сразу запускаем поток
    auto th = new Thread(&runModel).start;

    C: while (true)
    {
        writeln("use commands: stop(s), help(h), print(p)");
        import std.string : strip;
        auto str = stdin.readln().strip;
        switch (str)
        {
            case "stop": case "s": break C;
            case "print": case "p":
                writeln(model.value);
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
    model.finish();

    // ждём завершения второго потока
    th.join();
}