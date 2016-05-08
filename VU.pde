public static class VU {

	private VU () {}

	public static PVector rotateAround(PVector p, float theta, PVector r){
		PVector q = new PVector(0f,0f,0f);

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
} 