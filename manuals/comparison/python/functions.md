# Функции
## Декларация (с типами)
```python
def add(a: int, b: int) -> int:
    return a + b
```
```d
int add(int a, int b) {
    return a + b;
}
```
## Декларация (с утинной типизацией)
В D строгая типизация, однако можно сделать шаблонную функцию. Такая функция имеет параметры не только значений, но и их типов.
```python
def add(a, b):
    return a + b
```
```d
auto add(A, B)(A a, B b) {
    return a + b;
}
// Вызов функции
auto res = add(37, 5);
```
## Значения аргументов по умолчанию
```python
def add(a=2, b=3):
    return a + b
```
```d
auto add(int a = 2, int b = 3) {
    return a + b;
}
```
## Переменное количество аргументов
```python
def add(*args):
    res = 0
    for item in args:
        res += item
    return res
```
```d
auto add(int[] args ...) {
    auto res = 0;
    foreach(item; args)
        res += item;
    return res;
}
```
## Лямбды (анонимные функции)
```python
lambda a: a * 2
# Передача лямбды в качестве аргумента
map(lambda a: a * 2, [1, 2, 3])
```
```d
(a) => a * 2
// Передача лямбды в качестве аргумента
import std.algorithm;
[1, 2, 3].map!((a) => a * 2);
// Либо через строковый литерал
[1, 2, 3].map!"a * 2";
// Либо можно расписать так
[1, 2, 3].map!(
    (int a){ return a * 2; }
);
```
Последний вариант удобен при передаче лямбды с несколькими действиями

## Переменное количество аргументов (разных типов)
```python
from typing import Callable
def callee(age: int, name: string):
    pass


def caller(func: Callable, *args):
    func(*args)
    

caller(callee, 134, "Torin")
```
```d
auto caller(Args...)(void delegate(Args) dg, Args args) {
    dg(args);
}

caller!(int, string)(
    (int age, string name){
        // do smth
    }, 134, "Torin"
);
```
## Передача функции как аргумента другой функции
```python
from typing import Callable
def process_callback(a: int, b: int) -> int:
    return a + b
    
def process(callback: Callable[[int, int], int]):
    # do smth...
    callback(42, 37)
    
process(process_callback)
```

```d
int process_callback(int a, int b){
    return a + b;
}

auto process(int function(int, int) callback){
    // do smth...
    callback(42, 37);
}

process(&process_callback);
```
Или если пока не ясно какие типы будут использованы
```python
def process_callback():
    pass
    
def process(callback):
    # do smth...
    callback()
    
process(process_callback)
```
```d
auto process_callback(){
    // do smth
}

auto process(R, T...)(R function(T) callback){
    // do smth...
    callback();
}

process(&process_callback);
```
## Функции и делегаты
Однако в D есть разница между функцией `funtcion` и делегатом `delegate`. По этой причиней не получится вызвать метод `process` с лямбда выражением `process(x => x * 2)`. Одно из отличий между ними - делегат имеет доступ к переменным, которые доступны в его области видимости. Если надо поддерживать оба типа методов можно сделать так.
```d
auto process(alias callback)(){
    // do smth...
    callback(42);
}
```
Использование
```d
process!(process_callback)();

process!(x => x * 2)();

process!((int x) { return x * 2; })();
```
Синаксический сахар. В D если функция вызывается без аргументов, то скобки можно не ставить. То есть `getSmth()` то же самое что и `getSmth`. Таким образом вызывать `process` можно так.
```d
process!(process_callback);

process!(x => x * 2);

process!((int x) { return x * 2; });
```
Если нужно передать неизвестное количество аргументов неизвестно типа для передаваемого метода. То декларация принимаего метода будет такой.
```d
auto process(alias callback, T...)(T args){
    // do smth...
    callback(args);
}
```
Использование таким
```d
process!(process_callback);

process!(x => x * 2)(3); // то же самое что и process!(x => x * 2, int)(3)

process!((int x) { return x * 2; })(37); // то же самое что и process!((int x) { return x * 2; }, int)(37)
```
