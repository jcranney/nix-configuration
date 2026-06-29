{ den, ... }: {
  den.aspects.systemd-boot = {
    nixos = {pkgs, ...}: {
      # Bootloader.
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.loader.grub.timeoutStyle = "hidden";
    };
    includes = [
      den.aspects.common
    ];
  };

  den.aspects.grub-boot = {
    nixos = {pkgs, ...}: {
      # Bootloader.
      boot.loader.grub.enable = true;
      boot.loader.grub.device = "/dev/sda";
      boot.loader.grub.useOSProber = false;
    };
    includes = [
      den.aspects.common
    ];
  };

  den.aspects.common = {
    nixos = {pkgs, ...}: {
      # Select internationalisation properties.
      i18n.defaultLocale = "en_GB.UTF-8";

      i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_AU.UTF-8";
        LC_IDENTIFICATION = "en_AU.UTF-8";
        LC_MEASUREMENT = "en_AU.UTF-8";
        LC_MONETARY = "en_AU.UTF-8";
        LC_NAME = "en_AU.UTF-8";
        LC_NUMERIC = "en_AU.UTF-8";
        LC_PAPER = "en_AU.UTF-8";
        LC_TELEPHONE = "en_AU.UTF-8";
        LC_TIME = "en_AU.UTF-8";
      };

      networking.networkmanager.enable = true;
      time.timeZone = "Australia/Sydney";

      # Configure keymap in X11
      services.xserver.xkb = {
        layout = "au";
        variant = "";
      };
      
      services.avahi = {
        enable = true;
        nssmdns4 = true;
        publish = {
          enable = true;
          addresses = true;
          domain = true;
          hinfo = true;
          userServices = true;
          workstation = true;
        };
        openFirewall = true;
      };

      services.printing = {
        enable = true;
        drivers = with pkgs; [
          cups-filters
          cups-browsed
        ];
      };

      nix.extraOptions = "experimental-features = nix-command flakes";

      # Enable the OpenSSH daemon.
      services.openssh = {
        enable = true;
        openFirewall = true;
      };

      networking.firewall.enable = true;
    };

  };
}
