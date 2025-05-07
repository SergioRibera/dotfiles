let
  laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOsbaU+oEvGzu2tmJQNC6wT3Ojss6k+T50/pd+J6O6zI";
  rice4k = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFoUdDOk6GZZVL2lf7O66J2El30+aMWMyYgkmDMPrrkK";
  systems = [ laptop rice4k ];

  s4rch = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMUEFSn6uU5q1EhFWCsqdjxI2usxO8MFBnD9ECHJtoep";
  users = [ s4rch ];
in
{
  "secrets/github.age".publicKeys = systems ++ users;
  "secrets/rustlanges.age".publicKeys = systems ++ users;
  "secrets/hosts.age".publicKeys = systems ++ users;
}
