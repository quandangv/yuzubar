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
```

## Install & launch
After installing the dependencies, this should be simple:
- To install the tool:
```
make
make install
```
- To run an example, simply run `make run`
