class SmashPuff : Actor {
	int rollbackBornTic;

	void InitializeHitEffect(BaseFighter source, BaseFighter victim) {
		bXFLIP = source.bXFLIP;
		int offsetMult = bXFLIP ? -1 : 1;
		double effectZ = victim ? victim.Pos.Z + victim.Height * 0.5 : Pos.Z - 32;
		SetOrigin((Pos.X + 8 * offsetMult, Pos.Y, effectZ), false);
		rollbackBornTic = source.rollbackHandler ? source.rollbackHandler.rollbackCurrentTic : -1;
		SetStateLabel('Visible');
	}

	Default {
		Scale 0.25;
		+NOGRAVITY;
		+BRIGHT;
		+NOINTERACTION;
		Height 1;
	}

	States {
	Spawn:
		TNT1 A 0;
	Visible:
		SPUF ABCDEFGH 1;
		Stop;
	}
}

class BlockPuff : Actor {
	int rollbackBornTic;

	void InitializeHitEffect(BaseFighter source, BaseFighter victim) {
		bXFLIP = source.bXFLIP;
		int offsetMult = bXFLIP ? -1 : 1;
		double effectZ = victim ? victim.Pos.Z + victim.Height * 0.5 : Pos.Z - 32;
		SetOrigin((Pos.X + 8 * offsetMult, Pos.Y, effectZ), false);
		rollbackBornTic = source.rollbackHandler ? source.rollbackHandler.rollbackCurrentTic : -1;
		SetStateLabel('Visible');
	}

	Default {
		Scale 0.1;
		+NOGRAVITY;
		+BRIGHT;
		+NOINTERACTION;
		Height 1;
	}

	States {
	Spawn:
		TNT1 A 0;
	Visible:
		SPUB ABCDEFGH 1;
		Stop;
	}
}

class SlashPuff : Actor {
	int rollbackBornTic;

	void InitializeHitEffect(BaseFighter source, BaseFighter victim) {
		bXFLIP = source.bXFLIP;
		int offsetMult = bXFLIP ? -1 : 1;
		double effectZ = victim ? victim.Pos.Z + victim.Height * 0.5 : Pos.Z - 96;
		SetOrigin((Pos.X + 8 * offsetMult, Pos.Y, effectZ), false);
		rollbackBornTic = source.rollbackHandler ? source.rollbackHandler.rollbackCurrentTic : -1;
		SetStateLabel('Visible');
	}

	Default {
		Scale 0.37;
		+NOGRAVITY;
		+BRIGHT;
		+NOINTERACTION;
		+NOROLLBACK;
		Height 1;
	}

	States {
	Spawn:
	Visible:
		SPUV ABCDEFGH 1;
		Stop;
	}
}

class ThisIsYou : Actor {
	Default {
		Scale 0.1;
// 		RenderStyle 'Add';
		+NOGRAVITY;
		+BRIGHT;
		+NOINTERACTION;
		Height 1;
	}
	
	States {
	Spawn:
		YOUU A 15;
		YOUU AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 1 {
			Vel.Z += 0.15;
		}
		Stop;
	}
}