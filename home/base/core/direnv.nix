{...}:
{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;

    config.global = {
      # Without this every load dumps the whole mkShell env diff
      # ("export +AR +AS +CC ...") into the prompt, which makes a cached,
      # no-op load look like a full reload.
      hide_env_diff = true;
      # The default is 5s, which trips the "taking a while" warning on any
      # dev shell that actually has to be evaluated.
      warn_timeout = "30s";
    };
  };
}
