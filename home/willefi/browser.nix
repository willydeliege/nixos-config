{
  pkgs,
  ...
}:
{
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
}
