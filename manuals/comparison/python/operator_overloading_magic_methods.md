# Перегрузка операторов (магические методы)

## Арифметические операторы
```python
class Foo:
    def __init__(self):
        self.val = 1
    
    def __add__(self, rhs):
        return self.val + rhs
    
    def __radd__(self, lhs):
        return lhs + self.val
        
    def __sub__(self, rhs):
        return self.val - rhs
    
    def __rsub__(self, lhs):
        return lhs - self.val
        
    def __mul__(self, rhs):
        return self.val * rhs

    def __rmul__(self, lhs):
        return lhs * self.val

    def __truediv__(self, rhs):
        return self.val / rhs

    def __rtruediv__(self, lhs):
        return lhs / self.val

    def __mod__(self, rhs):
        return self.val / rhs

    def __rmod__(self, lhs):
        return lhs / self.val

    def __pow__(self, rhs):
        return self.val ** rhs

    def __rpow__(self, lhs):
        return  rhs ** self.val
```

```d
class Foo {
    auto val = 1;
    
    T opBinary(string op, T)(T rhs)
        if(op == "+")
    {
        return val + rhs;
    }


    T opBinaryRight(string op, T)(T lhs)
        if(op == "+")
    {
        return lhs + val;
    }
    
    // ... и так далее, подставляя вместо `+` нужный знак, однако можно воспользоваться кодогенерацией и сделать так.
    import std.algorithm; // импорт может быть глобальным.

    T opBinary(string op, T)(T rhs)
        if(canFind(["+", "-", "*", "/", "%", "^^"], op))  // if после объявления шаблонного метода служит условием возможности выполнения этого метода
    {
        return mixin("val" ~ op ~ "rhs"); // mixin - аналог eval из python, но работает только во время компиляции.
    }


    T opBinaryRight(string op, T)(T lhs)
        if(canFind(["+", "-", "*", "/", "%", "^^"], op))
    {
        return mixin("lhs" ~ op ~ "val");
    }
}
```
Некорректно сравнивать операторы деления в python и в D, потому что в python этот 
оператор вернет `float` даже при делении целых чисел, а оператор `//` в D отсутствует.

В целом можно переопределить абсолютно все операторы, если они выполняют все одну и ту же функцию.
Для этого можно убрать ограничение `if(["+", "-", "*", "/", "%", "^^"].canFind(op))` тогда объект можно будет
использовать с любым оператором.

## Операторы для работы с массивом

```python
class Foo:
    def __init__(self):
        self._arr = [1, 2, 3]

    def __getitem(self, index):
        return self._arr[index]

    def __setitem(self, index, value):
        self._arr[index] = value
    
    def __iter__(self):
        return iter(self._arr)
```
```d
class Foo {
    auto _arr = ['a', 'b', 'c'];
    auto opIndex(size_t index) {
        return _arr[index];
    }
    
    auto opIndexAssign(T)(T value, size_t index) {
        _arr[index] = value;
    }
    
    int opApply(int delegate(ref char val) dg) {
        int result = 0;
        foreach (ref elem; _arr) {
            result = dg(i);
            if (result) break;
        }
        return result;
    }
}
```
В Python определяя метод `__iter__`, объект сразу получает возможно не только быть итерируемым, но также его можно использовать с оператором `in`. В D оператор `in` нужно перегружать отдельно. Например так
```d
import std.algorithm;

class Foo {
    auto _arr = [];
    bool opBinaryRight(string op, T)(T lhs)
        if(op == "in")
    {
        return canFind(_arr, lhs);
    }
}
```
Перегрузка оператора среза (slice)
```python
class Foo:
    def __init__(self):
        self._arr = [1, 2, 3]

    def __getitem__(self, slice_object: slice):
        return self._arr[slice_object]

    def __setitem__(self, slice_object: slice, value):
        self._arr[slice_object] = value
```
```d
class Foo {
    auto _arr = ['a', 'b', 'c'];
    auto opSlice(size_t from, size_t to) {
        return _arr[from .. to]
    }
    
    auto opSliceAssign(T)(T value, size_t from, size_t to) {
        _arr[from .. to] = value;
    }
}
```