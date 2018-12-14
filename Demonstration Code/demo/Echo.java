// This example is from _Java Examples in a Nutshell_. (http://www.oreilly.com)
// Copyright (c) 1997 by David Flanagan
// This example is provided WITHOUT ANY WARRANTY either expressed or implied.
// You may study, use, modify, and distribute it for non-commercial purposes.
// For any commercial use, see http://www.davidflanagan.com/javaexamples

/**
 * This program prints out all its command-line arguments.
 **/
public class Echo {
  public static void main(String[] args) {
    int i = 0;                         // Initialize the loop variable
    while(i < args.length) {           // Loop until we reach end of array
      System.out.println(args[i] + " "); // Print each argument out
      i++;                             // Increment the loop variable
    }
    //System.out.println();              // Terminate the line
  }
}
