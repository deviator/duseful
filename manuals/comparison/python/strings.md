# Строки
Строки в D это иммутабельный массив char `immutable char[]`.

## Декларация

```python
mystr = "Lorem Ipsum"
```
```d
auto mystr = "Lorem Ipsum";
```

## Подстроки (substring)
```python
mystr[1:3]
```
```d
mystr[1..3];
```

## Получение одного символа
```python
mystr[1]
```
```d
mystr[1];
```

## Количество байт
```python
len('résumé'.encode())  # 8
```
```d
"résumé".length;  // 8
```

## Количество символов (unicode points)
```python
len('résumé')  # 6
```
```d
import std.uni;
"résumé".count;  // 6
```

## Форматирование
```python
'print %s' % mystr
```
```d
import std.format;
"print %s".format(mystr);
```

## Удаление пробелов слева и справа
```python
' Lorem '.strip()
```
```d
import std.string;
" Lorem ".strip;
```
## Удаление пробелов слева
```python
' Lorem '.rstrip()
```
```d
import std.string;
" Lorem ".stripLeft;
```

## Удаление пробелов справа
```python
' Lorem '.rstrip()
```
```d
import std.string;
" Lorem ".stripRight;
```

## Массив из строки по разделителю
```python
'lorem ipsum'.split()
```
```d
import std.array;
"lorem ipsum".split;
```

## Объединение массива в строку
```python
' '.join(['lorem', 'ipsum'])
```
```d
import std.array;
["lorem", "ipsum"].join(" ");
```
## Проверка наличия подстроки
```python
'stack' in 'haystack'
```
```d
import std.algorithm;
"haystack".canFind("stack");
```
## Поиск подстроки
```python
'haystack'.find('ys')
```
```d
import std.string;
"haystack".indexOf("ys");
```
## Приведение строки в верхнему регистру
```python
'haystack'.upper();
```
```d
import std.algorithm;
import std.uni;
"haystack".map!toUpper;
```
