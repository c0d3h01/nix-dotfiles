{ config, pkgs, ... }:

{
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;

    settings = {
      "mysqld" = {
        "bind-address" = "127.0.0.1";
        "port" = 3306;
        "skip-networking" = false;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    mariadb
    mysql84
    mysql-workbench
    parallel-full
  ];

  environment.variables.PATH = [ "${pkgs.mysql84}/bin" ];

  systemd.services.mysql = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
  };

  # Notes.
  # sudo mysql -u root
  # ALTER USER 'root'@'localhost' IDENTIFIED BY 'YourNewPassword';
  # FLUSH PRIVILEGES;
  # EXIT;
}
