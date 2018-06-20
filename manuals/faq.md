# FAQ для тех кто не теме

## Как массив байт перевести в структуру?

Имеется:

1. массив байт (полученный по сети, например)
1. структура без динамических массивов, указателей, делегатов и тд

```d
struct Foo
{
    float[3] coord;
    ulong time;
    ulong idx;
}
```

### Способ в одну строку

```d
Foo getFoo1(ubyte[] data) { return (cast(Foo[])cast(void[])data)[0]; }
Foo getFoo2(void[] data) { return (cast(Foo[])data)[0]; }
```

В этом случае нужно быть уверенным в том, что `data.length == Foo.sizeof`,
иначе эта функция выбросит исключение о несовпадении размеров
массивов при cast.

В случае, если нужно принять несколько структур должно выполняться
условие `data.length % Foo.sizeof == 0`.

```d
// аккуратно: результирующий массив будет указывать на ту же область
// памяти что и data
Foo[] getFoo(ubyte[] data) { return cast(Foo[])cast(void[])data; }
```

Так же это работает в обратном порядке:

```d
// аккуратно: выделяется память
ubyte[] getData(Foo foo) { return cast(ubyte[])cast(void[])[foo]; }
```

### Union

```d
union TBytes(T)
{
    void[T.sizeof] bytes;
    T value;
    this(const(void)[] data)
    {
        assert(data.length == bytes.length);
        bytes[] = data[];
    }
    this()(auto ref const(T) v) { value = v; }
    ubyte[] dupUbyte() { return cast(ubyte[])(bytes.dup); }
}
```

Переменная типа union хранит все свои поля на общей области памяти, т.е.
поля `bytes` и `value` будут физически лежать в одной области памяти.

```d
Foo getFoo2(void[] data) { return TBytes!Foo(data).value; }
```

```d
ubyte[] getData2(Foo foo) { return TBytes!Foo(foo).dupUbyte; }
```

## В чём отличие `void[]` от `ubyte[]`?

По сути и то и то массивы байт.
К `ubyte[]` можно обращаться поэлементно, к `void[]` нельзя:

```d
ubyte[] val1 = getSomeData1();
if (val1[42] == 15) { ... }
void[] val2 = getSomeData2();
// if (val2[42] == 15) { ... } -- ошибка
```

К `void[]` приводится любой массив неявно:

```d
void foo(void[] arr) { writeln(arr.length); }
void bar(ubyte[] arr) { writeln(arr.length); }
struct Baz { float[4] v; }
```

```d
auto val = [Baz([1,2,3,4])];
foo(val); // выведет количество байт, а не количество элементов
// bar(val); -- ошибка
bar(cast(ubyte[])val);
```