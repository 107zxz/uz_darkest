class Fetch : BaseFighter {
	States {
	SPAWN:
	IDLE:
	FETC A 2;
	Loop;
	
	CROUCH:
	EBCH A 2;
	Loop;
	
	WALK:
	FETW ABC 7;
	Loop;
	
	JUMP:
	---- A 2;
	EBAR A 2;
	Loop;
	
	LAND:
	EBCH A 7;
	Goto IDLE;
	
	J5P:
	---- A 2;
	EBJP A 3;
	EBJP A 14 HitLine(32,(0,-16),HITSTUN_MEDIUM,'SmashPuff',(0.5,2),'J5P');
	Goto JUMP;
	
	J5S:
	---- A 2;
	EBJP A 5;
	EBJS A 3 {
		HitLine(32,(0,-8),HITSTUN_MEDIUM,'SlashPuff',(0.75,0),'J5S') ||
		HitLine(32,(0,0),HITSTUN_MEDIUM,'SlashPuff',(0.75,0),'J5S') ||
		HitLine(32,(0,-16),HITSTUN_MEDIUM,'SlashPuff',(0.75,0),'J5S');
	}
	EBJS A 3 {
		HitLine(32,(0,-8),HITSTUN_LIGHT,'SlashPuff',(0.75,0),'J5S2') ||
		HitLine(32,(0,0),HITSTUN_LIGHT,'SlashPuff',(0.75,0),'J5S2') ||
		HitLine(32,(0,-16),HITSTUN_LIGHT,'SlashPuff',(0.75,0),'J5S2');
	}
	EBJS A 3 {
		HitLine(32,(0,-8),HITSTUN_MEDIUM,'SlashPuff',(0.75,0),'J5S3') ||
		HitLine(32,(0,0),HITSTUN_MEDIUM,'SlashPuff',(0.75,0),'J5S3') ||
		HitLine(32,(0,-16),HITSTUN_MEDIUM,'SlashPuff',(0.75,0),'J5S3');
	}
	EBJS A 3 {
		HitLine(32,(0,-8),HITSTUN_MEDIUM,'SlashPuff',(0.75,0),'J5S4') ||
		HitLine(32,(0,0),HITSTUN_MEDIUM,'SlashPuff',(0.75,0),'J5S4') ||
		HitLine(32,(0,-16),HITSTUN_MEDIUM,'SlashPuff',(0.75,0),'J5S4');
	}
	Goto JUMP;
	
	J5H:
	---- A 2;
	EBJP A 7;
	EBJH A 14 {
		HitLine(64,(0,0),HITSTUN_HEAVY,'SlashPuff',(1,0),'J5H', 0, (0,2.5)) ||
		HitLine(64,(0,-16),HITSTUN_HEAVY,'SlashPuff',(1,0),'J5H', 0, (0,2.5)) ||
		HitLine(64,(0,16),HITSTUN_HEAVY,'SlashPuff',(1,0),'J5H', 0, (0,2.5));
	}
	Goto JUMP;
	
	N5P:
	---- A 2;
	FETW BC 2;
	FETW D 3 {
		HitLine(32,(0,0),HITSTUN_LIGHT,'SmashPuff',(0.4,0),'N5P');
	}
	FETW E 3;
	FETW FG 2;
	Goto IDLE;
	
	N5S:
	---- A 2;
	EB5S B 5;
	EB5S C 3;
	EB5S D 5 {
		HitLine(96,(0,0),HITSTUN_MEDIUM,'SlashPuff',(2,0),'N5S') ||
		HitLine(96,(0,32),HITSTUN_MEDIUM,'SlashPuff',(2,0),'N5S') ||
		HitLine(96,(0,64),HITSTUN_MEDIUM,'SlashPuff',(2,0),'N5S');
	}
	EB5S E 3;
	Goto IDLE;
	
	N5H:
	---- A 2;
	EB5H BCDE 3;
	EB5H F 12 {
		HitLine(96,(0,0),HITSTUN_HEAVY,'SlashPuff',(0.4,6),'N5H') ||
		HitLine(96,(0,-16),HITSTUN_HEAVY,'SlashPuff',(0.4,6),'N5H');
	}
	EB5H GH 3;
	Goto IDLE;
	
	N2P:
	---- A 2;
	EBCP A 2;
	EBCP A 3 HitLine(32,(0,-16),HITSTUN_LIGHT,'SmashPuff',(0.4,0),'N2P');
	EBCP B 5;
	EBCH A 5;
	Goto IDLE;
	
	N2S:
	---- A 2;
	EBCM A 5;
	EBCM B 5 HitLine(64,(0,-16),HITSTUN_MEDIUM,'SlashPuff',(0.4,6),'N2S');
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
	}
}