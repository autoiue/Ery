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
        address = InetAddress.getByName("224.0.0.1");
    }

    public void send(){
        try{
            byte[] buf = new byte[256];
            String dString = "";
            buf = dString.getBytes();
            DatagramPacket packet = new DatagramPacket(buf, buf.length, address, 1703);
            socket.send(packet);
        }catch (Exception e) {}
    }
}