"OTHER-MISC for BUREAUCRACY: (C)1987 Infocom, Inc. All Rights Reserved."

<FILE-FLAGS MDL-ZIL?>

<INCLUDE "FORMDEFS" "OLD-PARSERDEFS">

<DEFINE DO-FORM? ("AUX" N WRD)
  <PROG ()
    <TELL CR "Type RESTORE followed by carriage return to restore a saved position, anything else (also followed by carriage return) to start the game anew." CR ">>">	;"'File' is not in manual."
    <SET WRD <>>
    <ZREAD ,P-INBUF ,P-LEXV>
    <SET N <GETB ,P-LEXV ,P-LEXWORDS>>
    <COND (<G? .N:FIX 0>
	   <SET WRD <ZGET ,P-LEXV ,P-LEXSTART>>)>
    <COND (<==? .WRD ,W?RESTORE>
	   <COND (<DO-RESTORE> <>)
		 (T <AGAIN>)>)
	  (<EQUAL? .WRD ,W?$VERIFY ,W?$VER>
	   <SETG PRSO <>>
	   <DEBUGGING-CODE
	    <COND (<AND <==? .N:FIX 2>
			<NUMBER? <+ ,P-LEXSTART ,P-LEXELEN>>>
		   <SETG PRSO ,INTNUM>)>>
	   <V-$VERIFY>
	   <AGAIN>)
	  (T
	   <DEBUGGING-CODE
	    <COND (<NOT <EQUAL? .WRD ,W?QUICKLY ,W?Q>>
		   T)
		  (T <>)>
	    T>)>>>

<DEFINE GO () 
       	 <SETG HEIGHT <LOWCORE SCRV>>
	 <SETG WIDTH <LOWCORE SCRH>>
	 <CLEAR -1>
	 <COPYRIGHT>
	 <COND (<DO-FORM?>
		<COND (<OR <L? ,HEIGHT:FIX ,FORM-LENGTH>
			   <L? ,WIDTH:FIX ,FORM-WIDTH>>
		       <TELL CR "[Screen too small.]" CR>
		       <QUIT>)>
		<GET-FORM>)
	       (T
		<CLEAR -1>
		<INIT-STATUS-LINE>
		<ZCRLF>)>
	 <ESTABLISH-EXCHANGES>
	 <QUEUE I-DOORBELL>
	 <QUEUE I-LLAMA>
	 <QUEUE I-TUNE-TIMER>
	 <QUEUE I-RADIO>
	 <QUEUE I-MACAW>
         <QUEUE I-BLOOD-PRESSURE>
	 <QUEUE I-HUNGER>
	 <QUEUE I-NERD>
	 <SETG HERE ,FROOM>
	 <MOVE ,PLAYER ,HERE>
	 <SETG WINNER ,PLAYER>
	 ;<SETG LIT? T>	 
	 <TELL "You have been granted ">
	 <LICENSE>
	 <TELL ,PCR "Thank you for your cooperation, M">
	 <GENDER-PRINT "s " "r ">
	 <PRINT-LAST-NAME>
	 <TELL ". Have a nice day." CR>
	 <LTUANDE>
	 <V-VERSION>
	 <ZCRLF>
	 <V-LOOK>
	 <DO-MAIN-LOOP>>

<DEFINE LTUANDE ()
	<TELL "|
|Well now, ">
	<GENDER-PRINT "Ms " "Mr ">
	<PRINT-LAST-NAME>
	<TELL ", aren't you glad you left your previous job? The Deep Thought Corporation of America was of course a great company to work for, except for the no-coloured-socks dress code, and you really enjoyed being Vice President (Software Development), especially the opportunities it gave you to cause considerable inconvenience to many hundreds of thousands of people you had never met.|
|
But Happitec is going to be ">
	<ITALICIZE "much">
	<TELL " more fun. The money's better, it's a great place to live and work and you're really looking forward to your Paris vacation.|
|
You're pretty pleased with your new home, too, and don't really mind that the removals company fouled up slightly due to a computer scheduling problem. After all, you won't be using your new place for the next two weeks, and they ">
	<ITALICIZE "promised">
	<TELL " to have everything installed by the time you return.|
|
In fact, the only tiny cloud on the horizon is a silly bit of bother with your bank about a change-of-address card. You know the sort of thing? You send them a change-of-address card, and they say \"Oh dearie me, that's not our official change-of-address form, the computer won't like it a bit, you'll have to fill in a proper one, we'll send one to you,\" and they do, but they send it to your old address along with your new US Excess card and your cheque book...?|
|
Of course you know the sort of thing. It's exactly what has happened to you. But Happitec's enlightened employee policies mean you don't really care. After all, who needs money? Pick up your Happitec cheque, grab a bite of lunch, a cab to the airport and then you'll be living high on the hog at Happitec's expense. What a truly ">
	<ITALICIZE "enviable">
	<TELL " situation you find yourself in, ">
	<GENDER-PRINT "Ms " "Mr ">
	<PRINT-LAST-NAME>
	<TELL "." CR>>

<DEFINE ESTABLISH-EXCHANGES ("AUX" X Y Z)
	 <SET X <+ <ZRANDOM 791> 202>>
	 <SET Y .X>
	 <ZPUT ,PHONE-NUMBERS ,BANK-NUMBER-X .X>
	 <SET X <+ .X 1>>
	 <ZPUT ,PHONE-NUMBERS ,WORK-NUMBER-X .X>
	 <SET X <+ .X 1>>
	 <ZPUT ,PHONE-NUMBERS ,CAB-NUMBER-X .X>
	 <SET X <+ .X 1>>
	 <ZPUT ,PHONE-NUMBERS ,OBANK-NUMBER-X .X>
	 <SET X <+ .X 1>>
	 <ZPUT ,PHONE-NUMBERS ,OLD-FRIEND-X .X>
	 <SET X <+ .X 1>>
	 <ZPUT ,PHONE-NUMBERS ,NEW-FRIEND-X .X>
	 <SET Y <- .Y 1>>
	 <REPEAT ()
		 <SET Z <+ <ZRANDOM 797> 201>>
		 <COND (<OR <G? .Z .X>
			    <L? .Z .Y>>
			<RETURN>)>>
	 <ZPUT ,PHONE-NUMBERS ,OHOME-NUMBER-X .Z>
	 <SET Z <+ .Z 1>>
	 <ZPUT ,PHONE-NUMBERS ,OBANK-NUMBER-X .Z>>

<DEFINE INIT-STATUS-LINE ()
	 <SETG OLD-HERE <>>
	 <SETG OLD-LEN 0>
	 <SETG OLD-BP 0>
	 <SPLIT 1>
	 <SCREEN ,S-WINDOW>
	 <ZBUFOUT <>>
	 <CURSET 1 1>
	 <HLIGHT ,H-INVERSE>
	 <PRINT-SPACES ,WIDTH>
	 <COND (<L? ,WIDTH:FIX 64>
		<CURSET 1 <- ,WIDTH:FIX 11>>
		<TELL "BP:">)
	       (T
		<CURSET 1 <- ,WIDTH:FIX 23>>
		<TELL "Blood Pressure:">)>
	 <HLIGHT ,H-NORMAL>
	 <ZBUFOUT T>
	 <SCREEN ,S-TEXT>>

<OBJECT WALLS
	(LOC GLOBAL-OBJECTS)
	(DESC "wall")
	(FLAGS NODESC TOUCHED SURFACE)
	(SYNONYM WALL WALLS)
	(ACTION WALLS-F)>
	 
<DEFINE WALLS-F WALLS ()
	 <COND (<NOT <IS? ,HERE ,INDOORS>>
		<CANT-SEE-ANY ,WALLS>
		<RETURN ,FATAL-VALUE .WALLS>)
	       (<THIS-PRSI?>
		<COND (<VERB? PUT-ON PUT THROW THROW-OVER>
		       <PRSO-SLIDES-OFF-PRSI>
		       <RETURN T .WALLS>)
		      (T
		       <RETURN <> .WALLS>)>)
	       (<OR <GETTING-INTO?>
		    <VERB? LOOK-BEHIND LOOK-UNDER>>
		<IMPOSSIBLE>
		<RETURN T .WALLS>)
	       (<OR <HURTING?>
		    <MOVING?>>
		<TELL CTHEO>
		<TELL " isn't affected." CR>
		<RETURN T .WALLS>)
	       (<INTBL? ,PRSA ,TALKVERBS ,NTVERBS>
		<TELL "Talking to walls">
		<WONT-HELP>
		<RETURN ,FATAL-VALUE .WALLS>)>
	 <YOU-DONT-NEED ,WALLS>
	 ,FATAL-VALUE>

<OBJECT CEILING
	(LOC GLOBAL-OBJECTS)
	(FLAGS NODESC TOUCHED)
	(DESC "ceiling")
	(SYNONYM CEILING)
	(ACTION CEILING-F)>

<DEFINE CEILING-F ()
	 <COND (<NOT <IS? ,HERE ,INDOORS>>
		<CANT-SEE-ANY ,CEILING>
		,FATAL-VALUE)
	       (<VERB? LOOK-UNDER>
		<V-LOOK>
		T)
	       (T
		<>)>>

<OBJECT HANDS
	(LOC GLOBAL-OBJECTS)
	(DESC "your hand")
	(FLAGS TOOL MANUALLY NODESC TOUCHED NOARTICLE)
	(SYNONYM HAND HANDS PALM PALMS FINGER FINGERS THUMB THUMBS)
	(ADJECTIVE MY BARE)
	(SIZE 5)
      ; (VALUE 0)
	(ACTION HANDS-F)>
       
<DEFINE HANDS-F ()
	 <COND (<THIS-PRSI?>
		<COND (<VERB? TIE>
		       <WASTE-OF-TIME>
		       T)
		      (T
		       <>)>)
	       (<VERB? EXAMINE LOOK-ON>
		<TELL "Your fingers are still there." CR>		      
		T)
	       (<VERB? COUNT>
		<TELL "You have ">
		<COND (<NOUN-USED? ,W?FINGERS ,W?FINGER>
		       <TELL "ten">)
		      (T
		       <TELL "two">)>
		<ZPRINT ,PERIOD>
		T)
	       (<VERB? LOOK-INSIDE SEARCH>
		<V-INVENTORY>
		T)
	       (<AND <VERB? PUT PUT-ON>
		     <T? ,PRSI>>
		<PERFORM ,V?TOUCH ,PRSI>
		T)
	       (<HAVING?>
		<IMPOSSIBLE>
		T)
	       (T
		<>)>>

<OBJECT FEET
	(LOC GLOBAL-OBJECTS)
	(DESC "your foot")
	(FLAGS CLOTHING WORN NODESC NOARTICLE SURFACE)
	(SYNONYM FOOT FEET TOE TOES SNEAKER SNEAKERS)
	(ADJECTIVE MY)
	(SIZE 5)
      ; (VALUE 0)
	(ACTION FEET-F)>

"TOUCHED = flight described once."

<DEFINE FEET-F ()
	 <COND (<THIS-PRSI?>
		<COND (<PUTTING?>
		       <WASTE-OF-TIME>
		       T)
		      (T
		       <>)>)
	       (<VERB? PUT-ON>
		<PERFORM ,V?STAND-ON ,PRSI>
		T)
	       (<HAVING?>
		<IMPOSSIBLE>
		T)
	       (T
		<>)>>
			
<OBJECT MOUTH
	(LOC GLOBAL-OBJECTS)
	(DESC "your mouth")
	(SYNONYM MOUTH)
	(ADJECTIVE MY)
	(FLAGS NODESC NOARTICLE TOUCHED)
	(ACTION MOUTH-F)>

<DEFINE MOUTH-F MOUTH ()
	 <COND (<THIS-PRSI?>
		<COND (<VERB? PUT PUT-ON THROW>
		       <PERFORM ,V?EAT ,PRSO>
		       <RETURN T .MOUTH>)
		      (<VERB? TOUCH-TO>
		       <PERFORM ,V?TASTE ,PRSO>
		       <RETURN T .MOUTH>)>)
	       (<VERB? REACH-IN>
		<TELL "How rude." CR>
		<RETURN T .MOUTH>)
	       (<VERB? OPEN OPEN-WITH CLOSE>
		<NO-NEED>
		<RETURN T .MOUTH>)
	       (<VERB? ;RAPE KICK KISS>
		<TELL "Good luck." CR>
		<RETURN T .MOUTH>)
	       (<HAVING?>
		<IMPOSSIBLE>
		<RETURN T .MOUTH>)>
	 <YOU-DONT-NEED ,MOUTH>
	 ,FATAL-VALUE>

<OBJECT EYES
	(LOC GLOBAL-OBJECTS)
	(SDESC SDESC-EYES)
	(FLAGS NODESC NOARTICLE TOUCHED NEEDS-IDENTITY SURFACE)
	(OBJ-NOUN 0)
	(SYNONYM EYES HEAD)
	(ADJECTIVE MY)
	(ACTION EYES-F)>

<DEFINE SDESC-EYES ()
  <TELL "your ">
  <ZPRINTB <GETP ,EYES ,P?OBJ-NOUN>>>

"SEEN = given PRE-DUMB-EXAMINE admonishment."

<DEFINE EYES-F EYES ()
	 <COND (<==? <GETP ,EYES ,P?OBJ-NOUN> ,W?EYES>
		<COND (<THIS-PRSI?>
		       <RETURN T .EYES>)
		      (<VERB? OPEN>
		       <TELL "They are." CR>
		       <RETURN T .EYES>)
		      (<VERB? CLOSE>
		       <V-SLEEP>
		       <RETURN T .EYES>)>)>
	 <COND (<HAVING?>
		<IMPOSSIBLE>
		T)
	       (T
		<YOU-DONT-NEED ,EYES>
		,FATAL-VALUE)>>

<OBJECT ME
        (LOC GLOBAL-OBJECTS)
	(SYNONYM I ME MYSELF BODY)
	(ADJECTIVE MY)
	(DESC "yourself")
	(FLAGS PERSON LIVING TOUCHED NOARTICLE)
	(ACTION ME-F)>

<DEFINE ME-F ("OPTIONAL" (CONTEXT <>) "AUX" OBJ NXT (ANY <>)) 
	 <COND (<THIS-PRSI?>
		<COND (<VERB? THROW THROW-OVER>
		       <WASTE-OF-TIME>
		       T)
		      (<VERB? COVER>
		       <PERFORM ,V?STAND-ON ,PRSO>
		       T)
		      (<VERB? PUT-ON WRAP-AROUND>
		       <COND (<IS? ,PRSO ,CLOTHING>
			      <PERFORM ,V?WEAR ,PRSO>)
			     (T
			      <IMPOSSIBLE>)>
		       T)
		      (<VERB? PUT>
		       <PERFORM ,V?TASTE ,PRSO>
		       T)
		      (T
		       <>)>)
	       (<VERB? EXAMINE LOOK-ON SEARCH>
		<TELL "You're ">
		<SET OBJ <FIRST? ,PLAYER>>
		<REPEAT ()
			<COND (<ZERO? .OBJ>
			       <RETURN>)>
			<SET NXT <NEXT? .OBJ>>
			<COND (<IS? .OBJ ,WORN>
			       <SET ANY T>
			       <MOVE .OBJ ,WEARING>)>
			<SET OBJ .NXT>>
		<COND (<ZERO? .ANY>
		       <TELL "not wearing anything special." CR>)
		      (T
		       <TELL "wearing ">
		       <PRINT-CONTENTS ,WEARING>
		       <ZPRINT ,PERIOD>
		       <MOVE-ALL ,WEARING ,PLAYER>)>
		T)
	       (<VERB? LISTEN SMELL>
		<TELL ,CANT "help doing that." CR>
		T)
	       (<VERB? FIND FOLLOW>
	        <TELL "You're right here." CR>
		T)
	       (<VERB? ;RAPE KISS>
		<TELL "Desperate?" CR>
		T)
	       (<VERB? KILL>
		<TELL "You're indispensable." CR>
		T)
	       (<HURTING?>
		<TELL "Punishing " D ,ME " that way">
		<WONT-HELP>
		T)
	       (<YOU-F>
		T)
	       (T
		<>)>>

<OBJECT YOU
	(LOC GLOBAL-OBJECTS)
	(DESC "myself")
	(SYNONYM YOU YOURSELF)
	(FLAGS NODESC NOARTICLE)
	(ACTION YOU-F)>
	       
<DEFINE YOU-F ()
	 <COND (<VERB? WHO WHAT WHERE>
		<TELL "Good question." CR>
		T)
	       (<VERB? UNDRESS>
		<INAPPROPRIATE>
		T)
	       (<OR <VERB? EAT TASTE DRINK DRINK-FROM>
		    <HAVING?>>
		<IMPOSSIBLE>
		T)
	       (T
		<>)>>

<OBJECT CLOTHES
	(LOC GLOBAL-OBJECTS)
	(DESC "your clothes")
	(SYNONYM CLOTHES CLOTHING APPAREL OUTFIT SHORTS)
	(ADJECTIVE MY)
	(FLAGS WORN CLOTHING NODESC NOARTICLE)
	(ACTION CLOTHES-F)>

<DEFINE CLOTHES-F ()
	 <COND (<VERB? EXAMINE LOOK-ON>
		<PERFORM ,V?EXAMINE ,ME>
		T)
	       (<VERB? LOOK-INSIDE>
		<PERFORM ,V?LOOK-INSIDE ,POCKET>
		T)
	       (<AND <VERB? PUT>
		     <PRSI? CLOTHES>>
		<TELL "[in " D ,POCKET ,BRACKET>
		<PERFORM ,V?PUT ,PRSO ,POCKET>
		T)
	       (<VERB? WEAR>
		<YOURE-ALREADY "wearing them">
		T)
	       (<VERB? TAKE-OFF DROP RAISE>
		<INAPPROPRIATE>
		T)
	       (T
		<>)>>

<OBJECT THEM
	(LOC GLOBAL-OBJECTS)
	(SYNONYM THEY THEM THEMSELVES)
	(DESC "them")
	(FLAGS NOARTICLE)>

<OBJECT INTDIR
	(LOC GLOBAL-OBJECTS)
	(DESC "direction")
	(SYNONYM DIRECTION)
	(ADJECTIVE NORTH EAST SOUTH WEST W ; "NE NW SE SW" UP DOWN)>

<OBJECT GROUND
	(LOC GLOBAL-OBJECTS)
	(SDESC SDESC-GROUND)
	(OBJ-NOUN 0)
	(SYNONYM SURFACE GROUND GROUNDS EARTH FLOOR)
        (FLAGS NODESC NEEDS-IDENTITY)
	(ACTION GROUND-F)>

<DEFINE SDESC-GROUND ("AUX" FOO)
  <COND (<N==? <SET FOO <GETP ,GROUND ,P?OBJ-NOUN>> ,W?FLOOR>
	 <TELL "ground">)
	(T
	 <ZPRINTB .FOO>)>>

<DEFINE GROUND-PRINT-CONTENTS-TEST (OBJ)
  <COND (<AND <T? <STD-PRINT-CONTENTS-TEST .OBJ>>
	      <IS? .OBJ ,TAKEABLE>> T)
	(T <>)>>

<DEFINE GROUND-F GROUND ("AUX" OBJ NXT SOMETHING)
	 <COND (<==? <GETP ,GROUND ,P?OBJ-NOUN> ,W?FLOOR>
		<COND (<NOT <IS? ,HERE ,INDOORS>>
		       <CANT-SEE-ANY ,GROUND>
		       <RETURN ,FATAL-VALUE .GROUND>)>)>
	 <COND (<THIS-PRSI?>
		<COND (<VERB? PUT-ON PUT THROW THROW-OVER EMPTY-INTO>
		       <PERFORM ,V?DROP ,PRSO>
		       T)
		      (T
		       <>)>)
	       (<VERB? EXAMINE LOOK-ON SEARCH>
		<TELL ,YOU-SEE>
		<SET SOMETHING <PRINT-CONTENTS ,HERE
					       ,GROUND-PRINT-CONTENTS-TEST>>
		<TELL " on the " D ,GROUND ,PERIOD>
		T)
	       (<VERB? CROSS>
		<V-WALK-AROUND>
		T)
	       (T
		<>)>>

<OBJECT POCKET
	(LOC PLAYER)
	(DESC "your pocket")
	(SYNONYM POCKET POCKETS)
	(ADJECTIVE MY SIDE YOUR)
	(FLAGS NODESC NOARTICLE CONTAINER OPENED SEARCH-ME)
	(SIZE 0)
	(CAPACITY 4)
	(CONTFCN IN-POCKET)
	(ACTION POCKET-F)>

<DEFINE POCKET-F ("AUX" OBJ)
	 <COND (<THIS-PRSI?>
		<COND (<AND <VERB? PUT>
		            <G? <GETP ,PRSO ,P?SIZE>:FIX 3>>
		       <TELL CTHEO " is too big to fit in " 
				    D ,PRSI ,PERIOD>
		       T)
		      (T
		       <>)>)
	       (<VERB? EXAMINE LOOK-INSIDE SEARCH>
		<SET OBJ <FIRST? ,PRSO>>
		<COND (<T? .OBJ>
		       <TELL "You have ">
		       <PRINT-CONTENTS ,PRSO>)		      
		      (T
		       <TELL "There's nothing">)>
		<TELL " in " D ,PRSO ,PERIOD>
		T)
	       (<VERB? EMPTY>
		<TELL "[into " D ,HANDS "s" ,BRACKET>
		<>)
	       (<VERB? OPEN OPEN-WITH CLOSE>
		<NO-NEED>
		T)
	       (<HAVING?>
		<TELL ,CANT "do that to " D ,PRSO ,PERIOD>
		T)
	       (T
		<>)>>
  
<DEFINE IN-POCKET ("OPTIONAL" (CONTEXT <>) "AUX" THING OPRSO)
	 <COND (<NOT <EQUAL? .CONTEXT ,M-CONT>>
		<>)
	       (<VERB? TAKE> <>)
	       (T
		<COND (<THIS-PRSI?> <SET THING ,PRSI>)
		      (T <SET THING ,PRSO>)>
		<SET OPRSO ,PRSO>
		<SETG PRSO .THING>
		<TELL "[Taking " THEO " first" ,BRACKET>
		<COND (<ITAKE>
		       <SETG PRSO .OPRSO>
		       <>)
		      (T
		       <SETG PRSO .OPRSO>
		       ,FATAL-VALUE)>)>>

"WINDOW [table] [left-margin], where [table] is a global PLTABLE
 with the 1st element = width of window, followed by strings (0 for blank).
 If [left-margin] is not specified, window is centered."

; "Used for optional arguments to WINDOW..."
<CONSTANT EXTRA-TEXT <ITABLE 3 <>>>

<DEFINE WINDOW WINDOW (TABLE "OPTIONAL" (S1 <>) (S2 <>) (S3 <>)
		       (STLINE 4)
		       "AUX" MARGIN (Y .STLINE) (I 2) W:FIX LINES:FIX
		       	     STR PLINES
			     (CT:FIX 0) (ET ,EXTRA-TEXT) SP:FIX)
	 <ZPUT .ET 0 .S1>
	 <ZPUT .ET 1 .S2>
	 <ZPUT .ET 2 .S3>
	 <SET LINES <ZGET .TABLE 0>>
	 <SET PLINES .LINES>
	 <SET W <ZGET .TABLE 1>>
	 <SET MARGIN </ <- ,WIDTH:FIX .W> 2>>	; "Center"
	 <SPLIT <+ .LINES .STLINE>> ; "Set up the window."
	 <SCREEN ,S-WINDOW>
	 <ZBUFOUT <>>
	 <HLIGHT ,H-INVERSE>
	 
	 <CURSET .Y .MARGIN>
	 <PRINT-SPACES .W>
	 
	 <REPEAT ()
		 <SET Y <+ .Y 1>>
		 <CURSET .Y .MARGIN>
		 <SET LINES <- .LINES 1>>
		 <COND (<ZERO? .LINES>
			<PRINT-SPACES .W>
			<RETURN>)>
		 <SET STR <ZGET .TABLE .I>>
		 <COND (<ZERO? .STR>
			<COND (<SET STR <ZGET .ET .CT>>
			       <SET SP <- .W <GETB .STR 0>:FIX>>
			       ; "Number of spaces needed"
			       <PRINT-SPACES </ .SP 2>>
			       ; "Print half"
			       <DUMP-LTABLE .STR>
			       <SET CT <+ .CT 1>>
			       <PRINT-SPACES <- .SP </ .SP 2>>>)
			      (T
			       <PRINT-SPACES .W>)>)
		       (T
			<PRINTC 32>
			<TELL .STR>
			<PRINTC 32>)>
		 <SET I <+ .I 1>>>
	 
	 <HLIGHT ,H-NORMAL>
	 <ZBUFOUT T>
	 <SCREEN ,S-TEXT>
	 <SPLIT 1>

       ; "Send window to printer."
	
	 <DIROUT ,D-SCREEN-OFF>
	 <SET I 2>
	 <SET CT 0>
	 <ZCRLF>
	 <TELL "[">
	 <REPEAT ()
		 <SET PLINES <- .PLINES 1>>
		 <COND (<ZERO? .PLINES>
			<RETURN>)>
		 <SET STR <ZGET .TABLE .I>>
		 <COND (<NOT <ZERO? .STR>>
			<COND (<NOT <EQUAL? .I 2>>
			       <PRINTC 32>)>
			<TELL .STR>)
		       (<SET STR <ZGET .ET .CT>>
			<SET CT <+ .CT 1>>
			<PRINT-SPACES </ <- .W <GETB .STR 0>:FIX> 2>>
			<DUMP-LTABLE .STR>)>
		 <COND (<EQUAL? .PLINES 1>
			<TELL "]">)>
		 <ZCRLF>
		 <SET I <+ .I 1>>>
	 <ZCRLF>
	 <DIROUT ,D-SCREEN-ON>
	 T>

<OBJECT SOUNDS
	(LOC GLOBAL-OBJECTS)
	(DESC "sound")
	(FLAGS NODESC)
	(SYNONYM SOUND SOUNDS)
	(GENERIC GENERIC-SOUND)
	(ACTION SOUND-F)>

<DEFINE GENERIC-SOUND (TBL "AUX" (LEN <ZGET .TBL 0>))
  <COND (<==? .LEN 2>
	 <COND (<==? <ZGET .TBL 1> ,SOUNDS>
		<ZGET .TBL 2>)
	       (<==? <ZGET .TBL 2> ,SOUNDS>
		<ZGET .TBL 1>)
	       (T <>)>)
	(T <>)>>

<DEFINE SOUND-F ("AUX" X)
	 <SET X <GETP ,HERE ,P?HEAR>>
	 <COND (<T? .X>
		<COND (<ZERO? ,NOW-PRSI?>
		       <PERFORM ,PRSA .X ,PRSI>)
		      (T
		       <PERFORM ,PRSA ,PRSO .X>)>
		T)
	       (<OR <SEEING?>
		    <TOUCHING?>>
		<IMPOSSIBLE>		       
		T)
	       (T
		<>)>>

<OBJECT CORNER
	(LOC GLOBAL-OBJECTS)
	(DESC "corner")
	(FLAGS NODESC SURFACE)
	(SYNONYM CORNER CORNERS)
	(ACTION CORNER-F)>

<DEFINE CORNER-F ()
	 <COND (<NOT <IS? ,HERE ,INDOORS>>
		<CANT-SEE-ANY ,CORNER>
		,FATAL-VALUE)
	       (<VERB? EXAMINE LOOK-INSIDE SEARCH LOOK-BEHIND LOOK-UNDER>
		<V-LOOK>
		T)
	       (<ENTERING?>
		<YOURE-ALREADY "close enough to the " <>>
		<TELL D ,CORNER ,PERIOD>
		T)
	       (<EXITING?>
		<V-WALK-AROUND>
		T)
	       (<PUTTING?>
		<PERFORM ,V?DROP ,PRSO>
		T)
	       (T
		<>)>>
;<OBJECT RIGHT
	(LOC GLOBAL-OBJECTS)
	(DESC "that direction")
	(FLAGS NODESC NOARTICLE)
	(SYNONYM RIGHT CLOCKWISE FORWARD AHEAD)
	(ACTION RL-F)>

;<OBJECT LEFT
	(LOC GLOBAL-OBJECTS)
	(DESC "that direction")
	(FLAGS NODESC NOARTICLE)
	(SYNONYM LEFT COUNTERCL BACKWARD BACKWARDS BACK)
	(ACTION RL-F)>

;<DEFINE RL-F ()
	 <COND (<OR <ENTERING?>
		    <VERB? EXIT LEAVE ESCAPE CLIMB-UP CLIMB-DOWN CLIMB-ON
			   CLIMB-OVER CROSS STAND-ON STAND-UNDER>>
		<V-WALK-AROUND>
		T)
	       (T
		<>)>>

<DEFINE SPECIFY-AN-AMOUNT ()
  <TELL "You must specify an amount of money.">>

<DEFINE LOOK-IN-PACKAGE ()
	 <TELL ,THIS-IS "the same " D ,PRSO
" included (at the last minute and at great expense) in your ">
	 <ITALICIZE "Bureaucracy">
	 <TELL " package." CR>
	 T>

