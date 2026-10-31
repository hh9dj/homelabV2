{
  device ? "/dev/nvme0n1",
  ...
}:
{
  disko.devices.disk.main = {
    inherit device;
    type = "disk";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          size = "1G";
          type = "EF00";
          label = "ESP";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [
              "fmask=0077"
              "dmask=0077"
            ];
          };
        };
        swap = {
          size = "8G";
          label = "swap";
          content = {
            type = "swap";
          };
        };
        root = {
          size = "100G";
          label = "root";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
        data = {
          size = "100%";
          label = "data";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/srv";
          };
        };
      };
    };
  };
}
