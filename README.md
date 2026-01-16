# helium-nix

Nix flake for the [Helium browser](https://helium.computer).

## Usage

### Quick start

```bash
nix run github:cloudglides/helium-nix
```

### In your flake

Add to inputs:

```nix
helium.url = "github:cloudglides/helium-nix";
```

Use the package:

```nix
environment.systemPackages = [ helium.packages.${system}.default ];
```

Or with overlay:

```nix
overlays = [ helium.overlays.default ];
# then use: pkgs.helium
```

### Build locally

```bash
nix build .#default
```

## Development

Format:
```bash
nix fmt
```
