# По умолчанию собираем под arm
arch = arm

# target path -- директория, куда будут собираться бинарные файлы
TP = build-$(arch)

DC = ./ldc

LDC_DFLAGS = -mtriple=armv7l-linux-gnueabihf -disable-inlining -mcpu=cortex-a8

EMPTY :=
SPACE :=$(EMPTY) $(EMPTY)

LDC_BRT_DFLAGS = $(subst $(SPACE),;,$(LDC_DFLAGS))

ifeq ($(skip), n)
	SKIP =
else
	# не проверяя обновления,
	SKIP = --skip-registry=all
endif

ifeq ($(force), y)
	# принудительно пересобираем все пакеты даже если собраны
	# иногда необходимо, т.к. dub не отслеживает некоторые варианты изменений
	FORCE = --force
else
	FORCE =
endif

ifeq ($(release), y)
	BUILD_TYPE = --build=release
else
	BUILD_TYPE =
endif

DUB_FLAGS = build --parallel --compiler=$(DC) $(SKIP) $(FORCE) $(BUILD_TYPE)

$(info DUB_FLAGS: $(DUB_FLAGS))

# использовать путь в контейнере
LDC = ldc2
LDC_BRT = ldc-build-runtime

# директория с runtime библиотеками под ARM
LDC_RT_DIR = .ldc-rt

GCC = arm-linux-gnueabihf-gcc

ifeq ($(arch), x86)
	LDC_FLAGS = 
else ifeq ($(arch), arm)
	LDC_FLAGS = $(LDC_DFLAGS) -L-L./$(LDC_RT_DIR)/lib -L-L./arm-lib -gcc=$(GCC)
else
	$(error unknown arch)
endif

DUB = TP=$(TP) LDC=$(LDC) LDC_FLAGS="$(LDC_FLAGS)" dub $(DUB_FLAGS)

# перечисленные цели не являются файлами
.PHONY: all clean rtlibs stat

# цель по умолчанию
all: rtlibs
	$(DUB)

DRT_LIBS=$(addprefix $(LDC_RT_DIR)/lib/, libdruntime-ldc.a libdruntime-ldc-debug.a libphobos2-ldc.a libphobos2-ldc-debug.a)

$(DRT_LIBS):
	CC=$(GCC) $(LDC_BRT) -j8 --dFlags="$(LDC_BRT_DFLAGS)" --buildDir=$(LDC_RT_DIR) \
		--targetSystem="Linux;UNIX" BUILD_SHARED_LIBS=OFF

# D runtime для ARM
rtlibs: $(DRT_LIBS)

stat:
	find source -name '*.d' | xargs wc -l

clean:
	rm -rf $(TP)
	rm -rf .dub
	$(LDC_BRT) --buildDir=$(LDC_RT_DIR) --resetOnly