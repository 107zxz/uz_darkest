// Game-owned state for fighter locomotion. Actor position is mirrored here
// because legacy attack states can still reposition fighters directly.
class FighterRollbackSnapshot play {
	BaseFighter fighter;
	vector3 position;
	vector3 velocity;
	State actorState;
	int actorStateTics;
	int health;
	uint freezeTics;
	double angle;
	double radius;
	double height;
	bool xFlip;
	bool shootable;
	int cancelTics;
	bool inAir;
	Actor lastHitTarget;
	int inputQueue[70];
	int hostInputHistory[13];
	int hostInputDelayTics;
	bool hasHostInputDelay;
	int currentInput;
	int inputSampleTic;
	bool hasInputSample;
	bool hasCombo;
	int comboChain;
	int comboHits;
	float comboProration;
	Array<Name> comboMoves;
	double fightX;
	int lastSimulationTic;
	StateLabel activeMove;
	int moveTic;
	bool activeMoveValid;
	StateLabel pendingCancelMove;
	State pendingCancelSourceState;
	int pendingCancelSourceTics;
	bool pendingCancelMoveValid;

	void Capture(BaseFighter target) {
		fighter = target;
		position = target.Pos;
		velocity = target.Vel;
		actorState = target.CurState;
		actorStateTics = target.tics;
		health = target.Health;
		freezeTics = target.freezetics;
		angle = target.Angle;
		radius = target.Radius;
		height = target.Height;
		xFlip = target.bXFLIP;
		shootable = target.bSHOOTABLE;
		cancelTics = target.cancelTics;
		inAir = target.inAir;
		lastHitTarget = target.lastHitTarget;
		for (int i = 0; i < 70; i++) inputQueue[i] = target.inputQueue[i];
		for (int i = 0; i < 13; i++) hostInputHistory[i] = target.hostInputHistory[i];
		hostInputDelayTics = target.hostInputDelayTics;
		hasHostInputDelay = target.hasHostInputDelay;
		currentInput = target.currentInput;
		inputSampleTic = target.inputSampleTic;
		hasInputSample = target.hasInputSample;

		hasCombo = target.combo != null;
		comboMoves.Clear();
		if (hasCombo) {
			comboChain = target.combo.chain;
			comboHits = target.combo.hits;
			comboProration = target.combo.proration;
			for (int m = 0; m < target.combo.usedMoves.Size(); m++)
				comboMoves.Push(target.combo.usedMoves[m]);
		}

		if (target.fightState) {
			fightX = target.fightState.x;
			lastSimulationTic = target.fightState.lastSimulationTic;
			activeMove = target.fightState.activeMove;
			moveTic = target.fightState.moveTic;
			activeMoveValid = target.fightState.activeMoveValid;
		}
		pendingCancelMove = target.pendingCancelMove;
		pendingCancelSourceState = target.pendingCancelSourceState;
		pendingCancelSourceTics = target.pendingCancelSourceTics;
		pendingCancelMoveValid = target.pendingCancelMoveValid;
	}

	void Restore() {
		if (fighter == null) return;
		fighter.SetOrigin(position, false);
		fighter.Vel = velocity;
		fighter.Health = health;
		fighter.freezetics = freezeTics;
		fighter.Angle = angle;
		fighter.RestoreRollbackSize(radius, height);
		fighter.bXFLIP = xFlip;
		fighter.bSHOOTABLE = shootable;
		fighter.SetState(actorState, true);
		fighter.tics = actorStateTics;
		fighter.cancelTics = cancelTics;
		fighter.inAir = inAir;
		fighter.lastHitTarget = lastHitTarget;
		for (int i = 0; i < 70; i++) fighter.inputQueue[i] = inputQueue[i];
		for (int i = 0; i < 13; i++) fighter.hostInputHistory[i] = hostInputHistory[i];
		fighter.hostInputDelayTics = hostInputDelayTics;
		fighter.hasHostInputDelay = hasHostInputDelay;
		fighter.currentInput = currentInput;
		fighter.inputSampleTic = inputSampleTic;
		fighter.hasInputSample = hasInputSample;

		if (!hasCombo) {
			fighter.combo = null;
		} else {
			if (fighter.combo == null)
				fighter.combo = ComboSequence.Init(comboProration);
			fighter.combo.chain = comboChain;
			fighter.combo.hits = comboHits;
			fighter.combo.proration = comboProration;
			fighter.combo.usedMoves.Clear();
			for (int m = 0; m < comboMoves.Size(); m++)
				fighter.combo.usedMoves.Push(comboMoves[m]);
		}

		if (fighter.fightState) {
			fighter.fightState.x = fightX;
			fighter.fightState.lastSimulationTic = lastSimulationTic;
			fighter.fightState.activeMove = activeMove;
			fighter.fightState.moveTic = moveTic;
			fighter.fightState.activeMoveValid = activeMoveValid;
		}
		fighter.pendingCancelMove = pendingCancelMove;
		fighter.pendingCancelSourceState = pendingCancelSourceState;
		fighter.pendingCancelSourceTics = pendingCancelSourceTics;
		fighter.pendingCancelMoveValid = pendingCancelMoveValid;
	}
}

class FightRollbackFrame play {
	int tic;
	int input0;
	int input1;
	bool valid;
	FighterRollbackSnapshot state0;
	FighterRollbackSnapshot state1;
	// Array<RollbackGarlicSnapshot> garlicSnapshots;

	void Capture(int frameTic, BaseFighter fighter0, BaseFighter fighter1, int buttons0, int buttons1 /*, Array<RollbackGarlicProjectile> garlic */) {
		if (state0 == null) state0 = New('FighterRollbackSnapshot');
		if (state1 == null) state1 = New('FighterRollbackSnapshot');
		tic = frameTic;
		input0 = buttons0;
		input1 = buttons1;
		state0.Capture(fighter0);
		state1.Capture(fighter1);
		/*
		while (garlicSnapshots.Size() > garlic.Size())
			garlicSnapshots.Delete(garlicSnapshots.Size() - 1);
		for (int i = 0; i < garlic.Size(); i++) {
			RollbackGarlicSnapshot snapshot;
			if (i < garlicSnapshots.Size()) snapshot = garlicSnapshots[i];
			else {
				snapshot = New('RollbackGarlicSnapshot');
				garlicSnapshots.Push(snapshot);
			}
			snapshot.Capture(garlic[i]);
		}
		*/
		valid = true;
	}

	void Restore() {
		if (!valid) return;
		state0.Restore();
		state1.Restore();
	}
}

class FightState {
	double x;
	int lastSimulationTic;
	StateLabel activeMove;
	int moveTic;
	bool activeMoveValid;
	bool initialized;

	void Initialize(double startX, int simulationTic) {
		x = startX;
		lastSimulationTic = simulationTic;
		initialized = true;
	}

	void SyncPosition(double actorX, int simulationTic) {
		x = actorX;
		lastSimulationTic = simulationTic;
		initialized = true;
	}

	void BeginMove(StateLabel move) {
		activeMove = move;
		moveTic = 0;
		activeMoveValid = true;
	}

	void EndMove() {
		moveTic = 0;
		activeMoveValid = false;
	}
}

extend class BaseFighter {
	StateLabel pendingCancelMove;
	State pendingCancelSourceState;
	int pendingCancelSourceTics;
	bool pendingCancelMoveValid;

	/*
	void SpawnGarlicProjectile(double velocityX, double velocityZ) {
		vector3 spawnPos = Pos + (-10, 0, 38);
		if (rollbackManaged && rollbackHandler) {
			rollbackHandler.SpawnRollbackGarlic(self, spawnPos, velocityX, velocityZ);
			return;
		}

		Actor garlic = Spawn('SuperGarlic', spawnPos);
		garlic.target = self;
		garlic.Vel.X = velocityX;
		garlic.Vel.Z = velocityZ;
	}
	*/

	void RestoreRollbackSize(double radius, double height) {
		A_SetSize(radius);
		Height = height;
	}

	// Prediction is enabled by default. Override this to exclude states whose
	// side effects are not restored by FightRollbackFrame or replayable.
	virtual bool IsRollbackUnsafeCurrentState() {
		return false;
	}

	virtual bool IsRollbackSafeCurrentState() {
		return !IsRollbackUnsafeCurrentState();
	}

	bool InRollbackState(StateLabel state) {
		return InStateSequence(curstate, ResolveState(state));
	}

	// Optional per-tic hook for moves that need rollback-specific behavior.
	// The normal actor state action still runs; guard its default side effect
	// with !rollbackManaged when this hook replaces it.
	virtual void ExecuteRollbackMove(StateLabel move, int frame) {
	}

	// A queued move cancel holds the source state for one simulation tic. If
	// another action changed that state first, discard the request.
	bool HasPendingMoveCancel() {
		if (!pendingCancelMoveValid) return false;
		if (curstate == pendingCancelSourceState && tics == pendingCancelSourceTics)
			return true;

		pendingCancelMoveValid = false;
		pendingCancelSourceState = null;
		return false;
	}

	void ApplyPendingMoveCancel() {
		StateLabel nextMove = pendingCancelMove;
		pendingCancelMoveValid = false;
		pendingCancelSourceState = null;

		if (rollbackManaged && fightState)
			fightState.BeginMove(nextMove);
		SetStateLabel(nextMove);
	}

	void AdvanceRollbackMove() {
		if (!rollbackManaged || fightState == null || !fightState.activeMoveValid)
			return;

		if (!InStateSequence(curstate, ResolveState(fightState.activeMove))) {
			fightState.EndMove();
			return;
		}

		ExecuteRollbackMove(fightState.activeMove, fightState.moveTic);
		if (!InStateSequence(curstate, ResolveState(fightState.activeMove)))
			fightState.EndMove();
		else
			fightState.moveTic++;
	}

	void InitializeFightState() {
		if (fightState == null)
			fightState = New('FightState');
		fightState.Initialize(Pos.X, Level.Time);
	}

	bool CanSpeculateRollbackTic() {
		// States are prediction-safe by default; character overrides can opt out.
		return rollbackManaged && IsRollbackSafeCurrentState();
	}

	bool IsRollbackNeutralState() {
		return InStateSequence(curstate, ResolveState('IDLE')) ||
			InStateSequence(curstate, ResolveState('WALK')) ||
			InStateSequence(curstate, ResolveState('CROUCH')) ||
			InStateSequence(curstate, ResolveState('JUMP')) ||
			InStateSequence(curstate, ResolveState('RUN')) ||
			InStateSequence(curstate, ResolveState('BACKDASH'));
	}

	// Run shared neutral locomotion from the match simulation. Registered move
	// states continue through the actor state machine; their actor fields and
	// rollback-aware hit/projectile effects are captured and replayed separately.
	void StepRollbackLocomotion(int simulationTic, int input) {
		if (fightState == null)
			InitializeFightState();

		// Actor collision/knockback and legacy attack actions can reposition a
		// fighter between simulation steps. Adopt those results before applying
		// the next game-owned neutral movement step.
		fightState.SyncPosition(Pos.X, simulationTic);
		if (!IsRollbackNeutralState()) return;

		int bt_left = BT_MOVELEFT;
		int bt_right = BT_MOVERIGHT;
		if (bXFLIP) {
			bt_left = BT_MOVERIGHT;
			bt_right = BT_MOVELEFT;
		}

		double nextX = fightState.x;
		bool idle = InStateSequence(curstate, ResolveState('IDLE'));
		bool walking = InStateSequence(curstate, ResolveState('WALK'));
		bool crouching = InStateSequence(curstate, ResolveState('CROUCH'));
		bool running = InStateSequence(curstate, ResolveState('RUN'));
		bool backdashing = InStateSequence(curstate, ResolveState('BACKDASH'));
		bool jumping = InStateSequence(curstate, ResolveState('JUMP'));

		if (idle && otherP) {
			if (Pos.X < otherP.Pos.X) {
				Angle = 0;
				bXFLIP = false;
			} else if (Pos.X > otherP.Pos.X) {
				Angle = 180;
				bXFLIP = true;
			}
		}

		if (idle) {
			if ((input & BT_MOVELEFT) || (input & BT_MOVERIGHT))
				SetStateLabel('WALK');
			if (input & BT_DOWN)
				SetStateLabel('CROUCH');
		}

		if (walking) {
			if (!(input & BT_MOVELEFT) && !(input & BT_MOVERIGHT))
				SetStateLabel('IDLE');
			if (input & BT_MOVELEFT) nextX -= 2;
			if (input & BT_MOVERIGHT) nextX += 2;
			if (input & BT_BACK) SetStateLabel('CROUCH');
		}

		if (crouching && !(input & BT_BACK))
			SetStateLabel('IDLE');

		if (running) {
			if (input & bt_right) {
				nextX += 5 * (1 - Angle / 90);
				if (ButtonInInput("9", input)) {
					Vel.Z = 10;
					Vel.X = 5 * (1 - Angle / 90);
					SetOrigin((Pos.X, Pos.Y, Pos.Z + 1), false);
					SetStateLabel('JUMP');
				}
			} else {
				SetStateLabel('IDLE');
			}
		}

		if (backdashing) {
			nextX -= 7 * (1 - Angle / 90);
			if (ButtonInInput("7", input)) {
				Vel.Z = 10;
				Vel.X = -5 * (1 - Angle / 90);
				SetOrigin((Pos.X, Pos.Y, Pos.Z + 1), false);
				SetStateLabel('JUMP');
			}
		}

		if ((idle || walking) && (input & BT_FORWARD) && Pos.Z == FloorZ) {
			if (input & BT_MOVELEFT) Vel.X = -2;
			if (input & BT_MOVERIGHT) Vel.X = 2;
			Vel.Z = 10;
			SetOrigin((Pos.X, Pos.Y, Pos.Z + 1), false);
			SetStateLabel('JUMP');
		}

		if (!jumping && nextX != Pos.X)
			SetOrigin((nextX, Pos.Y, Pos.Z), true);

		fightState.SyncPosition(Pos.X, simulationTic);
	}
}
