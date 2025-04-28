{ pkgs, ... }:
{
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Name = "Hello";
        ControllerMode = "dual";
        FastConnectable = "true";
        Experimental = "true";
        KernelExperimental = "true";
      };
      Policy = {
        AutoEnable = "true";
      };
    };
  };

  services.blueman.enable =  true;
  services.dbus.enable = true;
}
