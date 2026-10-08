class Abbey : BaseFighter {
	States {
	SPAWN:
	IDLE:
	EBBY ABCD 7 {
		A_SetSize(12);
		otherP.combo = null;
	}
// 	EBBY A 0 {
// 		if (pIdx == 1)
// 			SetStateLabel('N5S');
// 	}
	Loop;
	
	CROUCH:
	EBCH A 1 A_SetSize(12);
	Loop;
	
	WALK:
	EBWK BA 5;
	Loop;
	
	RUN:
	EBWK CA 4;
	Loop;
	
	RUNSTOP:
	EB5H I 8;
	Goto IDLE;
	
	BACKDASH:
	EB5H I 6;
// 	EB5H HHHH 1 SetOrigin((Pos.X - 6 * (1-Angle / 90), Pos.Y, Pos.Z), true);
// 	EB5H HH 1 SetOrigin((Pos.X - 3 * (1-Angle / 90), Pos.Y, Pos.Z), true);
	Goto IDLE;
	
	JUMP:
	---- A 1;
	EBAR A 1;
	Loop;
	
	LAND:
	EBCH A 2;
	Goto IDLE;
	
	PAIN:
// 	MAHT A 16;
	TNT1 A 0 A_Pain;
	TNT1 A 0 A_SetSize(12);
	EBHT ABBB 4;
	Goto IDLE;
	
	WALLBOUNCE:
	TNT1 A 0 A_Pain;
	TNT1 A 0 A_SetSize(12);
	EBWB AAAAAAAAAAAAAAAABBBBBBBBBBBBBBBBB 1 {
// 		Console.Printf("%.2f", otherP.Pos.X);
		if (Pos.X - otherP.Pos.X > 150 && Vel.X > 0) {
			Vel.Z = 3;
			Vel.X = -Abs(Vel.X) / 3;
		}
		if (Pos.X - otherP.Pos.X < -150 && Vel.X < 0) {
			Vel.Z = 3;
			Vel.X = Abs(Vel.X) / 3;
		}
	}
	Goto PAIN;
	
	FALL:
	EBFL ABC 8;
	EBFL C -1;
	Loop;
	
	WIN:
	EBWN ABCD 6;
	WINLAUGH:
	EBWN EF 10;
	Loop;

	BLOCK:
	EBBK AA 5 A_SetSize(12);
	Goto IDLE;
	
	CROUCHBLOCK:
	EBCB A 10 A_SetSize(12);
	Goto IDLE;
	
	GRAB:
	EBGB A 3 {Vel.X += (1-Angle / 90)*2;}
	TNT1 A 0 {
		if (HitLine(32,(0,0),0,'SmashPuff',(0,0),'GRAB',MOVE_GRAB | MOVE_NOCANCEL | MOVE_NOHITAIR)) {
			SetStateLabel("THROW");
		}
	}
	EBGB B 14;
	Goto IDLE;
	
	THROW:
	EBGB A 5 {
		otherP.SetStateLabel("PAIN");
		
	}
	EBAR A 1 {
		SetOrigin((Pos.X,0,Pos.Z+1),true);
		Vel.Z = 8;
		Vel.X = 3 * (1-Angle/90);
	}
	EBAR AAAAAAAAAAAAAAAAAAAA 1 {
		otherP.SetStateLabel("PAIN");
		otherP.SetOrigin((Pos.X-20* (1-Angle/90),0,Pos.Z+30),true);
		inAir = false;
	}
	EB22 A 1 {
		SetOrigin((Pos.X,0,0),true);
		otherP.SetOrigin((Pos.X+20 * (1-Angle/90),0,0),true);
		HitLine(96,(0,0),HITSTUN_HEAVY,'SlashPuff',(0.8,6),'THROW', MOVE_NOCANCEL);
	}
	EB22 B 2 {
// 		SetOrigin((Pos.X,0,0),true);
// 		otherP.SetOrigin((Pos.X+20 * (1-Angle/90),0,0),true);
		HitLine(96,(0,0),HITSTUN_HEAVY,'SlashPuff',(2.5,8),'THROW2', MOVE_NOCANCEL);
	}
	EB22 A 8;
	Goto IDLE;
	
	J5P:
	---- A 1;
	EBJP A 2;
	EBJP A 8 HitLine(32,(0,-16),HITSTUN_MEDIUM,'SmashPuff',(0.5,2),'J5P', MOVE_BLOCKHIGH);
	Goto JUMP;
	
	J5S:
	---- A 1;
	EBJP A 3;
	EBJS A 2 {
		HitLine(32,(0,-8),HITSTUN_MEDIUM,'SlashPuff',(0.75,0),'J5S', MOVE_BLOCKHIGH) ||
		HitLine(32,(0,0),HITSTUN_MEDIUM,'SlashPuff',(0.75,0),'J5S', MOVE_BLOCKHIGH) ||
		HitLine(32,(0,-16),HITSTUN_MEDIUM,'SlashPuff',(0.75,0),'J5S', MOVE_BLOCKHIGH);
	}
	EBJS A 2 {
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
	---- A 1;
	EBJP A 4;
	EBJH A 8 {
		HitLine(64,(0,0),HITSTUN_MEDIUM,'SlashPuff',(1,0),'J5H', MOVE_BLOCKHIGH, (0,2.5)) ||
		HitLine(64,(0,-16),HITSTUN_MEDIUM,'SlashPuff',(1,0),'J5H', MOVE_BLOCKHIGH, (0,2.5)) ||
		HitLine(64,(0,16),HITSTUN_MEDIUM,'SlashPuff',(1,0),'J5H', MOVE_BLOCKHIGH, (0,2.5));
	}
	Goto JUMP;
	
	N5P:
	---- A 1;
	EB5K BC 1;
	EB5K D 2 HitLine(32,(0,0),HITSTUN_LIGHT,'SmashPuff',(0,0),'N5P');
	EB5K E 2;
	EB5K FG 1;
	Goto IDLE;
	
	N5S:
	---- A 1;
	EB5S B 3;
	EB5S C 2;
	EB5S D 3 {
		A_SetSize(64);
		HitLine(96,(0,0),HITSTUN_MEDIUM,'SlashPuff',(2,0),'N5S');
	}
	EB5S E 4;
	TNT1 A 0 A_SetSize(12);
	Goto IDLE;
	
	N5H:
	---- A 1;
	EB5H BCDE 2;
	EB5H F 3 {
		HitLine(72,(0,0),HITSTUN_MEDIUM,'SlashPuff',(0.4,6),'N5H') ||
		HitLine(72,(0,-16),HITSTUN_MEDIUM,'SlashPuff',(0.4,6),'N5H');
	}
	EB5H GHD 2;
	Goto IDLE;
	
	N2P:
	---- A 1;
	EBCP A 1;
	EBCP A 2 HitLine(32,(0,-16),HITSTUN_LIGHT,'SmashPuff',(0.4,0),'N2P');
	EBCP B 3;
	EBCH A 3;
	Goto IDLE;
	
	N2S:
	---- A 1;
	EBCM A 3;
	EBCM B 3 HitLine(64,(0,-16),HITSTUN_MEDIUM,'SlashPuff',(0.4,6),'N2S',MOVE_BLOCKLOW);
	EBCM C 3;
	EBCH A 3;
	Goto IDLE;

	N2H:
	---- A 1;
	EB2H BCD 3;
	EB2H E 3 {
		HitLine(64,(0,32),HITSTUN_MEDIUM,'SlashPuff',(0.4,6),'N2H') ||
		HitLine(64,(0,0),HITSTUN_MEDIUM,'SlashPuff',(0.4,6),'N2H');
	}
	EB2H FG 3;
	Goto IDLE;
	
	236L:
	---- A 1;
	EB26 AAB 3;
	EB26 C 3 {
		Actor gar = Spawn('SuperGarlic', Pos + (-10,0,38));
		gar.target = self;
		gar.Vel.X = 8 * (1 - Angle / 90);
		gar.Vel.Z = 5;
	}
	EB26 DD 3;
	Goto IDLE;
	
	236M:
	---- A 1;
	EB26 AAB 3;
	EB26 C 3 {
		Actor gar = Spawn('SuperGarlic', Pos + (-10,0,38));
		gar.target = self;
		gar.Vel.X = 6 * (1 - Angle / 90);
		gar.Vel.Z = 7;
	}
	EB26 DD 3;
	Goto IDLE;
	
	236H:
	---- A 1;
	EB26 AAB 3;
	EB26 C 3 {
		Actor gar = Spawn('SuperGarlic', Pos + (-10,0,38));
		gar.target = self;
		gar.Vel.X = 1.5 * (1 - Angle / 90);
		gar.Vel.Z = 10;
	}
	EB26 DD 3;
	Goto IDLE;
	
	623H:
	---- A 1 {
		cancelTics = 0;
		bSHOOTABLE = false;
	}
	EB63 AA 3;
	EB63 B 3 {
		HitLine(64,(0,0),HITSTUN_LIGHT,'SlashPuff',(0,3),'623H',MOVE_NOCANCEL) ||
		HitLine(64,(0,-16),HITSTUN_LIGHT,'SlashPuff',(0,3),'623H',MOVE_NOCANCEL);
	}
	EB63 CD 2 {
		bSHOOTABLE = true;
	}
	EB63 E 3 {
		HitLine(64,(0,0),HITSTUN_LIGHT,'SlashPuff',(0,3),'623H2',MOVE_NOCANCEL) ||
		HitLine(64,(0,-16),HITSTUN_LIGHT,'SlashPuff',(0,3),'623H2',MOVE_NOCANCEL);
	}
	EB63 B 3 {
		HitLine(64,(0,0),HITSTUN_LIGHT,'SlashPuff',(2,3),'623H3',MOVE_NOCANCEL) ||
		HitLine(64,(0,-16),HITSTUN_LIGHT,'SlashPuff',(2,3),'623H3',MOVE_NOCANCEL);
	}
	EB63 CAA 3;
	TNT1 A 0 {
		bSHOOTABLE = true;
	}
	Goto IDLE;
	
	214L:
	---- A 1;
	EBQB DEGG 1;
	EBQB HHII 1 {Vel.X = 6 * (1-Angle/90);}
	EBCH A 2 {
		SetOrigin((Pos.X + 40*(1-Angle/90),0,Pos.Z),false);
	}
	Goto IDLE;
	
	214H:
	---- A 1;
	EBQB BCDE 2;
	EBQB F 3 {
		HitLine(96,(0,8),HITSTUN_HEAVY,'SlashPuff',(0.4,4),'214H') ||
		HitLine(96,(0,-16),HITSTUN_HEAVY,'SlashPuff',(0.4,4),'214H');
	}
	EBQB F 4 {
		HitLine(96,(0,8),HITSTUN_HEAVY,'SlashPuff',(0.4,7),'214H2') ||
		HitLine(96,(0,-16),HITSTUN_HEAVY,'SlashPuff',(0.4,7),'214H2');
	}
	EBQB GGG 2;
	EB5H HH 2;
	Goto IDLE;
	
	214M:
	---- A 1;
	EBQB BCDE 2;
	EBQB J 8 {
		HitLine(96,(0,-16),HITSTUN_HEAVY,'SlashPuff',(0.4,6),'214M', MOVE_BLOCKLOW);
	}
	EBQB GG 2;
	EB5H H 2;
	Goto IDLE;
	}
}