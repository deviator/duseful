# Контейнеры

## List (список или массив)

### Декларация
```python
my_list = [1, 2, 3, 4]
```

```d
auto myArray = [1, 2, 3];
```
### Конкатенация
```python
left_list + right_list
```
```d
leftArray ~ rightArray;
```

### Добавление элемента
```python
names.append('Alex')
```
```d
names ~= "Alex";
```

### Проверка наличия элемента
```python
'Alex' in names_list
```
```d
import std.algorithm;
namesArray.canFind("Alex");
```
### Удаление элемента
```python
del names_list[0]
del names_list[1:3]
```
```d
import std.algorithm;
import std.typecons;
names = names.remove(0);
names = names.remove(tuple(1, 3));
```

### Срез (slicing)
```python
names[1:3]
names[:-1]
names[1:]
```

```d
names[1..3]
names[0..$-1]
names[1..$]
```

### Длина
```python
len(names)
```
```d
names.length
```

### Индекс элемента
```python
names.index('Alex')
```
```d
import std.algorithm;
names.countUntil("Alex");
```

## Dictionary (словарь или ассоциативный массив)

### Декларация
```python
point = {'x': 0.52, 'y': 42, 'z': 1.3}
```

```d
auto point = ["x": 0.52, "y": 42, "z": 1.3];
```

### Итерация
```python
for key, value in my_dict.items():
    pass
for key, value in my_dict.keys():
    pass
for key, value in my_dict.items():
    pass
```

```d
foreach(key, value; myDict) {
    // ...
}
foreach(key; myDict.keys) {
    // ...
}
foreach(value; myDict.values) {
    // ...
}
```
### Добавление элемента
```python
my_dict[key] = value
```
```d
myDict[key] = value;
```

### Проверка ключа
```python
key in my_dict
```
```d
(key in MyDict) !is null;
```

### Удаление
```python
del my_dict['a']
```
```d
myDict.remove("a");
```
