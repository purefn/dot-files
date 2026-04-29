{
  services = {
    wayle = {
      enable = true;

      settings = {
        lock_cmd = "hyprlock &";
      #   clock.format = "%F %X";
      #   system_info = {
      #     indicators = [ "Cpu" "Memory" "Temperature" "DownloadSpeed" "UploadSpeed" ];
      #     temperature.sensor = "CPU temp";
      #   };
      #
      #   modules = {
      #     center = [
      #       "WindowTitle"
      #     ];
      #     left = [
      #       "Workspaces"
      #     ];
      #     right = [
      #       "SystemInfo"
      #       [
      #         "Tray"
      #         "Clock"
      #         "Privacy"
      #         "Settings"
      #       ]
      #     ];
      #   };
      };
    };
  };
}
