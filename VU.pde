public static class VU {

	public static final PVector Origin = new PVector(0,0,0);
	public static final PVector Xaxis = new PVector(1,0,0);
	public static final PVector Yaxis = new PVector(0,1,0);
	public static final PVector Zaxis = new PVector(0,0,1);

	private VU () {}

	public static PVector rotateAround(PVector p, float theta, PVector axe){
		PVector q = new PVector(0f,0f,0f);
		PVector r = axe.copy();

		double costheta,sintheta;

		r.normalize();

		costheta = cos(theta);
		sintheta = sin(theta);

		q.x += (costheta + (1 - costheta) * r.x * r.x) * p.x;
		q.x += ((1 - costheta) * r.x * r.y - r.z * sintheta) * p.y;
		q.x += ((1 - costheta) * r.x * r.z + r.y * sintheta) * p.z;

		q.y += ((1 - costheta) * r.x * r.y + r.z * sintheta) * p.x;
		q.y += (costheta + (1 - costheta) * r.y * r.y) * p.y;
		q.y += ((1 - costheta) * r.y * r.z - r.x * sintheta) * p.z;

		q.z += ((1 - costheta) * r.x * r.z - r.y * sintheta) * p.x;
		q.z += ((1 - costheta) * r.y * r.z + r.x * sintheta) * p.y;
		q.z += (costheta + (1 - costheta) * r.z * r.z) * p.z;

		return q;
	}

	public static PVector pointingVector(PVector origin, PVector target){
		return PVector.sub(target, origin);
	}
} 