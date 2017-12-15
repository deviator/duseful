# Настройка под Linux

* [DMD](#dmd)
* [LDC](#ldc)
* [GDC](#gdc)
* [DUB](#dub)

Для пользователей linux существует вспомогательный скрипт
[`install.sh`](https://dlang.org/install.sh).

Самый простой пример использования:
```
curl -fsS https://dlang.org/install.sh | bash -s dmd
```

С помощью скрипта так же можно установить и/или удалить интересующую
версию интересующего компилятора:

```
install.sh
install.sh dmd
install.sh install dmd
install.sh install dmd-2.071.1
install.sh install ldc-1.1.0-beta2

intall.sh uninstall dmd
install.sh uninstall dmd-2.071.1
install.sh uninstall ldc-1.1.0-beta2
```

## DMD

[Скачать](https://dlang.org/download.html)

На странице загрузки, скорее всего, будет пакет для вашего дистрибутива --
требуется его установка и больше настроек dmd не требует.

## LDC

[Скачать](https://github.com/ldc-developers/ldc/releases)

Скачивается архив с уже собранными файлами. Его нужно распаковать и
либо добавить папку `ldc2-X.X.X-linux-x86_64/bin/` в пути (переменная
окружения `$PATH`), либо сделать символические ссылки содержимого в
папку, которая уже есть в путях. В папке `bin` так же есть собранный `dub`.

Так же в Fedora можно установить из родного репозитария

    dnf install ldc

Но нужно быть внимательным -- версия не самая последняя (для fc26 это 1.3.0).

## GDC

[Скачать](https://gdcproject.org/downloads)

TODO

## DUB

[Скачать](http://code.dlang.org/download)

По аналогии с [`ldc`](#ldc) нужно скачать, распаковать нужный архив и добавить
в сам файл `dub` в пути.