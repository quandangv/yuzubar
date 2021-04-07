.PHONY:= run

build/yambar: yambar.cpp
	mkdir -p build
	g++ yambar.cpp -llinked_nodes -llinked_nodes_node -std=c++17 -o build/yambar || error Failed to build $@, did you install lemonbar and linked_nodes

run: build/yambar
	-pkill lemonbar
	./build/yambar 'lemonbar -f "Grenze Gotisch:style=smallcaps:size=40" -f "Grenze Gotisch:size=40:weight=bold" -f "Iosevka Nerd Font:size=40" -g +0+13 -a 40' &
