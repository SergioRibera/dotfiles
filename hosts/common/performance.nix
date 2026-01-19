{ ... }:
{
  zramSwap = {
    algorithm = "zstd";
    enable = true;
    memoryPercent = 50;
  };

  # Fedora enables these options by default. See the 10-oomd-* files here:
  # https://src.fedoraproject.org/rpms/systemd/tree/acb90c49c42276b06375a66c73673ac3510255
  systemd.oomd = {
    enable = true;
    enableRootSlice = true;
    enableUserSlices = true;
    enableSystemSlice = true;
    settings.OOM = {
      "DefaultMemoryPressureDurationSec" = "20s";
    };
  };

  # BPF-based auto-tuning of Linux system parameters
  services.bpftune.enable = true;

  ## A few other kernel tweaks
  boot.kernel.sysctl = {
    "kernel.nmi_watchdog" = 0;
    "kernel.sched_cfs_bandwidth_slice_us" = 3000;
    "net.core.rmem_max" = 2500000;
    "vm.max_map_count" = 16777216;
    # ZRAM is relatively cheap, prefer swap
    "vm.swappiness" = 100;
    # ZRAM is in memory, no need to readahead
    "vm.page-cluster" = 0;
  };
}
