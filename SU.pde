public static class SU {

	private SU () {}

	public static PVector Circle (float radius, int div, int index){
		return Circle(radius, div, index, 0);
	}
	public static PVector Circle (float radius, int div, int index, float z){
		PVector p = new PVector(0, radius, z);
		float theta = (TWO_PI/(float)div) * index;
		p.rotate(theta);
		return p;
	}

	public static PVector Line (PVector a, PVector b, int div, int index){
		return new PVector(0,0,0);
	}
}