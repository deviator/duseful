/++ Некоторые приёмы, часто используемые в языке D и совсем немного векторной алгебры

    для запуска кода вместе с тестами

        rdmd -unittest -main vector.d
 +/
module vector;

import std.stdio : writeln; // указывать импортируемые имена -- хороший стиль
import std.math : hypot, abs, sqrt;
import std.range : isInputRange, ElementType, take;
import std.algorithm : map, sum, equal;
import std.string : join, format;

// документирующие коментарии /++ +/ /** */ или ///
// позволяют генерировать документацию из исходного кода

/++ Математический вектор

    имена структур и классов с большой буквы

    Params:
        N - количество компонент
 +/
struct Vec(size_t N)
    if (N >=2 && N <= 4) // ограничение шаблонного параметра (количество компонент вектора)
{
    // для удобства теперь вместо полного типа внутри структуры можно использовать SType
    alias SType = Vec!N;

    // имена полей и методов с маленькой, camelCase
    float[N] data;

    // в случаях, когда будет требоваться массив будет автоматически подставляться data
    // тоесть вместо foo(myvector.data) можно писать foo(myvector), когда foo принимает
    // статический массив float'ов
    alias data this;

    // тестирующие блоки можно включать в тело классов или структур
    // в текущем случае будет инстанцированно 3 разных теста (для N=2,3,4)
    unittest
    {
        SType a;
        a[0] = 1;
        // обращаться по индексу нам даёт "alias data this"
        // по сути происходит замена такой записи на a.data[0]
        a[1] = 2;
        // а здесь на a.data[0..2] -- срез массива
        assert (equal(a[0..2], [1,2]));
        static assert (is(typeof(a[0..2]) == float[]));
    }

/+ 
    pure -- чистая функция -- не используются внешние данные (изменяемые
            глобальные переменные), только поля структуры и аргументы,
            используется для указанию компилятору возможности оптимизации
    @safe -- безопасный код -- запрет использования алгебры указателей
             и некоторых других низкоуровневых фич
    nothrow -- код не выбрасывает исключений, что позволяет компилятору
               оптимизировать код соответствующим образом
    @nogc -- код не выделяет память через сборщик мусора (new)

    В подавляющем большинстве случаев, если это не требует внешний код
    (код используемой библиотеки, например) можно обойтись без этих
    атрибутов.
 +/
pure @safe nothrow @nogc:

    /+ конструктор

        "..." указывает на то, что можно для массива не указывать квадратные
        скобки, тоесть запись будет выглядеть так Vec!3(1, 2, 3), что будет
        эквивалентно Vec!3([1, 2, 3])
     +/
    this(float[N] vals...) { data = vals; }

    @property // метод-свойсво
    {
        // inout позволяет использовать один и тот же метод как для const
        // так и для обычных mutable объектов
        ref x() inout { return data[0]; }
        ref y() inout { return data[1]; }

        // в зависимости от шаблонного параметра можем добавлять методы и поля
        static if (N >= 3)
            ref z() inout { return data[2]; }

        static if (N >= 4)
            ref w() inout { return data[3]; }
    }

    // статический метод может быть вызван как `Vec!2.zero`
    // @property позволяет использовать как метод как поле
    static SType zero() @property
    {
        SType ret;
        ret.data[] = 0;
        return ret;
    }

    /+ opOpAssign вызывается, когда встречается код вида `a += b;`
       операция как строка передаётся через шаблонный параметр `op`

       `auto ref` позволяет в шаблонной фукнции компилятору выбирать
       вставлять ссылку или передавать аргумент копированием
     +/
    ref opOpAssign(string op)(auto ref const Vec!N b)
    {
        /+ mixin используется для вставки кода как строки, которую
           можно вычислить во время компиляции, т.е. если `op == "+"` (`a += b;`),
           то mixin первратится во вставку строки `this = this + b;`
        +/
        mixin(`this = this ` ~ op ~ `b;`);
        return this;
    }

    // шаблонный параметр T должен приводиться к float (вариант ограничения 
    // сигнатуры шаблонный функции)
    ref opOpAssign(string op, T:float)(auto ref const T b)
    {
        mixin (`this = this ` ~ op ~ `b;`);
        return this;
    }

const: // методы не изменяют поля структуры

    // операция вида `-a`
    SType opUnary(string op)()
        if (op == "-") // ограничения на значение шаблонного параметра
    {
        SType ret;
        ret.data[] = data[] * -1;
        return ret;
    }

    // операции вида `a + b`, где `a` и `b` это Vec!N
    SType opBinary(string op)(auto ref const Vec!N b)
    {
        SType ret;
        static pure string mixstr()
        {
            string[] r;
            foreach (i; 0 .. N)
                r ~= format(`ret.data[%1$d] = data[%1$d] ` ~ op ~ `b.data[%1$d];`, i);
            return r.join("\n");
        }
        mixin(mixstr());
        return ret;
    }

    // операции вида `a + b`, где `a` это Vec!N, `b` это число
    SType opBinary(string op, T:float)(auto ref const T b)
    {
        SType ret;
        static pure string mixstr()
        {
            import std.string : join, format;
            string[] r;
            foreach (i; 0 .. N)
                r ~= format(`ret.data[%1$d] = data[%1$d] ` ~ op ~ `b;`, i);
            return r.join("\n");
        }
        mixin(mixstr());
        return ret;
    }

    @property
    {
        // квадрат длины вектора
        float len2() { return data[].map!(a=>a^^2).sum; }

        // евклидова длина вектора
        float len()
        {
            static if (N == 2) return hypot(x, y);
            else return sqrt(len2);
        }
    }
}

// скалярное произведение
auto dot(size_t N)(auto ref const Vec!N a, auto ref const Vec!N b)
    pure nothrow @nogc
{ return (a * b)[].sum; }
// a * b даёт вектор, каждая компонента которого это произведение соответствующих компонент a и b
// [] -- операция взятия всего среза (в данном случае "конвертация" статического массива в динамический)
// уже динамические массивы и диапазоны может обработать метод sum (суммировать элементы)

// короче на 1 символ (писать Vec2 вместо Vec!2), но всё равно приятней =)
alias Vec2 = Vec!2;
alias Vec3 = Vec!3;
alias Vec4 = Vec!4;

/+ блоки тестирования, очень удобно сразу записывать проверку кода,
   в дальнейшем это позволяет заранее устранять ошибки и быть уверенным
   что код работает именно так, как это планировалось
 
   для компиляции с исполнением тестовых блоков необходимо указать
   либо флаг компиляции

      rdmd -unittest file.d

   в случае, если в файле нет функции main, следует добавить флаг,
   генерирующий её

      rdmd -unittest -main file.d

   либо через dub

      dub test
 +/
unittest
{
    Vec2 a, b;
    /+ __traits(compiles, a + b) возвращает true если выражение `a + b`
       компилируется, иначе false

       static assert позволяет произвести проверку во время компиляции
     +/
    //static assert (!__traits(compiles, a + "hello"));
    //static assert ( __traits(compiles, a + b));
    auto c = a.opBinary!"+"(b);
}

unittest
{
    auto a = Vec2(1,2) + Vec2(3,4);

    // операции с плавающей точкой не могут быть выполнены точно
    // из-за ограничения представления чисел с плавающей точкой в бинарном виде
    // поэтому необходимо быть аккуратным при проверке на равенство

    immutable eps = float.epsilon; // наименьшее значащее число

    assert (abs(a.x - 4) < eps);
    assert (abs(a.y - 6) < eps);
    auto b = a / 2;
    assert (abs(b.x - 2) < eps);
    assert (abs(b.y - 3) < eps);
    b *= 3;
    assert (abs(b.x - 6) < eps);
    assert (abs(b.y - 9) < eps);
}

// имеет смысл проверять каждую функцию, даже если она достаточно проста
unittest
{
    auto a = Vec2(3,4);
    assert (abs(a.len - 5) < float.epsilon);
}

unittest
{
    auto a = Vec3(1,2,3);
    auto b = Vec3(3,6,5);
    assert (abs(dot(a,b) - (1*3+2*6+3*5)) < float.epsilon);
}

// вычисление цетра последовательности точек
auto center(R)(R rng)
    if (isInputRange!R && is(ElementType!R == Vec!N, size_t N))
    // isInputRange проверяет соответствие "интерфейсу" диапазона (input range):
    // тип должен содержать свойства front, empty и метод popFront, это позволяет
    // его использовать в foreach, ElementType!R возвращает тип элемента диапазона
    // он должен соответствовать выражению Vec!N, где N это size_t
{
    auto s = ElementType!R.zero;
    size_t n;
    foreach (v; rng)
    {
        s += v;
        n++;
    }
    return s / n;
}

unittest
{
    // метод center принимает массивы
    // UFCS, можно вызвать center как поле
    assert (([Vec2(1,1), Vec2(1,0), Vec2(0,1), Vec2(0,0)].center
                - Vec2(.5,.5)).len2 < float.epsilon);
}

unittest
{
    assert (([Vec3(1,1,1), Vec3(0,0,0)].center - Vec3(.5,.5,.5)).len2 < float.epsilon);
}

/+
    так называемые диапазоны (range) представляют из себя абстракцию,
    с которой можно работать с помощью foreach (пройтись по всем
    значениям)

    смысл в том, что реализация диапазона может быть совершенно
    не похожа на массив (вся последовательность данных не хранится,
    каждое следующее значение генерируется "на лету")
+/

// бесконечный диапазон случайных точек
struct RandomPoints(size_t N)
    if (is(Vec!N)) // если Vec!N является валидным типом
{
    float minVal = -1.0, maxVal = 1.0;

    // "текущий" элемент, начало последовательности
    Vec!N front = Vec!N.zero; // для isInputRange front может быть просто полем

    // пуста ли последовательность 
    bool empty() @property { return false; } // можно сделать метод-свойство
    
    // можно сделать полем, но не константным
    //bool empty = false;

    // "убирает" текущий элемент, заменяя его новым
    void popFront()
    {
        import std.random : uniform;
        foreach (i; 0 .. N)
            front[i] = uniform!"[]"(minVal, maxVal);
    }
}

/+ необычный unittest, так как присутствует вывод в консоль
   обычно так не нужно делать, unittest'ы должны что-либо печатать
   лишь при ошибках, но здесь это будет заменять функцию main,
   а сделанно это unittest'ом чтобы удобней было включать в
   другие файлы
 +/
unittest
{
    auto rp = RandomPoints!3(-100, 100);
    rp.popFront(); // кладём во front случайную точку

    // берём 10 случайный точек, вычисляем центр, получаем расстояние от начала координат
    writeln(rp.take(10).center.len);
    // 100 точек
    writeln(rp.take(100).center.len);
    // c увеличением числа точек центр в стреднем должен приближаться к началу координат
    writeln(rp.take(1000).center.len);
    writeln(rp.take(10000).center.len);
    writeln(rp.take(100000).center.len);
    writeln(rp.take(1000000).center.len);
}