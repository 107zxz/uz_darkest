class Abbey : BaseFighter {
	States {
	SPAWN:
	IDLE:
	EBBY A 1 {
		A_SetSize(12);
		otherP.combo = null;
	}
	EBBY A 0 {
// 		if (pIdx == 1)
// 			SetStateLabel('N5S');
	}
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
	EB5H H 8;
	Goto IDLE;
	
	BACKDASH:
	EB5H H 6;
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
	MABK AB 8;
	Goto IDLE;
	
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
		if (HitLine(32,0,0,'SmashPuff',(0,0),'GRAB',MOVE_GRAB | MOVE_NOCANCEL | MOVE_NOHITAIR)) {
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
		HitLine(96,0,HITSTUN_HEAVY,'SlashPuff',(0.8,6),'THROW', MOVE_NOCANCEL);
	}
	EB22 B 2 {
// 		SetOrigin((Pos.X,0,0),true);
// 		otherP.SetOrigin((Pos.X+20 * (1-Angle/90),0,0),true);
		HitLine(96,0,HITSTUN_HEAVY,'SlashPuff',(2,6),'THROW2', MOVE_NOCANCEL);
	}
	EB22 A 13;
	Goto IDLE;
	
	J5P:
	---- A 1;
	EBJP A 2;
	EBJP A 8 HitLine(32,-16,HITSTUN_MEDIUM,'SmashPuff',(0.5,2),'J5P', MOVE_BLOCKHIGH);
	Goto JUMP;
	
	J5S:
	---- A 1;
	EBJP A 3;
	EBJS A 2 {
		HitLine(32,-8,HITSTUN_MEDIUM,'SlashPuff',(0.75,0),'J5S', MOVE_BLOCKHIGH) ||
		HitLine(32,0,HITSTUN_MEDIUM,'SlashPuff',(0.75,0),'J5S', MOVE_BLOCKHIGH) ||
		HitLine(32,-16,HITSTUN_MEDIUM,'SlashPuff',(0.75,0),'J5S', MOVE_BLOCKHIGH);
	}
	EBJS A 2 {
		HitLine(32,-8,HITSTUN_LIGHT,'SlashPuff',(0.75,0),'J5S2', MOVE_BLOCKHIGH) ||
		HitLine(32,0,HITSTUN_LIGHT,'SlashPuff',(0.75,0),'J5S2', MOVE_BLOCKHIGH) ||
		HitLine(32,-16,HITSTUN_LIGHT,'SlashPuff',(0.75,0),'J5S2', MOVE_BLOCKHIGH);
	}
// 	EBJS A 2 {
// 		HitLine(32,-8,HITSTUN_MEDIUM,'SlashPuff',(0.75,0),'J5S3', MOVE_BLOCKHIGH) ||
// 		HitLine(32,0,HITSTUN_MEDIUM,'SlashPuff',(0.75,0),'J5S3',MOVE_BLOCKHIGH) ||
// 		HitLine(32,-16,HITSTUN_MEDIUM,'SlashPuff',(0.75,0),'J5S3',MOVE_BLOCKHIGH);
// 	}
// 	EBJS A 2 {
// 		HitLine(32,-8,HITSTUN_MEDIUM,'SlashPuff',(0.75,0),'J5S4',MOVE_BLOCKHIGH) ||
// 		HitLine(32,0,HITSTUN_MEDIUM,'SlashPuff',(0.75,0),'J5S4',MOVE_BLOCKHIGH) ||
// 		HitLine(32,-16,HITSTUN_MEDIUM,'SlashPuff',(0.75,0),'J5S4',MOVE_BLOCKHIGH);
// 	}
	Goto JUMP;
	
	J5H:
	---- A 1;
	EBJP A 4;
	EBJH A 8 {
		HitLine(64,0,HITSTUN_HEAVY,'SlashPuff',(1,0),'J5H', MOVE_BLOCKHIGH, (0,2.5)) ||
		HitLine(64,-16,HITSTUN_HEAVY,'SlashPuff',(1,0),'J5H', MOVE_BLOCKHIGH, (0,2.5)) ||
		HitLine(64,16,HITSTUN_HEAVY,'SlashPuff',(1,0),'J5H', MOVE_BLOCKHIGH, (0,2.5));
	}
	Goto JUMP;
	
	S22X:
	---- A 1;
	EB22 AABC 4;
	EB22 C 4 {
		A_SpawnItem('SuperCross');
	}
	Goto IDLE;
	
	N5P:
	---- A 1;
	EB5K BC 1;
	EB5K D 2 HitLine(32,0,HITSTUN_LIGHT,'SmashPuff',(0,0),'N5P');
	EB5K E 2;
	EB5K FG 1;
	Goto IDLE;
	
	N5S:
	---- A 1;
	EB5S B 3;
	EB5S C 2;
	EB5S D 3 {
		A_SetSize(64);
		HitLine(96,0,HITSTUN_MEDIUM,'SlashPuff',(2,0),'N5S');
// 		HitLine(96,32,HITSTUN_MEDIUM,'SlashPuff',(2,0),'N5S');
// 		HitLine(96,64,HITSTUN_MEDIUM,'SlashPuff',(2,0),'N5S');
	}
	EB5S E 4;
	TNT1 A 0 A_SetSize(12);
	Goto IDLE;
	
	N5H:
	---- A 1;
	EB5H BCDE 2;
	EB5H F 7 {
		HitLine(96,0,HITSTUN_HEAVY,'SlashPuff',(0.4,6),'N5H') ||
		HitLine(96,-16,HITSTUN_HEAVY,'SlashPuff',(0.4,6),'N5H');
	}
	EB5H GH 2;
	Goto IDLE;
	
	N2P:
	---- A 1;
	EBCP A 1;
	EBCP A 2 HitLine(32,-16,HITSTUN_LIGHT,'SmashPuff',(0.4,0),'N2P');
	EBCP B 3;
	EBCH A 3;
	Goto IDLE;
	
	N2S:
	---- A 1;
	EBCM A 3;
	EBCM B 3 HitLine(64,-16,HITSTUN_MEDIUM,'SlashPuff',(0.4,6),'N2S',MOVE_BLOCKLOW);
	EBCM C 3;
	EBCH A 3;
	Goto IDLE;

	N2H:
	---- A 1;
	EB2H BCD 3;
	EB2H E 3 {
		HitLine(64,32,HITSTUN_MEDIUM,'SlashPuff',(0.4,6),'N2H') ||
		HitLine(64,0,HITSTUN_MEDIUM,'SlashPuff',(0.4,6),'N2H');
	}
	EB2H FG 3;
	Goto IDLE;
	}
}