const BT_LIGHT = BT_ATTACK;
const BT_MEDIUM = BT_ALTATTACK;
const BT_HEAVY = BT_USE;
const BT_SPECIAL = BT_RELOAD;
const BT_UP = BT_FORWARD;
const BT_DOWN = BT_BACK;

// Local Multiplayer
const BT_P2_LIGHT = BT_ZOOM;
const BT_P2_MEDIUM = BT_USER2;
const BT_P2_HEAVY = BT_USER3;
const BT_P2_SPECIAL = BT_USER4;
const BT_P2_UP = BT_JUMP;
const BT_P2_DOWN = BT_TURN180;

const BT_MOVECANCEL = BT_USER1;


// TODO: Clear all BUTTONS from the input queue when a move starts

extend class BaseFighter {
    int bt_left;
    int bt_right;
    
    const BUF_LEN = 70;
    const BUF_LEN_ACTIONABLE = 16;
    int inputQueue[BUF_LEN];

	void InputPostBeginPlay() {
	
	}
	
	void InputTick() {
		bt_left = BT_MOVELEFT;
		bt_right = BT_MOVERIGHT;
		if (bXFLIP) {
			bt_left = BT_MOVERIGHT;
			bt_right = BT_MOVELEFT;
		}
	
		HandleInput();
	}
	
	bool ButtonPressed(int btn) {
		return players[pIdx].buttons & btn;
	}
	
	void HandleInput() {
		// Handle co-op buttons
		if (players[0].buttons & BT_P2_LIGHT) players[1].cmd.buttons |= BT_LIGHT;
		else players[1].cmd.buttons &= (0xFFFFFFFF - BT_LIGHT);
		if (players[0].buttons & BT_P2_MEDIUM) players[1].cmd.buttons |= BT_MEDIUM;
		else players[1].cmd.buttons &= (0xFFFFFFFF - BT_MEDIUM);
		if (players[0].buttons & BT_P2_HEAVY) players[1].cmd.buttons |= BT_HEAVY;
		else players[1].cmd.buttons &= (0xFFFFFFFF - BT_HEAVY);
		if (players[0].buttons & BT_P2_SPECIAL) players[1].cmd.buttons |= BT_SPECIAL;
		else players[1].cmd.buttons &= (0xFFFFFFFF - BT_SPECIAL);
		if (players[0].buttons & BT_MOVEUP) players[1].cmd.buttons |= BT_UP;
		else players[1].cmd.buttons &= (0xFFFFFFFF - BT_UP);
		if (players[0].buttons & BT_MOVEDOWN) players[1].cmd.buttons |= BT_DOWN;
		else players[1].cmd.buttons &= (0xFFFFFFFF - BT_DOWN);
		if (players[0].buttons & BT_SPEED) players[1].cmd.buttons |= BT_MOVELEFT;
		else players[1].cmd.buttons &= (0xFFFFFFFF - BT_MOVELEFT);
		if (players[0].buttons & BT_STRAFE) players[1].cmd.buttons |= BT_MOVERIGHT;
		else players[1].cmd.buttons &= (0xFFFFFFFF - BT_MOVERIGHT);
	
        // Add to input queue
        for (int i = BUF_LEN-1; i > 0; i--) {
            inputQueue[i] = inputQueue[i-1];
        }
        inputQueue[0] = players[pIdx].buttons;
        
//         for (int i=0; i<BUF_LEN_ACTIONABLE-1; i++) {
//             Console.Printf("%d ", inputQueue[i]);
//         }
//         Console.Printf("\n");
    }
	
	bool ButtonInInput(String button, int input) {
        button = button.MakeUpper();
        
//         Console.Printf("Checking if button %s in input", button);

//         bool rightBtn = BT_MOVERIGHT;
//         if (bXFLIP) rightBtn = BT_MOVELEFT;
//         bool leftBtn = BT_MOVELEFT;
//         if (bXFLIP) leftBtn = BT_MOVERIGHT;
        
        // TODO: Do these. Work out the boolean shit in python
        if (button == "1" && input & BT_DOWN && input & bt_left) return true;
        if (button == "3" && input & BT_DOWN && input & bt_right) return true;
        if (button == "4" && input & bt_left && !(input & BT_UP) && !(input & BT_DOWN)) return true;
        if (button == "6" && input & bt_right && !(input & BT_UP) && !(input & BT_DOWN)) return true;
        if (button == "7" && input & BT_UP && input & bt_left) return true;
        if (button == "9" && input & BT_UP && input & bt_right) return true;
        
        if (button == "2" && input & BT_DOWN) return true;
        if (button == "8" && input & BT_UP) return true;

        // If nothing above hit we're at 5
        if (button == "5" && !(input & BT_DOWN) && !(input & BT_UP) && !(input & bt_left) && !(input & bt_right)) return true;
        
        if (button == "L" && input & BT_LIGHT) return true;
        if (button == "M" && input & BT_MEDIUM) return true;
        if (button == "H" && input & BT_HEAVY) return true;
        if (button == "S" && input & BT_SPECIAL) return true;
        
        return false;
    }
    
    bool ButtonDown(string repr) {
        return ButtonInInput(repr, inputQueue[0]);
    }
	
	
	bool CheckSpecialInput(String repr) {
	
        int matching = 0;
		String lastMatchingDir = "";

        for (int b = BUF_LEN_ACTIONABLE-2; b >= 0; b--) {
		
            while (
                (
                    ButtonInInput(repr.Mid(matching,1), inputQueue[b]) &&
                    !ButtonInInput(repr.Mid(matching,1), inputQueue[b+1])
// 					inputQueue[b+1] & BT_MOVECANCEL == 0
                ) || (
					repr.Length() > 3 && 
					!ButtonInInput(repr.Mid(matching,1), inputQueue[b]) &&
                    ButtonInInput(repr.Mid(matching,1), inputQueue[b+1])
				)
            ) {
				if (inputQueue[b+1] & BT_MOVECANCEL) break;
				
				if (matching < repr.Length()-1) 
					lastMatchingDir = repr.Mid(matching,1);
				
				matching += 1;
				
			}
            
            if (matching >= repr.Length() && (repr.Length() < 4 || ButtonInInput(lastMatchingDir, inputQueue[0]))) {
				
				inputQueue[1] = BT_MOVECANCEL;
				for (int i = 2;i<BUF_LEN_ACTIONABLE;i++)
					inputQueue[i] = 0;
				
				// Since we've cancelled, no need to keep the window open
				canceltics = 0;
                
// 				Console.Printf("Found %s!", repr);
                return true;
            }
        }
        
        // Special condition, the last DIRECTION should be held instead of pressed
        
        return false;
    }
	
	String buttonString(int buttons) {
        int leftBtn = BT_MOVELEFT;
        int rightBtn = BT_MOVERIGHT;
        if (consoleplayer > 0) {
            leftBtn = BT_MOVERIGHT;
            rightBtn = BT_MOVELEFT;
        }

        String buttonText = "";
        if (buttons & BT_DOWN) {
            if (buttons & rightBtn) buttonText = buttonText .. "3";
            else if (buttons & leftBtn) buttonText = buttonText .. "1";
            else buttonText = buttonText .. "2";
        } else if (buttons & BT_UP) {
            if (buttons & rightBtn) buttonText = buttonText .. "9";
            else if (buttons & leftBtn) buttonText = buttonText .. "7";
            else buttonText = buttonText .. "8";
        } else if (buttons & rightBtn) buttonText = buttonText .. "6";
        else if (buttons & leftBtn) buttonText = buttonText .. "4";
        else buttonText = buttonText .. "5";
        if (buttons & BT_LIGHT) buttonText = buttonText .. "L";
        if (buttons & BT_MEDIUM) buttonText = buttonText .. "M";
        if (buttons & BT_HEAVY) buttonText = buttonText .. "H";
		if (buttons & BT_MOVECANCEL) buttonText = buttonText .. "--------";
        return buttonText;
    }
}