let
  laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOsbaU+oEvGzu2tmJQNC6wT3Ojss6k+T50/pd+J6O6zI";
  rice4k = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMAYIGZBaOMLoPStN9KB17o63gIKk0UczDmAMhAMGnkR";
  systems = [
    laptop
    rice4k
  ];

  s4rch = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMUEFSn6uU5q1EhFWCsqdjxI2usxO8MFBnD9ECHJtoep";
  users = [ s4rch ];
in
{
  "secrets/github.age".publicKeys = systems ++ users;
  "secrets/rustlanges.age".publicKeys = systems ++ users;
  "secrets/hosts.age".publicKeys = systems ++ users;
  "secrets/cftun01.age".publicKeys = systems ++ users;
}
