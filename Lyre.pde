public class Lyre{
	private PVector position;
	private PVector normale;
	private PVector pointing;
	private PVector target;

	private float panAmplitude, 
	tiltAmplitude, 
	pan, tilt,
	minBeamAngle, 
	maxBeamAngle,
	beamAngle;


	public Lyre(PVector position, float panAmplitude, float tiltAmplitude, float minBeamAngle, float maxBeamAngle){
		this(position, new PVector(0,0,position.z), panAmplitude, tiltAmplitude, minBeamAngle, maxBeamAngle);
	}

	// lyre pos, normale (origin), pan amplitude in rads, tilt amplitude in rads
	public Lyre(PVector position, PVector pointing, float panAmplitude, float tiltAmplitude, float minBeamAngle, float maxBeamAngle){
		// limitation pointing Z as to be == position Z
		pointing.z = position.z;
		this.position = position.copy();
		this.pointing = pointing;
		setBasePointing(pointing);

		this.panAmplitude = panAmplitude;
		this.tiltAmplitude = tiltAmplitude;
		this.minBeamAngle = minBeamAngle;
		this.maxBeamAngle = maxBeamAngle;
		this.maxBeamAngle = beamAngle;
		this.pan = 0;
		this.tilt = 0;
	}


	public void setBaseNormale(PVector normale){
		this.normale = normale.normalize(null);
	}

	public void setBasePointing(PVector point){
		this.normale = VU.pointingVector(position, point).normalize(null);
	}

	// draw lyre object using processing tools
	public void draw(){
		fill(10,10,15);
		stroke(40);

		pushBaseMatrix();

		pushMatrix();

		// main body
		translate(0,0,-30);
		box(30,30,10);

		// arms
		pushMatrix();
		rotateZ(pan);

		//line(0,0,0, 50,0,0);
		translate(0,-15,15);
		box(10,5, 30);
		translate(0,30,0);
		box(10,5, 30);

		// beam
		pushMatrix();
		translate(0, -15, 15);
		rotateY(tilt);

		ellipse(0, 0, 25, 25);
		//line(0,0,0, 0,0,500);

		popMatrix();

		popMatrix();

		popMatrix();

		// mark the way up
		stroke(255, 127, 255);
		//line(0,0,0,100,0,0);

		popBaseMatrix();
	}

	// draw vectors from actual calculation, without processing space manipulation
	public void drawVectors(){
		// draw normale
		stroke(0, 255, 255);
		PVector n = normale.copy();
		n.setMag(100);
		drawVectorAt(position, n);

		// draw vector pointing target
		stroke(255, 255, 0);
		PVector t = VU.pointingVector(position, target);
		//t.setMag(500);
		drawVectorAt(position, t);

		// draw origin
		PVector o = VU.Zaxis.cross(normale);
		o.setMag(100);
		stroke(255, 0, 0);
		drawVectorAt(position, o);

		// perpendicular
		PVector p = o.cross(normale);
		p.mult(-1);
		stroke(255, 0, 255);
		drawVectorAt(position, p);

		PVector h = VU.rotateAround(p, pan, n);
		drawVectorAt(position, h);

		//target projection on plan (p,o)
		PVector tp = new PVector(PVector.dot(p, t), PVector.dot(o, t));
		PVector tt = new PVector(PVector.dot(n, t), PVector.dot(o, t));
		tp.setMag(100);
		stroke(255);
		//line(position.x,position.y,0, tp.x,tp.y,0);
	}

	// draw light from the fixture
	public void drawLight(){
	}

	public void drawInfo(float[] rotations, int index){
		pushMatrix();
		translate(position.x,position.y,position.z - 30);
		rotateX(rotations[0]);
		rotateY(rotations[1]);
		rotateZ(rotations[2]);

		fill(255, 0, 0);
		text(""+index, -25,0,0);
		fill(255);
		text("P "+Math.round(degrees(pan))+"°", 0,0,0);
		text("T "+Math.round(degrees(tilt))+"°", 0,10,0);

		popMatrix();
	}

	// set fixture local coord system
	private void pushBaseMatrix(){
		pushMatrix();
		translate(position.x, position.y, position.z);
		orientBase();
	}

	// exit local system
	private void popBaseMatrix(){
		popMatrix();
	}

	// set pan tilt of the fixture for a target point
	public void setTarget(PVector target){
		this.target = target;

		PVector n = normale.copy();
		PVector t = VU.pointingVector(position, target);
		PVector o = VU.Zaxis.cross(normale);
		PVector p = o.cross(normale);
		PVector tp = new PVector(PVector.dot(p, t), PVector.dot(o, t));

		PVector h = VU.rotateAround(p, pan, n);
		PVector tt = new PVector(PVector.dot(h, t), PVector.dot(normale, t));

		pan = HALF_PI + atan2(tp.x, -tp.y);
		tilt = PI + atan2(tt.x, -tt.y);

	}

	// orient the base toward it's defined normale
	private void orientBase(){
		rotateY(atan2(normale.x, normale.z));
		rotateX(asin(-normale.y));

		// LIMITATION : this works if normale.z == position.z
		rotateZ(HALF_PI + atan2(normale.x, normale.z));
	}
}