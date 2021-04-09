
PREFIX?=/usr
BINDIR=${PREFIX}/bin

build/yambar: yambar.cpp
	mkdir -p build
	g++ yambar.cpp -llinked_nodes -llinked_nodes_node -std=c++17 -o build/yambar || error Failed to build $@, did you install lemonbar and linked_nodes

install_font:
	@read -r -p "Install fonts used by the example? [Y/n]: " -n 1 p && echo
	[[ "${p^^}" != "N" ]] && sudo cp GrenzeGotisch.ttf /usr/share/fonts/

run: build/yambar
	-pkill lemonbar
	./build/yambar 'lemonbar -f "GrenzeGotisch-VariableFont_wght.ttf:style=smallcaps:size=40" -f "Grenze Gotisch:size=40:weight=bold" -f "Iosevka Nerd Font:size=40" -g +0+13 -a 40' &

install: build/yambar
	install -D -m 755 build/yambar ${DESTDIR}${BINDIR}/yambar

.PHONY:= run install_font
