
import peasy.*;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Set;
import java.util.List;

XBOXController pad;
PeasyCam cam;
Map<String, CameraState> camViews;
Map<String, Controller> controllers;
PImage bg;
Sender s;

int selector = 2;

String selectedController = "";
String focusedController = "";

int selectedLyre = 0;
int focusedLyre = 0;

String selectedZoomMode = "";
String focusedZoomMode = "";

final int NB_LYRE = 32;
final float RADIUS = 750;
final int HEIGHT = 350;

int _width, _height;

boolean SHOW_SCENE = true;
boolean SHOW_VECTORS = true;
boolean SHOW_INFO = true;
boolean SHOW_HUD = true;
boolean SHOW_ORIGIN = true;
boolean SHOW_BEAM = false;
boolean SHOW_BG = false;

Lyre l[] =  new Lyre[NB_LYRE];

void setup(){
	size(3000,1600, P3D);
	//noSmooth();
	textFont(loadFont("RobotoMono-Regular-24.vlw"), 24);
	bg = loadImage("fondgiflyres2.png");
	
	// peasycam bad window size workaround
	_width = width;
	_height = height;

	surface.setResizable(true);

	frameRate(60);

	pad = new XBOXController(this);

	cam = new PeasyCam(this, 0, 0, HEIGHT/2, 2*RADIUS+200);
	camViews = new LinkedHashMap<String,CameraState>();

	cam.rotateX(-HALF_PI + radians(25));
	camViews.put("default", cam.getState());

	cam.setSuppressRollRotationMode();
	cam.setResetOnDoubleClick(false);
	cam.setMinimumDistance(0);
	cam.setMaximumDistance(5000);

	for(int i = 0; i < NB_LYRE; i ++){
		PVector pos = SU.Circle(RADIUS, NB_LYRE, i);
		pos.z = HEIGHT;										// 3PI == 540°; 1.5PI == 270°
		l[i] = new Lyre(pos, -HALF_PI + TWO_PI/NB_LYRE * i, PI+TWO_PI, HALF_PI+PI);
	}

	//l[0] = new Lyre(new PVector(0,0,0), random(0, TWO_PI));
	//l[0] = new Lyre(new PVector(0,0,0), HALF_PI);

	controllers = new LinkedHashMap<String, Controller>();
	controllers.put("SinglePoint", new SinglePoint(this));
	controllers.put("Circle", new Circle(this));
	controllers.put("Foyers", new Foyers(this));
	controllers.put("FoyersDiv", new FoyersDiv(this));
	controllers.put("FoyersPos", new FoyersPos(this));
	controllers.put("Haystack", new Haystack(this, NB_LYRE));

	selectedController = "SinglePoint";
	focusedController = "SinglePoint";
	
	try{
		s = new Sender(this);
	}catch (Exception e) {
		
	}
}

void draw(){
	s.send();
	// if(SHOW_BG){
	// 	background(bg);
	// }else{
		background(0,20, 60);
	//}
	pad.update();

	selectThings();

	List<PVector> targets = controllers.get(selectedController).request(NB_LYRE);
	for(int i = 0; i < NB_LYRE; i ++){
		l[i].setDirection(targets.get(i));
	}

	pushMatrix();
	if(SHOW_SCENE) drawScene();
	if(SHOW_SCENE) drawTargets(targets);
	if(SHOW_VECTORS) drawVectors();
	if(SHOW_BEAM) drawBeams();
	if(SHOW_ORIGIN) drawAxes();
	if(SHOW_INFO)  drawInfo();
	popMatrix();

	
	if(SHOW_HUD) drawHUD();

	pad.reset();
}

void drawAxes(){
	stroke(255,0,0);
	drawVectorAt(VU.Origin, VU.Xaxis.setMag(100));
	stroke(0,255,0);
	drawVectorAt(VU.Origin, VU.Yaxis.setMag(100));
	stroke(0,0,255);
	drawVectorAt(VU.Origin, VU.Zaxis.setMag(100));
}

void drawScene(){
	for(int i = 0; i < NB_LYRE; i ++){
		if(selector == 0){
			l[i].draw(selectedLyre == i, focusedLyre == i);
		}else{
			l[i].draw();
		}
	}
	fill(100, 80);
	stroke(255);
	ellipse(0, 0, 2*RADIUS, 2*RADIUS);
}

void drawVectors(){
	for(int i = 0; i < NB_LYRE; i ++){
		l[i].drawVectors();
	}
}

void drawBeams(){
	for(int i = 0; i < NB_LYRE; i ++){
		l[i].drawBeam();
	}
}

void drawTargets(List<PVector> targets){
	stroke(255,0,0);
	for(int i = 0; i < targets.size(); i++){
		PVector target = targets.get(i);
		line(target.x - 10, target.y, target.z, target.x + 10, target.y, target.z);
		line(target.x, target.y - 10, target.z, target.x, target.y + 10, target.z);
		line(target.x, target.y, target.z - 10, target.x, target.y, target.z + 10);
	}
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
	textSize(24);
	textAlign(LEFT, TOP);

	fill(0,0,0, 160);
	//translate((_width-width), (_height-height)); // peasycam bad window size workaround

	rect(0, height-200, width, 200);

	drawControllerList();

	fill(255);
	text(Math.round(frameRate) +" FPS", 5,height-195);
	text(focusedLyre, 5,height-175);

	cam.endHUD();
}

void drawControllerList(){
	int offset = 10;

	for(String n : controllers.keySet()){
		if(n.equals(selectedController)){
			fill(0,100,100, 160);
		}else{
			fill(0,160);
		}
		if(n.equals(focusedController)){
			stroke(0,200,200);
		}else{
			noStroke();
		}
		rect(width -390, offset, 400, 40);
		fill(255);
		text(n, width - 370, offset + 10);
		offset +=50;
	}
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
	}else if (key == 'o') {
		SHOW_SCENE = !SHOW_SCENE;
	}else if (key == 'h') {
		SHOW_HUD = !SHOW_HUD;
	}else if (key == 'i') {
		SHOW_BEAM = !SHOW_BEAM;
	}else if (key == 'p') {
		SHOW_BG = !SHOW_BG;
	}else if (key == ' ') {
		controllers.get(selectedController).forward();
	}
} 

void selectThings(){
	if(pad.getButton("east.press")) selector ++;
	if(pad.getButton("west.press")) selector --;
	if(selector == -1) selector = 2;
	if(selector ==  3) selector = 0;

	if(selector == 0){	// SELECT LYRES
		if(pad.getButton("south.press")) focusedLyre ++;
		if(pad.getButton("north.press")) focusedLyre --;
	if(focusedLyre == -1) focusedLyre = NB_LYRE-1;
	if(focusedLyre ==  NB_LYRE) focusedLyre = 0;
		if(pad.getButton("button.7.press")) selectedLyre = focusedLyre;
	}else if(selector == 1){	// SELECT ZOOMMODE
	}else if(selector == 2){	// SELECT COnTROLLERS
		if(pad.getButton("south.press")) focusedController = selectNext(focusedController, controllers.keySet());
		if(pad.getButton("north.press")) focusedController = selectPrevious(focusedController, controllers.keySet());
		if(pad.getButton("button.7.press")) selectedController = focusedController;
	}
}

String selectNext(String current, Set<String> set){
	String first = null;
	boolean ret = false;

	for(String c : set){
		if(first == null){
			first = c;
		}
		if(ret) return c;
		if(current.equals(c)) ret = true;
	}
	return first;
}
String selectPrevious(String current, Set<String> set){
	String last = null;

	for(String c : set){
		if(current.equals(c) && last != null) return last;
		last = c;
	}
	return last;
}

void drawVectorAt(PVector position, PVector v){
	line(position.x,position.y,position.z, position.x+v.x,position.y+v.y,position.z+v.z);
}