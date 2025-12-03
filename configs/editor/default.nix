{
  path,
  mods,
  ...
}:
with mods; [
  (mkMod path "micro")
]
