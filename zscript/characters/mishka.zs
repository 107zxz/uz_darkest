class Mishka : BaseFighter {
	States {
	SPAWN:
	IDLE:
	MISH A 12 {
		A_SetSize(12);
		if (!rollbackManaged) otherP.combo = null;
	}
// 	EBBY A 0 {
// 		if (pIdx == 1)
// 			SetStateLabel('N5S');
// 	}
	Loop;
	
	CROUCH:
	MICR A 2 A_SetSize(12);
	Loop;
	
	WALK:
	EBWK BA 9;
	Loop;
	
	RUN:
	EBWK CA 7;
	Loop;
	
	RUNSTOP:
	EB5H I 14;
	Goto IDLE;
	
	BACKDASH:
	EB5H I 10;
// 	EB5H HHHH 1 SetOrigin((Pos.X - 6 * (1-Angle / 90), Pos.Y, Pos.Z), true);
// 	EB5H HH 1 SetOrigin((Pos.X - 3 * (1-Angle / 90), Pos.Y, Pos.Z), true);
	Goto IDLE;
	
	JUMP:
	---- A 2;
	EBAR A 2;
	Loop;
	
	LAND:
	EBCH A 3;
	Goto IDLE;
	
	PAIN:
// 	MAHT A 16;
	TNT1 A 0 { if (!rollbackManaged) A_Pain(); }
	TNT1 A 0 A_SetSize(12);
	EBHT ABBB 7;
	Goto IDLE;
	
	FALL:
	EBFL ABC 14;
	EBFL C -1;
	Loop;
	
	WIN:
	EBWN ABCD 10;
	WINLAUGH:
	EBWN EF 17;
	Loop;

	BLOCK:
	EBBK AA 9 A_SetSize(12);
	Goto IDLE;
	
	CROUCHBLOCK:
	EBCB A 17 A_SetSize(12);
	Goto IDLE;
	
	GRAB:
	EBGB A 5 {Vel.X += ((1-Angle / 90)*2) * FRAME_DELTA;}
	TNT1 A 0 {
		if (HitLine(32,(0,0),0,'SmashPuff',(0,0),'GRAB',MOVE_GRAB | MOVE_NOCANCEL | MOVE_NOHITAIR)) {
			SetStateLabel("THROW");
		}
	}
	EBGB B 24;
	Goto IDLE;
	
	THROW:
	EBGB A 9 {
		otherP.SetStateLabel("PAIN");
		
	}
	EBAR A 2 {
		SetOrigin((Pos.X,0,Pos.Z+1),true);
		Vel.Z = (8) * FRAME_DELTA;
		Vel.X = (3 * (1-Angle/90)) * FRAME_DELTA;
	}
	EBAR AAAAAAAAAAAAAAAAAAAA 2 {
		otherP.SetStateLabel("PAIN");
		otherP.SetOrigin((Pos.X-20* (1-Angle/90),0,Pos.Z+30),true);
		inAir = false;
	}
	EB22 A 2 {
		SetOrigin((Pos.X,0,0),true);
		otherP.SetOrigin((Pos.X+20 * (1-Angle/90),0,0),true);
		HitLine(96,(0,0),HITSTUN_HEAVY,'SlashPuff',(0.8,6),'THROW', MOVE_NOCANCEL);
	}
	EB22 B 3 {
// 		SetOrigin((Pos.X,0,0),true);
// 		otherP.SetOrigin((Pos.X+20 * (1-Angle/90),0,0),true);
		HitLine(96,(0,0),HITSTUN_HEAVY,'SlashPuff',(2.5,8),'THROW2', MOVE_NOCANCEL);
	}
	EB22 A 14;
	Goto IDLE;
	
	J5P:
	---- A 2;
	EBJP A 3;
	EBJP A 14 HitLine(32,(0,-16),HITSTUN_MEDIUM,'SmashPuff',(0.5,2),'J5P', MOVE_BLOCKHIGH);
	Goto JUMP;
	
	J5S:
	---- A 2;
	EBJP A 5;
	EBJS A 3 {
		HitLine(32,(0,-8),HITSTUN_MEDIUM,'SlashPuff',(0.75,0),'J5S', MOVE_BLOCKHIGH) ||
		HitLine(32,(0,0),HITSTUN_MEDIUM,'SlashPuff',(0.75,0),'J5S', MOVE_BLOCKHIGH) ||
		HitLine(32,(0,-16),HITSTUN_MEDIUM,'SlashPuff',(0.75,0),'J5S', MOVE_BLOCKHIGH);
	}
	EBJS A 3 {
		HitLine(32,(0,-8),HITSTUN_LIGHT,'SlashPuff',(0.75,0),'J5S2', MOVE_BLOCKHIGH) ||
		HitLine(32,(0,0),HITSTUN_LIGHT,'SlashPuff',(0.75,0),'J5S2', MOVE_BLOCKHIGH) ||
		HitLine(32,(0,-16),HITSTUN_LIGHT,'SlashPuff',(0.75,0),'J5S2', MOVE_BLOCKHIGH);
	}
// 	EBJS A 2 {
// 		HitLine(32,(0,-8),HITSTUN_MEDIUM,'SlashPuff',(0.75,0),'J5S3', MOVE_BLOCKHIGH) ||
// 		HitLine(32,(0,0),HITSTUN_MEDIUM,'SlashPuff',(0.75,0),'J5S3',MOVE_BLOCKHIGH) ||
// 		HitLine(32,(0,-16),HITSTUN_MEDIUM,'SlashPuff',(0.75,0),'J5S3',MOVE_BLOCKHIGH);
// 	}
// 	EBJS A 2 {
// 		HitLine(32,(0,-8),HITSTUN_MEDIUM,'SlashPuff',(0.75,0),'J5S4',MOVE_BLOCKHIGH) ||
// 		HitLine(32,(0,0),HITSTUN_MEDIUM,'SlashPuff',(0.75,0),'J5S4',MOVE_BLOCKHIGH) ||
// 		HitLine(32,(0,-16),HITSTUN_MEDIUM,'SlashPuff',(0.75,0),'J5S4',MOVE_BLOCKHIGH);
// 	}
	Goto JUMP;
	
	J5H:
	---- A 2;
	EBJP A 7;
	EBJH A 14 {
		HitLine(64,(0,0),HITSTUN_MEDIUM,'SlashPuff',(1,0),'J5H', MOVE_BLOCKHIGH, (0,2.5)) ||
		HitLine(64,(0,-16),HITSTUN_MEDIUM,'SlashPuff',(1,0),'J5H', MOVE_BLOCKHIGH, (0,2.5)) ||
		HitLine(64,(0,16),HITSTUN_MEDIUM,'SlashPuff',(1,0),'J5H', MOVE_BLOCKHIGH, (0,2.5));
	}
	Goto JUMP;
	
	N5P:
	---- A 2;
	MISH BC 3;
	MISH C 17;
	MISH D 5 HitLine(86,(0,16),HITSTUN_HEAVY,'SlashPuff',(40,3),'N5P',MOVE_WALLBOUNCE);
	MISH C 10;
	MISH B 3;
	Goto IDLE;
	
	N5S:
	---- A 2;
	MIRL BCDEFGH 5;
	Goto IDLE;
	
	N5H:
	---- A 2;
	EB5H BCDE 3;
	EB5H F 5 {
		HitLine(72,(0,0),HITSTUN_MEDIUM,'SlashPuff',(0.4,6),'N5H') ||
		HitLine(72,(0,-16),HITSTUN_MEDIUM,'SlashPuff',(0.4,6),'N5H');
	}
	EB5H GHD 3;
	Goto IDLE;
	
	N2P:
	---- A 2;
	MICR BC 3;
	MICR C 17;
	MICR D 5 HitLine(86,(0,-16),HITSTUN_HEAVY,'SlashPuff',(40,3),'N5P',MOVE_WALLBOUNCE);
	MICR C 10;
	MICR B 3;
	Goto IDLE;
	
	N2S:
	---- A 2;
	EBCM A 5;
	EBCM B 5 HitLine(64,(0,-16),HITSTUN_MEDIUM,'SlashPuff',(0.4,6),'N2S',MOVE_BLOCKLOW);
	EBCM C 5;
	EBCH A 5;
	Goto IDLE;

	N2H:
	---- A 2;
	EB2H BCD 5;
	EB2H E 5 {
		HitLine(64,(0,32),HITSTUN_MEDIUM,'SlashPuff',(0.4,6),'N2H') ||
		HitLine(64,(0,0),HITSTUN_MEDIUM,'SlashPuff',(0.4,6),'N2H');
	}
	EB2H FG 5;
	Goto IDLE;
	
	236L:
	---- A 2;
	EB26 AAB 5;
	EB26 C 5 {
		// SpawnGarlicProjectile(8 * (1 - Angle / 90), 5);
	}
	EB26 DD 5;
	Goto IDLE;
	
	236M:
	---- A 2;
	EB26 AAB 5;
	EB26 C 5 {
		// SpawnGarlicProjectile(6 * (1 - Angle / 90), 7);
	}
	EB26 DD 5;
	Goto IDLE;
	
	236H:
	---- A 2;
	EB26 AAB 5;
	EB26 C 5 {
		// SpawnGarlicProjectile(1.5 * (1 - Angle / 90), 10);
	}
	EB26 DD 5;
	Goto IDLE;
	
	623H:
	---- A 2 {
		cancelTics = 0;
		bSHOOTABLE = false;
	}
	EB63 AA 5;
	EB63 B 5 {
		HitLine(64,(0,0),HITSTUN_LIGHT,'SlashPuff',(0,3),'623H',MOVE_NOCANCEL) ||
		HitLine(64,(0,-16),HITSTUN_LIGHT,'SlashPuff',(0,3),'623H',MOVE_NOCANCEL);
	}
	EB63 CD 3 {
		bSHOOTABLE = true;
	}
	EB63 E 5 {
		HitLine(64,(0,0),HITSTUN_LIGHT,'SlashPuff',(0,3),'623H2',MOVE_NOCANCEL) ||
		HitLine(64,(0,-16),HITSTUN_LIGHT,'SlashPuff',(0,3),'623H2',MOVE_NOCANCEL);
	}
	EB63 B 5 {
		HitLine(64,(0,0),HITSTUN_LIGHT,'SlashPuff',(2,3),'623H3',MOVE_NOCANCEL) ||
		HitLine(64,(0,-16),HITSTUN_LIGHT,'SlashPuff',(2,3),'623H3',MOVE_NOCANCEL);
	}
	EB63 CAA 5;
	TNT1 A 0 {
		bSHOOTABLE = true;
	}
	Goto IDLE;
	
	214L:
	---- A 2;
	EBQB DEGG 2;
	EBQB HHII 2 {Vel.X = (6 * (1-Angle/90)) * FRAME_DELTA;}
	EBCH A 3 {
		SetOrigin((Pos.X + 40*(1-Angle/90),0,Pos.Z),false);
	}
	Goto IDLE;
	
	214H:
	---- A 2;
	EBQB BCDE 3;
	EBQB F 5 {
		HitLine(96,(0,8),HITSTUN_HEAVY,'SlashPuff',(0.4,4),'214H') ||
		HitLine(96,(0,-16),HITSTUN_HEAVY,'SlashPuff',(0.4,4),'214H');
	}
	EBQB F 7 {
		HitLine(96,(0,8),HITSTUN_HEAVY,'SlashPuff',(0.4,7),'214H2') ||
		HitLine(96,(0,-16),HITSTUN_HEAVY,'SlashPuff',(0.4,7),'214H2');
	}
	EBQB GGG 3;
	EB5H HH 3;
	Goto IDLE;
	
	214M:
	---- A 2;
	EBQB BCDE 3;
	EBQB J 14 {
		HitLine(96,(0,-16),HITSTUN_HEAVY,'SlashPuff',(0.4,6),'214M', MOVE_BLOCKLOW);
	}
	EBQB GG 3;
	EB5H H 3;
	Goto IDLE;
	}
}