
# aqua-installer

Development Container Feature to install aqua.

This feature installs aqua with [aqua-installer](https://aquaproj.github.io/docs/products/aqua-installer).
aqua-installer requires bash and curl or wget, so this feature tries to install them if they aren't found.

> [!NOTE]
> This feature doesn't set the environment variable `PATH` and run `aqua i` command, so you have to do yourself.

## Example Usage

```json
{
  "image": "debian:bookworm-20240423",
  "features": {
    "ghcr.io/aquaproj/devcontainer-features/aqua-installer:0.1.3": {
      "aqua_version": "v2.53.3"
    }
  },
  "remoteEnv": {
    "PATH": "/root/.local/share/aquaproj-aqua/bin:${containerEnv:PATH}"
  },
  "postStartCommand": "aqua i -l"
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| aqua_version | The version of aqua. This option is required | string | - |

## Update `aqua_version` by Renovate

You can update `aqua_version` by [aqua-renovate-config](https://aquaproj.github.io/docs/products/aqua-renovate-config).

aqua-renovate-config [2.3.0](https://github.com/aquaproj/aqua-renovate-config/releases/tag/2.3.0) or newer is required.

```json
{
  "extends": [
    "github>aquaproj/aqua-renovate-config#2.8.2"
  ]
}
```
