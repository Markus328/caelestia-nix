{
  path,
  mods,
  ...
}:
with mods; [
  (mkMod path "micro")
  (mkPassMod path "zed")
  (mkPassMod path "vscode")
]
