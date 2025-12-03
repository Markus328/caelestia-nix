{
  path,
  mods,
  ...
}:
with mods; [
  (mkPassMod path "fish")
  (mkPassMod path "starship")
  (mkPassMod path "eza")
]
