/*
// Rollback-only display shell. Combat position/velocity live in the match
// simulation; this actor contributes animation only.
class SuperGarlicVisual : Actor {
	Default {
		Radius 1;
		Scale 0.2;
		+BRIGHT;
		+NOGRAVITY;
		+NOBLOCKMAP;
	}

	override void Tick() {}

	void RollbackVisualTick() {
		Super.Tick();
	}

	States {
	SPAWN:
		GARL ABCDEFG 2;
		Loop;
	}
}

class SuperGarlic : Actor {
	Default {
		+BRIGHT;
		Radius 1;
		Scale 0.2;
//		Gravity 0.7;
	}

	int bounces;
	bool rollbackVisualOnly;

	override void Tick() {
		if (!rollbackVisualOnly) Super.Tick();
	}

	States {
	SPAWN:
		GARL ABCDEFG 2 {
			if (!rollbackVisualOnly && BaseFighter(target).HitLine(7,(Abs(Pos.X - target.Pos.X),Pos.Z-target.Pos.Z - 32),HITSTUN_MEDIUM,'SmashPuff',(0.3,0),'EB236X',MOVE_NOSCREENFREEZE)) {
				if (bounces < 1) {
					SetOrigin((Pos.X,0,target.Height),true);
					Vel.X /= Abs(Vel.X) * 1.5;
					Vel.Z = 8;
					bounces += 1;
				} else {
					Destroy();
				}
			}

			if (!rollbackVisualOnly && Pos.Z == FloorZ) Destroy();
		}
		Loop;
	}
}

class RollbackGarlicProjectile play {
	BaseFighter owner;
	SuperGarlicVisual visual;
	double x;
	double z;
	double velocityX;
	double velocityZ;
	int age;
	int bounces;
	int bornTic;

	void Initialize(BaseFighter source, SuperGarlicVisual display, vector3 spawnPos, double velX, double velZ, int spawnTic) {
		owner = source;
		visual = display;
		x = spawnPos.X;
		z = spawnPos.Z;
		velocityX = velX;
		velocityZ = velZ;
		age = 0;
		bounces = 0;
		bornTic = spawnTic;
		visual.SetOrigin(spawnPos, false);
		visual.bXFLIP = source.bXFLIP;
	}

	bool Step() {
		if (owner == null || visual == null) return false;

		// SuperGarlic's native state attacks once on entry to each two-tic frame.
		if (!(age & 1) && owner.HitLine(7,(Abs(x - owner.Pos.X), z-owner.Pos.Z - 32),HITSTUN_MEDIUM,'SmashPuff',(0.3,0),'EB236X',MOVE_NOSCREENFREEZE)) {
			if (bounces < 1) {
				z = owner.Height;
				velocityX /= Abs(velocityX) * 1.5;
				velocityZ = 8;
				bounces++;
			} else return false;
		}

		if (z <= owner.FloorZ) return false;

		x += velocityX;
		z += velocityZ;
		velocityZ -= owner.GetGravity();
		visual.SetOrigin((x, 0, z), true);
		visual.RollbackVisualTick();
		age++;
		return true;
	}
}

class RollbackGarlicSnapshot play {
	BaseFighter owner;
	vector3 position;
	double velocityX;
	double velocityZ;
	int age;
	int bounces;
	int bornTic;
	State visualState;
	int visualTics;

	void Capture(RollbackGarlicProjectile projectile) {
		owner = projectile.owner;
		position = (projectile.x, 0, projectile.z);
		velocityX = projectile.velocityX;
		velocityZ = projectile.velocityZ;
		age = projectile.age;
		bounces = projectile.bounces;
		bornTic = projectile.bornTic;
		visualState = projectile.visual.CurState;
		visualTics = projectile.visual.tics;
	}
}
*/
