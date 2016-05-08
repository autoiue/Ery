// float angleZ = 0;
// int spinCount = 0;

Lyre l;
Lyre l1;
Lyre l2;
Lyre l3;
Lyre l4;

PVector Xaxis = new PVector(1,0,0);
PVector Yaxis = new PVector(0,1,0);
PVector Zaxis = new PVector(0,0,1);


void setup(){
	size(1750,1750, P3D);
	fill(255,0,0);
	frameRate(60);
	noSmooth();
	surface.setResizable(true);
	textSize(50);
	textAlign(CENTER, CENTER);

	l = new Lyre(new PVector(150f,-150f,50f), 0f,0f,0f,0f);
	l1 = new Lyre(new PVector(-10f,-40f,200f), 0f,0f,0f,0f);
	l2 = new Lyre(new PVector(-150f,150f,50f), 0f,0f,0f,0f);
		
}

void draw(){
	background(0);

	int targetX = mouseX - width/2;
	int targetY = mouseY - height/2;

	pushMatrix();
		translate(width/2,height/2);
		setCamera();
		drawAxes();

		PVector target = new PVector(targetX, 50, targetY);

		l.setTarget(target);
		l1.setTarget(target);
		l2.setTarget(target);

		l.draw();
		l1.draw();
		l2.draw();
		l.drawVectors();
		l1.drawVectors();
		l2.drawVectors();
		drawTarget(target);
	
	popMatrix();
}

void setCamera(){

	camera(400, 200, 360, 0,0,0, 2,1,-1); // basic
	//camera(0, 0, 500, 0,0,0, 1,1,-1); // dessus
	//camera(0, 0, 50, -10,10,500, 1,1,1);
}

void drawAxes(){
	stroke(255,0,0);
	line(0,0,0, 100,0,0);
	stroke(0,255,0);
	line(0,0,0, 0,100,0);
	stroke(0,0,255);
	line(0,0,0, 0,0,100);
}

void drawTarget(PVector target){
	stroke(255,0,0);
	line(target.x - 10, target.y, target.z, target.x + 10, target.y, target.z);
	line(target.x, target.y - 10, target.z, target.x, target.y + 10, target.z);
	line(target.x, target.y, target.z - 10, target.x, target.y, target.z + 10);
}

class Lyre{
	PVector position;
	PVector normale;
	PVector pointing;
	PVector target;

	float panAmplitude, 
		tiltAmplitude, 
		pan, tilt,
		minBeamAngle, 
		maxBeamAngle,
		beamAngle;


	public Lyre(PVector position, float panAmplitude, float tiltAmplitude, float minBeamAngle, float maxBeamAngle){
		this(position, new PVector(0,0,0), panAmplitude, tiltAmplitude, minBeamAngle, maxBeamAngle);
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
		this.normale = pointingVector(position, point).normalize(null);
	}

	public void draw(){
		pushBaseMatrix();
			fill(200,200,200,120);
			stroke(225);
			pushMatrix();
				translate(0,0,-30);
				box(30,30,10);
				pushMatrix();
					// todo rotate pan here Z is pan
					rotateZ(pan);

					line(0,0,0, 50,0,0);
					translate(0,-15,15);
					box(10,5, 30);
					translate(0,30,0);
					box(10,5, 30);
					pushMatrix();
						// todo rotate tilt here
						translate(0, -15, 15);
						rotateY(tilt);
						ellipse(0, 0, 25, 25);
						line(0,0,0, 0,0,500);
					popMatrix();
				popMatrix();
			popMatrix();
			// origin
			stroke(255, 127, 255);
			line(0,0,0,100,0,0);
		popBaseMatrix();
	}
	public void drawVectors(){
		// draw normale
		stroke(0, 255, 255);
		PVector n = normale.copy();
		n.setMag(100);
		drawVectorAt(position, n);
		// draw vector pointing target
		stroke(255, 255, 0);
		PVector t = pointingVector(position, target);
		t.setMag(500);
		drawVectorAt(position, t);

		// draw origin
		PVector o = Zaxis.cross(normale);
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
	public void drawLight(){}

	private void pushBaseMatrix(){
		pushMatrix();
		translate(position.x, position.y, position.z);
		orientBase();
	}
	private void popBaseMatrix(){
		popMatrix();
	}

	public void setTarget(PVector target){
		this.target = target;

		PVector n = normale.copy();
		PVector t = pointingVector(position, target);
		PVector o = Zaxis.cross(normale);
		PVector p = o.cross(normale);
		PVector tp = new PVector(PVector.dot(p, t), PVector.dot(o, t));

		PVector h = VU.rotateAround(p, pan, n);
		PVector tt = new PVector(PVector.dot(h, t), PVector.dot(normale, t));

		pan = HALF_PI + atan2(tp.x, -tp.y);
		tilt = PI + atan2(tt.x, -tt.y);

	}

	private void orientBase(){
		rotateY(atan2(normale.x, normale.z));
		rotateX(asin(-normale.y));

		// LIMITATION : this works if normale.z == position.z
		rotateZ(HALF_PI + atan2(normale.x, normale.z));
	}
}

PVector pointingVector(PVector origin, PVector target){
	return PVector.sub(target, origin);
}

void drawVectorAt(PVector position, PVector v){
	line(position.x,position.y,position.z, position.x+v.x,position.y+v.y,position.z+v.z);
}