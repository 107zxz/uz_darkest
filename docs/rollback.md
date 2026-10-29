# Mod-side rollback

## Overview

Rollback is implemented in ZScript by `AncestorReminderer` (`zscript/camera.zs`), using UZDoom's `StaticEventHandler.RollbackUpdate` callback as its scheduling/input hook. The engine does not restore the mod's match state: the handler owns command history, snapshots, prediction, correction, and replay. On each peer, the handler advances the two fighters in a fixed order (player 0, then player 1) so both fighters are simulated from the same input pair.

The engine callback is invoked from the network scheduler after packets are processed, including while the regular world ticker is waiting for a remote command. UZDoom supplies the newest locally generated command sequence and the newest sequence confirmed for every in-game peer. In a network game, the confirmed sequence is the minimum reported by the other clients. The callback runs before the engine decides how many ordinary world tics can run; it does not advance `gametic` or world thinkers. The mod uses it to advance its own fighter simulation ahead of confirmation when it can do so safely.

## Per-update flow

1. **Initialize/manage fighters.** On `WorldLoaded`, the handler finds the two `BaseFighter`s, attaches itself, initializes their `FightState`s, and clears history. On the first rollback update it anchors the simulation at the current engine world tic and begins tracking commands from that point; older commands are not rollback corrections because no snapshots exist for them. It then enables rollback management. A managed fighter's ordinary `Tick` returns without advancing gameplay; the handler is the sole gameplay tick driver for it.
2. **Record input by command sequence.** The handler stores up to 64 command tics in ring buffers. For each player it uses the command buttons when present, otherwise carries forward that player's last known input. The history also records which inputs were used, so later confirmation can be compared with the prediction. Engine command tics map to world simulation tics using `TicDup`; snapshots are held for 192 world tics (64 × maximum TicDup of 3).
3. **Detect late-input disagreement.** For commands now confirmed, the handler reads any available actual buttons and compares them with the stored used input. It retains the earliest mismatch in the update, converted to a world tic.
4. **Restore and replay if necessary.** A mismatch at or behind the current simulated tic triggers `ReplayFromTic`. The handler restores the pre-simulation snapshot at the correction tic (or searches backward for a retained snapshot), removes rollback-tagged hit/block/slash effects born from that tic onward, restores rollback-owned garlic projectiles, and re-simulates through the prior simulation head. For each command it substitutes newly arrived actual inputs and otherwise uses the previously stored inputs. If no suitable snapshot remains, prediction is disabled rather than replaying from invalid state.
5. **Predict while the normal ticker is waiting.** The handler advances new local command windows at world-tic granularity only when the console player's command exists and the other player's command is missing. It repeats the missing player's last known input. Prediction stops if rollback prediction was disabled, either fighter is in an unaudited state, a native `SuperGarlic` is active, or required input history is unavailable. Fully available/confirmed inputs are left for the normal world-tick path.
6. **Run confirmed gaps on world ticks.** `WorldTick` fills any unprocessed world-tic gaps when both inputs are available. Each simulated tic captures a snapshot first, installs input overrides on both fighters, then steps player 0 and player 1 in fixed order, advances rollback-owned garlic, and clears the overrides.

## What the mod snapshots and simulates

`FightRollbackFrame` captures both `FighterRollbackSnapshot`s and the rollback projectile list before a tic executes. Fighter snapshots include actor position/velocity/state and tics, health, freeze and collision-related fields, input buffers/delay state, combo data, and `FightState` move/locomotion bookkeeping. Garlic projectile snapshots include owner, position, velocity, age, bounce count, birth tic, and visual animation state.

The fighter path deliberately limits the amount of legacy actor logic that is replayed. `IsRollbackSafeCurrentState` and `IsRollbackMove` are per-character opt-ins; neutral states are supported by the base class, while characters enumerate additional safe states/moves and provide `ExecuteRollbackMove` implementations where needed. Shared rollback locomotion and move input run from `basefighter_moves.zs`. Rollback-managed hits update fighter health directly rather than invoking engine damage side effects, and rollback-aware visual effects are tagged with their birth tic so they can be discarded and recreated on replay. The garlic combat projectile has game-owned position/velocity and a separate display actor; its state is snapshotted and replayed as part of the match simulation.

`Ancestor.PlayerThink` changes the rendered view with `SetViewPos` rather than moving the `PlayerPawn`. UZDoom includes player-pawn position in its consistency checksum, so camera motion must not change the pawn's world position. The local view may follow speculative fighters without affecting network simulation state.

## Multiplayer sequence

The diagram shows one peer's local handler. The other peer runs the same mod-side logic using its own engine command history; neither side waits for a central rollback state packet. Actual remote commands eventually arrive through UZDoom's normal networking and are consumed by the next callback.

```mermaid
sequenceDiagram
    autonumber
    participant Net as UZDoom network scheduler
    participant Peer as This peer's player command buffers
    participant RB as AncestorReminderer
    participant S as Rollback snapshots / effects
    participant F0 as Player 0 BaseFighter
    participant F1 as Player 1 BaseFighter
    participant WT as Ordinary world ticker

    Net->>Peer: Process packets; update command sequences
    Net->>RB: RollbackUpdate(latestLocalTic, latestConfirmedTic)
    RB->>Peer: Read command buttons by tic; repeat last-known input if missing
    RB->>RB: Store used input pair in 64-command history
    RB->>Peer: Re-read commands through latestConfirmedTic
    alt A confirmed command differs from the input already used
        Peer-->>RB: Actual late input differs; report earliest correction tic
        RB->>S: Restore pre-tic fighter/projectile snapshot
        RB->>S: Destroy rollback effects born at/after correction
        loop Replay from correction through previous simulation head
            RB->>Peer: Use actual commands where present; otherwise stored input
            RB->>S: Capture state before this replay tic
            RB->>F0: Install input override; run rollback tic
            RB->>F1: Install input override; run rollback tic
            RB->>S: Advance rollback-owned projectiles/effects
            RB->>F0: Clear input override
            RB->>F1: Clear input override
        end
    else No confirmed-input mismatch
        RB->>RB: Keep current speculative state
    end
    alt Local command is available, remote command is missing, and both fighters/state are safe
        loop Predict each eligible world tic
            RB->>S: Capture pre-tic state
            RB->>F0: Simulate player 0 with its input from the pair
            RB->>F1: Simulate player 1 with its input from the pair
            RB->>S: Advance rollback-owned projectiles
        end
    else Inputs are confirmed, or prediction is unsafe/unavailable
        RB-->>Net: Do not speculate further
    end
    Net->>WT: Run ordinary world tic when peer commands permit
    WT->>RB: WorldTick()
    RB->>RB: Fill any confirmed world-tic gaps not already simulated
    Note over F0,F1: Managed fighters skip ordinary gameplay Tick; handler advances them in stable player order.
```

## Engine reference

The hook contract is declared in `../../UZDoom/wadsrc/static/zscript/events.zs` (`RollbackUpdate`) and invoked by the network scheduler in `../../UZDoom/src/d_net.cpp`. The scheduler computes the local and all-peer-confirmed command sequences, invokes the callback, then proceeds to determine ordinary world tics that can run.
