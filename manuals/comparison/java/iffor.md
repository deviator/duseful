# Циклы и ветвления

### Оператор ветвления

Синтаксис для оператора **if** что в Java, что в D будет идентичен:

```d
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

Так же и синтаксис тернарного оператора отличаться не будет:

```d
int val = 5;
int absval = val < 0 ? -val : val;
```

### Циклы for, while, do-while

И **for**, **while**, **do-while** для Java-разработчика не вызовут вопросов:  

```d
for (int i = 0; i < 10; i++) {
    // сделать что-нибудь 10 раз
}
```

```d
int i = 10;
while (i > 0) {
    i--;
    // сделать что-нибудь 10 раз
}
```

```d
int i = -1;
do {
    // сделать что-нибудь 1 раз
} while (i > 0);
```

### Цикл foreach

А вот в цикле **[foreach](https://tour.dlang.org/tour/ru/basics/foreach)** уже есть отличия. К примеру, если в Java foreach будет так выглядеть:

```java
String[] fruits = new String[] { "Orange", "Apple", "Pear", "Strawberry" };

for (String fruit : fruits) {
    // пробежимся по всем элементам массива/списка/ассоциативного массива
}
```

То в D аналогичная задача будет реализована следующим образом:

```d
auto fruits = [ "Orange", "Apple", "Pear", "Strawberry" ];

foreach (fruit; fruits) {
    writeln(fruit);
}
```

Если вам нужен индекс, это не проблема, используем следующий вариант:

```d
auto fruits = [ "Orange", "Apple", "Pear", "Strawberry" ];

foreach(i, fruit; fruits) {
    // 0 = Orange
    // 1 = Apple
    // ...
    writeln(i, " = ", fruit);
}
```

Так можно пробегаться по диапазонам:

```d
foreach (i; 0 .. 3) {
    // сделать что-нибудь 3 раза
    // выведет: 0, 1, 2
    writeln(i);
}
```

D поддерживает цикл **foreach_reverse**, который пробегается по елементам в обратном порядке:

```d
foreach_reverse (i; [1, 2, 3]) {
    // выведет: 3, 2, 1
    writeln(i);
}
```
