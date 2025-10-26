{pkgs, ...}: {
  services.swayidle = let
    # Lock command
    # lock = "${pkgs.swaylock}/bin/swaylock --daemonize";
    display = status: "${pkgs.niri}/bin/niri msg action power-${status}-monitors";
  in {
    enable = true;
    timeouts = [
      {
        timeout = 900; # in 15 min
        command = "${pkgs.libnotify}/bin/notify-send 'Monitor off in 60 seconds' -t 60000";
      }
      # {
      #   timeout = 20;
      #   command = lock;
      # }
      {
        timeout = 960;
        command = display "off";
        resumeCommand = display "on";
      }
      {
        timeout = 990;
        command = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];
    events = [
      {
        event = "before-sleep";
        # adding duplicated entries for the same event may not work
        # command = (display "off") + "; " + lock;
        command = display "off";
      }
      {
        event = "after-resume";
        command = display "on";
      }
      # {
      #   event = "lock";
      #   command = (display "off") + "; " + lock;
      # }
      # {
      #   event = "unlock";
      #   command = display "on";
      # }
    ];
  };
}
