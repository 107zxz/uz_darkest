class ComboSequence {
	const MAX_CHAINS = 3;

	int chain;
	Array<Name> usedMoves;
	int hits;
	
	float proration;
	
	static ComboSequence Init(float proration) {
		ComboSequence ret = New('ComboSequence');
		
		ret.proration = proration;
		
		return ret;
	}
	
	bool CanDoMove(Name move) {
		int tempChain = chain;
		for (int i=0; i<usedMoves.Size(); i++) {
			if (usedMoves[i] == move) {
				// Move already used! Bump if I can
				tempChain += 1;
				if (tempChain >= MAX_CHAINS) return false;
				
// 				usedMoves.Clear();
				
// 				usedMoves[0] = move;
				
				return true;
			}
		}
		
		// Move not already used! Add to list
// 		for (int i=0;i<20;i++) {
// 			if (usedMoves[i] == '') {
// 				usedMoves[i] = move;
// 			}
// 		}
		
		return true;
	}
	
	void AddMoveToCombo(Name move, float scaleProration) {
		for (int i=0; i<usedMoves.Size(); i++) {
			if (usedMoves[i] == move) {
				// Move already used! Bump if I can
				chain += 1;
				
				usedMoves.Clear();
			}
		}
		
		proration *= scaleProration;
		
		hits += 1;
		usedMoves.Push(move);
	}
}