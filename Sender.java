import java.io.*;
import java.net.*;
import java.util.*;
 
public class Sender {

    InetAddress address;
    DatagramSocket socket;
    Ery e;

    public Sender(Ery e) throws IOException {
        this.e = e;
        socket = new DatagramSocket() ;
        address = InetAddress.getByName("227.16.20.1");
    }

    public void send(Ery.Lyre[] lyres){
        try{
            byte[] buf = new byte[1024];
            String d = "";
            int index = 0;
            for(Ery.Lyre l : lyres){
                int[] dmx = l.getDMX();
                d += "r:ERY."+index+".pan:"+dmx[0]+"\n";
                d += "r:ERY."+index+".panf:"+dmx[1]+"\n";
                d += "r:ERY."+index+".tilt:"+dmx[2]+"\n";
                d += "r:ERY."+index+".tiltf:"+dmx[3]+"\n";
                d += "r:ERY."+index+".zoom:"+dmx[4]+"\n";
                d += "r:ERY."+index+".zoomf:"+dmx[5]+"\n";
                index ++;
            }
            buf = d.getBytes();
            DatagramPacket packet = new DatagramPacket(buf, buf.length, address, 1703);
            socket.send(packet);
        }catch (Exception e) {}
    }
}