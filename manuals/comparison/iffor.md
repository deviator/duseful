# Циклы и ветвления

## C++

WIP

## Python

### if

```python
if 2 > 1:
    print("2 greater than 1")
```
```d
if (2 > 1) {
    writeln("2 greater than 1");
}
```

### Однострочный if

```python
result = 2 if 2 > 1 else 1
```
```d
auto result = (2 > 1) ? 2 : 1;
```

### foreach
```python
for item in some_list:
    print(item)
```
```d
foreach(item; someList) {
    writeln(item);
}
```

### foreach с индексацией
```python
for i, item in enumerate(some_list):
    print(i, item)
```
```d
foreach(i, item; someList) {
    writeln(i, item);
}
```
### while
```python
while True:
    print(1)
```

```d
while(true) {
    writeln(1);
}
```

### for range
```python
for i in range(10):
    print(i)
```
```d
import std.range : iota;

foreach(i; iota(10)) {
    writeln(i);
}
```
Или
```d
for(auto i; i < 10; ++i) {
    writeln(i);
}
```

### list comprehension lazy
```python
double_list = (x * 2 for x in some_list)
```
```d
import std.algorithm;
auto doubledList = someList.map!(x => x * 2);
```
### list comprehension
```python
double_list = [x * 2 for x in some_list]
```
```d
import std.algorithm;
import std.array;
auto doubledList = someList.map!(x => x * 2).array;
```
## Java

### Оператор ветвления
```java
int gender = 1;
if (gender == 1) {
    // что-то делаем если условие gender = 1
} else if (gender == 2) {
    // что-то делаем если условие gender = 2
} else {
    // что-то делаем если условие gender имеет другое значение
}
```

### Тернарный оператор
```java
int val = 5;
int absval = val < 0 ? -val : val;
```

### Цикл for
```java
for (int i = 0; i < 10; i++) {
    // сделать что-нибудь 10 раз
}
```

### Цикл while
```java
int i = 10;
while (i > 0) {
    i--;
    // сделать что-нибудь 10 раз
}
```

### Цикл do-while
```java
int i = -1;
do {
    // сделать что-нибудь 1 раз
} while (i > 0);
```

### Цикл foreach
```java
String[] fruits = new String[] { "Orange", "Apple", "Pear", "Strawberry" };

for (String fruit : fruits) {
    // пробежимся по всем элементам массива/списка/ассоциативного массива
}
```

