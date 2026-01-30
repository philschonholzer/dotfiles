{
  services.vicinae = {
    enable = true;
    systemd = {
      enable = true;
      autoStart = true;
    };
  };

  # Note: Vicinae's wrapper sets QT_PLUGIN_PATH which can conflict with other Qt apps
  # (e.g. qutebrowser). We work around this by unsetting these vars in qutebrowser wrappers
  # rather than trying to override vicinae's package, which would be more complex and
  # fragile across updates.
}
