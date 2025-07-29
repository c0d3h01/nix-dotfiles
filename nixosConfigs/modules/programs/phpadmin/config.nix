{
  stdenv,
  fetchurl,
  lib,
  unzip,
}:

let
  version = "5.2.1";

in
stdenv.mkDerivation rec {
  pname = "phpmyadmin";
  inherit version;

  src = fetchurl {
    url = "https://files.phpmyadmin.net/phpMyAdmin/${version}/phpMyAdmin-${version}-all-languages.tar.xz";
    sha256 = "0mr53fsdd7fvfwiz9vcpy82w6s4y32nmsv9ifpzdd5mxvycragrp";
  };

  nativeBuildInputs = [ ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/phpmyadmin
    cp -r * $out/share/phpmyadmin/

    # Create basic config
    cp $out/share/phpmyadmin/config.sample.inc.php $out/share/phpmyadmin/config.inc.php

    runHook postInstall
  '';

  meta = with lib; {
    description = "Web interface for MySQL and MariaDB";
    homepage = "https://www.phpmyadmin.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
  };
}
