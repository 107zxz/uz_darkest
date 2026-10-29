class BaseFighter : Actor abstract {
	AncestorReminderer rollbackHandler;
	FightState fightState;
	bool rollbackManaged;

	Default {
	Radius 12;
	Height 53;
	Scale 0.2;
	PainChance 255;
	PainSound "";
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

	// Hold the source animation frame for a queued move cancel without an
	// extra blank state in every move sequence.
	void TickActorWithMoveCancel() {
		if (!HasPendingMoveCancel()) {
			Super.Tick();
			return;
		}

		State sourceState = curstate;
		int sourceTics = tics;
		if (sourceTics > 0) tics = sourceTics + 1;
		Super.Tick();

		if (curstate == sourceState) {
			if (sourceTics > 0) tics = sourceTics;
			if (HasPendingMoveCancel()) ApplyPendingMoveCancel();
		} else {
			pendingCancelMoveValid = false;
			pendingCancelSourceState = null;
		}
	}

	void bTick() {
		// Networked matches are advanced by AncestorReminderer in a stable
		// player order. Actor thinker ticks must not advance gameplay a second time.
		if (rollbackManaged) return;

		TickActorWithMoveCancel();
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
		TickActorWithMoveCancel();
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