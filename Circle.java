import java.util.List;
import java.util.ArrayList;
import processing.core.PVector;
import processing.core.PApplet;

public class Circle implements Controller{

	Ery p;
	float radius;
	float orientation = 0;

	public Circle(Ery p){this.p = p; radius = p.RADIUS/2;}

	public void forward(){}

	public List<PVector> request(int points){
		if(p.pad.getButton("button.3.hold")){ radius += 4; }
		if(p.pad.getButton("button.2.hold")){ radius -= 4; }
		radius = p.max(1, p.min(p.RADIUS*3, radius));
		if(p.pad.getButton("button.1.hold")){ orientation += p.QUARTER_PI/24; }
		if(p.pad.getButton("button.0.hold")){ orientation -= p.QUARTER_PI/24; }
		List<PVector> pointList = new ArrayList<PVector>(points);
		for(int i = 0; i < points; i ++){
			pointList.add(Ery.SU.Circle(radius, points, i).rotate(orientation));
		}
		return pointList;
	}
}