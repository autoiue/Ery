import java.util.List;
import java.util.ArrayList;
import processing.core.PVector;
import processing.core.PApplet;

public class FoyersDiv implements Controller{

	Ery p;
	int reflects = 8;
	int mod = 1;

	public FoyersDiv(Ery p){this.p = p;}

	public void forward(){}

	public List<PVector> request(int points){
		if(p.pad.getButton("button.3.hold")){ reflects ++; }
		if(p.pad.getButton("button.2.hold")){ reflects --; }
		reflects = p.max(1, p.min(points, reflects));
		if(p.pad.getButton("button.1.hold")){ mod ++; }
		if(p.pad.getButton("button.0.hold")){ mod --; }
		mod = p.max(1, p.min(points, mod));

		PVector point = new PVector(p.pad.sliders.get("x"), p.pad.sliders.get("y"));
		point.mult(p.RADIUS - 100);
		List<PVector> l = new ArrayList<PVector>(points);
		for (int i = 0; i < points ; i++) {
			l.add(Ery.SU.Circle(point.mag(), reflects, p.round(i/mod)).rotate(point.heading()));
		}

		return l;
	}
}