import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.TimeUnit;

import org.omg.CORBA.portable.InputStream;

public class MASTER {
    
    private static void readOutput(Process p) throws IOException {
        
        System.out.println("=== Standard output ===");
        
        java.io.InputStream is = p.getInputStream();
        InputStreamReader isr = new InputStreamReader(is, StandardCharsets.UTF_8);
        BufferedReader br = new BufferedReader(isr);

        String line;
        while ((line = br.readLine()) != null ) {
            System.out.println(line);
        }
    }
    
    private static void readError(Process p) throws IOException {
        
        System.out.println("=== Error output ===");
        
        java.io.InputStream is2 = p.getErrorStream();
        InputStreamReader isr = new InputStreamReader(is2, StandardCharsets.UTF_8);
        BufferedReader br = new BufferedReader(isr);

        String line;
        while ((line = br.readLine()) != null ) {
            System.out.println(line);
        }
        
    }
    
    public static void main(String[] args) throws IOException, InterruptedException {
        
        ProcessBuilder pb = new ProcessBuilder("java", "-jar", "/Users/maelfabien/eclipse-workspace/SLAVE/slave.jar").inheritIO();
        Process p = pb.start();
        boolean b = p.waitFor(3, TimeUnit.SECONDS);
        if (b==false) {
        	System.out.println("Timeout error");
        	p.destroy();
        } else {
        	readOutput(p);
        	readError(p);
        }
    }

}