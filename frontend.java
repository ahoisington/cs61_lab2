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
		String mode = "initial";
		String person_id = "";
	    String person_job = "";

		// CONNECT TO DB
		try {
		    // LOAD MYSQL DRIVER
		    Class.forName("com.mysql.jdbc.Driver").newInstance();

		    // INIT CONNECTION
		    con = DriverManager.getConnection(SERVER+DATABASE, USERNAME, PASSWORD);
		    System.out.println("Connection established.");

		    //TAKE IN USER INPUT
	        BufferedReader buffReader = null;
	        BufferedReader buffReader2 = null;

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

	               	int num_args = request.length;

	               	
	               	/* ----------------------------------------------------- REGISTER ----------------------------------------------------- */
	               	if (request[0].equals("register") && mode.equals("initial")){
	               		String[] req_to_check = Arrays.copyOfRange(request,2,request.length);
	               		person_job = request[1];
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

	               	/* ----------------------------------------------------- LOGIN ----------------------------------------------------- */
	               	// we expect: login <person_id>
	               	else if (request[0].equals("login") && mode.equals("initial")){

	               		if (num_args != 2) {
       			    		System.err.println("Incorrect number of arguments.");
       			    		System.exit(1);
       			    	}

	               		person_id = request[1];	          

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

							System.err.println("Invalid ID.");
							System.exit(1);

						}


	               		if (person_job.equals("author")){

	               			mode = "author";

	               			// retrieve author specific information
							query = ("SELECT * FROM author WHERE person_id=" + person_id + ";");		           			
							stmt = con.createStatement();
		           			res = stmt.executeQuery(query);

		           			if (res.next()){
		           				System.out.println(res.getString(3) + "\n"); // mailing address
		           			}

	               			// retrieve author's manuscript information
							query = ("SELECT manuscript_id, title, man_status, date_submitted FROM LeadAuthorManuscripts WHERE person_id=" + person_id + " ORDER BY manuscript_id ASC;");	

							stmt = con.createStatement();
		           			res = stmt.executeQuery(query);

		           			printStatus(res);	

	               		} else if (person_job.equals("reviewer")){

	               			mode = "reviewer";

	               			// retrieve editor's manuscript information (should these be ALL manuscripts or only the ones overseen by this editor???)
							query = ("SELECT manuscript_id, title, man_status, date_submitted FROM ReviewerManuscripts WHERE reviewer_id=" + person_id + " ORDER BY man_status DESC, manuscript_id ASC;");		           			
							stmt = con.createStatement();
		           			res = stmt.executeQuery(query);

		           			System.out.println("");

		           			printStatus(res);

	               		} else if (person_job.equals("editor")){

	               			mode = "editor";

	               			// retrieve editor's manuscript information (should these be ALL manuscripts or only the ones overseen by this editor???)
							query = ("SELECT manuscript_id, title, man_status, date_submitted FROM LeadAuthorManuscripts WHERE editor_id=" + person_id + " ORDER BY man_status DESC, manuscript_id ASC;");		           			
							stmt = con.createStatement();
		           			res = stmt.executeQuery(query);

		           			System.out.println("");

							printStatus(res);

	               		} else {
	               			// this should never happen! Just in case, though :)
	               			System.err.println("Input error: Make sure your request to login follows the correct format. Read documentation or input -h or --help for guidance.");
	               			System.exit(1);
	               		}

	               	/* ----------------------------------------------------- RESIGN ----------------------------------------------------- */
	               	// we expect: resign <person_id>
	               	} else if (request[0].equals("resign") && mode.equals("initial")) {
	               		// 	ONLY REVIEWERS CAN DO THIS... but they access it from the initial page!

	               		if (num_args != 2) {
	               			System.err.println("Incorrect number of arguments.");
	               			System.exit(1);
	               		}

	               		person_id = request[1];

	               		// make sure person_id is an integer
	               		if (!isInteger(person_id)) {

	               			System.err.println("Invalid ID.");
							System.exit(1);
	               		
	               		}

	               		// delete reviewer from database
	               		query = ("DELETE FROM person WHERE `person_id`=" + person_id + ";");

	               		stmt = con.createStatement();
	               		stmt.executeUpdate(query);

	               		// trigger has reverted all "under_review" manuscripts to which they were assigned back to "submitted"
	               		System.out.println("Thank you for your service.");

           		    /* --------------------------------------- AUTHOR OPTIONS --------------------------------------- */
           		    /* ------------- SUBMIT ------------- */
       			    // we expect: submit <title> <affiliation> <ricode> <filename> <editor_id> <author2_id> <author3_id> <author4_id>
       			    } else if (request[0].equals("submit") && mode.equals("author")) {

       			    	if (num_args < 6 || num_args > 9) {
       			    		System.err.println("Incorrect number of arguments.");
       			    		System.exit(1);
       			    	}

       			    	// NEED TO VERIFY THESE ARGUMENTS ARE CORRECT
       			    	String title = request[1];
       			    	String affiliation = request[2];
       			    	String ricode = request[3];
       			    	String filename = request[4]; // NOT DOING ANYTHING WITH FILENAME RIGHT NOW
       			    	String editor_id = request[5];

       			    	String new_man_id = "";
       			    	String affiliation_code = "";

	               		// make sure manu_id and reviewer_id are integers
	               		if ( !isInteger(ricode) || !isInteger(editor_id) ) {

	               			System.err.println("RICode and the editor ID must be integers.");
							System.exit(1);
	               		
	               		}

   			    		// figure out next manuscript_id
               			query = "SELECT MAX(manuscript_id) FROM manuscript;";
               			stmt = con.createStatement();
               			res = stmt.executeQuery(query);

						if (res.next()){
							new_man_id = String.valueOf(Integer.parseInt(res.getString(1)) + 1);
						}

       			    	// insert affiliation information

       			    	// affiliation already exists
						query = ("SELECT affiliation_code FROM affiliation WHERE affiliation = '" + affiliation + "' LIMIT 1;");

						stmt = con.createStatement();
	           			res = stmt.executeQuery(query);
	           			
	           			if (res.next()){
							affiliation_code = res.getString(1); // get affiliation_code
						} else {
	               			query = "SELECT MAX(affiliation_code) FROM affiliation;";
	               			stmt = con.createStatement();
	               			res = stmt.executeQuery(query);

							if (res.next()){
								affiliation_code = String.valueOf(Integer.parseInt(res.getString(1)) + 1); // create new affiliation_code
							}

							// insert new affiliation into affiliation table
							query = ("INSERT INTO `affiliation` (`affiliation_code`,`affiliation`) VALUES (" + affiliation_code + ",'" + affiliation + "');");

							stmt = con.createStatement();
							stmt.executeUpdate(query);
						}

						// associate this affiliation with this person
						query = ("INSERT INTO `person_to_affiliation` (`person_id`,`affiliation_code`) VALUES (" + person_id + "," + affiliation_code + ");");

						stmt = con.createStatement();
						stmt.executeUpdate(query);

						// get today's date
						String currentTime = getDate();

						// insert manuscript into manuscript
						query = ("INSERT INTO `manuscript` (`manuscript_id`,`title`,`date_submitted`,`man_status`,`RICode`,`person_id`) " 
								+ "VALUES (" + new_man_id + ",'" + title + "','" + currentTime + "','submitted'," + ricode + "," + editor_id + ");"
								);

						stmt = con.createStatement();
	           			stmt.executeUpdate(query);

	           			// insert primary author information
						query = ("INSERT INTO `man_to_author` (`manuscript_id`,`person_id`,`author_order_num`) VALUES (" + new_man_id + "," + person_id + ",1);");

						stmt = con.createStatement();
	           			stmt.executeUpdate(query);

	           			// insert secondary author information
						for (int i=6; i<num_args; i++) {
							query = "INSERT INTO `man_to_author` (`manuscript_id`,`person_id`,`author_order_num`) VALUES (" + new_man_id + "," + request[i] + "," + String.valueOf(i-4) + ");";

							stmt = con.createStatement();
	           				stmt.executeUpdate(query);
						}    			    

					/* ------------- STATUS ------------- */
       			    // we expect: status
       			    } else if (request[0].equals("status") && mode.equals("author")) {

       			    	if (num_args != 1) {
       			    		System.err.println("Incorrect number of arguments.");
       			    		System.exit(1);
       			    	}
   			    		
               			// retrieve author's manuscript information
						query = ("SELECT manuscript_id, title, man_status, date_submitted FROM LeadAuthorManuscripts WHERE person_id=" + person_id + " ORDER BY manuscript_id ASC;");	

						stmt = con.createStatement();
	           			res = stmt.executeQuery(query);

	           			System.out.println("");

	           			printStatus(res);	

       			    /* ------------- RETRACT ------------- */
       			    // we expect: retract <man_id>
       			    } else if (request[0].equals("retract") && mode.equals("author")) {

       			    	if (num_args != 2) {
       			    		System.err.println("Incorrect number of arguments.");
       			    		System.exit(1);
       			    	}

       			    	String man_id = request[1];

       			    	// validate man_id
       			    	if (!isInteger(man_id)) {
       			    		System.err.println("Invalid ID.");
	               			System.exit(1);
       			    	}

       			    	// ask user for confirmation
       			    	System.out.println("Are you sure you would like to retract manuscript #" + man_id + " from the database?");

       			    	System.out.print("Y/N: ");
       			    	input = buffReader.readLine();

   			    	    if (input.trim().toLowerCase().equals("y")) {

   			    	        // delete manuscript from database
    						query = ("DELETE FROM manuscript WHERE manuscript_id = " + man_id + ";");

    						stmt = con.createStatement();
               				stmt.executeUpdate(query);

               				System.out.println("Success. \n");

   			    	    } else {
   			    	    	System.out.println("Request aborted. \n");
   			    	    }

           		    /* --------------------------------------- EDITOR OPTIONS --------------------------------------- */
       			    /* ------------- STATUS ------------- */
       			    // we expect: status
       			    } else if (request[0].equals("status") && mode.equals("editor")) {

       			    	if (num_args != 1) {
       			    		System.err.println("Incorrect number of arguments.");
       			    		System.exit(1);
       			    	}

               			// retrieve editor's manuscript information 
						query = ("SELECT manuscript_id, title, man_status, date_submitted FROM LeadAuthorManuscripts WHERE editor_id=" + person_id + " ORDER BY man_status DESC, manuscript_id ASC;");		           			
						stmt = con.createStatement();
	           			res = stmt.executeQuery(query);

	           			System.out.println("");

						printStatus(res);

       			    /* ------------- ASSIGN ------------- */
       			    // we expect: assign <manu_id> <reviewer_id>
       			    } else if (request[0].equals("assign") && mode.equals("editor")) {

       			    	if (num_args != 3) {
       			    		System.err.println("Incorrect number of arguments.");
       			    		System.exit(1);
       			    	}

	               		String manu_id = request[1];
	               		String reviewer_id = request[2];

	               		// make sure manu_id and reviewer_id are integers
	               		if ( !isInteger(manu_id) || !isInteger(reviewer_id) ) {

	               			System.err.println("Invalid ID.");
							System.exit(1);
	               		
	               		}

	               		// check to see if this reviewer has the same RICode as the manuscript
	               		query = ("SELECT RICode FROM person_to_RICode WHERE person_id=" + reviewer_id +
	               			" AND RICode=(SELECT RICode FROM manuscript WHERE manuscript_id=" + manu_id + " AND person_id=" + person_id + ");");

	               		System.out.println(query);

	               		stmt = con.createStatement();
            			res = stmt.executeQuery(query);

            			if (!res.next()) {
            				System.err.println("Reviewer " + reviewer_id + " cannot be assigned to Manuscript #" + manu_id + ".");
            				System.exit(1);
            			}		
            			System.out.println(res.getString(1));

       			    	// get today's date
       			    	String currentTime = getDate();

			    	    // assign reviewer to manuscript
 						query = ("INSERT INTO `feedback` (`manuscript_id`,`person_id`,`date_assigned`) VALUES (" + manu_id + "," + reviewer_id + ",'" + currentTime + "');");

 						stmt = con.createStatement();
            			stmt.executeUpdate(query);	

			    	    // update manuscript to "under review"
 						query = ("UPDATE `manuscript` SET `man_status` = 'under review' WHERE manuscript_id = " + manu_id + ";");

 						stmt = con.createStatement();
            			stmt.executeUpdate(query);	

            			System.out.println("Manuscript #" + manu_id + " is being reviewed by reviewer " + reviewer_id + ".");

   			    	/* ------------- REJECT ------------- */
   			    	// we expect: reject <manu_id>
   			    	} else if (request[0].equals("reject") && mode.equals("editor")) {

   			    		if (num_args != 2) {
   			    			System.err.println("Incorrect number of arguments.");
   			    			System.exit(1);
   			    		}

	               		String manu_id = request[1];

	               		// make sure manu_id is an integer
	               		if ( !isInteger(manu_id) ) {

	               			System.err.println("Invalid ID.");
							System.exit(1);
	               		
	               		}

						// update manuscript to "rejected"
 						query = ("UPDATE `manuscript` SET `man_status` = 'rejected' WHERE manuscript_id = " + manu_id + " AND person_id=" + person_id + ";");

 						stmt = con.createStatement();
            			stmt.executeUpdate(query);	

            			System.out.println("Manuscript #" + manu_id + " has been rejected.");

		    		/* ------------- ACCEPT ------------- */
		    		// we expect: accept <manu_id>
		    		} else if (request[0].equals("accept") && mode.equals("editor")) {

		    			if (num_args != 2) {
		    				System.err.println("Incorrect number of arguments.");
		    				System.exit(1);
		    			}

	               		String manu_id = request[1];

	               		// make sure manu_id is an integer
	               		if ( !isInteger(manu_id) ) {

	               			System.err.println("Invalid ID.");
							System.exit(1);
	               		
	               		}

						// update manuscript to "accepted"
 						query = ("UPDATE `manuscript` SET `man_status` = 'accepted' WHERE manuscript_id = " + manu_id + " AND person_id=" + person_id + ";");

 						stmt = con.createStatement();
            			stmt.executeUpdate(query);	

            			// get today's date
            			String currentTime = getDate();

						// add manuscript to the accepted_man page (num_pages is null because manuscript has not been typeset yet)
 						query = ("INSERT INTO `accepted_man` (`manuscript_id`,`date_of_acceptance`,`num_pages`) VALUES (" + manu_id + ",'" + currentTime + "', NULL);");

 						stmt = con.createStatement();
            			stmt.executeUpdate(query);

            			System.out.println("Manuscript #" + manu_id + " has been accepted.");

       			    /* ------------- TYPESET ------------- */
       			    // we expect: typeset <manu_id> <pp>
       			    } else if (request[0].equals("typeset") && mode.equals("editor")) {

       			    	if (num_args != 3) {
       			    		System.err.println("Incorrect number of arguments.");
       			    		System.exit(1);
       			    	}

	               		String manu_id = request[1];
	               		String pp = request[2];

	               		// make sure manu_id and pp are integers
	               		if ( !isInteger(manu_id) || !isInteger(pp) ) {

	               			System.err.println("Arguments must be integers.");
							System.exit(1);
	               		
	               		}

						// update manuscript to "in typesetting"
 						query = ("UPDATE `manuscript` SET `man_status` = 'in typesetting' WHERE manuscript_id = " + manu_id + " AND person_id=" + person_id + ";");

 						stmt = con.createStatement();
            			stmt.executeUpdate(query);	

						// set number of pages for manuscript
 						query = ("UPDATE `accepted_man` SET `num_pages`=" + pp + ";");

 						stmt = con.createStatement();
            			stmt.executeUpdate(query);

            			System.out.println("Manuscript #" + manu_id + " is " + pp + " pages long.");

   			    	/* ------------- SCHEDULE ------------- */
   			    	// we expect: schedule <manu_id> <issue>
   			    	} else if (request[0].equals("schedule") && mode.equals("editor")) {

   			    		if (num_args != 3) {
   			    			System.err.println("Incorrect number of arguments.");
   			    			System.exit(1);
   			    		}

	               		String manu_id = request[1];
	               		String issue = request[2];

	               		// make sure manu_id and issue are integers
	               		if ( !isInteger(manu_id) || !isInteger(issue) ) {

	               			System.err.println("Arguments must be integers.");
							System.exit(1);
	               		
	               		}

		    		/* ------------- PUBLISH ------------- */
		    		// we expect: status <issue>
		    		} else if (request[0].equals("publish") && mode.equals("editor")) {

		    			if (num_args != 2) {
		    				System.err.println("Incorrect number of arguments.");
		    				System.exit(1);
		    			}

	               		String issue = request[1];

	               		// make sure issue is an integer
	               		if ( !isInteger(issue) ) {

	               			System.err.println("Invalid issue ID.");
							System.exit(1);
	               		
	               		}
	
           			         			    
           		    /* --------------------------------------- REVIEWER OPTIONS --------------------------------------- */
           		    /* ------------- REVIEW ------------- */
       			    // we expect: review <manuscript_id> <appropriateness> <clarity> <methodology> <contribution to field> <recommendation>
       			    } else if (request[0].equals("review") && mode.equals("reviewer")) {
       			    	// note: cannot give feedback for a manuscript that doesn't belong to this reviewer

       			    	if (num_args != 7) {
       			    		System.err.println("Incorrect number of arguments.");
       			    		System.exit(1);
       			    	}

       			    	// NEED TO VERIFY THESE ARGUMENTS ARE CORRECT
       			    	String manuscript_id = request[1];
       			    	String appropriateness = request[2];
       			    	String clarity = request[3];
       			    	String methodology = request[4];
       			    	String contribution = request[5];
       			    	String recommendation = request[6];


       			    	if (!isInteger(manuscript_id) ) {

       			    		System.err.println("Incorrect arguments. Manuscript ID must be an integer.");
       			    		System.exit(1);

       			    	}

       			    	if (!isIntegerBetween1And10(appropriateness) || !isIntegerBetween1And10(clarity) ||
       			    		!isIntegerBetween1And10(methodology) || !isIntegerBetween1And10(contribution) ||
       			    		!isIntegerBetween1And10(recommendation) ) {

       			    		System.err.println("Incorrect arguments. Ratings must be integers between 1 and 10.");
       			    		System.exit(1);

       			    	}

       			    	// get today's date
       			    	String currentTime = getDate();

			    	    // update feedback from this reviewer for manuscript
 						query = ("UPDATE feedback SET appropriateness = " + appropriateness + ", clarity = " + 
 							clarity + ", methodology = " + methodology + ", contribution_to_field = " + 
 							contribution + ", recommendation = " + recommendation + ", date_completed = '" + 
 							currentTime + "' WHERE manuscript_id = " + manuscript_id + " AND person_id=" + person_id + ";");

 						stmt = con.createStatement();
            			stmt.executeUpdate(query);		
            			System.out.println("Feedback submitted.");    

       			    /* ------------- STATUS ------------- */
       			    // we expect: status
       			    } else if (request[0].equals("status") && mode.equals("reviewer")) {

               			// retrieve reviewer's manuscript information
						query = ("SELECT manuscript_id, title, man_status, date_submitted FROM ReviewerManuscripts WHERE reviewer_id=" + person_id + " ORDER BY manuscript_id ASC;");	

						stmt = con.createStatement();
	           			res = stmt.executeQuery(query);

	           			System.out.println("");

	           			printStatus(res);	

       			    /* ------------- catch everything else ------------- */
	               	} else {
	               		System.err.println("Invalid request.");
	               		System.exit(1);
	               	}
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
    * printStatus() takes a ResultSet from a status query and prints the manuscripts and their information appropriately.
    *
    */
    public static void printStatus (ResultSet res){
    	try {
		    while(res.next()) { 		
		    	System.out.format("#%-5s", res.getObject(1)); // manuscript_id

				for(int i = 2; i <= 4; i++) {
				    System.out.format("%-30s", res.getObject(i)); // title, man_status, date_submitted
				}
				System.out.println("");
		    }

		    System.out.println("");

		} catch (SQLException e ) {    // catch SQL errors
		    System.err.format("SQL Error: %s\n", e.getMessage());
		}
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

	// checks to see if str is an integer between 1 and 10 inclusive
    public static boolean isIntegerBetween1And10(String str) {
	    try {
	        int i = Integer.parseInt(str);
	        if (i >= 1 && i <= 10) {
	        	return true;
	        } else {
	        	return false;
	        }
	    } catch (NumberFormatException nfe) {
	        return false;
	    }
	}    	

	// gets today's date and time in the form of a string
    public static String getDate() {
	    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    	return sdf.format(new java.util.Date());
	}    	




















    
}