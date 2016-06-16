public class Lyre{
	private PVector position; 	// position of the center of beam
	private float orientation;	// rotation on the normale
	private PVector direction;	// beam direction

	private float pan, tilt;   	// the data to be converted in dmx

	public Lyre(PVector position, float orientation){

		this.position = position;
		this.orientation = orientation;

		this.pan = 0;
		this.tilt = 0;
	}


	public void draw(){ draw(false, false);}

	// draw lyre object using processing tools
	public void draw(Boolean selected, Boolean focused){
		if(selected){
			fill(200,10,0);
		}else{
			fill(10,10,15);
		}
		if(focused){
			stroke(0,200,200);
		}else{
			stroke(40);
		}


		pushBaseMatrix();

		pushMatrix();

		// main body
		translate(0,0,-30);
		box(30,30,10);

		// arms
		pushMatrix();
		rotateZ(-pan);

		//line(0,0,0, 50,0,0);
		translate(0,-15,15);
		box(10,5, 30);
		translate(0,30,0);
		box(10,5, 30);

		// beam
		pushMatrix();
		translate(0, -15, 15);
		rotateY(tilt-HALF_PI);

		ellipse(0, 0, 25, 25);
		stroke(255);
		//line(0,0,0, 0,0,500);

		popMatrix();

		popMatrix();

		popMatrix();

		// mark the way up
		stroke(255, 127, 255);
		//line(0,0,0,100,0,0);

		popBaseMatrix();
	}

	// draw vectors from actual calculation, without Processing's space manipulation
	public void drawVectors(){
		PVector x = VU.Xaxis.copy();
		PVector front = x.rotate(orientation);
		PVector tiltPlan = VU.rotateAround(front, HALF_PI + pan, VU.Zaxis);
		PVector beamDir = VU.rotateAround(front, pan, VU.Zaxis);
		beamDir = VU.rotateAround(beamDir, tilt, tiltPlan);
		stroke(255,0,0);
		drawVectorAt(position, front.setMag(100));	
		stroke(0,0,255);
		drawVectorAt(position, tiltPlan.setMag(100));
		stroke(200,0,200, 60);
		drawVectorAt(position, direction);
		stroke(255,0,255);
		drawVectorAt(position, beamDir.setMag(100));
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
	public void setDirection(PVector target){
		PVector X = VU.Xaxis.copy();
		direction = VU.pointingVector(position, target);
		PVector relDirection = direction.copy().rotate(-orientation);

		pan = atan2(relDirection.y, relDirection.x);
		tilt = asin((position.z-target.z)/ PVector.dist(position, target));
	}

	// orient the base 
	private void orientBase(){
		rotateZ(orientation);
		rotateY(PI);
	}
}