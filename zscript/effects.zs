class SmashPuff : Actor {
	Default {
		Scale 0.25;
		+NOGRAVITY;
		+BRIGHT;
		+NOINTERACTION;
		Height 1;
	}

	States {
	Spawn:
		TNT1 A 0 NoDelay {
			bXFLIP = DamageSource.bXFLIP;
			
			int offsetMult = 1;
			if (bXFLIP) offsetMult = -1;
			
			SetOrigin((Pos.X+8*offsetMult, Pos.Y, Pos.Z-32),false);
			
			// Try
			bXFLIP = random(0,1);
		}
		SPUF ABCDEFGH 1;
		Stop;
	}
}

class BlockPuff : Actor {
	Default {
		Scale 0.1;
		+NOGRAVITY;
		+BRIGHT;
		+NOINTERACTION;
		Height 1;
	}

	States {
	Spawn:
		TNT1 A 0 NoDelay {
			bXFLIP = DamageSource.bXFLIP;
			
			int offsetMult = 1;
			if (bXFLIP) offsetMult = -1;
			
			SetOrigin((Pos.X+8*offsetMult, Pos.Y, Pos.Z-32),false);
		}
		SPUB ABCDEFGH 1;
		Stop;
	}
}

class SlashPuff : Actor {
	Default {
		Scale 0.37;
		+NOGRAVITY;
		+BRIGHT;
		+NOINTERACTION;
		Height 1;
	}

	States {
	Spawn:
		TNT1 A 0 NoDelay {
			bXFLIP = DamageSource.bXFLIP;
			
			int offsetMult = 1;
			if (bXFLIP) offsetMult = -1;
			
			SetOrigin((Pos.X+8*offsetMult, Pos.Y, Pos.Z-96),false);
			
			// Try
			bXFLIP = random(0,1);
		}
		SPUV ABCDEFGH 1;
		Stop;
	}
}