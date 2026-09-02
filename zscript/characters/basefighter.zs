class BaseFighter : Actor {
	Default {
	Radius 12;
	Height 53;
	Scale 0.2;
	PainChance 255;
	
// 	Health 200;
	
// 	+SOLID;d
	+SHOOTABLE;
	+CASTSPRITESHADOW;
	+NOBLOOD;
	+BRIGHT;
// 	+NOBLOCKMAP;
	}
	
	BaseFighter otherP;
	int pIdx;
	
	override void PostBeginPlay() {
		pIdx = 0;
		if (Angle == 180) {
// 			bXFLIP = true;
			pIdx = 1;
		}
		
		// TODO: DEBUG CODE: REMOVE THIS
		ThinkerIterator pFinder = ThinkerIterator.Create("BaseFighter");
		BaseFighter mo;
		while (mo = BaseFighter(pFinder.Next())) {
			if (180 - mo.Angle == Angle) {
				otherP = mo;
				break;
			}
		}
	}
	
	override void Tick() {
		Super.Tick();
	
		if (InStateSequence(curstate, ResolveState("IDLE"))) HandleIdle();
		if (InStateSequence(curstate, ResolveState("CROUCH"))) HandleCrouch();
		if (InStateSequence(curstate, ResolveState("JUMP"))) HandleJump();
		if (InStateSequence(curstate, ResolveState("WALK"))) HandleWalk();
		
		// Unstuck me!
		if (otherP)
			UnstuckMe();
	}
	
	bool ButtonPressed(int button) {
		return players[pIdx].buttons & button;
	}
	
	virtual void GroundMoves() {
	
	}
	
	virtual void HandleIdle() {
		if (otherP && Pos.X < otherP.Pos.X) {
			Angle = 0;
			bXFLIP = false;
		} else {
			Angle = 180;
			bXFLIP = true;
		}
	

		if (ButtonPressed(BT_MOVELEFT)) {
// 			SetOrigin((Pos.X - 2, Pos.Y, Pos.Z), true);
			SetStateLabel("WALK");
		}
		if (ButtonPressed(BT_MOVERIGHT)) {
// 			SetOrigin((Pos.X + 2, Pos.Y, Pos.Z), true);
			SetStateLabel("WALK");
		}
		
		
		if (ButtonPressed(BT_BACK)) SetStateLabel("CROUCH");
		
		GroundMoves();
		
		if (ButtonPressed(BT_FORWARD) && Pos.Z == FloorZ) {
			if (ButtonPressed(BT_MOVELEFT)) Vel.X = -2;
			if (ButtonPressed(BT_MOVERIGHT)) Vel.X = 2;
			Vel.Z = 10;
			SetOrigin((Pos.X,Pos.Y,Pos.Z+1),false);
			SetStateLabel("JUMP");
		}
		
		
	}
	
	virtual void HandleCrouch() {
		GroundMoves();
	
		if (!ButtonPressed(BT_BACK)) {
			SetStateLabel("IDLE");
		}
	}
	
	virtual void HandleJump() {
		if (Pos.Z == FloorZ) {
			Vel.X = 0;
			SetStateLabel("IDLE");
		}
	}
	
	void HandleWalk() {
		GroundMoves();
		
		if (!ButtonPressed(BT_MOVELEFT) && !ButtonPressed(BT_MOVERIGHT))
			SetStateLabel("IDLE");
		
		if (ButtonPressed(BT_MOVELEFT)) {
			SetOrigin((Pos.X - 2, Pos.Y, Pos.Z), true);
		}
		if (ButtonPressed(BT_MOVERIGHT)) {
			SetOrigin((Pos.X + 2, Pos.Y, Pos.Z), true);
		}
		
		if (ButtonPressed(BT_BACK)) SetStateLabel("CROUCH");
		
		if (ButtonPressed(BT_FORWARD) && Pos.Z == FloorZ) {
			if (ButtonPressed(BT_MOVELEFT)) Vel.X = -2;
			if (ButtonPressed(BT_MOVERIGHT)) Vel.X = 2;
			Vel.Z = 10;
			SetOrigin((Pos.X,Pos.Y,Pos.Z+1),false);
			SetStateLabel("JUMP");
		}
	}
	
	// Will be called every frame on BOTH players, so we should expect
	// the other player to do this too befor this gets called again
	// if we're inside each other
	void UnstuckMe() {
// 		Console.Printf("%f", Pos.X);
	
		float delta = Math.abs(otherP.Pos.X - Pos.X);
		
		float newX = Pos.X;
		if (newX-Radius/2 <-88)
			newX = -88+Radius/2;
		if (newX+Radius/2 > 88)
			newX = 88-Radius/2;
		
		
		if (Pos.Z <= floorz && otherP.Pos.Z <= otherP.floorz && delta<Radius/2+otherP.Radius/2) {
			if (Pos.X < otherP.Pos.X) {
				float seperation_force=Radius/2+otherP.Radius/2-delta;
// 				SetOrigin((Pos.X-seperation_force/3,Pos.Y,Pos.Z),true);
				otherP.SetOrigin((otherP.Pos.X+seperation_force/3,otherP.Pos.Y,otherP.Pos.Z),true);

				newX-=seperation_force/3;
			}
		}
		
		SetOrigin((newX,Pos.Y,Pos.Z),true);
	}
	
	bool HitLine(double length, double z_offset, int dmg, StateLabel hurtanim, Vector2 knockback) {
		FTranslatedLineTarget t;
		LineAttack(Angle, length, 0, dmg, 'Normal', 'SmashPuff', 0, t, z_offset);
		
		if (t.linetarget != null) {
			t.linetarget.SetStateLabel(hurtanim);
			t.linetarget.Vel = (knockback.X * (1-Angle / 90),0,knockback.Y);
		}
		
		return t.linetarget != null;
	}
	
	/* LEGACYBULLSHIT. MOVE THIS SOMEWHERE
	
	
	// Get the button that's currently 'left'. Used for special inputs
	int bt_left() {
		return bXFLIP ? BT_MOVERIGHT : BT_MOVELEFT;
	}
	int bt_right() {
		return bXFLIP ? BT_MOVELEFT : BT_MOVERIGHT;
	}
	
	// Check if a button is currently pressed. Kind of a convenience
	// method
	bool ButtonDown(string repr) {
        return ButtonInInput(repr, inputQueue[0]);
    }
	
	// 
	bool ButtonInInput(String button, int input) {
        button = button.MakeUpper();

        if (button == "1" && input & BT_DOWN && input & bt_left()) return true;
        if (button == "3" && input & BT_DOWN && input & bt_right()) return true;
        if (button == "4" && input & bt_left() && !(input & BT_UP) && !(input & BT_DOWN)) return true;
        if (button == "6" && input & bt_right() && !(input & BT_UP) && !(input & BT_DOWN)) return true;
        if (button == "7" && input & BT_UP && input & bt_left()) return true;
        if (button == "9" && input & BT_UP && input & bt_right()) return true;
        
        if (button == "2" && input & BT_DOWN) return true;
        if (button == "8" && input & BT_UP) return true;

        // If nothing above hit we're at 5
        if (button == "5" && !(input & BT_DOWN) && !(input & BT_UP) && !(input & bt_left()) && !(input & bt_right())) return true;
        
        if (button == "L" && input & BT_LIGHT) return true;
        if (button == "M" && input & BT_MEDIUM) return true;
        if (button == "H" && input & BT_HEAVY) return true;
        if (button == "S" && input & BT_SPECIAL) return true;
        
        return false;
    }
	
	//
	
	// Given numpad notation of a move check if it happened.
	// There is a bug here where if a move is too short this will
	// detect an input from it twice.
	bool CheckSpecialInput(String repr) {
        int matching = 0;
        for (int b = BUF_LEN_ACTIONABLE-2; b >= 0; b--) {
            while (
                (
                    ButtonInInput(repr.Mid(matching,1), inputQueue[b]) &&
                    !ButtonInInput(repr.Mid(matching,1), inputQueue[b+1])
                ) || (
                    repr.Length() > 3 &&
                    !ButtonInInput(repr.Mid(matching,1), inputQueue[b]) &&
                    ButtonInInput(repr.Mid(matching,1), inputQueue[b+1])
                )
            ) matching += 1;
            if (matching >= repr.Length()) {
                // If we get one of these, we should probably clear the buffer
                // So we don't freak out, but this would totally fuck up the whole
                // Kara kancel dynamic. What the fuck do I do?
                
                // Lets not clear for normals, but we should for dashes
                // (e.g. 656)

                // Don't clear for the first two framesMapleKickEffect
                if (repr.Length() > 2) {
                    for (int i = 0; i < BUF_LEN_ACTIONABLE; i++) {
                        inputQueue[i] = 0;
                    }
                }
                return true;
            }
        }
        // Special condition, the last DIRECTION should be held instead of pressed
        return false;
    }
	
	// Shuffle forward the input buffer
	void HandleInput() {
        // Add to input queue
        for (int i = BUF_LEN_ACTIONABLE-1; i > 0; i--) {
            inputQueue[i] = inputQueue[i-1];
        }
        inputQueue[0] = players[player].buttons;
    }

	*/
}