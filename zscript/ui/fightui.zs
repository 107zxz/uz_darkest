class BlankBar : BaseStatusBar {
	HUDFont trainingFont;

	override void Init() {
		Super.Init();
// 		SetSize(64,640,480);
		
		trainingFont = HUDFont.Create(smallfont);
	}

	override void Draw(int state, double TicFrac) {
		Super.Draw(state, TicFrac);
		
		int enemyhealth = ((Ancestor)(players[0].mo)).allFighters[1].Health;

		BeginHUD(1.0, true, 640, 480);
		DrawImage("textures/uibarsback.ase", (0, 60), DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP, 1.0);
		DrawImage("textures/uibarsback.ase", (0, 60), DI_SCREEN_CENTER_TOP|DI_ITEM_RIGHT_TOP|DI_MIRROR, 1.0);
		DrawImage("textures/uibarsfront.ase", (enemyhealth*2-300, 62), DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP, 1.0);
		DrawImage("textures/uibarsfront.ase", (0, 62), DI_SCREEN_CENTER_TOP|DI_ITEM_RIGHT_TOP|DI_MIRROR, 1.0);
		DrawImage("textures/uieclipse.ase", (0, 20), DI_SCREEN_CENTER_TOP|DI_ITEM_TOP, 1.0);

		// Training info
		Fill(color(128,128,128,255),15,15,65,25);
		Fill(color(255,0,0,0),20,20,55,15);
		
// 		DrawString(trainingFont, "\cjv0.0.0", (25,25));

		DrawString(trainingFont,String.Format("\cjP2 HP: %d",enemyhealth),(25,25+8*0));
// 		DrawString(trainingFont,String.Format("\cjP2 inputs: %d",players[1].buttons),(25,25+8*1));
		
// 		DrawString(trainingFont,String.Format("\cjP1 health: %d",players[0].mo.Health),(25,25+8*3));
// 		DrawString(trainingFont,String.Format("\cjP2 health: %d",GetAmount("EnemyHP")),(25,25+8*4));
	}
}