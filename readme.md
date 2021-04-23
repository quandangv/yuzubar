# Yambar - the YAML-based status bar

## Dependencies
Yambar currently depends on Lemonbar and Linked_nodes; I'm working to merge Lemonbar into Yambar itself.
1. Lemonbar: It's recommended to install the xft-supported version of lemonbar
```
git clone https://gitlab.com/protesilaos/lemonbar-xft
cd lemonbar-xft
make
make install
```
2. Linked_nodes: Developed by myself :), it contains most of the core functionalities
```
git clone https://github.com/quandangv/linked_nodes
cd linked_nodes
./build.sh -A
export LD_LIBRARY_DIR="$LD_LIBRARY_DIR:/usr/local/lib"
```

## Install
After installing the dependencies, execute these command to install yuzubar:
```
make
make install
```

## Examples
To launch an example bar, simply run `make full`. To launch a simple, easy-to-understand bar, run `make simple`. The commands used to start the bar in these examples will be printed out by _make_
