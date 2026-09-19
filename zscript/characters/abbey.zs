class Abbey : BaseFighter {
	States {
	SPAWN:
	IDLE:
	EBBY A 1;
	Loop;
	
	CROUCH:
	EBCH A 1;
	Loop;
	
	WALK:
	EBBY A 1;
	Loop;
	
	JUMP:
	---- A 1;
	EBAR A 1;
	Loop;
	
	LAND:
	EBCH A 4;
	Goto IDLE;
	
  PAIN:
// 	MAHT A 16;
	MABK AB 8;
	Goto IDLE;

  BLOCK:
	MABK AB 7;
	Goto IDLE;
	
	J5P:
	---- A 1;
	EBJP A 2;
	EBJP A 8 HitLine(32,-16,HITSTUN_MEDIUM,'SmashPuff',(0.5,2),'J5P');
	Goto JUMP;
	
	J5S:
	---- A 1;
	EBJP A 3;
	EBJS A 2 {
		HitLine(32,-8,HITSTUN_MEDIUM,'SlashPuff',(0.75,0),'J5S') ||
		HitLine(32,0,HITSTUN_MEDIUM,'SlashPuff',(0.75,0),'J5S') ||
		HitLine(32,-16,HITSTUN_MEDIUM,'SlashPuff',(0.75,0),'J5S');
	}
	EBJS A 2 {
		HitLine(32,-8,HITSTUN_LIGHT,'SlashPuff',(0.75,0),'J5S2') ||
		HitLine(32,0,HITSTUN_LIGHT,'SlashPuff',(0.75,0),'J5S2') ||
		HitLine(32,-16,HITSTUN_LIGHT,'SlashPuff',(0.75,0),'J5S2');
	}
	EBJS A 2 {
		HitLine(32,-8,HITSTUN_MEDIUM,'SlashPuff',(0.75,0),'J5S3') ||
		HitLine(32,0,HITSTUN_MEDIUM,'SlashPuff',(0.75,0),'J5S3') ||
		HitLine(32,-16,HITSTUN_MEDIUM,'SlashPuff',(0.75,0),'J5S3');
	}
	EBJS A 2 {
		HitLine(32,-8,HITSTUN_MEDIUM,'SlashPuff',(0.75,0),'J5S4') ||
		HitLine(32,0,HITSTUN_MEDIUM,'SlashPuff',(0.75,0),'J5S4') ||
		HitLine(32,-16,HITSTUN_MEDIUM,'SlashPuff',(0.75,0),'J5S4');
	}
	Goto JUMP;
	
	J5H:
	---- A 1;
	EBJP A 4;
	EBJH A 8 {
		HitLine(64,0,HITSTUN_HEAVY,'SlashPuff',(1,0),'J5H', (0,2.5)) ||
		HitLine(64,-16,HITSTUN_HEAVY,'SlashPuff',(1,0),'J5H', (0,2.5)) ||
		HitLine(64,16,HITSTUN_HEAVY,'SlashPuff',(1,0),'J5H', (0,2.5));
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
	EB5K D 2 HitLine(32,0,HITSTUN_LIGHT,'SmashPuff',(0.4,0),'N5P');
	EB5K E 2;
	EB5K FG 1;
	Goto IDLE;
	
	N5S:
	---- A 1;
	EB5S B 3;
	EB5S C 2;
	EB5S D 3 {
		HitLine(96,0,HITSTUN_MEDIUM,'SlashPuff',(2,0),'N5S') ||
		HitLine(96,32,HITSTUN_MEDIUM,'SlashPuff',(2,0),'N5S') ||
		HitLine(96,64,HITSTUN_MEDIUM,'SlashPuff',(2,0),'N5S');
	}
	EB5S E 2;
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
	EBCM B 3 HitLine(64,-16,HITSTUN_MEDIUM,'SlashPuff',(0.4,6),'N2S');
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