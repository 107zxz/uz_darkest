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

class SuperGarlic : Actor {
	Default {
		+BRIGHT;
		Radius 1;
		Scale 0.2;
// 		Gravity 0.7;
	}
	
	int bounces;
	
	States {
	SPAWN:
		GARL ABCDEFG 2 {
			if (BaseFighter(target).HitLine(7,(Abs(Pos.X - target.Pos.X),Pos.Z-target.Pos.Z - 32),HITSTUN_MEDIUM,'SmashPuff',(0.3,0),'EB236X',MOVE_NOSCREENFREEZE)) {
				if (bounces < 1) {
					SetOrigin((Pos.X,0,target.Height),true);
					Vel.X /= Abs(Vel.X) * 1.5;
					Vel.Z = 8;
					
					bounces += 1;
				} else {
					Destroy();
				}
			}
			
			if (Pos.Z == FloorZ) Destroy();
		}
		Loop;
	}
}