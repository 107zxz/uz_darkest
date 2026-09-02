class Maple : BaseFighter {
  States {
  SPAWN:
  IDLE:
	MAPL A 1;
    Loop;
  MA5H:
    FETC ABCCDDEEFGHIJ 2;
    Goto IDLE;
  PAIN:
	MAHT A 16;
	Goto IDLE;
  }

}