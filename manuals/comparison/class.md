# Классы и структуры

## C++

WIP

## Java

### Простой класс

```java
public class MyClass {

}
```

### Класс, который нельзя наследовать

```java
public final class MyClass {

}
```

### Класс, экземпляр которого нельзя создать, и который можно только наследовать

```java
public abstract class MyClass {

}
```

### Подкласс

```java
public class MyClass {
    // Обязательно должен быть static, чтоб избежать утечек памяти
    public static class InnerClass {

    }
}
```

### Наследование классов

```java
public class SubClass extends SuperClass {

    public SubClass() {
        // обязательно должны вызвать любой
        // сучествующий родительский конструктор
        super(5);
    }
    
    // Переопределяем метод родительського класса
    @Override
    public int calculate() {
        return 2 + 2;
    }
}

public class SuperClass {

    // private - классы-наследники не будут видеть переменную
    // final - значит переменная обязательно должна
    // быть проинициализированна в конструкторе
    private final int value;

    public SuperClass(int value) {
        this.value = value;
    }

    public int calculate() {
        return value * 2;
    }
}
```
