# Перегрузка операторов (магические методы)

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
        if(["+", "-", "*", "/", "%", "^^"].canFind(op))  // if после объявления шаблонного метода служит условием возможности выполнения этого метода
    {
        return mixin("val" ~ op ~ "rhs"); // mixin - аналог eval из python, но работает только во время компиляции.
    }


    T opBinaryRight(string op, T)(T lhs)
        if(["+", "-", "*", "/", "%", "^^"].canFind(op))
    {
        return mixin("lhs" ~ op ~ "val");
    }
}
```
Некорректно сравнивать операторы деления в python и в D, потому что в python этот 
оператор вернет `float` даже при делении целых чисел, а оператор `//` в D отсутствует.
Оператор возведения в степень `**` также отсутствует в D.

В целом можно переопределить абсолютно все операторы, если они выполняют все одну и ту же функцию.
Для этого можно убрать ограничение `if(["+", "-", "*", "/", "%"].canFind(op))` тогда объект можно будет
использовать с любым оператором.

