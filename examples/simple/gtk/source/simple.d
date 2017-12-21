// распостраняется до конца файла: если нет версии simple, то
// код ниже не попадает в компиляцию
version(simple):

import std.stdio;
import std.conv : text;

import gtk.Builder;
import gtk.Main;
import gtk.Widget;
import gtk.Window;
import gtk.Button;
import gtk.Label;

void main(string[] args)
{
    // инициализация gtk
    Main.init(args);

    // класс Builder строит интерфейс
    auto ui = new Builder;
    // файлы .glade подготавливаются с помощью программы Glade
    // директива import позволяет читать файл во время компиляции
    // по сути текст файла вставляется в исполняемый файл
    ui.addFromString(import("main.glade"));

    // builder возвращает ObjectG объект, его приводим к интересуюущему классу
    auto win = cast(Window)ui.getObject("mwindow");

    // имена объектов присваиваются при создании интерфейса (main.glade)
    auto btn = cast(Button)ui.getObject("actionbtn");
    auto lbl = cast(Label)ui.getObject("infolbl");

    size_t n;

    // выставляем новый текст в label (текстовый widget)
    btn.addOnClicked((aux) { lbl.setText(text(n++)); });
    // функция text переводит любой свой аргумент в текст

    // при скрытии окна завершать главный цикл обработки событий
    win.addOnHide((aux){ Main.quit(); });

    // показать окно и все дочерние элементы
    win.showAll();

    // запуск цикла обработки событий
    Main.run();
}
