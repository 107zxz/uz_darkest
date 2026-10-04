class BlankBar : BaseStatusBar {
	HUDFont trainingFont;
	
	float chainFade;
	float chainFade2;
	
	float screenFadeIn;
	
	bool rematchScreen;
	bool p1rematch;
	bool p2rematch;
	
	int p1rounds;
	int p2rounds;

	override void Init() {
		Super.Init();
// 		SetSize(0,640,480);
		
		trainingFont = HUDFont.Create(confont);
// 		rematchScreen = true;
	}
	
	void UpdateChain(BaseFighter p, bool rightSide) {
		int comboLength = 0;
		if (p.combo != null)
			comboLength = p.combo.hits;
		int comboChain = 1;
		if (p.combo != null)
			comboChain = p.combo.chain;
			
		if (comboLength > 1) {
			if (rightSide) chainFade2 = 1.0;
			else chainFade = 1.0;
		} else {
		
			if (rightSide) {
				chainFade2 -= 2.0/35.0;
			} else {
				chainFade -= 2.0/35.0;
			}
		}
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
		} else {
		
			if (rightSide) {
				DrawImage(chainBreakTex,(32,-32), chainFlags,chainFade2);
			} else {
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
	
	void UpdateScreenFX(int p1hp, int p2hp) {
		if ((p1hp <= 17 || p2hp <= 17) && !rematchScreen) {
			screenFadeIn -= 4.0/35;
			
		} else if (screenFadeIn <= 1.0) {
			screenFadeIn += 2.0/35;
		} else {
			screenFadeIn = 1.0*10;
		}
		
		if (screenFadeIn < -0.25 && !rematchScreen) {
			if (p2hp <= 17) p1rounds += 1;
			if (p1hp <= 17) p2rounds += 1;
			
			if (p1rounds > 1 || p2rounds > 1) {
				rematchScreen = true;
				screenFadeIn = 1.0 * 6;
			}else {
				screenFadeIn = 0;
				Level.ChangeLevel("MAP01", 0, 0);//CHANGELEVEL_RESETINVENTORY|CHANGELEVEL_RESETHEALTH|CHANGELEVEL_NOINTERMISSION);
			}
		}
		
		if (rematchScreen) {
			if (((Ancestor)(players[0].mo)).allFighters[0].inputQueue[0] & BT_ATTACK) {
				p1rematch = true;
			}
			
			if (((Ancestor)(players[0].mo)).allFighters[1].inputQueue[0] & BT_ATTACK) {
				p2rematch = true;
			}
		}
		
		if (rematchscreen && p1rematch && p2rematch) {
			p1rematch = false;
			p2rematch = false;
			rematchScreen = false;
			p1rounds = 0;
			p2rounds = 0;
			screenFadeIn = 0;
			Level.ChangeLevel("MAP01", 0, 0);
		}
	}
	
	void DrawScreenFX(int p1hp, int p2hp) {
		if ((p1hp <= 17 || p2hp <= 17) && !rematchScreen) {
			
			if (screenFadeIn <= 1.0 * 6)
				DrawString(trainingFont,"ABBEY WINS",(360,360),9,Font.CR_BRICK,1,-1,4,(3,3));
		}
		
		Fill(color(255,0,0,0),0,0,1200,600 - screenFadeIn*800);
		Fill(color(255,0,0,0),0,screenFadeIn*800,1200,800);
		
		if (rematchScreen) {
			Fill(color(96,0,0,64),0,0,1200,800);
			DrawImage('textures/ABBEYWIN.ase',(0,0),DI_SCREEN_CENTER_BOTTOM);
			Fill(color(255,0,0,0),0,400,1200,800);
			
			DrawString(trainingFont, "\"Never do anything again\"", (200,420),9,Font.CR_RED,1.0,-1,4,(3,3));
			int p1color = Font.CR_ICE;
			int p2color = Font.CR_ICE;
			
			if (p1rematch) p1color = Font.CR_GOLD;
			if (p2rematch) p2color = Font.CR_GOLD;
			
			if (consoleplayer == 0) {
				DrawString(trainingFont, ">Rematch?", (100,510),9,p1color,1.0,-1,4,(3,3));
				DrawString(trainingFont, " Rematch?", (650,510),9,p2color,1.0,-1,4,(3,3));
			} else {
				DrawString(trainingFont, ">Rematch?", (650,510),9,p2color,1.0,-1,4,(3,3));
				DrawString(trainingFont, " Rematch?", (100,510),9,p1color,1.0,-1,4,(3,3));
			}
		}
	}
	
	override void Tick() {
		Super.Tick();
		
		BaseFighter p1 = ((Ancestor)(players[0].mo)).allFighters[0];
		BaseFighter p2 = ((Ancestor)(players[0].mo)).allFighters[1];
		
		if (!p1 || !p2) return;
		
		int p1Health = ((Ancestor)(players[0].mo)).allFighters[0].Health;
		int enemyhealth = ((Ancestor)(players[0].mo)).allFighters[1].Health;
		
		UpdateChain(p1,false);
		UpdateChain(p2,true);
		UpdateScreenFX(p1Health, enemyhealth);
	}

	override void Draw(int state, double TicFrac) {
		Super.Draw(state, TicFrac);
		
		BaseFighter p1 = ((Ancestor)(players[0].mo)).allFighters[0];
		BaseFighter p2 = ((Ancestor)(players[0].mo)).allFighters[1];
		
		if (!p1 || !p2) return;
		
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


		float HPSCALE = 366.0/150.0;
		Fill(color(255,255,255,0),-p1Health * HPSCALE,62,p1Health * HPSCALE,23,DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP);
		Fill(color(255,255,255,0),0,62,enemyhealth * HPSCALE,23,DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP);
		Fill(color(255,255,128,0),-p1Health * HPSCALE,72,p1Health * HPSCALE,14,DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP);
		Fill(color(255,255,128,0),0,72,enemyhealth * HPSCALE,14,DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP);

		DrawImage("textures/uieclipse.ase", (0, 20), DI_SCREEN_CENTER_TOP|DI_ITEM_TOP, 1.0);
		
		// Round wins
		if (p2rounds > 0)
			DrawImage("textures/roundicon.ase", (35, 130), DI_SCREEN_CENTER_TOP|DI_ITEM_TOP, 1.0);
		if (p1rounds > 0)
			DrawImage("textures/roundicon.ase", (-40, 130), DI_SCREEN_CENTER_TOP|DI_ITEM_TOP, 1.0);
		if (p2rounds > 1)
			DrawImage("textures/roundicon.ase", (56, 120), DI_SCREEN_CENTER_TOP|DI_ITEM_TOP, 1.0);
		if (p1rounds > 1)
			DrawImage("textures/roundicon.ase", (-60, 120), DI_SCREEN_CENTER_TOP|DI_ITEM_TOP, 1.0);

// 		// Chain info
		DrawChain(p1, false);
		DrawChain(p2, true);
		
		// Round start/end
		DrawScreenFX(p1.Health, p2.Health);
		
		// VERSION
		DrawString(trainingFont, "'SUNLESS STRIKE' ALPHA PLAYTEST 6",(5,5));
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