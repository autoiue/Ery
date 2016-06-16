import java.util.List;
import processing.core.PVector;

public interface Controller {
	public List<PVector> request(int pointsNumber);
	public void forward();
}