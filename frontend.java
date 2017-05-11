/*
  Acacia and Elisabeth

  connecting to a MySQL database and executing a query
 */
import java.sql.*;
import java.io.*;
import java.util.*;

public class frontend {
    public static final String SERVER   = "jdbc:mysql://sunapee.cs.dartmouth.edu/";
    public static final String USERNAME = "epills";
    public static final String PASSWORD = "happyKale44";
    public static final String DATABASE = "epills_db";


    public static void main(String[] args) {
		Connection con = null;
		Statement stmt = null;
		ResultSet res  = null;
		int numColumns = 0;
		String query = "";

		// CONNECT TO DB
		try {
		    // LOAD MYSQL DRIVER
		    Class.forName("com.mysql.jdbc.Driver").newInstance();

		    // INIT CONNECTION
		    con = DriverManager.getConnection(SERVER+DATABASE, USERNAME, PASSWORD);
		    System.out.println("Connection established.");

		    //TAKE IN USER INPUT
	        BufferedReader buffReader = null;
	        try {
	            buffReader = new BufferedReader(new InputStreamReader(System.in));
	            while (true) {

	                System.out.print("Enter your request: "); 	// ASK USER FOR INPUT
	                String input = buffReader.readLine();

	                if ("q".equals(input)) {	// USER WANTS TO EXIT PROGRAM
	                    System.out.println("Exit!");
	                    buffReader.close();
	               		break; //leave buffReader loop. then prog will close connection to MySQL server
	                } 

	               	String[] request = input.split(" ");
	               	
	               	String q = "SELECT MAX(person_id) FROM person;";

	               	if (request[0].equals("register")){
	               		String[] req_to_check = Arrays.copyOfRange(request,2,request.length);
	               		String person_job = request[1];
	               		if (person_job.equals("author") && author_register(req_to_check)){
	               			//run register sql query to insert
	               			query = "SELECT MAX(person_id) FROM person;";
	               			stmt = con.createStatement();
	               			res = stmt.executeQuery(query);

							if (res.next()){
								System.out.println(res.getObject(1));
							}

	               			query = "INSERT INTO person_id (`fname`,`lname`,`person_job`) VALUES (" + request[2] + ", "+ request[3] +", 'author');";

	               		} else if (person_job.equals("reviewer") && reviewer_register(req_to_check)){
	               			//run register sql query to insert

	               		} else if (person_job.equals("editor") && editor_register(req_to_check)){
	               			//run register sql query to insert
	               		} else {
	               			System.err.println("Input error: Make sure your request to register follows the correct format. Read documentation or input -h or --help for guidance.");
	               			System.exit(1);
	               		}
	               	}

	               	// we expect: login <person_id>
	               	else if (request[0].equals("login")){

	               		String person_id = request[1];
	               		String person_job="";

	               		// make sure person_id is an integer
	               		if (!isInteger(person_id)) {

	               			System.err.println("Invalid ID.");
							System.exit(1);
	               		
	               		}

               			// retrieve information about this person
               			query = ("SELECT * FROM person WHERE person_id=" + person_id + ";");
               			stmt = con.createStatement();
               			res = stmt.executeQuery(query);

						if (res.next()){

							person_job = res.getString(4);

							// change this greeting?
							System.out.println("\nWelcome to your " + person_job + " page.\n");
							System.out.println(res.getString(2) +  " " + res.getString(3));

						} else {

							System.err.println("Invalid ID. ha");
							System.exit(1);

						}


	               		if (person_job.equals("author")){

	               			// retrieve author specific information
							query = ("SELECT * FROM author WHERE person_id=" + person_id + ";");		           			
							stmt = con.createStatement();
		           			res = stmt.executeQuery(query);

		           			if (res.next()){
		           				System.out.println(res.getString(3) + "\n"); // mailing address
		           			}

	               			// retrieve author's manuscript information
							query = ("SELECT * FROM LeadAuthorManuscripts WHERE person_id=" + person_id + " ORDER BY manuscript_id ASC;");		           			
							stmt = con.createStatement();
		           			res = stmt.executeQuery(query);

		           			// NEED TO GROUP BY # SUBMITTED ETC ETC????? ASK ACACIA
		       			    while(res.next()) { 		
	           			    	System.out.format("#%-5s", res.getObject(6)); // manuscript_id

	           					for(int i = 7; i <= 9; i++) {
	           					    System.out.format("%-30s", res.getObject(i)); // title, man_status, date_submitted
	           					}

	           					System.out.println("");
	           			    }

	           			    // NOW THAT WE'RE LOGGED IN, WE HAVE A COUPLE OF OPTIONS

	           			    // big while loop that prompts author for requests

	           			    // we expect: submit <title> <affiliation> <ricode> <author2> <author3> <author4> <filename>
	           			    // if (request[0].equals("submit"))
	           			    	// notes: 
	           			    		// create a brand new manuscript_id
	           			    		// additional authors are optional....

	           			    // we expect: review-reject <manuscript_id> <appropriateness> <clarity> <methodology> <contribution to field> 
	           			    // if (request[0].equals("review-reject"))
	           			    	// note: cannot reject a manuscript that doesn't belong to this reviewer

	           			    // we expect: status
	           			    // if (request[0].equals("status"))
	           			    	// return the summary info for all manuscripts associated with this author as primary


	               		} else if (person_job.equals("reviewer")){

	               			// retrieve editor's manuscript information (should these be ALL manuscripts or only the ones overseen by this editor???)
							query = ("SELECT * FROM ReviewerManuscripts WHERE reviewer_id=" + person_id + " ORDER BY man_status DESC, manuscript_id ASC;");		           			
							stmt = con.createStatement();
		           			res = stmt.executeQuery(query);

		           			System.out.println("");

	           			    while(res.next()) { 		
	           			    	System.out.format("#%-5s", res.getObject(1)); // manuscript_id

	           					for(int i = 3; i <= 5; i++) {
	           					    System.out.format("%-30s", res.getObject(i)); // title, man_status, date_submitted
	           					}

	           					System.out.println("");
	           			    }

	           			    // NOW THAT WE'RE LOGGED IN, WE HAVE A COUPLE OF OPTIONS

	           			    // big while loop that prompts reviewer for requests

	           			    // we expect: review-accept <manuscript_id> <appropriateness> <clarity> <methodology> <contribution to field>
	           			    // if (request[0].equals("review-accept"))
	           			    	// note: cannot accept a manuscript that doesn't belong to this reviewer

	           			    // we expect: review-reject <manuscript_id> <appropriateness> <clarity> <methodology> <contribution to field> 
	           			    // if (request[0].equals("review-reject"))
	           			    	// note: cannot reject a manuscript that doesn't belong to this reviewer

	           			    // doesn't explicitly say this but I think we should include it....
	           			    // we expect: status
	           			    // if (request[0].equals("status"))
	           			    	// return the summary info for all manuscripts associated with this reviewer


	               		} else if (person_job.equals("editor")){

	               			// retrieve editor's manuscript information (should these be ALL manuscripts or only the ones overseen by this editor???)
							query = ("SELECT * FROM LeadAuthorManuscripts WHERE editor_id=" + person_id + " ORDER BY man_status DESC, manuscript_id ASC;");		           			
							stmt = con.createStatement();
		           			res = stmt.executeQuery(query);

		           			System.out.println("");

	           			    while(res.next()) { 		
	           			    	System.out.format("#%-5s", res.getObject(6)); // manuscript_id

	           					for(int i = 7; i <= 9; i++) {
	           					    System.out.format("%-30s", res.getObject(i)); // title, man_status, date_submitted
	           					}

	           					System.out.println("");
	           			    }

	               		} else {
	               			// this should never happen! Just in case, though :)
	               			System.err.println("Input error: Make sure your request to login follows the correct format. Read documentation or input -h or --help for guidance.");
	               			System.exit(1);
	               		}

	               	// // we expect: resign <person_id>
	               	// } else if (request[0].equals("resign")){
	               	// 	// ONLY REVIEWERS CAN DO THIS!

	               	} else {
	               		System.err.println("Invalid request.");
	               		System.exit(1);
	               	}









				    //////////////////////////////////////////////////////////////

	                

				    // INITIALIZE QUERY STATEMENT
				    stmt = con.createStatement();

				    // QUERY DB. SAVE RESULTS
				    res = stmt.executeQuery(query);
				    // res = stmt.executeQuery(q);
				    System.out.format("\n\n\n\nQuery executed: '%s'\n\nResults:\n", query);
				    // System.out.println("results " +res.getObject(1));
				    // RESULT SET CONTAINS META DATA
				    numColumns = res.getMetaData().getColumnCount();

				    // PRINT RESULTS OF QUERY
				    for(int i = 1; i <= numColumns; i++) { 			//PRINT HEADER
						System.out.format("%-12s", res.getMetaData().getColumnName(i));
				    }
				    System.out.println("\n--------------------------------------------");
				    while(res.next()) { 		// ITERATE THROUGH RESULTS TO PRINT THEM
						for(int i = 1; i <= numColumns; i++) {
						    System.out.format("%-12s", res.getObject(i));
						}
						System.out.println("");
				    }

				    //////////////////////////////////////////////////////////////


















	            }

	        } catch (IOException e) { 
	            e.printStackTrace();
	        } finally { //close buffReader
	            if (buffReader != null) {
	                try {
	                    buffReader.close();
	                } catch (IOException e) {
	                    e.printStackTrace();
	                }
	            }
	        } //end of bufferedReader
		} catch (SQLException e ) {    // catch SQL errors
		    System.err.format("SQL Error: %s\n", e.getMessage());
		} catch (Exception e) {  		// anything else
		    e.printStackTrace();
		} finally {		// clean up
		    try {
				con.close();
				stmt.close();
				res.close();
				System.out.print("\nConnection terminated.\n");
		    } catch (Exception e) { /* ignore cleanup errors */ }
		}
    }

	/*
     *
     * author_register checks if num of args and format of register-author request is correct. returns boolean.	
     * true if format is:	 <fname> <lname> <email> <address> <affiliation>
     *
     */
    public static boolean  author_register (String[] req){
        if (req.length == 5){
            if (isEmailAddress(req[2]) && isInteger(req[4])){  //email && affiliation code
                return true;
            } else {
                System.err.println("Input error: incorrect formatting of values");
                System.exit(1); 
            }
        } else {
            System.err.println("Input error: invalid number of input vals");
            System.exit(1);
        }
        return false;
    } 

    /*
    *
    * reviewer_register checks if num of args and format of register-reviewer request is correct. returns boolean.	
    * correct format is:	 <fname> <lname> <email> <affiliationCode> <RICode1> <RICode2 (optional)> <RICode3 (optional)>
    *
    */
    public static boolean reviewer_register (String[] req){
    	if (req.length == 5){ // 1 RICode submitted
			if (isEmailAddress(req[2]) && isInteger(req[3])&& isInteger(req[4])  ){  //email && affiliation code and RICodes
				return true;
			} else {
				System.err.println("Input error: incorrect formatting of values");
				System.exit(1); 
			}
    	} else if (req.length == 6){ // 2 RICodes submitted
    		if (isEmailAddress(req[2]) && isInteger(req[3]) && isInteger(req[4]) && isInteger(req[5])){  //email && affiliation code and RICodes
				return true;
			} else {
				System.err.println("Input error: incorrect formatting of values");
				System.exit(1); 
			}
    	} else if (req.length == 7){ //  3 RICodes submitted
    		if (isEmailAddress(req[2]) && isInteger(req[3]) && isInteger(req[4]) && isInteger(req[5]) && isInteger(req[6]) ){  //email && affiliation code and RICodes
				return true;
			} else {
				System.err.println("Input error: incorrect formatting of values");
				System.exit(1); 
			}
    	} else {
    		System.err.println("Input error: invalid number of input vals");
    		System.exit(1);
    	}
    	return false;
    } 

    /*
    *
    * editor_register checks if num of args and format of register-editor request is correct. returns boolean.	
    * correct format is:	 <fname> <lname> <email> 
    *
    */
    public static boolean editor_register (String[] req){
    	if (req.length == 3){
			if (isEmailAddress(req[2])){  //email 
				return true;
			} else {
				System.err.println("Input error: incorrect formatting of input vals.");
				System.exit(1);  
			}
    	} else {
    		System.err.println("Input error: invalid number of input vals");
    		System.exit(1);
    	}
    	return false;
    } 

   	/*
   	 *
   	 * copied from internet. that okay? my inner good student feels wary.
   	 * http://stackoverflow.com/questions/624581/what-is-the-best-java-email-address-validation-method
   	 */
    public static boolean isEmailAddress(String email) {
           String ePattern = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\])|(([a-zA-Z\\-0-9]+\\.)+[a-zA-Z]{2,}))$";
           java.util.regex.Pattern p = java.util.regex.Pattern.compile(ePattern);
           java.util.regex.Matcher m = p.matcher(email);
           return m.matches();
    }


    /*
    *
    * checks if val is integer. haha another one from internet aah i hope this is okay lolol
    * http://stackoverflow.com/questions/8336607/how-to-check-if-the-value-is-integer-in-java
    */
    public static boolean isInteger(String str) {
	    try {
	        Integer.parseInt(str);
	        return true;
	    } catch (NumberFormatException nfe) {
	        return false;
	    }
	}
    	


















    
}