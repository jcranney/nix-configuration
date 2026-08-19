{ den, ... }: {
  flake.den = den;  #
  den.hosts.x86_64-linux.agnes.users.jcranney = {};
  den.hosts.x86_64-linux.agnes.users.abdu = {};

  den.aspects.agnes = {
    includes = [
      den.aspects.grub-boot
    ];

    provides.jcranney.includes = [ den.batteries.primary-user ];
    provides.abdu.includes = [ den.batteries.primary-user ];
    
    nixos = { pkgs, lib, ... }: {
      imports = [ 
        ./_nixos/agnes-hardware-configuration.nix
      ];
      
      # Open ports in the firewall.
      networking.firewall.allowedTCPPorts = [ 
        1883  # mqtt unencrypted port
        8888  # ffmpeg http camera server for mediamtx
        # other applications have an "openFirewall=true;" option
      ];

      systemd.services.temp-logger = {
        enable = true;
        serviceConfig = {
          ExecStart = ''/home/jcranney/temp-logger'';
          WorkingDirectory = ''/home/jcranney'';
          Type = "simple";
        };
        description = "Service for logging temperature data to file for post-processing";
        after = [ "network.target" ];
	wantedBy = [ "default.target" ];
      };

      services.mosquitto = {
        enable = true;
        listeners = [
          {
            acl = [ "pattern readwrite #" ];
            omitPasswordAuth = true;
            settings.allow_anonymous = true;
          }
        ];
      };

      services.octoprint = {
        enable = true;
        openFirewall = true;
        port = 5001;
        plugins = plugins: with plugins; [ mqtt ];
      };

      environment.systemPackages = [ pkgs.x265 ];
      services.mediamtx = {
        enable = true;
        settings = {
          paths = {
            cam = {
              runOnInit = "${pkgs.ffmpeg-full}/bin/ffmpeg -f v4l2 -i /dev/video0 -c:v libx265 -f rtsp rtsp://0.0.0.0:$RTSP_PORT/$RTSP_PATH";
              runOnInitRestart = true;
            };
          };
        };
        allowVideoAccess = true;
      };

      services.node-red = {
        enable = true;
        withNpmAndGcc = true;
        user = "jcranney";
        define = {
            "uiHost"= "0.0.0.0";
        };
        openFirewall = true;
      };
      # If you want to imperatively install most npm packages, you will need nix-ld since npm is typically
      # not very pure (to say the least)
      programs.nix-ld.enable = true;
      systemd.services.node-red = {
        path = with pkgs; [
          # git is needed for projects, but systemd resets the path so we need to add it back
          git
          # needed by nodejs to install for instance node-red-dashboard (or "error syscall spawn sh")
          bash
          # Add here any other program needed by the npm packages you want to install
        ];
        environment = {
          # environment variables are removed, so we need to specify nix-ld environment here
          NIX_LD = lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker";
          NIX_LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath [
            # List by default
            zlib
            zstd
            stdenv.cc.cc
            curl
            openssl
            attr
            libssh
            bzip2
            libxml2
            acl
            libsodium
            util-linux
            xz
            systemd
          ];
        };
      };

      services.home-assistant = {
        openFirewall = true;
        openFirewallForComponents = true;
        enable = true;
        extraComponents = [
          # Components required to complete the onboarding
          "esphome"
          "met"
          "radio_browser"
          "octoprint"
          "cast"
          "homekit"
          "homekit_controller"
          "mqtt"
          "bluetooth"
          "upnp"
          # "hacs"
        ];
        config = {
          # Includes dependencies for a basic setup
          # https://www.home-assistant.io/integrations/default_config/
          default_config = {};
          http = {
            use_x_forwarded_for = true;
            trusted_proxies = [ "127.0.0.1" "::1" "192.168.1.109" ];
          };
        };
      };
    };
  };
}

