class BlankBar : BaseStatusBar {
	HUDFont trainingFont;
	

	override void Init() {
		Super.Init();
		SetSize(0,320,240);
		
		trainingFont = HUDFont.Create(confont);
	}

	override void Draw(int state, double TicFrac) {
		Super.Draw(state, TicFrac);
		
		BaseFighter p1 = ((Ancestor)(players[0].mo)).allFighters[0];
		
		int enemyhealth = ((Ancestor)(players[0].mo)).allFighters[1].Health;

		BeginHUD(1.0, true, 640, 480);
		DrawImage("textures/uibarsback.ase", (0, 60), DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP, 1.0);
		DrawImage("textures/uibarsback.ase", (0, 60), DI_SCREEN_CENTER_TOP|DI_ITEM_RIGHT_TOP|DI_MIRROR, 1.0);
		DrawImage("textures/uibarsfront.ase", (enemyhealth*2-300, 62), DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP, 1.0);
		DrawImage("textures/uibarsfront.ase", (0, 62), DI_SCREEN_CENTER_TOP|DI_ITEM_RIGHT_TOP|DI_MIRROR, 1.0);
		DrawImage("textures/uieclipse.ase", (0, 20), DI_SCREEN_CENTER_TOP|DI_ITEM_TOP, 1.0);

		// Training info
		
		// Input buffer display. Needs some work before it can be fully exposed to the player
// 		int boxwidth = 128;
// 		int boxheight = 300;
// 		Fill(color(128,128,128,255),15,15,boxwidth,boxheight);
// 		Fill(color(255,0,0,0),20,20,boxwidth - 10,boxheight-10);
// 		DrawString(trainingFont,"\cjP1 Inputs:",(25,25+8*0));
// 		DrawString(trainingFont,"----------",(25,25+8*1));
// 		for (int i = 0; i < p1.BUF_LEN_ACTIONABLE; i++) {
// 			DrawString(trainingFont, String.Format("\cj%s", buttonString(p1.inputQueue[i])), (25,41+8*i));
// 		}
		
		int boxwidth = 300;
		int boxheight = 200;
		Fill(color(128,128,128,255),15,15,boxwidth,boxheight);
		Fill(color(255,0,0,0),20,20,boxwidth - 10,boxheight-10);
		DrawString(trainingFont,"\cjP1 Combo Info:",(25,25+8*0));
		DrawString(trainingFont,"---------------",(25,25+8*1));
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