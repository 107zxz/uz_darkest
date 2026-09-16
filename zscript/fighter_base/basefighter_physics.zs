extend class BaseFighter {
	void PhysicsPostBeginPlay() {
	
	}
	
	void PhysicsTick() {
		if (otherP)
			UnstuckMe();
	}

	// Will be called every frame on BOTH players, so we should expect
	// the other player to do this too befor this gets called again
	// if we're inside each other
	void UnstuckMe() {
		float delta = Math.abs(otherP.Pos.X - Pos.X);
		
		float newX = Pos.X;
		
		// Keep in bounds
		newX = min(160-Radius/2,newX);
		newX = max(-160+Radius/2,newX);
		
		// Don't allow players to get too far apart!
		newX = max(otherP.Pos.X - 160,newX);
		newX = min(otherP.Pos.X + 160,newX);
		
		// Don't allow players to get too close together!
		if (Abs(Pos.Z - otherP.Pos.Z)< 40 && delta<Radius/2+otherP.Radius/2) {
			float seperation_force=Radius/2+otherP.Radius/2-delta;
			
			newX-=seperation_force/3 * (1-Angle/90);
		}
		
		SetOrigin((newX,Pos.Y,Pos.Z),true);
	}
}