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
