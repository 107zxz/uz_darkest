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
	EBAR A 1;
	Loop;
	
	N5P:
	EB5P B 1;
	EB5P B 2 {
		HitLine(32,0,10,'PAIN',(0.4,0.8));
		// TODO: Track in class var and cancel next frame
		
	}
	EB5P C 4;
	EB5P D 4;
	Goto IDLE;
	
	N5S:
	EB5S B 4;
	EB5S C 3;
	EB5S D 3 {
		HitLine(96,0,10,'PAIN',(0.4,0.8));
	}
	EB5S E 8;
	Goto IDLE;
	
	N5H:
	EB5H BCD 3;
	EB5H E 3 {
		HitLine(96,0,10,'PAIN',(0.4,0.8));
	}
	EB5H FG 3;
	Goto IDLE;
	
	N2P:
	EBCP A 1;
	EBCP A 2 {
		HitLine(32,0,10,'PAIN',(0.4,0.8));
	}
	EBCP B 3;
	EBCH A 3;
	Goto IDLE;
	
	N2S:
	EBCM A 3;
	EBCM B 3 {
		HitLine(64,0,10,'PAIN',(0.4,0.8));
	}
	EBCM C 3;
	EBCH A 3;
	Goto IDLE;

	N2H:
	EB2H BCDEFG 3;
	Goto IDLE;
	}
	
	  
	override void GroundMoves() {
		if (ButtonPressed(BT_ATTACK) && ButtonPressed(BT_BACK)) SetStateLabel("N2P");
		else if (ButtonPressed(BT_ALTATTACK) && ButtonPressed(BT_BACK)) SetStateLabel("N2S");
		else if (ButtonPressed(BT_USE) && ButtonPressed(BT_BACK)) SetStateLabel("N2H");
		else if (ButtonPressed(BT_ATTACK)) SetStateLabel("N5P");
		else if (ButtonPressed(BT_ALTATTACK)) SetStateLabel("N5S");
		else if (ButtonPressed(BT_USE)) SetStateLabel("N5H");
	}
}