{
  services.libinput = {
    enable = true;

    mouse = {
      accelProfile = "flat"; # Consistent speed regardless of movement speed
      accelSpeed = "0"; # Neutral sensitivity (1:1 mapping)
      middleEmulation = false; # Disable middle-click on simultaneous press
    };

    touchpad = {
      naturalScrolling = true; # Scroll direction matches finger movement
      tapping = true; # Enable tap-to-click
      tappingDragLock = true; # Hold finger to drag after double-tap
      clickMethod = "clickfinger"; # Left/Right/Middle based on button area
      disableWhileTyping = true; # Prevent accidental palm touches
      accelProfile = "adaptive"; # Smoother acceleration curve for precision
      accelSpeed = "0.2"; # Slightly faster than default for small trackpads
      sendEventsMode = "enabled"; # Auto-disable when mouse is plugged in
    };
  };
}
