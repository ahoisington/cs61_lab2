/*
  Acacia and Elisabeth

  listen for user input
 */
import java.io.*;
import java.util.Scanner;


public class listen {

	public static void main(String[] args) {

	        BufferedReader buffR = null;

	        try {

	            // Refer to this http://www.mkyong.com/java/how-to-read-input-from-console-java/
	            // for JDK 1.6, please use java.io.Console class to read system input.
	            buffR = new BufferedReader(new InputStreamReader(System.in));

	            System.out.println();


	            while (true) {

	                System.out.print("Enter something : ");
	                String input = buffR.readLine();

	                if ("-q".equals(input)) {
	                    System.out.println("Exit!");
	                    System.exit(0);
	                }

	                System.out.println("input : " + input);
	                System.out.println("-----------\n");
	            }







	        } catch (IOException e) {
	            e.printStackTrace();
	        } finally {
	            if (buffR != null) {
	                try {
	                    buffR.close();
	                } catch (IOException e) {
	                    e.printStackTrace();
	                }
	            }
	        }

	    }













	}





}


