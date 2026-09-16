class BlankBar : BaseStatusBar {
	HUDFont trainingFont;
	
	float chainFade;
	

	override void Init() {
		Super.Init();
		SetSize(0,320,240);
		
		trainingFont = HUDFont.Create(confont);
	}

	override void Draw(int state, double TicFrac) {
		Super.Draw(state, TicFrac);
		
		BaseFighter p1 = ((Ancestor)(players[0].mo)).allFighters[0];
		
		int enemyhealth = ((Ancestor)(players[0].mo)).allFighters[1].Health;
		
		int comboLength = 0;
		if (p1.combo != null)
			comboLength = p1.combo.hits;
		int comboChain = 1;
		if (p1.combo != null)
			comboChain = p1.combo.chain;

		BeginHUD(1.0, true, 640, 480);
		DrawImage("textures/uibarsback.ase", (0, 60), DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP, 1.0);
		DrawImage("textures/uibarsback.ase", (0, 60), DI_SCREEN_CENTER_TOP|DI_ITEM_RIGHT_TOP|DI_MIRROR, 1.0);
		DrawImage("textures/uibarsfront.ase", (enemyhealth*2-300, 62), DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP, 1.0);
		DrawImage("textures/uibarsfront.ase", (0, 62), DI_SCREEN_CENTER_TOP|DI_ITEM_RIGHT_TOP|DI_MIRROR, 1.0);
		DrawImage("textures/uieclipse.ase", (0, 20), DI_SCREEN_CENTER_TOP|DI_ITEM_TOP, 1.0);

// 		// Chain info
		
		if (comboLength > 1) {
			if (comboChain < 1)
				DrawImage("textures/CHAIN.ase",(-32-32-32-16,-72), DI_SCREEN_LEFT_TOP|DI_ITEM_LEFT_TOP,0.4);
			if (comboChain < 2)
			DrawImage("textures/CHAIN.ase",(-32-32+32,-72), DI_SCREEN_LEFT_TOP|DI_ITEM_LEFT_TOP,0.6);
			if (comboChain < 3)
			DrawImage("textures/CHAIN.ase",(-32,0), DI_SCREEN_LEFT_TOP|DI_ITEM_LEFT_TOP,0.8);
			
			
			
			chainFade = 1.0;
		} else {
			chainFade -= 1.0/35.0;
			DrawImage("textures/CHAINBROKEN.ase",(-32,-32), DI_SCREEN_LEFT_TOP|DI_ITEM_LEFT_TOP,chainFade);
		}
		
		DrawString(trainingFont,String.Format("Chain %d", comboChain+1), (64,64),9,Font.CR_ICE,chainFade,-1,4,(2,2));
		DrawString(trainingFont,String.Format("Hits: %d", comboLength), (72,86),9,Font.CR_LIGHTBLUE,chainFade,-1,4,(3,3));
		
		// VERSION
		DrawString(trainingFont, "ALPHA PLAYTEST 3",(410,5));
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