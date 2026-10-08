class Eye1 : Actor {
  Default {
    Scale 2.1;
	+BRIGHT;
  }
	
  States {
  SPAWN:
    EYEB B -1;
    Loop;
  }
}

class Eye2 : Actor {
  Default {
    Scale 1.2;
	+BRIGHT;
  }
	
  States {
  SPAWN:
    EYEB C -1;
    Loop;
  }
}

class Eye3 : Actor {
  Default {
    Scale 1.2;
	+BRIGHT;
  }
	
  States {
  SPAWN:
	EYEB D -1;
//     EYEB D 4 {
// 		bBRIGHT = !bBRIGHT;
// 	}
    Loop;
  }
}

class Eye4 : Actor {
  Default {
    Scale 1.2;
  }
	
  States {
  SPAWN:
    EYEB E -1;
    Loop;
  }
}

class Crystal : Actor {
	Default {
	+BRIGHT;
	}

	States {
	SPAWN:
		CRYS A -1;
		Loop;
	}
}


class Tentacle : Actor {
	Default {
	+BRIGHT;
	}

	States {
	SPAWN:
		CRYS BBBCDDDC 10;
		Loop;
	}
}


class Tentacle2 : Actor {
	Default {
	+BRIGHT;
	+XFLIP;
	Scale 0.85;
	}

	States {
	SPAWN:
		CRYS BBBCDDDC 10;
		Loop;
	}
}