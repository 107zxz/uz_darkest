class Maple : BaseFighter {
  States {
  SPAWN:
  IDLE:
	MAPL A 1;
    Loop;
  LAND:
	MAPL A 4 {
		
		bSHOOTABLE = false;
		A_SetRenderStyle(1.0, STYLE_Stencil);
	}
	TNT1 A 1 {
		A_SetRenderStyle(1.0, STYLE_Normal);
		bSHOOTABLE = true;
	}
	Goto IDLE;
  MA5H:
    FETC ABCCDDEEFGHIJ 2;
    Goto IDLE;
  PAIN:
// 	MAHT A 16;
	MABK AB 8;
	Goto IDLE;

  BLOCK:
	MABK AB 7;
	Goto IDLE;
  }
}