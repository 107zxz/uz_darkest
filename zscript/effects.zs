class RollbackHitEffect : Actor abstract {
	int rollbackBornTic;

	virtual double HitEffectVerticalOffset() { return -32; }

	void InitializeHitEffect(BaseFighter source, BaseFighter victim) {
		if (source == null) return;
		bXFLIP = source.bXFLIP;
		int offsetMult = bXFLIP ? -1 : 1;
		double effectZ = (victim ? victim.Pos.Z + victim.Height * 0.5 : Pos.Z) + HitEffectVerticalOffset();
		SetOrigin((Pos.X + 8 * offsetMult, Pos.Y, effectZ), false);
		rollbackBornTic = source.rollbackHandler ? source.rollbackHandler.rollbackCurrentTic : -1;
		SetStateLabel('Visible');
	}
}

class SmashPuff : RollbackHitEffect {

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

class BlockPuff : RollbackHitEffect {

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

class SlashPuff : RollbackHitEffect {
	override double HitEffectVerticalOffset() { return -96; }

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
                TNT1 A 0;
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