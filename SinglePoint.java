import java.util.List;
import java.util.ArrayList;
import processing.core.PVector;
import processing.core.PApplet;

public class SinglePoint implements Controller{

	Ery p;

	public SinglePoint(Ery p){this.p = p;}

	public void forward(){}

	public List<PVector> request(int points){
		PVector point = new PVector(p.pad.sliders.get("x")*p.RADIUS*1.2f, p.pad.sliders.get("y")*p.RADIUS*1.2f);
		List<PVector> l = new ArrayList<PVector>(points);
		for (int i = 0; i < points ; i++) {
			l.add(point);
		}

		return l;
	}
}