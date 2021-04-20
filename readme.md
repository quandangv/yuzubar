# Yuzubar - the YAML-based status bar

<p align="center">
  <img src="previews/mars-theme.png" width="50%" alt="Themes using yuzubar">
  <img src="previews/nuclear-theme.png" width="50%" alt="Themes using yuzubar">
</p>

## Dependencies
Yuzubar currently depends on Lemonbar and [Linkt](https://github.com/quandangv/linkt); I'm working to merge Lemonbar into Yambar itself.
1. **Lemonbar** - It's recommended to install the xft-supported version of lemonbar
```
git clone https://gitlab.com/protesilaos/lemonbar-xft
cd lemonbar-xft
make
make install
```
2. **Linkt** - Developed by myself :), it contains most of the core functionalities
```
git clone https://github.com/quandangv/linkt
cd linked_nodes
./build.sh -A
export LD_LIBRARY_DIR="$LD_LIBRARY_DIR:/usr/local/lib"
```

## Install & launch
After installing the dependencies, this should be simple:
- To install the tool:
```
make
make install
```
- To run an example, simply run `make full`
