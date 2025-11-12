{
  pkgs,
  lib,
  userConfig,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;

    # Pre-create production DB
    ensureDatabases = [ "production" ];

    settings.mysqld = {
      bind_address = "127.0.0.1";
      skip_symbolic_links = 1;
      local_infile = 0;
      sql_mode = "STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO";
      default_authentication_plugin = "mysql_native_password";

      # Logging
      log_error = "/var/log/mysql/error.log";
      slow_query_log = 1;
      slow_query_log_file = "/var/log/mysql/slow.log";

      # Performance tuning
      innodb_buffer_pool_size = "4G";
      innodb_log_file_size = "1G";
      innodb_flush_log_at_trx_commit = 2;
      max_connections = 200;
      table_open_cache = 2000;
      thread_cache_size = 100;
    };
  };

  environment.systemPackages = with pkgs; [
    mysql-workbench
    mariadb.client
    mycli
  ];
}
