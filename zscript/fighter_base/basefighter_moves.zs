const HITSTUN_LIGHT = 3;
const HITSTUN_MEDIUM = 5;
const HITSTUN_HEAVY = 7;


enum MoveFlags {
	MOVE_BLOCKLOW = 1,
	MOVE_BLOCKHIGH = 2,
	MOVE_UNBLOCKABLE = 4,
	MOVE_NOHITAIR = 8,
	MOVE_NOHITGROUND = 16,
	MOVE_NOCANCEL = 32,
	MOVE_GRAB = 64,
	MOVE_NOSCREENFREEZE = 128,
	MOVE_WALLBOUNCE = 256
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
	
		// DEBUG: Heal outside of combos
		if (!otherP.combo && Cvar.FindCVar("sv_trainingregen").GetBool())
			GiveBody(3);
		// Death
		else if (Health < 18) {
			CancelIfDifferent('FALL');
			return;
		} else if (otherP.Health < 18) {
			if (InStateSequence(curstate, ResolveState("IDLE")) || InStateSequence(curstate, ResolveState("JUMP")))
				CancelIfDifferent('WIN');
			return;
		}
	
		// This one's important, if we land in an air move early cancel it.
		// Also if you're getting hit and land end the combo
		if (Pos.Z == FloorZ && inAir) {
// 			Console.Printf("Hiii");
			SetStateLabel("LAND");
			inAir = Pos.Z != FloorZ;
			Vel.Z = 0;
			return;
		}
		inAir = Pos.Z != FloorZ;
	
		if (InStateSequence(curstate, ResolveState("IDLE"))) HandleIdle();
		if (InStateSequence(curstate, ResolveState("CROUCH"))) HandleCrouch();
		if (InStateSequence(curstate, ResolveState("JUMP"))) HandleJump();
		if (InStateSequence(curstate, ResolveState("WALK"))) HandleWalk();
		if (InStateSequence(curstate, ResolveState("RUN"))) HandleRun();
// 		if (InStateSequence(curstate, ResolveState("RUNSTOP"))) HandleRunStop();
		if (InStateSequence(curstate, ResolveState("BACKDASH"))) HandleBackdash();
			
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
	
	void IAmHit(BaseFighter inflictor, int dmg, Vector2 knockback, bool blocked, Name moveName, int flags) {
		if (blocked) {
// 			Console.Printf("Flags: %d", flags);
		
			if (!(flags & MOVE_NOSCREENFREEZE))
				freezetics = dmg/2;
			Vel = (knockback.X * -(1-Angle / 90),0,0);
			inflictor.Vel += (knockback.X * (1-Angle / 90),0,0);
			
			if ((ButtonDown("2") && !inAir) || (CVar.FindCVar("sv_trainingblock").GetBool() && flags & MOVE_BLOCKLOW))
				SetStateLabel('CROUCHBLOCK');
			else
				SetStateLabel('BLOCK');
			
			A_Quake(dmg/4, dmg/3, 0,20000);
			return;
		}
		
		// Combo stuff
		if (inflictor.combo == null) {
			inflictor.combo = ComboSequence.Init(dmg/7.0*0.1+0.9);
		}
		
		inflictor.combo.AddMoveToCombo(moveName, dmg/7.0*0.1+0.9);
		
		if (!(flags & MOVE_NOSCREENFREEZE))
			freezetics = dmg;
		Vel = (knockback.X * -(1-Angle / 90),0,knockback.Y);
		
		// Juggle bonus
		if (inAir)
			Vel += (0, 0, 1);
		
		DamageMobj(inflictor, inflictor, dmg * inflictor.combo.proration, 'Normal');
		if (flags & MOVE_WALLBOUNCE) {
			SetStateLabel('WALLBOUNCE');
		} else
			SetStateLabel('PAIN');
		
// 		Console.Printf("%f", inflictor.combo.proration);
		
		
		A_Quake(dmg/3, dmg/2, 0,20000);
	}
	
	bool HitLine(double length, Vector2 offset, int dmg, Name pufftype, Vector2 knockback, Name moveName, int flags = 0, Vector2 selfKnockback = (0,0)) {
		FTranslatedLineTarget t;
		
// 		Console.Printf("HitLine Flags: %d", flags);
		
		// Whiff if we're outta usages
		if (combo && !combo.CanDoMove(moveName))
			return false;
		
		bool blocked;
		blocked = otherP.ButtonPressed(otherP.bt_left);
		
		// High/Low
		if (flags & MOVE_BLOCKLOW && !otherP.ButtonPressed(BT_BACK))
			blocked = false;
		if (flags & MOVE_BLOCKHIGH && otherP.ButtonPressed(BT_BACK))
			blocked = false;
			
		blocked |= CVar.FindCVar("sv_trainingblock").GetBool();
		
		if (!otherP.curState.InStateSequence(otherP.ResolveState('IDLE')) &&
			!otherP.curState.InStateSequence(otherP.ResolveState('BLOCK')) &&
			!otherP.curState.InStateSequence(otherP.ResolveState('CROUCHBLOCK')) &&
			!otherP.curState.InStateSequence(otherP.ResolveState('WALK')) &&
			!otherP.curState.InStateSequence(otherP.ResolveState('CROUCH')) &&
			!otherP.curState.InStateSequence(otherP.ResolveState('JUMP'))
		) {
			blocked = false; 
		}
		
		if (flags & MOVE_UNBLOCKABLE) blocked = false;
		
		if (flags & MOVE_GRAB) {
			if (otherP.curState.InStateSequence(otherP.ResolveState('BLOCK')) ||
			otherP.curState.InStateSequence(otherP.ResolveState('CROUCHBLOCK'))) {
				return false;
			}
			
			blocked = false;
		}
		
		if (blocked) pufftype = 'BlockPuff';
		
		LineAttack(Angle, length, 0, 0, 'Normal', pufftype, 0, t, offset.y, offset.x);

		if (t.linetarget != null) {
			if (flags & MOVE_NOHITAIR && (BaseFighter)(t.linetarget).inAir) {
				return false;
			}
		
			((BaseFighter)(t.linetarget)).IAmHit(self, dmg, knockback, blocked, moveName, flags);
			
			
			freezetics = dmg;
			Vel += (selfKnockback.X * (1-Angle / 90),0,selfKnockback.Y);
			
			if (!(flags & MOVE_NOCANCEL))
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
	
	void HandleRun() {
		cancelTics = 0;
		if (ButtonPressed(bt_right)) {
			SetOrigin((Pos.X + 5 * (1-Angle / 90), Pos.Y, Pos.Z), true);
			
			if (ButtonDown("9")) {
				Vel.Z = 10;
				Vel.X = 5 * (1-Angle / 90);
				SetOrigin((Pos.X,Pos.Y,Pos.Z+1),false);
				SetStateLabel("JUMP");
				return;
			}
			
			GroundMoves();
		} else {
			SetStateLabel("IDLE");
		}
	}

	
	void HandleBackdash() {
		cancelTics = 0;
		SetOrigin((Pos.X - 7 * (1-Angle / 90), Pos.Y, Pos.Z), true);
		
		if (ButtonDown("7")) {
			Vel.Z = 10;
			Vel.X = -5 * (1-Angle / 90);
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
	
		if (CheckSpecialInput("623H")) {
			CancelIfDifferent("623H");
			return;
 		}
// 		if (CheckSpecialInput("626H")) {
// 			CancelIfDifferent("623H");
// 			return;
//  		}
		if (CheckSpecialInput("214L")) {
			CancelIfDifferent("214L");
			return;
 		}
		if (CheckSpecialInput("214M")) {
			CancelIfDifferent("214M");
			return;
 		}
		if (CheckSpecialInput("214H")) {
			CancelIfDifferent("214H");
			return;
 		}
		if (CheckSpecialInput("236L")) {
			CancelIfDifferent("236L");
			return;
 		}
		if (CheckSpecialInput("236M")) {
			CancelIfDifferent("236M");
			return;
 		}
		if (CheckSpecialInput("236H")) {
			CancelIfDifferent("236H");
			return;
 		}
		
		// Regular throw
		if ((ButtonDown("S") && ButtonDown("L"))) {
			CheckSpecialInput("L");
			CheckSpecialInput("S");
// 			Console.Printf("Throw attempt");
			CancelIfDifferent("GRAB");
			return;
		}

		if (CheckSpecialInput("2L")) {CancelIfDifferent("N2P"); cancelTics=4; return;}
		if (CheckSpecialInput("2M")) {CancelIfDifferent("N2S"); cancelTics=4; return;}
		if (CheckSpecialInput("2H")) {CancelIfDifferent("N2H"); cancelTics=4; return;}
		
		if (ButtonDown("2")) {
			if (CheckSpecialInput("L")) {CancelIfDifferent("N2P"); cancelTics=4; return;}
			if (CheckSpecialInput("M")) {CancelIfDifferent("N2S"); cancelTics=4; return;}
			if (CheckSpecialInput("H")) {CancelIfDifferent("N2H"); cancelTics=4; return;}
		} else {
			if (CheckSpecialInput("L")) {CancelIfDifferent("N5P"); cancelTics=4; return;}
			if (CheckSpecialInput("M")) {CancelIfDifferent("N5S"); cancelTics=4; return;}
			if (CheckSpecialInput("H")) {CancelIfDifferent("N5H"); cancelTics=4; return;}
		}
		
		// Dash
		if (CheckSpecialInput("656")) {CancelIfDifferent("RUN"); cancelTics=4; return;}
		if (CheckSpecialInput("454") && ButtonPressed(bt_left)) {CancelIfDifferent("BACKDASH"); cancelTics=8; return;}
		
		
	}
	
	virtual void AirMoves() {
		if (CheckSpecialInput("L")) {CancelIfDifferent("J5P"); return;}
		if (CheckSpecialInput("M")) {CancelIfDifferent("J5S"); return;}
		if (CheckSpecialInput("H")) {CancelIfDifferent("J5H"); return;}
	}
}