PREFIX?=/usr
BINDIR=${PREFIX}/bin
font_size=25

build/yambar: yambar.cpp
	mkdir -p build
	g++ yambar.cpp -llinked_nodes -llinked_nodes_node -std=c++17 -o build/yambar || error Failed to build $@, did you install lemonbar and linked_nodes

install_font:
	@read -r -p "Install fonts used by the example? [Y/n]: " -n 1 p && echo
	[[ "${p^^}" != "N" ]] && sudo cp GrenzeGotisch.ttf /usr/share/fonts/

run: build/yambar
	-pkill lemonbar
	./build/yambar 'lemonbar -f "Source Sans Pro:size=${font_size}" -f "Source Sans Pro:size=${font_size}:weight=bold" -f "Iosevka Nerd Font:size=${font_size}" -g x50 -b -a 40 -u 4' &

install: build/yambar
	install -D -m 755 build/yambar ${DESTDIR}${BINDIR}/yambar

.PHONY:= run install_font
