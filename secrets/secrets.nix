let
  userPublicKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG5qPWYOZSxl3Fnsiu3fBCTxQuwGrigSoqHAoMpLGmAC harshalsawant.dev@gmail.com"
  ];

  systemPublicKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIdsj+1/I+lofo/qHqRIt3gOyEUtnQBRqONBeDq6SJOY root@devbox"
  ];
in
{
  "ssh.age".publicKeys = userPublicKeys ++ systemPublicKeys;
  "userPassword.age".publicKeys = userPublicKeys ++ systemPublicKeys;
  "sshPublicKeys.age".publicKeys = userPublicKeys ++ systemPublicKeys;
  "element.age".publicKeys = userPublicKeys ++ systemPublicKeys;
}
