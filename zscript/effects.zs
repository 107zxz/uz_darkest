class SmashPuff : Actor {
	Default {
		Scale 0.5;
		+NOGRAVITY;
	}

	States {
	Spawn:
		TNT1 A 0 NoDelay {
			bXFLIP = DamageSource.bXFLIP;
			
			int offsetMult = 1;
			if (bXFLIP) offsetMult = -1;
			
			SetOrigin((Pos.X+8*offsetMult, Pos.Y, Pos.Z-24),false);
		}
		SPUF ABCD 1;
		Stop;
	}
}