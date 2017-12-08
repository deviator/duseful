# Циклы и ветвления

### if

```python
if 2 > 1:
    print("2 greater than 1")
```
```d
if (2 > 1)
{
    writeln("2 greater than 1");
}
```

### Тернарный оператор

```python
result = 2 if 2 > 1 else 1
```
```d
auto result = 2 > 1 ? 2 : 1;
```

### foreach
```python
for item in some_list:
    print(item)
```
```d
foreach (item; someList)
{
    writeln(item);
}
```

### foreach с индексацией
```python
for i, item in enumerate(some_list):
    print(i, item)
```
```d
foreach(i, item; someList)
{
    writeln(i, item);
}
```

### while
```python
while True:
    print(1)
```
```d
while(true)
{
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

foreach (i; iota(10))
{
    writeln(i);
}
```
Или
```d
for (auto i; i < 10; ++i)
{
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
