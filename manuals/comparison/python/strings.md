# Строки
Строки в D это иммутабельный массив char `immutable char[]`

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

## Количество символов
```python
len(mystr)
```
```d
mystr.length;
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
