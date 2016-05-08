import peasy.*;
import java.util.HashMap;

PeasyCam cam;
HashMap<String, CameraState> camViews;

final int NB_LYRE = 40;
final float RADIUS = 400;
final int HEIGHT = 500;

int _width, _height;

boolean SHOW_SCENE = true;
boolean SHOW_VECTORS = false;
boolean SHOW_INFO = true;
boolean SHOW_HUD = true;
boolean SHOW_ORIGIN = false;
boolean SHOW_LIGHTS = false;

Lyre l[] =  new Lyre[NB_LYRE];

void setup(){
	size(3200,1800, P3D);
	//noSmooth();
	textFont(loadFont("RobotoMono-Regular-24.vlw"), 24);
	
	// peasycam bad window size workaround
	_width = width;
	_height = height;

	surface.setResizable(true);

	frameRate(60);

	cam = new PeasyCam(this, 0, 0, HEIGHT/2, 2*RADIUS+200);
	camViews = new HashMap<String,CameraState>();

	cam.rotateX(-HALF_PI + radians(25));
	camViews.put("default", cam.getState());

	cam.setSuppressRollRotationMode();
	cam.setResetOnDoubleClick(false);
	cam.setMinimumDistance(0);
	cam.setMaximumDistance(5000);

	for(int i = 0; i < NB_LYRE; i ++){
		PVector pos = SU.Circle(RADIUS, NB_LYRE, i);
		pos.z = HEIGHT;
		l[i] = new Lyre(pos, 0f, 0f, PI/16.0f, HALF_PI);
	}

}

void draw(){
	background(0,20, 60);

	int targetX = mouseX - width/2;
	int targetY = mouseY - height/2;

	PVector target = new PVector(targetX, targetY, 0);
	for(int i = 0; i < NB_LYRE; i ++){
		l[i].setTarget(target);
	}

	pushMatrix();
	if(SHOW_LIGHTS) drawLights();
	if(SHOW_SCENE) drawScene();
	if(SHOW_INFO)  drawInfo();
	if(SHOW_SCENE) drawTargets(target);
	if(SHOW_VECTORS) drawVectors();
	if(SHOW_ORIGIN) drawAxes();
	popMatrix();

	
	if(SHOW_HUD) drawHUD();
}

void drawAxes(){
	stroke(255,0,0);
	line(0,0,0, 100,0,0);
	stroke(0,255,0);
	line(0,0,0, 0,100,0);
	stroke(0,0,255);
	line(0,0,0, 0,0,100);
}

void drawScene(){
	stroke(255);
	fill(100, 80);
	ellipse(0, 0, 2*RADIUS, 2*RADIUS);
	for(int i = 0; i < NB_LYRE; i ++){
		l[i].draw();
	}
}

void drawVectors(){
	for(int i = 0; i < NB_LYRE; i ++){
		l[i].drawVectors();
	}
}

void drawLights(){
	//lights();
	for(int i = 0; i < NB_LYRE; i += NB_LYRE/8){
		l[i].drawLight();
	}
}

void drawTargets(PVector target){
	stroke(255,0,0);
	line(target.x - 10, target.y, target.z, target.x + 10, target.y, target.z);
	line(target.x, target.y - 10, target.z, target.x, target.y + 10, target.z);
	line(target.x, target.y, target.z - 10, target.x, target.y, target.z + 10);
}

void drawInfo(){
	textSize(10);
	textAlign(CENTER,CENTER);
	float[] r = cam.getRotations();
	for(int i = 0; i < NB_LYRE; i ++){
		l[i].drawInfo(r,i);
	}
}

void drawHUD(){
	cam.beginHUD();
	noStroke();
	fill(0,0,0, 160);
	//translate((_width-width), (_height-height)); // peasycam bad window size workaround

	rect(0, height-200, width, 200);

	fill(255);

	textSize(24);
	textAlign(LEFT, TOP);
	text(Math.round(frameRate) +" FPS", 5,height-195);

	cam.endHUD();
}

void keyReleased() {
	if(key == 'r'){
		cam.setState(camViews.get("default"), 300);
	}else if (key == 't') {
		SHOW_INFO = !SHOW_INFO;
	}else if (key == 'y') {
		SHOW_ORIGIN = !SHOW_ORIGIN;
	}else if (key == 'u') {
		SHOW_VECTORS = !SHOW_VECTORS;
	}else if (key == 'i') {
		SHOW_LIGHTS = !SHOW_LIGHTS;
	}else if (key == 'o') {
		SHOW_SCENE = !SHOW_SCENE;
	}
}

void drawVectorAt(PVector position, PVector v){
	line(position.x,position.y,position.z, position.x+v.x,position.y+v.y,position.z+v.z);
}