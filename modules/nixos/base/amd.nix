{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # AMD specific
    ryzenadj # TDP/PPT limits (you have this)
    amdgpu_top # like nvtop but for AMD, shows GPU+CPU power states
  ];
}
