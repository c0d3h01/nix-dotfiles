{ config, username, ... }:

{
  age.secrets = {
    wifi-password = {
      file = ./secrets/wifi-password.age;
      owner = "${username}";
    };
  };
}
