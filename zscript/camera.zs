class Ancestor : PlayerPawn {

    BaseFighter allFighters[2];

    float playerDistance;

    Default {
        Player.DisplayName "Spectator";
        +NOGRAVITY;
        +NOCLIP;
        Radius 8;
        Height 1;
    }
    
        
    override void PostBeginPlay() {
        // Spawn in a fighter
        ThinkerIterator fighterFinder = ThinkerIterator.Create("BaseFighter");
        allFighters[0] = (BaseFighter)(fighterFinder.Next());
        allFighters[1] = (BaseFighter)(fighterFinder.Next());
        
        
        if (!allFighters[1]) allFighters[1] = allFighters[0];
        
        Player.FOV = 85;
		Player.ViewZ = 48.0;
    }
    
    override void PlayerThink() {
        if (allFighters[0] && allFighters[1]) {
		
            float avgX = (allFighters[0].Pos.X + allFighters[1].Pos.X) / 2;
            float avgZ = (allFighters[0].Pos.Z + allFighters[1].Pos.Z) / 2;
			
			// Clamp X between bounds
			avgX = Min(avgX, 80);
			avgX = Max(avgX, -80);
        
            SetOrigin((avgX, Pos.Y, Pos.Z), false);
            Player.ViewZ = avgZ/3.0 + 48.0;
            
            playerDistance = Abs(allFighters[0].Pos.X - allFighters[1].Pos.X);
			
			Player.FOV = max(ATan(playerDistance/2/-Pos.Y)*1.9,85);
        }
    }
}