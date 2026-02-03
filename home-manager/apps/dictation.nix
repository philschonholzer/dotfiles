# Dictation configuration using nerd-dictation
# Provides offline speech-to-text for English and German
#
# Usage:
#   dictation en   - Start English dictation
#   dictation de   - Start German dictation
#   dictation stop - Stop dictation
{
  pkgs,
  dictation,
  ...
}:
{
  home.packages = [
    dictation.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
