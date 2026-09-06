class Fetch : BaseFighter {
	States {
	SPAWN:
	IDLE:
		FETC A 1;
		Loop;
	N5H:
		
		FETC BC 3;
		FETC D 3 {
			FTranslatedLineTarget victim;
			LineAttack(Angle,96,0,32,'Hitscan',"SmashPuff",0,victim);
			if (victim.linetarget) {
				otherP.Vel.Z = 10;
				otherP.Vel.X = 3;
				if (bXFLIP) otherP.Vel.X = -3;
// 				otherP.SetOrigin((Pos.X+96,otherP.Pos.Y,otherP.Pos.Z),true);
				
// 				otherP.freezetics = 5;
// 				freezetics = 5;
				A_Quake(1.0,5,0,256);
			}
		}
		FETC E 3;
		FETC F 3;
		TNT1 A 0 {
			SetOrigin((Pos.X + 645 * 0.1 * (1-(Angle/90)), Pos.Y, Pos.Z), false);
		}
		Goto IDLE;
	N5M:
		FETC BC 3;
		FETC D 3 {
			FTranslatedLineTarget victim;
			LineAttack(Angle,96,0,32,'Hitscan',"SmashPuff",0,victim);
			if (victim.linetarget) {
				otherP.Vel.Z = 10;
				otherP.Vel.X = 3;
				if (bXFLIP) otherP.Vel.X = -3;
// 				otherP.SetOrigin((Pos.X+96,otherP.Pos.Y,otherP.Pos.Z),true);
				
// 				otherP.freezetics = 5;
// 				freezetics = 5;
				A_Quake(1.0,5,0,256);
			}
		}
		FETC E 3;
		FETC F 3;
		TNT1 A 0 {
			SetOrigin((Pos.X + 645 * 0.1 * (1-(Angle/90)), Pos.Y, Pos.Z), false);
		}
		Goto IDLE;
	}
	
// 	override void HandleIdle() {
// 		Super.HandleIdle();
// 		if (ButtonPressed(BT_ATTACK)) SetStateLabel("N5H");
// 		if (ButtonPressed(BT_ALTATTACK)) SetStateLabel("N5M");
// 	}
}