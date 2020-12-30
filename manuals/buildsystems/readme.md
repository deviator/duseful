# Системы сборки

D поддерживается следующими системами сборки:

* [`dub`](https://dub.pm/package-format-sdl.html) ставится вместе c `dmd` и `ldc`, является так же менеджером пакетов
* [модуль для `cmake`](https://github.com/dcarp/cmake-d)
* [`meson`](https://mesonbuild.com/D.html)
* [`waf`](https://waf.io/book/#_loading_and_using_waf_tools)
* [`premake`](https://github.com/premake/premake-core/tree/master/modules/d)
* [`NixOS`](https://github.com/NixOS/nixpkgs) [пример сборки ldc](https://github.com/NCrashed/asteroids-arena/blob/master/nix/ldc/generic.nix)
* [`scons`](https://www.scons.org/documentation.html) мало документации по D, но поддержка есть ([исходники](https://github.com/SCons/scons/blob/master/SCons/Tool/DCommon.py))
* [`Cook2`](https://github.com/gecko0307/cook2) *
* [`Reggae`](https://github.com/atilaneves/reggae) *

`*` написаны на D