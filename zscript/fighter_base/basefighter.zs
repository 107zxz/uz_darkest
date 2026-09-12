class BaseFighter : Actor abstract {
	Default {
	Radius 12;
	Height 53;
	Scale 0.2;
	PainChance 255;
	Health 150;
	
	Friction 0.8;
	  
	+SHOOTABLE;
	+CASTSPRITESHADOW;
	+NOBLOOD;
	+BRIGHT;
	
	+BUDDHA;
	}
	
	override void PostBeginPlay() {
		ContextPostBeginPlay();
		MovesPostBeginPlay();
		PhysicsPostBeginPlay();
	}
	
	override void Tick() {
		Super.Tick();
		
		InputTick();
		MovesTick();
		ContextTick();
		PhysicsTick();
		
	}
}

#include "zscript/fighter_base/basefighter_context.zs"
#include "zscript/fighter_base/basefighter_input.zs"
#include "zscript/fighter_base/basefighter_physics.zs"
#include "zscript/fighter_base/basefighter_moves.zs"
#include "zscript/fighter_base/basefighter_combo.zs"