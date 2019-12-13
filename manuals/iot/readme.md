# D для IoT (Internet of Things)

По бОльшей части IoT связан с разработкой под микроконтроллеры и энергоэфективные процессоры.
На сегодняшний день в подавляющем большинстве это ARM архитектура (все распостранённые SoM).

## Настройка компиляции под ARM для Raspberry PI (2, 3), beaglebone, etc

С выходом ldc `1.18.0` кросскомпиляция стала достаточно простой и описана [здесь](../crosscompile/).

Поскольку рассматривается ситуация с linux на борту устройства особых ограничений на структуру проекта нет.
Если проекта пока нет можно проследовать [инструкции](/manuals/begin.md#Первые-шаги) и создать пустой.

## полезные библиотеки

* [serialport](https://github.com/deviator/serialport) -- библиотека для работы с последовательным портом
* [modbus](https://github.com/deviator/modbus) -- реализация протокола [Modbus](https://ru.wikipedia.org/wiki/Modbus) (master и slave)
* [mosquittod](https://github.com/deviator/mosquittod) -- биндинг к библиотеке [mosquitto](https://mosquitto.org/), реализующей протокол MQTT
* [vibe-mqtt](https://github.com/tchaloupka/vibe-mqtt) -- реализация сервера MQTT на D
* [sdutil](https://github.com/deviator/sdutil) -- биндинг к `libsystemd.so`, позволяет удобно писать systemd сервисы
* [protobuf](https://github.com/dcarp/protobuf-d) -- реализация плагина для компилятора protobuf (только для `proto3`)

## Без linux

D достаточно плотно интегрирован со своим runtime, но всё равно runtime можно выпилить и собирать код
под чистое железо без ОС.

Ссылки по теме:

* https://wiki.dlang.org/Bare_Metal_ARM_Cortex-M_GDC_Cross_Compiler
* https://wiki.dlang.org/Minimal_semihosted_ARM_Cortex-M_%22Hello_World%22
* https://forum.dlang.org/thread/qzrbbjgjwmgbyxukqpay@forum.dlang.org
* https://bitbucket.org/timosi/minlibd/overview

