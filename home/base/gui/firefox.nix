{
  programs.firefox = {
    enable = true;
    configPath = ".mozilla/firefox";
    #   profiles.default = {
    #     settings = {
    #       "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    #     };
    #     userChrome = ''
    #       /* hides the native tabs */
    #         #TabsToolbar {
    #           visibility: collapse;
    #         }
    #     '';
    #   };
  };
}
