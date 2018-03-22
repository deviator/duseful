# Модули

### Импорт всех сущностей из модуля
```python
from zoo.animals.cats import *
jaguar = Jaguar()
```
```d
import zoo.animals.cats;
auto jaguar = Jaguar();
```

### Импорт модуля
```python
import zoo.animals.cats
jaguar = zoo.animals.cats.Jaguar()
```
```d
import zoo.animals.cats;  // Импорт выглядит так же как в предыдущем случае.
auto jaguar = zoo.animals.cats.Jaguar();  // Указывание полного пути позволяет разрешать конфликты имен.
```

### Разрешение конфликтов
```d
import zoo.animals.cats;
import machines.cars;
auto jaguarAnimal = zoo.animals.cats.Jaguar();
auto jaguarCar = machines.cars.Jaguar();
```

### Именованый импорт
```python
from zoo.animals import cats as zoo_cats
jaguar = zoo_cats.Jaguar()
```
```d
import zooCats = zoo.animals.cats;
auto jaguar = zooCats.Jaguar();
```

### Выборочный импорт (подмодуля)
```python
from zoo.animals import cats
jaguar = cats.Jaguar()
```
```d
import cats = zoo.animals.cats;
auto jaguar = cats.Jaguar();
```

### Выборочный импорт (класса, функции или объекта)
```python
from zoo.animals.cats import Jaguar
jaguar = Jaguar()
```
```d
import zoo.animals.cats : Jaguar;
auto jaguar = Jaguar();
```
