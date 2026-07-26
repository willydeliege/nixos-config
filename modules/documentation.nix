{
  lib,
  stdenv,
  ...
}:

{

  documentation = {
    enable = true;
    man.cache.generateAtRuntime = true;
    man.cache.enable = true;
    man.enable = true;
    man.man-db.enable = true;
    dev.enable = true; # Optionnel : inclut aussi les manuels de développement
    info.enable = true;
    nixos.enable = true;

  };
}
