PREFIX?=/usr
BINDIR=${PREFIX}/bin

# Font name and sizes for the example bars
font=Montserrat
font_size=22
icon_size=20

# Build the main executable
build/yuzubar: yuzubar.cpp build/generated/command-line-help.txt
	mkdir -p build
	g++ yuzubar.cpp -llinkt_lang -llinkt_node -L/usr/local/lib -std=c++17 -o build/yuzubar -I build/generated || error Failed to build $@, did you install lemonbar and linkt_nodes?

# Preprocess the file containing command-line help
build/generated/command-line-help.txt: command-line-help.txt.in
	mkdir -p build/generated
	sed 's/^/"/g; s/$$/\\n"/g' command-line-help.txt.in > build/generated/command-line-help.txt

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
simple: build/yuzubar prep_example 
	./build/yuzubar -k simple.yzb

# Launch a full example bar
full: build/yuzubar build/install_font prep_example
	./build/yuzubar -k example.yzb ~/.config/yuzubar/default.yzb \
	    -f "${font}:size=${font_size}:weight=light" \
	    -f "${font}:size=${font_size}:weight=regular" \
	    -f "Iosevka Nerd Font:size=${icon_size}" \
	    -l "lemonbar -b -a 40 -u 2 -g x40" \

# Install yuzubar
install: build/yuzubar
	$$(type sudo>/dev/null && echo sudo) install -D -m 755 build/yuzubar ${DESTDIR}${BINDIR}/yuzubar

# Delete the build directory
clean:
	rm -rf build

.PHONY:= run kill_bar prep_example
