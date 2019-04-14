"MISC for BUREAUCRACY: (C)1987 Infocom, Inc. All Rights Reserved."

<FILE-FLAGS MDL-ZIL?>

<INCLUDE "OLD-PARSERDEFS" "FORMDEFS">

<USE "NEWSTRUC">

<DIRECTIONS NORTH EAST SOUTH WEST UP DOWN IN OUT>

"*** ZCODE STARTS HERE ***"

<OBJECT DUMMY-OBJECT>

<CONSTANT SL-TABLE <ITABLE NONE 80>>
<SETG OLD-HERE <>>
<SETG OLD-LEN 0>

<SETG WINNER 0>

<CONSTANT YOU-SEE "You see ">
<CONSTANT CANT "You can't ">
<CONSTANT DONT "You don't ">
<CONSTANT PERIOD ".|
">
<CONSTANT PCR ".|
|
">
<CONSTANT BRACKET "]|
|
">

<MSETG S-TEXT 0>
<MSETG S-WINDOW 1>

<MSETG S-BEEP 1>
<MSETG S-BOOP 2>

<MSETG H-NORMAL 0>
<MSETG H-INVERSE 1>
<MSETG H-BOLD 2>
<MSETG H-ITALIC 4>

<MSETG D-SCREEN-ON 1>
<MSETG D-SCREEN-OFF -1>
<MSETG D-PRINTER-ON 2>
<MSETG D-PRINTER-OFF -2>
<MSETG D-TABLE-ON 3>
<MSETG D-TABLE-OFF -3>
<MSETG D-RECORD-ON 4>
<MSETG D-RECORD-OFF -4>

<SETG WIDTH 0>  ; "Width of screen."
<SETG HEIGHT 0> ; "Height of screen."

<SETG CURRENT-MESSAGE <>>

<DEFINE DO-MAIN-LOOP ("AUX" X)
	 <REPEAT ()
		 <SETG CURRENT-MESSAGE <>>
		 <SET X <MAIN-LOOP>>>>

<SETG P-MULT? <>>

<DEFINE DO-PRINT-WORD (WRD "AUX" (FOO ,LONG-WORD-TABLE))
  <COND (<SET FOO <INTBL? .WRD <ZREST .FOO 2> <ZGET .FOO 0>>>
	 <TELL <ZGET .FOO 1>>)
	(T
	 <ZPRINTB .WRD>)>>

<SETG OBJECTS-GROUPED <>>

<DEFINE OBJECTS-GROUPED? OG? (TBL "AUX" (CNT:FIX <ZGET .TBL 0>))
  <SET TBL <ZREST .TBL 2>>
  <COND (<AND <==? .CNT 2>
	      <INTBL? ,BWIRE .TBL .CNT>
	      <INTBL? ,RWIRE .TBL .CNT>>
	 T)
	(<G=? .CNT 2>
	 <REPEAT (O (X1 <>) (X2 <>))
	   <COND (<NOT <INTBL? <SET O <ZGET .TBL <SET CNT <- .CNT 1>>>>
			       ,ALL-HANDLES ,HANDLE-COUNT>>
		  <RETURN <> .OG?>)>
	   <COND (<F? .X1> <SET X1 .O>)
		 (<F? .X2>
		  <COND (<N==? .O .X1> <SET X2 .O>)
			(T
			 <RETURN <> .OG?>)>)
		 (<OR <==? .O .X1>
		      <==? .O .X2>>
		  <RETURN <> .OG?>)>
	   <COND (<==? .CNT 0>
		  <RETURN T .OG?>)>>)>>

<SETG QCONTEXT <>>
<SETG QCONTEXT-ROOM <>>

<DEFINE MAIN-LOOP ("OPT" (GROUP? <>) (FAKE? <>)
		   "AUX" ICNT:FIX OCNT:FIX NUM:FIX CNT:FIX OBJ TBL (V <>)
		          PTBL OBJ1 TMP X (OLD-THEM <>))
     <SET CNT 0>
     <SET OBJ <>>
     <SET PTBL T>
     <COND (<NOT <HERE? QCONTEXT-ROOM>>
	    <SETG QCONTEXT <>>)>
     <COND (<AND <F? .GROUP?>
		 <F? .FAKE?>>
	    <SETG P-MULT? <>>
	    <SETG P-WON <PARSER>>)>
     <COND (<T? ,P-WON>
	    <SET ICNT <ZGET ,P-PRSI ,P-MATCHLEN>>
	    <SET OCNT <ZGET ,P-PRSO ,P-MATCHLEN>>
	    <COND (<AND <T? ,P-IT-OBJECT>
			<ACCESSIBLE? ,P-IT-OBJECT>>
		   <SET TMP <>>
		   <REPEAT ()
			   <COND (<G? <SET CNT <+ .CNT 1>> .ICNT>
				  <RETURN>)
				 (T
				  <COND (<EQUAL? <ZGET ,P-PRSI .CNT> ,IT>
					 <ZPUT ,P-PRSI .CNT ,P-IT-OBJECT>
					 <SET TMP T>
					 <RETURN>)>)>>
		   <COND (<ZERO? .TMP>
			  <SET CNT 0>
			  <REPEAT ()
			   <COND (<G? <SET CNT <+ .CNT 1>> .OCNT>
				  <RETURN>)
				 (T
				  <COND (<EQUAL? <ZGET ,P-PRSO .CNT> ,IT>
					 <ZPUT ,P-PRSO .CNT ,P-IT-OBJECT>
					 <RETURN>)>)>>)>
		   <SET CNT 0>)>
	    <SET NUM
		 <COND (<ZERO? .OCNT>
			.OCNT)
		       (<G? .OCNT 1>
			<SET TBL ,P-PRSO>
			<COND (<ZERO? .ICNT>
			       <SET OBJ <>>)
			      (T
			       <SET OBJ <ZGET ,P-PRSI 1>>)>
			.OCNT)
		       (<G? .ICNT 1>
			<SET PTBL <>>
			<SET TBL ,P-PRSI>
			<SET OBJ <ZGET ,P-PRSO 1>>
			.ICNT)
		       (T
			1)>>
	    <COND (<AND <ZERO? .OBJ>
			<EQUAL? .ICNT 1>>
		   <SET OBJ <ZGET ,P-PRSI 1>>)>
	    <COND (<AND <VERB? WALK>
			<OR <T? ,P-WALK-DIR>
			    <T? ,PRSO>>>
		   <SET V <PERFORM ,PRSA ,PRSO>>)
		  (<ZERO? .NUM>
		   <COND (<ZERO? <BAND <GETB ,P-SYNTAX ,P-SBITS> ,P-SONUMS>>
			  <SET V <PERFORM ,PRSA>>
			  <SETG PRSO <>>)
			 ;(<ZERO? ,LIT?>
			  <PCLEAR>
			  <TOO-DARK>)
			 (T
			  <PCLEAR>
			  <TELL "[There isn't anything to ">
			  <SET TMP <ZGET ,P-ITBL ,P-VERBN>>
			  <COND (<INTBL? ,PRSA ,TALKVERBS ,NTVERBS>
			         <TELL "talk to">)
				(<OR <T? ,P-MERGED>
				     <T? ,P-OFLAG>>
				 <DO-PRINT-WORD <ZGET .TMP 0>>)
				(T
				 <SET V <WORD-PRINT <GETB .TMP 2>
						    <GETB .TMP 3>>>)>
			  <TELL ".]" CR>
			  <SET V <>>)>)
		; (<AND <T? .PTBL>
			<G? .NUM 1>
			<VERB? COMPARE>>
		   <SET V <PERFORM ,PRSA ,OBJECT-PAIR>>)
		  (T
		   <SET X 0>
		   <SETG P-MULT? <>>
		   <SETG OBJECTS-GROUPED <>>
		   <COND (<AND <G? .OCNT 1>
			       <F? .GROUP?>
			       <OBJECTS-GROUPED? ,P-PRSO>>
			  <SETG OBJECTS-GROUPED T>)
			 (<G? .NUM 1>
			  <SETG P-MULT? T>
			  <COND (<F? <SET OLD-THEM ,P-THEM-OBJECT>>
				 <SET OLD-THEM -2>)>)>
		   <SET TMP <>>
		   <REPEAT ()
		    <COND (<G? <SET CNT <+ .CNT 1>> .NUM>
			   <COND (<G? .X 0>
				  <TELL "[The ">
				  <COND (<NOT <EQUAL? .X .NUM>>
					 <TELL "other ">)>
				  <TELL "object">
				  <COND (<NOT <EQUAL? .X 1>>
					 <TELL "s">)>
				  <TELL " that you mentioned ">
				  <COND (<NOT <EQUAL? .X 1>>
					 <TELL "are">)
					(T <TELL "is">)>
				  <TELL "n't here.]" CR>)
				 (<ZERO? .TMP>
				  <REFERRING>)>
			   <RETURN>)
			  (T
			   <COND (<T? .PTBL>
				  <SET OBJ1 <ZGET ,P-PRSO .CNT>>)
				 (T
				  <SET OBJ1 <ZGET ,P-PRSI .CNT>>)>
	<COND (<OR <G? .NUM 1>
		   <EQUAL? <ZGET <ZGET ,P-ITBL ,P-NC1> 0> ,W?ALL ,W?EVERYTHING>>
	       <COND (<EQUAL? .OBJ1 ,NOT-HERE-OBJECT>
		      <SET X <+ .X 1>>
		      <AGAIN>)
		     (<AND <EQUAL? ,P-GETFLAGS ,P-ALL>
			   <DONT-ALL? .OBJ1 .OBJ>>
		      <AGAIN>)
		     (<NOT <ACCESSIBLE? .OBJ1>>
		      <AGAIN>)
		     (<EQUAL? .OBJ1 ,PLAYER>
		      <AGAIN>)
		     (T
		      <COND (<F? ,OBJECTS-GROUPED>
			     <COND (<EQUAL? .OBJ1 ,IT>
				    <TELL CTHE ,P-IT-OBJECT>)
				   (T
				    <COND
				     (<EQUAL? .OBJ1 ,THEM .OLD-THEM>
				      <SET OLD-THEM -1>)>
				    <TELL CTHE .OBJ1>)>
			     <TELL ": ">)>)>)>
			   <SET TMP T>
			   <SETG PRSO <COND (<T? .PTBL> .OBJ1)
					    (T .OBJ)>>
			   <SETG PRSI <COND (<T? .PTBL> .OBJ)
					    (T .OBJ1)>>
		   <SET V <PERFORM ,PRSA ,PRSO ,PRSI>>
		   <COND (<EQUAL? .V ,FATAL-VALUE>
			  <RETURN>)>)>
		    <COND (<AND <G? .NUM 1>
				<F? ,P-MULT?>>
			   <RETURN>)>>
		   ; "OLD-THEM 0 means no p-mult.  -1 means THEM was
		      used here; -2 means no previous them object."
		   <COND (<EQUAL? .OLD-THEM 0 -1 -2> T)
			 (T <SETG P-THEM-OBJECT <>>)>)>
	    <COND (<EQUAL? .V ,FATAL-VALUE>
		   <SETG P-CONT <>>)>)
	   (T
	    <COND (<F? ,P-OFLAG>
		   <UPDATE-BP 2>)>
	    <SETG P-CONT <>>)>
     <COND (.GROUP?
	    <SETG P-MULT? <>>)>
     <COND (<AND <T? ,P-WON>
		 <F? .FAKE?>
		 <F? .GROUP?>
		 <NOT <EQUAL? .V ,FATAL-VALUE>>
		 <NOT <GAME-VERB?>>
		 <NOT <VERB? SAY>>>
	    <SET V <CLOCKER>>)>
     <SETG PRSA <>>
     <SETG PRSO <>>
     <SETG PRSI <>>>

<CONSTANT GAME-VERBS
	<PLTABLE
	 V?INVENTORY V?TELL V?TIME V?SCORE
         V?SAVE V?RESTORE V?SCRIPT V?UNSCRIPT V?DIAGNOSE V?HELP
	 V?VERBOSE V?BRIEF V?SUPER-BRIEF V?VERSION V?QUIT V?$REFRESH
	 V?$VERIFY V?$ID V?NOTIFY V?$COMMAND
         V?$UNRECORD V?$COMMAND V?$RANDOM ;V?$DEBUG ;V?$CHEAT>>

<DEFINE GAME-VERB? ("AUX" (GV ,GAME-VERBS))
  <COND (<INTBL? ,PRSA <ZREST .GV 2>
		 <ZGET .GV 0>> T)
	(T <>)>>

<DEFINE TOUCHING? ()
	<INTBL? ,PRSA ,TOUCHVERBS ,NTOUCHES>>

<DEFINE PUTTING? ()
	<INTBL? ,PRSA ,PUTVERBS ,NUMPUTS>>

<DEFINE MOVING? ()
	<INTBL? ,PRSA ,MOVEVERBS ,NMVERBS>>

<DEFINE HURTING? ()
	<INTBL? ,PRSA ,HURTVERBS ,NHVERBS>>

<DEFINE SEEING? ()
	<INTBL? ,PRSA ,SEEVERBS ,NSVERBS>>

<DEFINE HAVING? ()
	<INTBL? ,PRSA ,HAVEVERBS ,NHAVES>>

<DEFINE DONT-ALL? DA (O I "AUX" L)
	 <SET L <LOC .O>>
	 <COND (<OR <ZERO? .L>
		    <EQUAL? .O .I>>)
	       (<VERB? TAKE>
		<COND (<EQUAL? .L ,WINNER>
		       T)
		      (<IS? .O ,NOALL>
		       T)
		      (<AND <NOT <IS? .O ,TAKEABLE>>
			    <NOT <IS? .O ,TRYTAKE>>>
		       T)
		      (<==? .L ,LLAMA-PEN> <>)
		      (<AND <IS? .L ,CONTAINER>
			    <NOT <IS? .L ,OPENED>>>
		       T)
		      (<AND <IS? .L ,CONTAINER>
			    <IS? .L ,TAKEABLE>
			    <N==? .L .I>>
		       T)
		      (<T? .I>
		       <COND (<NOT <EQUAL? .L .I>> T)
			     (<SEE-INSIDE? .I>
			      <RETURN <> .DA>)>)
		      (<OR <EQUAL? .L ,HERE>
		       	   <SEE-INSIDE? .L>>
		       <RETURN <> .DA>)>)
	       (<VERB? DROP PUT PUT-ON THROW THROW-OVER>
		<COND (<EQUAL? .O ,POCKET> T)
		      (<EQUAL? .L ,POCKET> T)
		      (<IS? .O ,WORN> T)
		      (<EQUAL? .L ,WINNER>
		       <RETURN <> .DA>)>)
	       (T
		<RETURN <> .DA>)>
	 T>

<DEFINE ACCESSIBLE? (OBJ)
         <COND (<EQUAL? .OBJ <> ,NOT-HERE-OBJECT>
		<>)
	       (<EQUAL? <META-LOC .OBJ> ,WINNER ,HERE ,GLOBAL-OBJECTS>
	        T)
	       (<==? .OBJ ,RANDOM-OBJECT> T)
	       (<AND <==? .OBJ ,AISLE>
		     <HERE? SEAT AISLE>> T)
	       (<AND <==? .OBJ ,SEAT>
		     <HERE? SEAT AISLE>> T)
	       (<AND <==? .OBJ ,UNDER-TRAP-DOOR>
		     <HERE? LANDING-STRIP>> T)
	       (<VISIBLE? .OBJ>
	        T)
	       (T 
		<>)>>

<DEFINE VISIBLE? VIS (OBJ "AUX" L)
         <COND (<EQUAL? .OBJ <> ,NOT-HERE-OBJECT> 
		<RETURN <> .VIS>)>
	 <SET L <LOC .OBJ>>
	 <COND (<==? .OBJ ,RANDOM-PERSON> T)
	       (<EQUAL? .L <> ,GLOBAL-OBJECTS>
		<>)
	       (<EQUAL? .L ,HERE ,PLAYER ,WINNER>
	        T)
               (<AND <EQUAL? .L ,LOCAL-GLOBALS>
		     <GLOBAL-IN? .OBJ ,HERE>>
		T)
	       (<AND <SEE-INSIDE? .L>
		     <VISIBLE? .L>>
	        T)
               (T
	        <>)>>

<DEFINE META-IN? MI (OBJ LOC)
  <REPEAT ()
    <COND (<IN? .OBJ .LOC> <RETURN T .MI>)>
    <COND (<F? <SET OBJ <LOC .OBJ>>> <RETURN <> .MI>)>>>

<DEFINE META-LOC ML (OBJ)
	 <REPEAT ()
		 <COND (<ZERO? .OBJ>
			<RETURN <> .ML>)
		       (<IN? .OBJ ,GLOBAL-OBJECTS>
			<RETURN ,GLOBAL-OBJECTS .ML>)
		       (<IN? .OBJ ,ROOMS>
			<RETURN .OBJ .ML>)
		       (T
			<SET OBJ <LOC .OBJ>>)>>>

<DEFINE DISPLAY-PLACE ("AUX" NL)
	 <COND (<NOT <HERE? OLD-HERE>>
		<SETG OLD-HERE ,HERE>
		<ZBUFOUT <>>
		<SCREEN ,S-WINDOW>
		<HLIGHT ,H-NORMAL>
		<HLIGHT ,H-INVERSE>
		<SET NL <SAY-HERE 1>>
		; "Doesn't do any screen output, returns len"
		<CURSET 1 2> ; "Erase old desc."
		<PRINT-SPACES ,OLD-LEN>
		<SETG OLD-LEN .NL> ; "Print new HERE desc."
		<CURSET 1 2>
		<SAY-HERE 2>
		<HLIGHT ,H-NORMAL>
		<SCREEN ,S-TEXT>
		<ZBUFOUT T> ; "Back to main screen.")>>
	
<DEFINE PRINT-SPACES (N) 
	 <REPEAT ()
		 <COND (<L? <SET N <- .N 1>> 0>
			<RETURN>)>
		 <PRINTC 32>>>

<DEFINE SAY-HERE ("OPT" (SL-MODE? <>))
	 <COND (<==? .SL-MODE? 1>
		<DIROUT ,D-TABLE-ON ,SL-TABLE>
		<TELL D ,HERE>
		;<COND (<ZERO? ,LIT?>
		       <TELL "Darkness">)
		      (T
		       <TELL D ,HERE>)>
		<DIROUT ,D-TABLE-OFF>
		<ZGET ,SL-TABLE 0>)
	       ;(<ZERO? ,LIT?>
		<TELL "Darkness">)
	       (T
		<START-CAPS>
		<TELL D ,HERE>
		; "Says to capitalise all words"
		<END-CAPS T>
		;<COND (<F? .SL-MODE?>
		       <ZBUFOUT <>>
		       <DIROUT ,D-SCREEN-OFF>
		       <TELL D ,HERE>
		       <DIROUT ,D-SCREEN-ON>
		       <ZBUFOUT T>)>)>>

<SETG BP <ORB <* 120 ,SYSTOLIC-SHIFT> 80>>   ; "Blood pressure."
<SETG OLD-BP 0> ; "Previous blood pressure."

<DEFINE DISPLAY-BP ("AUX" S)
	 <COND (<NOT <EQUAL? ,OLD-BP ,BP>>
		<SETG OLD-BP ,BP>
		<ZBUFOUT <>>
		<SCREEN ,S-WINDOW>
		<HLIGHT ,H-NORMAL>
		<HLIGHT ,H-INVERSE>
		<SET S <- ,WIDTH 7>>
		<CURSET 1 .S> ; "Erase old numbers."
		<PRINT-SPACES 7>
		<CURSET 1 .S>
		<SAY-BP>
		<HLIGHT ,H-NORMAL>
		<SCREEN ,S-TEXT>
		<ZBUFOUT T> ; "Back to main screen.")>>

<DEFINE SAY-BP ("AUX" (SYSTOLIC <GET-SYSTOLIC>)
		(DIASTOLIC <ANDB ,BP *377*>))
	 <TELL N .SYSTOLIC "/" N .DIASTOLIC>>

<DEFINE PRINT-PICK-ONE (TBL)
  <TELL <PICK-ONE .TBL>>>

<DEFINE PRINT-PICK-NEXT (TBL)
  <TELL <PICK-NEXT .TBL>>>
	 
<DEFINE CTHE-PRINT ("OPTIONAL" (O <>))
	 <COND (<ZERO? .O>
		<SET O ,PRSO>)>
	 <COND (<NOT <IS? .O ,NOARTICLE>>
		<TELL "The " D .O>)
	       (T
		<START-CAPS>
		<TELL D .O>
		<END-CAPS>)>>

<DEFINE THE-PRINT ("OPTIONAL" (O <>))
	 <COND (<ZERO? .O>
		<SET O ,PRSO>)>
	 <COND (<NOT <IS? .O ,NOARTICLE>>
		<TELL "the ">)>
	 <TELL D .O>>

<DEFINE CTHEI-PRINT ()
	 <CTHE-PRINT ,PRSI>
	 T>

<DEFINE THEI-PRINT ()
	 <THE-PRINT ,PRSI>
	 T>

<DEFINE DPRINT (O "AUX" X)
	 <SET X <GETP .O ,P?SDESC>>
	 <COND (<T? .X>
		<ZAPPLY .X>)
	       (T
		<PRINTD .O>)>>

<DEFINE CPRINTA (O)
  <START-CAPS>
  <PRINTA .O>
  <END-CAPS>>

<DEFINE PRINTA (O)
	 <COND (<NOT <IS? .O ,NOARTICLE>>
		<COND (<IS? .O ,PLURAL>
		       <COND (<IS? .O ,PERSON>
			      <TELL "the ">)>)
		      (<IS? .O ,VOWEL>
		       <PRINTI "an ">)
		      (T
		       <PRINTI "a ">)>)>
	 <TELL D .O>>

<OBJECT GLOBAL-OBJECTS
	(FLAGS LOCATION LIGHTED INDOORS PLACE FOODBIT
	       NODESC NOARTICLE VOWEL PLURAL NOALL SEEN
	       TOUCHED SURFACE CONTAINER OPENABLE DOORLIKE 
	       OPENED TRANSPARENT LOCKED TAKEABLE TRYTAKE
	       CLOTHING WORN LIVING PERSON FEMALE IN-TERMINAL
	       IN-TOWN IN-AIRPLANE
	       TOOL VEHBIT READABLE MANUALLY CLERK-TOLD AGENT-TOLD
	       DMAN-TOLD SHITTY NO-NERD SPECIAL-DROP SHARPENED
	       SEARCH-ME MUSICAL INVISIBLE NEEDS-IDENTITY)>

<OBJECT LOCAL-GLOBALS
	(LOC GLOBAL-OBJECTS)
	(SYNONYM ZZZP)
        (DESCFCN 0)
        (GLOBAL GLOBAL-OBJECTS)
        (FDESC "F")
        (LDESC "L")
        (CONTFCN 0)
        (SIZE 0)
        (CAPACITY 0)
      ; (VALUE 0)>

<OBJECT ROOMS
	(FLAGS NODESC NOARTICLE LOCATION)
	(DESC "that")
	(IN TO ROOMS)>

<OBJECT INTNUM
	(LOC GLOBAL-OBJECTS)
	(DESC "number")
	(SYNONYM INTNUM PAGE)
	(ADJECTIVE PAGE OMNIA GALLIA FLIGHT INTNUM)
	(ACTION INTNUM-F)>

<DEFINE INTNUM-F INTNUM ("AUX" X)
	 <COND (<AND <EQUAL? ,P-NUMBER 42>
		     <ADJ-USED? ,W?FLIGHT ,W?ZALAGASA ,W?AIR>>
		<COND (<THIS-PRSI?>
		       <ZPUT ,P-NAMW 1 ,W?FLIGHT>
		       <ZPUT ,P-OFW 1 <>>
		       <SET X <PERFORM ,PRSA ,PRSO ,THE-FLIGHT>>
		       <RETURN T .INTNUM>)>
		<ZPUT ,P-NAMW 0 ,W?FLIGHT>
		<ZPUT ,P-OFW 0 <>>
		<SET X <PERFORM ,PRSA ,THE-FLIGHT ,PRSI>>
		T)
	       (<OR <ADJ-USED? ,W?PAGE>
		    <NOUN-USED? ,W?PAGE>>
		<COND (<AND <VISIBLE? ,ABOOK>
			    <EQUAL? ,P-NUMBER 1 2 3>>
		       <COND (<NOT <IS? ,ABOOK ,OPENED>>
			      <MAKE ,ABOOK ,OPENED>
			      <TELL "[opening " THE ,ABOOK 
				    " first" ,BRACKET>)>
		       <SET X ,PAGE-1>
		       <COND (<EQUAL? ,P-NUMBER 2>
			      <SET X ,PAGE-2>)
			     (<EQUAL? ,P-NUMBER 3>
			      <SET X ,PAGE-3>)>
		       <COND (<THIS-PRSI?>
			      <SET X <PERFORM ,PRSA ,PRSO .X>>)
			     (T
			      <SET X <PERFORM ,PRSA .X ,PRSI>>)>
		       T)
		      (T
		       <REFERRING>
		       ,FATAL-VALUE)>)
	       (T
		<>)>>			    

<OBJECT IT
	(LOC GLOBAL-OBJECTS)
	(DESC "it")
	(FLAGS VOWEL NOARTICLE NODESC TOUCHED)
	(SYNONYM IT THAT ITSELF THIS)>

<DEFINE BE-SPECIFIC ()
	 <TELL "[Be specific: what do you want to ">>

<DEFINE TO-DO-THING-USE (STR1 STR2)
	 <TELL "[To " .STR1 " something, use the command: " 
	       .STR2 " THING.]" CR>>

<DEFINE CANT-USE (PTR "AUX" BUF) 
	<SETG QUOTE-FLAG <>>
	<SETG P-OFLAG <>>
	<TELL "[This story can't understand the word \"">
	<WORD-PRINT <GETB <ZREST ,P-LEXV <SET BUF <* .PTR 2>>> 2>
		    <GETB <ZREST ,P-LEXV .BUF> 3>>
	<TELL "\" when you use it that way.]" CR>>

<DEFINE DONT-UNDERSTAND ()
	<TELL "[Please try to express that another way.]" CR>>

<DEFINE NOT-IN-SENTENCE (STR)
	 <TELL "[There aren't " .STR " in that sentence.]" CR>>

<OBJECT PLAYER
	(SYNONYM PROTAGONIST)
	(DESC "yourself")
	(FLAGS NODESC NOARTICLE)
	(ACTION PLAYER-F)
	(SIZE 0)
	(CAPACITY 1000)>

<SETG HUNGER 1>

<MSETG HUNGER-SLIGHT 40>	;"Slightly hunger"
<MSETG HUNGER-MORE 80>		;"Hungry"
<MSETG MUNGER-VERY 120>		;"Very hungry"
<MSETG HUNGER-FAMISH 160>	;"Famished"
<MSETG HUNGER-DELERIOUS 200>	;"Delirious"

<MSETG H-ERRS 0>		;"Offset for error messages"
<MSETG H-EAT 1>			;"Offset for msgs during eating."
<MSETG H-HUNG 2>		;"Offset for msgs when hunger achieved."
;<MSETG H-PROB 3>		;"Offset for hunger probs."
;<MSETG H-LLAMA-EAT-MSGS 4>
<MSETG H-LLAMA-EAT-MSGS 3>	;"Offset for msgs if try eating LLAMA food."

<MSETG HUNGER-MAX 4>

<CONSTANT HUNGER-MSGS
      <PTABLE
       <PLTABLE "A fainting feeling prevents this simple action."
	        "Your compelling thoughts of a nice juicy steak temporarily distract you."
	        "Daydreaming about your last meal causes you to forget what you were doing."
	        "You find yourself becoming completely engrossed in your lack of food."
	        "You are delirious with hunger and can't even do this.">
       <PTABLE "You're not hungry but eat anyway."
	       "You're slightly hungry so you eat with little enjoyment."
	       "You're pretty hungry so you eat with satisfaction."
	       "You're very hungry and decide the burger hits the spot."
	       "You're famished so you stuff it into your mouth as fast as you can."
	       "You're delirious with hunger and are amazed you can even get it into your mouth.">
       <PTABLE "You are starting to feel hungry."
	       "You are feeling hungry."
	       "You are feeling very hungry."
	       "You are famished."
	       "You are weak with hunger.">
        ;<PTABLE (BYTE) 0 1 5 10 20 60>
	<PTABLE "You're not even hungry."
		"There are obviously better things to eat."
		"They don't really seem appetising."
		"You taste one and think better of it."
		"As hungry as you are, they taste too disgusting to eat."
		"You try imagining they are nacho chips but just can't bring yourself to swallow them.">>>

<SETG MOVES 0>

<SETG NO-HUNGER-INT <>>

<DEFINE PLAYER-F ("OPTIONAL" (CONTEXT <>) "AUX" (H:FIX ,HUNGER) PR:FIX H1:FIX)
	<COND (<==? .CONTEXT ,M-WINNER>
	       <SETG MOVES <+ ,MOVES:FIX 1>>)>
	<COND (<AND <THIS-PRSO?>
		    <VERB? UNPLUG>
		    <IN? ,CHUTE ,PLAYER>>
	       <PERFORM ,V?TAKE-OFF ,CHUTE>)
	      (<AND <N==? .H 0> <==? .CONTEXT ,M-WINNER>>
	       ;<SET H1 </ .H 40>>
	       ;<SET PR <GETB <ZGET ,HUNGER-MSGS ,H-PROB> .H1>>
	       <SET PR 60>
	       <COND (<AND <G=? .H ,HUNGER-DELERIOUS>
			   ;<N==? .PR 0>
			   <PROB .PR>
			   <NOT <GAME-VERB?>>
			   <N==? ,PRSA ,V?WAIT>>
		      <TELL PONE <ZGET ,HUNGER-MSGS ,H-ERRS> CR>
		      <SETG NO-HUNGER-INT T>
		      ,FATAL-VALUE)
		     (ELSE <>)>)>>

<DEFINE I-HUNGER ("OPT" (CR? T) "AUX" H1:FIX)
  <COND (<L? ,HUNGER:FIX ,HUNGER-DELERIOUS>
	 <SETG HUNGER <+ ,HUNGER:FIX 1>>)>
  <COND (<AND <F? ,NO-HUNGER-INT>
	      <==? <* <SET H1 </ ,HUNGER:FIX 40>> 40> ,HUNGER:FIX>>
	 <COND (<G? .H1 ,HUNGER-MAX>
		<SET H1 ,HUNGER-MAX>)>
	 <COND (.CR? <ZCRLF>)>
	 <TELL <ZGET <ZGET ,HUNGER-MSGS ,H-HUNG> .H1> CR>
	 T)
	(T
	 <SETG NO-HUNGER-INT <>>
	 <>)>>

<DEFINE EAT-LLAMA-TREATS ()
	<TELL <ZGET <ZGET ,HUNGER-MSGS ,H-LLAMA-EAT-MSGS>
			   </ ,HUNGER 40>> CR>>
	       
<DEFINE INAPPROPRIATE ()
	 <TELL "That would hardly be an appropriate thing to do." CR>>

<DEFINE WONT-HELP ()
	 <TELL " isn't likely to help matters." CR>>

<OBJECT GLOBAL-ROOM
	(LOC GLOBAL-OBJECTS)
	(DESC "room")
	(SYNONYM ROOM AREA PLACE)
	(ADJECTIVE OPENED THIS)
	(ACTION GLOBAL-ROOM-F)>

<DEFINE GLOBAL-ROOM-F ()
	 <COND (<VERB? EXAMINE LOOK-ON LOOK-INSIDE>
		<V-LOOK>
		T)
	       (<OR <ENTERING?>
		    <VERB? DROP EXIT>>
		<V-WALK-AROUND>
		,FATAL-VALUE)
	       (<VERB? WALK-AROUND>
		<TELL
"Walking around the area reveals nothing new" ,PCR
"[If you want to go somewhere, simply indicate a " D ,INTDIR ".]" CR>
		T)
	       (T
		<>)>>
	       
<DEFINE CANT-SEE-ANY-STR (STR)
  <CANT-SEE-ANY <> .STR>>

<DEFINE CANT-SEE-ANY ("OPTIONAL" (THING <>) (STRING? <>))
         <SETG CLOCK-WAIT? T>
	 <PCLEAR>
	 <SETG P-IT-OBJECT ,NOT-HERE-OBJECT>
	 <TELL ,CANT>
	 <COND (<VERB? LISTEN>
		<TELL "hear ">)
	       (<VERB? SMELL>
		<TELL "smell ">)
	       (T
		<TELL "see ">)>
	 <COND (<T? .STRING?>
		<TELL .STRING?>)
	       (<T? .THING>
		<COND (<NOT <IS? .THING ,NOARTICLE>>
		       <TELL "any ">)>
		<TELL D .THING>)
	       (T
		<TELL D ,NOT-HERE-OBJECT>)>
	 <TELL " here." CR>>

<DEFINE HOW? ()
         <TELL "How do you ">
	 <COND (<PROB 50>
		<TELL "expect ">)
	       (T
		<TELL "intend ">)>
	 <TELL "to do that?" CR>>
	 			      
<DEFINE NOT-LIKELY (THING STR)
	 <TELL "It" PNEXT ,LIKELIES " that " THE .THING>
	 <SPACE>
	 <TELL .STR ,PERIOD>>

<CONSTANT LIKELIES 
	<TABLE (LENGTH PATTERN (BYTE [REST WORD]))
	 #BYTE 0
	 " isn't likely"
	 " seems doubtful"
	 " seems unlikely"
	 "'s unlikely"
	 "'s not likely"
	 "'s doubtful">>

<DEFINE YOUD-HAVE-TO (STR THING)
	 <THIS-IS-IT .THING>
	 <TELL "You'd have to " .STR>
	 <SPACE>
	 <TELL THE .THING " to do that." CR>>

<OBJECT HER
	(LOC GLOBAL-OBJECTS)
	(SYNONYM SHE HER HERSELF)
	(DESC "her")
	(FLAGS NOARTICLE PERSON LIVING FEMALE)>

<OBJECT HIM
	(LOC GLOBAL-OBJECTS)
	(SYNONYM HE HIM HIMSELF)
	(DESC "him")
	(FLAGS NOARTICLE PERSON LIVING)>

<DEFINE NO-NEED ()
	 <TELL ,DONT "need to do that." CR>>

<DEFINE ITALICIZE (STR "AUX" (PTR 2) (ST 0) LEN CHAR)
         <COND (<EQUAL? <LOWCORE INTID> 5> ; "Atari ST?"
		<SET ST <+ .ST 1>>)>
	 <DIROUT ,D-SCREEN-OFF>
	 <DIROUT ,D-TABLE-ON ,SL-TABLE>
	 <TELL .STR>
	 <DIROUT ,D-TABLE-OFF>
	 <DIROUT ,D-SCREEN-ON>
	 <SET LEN <ZGET ,SL-TABLE 0>>
         <SET LEN <+ .LEN 1>>
	 <COND (<L? .LEN 2>)
	       (; <BAND <GETB 0 1> 8>
	        <OR <ZIL?>
		    <BAND <LOWCORE (ZVERSION 1)>
			  ;<GETB 0 1> 8>> ; "ITALICS BIT SET?"
		<HLIGHT ,H-ITALIC>
		<REPEAT ()
			<SET CHAR <GETB ,SL-TABLE .PTR>>
			<COND (<AND <ZERO? .ST>
				    <OR <EQUAL? .CHAR 32 46 44>
					<EQUAL? .CHAR 33 63 59>
					<EQUAL? .CHAR 58>>>
			       <HLIGHT ,H-NORMAL>
			       <PRINTC .CHAR>
			       <HLIGHT ,H-ITALIC>)
			      (T
			       <PRINTC .CHAR>)>
			<COND (<EQUAL? .PTR .LEN>
			       <RETURN>)>
			<SET PTR <+ .PTR 1>>>
		<HLIGHT ,H-NORMAL>)
	       (T
		<REPEAT ()	; "Caps if no italics."
		  <SET CHAR <GETB ,SL-TABLE .PTR>>
		  <COND (<AND <G? .CHAR 96>
			      <L? .CHAR 123>>
			 <SET CHAR <- .CHAR 32>>)>
		  <PRINTC .CHAR>
		  <COND (<EQUAL? .PTR .LEN>
			 <RETURN>)>
		  <SET PTR <+ .PTR 1>>>)>
	 ;<ZBUFOUT <>>
	 ;<DIROUT ,D-SCREEN-OFF>
	 ;<TELL .STR>
	 ;<DIROUT ,D-SCREEN-ON>
	 ;<ZBUFOUT T>
	 T>
	       
<DEFINE WRONG-WINNER? ()
	 <COND (<EQUAL? ,WINNER ,PLAYER>
		<>)
	       (T
		<TELL "[" ,CANT "tell characters to do that.]" CR>
		T)>>

<DEFINE NOT-IN ("OPTIONAL" (THING <>))
	 <COND (<ZERO? .THING>
		<SET THING ,PRSO>)>
	 <THIS-IS-IT .THING>
	 <TELL "You're not in " THE .THING ,PERIOD>>

<DEFINE NOT-ON ("OPTIONAL" (THING <>))
	 <COND (<ZERO? .THING>
		<SET THING ,PRSO>)>
	 <THIS-IS-IT .THING>
	 <TELL "You're not on " THE .THING ,PERIOD>>

<DEFINE ALREADY-IN ("OPTIONAL" (THING <>))
	 <COND (<ZERO? .THING>
		<SET THING ,PRSO>)>
	 <THIS-IS-IT .THING>
	 <YOURE-ALREADY "in " <>>
	 <TELL THE .THING ,PERIOD>>

<DEFINE ALREADY-ON ("OPTIONAL" (THING <>))
	 <COND (<ZERO? .THING>
		<SET THING ,PRSO>)>
	 <THIS-IS-IT .THING>
	 <YOURE-ALREADY "on " <>>
	 <TELL THE .THING ,PERIOD>>

<DEFINE ALREADY-AT-TOP ("OPTIONAL" (OBJ <>))
	 <ALREADY-AT "top" .OBJ>>

<DEFINE ALREADY-AT-BOTTOM ("OPTIONAL" (OBJ <>))
	 <ALREADY-AT "bottom" .OBJ>>

<DEFINE ALREADY-AT (STR OBJ)
	 <COND (<ZERO? .OBJ>
		<SET OBJ ,PRSO>)>
	 <THIS-IS-IT .OBJ>
	 <YOURE-ALREADY "at the " <>>
	 <TELL .STR " of " THE .OBJ ,PERIOD>>

<DEFINE CANT-SEE-MUCH ()
	 <TELL "Little can be seen from where you are." CR>>

;<DEFINE CANT-SEE-FROM-HERE ("OPTIONAL" (THING <>))
	 <COND (<ZERO? .THING>
		<SET THING ,PRSO>)>
	 <TELL ,CANT "see " THE .THING " from here." CR>>

<DEFINE NOT-A (FRM STR)
	 <TELL "In order to become a "
	       .STR ", you must submit a form " .FRM
	       ". To obtain one, apply in person at the Office of Forms in Point Barrow."
	       CR>>

<DEFINE OPEN-CLOSED ("OPTIONAL" (THING <>) (VOWEL T))
	 <COND (<ZERO? .THING>
		<SET THING ,PRSO>)>
	 <COND (<IS? .THING ,OPENED>
		<COND (<T? .VOWEL>
		       <TELL "n">)>
		<TELL " open ">)
	       (T
		<TELL " closed ">)>
	 <TELL D .THING>>

<DEFINE CANT-FROM-HERE ()
	 <TELL "You couldn't do that from " PNEXT ,COULDNTS ,PERIOD>>

<CONSTANT COULDNTS
	<TABLE (LENGTH PATTERN (BYTE [REST WORD]))
	       #BYTE 0 "here" "where you are" "here">>

<DEFINE IS-ARE ("OPTIONAL" (THING <>))
	 <COND (<ZERO? .THING>
		<SET THING ,PRSO>)>
	 <COND (<IS? .THING ,PLURAL>
		<TELL " are ">)
	       (T
		<TELL " is ">)>>

<DEFINE ISNT-ARENT ("OPTIONAL" (THING <>))
	 <COND (<ZERO? .THING>
		<SET THING ,PRSO>)>
	 <COND (<IS? .THING ,PLURAL>
		<TELL " aren't ">)
	       (T
		<TELL " isn't ">)>>

<DEFINE CARRIAGE-RETURNS ("OPTIONAL" (CNT 23))
	 <COND (<G? .CNT 0>
		<REPEAT ()
		  <ZCRLF>
		  <COND (<L=? <SET CNT <- .CNT 1>> 0>
			 <RETURN>)>>)>
	 T>

<DEFINE WHICH-WAY-IN ()
	 <WHICH-WAY "in">
	 <>>

<DEFINE WHICH-WAY-OUT ()
	 <WHICH-WAY "out">
	 <>>

<DEFINE WHICH-WAY (STR)
	 <TELL "[Which way do you want to go " .STR "?]" CR>>

<DEFINE FIRMLY-ATTACHED (THING TO "OPT" (OTHER <>))
	 <THIS-IS-IT .THING>
	 <TELL CTHE .THING>
	 <IS-ARE .THING>
	 <TELL PNEXT <ZGET ,FIXTURES 0> "ly "
	       PNEXT <ZGET ,FIXTURES 1> " to ">
	 <COND (<F? .TO>
		<TELL .OTHER>)
	       (T
		<TELL THE .TO>)>
	 <TELL ,PERIOD>>

<CONSTANT FIXTURES
	<PTABLE
	 <TABLE (LENGTH PATTERN (BYTE [REST WORD]))
		#BYTE 0 "firm" "permanent" "immovab" "secure">
	 <TABLE (LENGTH PATTERN (BYTE [REST WORD]))
		#BYTE 0 "attached" "affixed">>>

<DEFINE PRSO-NOUN-USED? (WORD1 "OPT" (WORD2 <>) (WORD3 <>) "AUX" WD OFWD)
  <COND (<OR <T? ,PRSO>
	     <G? <ZGET ,P-PRSO 0> 0>>
	 <SET WD <ZGET ,P-NAMW 0>>
	 <SET OFWD <ZGET ,P-OFW 0>>
	 <COND (<OR <AND .WD <EQUAL? .WD .WORD1 .WORD2 .WORD3>>
		    <AND .OFWD <EQUAL? .OFWD .WORD1 .WORD2 .WORD3>>>
		T)
	       (T <>)>)
	(T <>)>>

<DEFINE PRSI-NOUN-USED? (WORD1 "OPT" (WORD2 <>) (WORD3 <>) "AUX" WD OFWD)
  <COND (<OR <T? ,PRSI>
	     <G? <ZGET ,P-PRSI 0> 0>>
	 <SET WD <ZGET ,P-NAMW 1>>
	 <SET OFWD <ZGET ,P-OFW 1>>
	 <COND (<OR <AND .WD <EQUAL? .WD .WORD1 .WORD2 .WORD3>>
		    <AND .OFWD <EQUAL? .OFWD .WORD1 .WORD2 .WORD3>>>
		T)
	       (T <>)>)
	(T <>)>>

<DEFINE NOUN-USED? (WORD1 "OPTIONAL" (WORD2 <>) (WORD3 <>) 
		           "AUX" O I OOF IOF)
	 <COND (<THIS-PRSI?>
		<PRSI-NOUN-USED? .WORD1 .WORD2 .WORD3>)
	       (T
		<PRSO-NOUN-USED? .WORD1 .WORD2 .WORD3>)>>

<DEFINE PRSO-ADJ-USED? (WORD1 "OPT" (WORD2 <>) (WORD3 <>) "AUX" ADJ)
  <COND (<T? ,PRSO>
	 <COND (<AND <SET ADJ <ZGET ,P-ADJW 0>>
		     <EQUAL? .ADJ .WORD1 .WORD2 .WORD3>>
		T)
	       (T <>)>)
	(T <>)>>

<DEFINE PRSI-ADJ-USED? (WORD1 "OPT" (WORD2 <>) (WORD3 <>) "AUX" ADJ)
  <COND (<T? ,PRSI>
	 <COND (<AND <SET ADJ <ZGET ,P-ADJW 1>>
		     <EQUAL? .ADJ .WORD1 .WORD2 .WORD3>>
		T)
	       (T <>)>)
	(T <>)>>

<DEFINE ADJ-USED? (WORD1 "OPTIONAL" (WORD2 <>) (WORD3 <>))
	 <COND (<THIS-PRSI?>
		<PRSI-ADJ-USED? .WORD1 .WORD2 .WORD3>)
	       (T
		<PRSO-ADJ-USED? .WORD1 .WORD2 .WORD3>)>>
		   
<DEFINE HERE-F ()
	 <COND (<THIS-PRSI?>
		<COND (<VERB? PUT EMPTY-INTO>
		       <PERFORM ,V?DROP ,PRSO>
		       T)
		      (T
		       <>)>)
	       (<VERB? EXAMINE LOOK-ON LOOK-INSIDE SEARCH WATCH>
		<V-LOOK>
		T)
	       (<VERB? LOOK-BEHIND LOOK-OUTSIDE>
		<CANT-SEE-MUCH>
		T)
	       (<VERB? ENTER WALK-TO FIND>
		<ALREADY-IN>
		T)
	       (<OR <EXITING?>
		    <VERB? FOLLOW THROUGH CROSS CLIMB-OVER CLIMB-UP
			   CLIMB-DOWN CLIMB-ON>>
		<V-WALK-AROUND>
		T)
	       (T
		<>)>>

<DEFINE PCLEAR ()
	 <SETG P-CONT <>>
	 <SETG QUOTE-FLAG <>>
	 T>

<DEFINE YOU-DONT-NEED (THING "OPTIONAL" (STRING? <>))
	 <TELL "[" ,DONT "need to refer to ">
	 <COND (<T? .STRING?>
		<TELL "the " .THING>)
	       (T
		<TELL THE .THING>)>
	 <TO-COMPLETE>
	 T>

<DEFINE TO-COMPLETE ()
	 <TELL " to complete this story.]" CR>>

;<DEFINE PLACEHOLDER (STR)
	 <TELL "[TESTER: " .STR ". Film at eleven.]" CR>
	 T>

<DEFINE GENDER-PRINT (MALE FEMALE)
  <COND (<T? ,SEX> <TELL .FEMALE>)
	(<T? .MALE> <TELL .MALE>)>
  T>

<CONSTANT PHONE-NUMBERS <ITABLE 14 0>>
