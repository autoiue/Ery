import java.util.List;
import java.util.ArrayList;
import processing.core.PVector;
import processing.core.PApplet;

public class SinglePoint implements Controller{

	Ery p;

	public SinglePoint(Ery p){this.p = p;}

	public void forward(){}

	public List<PVector> request(int points){
		float z = (float)1000.0 * (1+p.pad.sliders.get("rz"));
		PVector point = new PVector(p.pad.sliders.get("x")*p.RADIUS*2.0f, p.pad.sliders.get("y")*p.RADIUS*2.0f, z);
		List<PVector> l = new ArrayList<PVector>(points);
		for (int i = 0; i < points ; i++) {
			l.add(point);
		}

		return l;
	}
}