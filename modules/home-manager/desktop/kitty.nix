{ pkgs, ...}:

{
  home = {
    file = {
      ".terminfo/x/xterm-kitty".source = "${pkgs.kitty}/lib/kitty/terminfo/x/xterm-kitty";
    };

  };

  programs = {
    kitty = {
      enable = true;

      font = {
        package = pkgs.nerdfonts.override { fonts = [ "FiraCode" "DejaVuSansMono" ]; };
        name = "FiraCode Nerd Font";
      };

      settings = {
        cursor_blink_interval = 0;
        tab_bar_edge = "top";
        tab_bar_style = "separator";
        tab_separator  = " ";
        tab_title_template  = "<{title}>";
        active_tab_background = "#f00";
        inactive_tab_background = "#000";
      };
    };
  };
}
