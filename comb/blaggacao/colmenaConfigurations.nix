{
  inputs,
  cell,
}: {
  ws = {
    system = "x86_64-linux";
    packages = inputs.nixos.legacyPackages;
  };
}
