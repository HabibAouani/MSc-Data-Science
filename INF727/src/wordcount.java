import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class wordcount {
	
	private static final Set<String> VALUES = new HashSet<String>();

	public static void main(String[] args) throws IOException {

		long startTime = System.currentTimeMillis();

		// Read the file path
		FileReader in = new FileReader("/Users/maelfabien/CC-MAIN-20170322212949-00140-ip-10-233-31-227.ec2.internal.warc.wet");
		
		// Reads text from input, buffering characters to provide  efficient reading of characters, arrays, and lines.
		BufferedReader br = new BufferedReader(in);
	
		// hm will contain the word and the count
		Map<String, Integer> hm = new HashMap<String, Integer>();

		String line;
		
		// Loop while there is a next line
		while ((line = br.readLine()) != null) {
			
			// Create an array of single words, replace line jumps and spaces
			String[] words = line.replace("\n", " ").split(" ");

			// Loop on the length of the whole array
			for (int i = 0; i < words.length; i++) {
				
				// Set words to lower case
				String word_lowerCased = words[i].toLowerCase();
				
				// Create a boolean. If already contains word, True. Else, False.
				boolean contains = VALUES.contains(word_lowerCased);
				
				if (!contains){
					// If wrong, create a new key and set 1
					if (!hm.containsKey(word_lowerCased)) {
						hm.put(word_lowerCased, 1);
					} else {
					// Else increment count by 1
						int cont = hm.get(word_lowerCased);
						hm.put(word_lowerCased, cont + 1);
					}
				}
			}
		}
		in.close();

		System.out.println("--- Sorted list ---");
		List<Map.Entry<String, Integer>> list = new ArrayList<Map.Entry<String, Integer>>(hm.entrySet());
		long startTime2 = System.currentTimeMillis();
		// Sort and apply the Double Comparator class above
		Collections.sort(list, new DoubleComparator<String, Integer>());
		long endTime2  = System.currentTimeMillis();
		
		// Display results while i < list.size()
		for (int i = 0; i < 50; i++){ 
			System.out.println(list.get(i).getKey() + " " + list.get(i).getValue());
		}
		long endTime   = System.currentTimeMillis();
		long totalTime = endTime - startTime;
		long totalTime2 = endTime2 - startTime2;
		System.out.println(" ");
		System.out.println("Total computation time is " + totalTime + "ms");
		System.out.println("Computation time for sorting is " + totalTime2 + "ms");
		

	}

}

	// Display results
	class DoubleComparator<K extends Comparable<? super K>, V extends Comparable<? super V>> implements Comparator<Map.Entry<K, V>> {
		
		// Compare two map entries
		public int compare(Map.Entry<K, V> a, Map.Entry<K, V> b) {
			
			// First, we sort by Value
			int cmp1 = b.getValue().compareTo(a.getValue());
			if (cmp1 != 0) {
				return cmp1;
			} else {
				// If values are equal, we sort by keys
				return a.getKey().compareTo(b.getKey());
			}
	}
}