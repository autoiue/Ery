import java.util.List;
import java.util.ArrayList;
import processing.core.PVector;
import processing.core.PApplet;

public class Haystack implements Controller{

	Ery p;
	int size;
	boolean parity;
	List<PVector> pointList;

	public Haystack(Ery p, int size){
		this.p = p; 
		this.size = size; 
		pointList = new ArrayList<PVector>(size);

		for(int i = 0; i < size; i ++){
			pointList.add(new PVector(0,0,0));
		}
	}

	public void forward(){
		for(int i = parity ? 0 : 1; i < size; i += 2){
			PVector v = new PVector(p.random(0, p.RADIUS),0, p.random(0, p.HEIGHT));
			v.rotate(p.random(0, p.TWO_PI));
			pointList.set(i,v);
		}
		parity = !parity;
	}

	public List<PVector> request(int points){
		return pointList;
	}
}