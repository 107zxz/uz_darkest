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

	void MovesPostBeginPlay() {
	
	}
	
	
	
	void MovesTick() {
		if (InStateSequence(curstate, ResolveState("IDLE"))) HandleIdle();
		if (InStateSequence(curstate, ResolveState("CROUCH"))) HandleCrouch();
		if (InStateSequence(curstate, ResolveState("JUMP"))) HandleJump();
		if (InStateSequence(curstate, ResolveState("WALK"))) HandleWalk();
			
		// Cancels
		if (cancelTics > 0) {
// 			Console.Printf("Cancel Window");
			cancelTics -= 1;
			
			if (Pos.Z == FloorZ) {
				if (ButtonDown("8")) {
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
	
	bool HitLine(double length, double z_offset, int dmg, StateLabel hurtanim, Vector2 knockback, Vector2 selfKnockback = (0,0)) {
		FTranslatedLineTarget t;
		LineAttack(Angle, length, 0, dmg, 'Normal', 'SmashPuff', 0, t, z_offset);

		if (t.linetarget != null) {
			t.linetarget.SetStateLabel(hurtanim);
			
			A_Quake(dmg/3, dmg/2, 0,20000);
			
			freezetics = dmg;
			t.linetarget.freezetics = dmg;
			
			t.linetarget.Vel = (knockback.X * (1-Angle / 90),0,knockback.Y);
			Vel += (selfKnockback.X * (1-Angle / 90),0,selfKnockback.Y);
			
// 			Console.Printf("Hit! %d", dmg);
			// Allow a little extra time for delay cancelling
			cancelTics = dmg+8;
		}
			
// 			if (Pos.Z == FloorZ) {
				
// 				if (ButtonDown("8")) {
// 					if (ButtonPressed(BT_MOVELEFT)) Vel.X = -2;
// 					if (ButtonPressed(BT_MOVERIGHT)) Vel.X = 2;
// 					Vel.Z = 10;
// 					SetOrigin((Pos.X,Pos.Y,Pos.Z+1),false);
// 					SetStateLabel("JUMP");
// 					AirMoves();
// 				} else GroundMoves();
				
// 			} else {
// 				AirMoves();
// 			}
			
// 		}
		
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
	
		if (CheckSpecialInput("236L")) {
			CancelIfDifferent("N2H");
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
		if (CheckSpecialInput("L")) CancelIfDifferent("J5P");
		if (CheckSpecialInput("M")) CancelIfDifferent("J5S");
		if (CheckSpecialInput("H")) CancelIfDifferent("J5H");
	}
}