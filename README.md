# bs-containers-core

[`OCaml-containers`](https://github.com/c-cube/ocaml-containers) core for BuckleScript. Only wrapper, no any modifications, so it should be safe for production.

## Usage

Add `bs-containers-core` to your project's dependencies by `yarn` or `npm`, And add it to `bs-dependencies` for `bsconfig.json`, e.g.

```json
{
    "name": "coolproj",
    "bs-dependencies": [
      "bs-containers-core"
    ]
}
```

## Notice

`CCArrayLabels` and `CCListLabels` are excluded due to BuckleScript reject to compile.

## Development

Under OCaml 4.02.3, run `sh mksrc.sh`.
