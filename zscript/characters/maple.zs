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

  override bool IsRollbackMove(StateLabel move) {
    return move == 'MA5H' || Super.IsRollbackMove(move);
  }

  override bool IsRollbackSafeCurrentState() {
    return Super.IsRollbackSafeCurrentState() || InRollbackState('MA5H') ||
      InRollbackState('LAND') || InRollbackState('PAIN') || InRollbackState('BLOCK');
  }
}