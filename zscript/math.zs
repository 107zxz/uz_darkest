class Math {
	static float abs(float x) {
		if (x>=0)
			return x;
		else
			return -x;
	}
	
	static float min(float a, float b) {
		return a<b ? a : b;
	}
	
	static float max(float a, float b) {
		return a>b ? a : b;
	}
}