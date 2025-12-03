{
  config,
  path,
  mods,
  ...
}:
with mods; [
  (mkPassMod path ["shell"])
  (mkPassMod path ["cli"])
]
