class GenericHitbox : Actor {
	Default {
		+NOGRAVITY;
		Projectile;
		Damage 12;
		Speed 12;
		RenderStyle "STYLE_Translucent";
		Alpha 0.5;
		Scale 0.8;
	}
	
	States {
	SPAWN:
		HITB A 3 NoDelay {
			SetOrigin((Pos.X-100,Pos.Y,Pos.Z),false);
		}
		Loop;
	}
}

class SuperCross : Actor {
	Default {
		Projectile;
		Damage 1;
		Scale 0.2;
		Height 86;
		+BRIGHT;
		+RIPPER;
	}
	
	States {
	SPAWN:
		EB22 DEDEDEDE 4;
		Stop;
	}
}