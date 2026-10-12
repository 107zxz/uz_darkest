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
    Scale 1.0;
	+NOGRAVITY;
// 	+BRIGHT;
	+WALLSPRITE;
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
    Scale 1.5;
	+BRIGHT;
	+WALLSPRITE;
	+NOGRAVITY;
  }
	
  States {
  SPAWN:
    SKYA A -1;
    Loop;
  }
}

class BigClock : Actor {
	Default {
	Scale 1.0;
	+BRIGHT;
	+WALLSPRITE;
	+NOGRAVITY;
	}
	
	States {
	SPAWN:
		CLCK A -1;
		Loop;
	}
}