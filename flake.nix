{
  description = "Development environment templates and packages collection";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    let
      # Helper function to read template metadata from CLAUDE.md or README.md
      readTemplateMetadata =
        templatePath:
        let
          claudeFile = templatePath + "/CLAUDE.md";
          readmeFile = templatePath + "/README.md";
          flakeFile = templatePath + "/flake.nix";

          # Try to read description from flake.nix first
          flakeContent = builtins.readFile flakeFile;
          descMatch = builtins.match ".*description = \"([^\"]+)\".*" flakeContent;
          description =
            if descMatch != null then builtins.head descMatch else "Development environment template";

          # Extract first paragraph from CLAUDE.md or README.md for welcomeText
          docFile = if builtins.pathExists claudeFile then claudeFile else readmeFile;
          welcomeText =
            if builtins.pathExists docFile then
              let
                content = builtins.readFile docFile;
                # Take first 500 characters as a preview
                preview = builtins.substring 0 500 content;
              in
              ''
                ${preview}

                For full documentation, see CLAUDE.md or README.md in the template.
              ''
            else
              "See template files for documentation.";
        in
        {
          inherit description;
          welcomeText = welcomeText;
        };

      # Auto-discover all templates from ./templates/ directory
      discoverTemplates =
        let
          templatesDir = ./templates;
          # Read all entries in templates directory
          entries = builtins.readDir templatesDir;
          # Filter only directories (each template is a directory)
          templateDirs = nixpkgs.lib.filterAttrs (_: type: type == "directory") entries;
          # Transform into template definitions
          makeTemplate =
            name: _:
            let
              templatePath = templatesDir + "/${name}";
              metadata = readTemplateMetadata templatePath;
            in
            {
              path = templatePath;
              description = metadata.description;
              welcomeText = metadata.welcomeText;
            };
        in
        nixpkgs.lib.mapAttrs makeTemplate templateDirs;

      # Auto-discover all packages from ./packages/ directory
      discoverPackages =
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          packagesDir = ./packages;
        in
        if builtins.pathExists packagesDir then
          let
            entries = builtins.readDir packagesDir;
            # Filter only directories that contain a package.nix or default.nix
            packageDirs = nixpkgs.lib.filterAttrs (
              name: type:
              type == "directory"
              && (
                builtins.pathExists (packagesDir + "/${name}/package.nix")
                || builtins.pathExists (packagesDir + "/${name}/default.nix")
              )
            ) entries;
            # Import each package
            importPackage =
              name: _:
              let
                packagePath = packagesDir + "/${name}";
                packageFile =
                  if builtins.pathExists (packagePath + "/package.nix") then
                    packagePath + "/package.nix"
                  else
                    packagePath + "/default.nix";
              in
              pkgs.callPackage packageFile { };
          in
          nixpkgs.lib.mapAttrs importPackage packageDirs
        else
          { };
    in
    # Per-system outputs (packages, devShells, apps)
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        packages = discoverPackages system;
      in
      {
        # Expose all discovered packages
        packages = packages;

        # Auto-generate apps from packages
        apps = nixpkgs.lib.mapAttrs (
          name: pkg: {
            type = "app";
            program = "${pkg}/bin/${name}";
          }
        ) packages;

        # Default development shell with common tools
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            wget
            yq
            jq
            nodejs
            python3
            git
            curl
          ];
          shellHook =
            let
              templateList = builtins.concatStringsSep ", " (builtins.attrNames (discoverTemplates));
              packageList = builtins.concatStringsSep ", " (builtins.attrNames packages);
            in
            ''
              echo "Nix Flakes Development Repository"
              echo ""
              echo "Available packages (${builtins.toString (builtins.length (builtins.attrNames packages))}): ${packageList}"
              echo ""
              echo "Available templates (${builtins.toString (builtins.length (builtins.attrNames (discoverTemplates)))}): ${templateList}"
              echo ""
              echo "Usage:"
              echo "  nix flake init -t github:gui-wf/flakes#<template>"
              echo "  nix build .#<package>"
              echo "  nix run .#<package>"
            '';
        };
      }
    )
    // {
      # Non-system-specific outputs (templates)
      templates = discoverTemplates;
    };
}
