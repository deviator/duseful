﻿# Bitmap

## Источник

[http://rosettacode.org/wiki/Bitmap](http://rosettacode.org/wiki/Bitmap)

## Задача

Приведите базовый тип для хранения простого растрового графического изображения в формате RGB и нексколько примитивных функций, связанных с этим типом.

По возможности предоставьте функцию для выделения неинициализированного изображения с учетом его ширины и высоты, также предоставьте 3 дополнительные функции:

* одну для заполнения изображения простым RGB-цветом,
* одну для установки цвета заданного пикселя,
* одну для получения цвета заданного пикселя.

(Если есть особенности относительно хранения изображаения или выделения памяти, объясните это.)

## Примечания

Для сборки проекта в формате исполняемого файла укажите конфигурацию `app`:

```cmd
dub build --config=app
```