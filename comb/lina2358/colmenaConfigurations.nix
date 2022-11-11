{
  lavinox = {
    networking.hostName = "lavinox";
    deployment = {
      allowLocalDeployment = true;
      targetHost = null;
    };
    imports = [cell.nixosConfigurations.lavinox];
  };
}
