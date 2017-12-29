/+ Задача:
    написать функцию форматирования текста по ширине

   запуск примера
    
    rdmd ex3.d -w42
 +/

import std.stdio : writeln;
import std.string : join, split, strip, splitLines;
import std.algorithm : map, sum, max;
import std.getopt;
import std.range : repeat, walkLength, zip;
import std.array : array;

// выравниватель
struct WidthAdjuster
{
    // требуемая ширина текста
    size_t width;

    // текущая строка
    private string[] line;

    // добавить слово к строке
    // strip обрезает пробельные символы в начале и конце строки
    void appendWord(string word) { line ~= word.strip; }

    // сброс текущей строки
    void reset() { line.length = 0; }

    // можем ли добавить слово к строке
    bool canAppend(string word) const
    {
        // если ничего нет, то любое слово можно добавить
        if (line.length == 0) return true;
        /+ иначе вычисляем текущую минимальную длину строки (единичные пробелы)
           и складываем с длиной переданного слова + 1 (пробел между имеющейся
           строкой и новым словом)

           для определения количества символов в строке необходимо
           использовать walkLength, так как один символ unicode может
           быть закодирован несколькими char'ами 
         +/ 
        return line.lineLength + 1 + word.strip.walkLength <= width;
    }

    string build() const @property { return adjustLine(line, width).join(); }
}

size_t lineLength(const(string[]) ln)
{
    return ln.map!(a=>a.walkLength).sum + // каждое слово мапим в его длину и суммируем
            ln.length + (ln.length ? -1 : 0); // добавляем минимальное чилсо пробелов
}

string[] adjustLine(const(string[]) ln, size_t width)
{
    // одно слово выровнять не получится
    if (ln.length == 1) return ln.dup;

    assert (width >= ln.lineLength);

    // получим пробелы между каждой парой слов
    auto add = spaceDistrib(width - ln.lineLength, ln.length);

    return zip(ln, add) // попарно берём слово и пробел за ним
            .map!(a=>[a[0], a[1]]) // получившийся tuple делаем массивом
            .join; // соединяем массивы в один
}

// передаём пробелы, которые нужно распределить и количество слов
auto spaceDistrib(size_t need, size_t count)
{
    // возвращаем range
    struct Result
    {
        size_t count, add;
        string longSpace, shortSpace;

        this(size_t n, size_t c)
        {
            count = c;
            auto bais = n / (c-1); // 13/5=2
            add = n % (c-1); // 13%5=3 -- между 3-мя парами должно быть bais+1

            longSpace = ' '.repeat(bais + 2).array;
            shortSpace = ' '.repeat(bais + 1).array;
        }

        @property
        {
            bool empty() { return count == 0; }

            string front()
            {
                // после последнего слова пробел не нужен
                if (count == 1) return "";
                else if (add) return longSpace;
                else return shortSpace;
            }
        }

        void popFront()
        {
            count--;
            if (add) add--;
        }
    }

    return Result(need, count);
}

string formatWidth(string text, size_t width)
{
    string[] res;

    // можно читать из файла по строкам и разбивать на слова
    auto words = text.strip.splitLines.map!strip.join(" ").split;

    auto wa = WidthAdjuster(width);
    foreach (word; words)
    {
        // обрабатываем по отдельному слову
        if (wa.canAppend(word))
            wa.appendWord(word);
        else
        {
            res ~= wa.build; // тут можно писать в выходной файл
            wa.reset;
            wa.appendWord(word);
        }
    }
    res ~= wa.build; // не забываем про последнюю строку

    return res.join("\n");
}

void main(string[] args)
{
    auto text = `
    D (Ди) — мультипарадигмальный компилируемый язык
    программирования,
    созданный Уолтером Брайтом из компании Digital Mars.
    Начиная с 2006 г. соавтором также является
    Андрей Александреску.
    Изначально D был задуман как реинжиниринг языка
    C++, однако, несмотря на значительное
    влияние С++, не является его вариантом.
    Также язык испытал влияние концепций из языков программирования
    Python, Ruby, C#, Java, Eiffel.
    `;

    size_t width = 40;
    getopt(args, "w|width", &width);
    writeln(text.formatWidth(width));
}