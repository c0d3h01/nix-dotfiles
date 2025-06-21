let
  userPublicKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICSjL8HGjiSAnLHupMZin095bql7A8+UDfc7t9XCZs8l harshalsawant.dev@gmail.com"
  ];

in
{
  "ssh-key.age".publicKeys = userPublicKeys;
  "element-key.age".publicKeys = userPublicKeys;
}
