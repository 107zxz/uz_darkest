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
    
        
    void Setup() {
        // Spawn in a fighter
        ThinkerIterator fighterFinder = ThinkerIterator.Create("BaseFighter");
        allFighters[0] = (BaseFighter)(fighterFinder.Next());
        allFighters[1] = (BaseFighter)(fighterFinder.Next());
        
        
        if (!allFighters[1]) allFighters[1] = allFighters[0];
        
        Player.FOV = 85;
		Player.ViewZ = 48.0;
    }
    
    override void PlayerThink() {
        // In the offline rollback test there is only one authoritative simulation,
        // so let the view follow its speculative fighters. In a real network game,
        // keep the camera on confirmed state to avoid peer-dependent camera actors.
        if (allFighters[0] && allFighters[0].rollbackHandler &&
            allFighters[0].rollbackHandler.IsRollbackAhead() &&
            CVar.FindCVar("cl_debugrollback").GetInt() <= 0) return;

        if (allFighters[0] && allFighters[1]) {
		
            float avgX = (allFighters[0].Pos.X + allFighters[1].Pos.X) / 2;
            float avgZ = (allFighters[0].Pos.Z + allFighters[1].Pos.Z) / 2;
			
			// Clamp X between bounds
			avgX = Min(avgX, 80);
			avgX = Max(avgX, -80);
        
            // Every peer must move the same set of camera pawns. Updating only
            // this console player's pawn makes the replicated actor state differ.
            for (int i = 0; i < MAXPLAYERS; i++) {
                if (!playeringame[i] || !players[i].mo) continue;
                Ancestor cameraPawn = Ancestor(players[i].mo);
                if (cameraPawn) {
                    cameraPawn.SetOrigin((avgX, cameraPawn.Pos.Y, cameraPawn.Pos.Z), false);
                }
            }

            Player.ViewZ = avgZ/3.0 + 48.0;
            
            playerDistance = Abs(allFighters[0].Pos.X - allFighters[1].Pos.X);
			
			Player.FOV = max(ATan(playerDistance/2/-Pos.Y)*1.9,85);
        }
    }
}

class AncestorReminderer : StaticEventHandler {
	const ROLLBACK_INPUT_HISTORY = 64;
	const ROLLBACK_FRAME_HISTORY = 192; // BACKUPTICS (64) times max TicDup (3)

	int rollbackInputTic[ROLLBACK_INPUT_HISTORY];
	int rollbackUsedInput0[ROLLBACK_INPUT_HISTORY];
	int rollbackUsedInput1[ROLLBACK_INPUT_HISTORY];
	int rollbackActualInput0[ROLLBACK_INPUT_HISTORY];
	int rollbackActualInput1[ROLLBACK_INPUT_HISTORY];
	int rollbackActualMask[ROLLBACK_INPUT_HISTORY];
	bool rollbackFrameValid[ROLLBACK_INPUT_HISTORY];
	int newestRollbackLocalTic;
	int latestRollbackCorrectionTic;
	int lastKnownInput0;
	int lastKnownInput1;
	bool rollbackInputStarted;
	bool rollbackSimulationActive;
	BaseFighter rollbackFighter0;
	BaseFighter rollbackFighter1;
	FightRollbackFrame rollbackFrames[ROLLBACK_FRAME_HISTORY];
	Array<RollbackGarlicProjectile> rollbackGarlic;
	int rollbackSimTic;
	int rollbackCurrentTic;
	int latestRollbackConfirmedTic;
	int rollbackTicDup;
	bool rollbackSimStarted;

	override void WorldLoaded (WorldEvent e) {
		ResetRollbackInputs();
		rollbackSimulationActive = false;
		rollbackFighter0 = null;
		rollbackFighter1 = null;
		rollbackSimStarted = false;
		rollbackSimTic = -1;
		rollbackCurrentTic = -1;
		latestRollbackConfirmedTic = -1;
		rollbackTicDup = 1;
		for (int i = 0; i < ROLLBACK_FRAME_HISTORY; i++) rollbackFrames[i] = null;
		ClearRollbackGarlic();
		((Ancestor)(players[consoleplayer].mo)).Setup();
		((Ancestor)(players[consoleplayer].mo)).allFighters[0].PostBeginPlay();
		((Ancestor)(players[consoleplayer].mo)).allFighters[1].PostBeginPlay();

		ThinkerIterator fighterFinder = ThinkerIterator.Create("BaseFighter");
		BaseFighter fighter;
		while (fighter = BaseFighter(fighterFinder.Next())) {
			fighter.rollbackHandler = self;
			fighter.rollbackManaged = false;
			fighter.InitializeFightState();
			if (fighter.pIdx == 0) rollbackFighter0 = fighter;
			else rollbackFighter1 = fighter;
		}
	}

	override void WorldTick() {
		if (!rollbackSimulationActive || !rollbackFighter0 || !rollbackFighter1) return;

		int worldTic = players[consoleplayer].GetWorldTic();
		if (!rollbackSimStarted) {
			rollbackSimTic = worldTic - 1;
			rollbackSimStarted = true;
		}

		// RollbackUpdate may already have simulated these confirmed world tics
		// from local input. Fill only unprocessed world-tic gaps here.
		for (int tic = rollbackSimTic + 1; tic <= worldTic; tic++) {
			int commandTic = tic / rollbackTicDup;
			int input0 = GetRollbackInput(0, commandTic);
			int input1 = GetRollbackInput(1, commandTic);
			if (input0 < 0) input0 = players[0].buttons;
			if (input1 < 0) input1 = players[1].buttons;
			SimulateRollbackTic(tic, input0, input1);
			rollbackSimTic = tic;
		}
	}

	void SimulateRollbackTic(int tic, int input0, int input1) {
		int frameSlot = tic % ROLLBACK_FRAME_HISTORY;
		int commandTic = tic / rollbackTicDup;
		int inputSlot = commandTic % ROLLBACK_INPUT_HISTORY;
		if (rollbackFrames[frameSlot] == null)
			rollbackFrames[frameSlot] = New('FightRollbackFrame');
		rollbackFrames[frameSlot].Capture(tic, rollbackFighter0, rollbackFighter1, input0, input1, rollbackGarlic);

		if (rollbackFrameValid[inputSlot] && rollbackInputTic[inputSlot] == commandTic) {
			rollbackUsedInput0[inputSlot] = input0;
			rollbackUsedInput1[inputSlot] = input1;
		}

		rollbackCurrentTic = tic;
		rollbackFighter0.BeginRollbackTic(tic, input0);
		rollbackFighter1.BeginRollbackTic(tic, input1);
		rollbackFighter0.RunRollbackTic();
		rollbackFighter1.RunRollbackTic();
		AdvanceRollbackGarlic();
		rollbackFighter0.EndRollbackTic();
		rollbackFighter1.EndRollbackTic();
	}

	void ResetRollbackInputs() {
		rollbackInputStarted = false;
		newestRollbackLocalTic = -1;
		latestRollbackCorrectionTic = -1;
		lastKnownInput0 = 0;
		lastKnownInput1 = 0;
		for (int i = 0; i < ROLLBACK_INPUT_HISTORY; i++) {
			rollbackFrameValid[i] = false;
			rollbackInputTic[i] = -1;
			rollbackActualMask[i] = 0;
		}
	}

	// Called by UZDoom's network scheduler after it processes packets, including
	// when the normal world ticker is waiting for a peer. This records predicted
	// inputs and notices when a later command disagrees with one already used.
	override void RollbackUpdate(int latestLocalTic, int latestConfirmedTic) {
		if (latestLocalTic < 0) return;
		rollbackTicDup = players[consoleplayer].GetTicDup();
		latestRollbackConfirmedTic = (latestConfirmedTic + 1) * rollbackTicDup - 1;
		rollbackSimulationActive = rollbackFighter0 != null && rollbackFighter1 != null;
		if (rollbackSimulationActive) {
			if (!rollbackFighter0.rollbackManaged) rollbackFighter0.EnableRollbackSimulation();
			if (!rollbackFighter1.rollbackManaged) rollbackFighter1.EnableRollbackSimulation();
		}

		if (!rollbackInputStarted) {
			// On joining/loading a level, start at the oldest locally available
			// command rather than attempting to simulate a pre-match history.
			newestRollbackLocalTic = max(-1, latestLocalTic - ROLLBACK_INPUT_HISTORY);
			rollbackInputStarted = true;
		}

		int firstNewTic = newestRollbackLocalTic + 1;
		int oldestNewTic = max(firstNewTic, latestLocalTic - ROLLBACK_INPUT_HISTORY + 1);
		for (int tic = oldestNewTic; tic <= latestLocalTic; tic++) {
			int slot = tic % ROLLBACK_INPUT_HISTORY;
			rollbackInputTic[slot] = tic;
			rollbackFrameValid[slot] = true;
			rollbackActualMask[slot] = 0;

			int input0 = lastKnownInput0;
			int input1 = lastKnownInput1;
			if (players[0].HasCommandAtTic(tic)) {
				input0 = players[0].GetCommandButtonsAtTic(tic);
				rollbackActualInput0[slot] = input0;
				rollbackActualMask[slot] |= 1;
				lastKnownInput0 = input0;
			}
			if (players[1].HasCommandAtTic(tic)) {
				input1 = players[1].GetCommandButtonsAtTic(tic);
				rollbackActualInput1[slot] = input1;
				rollbackActualMask[slot] |= 2;
				lastKnownInput1 = input1;
			}

			rollbackUsedInput0[slot] = input0;
			rollbackUsedInput1[slot] = input1;
		}
		newestRollbackLocalTic = max(newestRollbackLocalTic, latestLocalTic);

		// Inputs can become known after a predicted frame was recorded. Keep the
		// earliest mismatch so the simulation can restore and replay from it.
		int oldestStoredTic = max(0, newestRollbackLocalTic - ROLLBACK_INPUT_HISTORY + 1);
		for (int tic = oldestStoredTic; tic <= min(latestConfirmedTic, newestRollbackLocalTic); tic++) {
			int slot = tic % ROLLBACK_INPUT_HISTORY;
			if (!rollbackFrameValid[slot] || rollbackInputTic[slot] != tic) continue;

			if (!(rollbackActualMask[slot] & 1) && players[0].HasCommandAtTic(tic)) {
				int actual = players[0].GetCommandButtonsAtTic(tic);
				rollbackActualInput0[slot] = actual;
				rollbackActualMask[slot] |= 1;
				lastKnownInput0 = actual;
				if (actual != rollbackUsedInput0[slot] && HasRollbackFrame(tic)) MarkRollbackCorrection(tic * rollbackTicDup);
			}
			if (!(rollbackActualMask[slot] & 2) && players[1].HasCommandAtTic(tic)) {
				int actual = players[1].GetCommandButtonsAtTic(tic);
				rollbackActualInput1[slot] = actual;
				rollbackActualMask[slot] |= 2;
				lastKnownInput1 = actual;
				if (actual != rollbackUsedInput1[slot] && HasRollbackFrame(tic)) MarkRollbackCorrection(tic * rollbackTicDup);
			}
		}

		if (!rollbackSimStarted) {
			rollbackSimTic = players[consoleplayer].GetWorldTic() - 1;
			rollbackSimStarted = true;
		}

		int correctionTic = ConsumeRollbackCorrectionTic();
		if (correctionTic >= 0 && correctionTic <= rollbackSimTic)
			ReplayFromTic(correctionTic);

		// Simulate local command windows at world-tic granularity. A duplicated
		// network command is fed to each of its TicDup world ticks.
		int latestLocalWorldTic = (latestLocalTic + 1) * rollbackTicDup - 1;
		for (int tic = rollbackSimTic + 1; tic <= latestLocalWorldTic; tic++) {
			int commandTic = tic / rollbackTicDup;
			int slot = commandTic % ROLLBACK_INPUT_HISTORY;
			if (!rollbackFrameValid[slot] || rollbackInputTic[slot] != commandTic) break;
			// Confirmed commands are advanced by WorldTick with the rest of the
			// level. Predict only the local player's available command when a peer
			// command is missing and the fighter/projectile state is rewindable.
			if (rollbackActualMask[slot] == 3 ||
				!(rollbackActualMask[slot] & (1 << consoleplayer)) || !CanSpeculateRollbackTic()) break;
			int input0 = GetRollbackInput(0, commandTic);
			int input1 = GetRollbackInput(1, commandTic);
			if (input0 < 0 || input1 < 0) break;
			SimulateRollbackTic(tic, input0, input1);
			rollbackSimTic = tic;
		}
	}

	RollbackGarlicProjectile SpawnRollbackGarlic(BaseFighter owner, vector3 position, double velocityX, double velocityZ) {
		RollbackGarlicProjectile projectile = New('RollbackGarlicProjectile');
		SuperGarlicVisual visual = SuperGarlicVisual(owner.Spawn('SuperGarlicVisual', position));
		if (visual == null) return null;
		visual.bXFLIP = owner.bXFLIP;
		projectile.Initialize(owner, visual, position, velocityX, velocityZ, rollbackCurrentTic);
		rollbackGarlic.Push(projectile);
		return projectile;
	}

	void AdvanceRollbackGarlic() {
		for (int i = rollbackGarlic.Size() - 1; i >= 0; i--) {
			RollbackGarlicProjectile projectile = rollbackGarlic[i];
			if (!projectile.Step()) {
				if (projectile.visual) projectile.visual.Destroy();
				rollbackGarlic.Delete(i);
			}
		}
	}

	void ClearRollbackGarlic() {
		for (int i = 0; i < rollbackGarlic.Size(); i++)
			if (rollbackGarlic[i].visual) rollbackGarlic[i].visual.Destroy();
		rollbackGarlic.Clear();
	}

	void RestoreRollbackGarlic(FightRollbackFrame frame) {
		ClearRollbackGarlic();
		for (int i = 0; i < frame.garlicSnapshots.Size(); i++) {
			RollbackGarlicSnapshot state = frame.garlicSnapshots[i];
			SpawnRollbackGarlic(state.owner, state.position, state.velocityX, state.velocityZ);
			RollbackGarlicProjectile projectile = rollbackGarlic[rollbackGarlic.Size() - 1];
			projectile.age = state.age;
			projectile.bounces = state.bounces;
			projectile.bornTic = state.bornTic;
			projectile.visual.SetState(state.visualState, true);
			projectile.visual.tics = state.visualTics;
		}
	}

	bool CanSpeculateRollbackTic() {
		if (!rollbackFighter0 || !rollbackFighter1 || HasActiveRollbackProjectiles()) return false;
		return rollbackFighter0.CanSpeculateRollbackTic() && rollbackFighter1.CanSpeculateRollbackTic();
	}

	bool HasActiveRollbackProjectiles() {
		ThinkerIterator garlicActorFinder = ThinkerIterator.Create("SuperGarlic");
		if (garlicActorFinder.Next()) return true;
		return false;
	}

	void ReplayFromTic(int firstWorldTic) {
		int firstSlot = firstWorldTic % ROLLBACK_FRAME_HISTORY;
		if (!rollbackFrames[firstSlot] || !rollbackFrames[firstSlot].valid || rollbackFrames[firstSlot].tic != firstWorldTic) {
			// The snapshot fell out of the rewind window. Stop prediction rather
			// than applying a correction to an unrelated frame.
			rollbackSimTic = players[consoleplayer].GetWorldTic() - 1;
			return;
		}

		int replayThrough = rollbackSimTic;
		if (CVar.FindCVar("cl_debugrollback").GetInt() > 0) {
			Console.Printf("Rollback test replay: command %d, %d world tics\n",
				firstWorldTic / rollbackTicDup, replayThrough - firstWorldTic + 1);
		}
		DestroyRollbackHitEffectsFrom(firstWorldTic);
		rollbackFrames[firstSlot].Restore();
		RestoreRollbackGarlic(rollbackFrames[firstSlot]);
		rollbackSimTic = firstWorldTic - 1;

		int firstCommandTic = firstWorldTic / rollbackTicDup;
		int previousInput0 = FindLastActualInput(0, firstCommandTic);
		int previousInput1 = FindLastActualInput(1, firstCommandTic);
		for (int commandTic = firstCommandTic; commandTic <= newestRollbackLocalTic; commandTic++) {
			int inputSlot = commandTic % ROLLBACK_INPUT_HISTORY;
			if (!rollbackFrameValid[inputSlot] || rollbackInputTic[inputSlot] != commandTic) break;

			int input0 = previousInput0;
			int input1 = previousInput1;
			if (rollbackActualMask[inputSlot] & 1) {
				input0 = rollbackActualInput0[inputSlot];
				previousInput0 = input0;
			}
			if (rollbackActualMask[inputSlot] & 2) {
				input1 = rollbackActualInput1[inputSlot];
				previousInput1 = input1;
			}
			rollbackUsedInput0[inputSlot] = input0;
			rollbackUsedInput1[inputSlot] = input1;

			int frameStart = max(firstWorldTic, commandTic * rollbackTicDup);
			int frameEnd = min(replayThrough, (commandTic + 1) * rollbackTicDup - 1);
			for (int frame = frameStart; frame <= frameEnd; frame++) {
				SimulateRollbackTic(frame, input0, input1);
				rollbackSimTic = frame;
			}
		}
		lastKnownInput0 = FindLastActualInput(0, newestRollbackLocalTic + 1);
		lastKnownInput1 = FindLastActualInput(1, newestRollbackLocalTic + 1);
	}

	int FindLastActualInput(int playerNum, int beforeTic) {
		int oldest = max(0, beforeTic - ROLLBACK_INPUT_HISTORY);
		for (int tic = beforeTic - 1; tic >= oldest; tic--) {
			int slot = tic % ROLLBACK_INPUT_HISTORY;
			if (!rollbackFrameValid[slot] || rollbackInputTic[slot] != tic) continue;
			if (rollbackActualMask[slot] & (1 << playerNum))
				return playerNum == 0 ? rollbackActualInput0[slot] : rollbackActualInput1[slot];
		}
		return 0;
	}

	void DestroyRollbackHitEffectsFrom(int tic) {
		ThinkerIterator it = ThinkerIterator.Create("SmashPuff");
		SmashPuff smash;
		while (smash = SmashPuff(it.Next()))
			if (smash.rollbackBornTic >= tic) smash.Destroy();

		it = ThinkerIterator.Create("SlashPuff");
		SlashPuff slash;
		while (slash = SlashPuff(it.Next()))
			if (slash.rollbackBornTic >= tic) slash.Destroy();

		it = ThinkerIterator.Create("BlockPuff");
		BlockPuff block;
		while (block = BlockPuff(it.Next()))
			if (block.rollbackBornTic >= tic) block.Destroy();
	}

	bool HasRollbackFrame(int commandTic) {
		int worldTic = commandTic * rollbackTicDup;
		int slot = worldTic % ROLLBACK_FRAME_HISTORY;
		return rollbackFrames[slot] != null && rollbackFrames[slot].valid && rollbackFrames[slot].tic == worldTic;
	}

	bool IsRollbackAhead() {
		return rollbackSimulationActive && rollbackSimTic > latestRollbackConfirmedTic;
	}

	void MarkRollbackCorrection(int tic) {
		if (latestRollbackCorrectionTic < 0 || tic < latestRollbackCorrectionTic)
			latestRollbackCorrectionTic = tic;
	}

	int GetRollbackInput(int playerNum, int tic) {
		if (playerNum < 0 || playerNum > 1 || tic < 0) return -1;
		int slot = tic % ROLLBACK_INPUT_HISTORY;
		if (!rollbackFrameValid[slot] || rollbackInputTic[slot] != tic) return -1;
		if (rollbackActualMask[slot] & (1 << playerNum))
			return playerNum == 0 ? rollbackActualInput0[slot] : rollbackActualInput1[slot];
		return playerNum == 0 ? rollbackUsedInput0[slot] : rollbackUsedInput1[slot];
	}

	int ConsumeRollbackCorrectionTic() {
		int result = latestRollbackCorrectionTic;
		latestRollbackCorrectionTic = -1;
		return result;
	}
}
