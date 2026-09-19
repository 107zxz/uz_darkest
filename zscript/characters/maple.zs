class Maple : BaseFighter {
  States {
  SPAWN:
  IDLE:
	MAPL A 1;
    Loop;
  LAND:
	---- A 4;
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