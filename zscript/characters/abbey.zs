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
	
	J5P:
	---- A 1;
	EBJP A 2;
	EBJP A 8 HitLine(32,-32,HITSTUN_MEDIUM,'SmashPuff',(0.5,2));
	Goto JUMP;
	
	J5S:
	---- A 1;
	EBJP A 3;
	EBJS AAAA 2 HitLine(32,-24,HITSTUN_MEDIUM,'SlashPuff',(0.75,2.5));
	Goto JUMP;
	
	J5H:
	---- A 1;
	EBJP A 4;
	EBJH A 8 HitLine(64,0,HITSTUN_HEAVY,'SlashPuff',(1,2.5), (3,2.5));
	Goto JUMP;
	
	N5P:
	---- A 1;
	EB5P B 1;
	EB5P B 2 HitLine(32,0,HITSTUN_LIGHT,'SmashPuff',(0.4,0.8));
	EB5P C 2;
	EB5P D 8;
	Goto IDLE;
	
	N5S:
	---- A 1;
	EB5S B 3;
	EB5S C 2;
	EB5S D 3 HitLine(96,0,HITSTUN_MEDIUM,'SlashPuff',(2,0.8));
	EB5S E 2;
	Goto IDLE;
	
	N5H:
	---- A 1;
	EB5H BCDE 2;
	EB5H F 7 HitLine(96,0,HITSTUN_HEAVY,'SlashPuff',(0.4,6));
	EB5H GH 2;
	Goto IDLE;
	
	N2P:
	---- A 1;
	EBCP A 1;
	EBCP A 2 HitLine(32,-16,HITSTUN_LIGHT,'SmashPuff',(0.4,0.8));
	EBCP B 3;
	EBCH A 3;
	Goto IDLE;
	
	N2S:
	---- A 1;
	EBCM A 3;
	EBCM B 3 HitLine(64,-16,HITSTUN_MEDIUM,'SlashPuff',(0.4,6));
	EBCM C 3;
	EBCH A 3;
	Goto IDLE;

	N2H:
	---- A 1;
	EB2H BCD 3;
	EB2H E 3 HitLine(64,32,HITSTUN_MEDIUM,'SlashPuff',(0.4,6));
	EB2H FG 3;
	Goto IDLE;
	}
}