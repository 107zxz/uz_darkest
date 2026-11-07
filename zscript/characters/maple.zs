class Maple : BaseFighter {
  States {
  SPAWN:
  IDLE:
	MAPL A 2;
    Loop;
  LAND:
	---- A 7;
	Goto IDLE;
  MA5H:
    FETC ABCCDDEEFGHIJ 3;
    Goto IDLE;
  PAIN:
// 	MAHT A 16;
	MABK AB 14;
	Goto IDLE;

  BLOCK:
	MABK AB 12;
	Goto IDLE;
  }
}