{
  nix.distributedBuilds = true;
  nix.settings.builders-use-substitutes = true;

  programs.ssh.extraConfig = ''
    Host build1.hardlight.internal
      Port 2201
  '';

  nix.buildMachines = [
    {
      hostName = "build1.hardlight.internal";
      protocol = "ssh-ng";
      sshUser = "nix-ssh";
      sshKey = "/var/root/.ssh/remotebuild";
      system = "x86_64-linux";
      maxJobs = 4;
      speedFactor = 2;
      supportedFeatures = [
        "nixos-test"
        "big-parallel"
        "kvm"
      ];
    }
  ];
}
