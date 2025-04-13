# Notes.
# sudo mysql -u root
# ALTER USER 'root'@'localhost' IDENTIFIED BY 'YourNewPassword';
# FLUSH PRIVILEGES;
# EXIT;

{ pkgs, ... }:
{
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };
  environment.systemPackages = with pkgs; [
    mariadb
    mysql-workbench
    parallel
  ];
}
