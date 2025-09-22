{...}: {
  animations = {
    enabled = true;
    _beziers.bezier = [
      "specialWorkSwitch, 0.05, 0.7, 0.1, 1"
      "emphasizedAccel, 0.3, 0, 0.8, 0.15"
      "emphasizedDecel, 0.05, 0.7, 0.1, 1"
      "standard, 0.2, 0, 0, 1"
    ];
    animation = [
      "layersIn, 1, 5, emphasizedDecel, slide"
      "layersOut, 1, 4, emphasizedAccel, slide"
      "fadeLayers, 1, 5, standard"
      "windowsIn, 1, 5, emphasizedDecel"
      "windowsOut, 1, 3, emphasizedAccel"
      "windowsMove, 1, 6, standard"
      "workspaces, 1, 5, standard"
      "specialWorkspace, 1, 4, specialWorkSwitch, slidefadevert 15%"
      "fade, 1, 6, standard"
      "fadeDim, 1, 6, standard"
      "border, 1, 6, standard"
    ];
  };
}
