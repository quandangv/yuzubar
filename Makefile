PREFIX?=/usr
SHELL=bash
BINDIR=${PREFIX}/bin
font_size=25
icon_size=22

build/yambar: yambar.cpp
	mkdir -p build
	g++ yambar.cpp -llinked_nodes -llinked_nodes_node -std=c++17 -o build/yambar || error Failed to build $@, did you install lemonbar and linked_nodes

build/install_font:
	@read -p "Install fonts used by the example? [Y/n]: " -n 1 -r; \
	if [[ "$${REPLY^^}" != "N"  ]]; then touch build/install_font; cp "Iosevka Nerd Font.ttf" "~/.local/share/fonts/"; fi
	@echo

full: build/yambar build/install_font
	-pkill lemonbar
	./build/yambar example.yamb 'lemonbar -f "Source Sans Pro:size=${font_size}" -f "Source Sans Pro:size=${font_size}:weight=bold" -f "Iosevka Nerd Font:size=${icon_size}" -b -a 40 -u 4' &

clean_bar:
	-pkill lemonbar
	-pkill yambar

simple: build/yambar clean_bar
	-pkill lemonbar
	./build/yambar simple.yamb

install: build/yambar clean_bar
	sudo install -D -m 755 build/yambar ${DESTDIR}${BINDIR}/yambar

.PHONY:= run clean_bar
