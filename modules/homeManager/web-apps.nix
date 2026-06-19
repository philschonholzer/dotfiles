{ ... }: {
  flake.modules.homeManager.web-apps = import ../../home-manager/apps/web-apps;
}
