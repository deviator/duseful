# Классы
```python
class Point:
    pass
```
```d
class Point {
}
```
## Инициализация (конструктор)
```python
class Point:
    def __init__(self, x: int, y: int):
        self.x = x
        self.y = y
```

```d
class Point {
    this(int x, int y) {
        this.x = x;
        this.y = y;
    }
    int x;
    int y;
}
```
## Методы
```python
class Point:
    def __init__(self, x: int, y: int):
        self.x = x
        self.y = y
        
    def length(self):
        return (self.x ** 2 + self.y ** 2) ** (1 / 2);
        
p = Point(2, 2)
p.length()
```
```d
import std.math;
class Point {
    this(int x, int y) {
        this.x = x;
        this.y = y;
    }
    
    auto length() {
        return pow(
            pow(this.x, 2) + pow(this.y, 2),
            1 / 2.
        );
    }
    int x;
    int y;
}

auto p = new Point(2, 2);
p.length();  // то же что и p.length
```
## Поля класса (статические поля)
```python
class Point:
    x = 0
    y = 0

p1 = Point()
p2 = Point()
p1.x = 2
assert p2.x == 2, 'Поля точек должны быть одинаковыми'
```
```d
class Point {
    static auto x = 0;
    static auto y = 0;
}

auto p1 = new Point;
auto p2 = new Point;
p1.x = 2;
assert(p2.x == 2, "Поля точек должны быть одинаковыми")
```
## Методы класса (статические методы)
```python
class Point:
    x = 0
    y = 0
    
    @classmethod
    def length(cls):
        return (cls.x ** 2 + cls.y ** 2) ** (1 / 2);

Point.length()
```
```d
class Point {
    static x = 0;
    static y = 0;
    
    static length() {
        return pow(
            pow(this.x, 2) + pow(this.y, 2),
            1 / 2.
        );
    }
}

Point.length;
```
## Свойства (@property)
class Point:
    def __init__(self, x: int, y: int):
        self._x = x
        self.y = y
    
    @property
    def x(self):
        return self._x
    
    @x.setter
    def x(self, x):
        self._x = x

p = Point(2, 2)
p.x = 3
assert p.x == 3
```
```d
class Point {
    this(int x, int y) {
        this._x = x;
        this.y = y;
    }
    
    auto _x;
    auto y;
    
    @property
    auto x() {
        return this._x;
    }
    
    @property
    auto x(int x) {
        this._x = x;
    }
}

auto p = new Point(2, 2);
p.x = 3;
assert(p.x == 3);
```

## Наследование
```python
class Point2d:
    def __init__(self, x: int, y: int):
        self.x = x
        self.y = y
        
        
class Point3d(Point2d):
    def __init__(self, x: int, y: int, z: int):
        super().__init__(x, y)
        self.z = z;
```
```d
class Point2d {
    this(int x, int y) {
        this.x = x;
        this.y = y;
    }
    auto x;
    auto y;
}

class Point3d : Point2d {
    this(int x, int y, int z) {
        super(x, y);
        this.z = z;
    }
    auto z;
}

## Множественное наследование
В D нет множественного наследования, если не обходимо добавить какой-то миксин в класс можно
воспользоваться конструкцией `mixin template`. Пример опирается на 2 класса, объявленные выше, `Point2D` и `Point3D`
```python
class NameMixin:
    def __init__(self, *args, **kwargs):
        self.name = ''
        super().__init__(*agrs, **kwargs)

    def get_name():
        return self.name

    def set_name(name)
        self.name = name

class NamedPoint3d(Point3d, NameMixin):
    pass
```
```d
mixin template NameMixin() {
    auto name = "";
    
    auto getName() {
        return this.name;
    }
    
    auto setName(string name) {
        this.name = name;
    }
}

class NamedPoint3d(Point3d) {
    mixin NameMixin;
}
```
