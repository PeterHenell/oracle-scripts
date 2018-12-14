CREATE OR REPLACE PACKAGE dbg
/*
|| dbg - A PL/SQL debugging package by Steven Feuerstein
||
|| Package dependencies:
||		DBMS_OUTPUT
||		DBMS_PIPE
||		DBMS_UTIILTY
||		PS_List (list package defined in Chapter 22)
||		PS_Global (Named globals package defined in Chapter 22)
*/
IS
	/*
	|| SESSION MANAGEMENT
	|| Create a new session, set the current session, halt a session,
	|| get the name of the current session, pack all the session 
	|| settings into a named pipe message, and unpack the contents
	|| of the message into the debug settings.
	*/
	PROCEDURE new_session (session_in IN VARCHAR2);
	PROCEDURE set_session (session_in IN VARCHAR2);
	PROCEDURE halt_session (session_in IN VARCHAR2);
	FUNCTION  get_session RETURN VARCHAR2;
	PROCEDURE pack_session (msg_in IN VARCHAR2);
	PROCEDURE unpack_session;
	/*
	|| WAIT_TIME
	|| The wait_time_in indicates the amount of time that 
	||    (1) a program will wait for a response from the listener before
	||        continuing.
	||	   (2) the listener will wait in between checks for debug messages.
	|| The default is 60 seconds. 
	*/
	PROCEDURE set_wait_time (num_in IN NUMBER);
	FUNCTION get_wait_time RETURN NUMBER;
	/*
	|| INTERRUPT Processing
	|| You can specify that when a breakpoint is fired the program 
	|| waits for a reply from the listening process. The programmer
	|| then has an opportunity to change debug settings.
	*/
	PROCEDURE set_interrupt;
	FUNCTION get_interrupt RETURN BOOLEAN;
	PROCEDURE set_nointerrupt;

	/*
	|| DEBUG MESSAGE OUTPUT
	|| You can specify that a break message be displayed on the 
	|| screen of the same Oracle process that called the break, 
	|| or you can pipe the message to the listener
	*/
	PROCEDURE to_screen;
	PROCEDURE to_pipe;
	FUNCTION get_output RETURN VARCHAR2;
	/*
	|| SKIP
	|| Specifies number of active breakpoints to skip before firing.
	*/
	PROCEDURE set_skip (num_in IN NUMBER);
	FUNCTION get_skip RETURN NUMBER;
	/*
	|| CONFIRM
	|| Specifies number of active breakpoints to fire before confirming 
	|| you want to continue. This setting only has an effect if you are 
	|| directing output to the pipe and "interrupt mode" is turned on.
	*/
	PROCEDURE set_confirm (num_in IN NUMBER);
	FUNCTION get_confirm RETURN NUMBER;
	/*
	|| ACTIVATE BREAKPIONTS
	|| You can activate/deactivate a specific breakpoint, activate ALL 
	|| breakpoints, or turn off all-activation (which means that only those
	|| specifically activated breakpoints will fire). You can specify a 
	|| breakpoint by name or number.
	*/
	PROCEDURE activate_all;
	FUNCTION get_activate_all RETURN BOOLEAN;
	PROCEDURE set_noactivate_all;

	PROCEDURE activate (level_in IN VARCHAR2);
	PROCEDURE activate (level_in IN NUMBER);
	PROCEDURE deactivate (level_in IN VARCHAR2);
	PROCEDURE deactivate (level_in IN NUMBER);

	/*
	|| THE BRK PROCEDURE:
	|| The next seven procedures are all overloaded on the name "brk". I can
	|| overload this way because the parameter lists of the procedures 
	|| are sufficiently different in datatype or number.
	*/
	PROCEDURE brk (date_in IN DATE, 
						mask_in IN VARCHAR2 := 'Month DD, YYYY - HH:MI:SS PM', 
						bp_in IN VARCHAR2 := NULL,
						session_in IN VARCHAR2 := get_session);
	
	PROCEDURE brk (number_in IN NUMBER, 
						bp_in IN VARCHAR2 := NULL,
						session_in IN VARCHAR2 := get_session);
	
	PROCEDURE brk (char_in IN VARCHAR2, 
						bp_in IN VARCHAR2 := NULL,
						session_in IN VARCHAR2 := get_session);
	
	PROCEDURE brk (char_in IN VARCHAR2, number_in IN NUMBER, 
						bp_in IN VARCHAR2 := NULL,
						session_in IN VARCHAR2 := get_session);
	
	PROCEDURE brk (char_in IN VARCHAR2, 
						date_in IN DATE,
						mask_in IN VARCHAR2 := 'Month DD, YYYY - HH:MI:SS PM', 
						bp_in IN VARCHAR2 := NULL,
						session_in IN VARCHAR2 := get_session);

	PROCEDURE brk (boolean_in IN BOOLEAN, 
						bp_in IN VARCHAR2 := NULL,
						session_in IN VARCHAR2 := get_session);
	
	PROCEDURE brk (char_in IN VARCHAR2, boolean_in IN BOOLEAN, 
						bp_in IN VARCHAR2 := NULL,
						session_in IN VARCHAR2 := get_session);
	
END dbg;
