let
  userPublicKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG5qPWYOZSxl3Fnsiu3fBCTxQuwGrigSoqHAoMpLGmAC harshalsawant.dev@gmail.com"
  ];

  systemPublicKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl"
  ];
in
{
  "ssh.age".publicKeys = userPublicKeys ++ systemPublicKeys;
}
