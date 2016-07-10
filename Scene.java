import java.util.List;
import java.util.ArrayList;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;

import processing.core.PVector;
import processing.core.PApplet;

public class Scene implements Controller{

	Ery p;
	int size, index;
	ArrayList<ArrayList<PVector>> scenes;

	public Scene(Ery p, int size){
		this.p = p; 
		this.size = size; 
		scenes = new ArrayList<ArrayList<PVector>>(10);

		try
		{
			FileInputStream fileIn = new FileInputStream("data/scenes");
			ObjectInputStream in = new ObjectInputStream(fileIn);
			scenes = (ArrayList<ArrayList<PVector>>) in.readObject();
			in.close();
			fileIn.close();

		}catch(Exception e){	

			for(int j = 0; j < 10; j++){
				ArrayList<PVector> pointList = new ArrayList<PVector>(size);
				for(int i = 0; i < size; i ++)
					pointList.add(new PVector(0,0,0));
				scenes.add(new ArrayList<PVector>(pointList));
			}
		}

	}

	public void forward(){

	}

	public void save(){
		try{
			FileOutputStream fileOut = new FileOutputStream("data/scenes");
			ObjectOutputStream out = new ObjectOutputStream(fileOut);
			out.writeObject(scenes);
			out.close();
			fileOut.close();
		}catch(Exception i){
			i.printStackTrace();
		}
	}

	public List<PVector> request(int points){
		if(p.pad.getButton("button.3.press")){ index ++; }
		if(p.pad.getButton("button.2.press")){ index --; }

		if(index == -1) index = 9;
		if(index == 10) index = 0;

		ArrayList<PVector> pointList = scenes.get(index);

		if(p.selector == 0){
			PVector change = new PVector(p.pad.sliders.get("x"), p.pad.sliders.get("y"), Math.max(0,p.pad.sliders.get("rz")));
			change.mult(10);
			if(change.mag() > 2){
				PVector point = pointList.get(p.selectedLyre);
				point.add(change);
				if(p.pad.getButton("button.5.press")) point.z = 0;
				pointList.set(p.selectedLyre, point);
			}
		}
		return pointList;
	}
}