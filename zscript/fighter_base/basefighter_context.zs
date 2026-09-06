extend class BaseFighter {
	BaseFighter otherP;
	int pIdx;

	void ContextPostBeginPlay() {
		pIdx = 0;
		if (Angle == 180) {
			pIdx = 1;
		}
		
		// TODO: DEBUG CODE: REMOVE THIS
		ThinkerIterator pFinder = ThinkerIterator.Create("BaseFighter");
		BaseFighter mo;
		while (mo = BaseFighter(pFinder.Next())) {
			if (180 - mo.Angle == Angle) {
				otherP = mo;
				break;
			}
		}
	}

	void ContextTick() {
// 		Console.Printf("%d", otherP.Health);
// 		SetInventory("EnemyHP",otherP.Health,true);
	}
}

// class EnemyHP : Inventory {
// 	Default {
// 		Inventory.Amount 1;
// 		Inventory.MaxAmount 100;
		
// 	}
// }