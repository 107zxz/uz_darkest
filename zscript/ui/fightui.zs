class BlankBar : BaseStatusBar {

  override void Draw(int state, double TicFrac) {
    Super.Draw(state, TicFrac);

    BeginHUD(1.0, true, 640, 480);
    DrawImage("textures/uibarsback.ase", (0, 60), DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP, 1.0);
    DrawImage("textures/uibarsback.ase", (0, 60), DI_SCREEN_CENTER_TOP|DI_ITEM_RIGHT_TOP|DI_MIRROR, 1.0);
    DrawImage("textures/uibarsfront.ase", (0, 62), DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP, 1.0);
    DrawImage("textures/uibarsfront.ase", (0, 62), DI_SCREEN_CENTER_TOP|DI_ITEM_RIGHT_TOP|DI_MIRROR, 1.0);
    DrawImage("textures/uieclipse.ase", (0, 20), DI_SCREEN_CENTER_TOP|DI_ITEM_TOP, 1.0);
  }
}