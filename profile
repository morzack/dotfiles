# sourced by login shells and by greetd (source_profile defaults to true),
# so this is what puts ~/.local/bin on PATH for labwc and its keybinds.
case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac
