{...}: {
  gestures = {
    workspace_swipe_distance = 700;
    workspace_swipe_cancel_ratio = 0.15;
    workspace_swipe_min_speed_to_force = 5;
    workspace_swipe_direction_lock = true;
    workspace_swipe_direction_lock_threshold = 10;
    workspace_swipe_create_new = true;
  };

  gesture = [
    "$workspaceSwipeFingers, horizontal, workspace"
    "$gestureFingers, up, special, special"
    "$gestureFingers, down, dispatcher, exec, caelestia toggle specialws"
    "$gestureFingersMore, down, dispatcher, exec, systemctl suspend-then-hibernate"
  ];
}
