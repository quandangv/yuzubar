PREFIX?=/usr
SHELL=bash
BINDIR=${PREFIX}/bin
font_size=22
icon_size=20
font=Montserrat

build/yuzubar: yuzubar.cpp
	mkdir -p build
	g++ yuzubar.cpp -llinked_lang -llinked_node -std=c++17 -o build/yuzubar || error Failed to build $@, did you install lemonbar and linked_nodes

build/install_font:
	@read -p "Install fonts used by the example? [Y/n]: " -n 1 -r; \
	if [[ "$${REPLY^^}" != "N"  ]]; then cp "Iosevka Nerd Font.ttf" ~/.local/share/fonts/ && touch build/install_font; fi
	@echo

clean_bar:
	-pkill lemonbar
	-pkill yuzubar

simple: build/yuzubar clean_bar
	-pkill lemonbar
	./build/yuzubar simple.yzb

full: build/yuzubar build/install_font
	-pkill lemonbar
	./build/yuzubar example.yzb ~/.config/yuzubar/default.yzb -l 'lemonbar -f "${font}:size=${font_size}:weight=light" -f "${font}:size=${font_size}:weight=regular" -f "Iosevka Nerd Font:size=${icon_size}" -b -a 40 -u 2 -g x40'

install: build/yuzubar
	$$(type sudo>/dev/null && echo sudo) install -D -m 755 build/yuzubar ${DESTDIR}${BINDIR}/yuzubar

clean:
	rm -rf build

.PHONY:= run clean_bar