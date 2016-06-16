import org.gamecontrolplus.*;
import net.java.games.input.*;
import processing.core.PApplet;

public class XBOXController {

	private static final String XBOX_CONTROLLER_NAME = "XBOX 360 For Windows (Controller)";
	private static final String XBOX_CONTROLLER_NAME_ALT = "Microsoft X-Box 360 pad";

	private static final int INPUT_TIMEOUT = 100;

	public HashMap<String, Boolean> buttons;
	public HashMap<String, Float> sliders;

	private ControlIO C;
	private ControlDevice pad;
	private PApplet parent;

	public XBOXController (PApplet parent) {
		buttons = new HashMap<String, Boolean>();
		sliders = new HashMap<String, Float>();
		try{
			C = ControlIO.getInstance(parent);
			pad = C.getDevice(XBOX_CONTROLLER_NAME);
			println("XBOX Controller found");
		}catch(Exception e){
			try{
				pad = C.getDevice(XBOX_CONTROLLER_NAME_ALT);
				println("XBOX Controller found");
			}catch(Exception a){
				C.dispose();
				C = null;
				println("e: "+a);
				pad = null;
				
			}
		}
	}

	public void update(){
		if(pad != null){
			for(int i = pad.getNumberOfButtons() - 1; i >= 0 ; i --){
				if(i == 11){
					switch((int) pad.getButton(i).getValue()){
						case 2:
						setButton("north");
						unsetButton("east");
						unsetButton("south");
						unsetButton("west");
						break;
						case 4:
						setButton("east");
						unsetButton("north");
						unsetButton("south");
						unsetButton("west");
						break;
						case 6:
						setButton("south");
						unsetButton("north");
						unsetButton("east");
						unsetButton("west");
						break;
						case 8:
						setButton("west");
						unsetButton("north");
						unsetButton("east");
						unsetButton("south");
						break;
						default:
						unsetButton("north");
						unsetButton("east");
						unsetButton("south");
						unsetButton("west");
					}
				}else if(pad.getButton(i).getValue() == 8){
					setButton("button."+ i);
				}else if(pad.getButton(i).getValue() == 0){
					unsetButton("button."+ i);
				}
			}

			for(int i = pad.getNumberOfSliders() - 1; i >= 0 ; i --){
				sliders.put("" + pad.getSlider(i).getName(), pad.getSlider(i).getValue());
			}
		}
	}

	void reset(){
		for(String b : buttons.keySet()){
			if(!b.contains("hold"))
				buttons.put(b, false);
		}
	}

	void setButton(String input){
		if(!getButton(input+".hold")){
			buttons.put(input+".press", true);
			buttons.put(input+".hold", true);
		}
	}
	Boolean getButton(String input){
		if(buttons.containsKey(input)){
			return buttons.get(input);
		}else{
			return false;
		}
	}

	void unsetButton(String input){
		buttons.put(input+".release", true);
		buttons.put(input+".hold", false);
	}

}