class BaseFighter : Actor abstract {
	AncestorReminderer rollbackHandler;
	FightState fightState;
	bool rollbackManaged;

	Default {
	Radius 12;
	Height 53;
	Scale 0.2;
	PainChance 255;
// 	PainSound "hit01";
	Health 150;
// 	Health 18;
	
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
		bTick();
	}
	
	void bTick() {
		// Networked matches are advanced by AncestorReminderer in a stable
		// player order. Actor thinker ticks must not advance gameplay a second time.
		if (rollbackManaged) return;

		Super.Tick();
		InputTick();
		MovesTick();
		ContextTick();
		PhysicsTick();
	}

	void EnableRollbackSimulation() {
		InitializeFightState();
		rollbackManaged = true;
	}

	void BeginRollbackTic(int simulationTic, int input) {
		rollbackInputOverrideActive = true;
		rollbackInputOverrideTic = simulationTic;
		rollbackInputOverride = input;
	}

	void RunRollbackTic() {
		Super.Tick();
		AdvanceRollbackMove();
		InputTick();
		MovesTick();
		ContextTick();
		PhysicsTick();
	}

	void EndRollbackTic() {
		rollbackInputOverrideActive = false;
		hasInputSample = false;
	}
}

#include "zscript/fighter_base/basefighter_context.zs"
#include "zscript/fighter_base/basefighter_input.zs"
#include "zscript/fighter_base/basefighter_physics.zs"
#include "zscript/fighter_base/basefighter_moves.zs"
#include "zscript/fighter_base/basefighter_combo.zs"
#include "zscript/fighter_base/fight_state.zs"