import java.util.List;
import java.util.ArrayList;
import processing.core.PVector;
import processing.core.PApplet;

public class Foyers implements Controller{

	Ery p;
	int reflects = 8;
	int mod = 1;

	public Foyers(Ery p){this.p = p;}

	public void forward(){}

	public List<PVector> request(int points){
		if(p.pad.getButton("button.3.hold")){ reflects ++; }
		if(p.pad.getButton("button.2.hold")){ reflects --; }
		reflects = p.max(1, p.min(points, reflects));
		if(p.pad.getButton("button.1.press")){ mod ++; }
		if(p.pad.getButton("button.0.press")){ mod --; }
		mod = p.max(reflects, p.min(points, mod));

		PVector point = new PVector(p.pad.sliders.get("x"), p.pad.sliders.get("y"));
		float z = (float)800.0 * (1+p.pad.sliders.get("rz"));
		point.mult(p.RADIUS - 100);
		List<PVector> l = new ArrayList<PVector>(points);
		for (int i = 0; i < points ; i++) {
			l.add(Ery.SU.Circle(point.mag(), reflects, i%mod, z).rotate(point.heading()));
		}

		return l;
	}
}