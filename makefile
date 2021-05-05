AUTHOR = Quandangv
PREFIX ?= /usr
BINDIR = ${PREFIX}/bin

CXX ?= g++
CFLAGS += -Wall -Os -D_GNU_SOURCE
LDFLAGS += -llinkt_lang -llinkt_node -L/usr/local/li -std=c++17
CFDEBUG = -g3 -pedantic -Wall -Wunused-parameter -Wlong-long -Wsign-conversion -Wconversion

# Font name and sizes for the example bars
font=Montserrat
font_size=22
icon_size=20

# Build the main executable
build/yuzubar: yuzubar.cpp build/generated/command-line-help.txt
	mkdir -p build
	${CXX} yuzubar.cpp -o build/yuzubar -I build/generated ${CFLAGS} ${LDFLAGS}

# Preprocess the file containing command-line help
build/generated/command-line-help.txt: doc/prebuilt/command-line-help.txt
	mkdir -p build/generated
	sed 's/^/"/g; s/$$/\\n"/g' doc/prebuilt/command-line-help.txt > build/generated/command-line-help.txt
test: build/yuzubar
	./build/yuzubar -h

all: doc debug

debug: build/yuzubar
debug: CXX += ${CFDEBUG}

doc: doc/command-line-help.md
	mkdir -p doc/prebuilt
	pandoc -t plain --columns=80 -o doc/prebuilt/command-line-help.txt doc/command-line-help.md
	#echo ".TH yuzubar 1 \"$$(date +%Y-%m-%d)\" \"yuzubar\" \"yuzubar Manual\"" > doc/prebuilt/yuzubar.man
	pandoc -t man \
	  --shift-heading-level-by=-1 \
	  --template=doc/man-template.man \
	  -V author=${AUTHOR} \
	  doc/command-line-help.md > doc/prebuilt/yuzubar.man

# Prompt the user to install the font for the examples
build/install_font:
	@read -p "Install fonts used by the example? [Y/n]: " -n 1 -r; \
	if [[ "$${REPLY^^}" != "N"  ]]; then cp "font/Iosevka Nerd Font.ttf" ~/.local/share/fonts/ && touch build/install_font; fi
	@echo

# Notify the user that the command to launch yuzubar is being printed
prep_example:
	@echo
	@echo Command used to start yuzubar:

# Launch a simple bar
simple: build/yuzubar prep_example simple.yzb
	./build/yuzubar -k simple.yzb

# Launch a full example bar
full: build/yuzubar build/install_font prep_example example.yzb
	./build/yuzubar -k example.yzb ~/.config/yuzubar/default.yzb \
	    -f "${font}:size=${font_size}:weight=light" \
	    -f "${font}:size=${font_size}:weight=regular" \
	    -f "Iosevka Nerd Font:size=${icon_size}" \
	    -l "lemonbar -b -a 40 -u 2 -g x40" \

# Install yuzubar
install: build/yuzubar
	install -D -m 755 build/yuzubar ${DESTDIR}${BINDIR}/yuzubar
	install -D -m 644 doc/prebuilt/yuzubar.man ${DESTDIR}${PREFIX}/share/man/man1/yuzubar.1

# Delete the build directory
clean:
	rm -rf build

sterilize: clean
	rm -rf doc/prebuilt

.PHONY: all run doc clean sterilize prep_example test
