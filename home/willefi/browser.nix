{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    buku # Bookmarks manager
  ];
  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    extensions = [
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # bitwarden
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # dark reader
      { id = "omkfmpieigblcllmkgbflkikinpkodlk"; } # h264
      { id = "fihnjjcciajhdojfnbdddfaoknhalnja"; } # I don't care cookies
      { id = "hkgfoiooedgoejojocmhlaklaeopbecg"; } # Picture in Picture
      { id = "gfbliohnnapiefjpjlpjnehglfpaknnc"; } # surfing keys
      { id = "gkkkcomfmldkigajkmljnbpiajbpbgdg"; } # translations
      { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; } # ublick origin lite
    ];

  };

  # Configuration des services systemd utilisateur
  systemd.user.services.sync-brave-buku = {
    Unit = {
      Description = "Synchronisation automatique des marque-pages Brave vers Buku";
    };
    Service = {
      Type = "oneshot";
      # Le script vérifie si le fichier existe avant d'importer pour éviter les erreurs au premier démarrage
      ExecStart = "${pkgs.bash}/bin/bash -c 'if [ -f ~/.config/BraveSoftware/Brave-Browser/Default/Bookmarks ]; then ${pkgs.buku}/bin/buku -i ~/.config/BraveSoftware/Brave-Browser/Default/Bookmarks; fi'";
    };
  };

  # Déclencheur (Timer) pour exécuter la synchronisation périodiquement
  systemd.user.timers.sync-brave-buku = {
    Unit = {
      Description = "Déclencheur pour la synchronisation Brave-Buku";
    };
    Timer = {
      # S'exécute 5 minutes après le démarrage de la session utilisateur
      OnStartupSec = "5m";
      # Puis se répète toutes les heures
      OnUnitActiveSec = "1h";
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
  # NOTE: ne pas oublier
  # systemctl --user daemon-reload
  # systemctl --user enable --now sync-brave-buku.timer
}
