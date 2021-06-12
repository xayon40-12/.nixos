# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/hardware/network/broadcom-43xx.nix")
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/88adf322-692c-4eac-97d4-f5bd8669642a";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/67E3-17ED";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/7e6acc0d-96f8-4ddc-a18e-23d214bdb4c1"; }
    ];

  # use dhcp for wifi
  networking.interfaces.wlp3s0.useDHCP = true;

  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;

  hardware.opengl.extraPackages = with pkgs; [
    intel-compute-runtime
    intel-media-driver # LIBVA_DRIVER_NAME=iHD
    vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
    vaapiVdpau
    libvdpau-va-gl
  ];

  # Enable camera for macbook
  hardware.facetimehd.enable = true;

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
    linux = pkgs.linuxPackages.override {
      extraConfig = ''
        THUNDERBOLT m
      '';
    };
  };

  services.xserver.synaptics = {
    enable = true;
    accelFactor = "0.05";
    minSpeed = "0.5";
    maxSpeed = "1.0";
    tapButtons = true;
    fingersMap = [ 0 2 0 ];
    buttonsMap = [ 1 3 0 ];
    palmDetect = true;
    twoFingerScroll = true;
    additionalOptions = ''
      Option "VertScrollDelta" "200"
      Option "HorizScrollDelta" "200"
    '';
  };
}
