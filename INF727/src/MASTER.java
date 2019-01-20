import java.io.IOException;

public class MASTER {
	public static void main(String[] ags) throws IOException {
	ProcessBuilder pb = new ProcessBuilder("ls", "-al", "/tmp");
	Process p = pb.start();
	}
}

