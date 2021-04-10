PREFIX?=/usr
SHELL=bash
BINDIR=${PREFIX}/bin
font_size=25

build/yambar: yambar.cpp
	mkdir -p build
	g++ yambar.cpp -llinked_nodes -llinked_nodes_node -std=c++17 -o build/yambar || error Failed to build $@, did you install lemonbar and linked_nodes

build/install_font:
	@read -p "Install fonts used by the example? [Y/n]: " -n 1 -r; \
	if [[ "$${REPLY^^}" != "N"  ]]; then touch build/install_font; cp "Iosevka Nerd Font.ttf" "~/.local/share/fonts/"; fi
	@echo
	
run: build/yambar build/install_font
	-pkill lemonbar
	./build/yambar example.yamb 'lemonbar -f "Source Sans Pro:size=${font_size}" -f "Source Sans Pro:size=${font_size}:weight=bold" -f "Iosevka Nerd Font:size=${font_size}" -g x50 -b -a 40 -u 4' &

install: build/yambar
	sudo install -D -m 755 build/yambar ${DESTDIR}${BINDIR}/yambar

.PHONY:= run
