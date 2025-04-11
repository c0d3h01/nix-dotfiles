{
  networking.extraHosts =
    let
      hostsFile = builtins.fetchurl {
        url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
        sha256 = "0aiwpvv1fz5b3jffl270i8ldy9hgbih5ncdwqpvjxvrwzwxpappy";
      };
    in
    builtins.readFile hostsFile;
}
