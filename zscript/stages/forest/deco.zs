class GrassDeco : Actor {
  Default {
    Radius 16;
    Scale 0.5;
  }
	
  States {
  SPAWN:
    GRAS AB 8;
    Loop;
  }
}

class BushDeco : Actor {
  Default {
    Radius 16;
    Scale 0.5;	
  }
	
  States {
  SPAWN:
    BUSH A -1;
    Loop;
  }
}

class TreelineDeco : Actor {
  Default {
    Radius 16;
    Scale 0.5;
  }
	
  States {
  SPAWN:
    TREE A -1;
    Loop;
  }
}

class MountainDeco : Actor {
  Default {
    Radius 16;
    Scale 0.5;
	+BRIGHT;
  }
	
  States {
  SPAWN:
    SKYA A -1;
    Loop;
  }
}