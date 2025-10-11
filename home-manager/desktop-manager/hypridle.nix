{lib, ...}: {
  services.hypridle.settings.listener = lib.mkForce [
    {
      timeout = 300;
      on-timeout = "loginctl lock-session";
    }
    {
      timeout = 900;
      on-timeout = "systemctl suspend";
    }
  ];
}
