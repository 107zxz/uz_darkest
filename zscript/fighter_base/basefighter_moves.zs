const HITSTUN_LIGHT = 3;
const HITSTUN_MEDIUM = 5;
const HITSTUN_HEAVY = 7;

enum CancelType {
	CANCEL_MAGIC,
	CANCEL_SPECIAL,
	CANCEL_JUMP
}

extend class BaseFighter {

	Actor lastHitTarget;
	int cancelTics;
	ComboSequence combo;
	bool inAir;
	
// 	int airJumps;

	void MovesPostBeginPlay() {
	
	}
	
	
	
	void MovesTick() {
		// This one's important, if we land in an air move early cancel it.
		// Also if you're getting hit and land end the combo
		if (Pos.Z == FloorZ && inAir) {
// 			Console.Printf("Hiii");
			SetStateLabel("LAND");
			inAir = Pos.Z != FloorZ;
			return;
		}
		inAir = Pos.Z != FloorZ;
	
		if (InStateSequence(curstate, ResolveState("IDLE"))) HandleIdle();
		if (InStateSequence(curstate, ResolveState("CROUCH"))) HandleCrouch();
		if (InStateSequence(curstate, ResolveState("JUMP"))) HandleJump();
		if (InStateSequence(curstate, ResolveState("WALK"))) HandleWalk();
			
		// Cancels
		if (cancelTics > 0) {
			cancelTics -= 1;
			
			if (!inAir) {
				if (ButtonDown("8") || CheckSpecialInput("8")) {
					if (ButtonPressed(BT_MOVELEFT)) Vel.X = -2;
					if (ButtonPressed(BT_MOVERIGHT)) Vel.X = 2;
					Vel.Z = 10;
					SetOrigin((Pos.X,Pos.Y,Pos.Z+1),false);
					SetStateLabel("JUMP");
					AirMoves();
				} else GroundMoves();
			} else {
				AirMoves();
			}
		}
	}
	
	void IAmHit(BaseFighter inflictor, int dmg, Vector2 knockback, bool blocked, Name moveName) {
		if (blocked) {
			freezetics = dmg/2;
			Vel = (knockback.X * -(1-Angle / 90),0,0);
			inflictor.Vel += (knockback.X * (1-Angle / 90),0,0);
			SetStateLabel('BLOCK');
			
			A_Quake(dmg/4, dmg/3, 0,20000);
			return;
		}
		
		// Combo stuff
		if (inflictor.combo == null) {
			inflictor.combo = ComboSequence.Init(dmg/7.0*0.1+0.9);
		}
		
		inflictor.combo.AddMoveToCombo(moveName, dmg/7.0*0.1+0.9);
		
		freezetics = dmg;
		Vel = (knockback.X * -(1-Angle / 90),0,knockback.Y);
		
		// Juggle bonus
		if (inAir)
			Vel += (0, 0, 1);
		
		SetStateLabel('PAIN');
		
// 		Console.Printf("%f", inflictor.combo.proration);
		
		DamageMobj(inflictor, inflictor, dmg * inflictor.combo.proration, 'Normal');
		
		A_Quake(dmg/3, dmg/2, 0,20000);
	}
	
	bool HitLine(double length, double z_offset, int dmg, Name pufftype, Vector2 knockback, Name moveName, Vector2 selfKnockback = (0,0)) {
		FTranslatedLineTarget t;
		
		// Whiff if we're outta usages
		if (combo && !combo.CanDoMove(moveName))
			return false;
		
		bool blocked = CVar.FindCVar("sv_trainingblock").GetBool();
		if (blocked) pufftype = 'BlockPuff';
		
		LineAttack(Angle, length, 0, 0, 'Normal', pufftype, 0, t, z_offset);

		if (t.linetarget != null) {
			((BaseFighter)(t.linetarget)).IAmHit(self, dmg, knockback, blocked, moveName);
			
			
			freezetics = dmg;
			Vel += (selfKnockback.X * (1-Angle / 90),0,selfKnockback.Y);
			
			cancelTics = dmg+8;
		}
		
		return t.linetarget != null;
	}
	
	void CancelIfDifferent(StateLabel newState) {
		if (!curState.InStateSequence(ResolveState(newState))) {
			SetStateLabel(newState);
		}
	}
	
	virtual void HandleIdle() {
	
		// TRAINING MODE EXCLUSIVE. Regen hp
		GiveBody(3);
		
		// End combo
		if (otherP.combo)
			otherP.combo = null;
	
		if (otherP && Pos.X < otherP.Pos.X) {
			Angle = 0;
			bXFLIP = false;
		} 
		if (otherP && Pos.X > otherP.Pos.X) {
			Angle = 180;
			bXFLIP = true;
		}
	

		if (ButtonPressed(BT_MOVELEFT)) {
			SetStateLabel("WALK");
		}
		if (ButtonPressed(BT_MOVERIGHT)) {
			SetStateLabel("WALK");
		}
		
		if (ButtonDown("2")) SetStateLabel("CROUCH");
		
		GroundMoves();
		
		if ((ButtonPressed(BT_FORWARD)) && (Pos.Z == FloorZ)) {
		
			if (ButtonPressed(BT_MOVELEFT)) Vel.X = -2;
			if (ButtonPressed(BT_MOVERIGHT)) Vel.X = 2;
			Vel.Z = 10;
			SetOrigin((Pos.X,Pos.Y,Pos.Z+1),false);
			SetStateLabel("JUMP");
		}
	}
	
	void HandleWalk() {
		
		
		if (!ButtonPressed(BT_MOVELEFT) && !ButtonPressed(BT_MOVERIGHT))
			SetStateLabel("IDLE");
		
		if (ButtonPressed(BT_MOVELEFT)) {
			SetOrigin((Pos.X - 2, Pos.Y, Pos.Z), true);
		}
		if (ButtonPressed(BT_MOVERIGHT)) {
			SetOrigin((Pos.X + 2, Pos.Y, Pos.Z), true);
		}
		
		if (ButtonPressed(BT_BACK)) SetStateLabel("CROUCH");
		
		GroundMoves();
		
		if ((ButtonPressed(BT_FORWARD)) && Pos.Z == FloorZ) {
			if (ButtonPressed(BT_MOVELEFT)) Vel.X = -2;
			if (ButtonPressed(BT_MOVERIGHT)) Vel.X = 2;
			Vel.Z = 10;
			SetOrigin((Pos.X,Pos.Y,Pos.Z+1),false);
			SetStateLabel("JUMP");
		}
		
		
	}
	
	virtual void HandleCrouch() {
		if (!ButtonPressed(BT_BACK)) {
			SetStateLabel("IDLE");
		}
		
		GroundMoves();
	}
	
	virtual void HandleJump() {
		
	
		if (Pos.Z == FloorZ) {
			Vel.X = 0;
			SetStateLabel("IDLE");
			GroundMoves();
		} else
		
		AirMoves();
	}
	
	virtual void GroundMoves() {
	
		if (CheckSpecialInput("252L")) {
			CancelIfDifferent("S22X");
			return;
		}
		if (CheckSpecialInput("2L")) {CancelIfDifferent("N2P"); return;}
		if (CheckSpecialInput("2M")) {CancelIfDifferent("N2S"); return;}
		if (CheckSpecialInput("2H")) {CancelIfDifferent("N2H"); return;}
		
		if (ButtonDown("2")) {
			if (CheckSpecialInput("L")) {CancelIfDifferent("N2P"); return;}
			if (CheckSpecialInput("M")) {CancelIfDifferent("N2S"); return;}
			if (CheckSpecialInput("H")) {CancelIfDifferent("N2H"); return;}
		} else {
			if (CheckSpecialInput("L")) {CancelIfDifferent("N5P"); return;}
			if (CheckSpecialInput("M")) {CancelIfDifferent("N5S"); return;}
			if (CheckSpecialInput("H")) {CancelIfDifferent("N5H"); return;}
		}
	}
	
	virtual void AirMoves() {
		if (CheckSpecialInput("L")) {CancelIfDifferent("J5P"); return;}
		if (CheckSpecialInput("M")) {CancelIfDifferent("J5S"); return;}
		if (CheckSpecialInput("H")) {CancelIfDifferent("J5H"); return;}
	}
}