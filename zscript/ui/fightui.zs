class BlankBar : BaseStatusBar {
	HUDFont trainingFont;
	
	float chainFade;
	float chainFade2;
	

	override void Init() {
		Super.Init();
// 		SetSize(0,640,480);
		
		trainingFont = HUDFont.Create(confont);
	}
	
	void DrawChain(BaseFighter p, bool rightSide) {
		
		string chainTex = "textures/CHAIN.ase";
		string chainBreakTex = "textures/CHAINBROKEN.ase";
		int chainFlags = DI_SCREEN_LEFT_TOP|DI_ITEM_LEFT_TOP;
		
		if (rightSide) {
			chainTex = "textures/CHAIN2.ase";
			chainBreakTex = "textures/CHAINBROKEN2.ase";
			chainFlags = DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP;
		}
	
		int comboLength = 0;
		if (p.combo != null)
			comboLength = p.combo.hits;
		int comboChain = 1;
		if (p.combo != null)
			comboChain = p.combo.chain;
			
		if (comboLength > 1) {
			if (comboChain < 1) {
				if (!rightSide) DrawImage(chainTex,(-96-64,-72), chainFlags,0.4);
				else DrawImage(chainTex,((-96-64)*-1,-72), chainFlags,0.4);
			}
			if (comboChain < 2) {
				if (!rightSide) DrawImage(chainTex,(-96,-72), chainFlags,0.4);
				else DrawImage(chainTex,((-96)*-1,-72), chainFlags,0.4);
			}
			if (comboChain < 3) {
				if (!rightSide) DrawImage(chainTex,(-32,-72), chainFlags,0.4);
				else DrawImage(chainTex,((-32)*-1,-72), chainFlags,0.4);
// 				DrawImage(chainTex,(-32,0), chainFlags,0.8);
			}

			if (rightSide) chainFade2 = 1.0;
			else chainFade = 1.0;
		} else {
		
			if (rightSide) {
				chainFade2 -= 1.0/35.0;
				DrawImage(chainBreakTex,(32,-32), chainFlags,chainFade2);
			} else {
				chainFade -= 1.0/35.0;
				DrawImage(chainBreakTex,(-32,-32), chainFlags,chainFade);
			}
		} 
		
		if (rightSide) {
			DrawString(trainingFont,String.Format("Chain %d", comboChain+1), (720,64),9,Font.CR_ICE,chainFade2,-1,4,(2,2));
			DrawString(trainingFont,String.Format("Hits: %d", comboLength), (720-12,86),9,Font.CR_LIGHTBLUE,chainFade2,-1,4,(3,3));
		} else {
			DrawString(trainingFont,String.Format("Chain %d", comboChain+1), (64,64),9,Font.CR_ICE,chainFade,-1,4,(2,2));
			DrawString(trainingFont,String.Format("Hits: %d", comboLength), (72,86),9,Font.CR_LIGHTBLUE,chainFade,-1,4,(3,3));
		}
	}

	override void Draw(int state, double TicFrac) {
		Super.Draw(state, TicFrac);
		
		BaseFighter p1 = ((Ancestor)(players[0].mo)).allFighters[0];
		BaseFighter p2 = ((Ancestor)(players[0].mo)).allFighters[1];
		
		int p1Health = ((Ancestor)(players[0].mo)).allFighters[0].Health;
		int enemyhealth = ((Ancestor)(players[0].mo)).allFighters[1].Health;
		
		int comboLength = 0;
		if (p1.combo != null)
			comboLength = p1.combo.hits;
		int comboChain = 1;
		if (p1.combo != null)
			comboChain = p1.combo.chain;

		BeginHUD(1.0, true, 800, 600);
		DrawImage("textures/uibarsback.ase", (0, 60), DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP, 1.0);
		DrawImage("textures/uibarsback.ase", (0, 60), DI_SCREEN_CENTER_TOP|DI_ITEM_RIGHT_TOP|DI_MIRROR, 1.0);
// 		DrawImage("textures/uibarsfront.ase", (enemyhealth*2-300, 62), DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP, 1.0);
// 		DrawImage("textures/uibarsfront.ase", (0, 62), DI_SCREEN_CENTER_TOP|DI_ITEM_RIGHT_TOP|DI_MIRROR, 1.0);

		Fill(color(255,255,255,0),-p1Health*2.44,62,p1Health*2.44,23,DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP);
		Fill(color(255,255,255,0),0,62,enemyhealth*2.44,23,DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP);

		DrawImage("textures/uieclipse.ase", (0, 20), DI_SCREEN_CENTER_TOP|DI_ITEM_TOP, 1.0);

// 		// Chain info
		DrawChain(p1, false);
		DrawChain(p2, true);
		
		
		// VERSION
		DrawString(trainingFont, "ALPHA PLAYTEST 4.0",(410,5));
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