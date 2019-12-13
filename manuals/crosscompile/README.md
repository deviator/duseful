# Кросскомпиляция

## linux -> windows

* [скачиваем](https://github.com/ldc-developers/ldc/releases) ldc под linux 
* оттуда же скачиваем ldc под windows multilib
* распаковываем ldc под linux, кладём куда пожелается, например `/opt/ldc2/`
* добавляем в `$PATH` путь до `<LDC_PATH>/bin`
* распаковываем ldc под windows, берём оттуда папки `lib32` и `lib64` и кладём в `<LDC_PATH>/win-lib32` и `<LDC_PATH>/win_lib64` соответственно
* в файл `<LDC_PATH>/etc/ldc2.conf` добавляем строчки
    
        "i[3-6]86-.*-windows-msvc":
        {
            switches = [
                "-defaultlib=phobos2-ldc,druntime-ldc",
                "-link-defaultlib-shared=false",
            ];
            lib-dirs = [
                "%%ldcbinarypath%%/../win-lib32",
            ];
        };

        "x86_64-.*-windows-msvc":
        {
            switches = [
                "-defaultlib=phobos2-ldc,druntime-ldc",
                "-link-defaultlib-shared=false",
            ];
            lib-dirs = [
                "%%ldcbinarypath%%/../win-lib64",
            ];
        };

## linux x86 -> linux arm

* [скачиваем](https://github.com/ldc-developers/ldc/releases) ldc под linux 
* распаковываем и прописываем в `$PATH` как описано выше
* находим и ставим под свою ОС кросскомпилятор `gcc` (для debian это пакет `gcc-arm-linux-gnueabihf`)
* собираем стандартную библиотеку D под arm командой

        CC=arm-linux-gnueabihf-gcc ldc-build-runtime -j8 \
            --dFlags="-mtriple=armv7l-linux-gnueabihf" \
            --buildDir=/tmp/arm-rt --targetSystem="Linux;UNIX" \
            && mv /tmp/arm-rt/lib /opt/ldc2/arm-lib \
            && rm -rf /tmp/arm-rt

    Переменной `CC` должен быть присвоен путь к кросс-компилятору gcc.
    Вспомогательный скрипт `ldc-build-runtime` поставляется вместе с ldc,
    он упрощает сборку runtime'а под целевую платформу. `--dFlags` содержат
    параметры сборки, включая информацию о целевой платформе. В `-mtriple`
    первым идёт `armv7l`, что указывает набор 32-битных инструкций little
    endian. `gnueabihf` указывает на бинарный интерфейс linux с аппаратной
    поддержкой плавающей точки (`hf` -- `hard float`).

* в файл `<LDC_PATH>/etc/ldc2.conf` добавляем строчки

        "^armv7l.*-linux-gnueabihf$":
        {
            switches = [
                "-defaultlib=phobos2-ldc,druntime-ldc",
                "-gcc=arm-linux-gnueabihf-gcc",
            ];
            lib-dirs = [
                "%%ldcbinarypath%%/../arm-lib",
            ];
            rpath = "%%ldcbinarypath%%/../arm-lib";
        };

Будьте аккуратны с версией `glibc` -- они должны совпадать у кросс-компилятора и целевой платформы.

## Сборка проекта

С версии `1.18.0` ldc поставляется с dub, поддерживающим передачу флага `-mtriple` через флаг `--arch`.

Для windows выглядит так

    dub build --arch=x86_64-pc-windows-msvc

Для linux arm 

    dub build --arch=armv7l-linux-gnueabihf

## Docker образ

В директории [ctx](ctx) лежит `Dockerfile` для сборочного образа, например
для использования в CI gitlab'а.

Собрать docker-контейнер

    docker build -t dmulticross ctx/

Использовать docker-контейнер для сборки проекта для linux arm

    docker run -it --rm -v $(pwd):/workdir dmulticross dub build --arch=armv7l-linux-gnueabihf

Стоит отметить что dub будет скачивать зависимости проекта в
docker-контейнер. Чтобы использовать директорию из системы
нужно её прокинуть в контейнер флагом `-v /home/user/.dub/:/root/.dub`.