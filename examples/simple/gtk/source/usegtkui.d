// распостраняется до конца файла: если нет версии usegtkui, то
// код ниже не попадает в компиляцию
version(usegtkui):

import std.stdio;
import std.conv : text;

import gtkui : MainBuilderUI;

import gtk.Window;
import gtk.Button;
import gtk.Label;

// MainBuilderUI делает бОльшую часть работы по созданию кода
// работы с gtk объектами
class GUI : MainBuilderUI
{
    // вставляется вспомогательный код, шаблон объявлен внутри
    // GtkUI -- базовый класс MainBuilderUI
    mixin GtkUIHelper;

    /+ @gtkwidget -- UDA, объявленный в GtkUI

       UDA - user defined attribute - атрибут определённый пользователем
       определён в gtkui
       
       @gtkwidget используется для автоматической инициализации полей
       посредством получения экземпляров из gtk.Builder с последующим
       кастованием к нужному типу. При отсутствии поля во входном xml
       в конструкторе выбрасывается исключение.
     +/
    @gtkwidget
    {
        // имена в файле интерфейса должны совпадать с именами полей
        Window mwindow;
        Button actionbtn;
        Label infolbl;
    }

    this()
    {
        /+ в базовый класс нужно передать текст файла интерфейса
           import("filename") читает filename во время компиляции
           поиск filename осуществляется в папке, указанной в флаге
           компилятора -Jfolder, который так же выставляется в
           dub.sdl/json в параметре stringImpmortPaths
         +/
        super(import("main.glade"));

        size_t n;
        actionbtn.addOnClicked((aux) { infolbl.setText(text(n++)); });

        setupMainWindow(mwindow);
        addOnQuit({ exitLoop(); });
    }
}

void main()
{
    auto gui = new GUI;
    gui.runLoop(); // запуск цикла обработки событий (вызов gtk.Main.run)
}