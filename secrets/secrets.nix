let
  userPublicKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO8va6PxchHjK67XVlCqf8R2Hy7OeSji1Ve6PscBhhY0 harshalsawant.dev@gmail.com"
  ];

  systemPublicKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHzpjkemvDlj/Z4nj3Uzk1Mc6I+Jty8cDEqamzqfNcYK root@devbox"
  ];
in
{
  "ssh-key.age".publicKeys = userPublicKeys ++ systemPublicKeys;
  "element-key.age".publicKeys = userPublicKeys ++ systemPublicKeys;
}
