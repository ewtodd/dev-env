{
  description = "Development shell flake templates";

  outputs = { self }: {
    templates = {
      default = {
        path = ./dev-shell;
        description = "Nix development shell with Python and ROOT";
        welcomeText = ''
          Run `nix develop` to enter the development environment.
        '';
      };

      dev-shell = self.templates.default;
    };
  };
}
