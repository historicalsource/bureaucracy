"VERBS for BUREAUCRACY: (C)1987 Infocom, Inc. All Rights Reserved."

<FILE-FLAGS MDL-ZIL?>

<INCLUDE "COMPUTERDEFS" "OLD-PARSERDEFS" "XXJETDEFS">

<DEBUGGING-CODE
 <ROUTINE V-$CHEAT ("AUX" X)
	 <COND (<PRSO? INTNUM>
		<COND (<ZERO? ,P-NUMBER>
		       <SHOW-FIELDS>)
		      (<EQUAL? ,P-NUMBER 1>
		       <VISIT-AIRPORT>)
		      (<EQUAL? ,P-NUMBER 2 22>
		       <COND (<==? ,P-NUMBER 22>
			      <MOVE ,COMPUTER ,PLAYER>
			      <MOVE ,RECIPE ,PLAYER>
			      <MOVE ,MONEY ,PLAYER>)>
		       <GO-TO-PLANE>)
		      (<==? ,P-NUMBER 3>
		       <MOVE ,CHUTE ,PLAYER>
		       <UNMAKE ,CHUTE ,TRANSPARENT>
		       <MAKE ,CHUTE ,OPENED>
		       <MOVE ,COMPUTER ,PLAYER>
		       <MOVE ,RECIPE ,PLAYER>
		       <MOVE ,MONEY ,PLAYER>
		       <GOTO ,IN-TREE <> T>)
		      (<==? ,P-NUMBER 4>
		       <DEQUEUE I-NERD>
		       <SETG HERE ,INNER-ROOM>
		       <MOVE ,COMPUTER ,PLAYER>
		       <MOVE ,PLAYER ,HERE>
		       <INNER-ROOM-F ,M-ENTERING>)>)
	       (T
		<DONT-UNDERSTAND>)>
	 T>>

<DEFINE V-BAD-DIRECTION ()
	 <PCLEAR>
	 <TELL "[" ,DONT "need to use that " D ,INTDIR
	       " to finish this story.]" CR>>

<DEFINE V-$REFRESH ()
	 <CLEAR -1>
	 <INIT-STATUS-LINE>
	 T>

;<SETG VERBOSITY 1> "0 = super, 1 = brief, 2 = verbose."

<DEFINE V-VERBOSE ()
	 <COND (<WRONG-WINNER?>
		,FATAL-VALUE)
	       (T
		<SETG VERBOSITY 2>
		<TELL "[Maximum verbosity." ,BRACKET>
		<V-LOOK>
		T)>>

<DEFINE V-BRIEF ()
	 <COND (<WRONG-WINNER?>
		,FATAL-VALUE)
	       (T
		<SETG VERBOSITY 1>
		<TELL "[Brief descriptions.]" CR>
		T)>>

<DEFINE V-SUPER-BRIEF ()
	 <COND (<WRONG-WINNER?>
		,FATAL-VALUE)
	       (T
		<SETG VERBOSITY 0>
		<TELL "[Superbrief descriptions." ,BRACKET>
		T)>>

<DEFINE V-DIAGNOSE ()
	 <COND (<WRONG-WINNER?>
		,FATAL-VALUE)
	       (<MEAL-EATEN?>
		<TELL "How do you expect to feel after eating that stuff?" CR>)
	       (T
		<TELL 
"You feel much as you'd expect, considering the way you're living."
		 CR>
		T)>>

<OBJECT WEARING>

<DEFINE V-INVENTORY ("AUX" (P? <>) (WORN? <>) OBJ NXT OLDIT)
	 <COND (<WRONG-WINNER?>
		,FATAL-VALUE)
	       (T
		<SET OLDIT ,P-IT-OBJECT>
		<SET P? <FIRST? ,POCKET>>
		<ZREMOVE ,POCKET>
		; "Move all worn objects to WEARING for separate sentence."
		<SET OBJ <FIRST? ,PLAYER>>
		<REPEAT ()
		  <COND (<ZERO? .OBJ>
			 <RETURN>)>
		  <SET NXT <NEXT? .OBJ>>
		  <COND (<IS? .OBJ ,WORN>
			 <SET WORN? T>
			 <MOVE .OBJ ,WEARING>)>
		  <SET OBJ .NXT>>
		<SET OBJ <FIRST? ,PLAYER>>
		<TELL "You're ">
		<COND (<T? .OBJ>
		       <TELL "holding ">
		       <PRINT-CONTENTS ,PLAYER>
		       ;<REPEAT ()
			       <COND (<AND <SEE-INSIDE? .OBJ>
					   <SEE-ANYTHING-IN? .OBJ>>
				      <TELL ". ">
				      <COND (<AND <IS? .OBJ ,SURFACE>
						  <N==? .OBJ ,ENVELOPE>>
					     <TELL "On ">)
					    (T
					     <TELL "Inside ">)>
				      <TELL THE .OBJ " you see ">
				      <PRINT-CONTENTS .OBJ>)>
			       <SET OBJ <NEXT? .OBJ>>
			       <COND (<ZERO? .OBJ>
				      <RETURN>)>>
		       <TELL ". You">
		       <COND (<T? .WORN?>
			      <TELL "'re wearing ">
			      <PRINT-CONTENTS ,WEARING>
			      <COND (<T? .P?>
				     <TELL ", and you have ">)
				    (T
				     <TELL ". Your ">)>)
			     (<T? .P?>
			      <TELL " also have ">)
			     (T
			      <TELL "r ">)>)
		      (T
		       <TELL "not holding anything, ">
		       <COND (<T? .WORN?>
			      <TELL "but you're wearing ">
			      <PRINT-CONTENTS ,WEARING>
			      <TELL ". You">
			      <COND (<T? .P?>
				     <TELL " also have ">)
				    (T
				     <TELL "r ">)>)
			     (<T? .P?>
			      <TELL "but you have ">)
			     (T
			      <TELL "and your ">)>)>
		<COND (<T? .P?>
		       <PRINT-CONTENTS ,POCKET>
		       <TELL " in " D ,POCKET>)
		      (T
		       <TELL "pocket is empty">)>
		<TELL ,PERIOD>
		<MOVE-ALL ,WEARING ,PLAYER>
		<MOVE ,POCKET ,PLAYER>	 
		<SETG P-IT-OBJECT .OLDIT>
		T)>>

<DEFINE SAY-SURE ()
	 <TELL "Are you sure you want to ">>

<DEFINE V-QUIT QUIT ("OPTIONAL" (ASK? T) "AUX" SCOR WRD)
	 <COND (<WRONG-WINNER?>
		<RETURN ,FATAL-VALUE .QUIT>)>
	 <V-SCORE>
	 <COND (<T? .ASK?>
		<ZCRLF>
		<SAY-SURE>
		<TELL "leave the story now?">
		<COND (<YES?>
		       <ZCRLF>
		       <QUIT>)
		      (T
		       <TELL CR "[Continuing.]" CR>)>)
	       (T
		<PROG ()
		  <TELL CR "RESTORE, RESTART, or QUIT?|
>>">
		  <ZREAD ,P-INBUF ,P-LEXV>
		  <COND (<OR <0? <GETB ,P-LEXV ,P-LEXWORDS>>
			     <EQUAL? <SET WRD <ZGET ,P-LEXV ,P-LEXSTART>>
				    ,W?QUIT ,W?Q>>
		         <QUIT>)
		        (<==? .WRD ,W?RESTART>
		         <RESTART>
			 <FAILED "RESTART">
			 <AGAIN>)
			(<==? .WRD ,W?RESTORE>
			 <COND (<F? <DO-RESTORE>>
				<AGAIN>)>)
			(T
			 <QUIT>)>>)>
	 T>
		      
<DEFINE V-RESTART ()
	 <COND (<WRONG-WINNER?>
		,FATAL-VALUE)
	       (T
		<V-SCORE>
		<ZCRLF>
		<SAY-SURE>
		<TELL "restart the story?">
		<COND (<YES?>
		       <RESTART>
		       <FAILED "RESTART">)>
		T)>>

<CONSTANT YES-INBUF <ITABLE BYTE 12>>
<CONSTANT YES-LEXV <ITABLE BYTE 10>>

<DEFINE YES? YES ("AUX" WORD)
	 <SAID-YES? <> "[Please type YES or NO.] >">>

<DEFINE SAID-YES? YES (STR "OPT" (P <>) "AUX" WORD)
	 <REPEAT ()
		 <TELL CR>
		 <COND (<F? .P> <TELL ">>">)
		       (T <TELL .P>)>
		 <PUTB ,YES-LEXV 0 4>
	         <ZREAD ,YES-INBUF ,YES-LEXV>
	         <SET WORD <ZGET ,YES-LEXV ,P-LEXSTART>>
	         <COND (<ZERO? <GETB ,YES-LEXV ,P-LEXWORDS>>
		        T)
	               (<T? .WORD>
			<COND (<YES-USED? .WORD>
		               <RETURN T .YES>)
	                      (<NO-USED? .WORD>
		               <RETURN  <> .YES>)>)>
		 <COND (<T? .STR> <TELL .STR CR>)
		       (T <RETURN <> .YES>)>>>

<DEFINE YES-USED? (WORD)
	 <COND (<OR <EQUAL? .WORD ,W?Y ,W?YES ,W?YUP>
		    <EQUAL? .WORD ,W?OKAY ,W?OK ,W?AYE>
		    <EQUAL? .WORD ,W?SURE ,W?AFFIRMATIVE ,W?POSITIVE>
		    <EQUAL? .WORD ,W?YEAH>>
		T)
	       (T
		<>)>>

<DEFINE NO-USED? (WORD)
	 <COND (<OR <EQUAL? .WORD ,W?N ,W?NO ,W?NOPE>
		    <EQUAL? .WORD ,W?NAY ,W?NAW ,W?NEGATIVE>>
		T)
	       (T
		<>)>>

<DEFINE V-RESTORE ("AUX" X)
	 <COND (<WRONG-WINNER?>
		,FATAL-VALUE)
	       (T
		<DO-RESTORE>
		T)>>

<DEFINE DO-RESTORE ("AUX" X)
  <SETG OLD-HERE <>>
  <SETG OLD-LEN 0>
  <SET X <ZRESTORE>>
  <COND (<ZERO? .X>
	 <FAILED "RESTORE">
	 <>)
	(T T)>>

<DEFINE V-SAVE SAVE ("AUX" X)
	 <COND (<WRONG-WINNER?>
		<RETURN ,FATAL-VALUE .SAVE>)>
	 <PCLEAR>
	 <SETG OLD-HERE <>>
	 <SETG OLD-LEN 0>
	 <PUTB ,OOPS-INBUF 1 0> ; "Retrofix #50"
	 <SET X <ZSAVE>>
	 <COND (<ZERO? .X>
	        <FAILED "SAVE">
		<RETURN ,FATAL-VALUE .SAVE>)
	       (<EQUAL? .X 1>
		<COMPLETED "SAVE">
		<RETURN ,FATAL-VALUE .SAVE>)>
	 <COMPLETED "RESTORE">
	 <ZCRLF>
	 <V-LOOK>
	 ,FATAL-VALUE>

<DEFINE COMPLETED (STR)
	 <TELL CR "[" .STR " completed.]" CR>
	 <INIT-STATUS-LINE>	 	 
	 <COND (<ZERO? ,VERBOSITY>
		<ZCRLF>)>
	 T>

<DEFINE FAILED (STR)
	 <TELL CR "[" .STR " failed.]" CR>
	 <INIT-STATUS-LINE>
	 <COND (<ZERO? ,VERBOSITY>
		<ZCRLF>)>
	 T>

<DEFINE GET-SYSTOLIC ()
  </ <ANDB </ ,BP:FIX 2> *77777*> </ ,SYSTOLIC-SHIFT 2>>>

<SETG SCORE 0>

<MSETG MAX-GAME-SCORE 21>

<GDECL (SCORE) FIX>

<DEFINE V-SCORE SCORE ("AUX" SYSTOLIC:FIX)
	 <COND (<WRONG-WINNER?>
		<RETURN ,FATAL-VALUE .SCORE>)>
	 <TELL "[Your blood pressure is ">
	 <SAY-BP>
	 <TELL ", in " N ,MOVES " move">
	 <COND (<NOT <EQUAL? ,MOVES 1>>
		<TELL "s">)>
	 <TELL ". Your status is ">
	 <SET SYSTOLIC <GET-SYSTOLIC>>
	 <COND (<0? .SYSTOLIC>
		<TELL "Defunct">)
	       (<L? .SYSTOLIC 105>
		<TELL "Sleepy">)
	       (<L? .SYSTOLIC 115>
		<TELL "Calm">)
	       (<L? .SYSTOLIC 125>
		<TELL "Stable">)
	       (<L? .SYSTOLIC 130>
		<TELL "Annoyed">)
	       (<L? .SYSTOLIC 135>
		<TELL "Angry">)
	       (<L? .SYSTOLIC 139>
		<TELL "Really Pissed Off">)
	       (T
		<TELL "Livid">)>
	 <TELL ". Your score is " N ,SCORE
	       " out of a possible " N ,MAX-GAME-SCORE
	       ", making you a ">
	 <COND (<==? ,SCORE ,MAX-GAME-SCORE>
		<TELL "Bureaucrat">)
	       (T
		<TELL "Victim">)>
	 <TELL ".]" CR>
	 T> 

<SETG DO-SCORE? 0> "0 = not offered, 1 = on, 2 = off."

<DEFINE V-NOTIFY NOTIFY ()
	 <COND (<WRONG-WINNER?>
		<RETURN ,FATAL-VALUE .NOTIFY>)
	       (<L? ,DO-SCORE?:FIX 2>
		<SETG DO-SCORE? 2>)
	       (T
		<SETG DO-SCORE? 1>)>
	 <TELL "[Score notification o">
	 <COND (<EQUAL? ,DO-SCORE? 2>
		<TELL "ff">)
	       (T
		<TELL "n">)>
	 <TELL ".]" CR>
	 T>

<SETG LAST-BP-CHANGE 0>

; "Because five extra points if go through complex"
<MSETG SCORE-LEV-1 19>
<MSETG SCORE-LEV-2 14>
<MSETG SCORE-LEV-3 11>
<MSETG SCORE-LEV-4 8>
<MSETG SCORE-LEV-5 5>

<DEFINE UPDATE-SCORE (AMT:FIX "OPT" (CR T))
  <SETG SCORE <+ ,SCORE .AMT>>
  <SAY-SCORE-UPDATE "score" .CR>>

<DEFINE SAY-SCORE-UPDATE (WHICH CR "OPT" (DOWN? <>))
  <COND (<==? ,DO-SCORE? 2> <>)
	(T
	 <COND (<T? .CR> <ZCRLF>)>
	 <HLIGHT ,H-BOLD>
	 <TELL "[Your " .WHICH " just went ">
	 <COND (<T? .DOWN?> <TELL "down">)
	       (T <TELL "up">)>
	 <TELL ".]">
	 <HLIGHT ,H-NORMAL>
	 <ZCRLF>
	 <SOUND 1>
	 T)>>

<DEFINE UPDATE-BP UPDATE ("OPTIONAL" (FACTOR:FIX 1) (CR T) (DECAY? <>)
			  "AUX" (SYSTOLIC:FIX <GET-SYSTOLIC>)
				(DIASTOLIC:FIX <ANDB ,BP *377*>)
				(ALREADY-NORMAL? <>))
	 <COND (<ZERO? .FACTOR>		    	    
		<RETURN <> .UPDATE>)>
         <SETG BP-DELAY ,DELAY-FACTOR>
	 <COND (<AND <G=? .SYSTOLIC 119>
		     <L=? .SYSTOLIC 121>>
		<SET ALREADY-NORMAL? T>)>
	 <COND (<AND <G? .FACTOR 0>
		     <G? ,LAST-BP-CHANGE:FIX 0>>
		<SET FACTOR <+ .FACTOR ,LAST-BP-CHANGE:FIX>>)>
	 <SETG LAST-BP-CHANGE .FACTOR>
	 <COND (<G? <SET SYSTOLIC <+ .SYSTOLIC .FACTOR>> 255>
		<SET SYSTOLIC 250>)>
	 <SET DIASTOLIC <+ 80 </ <- .SYSTOLIC 120> 2>>>
	 <SETG BP <ORB <* .SYSTOLIC ,SYSTOLIC-SHIFT>
		       .DIASTOLIC>>
	 <COND (.DECAY?
		<COND (<AND <G=? .SYSTOLIC 119>
			    <L=? .SYSTOLIC 121>>
		       ; "Back to normal"
		       <SETG BP <ORB <* 120 ,SYSTOLIC-SHIFT>
				     80>>
		       <COND (<NOT .ALREADY-NORMAL?>
			      <COND (<T? .CR> <ZCRLF>)>
			      <TELL "You're beginning to feel normal again.">
			      <COND (<T? .CR> <ZCRLF>)>)>
		       <RETURN T .UPDATE>)
		      (T
		       <RETURN <> .UPDATE>)>)
	       (<AND <G? .SYSTOLIC 230>
		     <G? .DIASTOLIC 130>>
		<COND (<T? .CR>
		       <ZCRLF>)>
		<TELL "Your blood pressure soars to ">
		<SAY-BP>
		<TELL 
", causing a small vessel in your brain to rupture. You sink into coma and die without pain.">
		<JIGS-UP>
		<RETURN T .UPDATE>)
	       (<L=? .SYSTOLIC 96>
		<COND (<T? .CR>
		       <ZCRLF>)>
		<TELL 
"Your blood pressure drops to a level too low to sustain higher brain activities, and you fall asleep." CR>
		<CARRIAGE-RETURNS>
		<SETG BP <ORB <* 120 ,SYSTOLIC-SHIFT> 80>>
		<TELL "You wake up refreshed and invigorated" ,PCR>
		<V-LOOK>
		<RETURN T .UPDATE>)>
	 <SAY-SCORE-UPDATE "blood pressure" .CR
			   <COND (<L? .FACTOR 0> T) (T <>)>>>

<DEFINE V-TIME ()
	 <COND (<WRONG-WINNER?>
		,FATAL-VALUE)
	       (<VISIBLE? ,WRISTWATCH>
		<TELL "Your " D ,WRISTWATCH " says it's ">
	        <TELL-TIME>
	        <TELL ,PERIOD>
	        T)
	       (T
		<TELL "There aren't any clocks visible." CR>
		T)>>

<DEFINE TELL-TIME ("AUX" H (PM? <>))
	 <TELL <ZGET ,DAY-TABLE <ZGET ,DAY-TABLE 0>> "day, ">
	 <COND (<G? ,HOURS:FIX 11>
		<SET PM? T>)>
	 <COND (<G? ,HOURS:FIX 12>
		<SET H <- ,HOURS:FIX 12>>)
	       (<ZERO? ,HOURS:FIX>
		<SET H 12>)
	       (T
		<SET H ,HOURS:FIX>)>
	 <TELL N .H ":">
	 <COND (<L? ,MINUTES:FIX 10>
		<TELL "0">)>
	 <TELL N ,MINUTES>
	 <COND (<T? .PM?>
		<TELL " pm">)
	       (T
		<TELL " am">)>
	 T>

<DEFINE V-SCRIPT ()
         <COND (<WRONG-WINNER?>
	       	,FATAL-VALUE)
	       (T
		<TELL "[Scripting on.]" CR>
		<DIROUT ,D-PRINTER-ON>
		<TRANSCRIPT "begin">	 
		T)>>

<DEFINE V-UNSCRIPT ()
	 <COND (<WRONG-WINNER?>
	        ,FATAL-VALUE)
	       (T
		<TRANSCRIPT "end">
		<DIROUT ,D-PRINTER-OFF>
		<TELL "[Scripting off.]" CR>
		T)>>

<DEFINE TRANSCRIPT (STR)
	 <DIROUT ,D-SCREEN-OFF>
	 <TELL CR "Here " .STR "s a transcript of interaction with" CR>
	 <V-VERSION>
	 <DIROUT ,D-SCREEN-ON>
	 T>

<DEFINE V-VERSION VERSION ("AUX" (CNT 17) V)
	 <COND (<WRONG-WINNER?>
		<RETURN ,FATAL-VALUE .VERSION>)>
	 <HLIGHT ,H-BOLD>
	 <TELL CR "BUREAUCRACY" CR>
	 <HLIGHT ,H-NORMAL>
	 <TELL "A Paranoid Fantasy" CR>
	 <COPYRIGHT>
	 <ZCRLF>
	 <TRADEMARK>
	 <ZCRLF>
	 <V-$ID>
	 <RELEASE>
	 <TELL " / ">
	 <LICENSE>
	 <ZCRLF>
	 T>
 		
<DEFINE LICENSE ("AUX" (CNT 17))
	 <TELL "Licence Number ">
	 <LOWCORE-TABLE SERIAL 6 PRINTC>
	 T>

<DEFINE RELEASE ("AUX" V)
	 <SET V <BAND <LOWCORE ZORKID> *3777*>>
	 <TELL "Release " N .V>
	 <DEBUGGING-CODE <TELL  " for Internal Testing">>
	 T>

<DEFINE COPYRIGHT ()
	 <HLIGHT ,H-NORMAL>
	 <TELL "Copyright (C) 1987 Infocom, Inc. All rights reserved.">
	 T>

<DEFINE TRADEMARK ()
	 <ITALICIZE "Bureaucracy">
	 <TELL " is a trademark of Infocom, Inc.">
	 T>

<DEFINE V-$ID ()
	 <TELL "Interpreter ">
	 <PRINTN <LOWCORE INTID>>
	 <TELL " Version ">
	 <PRINTC <LOWCORE INTVR>>
	 <ZCRLF>
	 T>

<DEFINE V-$VERIFY ()
         <COND (<T? ,PRSO>
	        <COND (<AND <PRSO? INTNUM>
		            <EQUAL? ,P-NUMBER 9105>>
	               <TELL N ,SERIAL CR>)
	              (T 
		       <DONT-UNDERSTAND>)>
		T)
	       (T
		<V-$ID>
		<TELL CR "[Verifying.]" CR>
		<COND (<VERIFY> 
		       <TELL CR "[Disk correct.]" CR>)
		      (T
		       <FAILED "$VERIFY">)>
		T)>>

<DEFINE V-$RECORD ()
	 <COND (<WRONG-WINNER?>
		,FATAL-VALUE)
	       (T
		<DIROUT 4>
	        T)>>

<DEFINE V-$UNRECORD ()
	 <COND (<WRONG-WINNER?>
		,FATAL-VALUE)
	       (T
		<DIROUT -4>
	        T)>>

<DEFINE V-$COMMAND ()
	 <COND (<WRONG-WINNER?>
		,FATAL-VALUE)
	       (T
		<DIRIN 1>
	        T)>>

<DEFINE V-$RANDOM VR ()
	 <COND (<WRONG-WINNER?>
		<RETURN ,FATAL-VALUE .VR>)
	       (<NOT <PRSO? INTNUM>>
		<TELL "[Illegal #RANDOM.]" CR>)
	       (T
		<RANDOM <- 0 ,P-NUMBER>>)>
	 T>

;<SETG DEBUG? <>>

;<DEFINE V-$DEBUG ()
	 <COND (<AND <NOT <ZIL?>>
		     <NOT <EQUAL? <GETB 0 56> 80>>>
		<DONT-UNDERSTAND>)
	       (T
		<TELL "[Debug ">
		<COND (<T? ,DEBUG?>
		       <SETG DEBUG? <>>
		       <TELL "off">)
		       (T
			<SETG DEBUG? T>
			<TELL "on">)>
		<TELL ".]" CR>)>
	 T>

<DEFINE V-USE ()
	 <COND (<IS? ,PRSO ,PERSON>
		<TELL CTHEO " might resent that." CR>)
	       (T
		<HOW?>)>
	 T>

<DEFINE V-BITE ()
	 <TELL "The American Dental Association has determined that biting is bad for your teeth." CR>
	 T>

<DEFINE V-BLOW-INTO ()
	 <COND (<IS? ,PRSO ,PERSON>
		<PERFORM ,V?USE ,PRSO>)
	       (T
		<TELL "The American Pulmonary Institute has determined that blowing is bad for you." CR>)>
	 T>

;<DEFINE V-LIGHT-WITH ()
	 <V-BURN-WITH>
	 T>

;<DEFINE V-BURN-WITH ()
         <TELL "With " A ,PRSI "? " PNEXT ,YUKS ,PERIOD>
	 T>

<DEFINE V-BUY ()
	 <COND (<NOT <VISIBLE? ,PRSO>>
		<CANT-SEE-ANY ,PRSO>
		,FATAL-VALUE)
	       (<HELD? ,PRSO>
		<ALREADY-HAVE-PRSO>)	       
	       (<AND <EQUAL? ,WINNER ,PLAYER>
		     <IN? ,PRSO ,POCKET>>
		<TELL "It's in " D ,POCKET ,PERIOD>)
	       (<T? ,PRSI>
		<TELL "You couldn't buy " THEO " with " A ,PRSI ,PERIOD>)
	       (T
		<NO-MONEY>)>>

<DEFINE V-BUY-FROM ()
	 <COND (<NOT <VISIBLE? ,PRSO>>
		<CANT-SEE-ANY ,PRSO>
		,FATAL-VALUE)
	       (<HELD? ,PRSO>
		<ALREADY-HAVE-PRSO>
		T)
	       (<AND <EQUAL? ,WINNER ,PLAYER>
		     <IN? ,PRSO ,POCKET>>
		<TELL "It's in " D ,POCKET ,PERIOD>
		T)
	       (T
		<NO-MONEY>
		T)>>

<DEFINE ALREADY-HAVE-PRSO ()
	 <TELL "You already have " A ,PRSO ,PERIOD>>

<DEFINE NO-MONEY ()
	 <COND (<EQUAL? <LOC ,MONEY> ,PLAYER ,WALLET ,POCKET>
		<TELL "You probably have better things to spend your money on."
		      CR>)
	       (T
		<TELL ,DONT "have any money." CR>)>>

<DEFINE V-CLEAN ()
	 <TELL "The American Garbage Association has determined that cleaning is bad for your health." CR>
	 T>

<DEFINE V-CLEAN-OFF ()
	 <COND (<PRSO? PRSI>
		<IMPOSSIBLE>)
	       (T
		<ZPRINT ,CANT>
		<ZPRINTB ,P-PRSA-WORD>
		<SPACE>
		<TELL THEO " on " THEI ,PERIOD>)>
	 T>

<DEFINE V-CLIMB-DOWN ()
	 <COND (<EQUAL? ,P-PRSA-WORD ,W?JUMP ,W?LEAP>
		<PERFORM ,V?DIVE ,PRSO>)
	       (<PRSO? ROOMS>
		<DO-WALK ,P?DOWN>)
	       (T
		<IMPOSSIBLE>)>
	 T>

<DEFINE V-CLIMB-ON ()
	 <COND (<EQUAL? ,P-PRSA-WORD ,W?TAKE>
		<NOT-LIKELY ,PRSO "is looking for a fight">)
	       (T
		<ZPRINT ,CANT>
		<ZPRINTB ,P-PRSA-WORD>
		<TELL " onto that." CR>)>
	 T>

<DEFINE V-CLIMB-OVER ()
	 <COND (<PRSO? ROOMS>
		<V-WALK-AROUND>)
	       (T
		<TELL ,CANT "climb over that." CR>)>
	 T>

<DEFINE V-CLIMB-UP ()
	 <COND (<PRSO? ROOMS>
		<DO-WALK ,P?UP>)
	       (T
		<IMPOSSIBLE>)>
	 T>

<DEFINE V-OPEN-WITH ()
	 <COND (<NOT <IS? ,PRSO ,OPENABLE>>
		<CANT-OPEN-PRSO>)
	       (<IS? ,PRSO ,OPENED>
		<ALREADY-OPEN>)
	       (T
		<TELL ,CANT>
		<ZPRINTB ,P-PRSA-WORD>
		<TELL " " THEO " with " THEI ,PERIOD>)>
	 T>

<DEFINE CANT-OPEN-PRSO ()
	 <TELL "You couldn't possibly open " A ,PRSO ,PERIOD>>

"First and second ADJECTIVE slots must be available."
"Set to OPENED and OPEN for open objects, CLOSED and SHUT for closed."

<DEFINE V-OPEN ("AUX" TBL FOO) 
	 <SET FOO <GETP ,PRSO ,P?MAIL-LETTER>>
	 <COND (<OR <IS? ,PRSO ,LIVING>
		    <IS? ,PRSO ,PERSON>>
		<PERFORM ,V?LOOK-INSIDE ,PRSO>)
	       (<T? .FOO>
		<COND (<NOT <IN? ,PRSO ,PLAYER>>
		       <PERFORM ,V?TAKE ,PRSO>)>
		<COND (<IN? ,PRSO ,PLAYER>
		       <PUTP ,PRSO ,P?MAIL-LETTER <>>
		       <PERFORM ,V?OPEN ,PRSO>
		       <PUTP ,PRSO ,P?MAIL-LETTER .FOO>)>
		T)
	       (<NOT <IS? ,PRSO ,OPENABLE>>
		<CANT-OPEN-PRSO>
		T)
	       (<IS? ,PRSO ,OPENED>
		<ALREADY-OPEN>
		T)
	       (<IS? ,PRSO ,LOCKED>
		<TELL CTHEO " seems to be locked." CR>
		T)
	       (T
		<MAKE ,PRSO ,OPENED>
		<SET TBL <GETPT ,PRSO ,P?ADJECTIVE>>
		<COND (<AND <T? .TBL>
			    <EQUAL? <ZGET .TBL 0> ,W?CLOSED>>
		       <ZPUT .TBL 0 ,W?OPENED>
		       <ZPUT .TBL 1 ,W?OPEN>)>
		<YOU-FROB <> "open">
		<TELL THEO ,PERIOD>
		<COND (<IS? ,PRSO ,CONTAINER>
		       <COND (<OR <NOT <FIRST? ,PRSO>>
				  <IS? ,PRSO ,TRANSPARENT>>)
			     ; (<AND <SET F <FIRST? ,PRSO>>
				     <NOT <NEXT? .F>>
				     <SET STR <GETP .F ,P?FDESC>>>
				<TELL CR .STR CR>)
			     (T
			      <ZCRLF>
			      <TELL ,YOU-SEE>
			      <PRINT-CONTENTS ,PRSO>
			      <TELL " inside." CR>)>)>
		T)>>

<DEFINE V-CLOSE ("AUX" TBL)
	 <COND (<IS? ,PRSO ,OPENABLE>
		<COND (<IS? ,PRSO ,OPENED>
		       <UNMAKE ,PRSO ,OPENED>
		       <SET TBL <GETPT ,PRSO ,P?ADJECTIVE>>
		       <COND (<AND <T? .TBL>
				   <EQUAL? <ZGET .TBL 0> ,W?OPENED>>
			      <ZPUT .TBL 0 ,W?CLOSED>
			      <ZPUT .TBL 1 ,W?SHUT>)>
		       <YOU-FROB <> "close">
		       <TELL THEO ,PERIOD>)
		      (T
		       <ALREADY-CLOSED>)>)
	       (T
		<TELL ,CANT "close " A ,PRSO ,PERIOD>)>
	 T>

<DEFINE V-COUNT ()
	 <COND (<IS? ,PRSO ,PLURAL>
		<TELL "Your mind wanders, and you lose count." CR>)
	       (T
		<TELL "You see only one." CR>)>
	 T>

<DEFINE V-COVER ()
	 <PERFORM ,V?PUT-ON ,PRSI ,PRSO>
	 T>

<DEFINE V-HOLD-OVER ()
	 <WASTE-OF-TIME>
	 T>

<DEFINE V-CROSS ()
	 <TELL ,CANT "cross that." CR>
	 T>

<DEFINE V-CUT ()
	 <COND (<IS? ,PRSI ,SHARPENED>
		<HACK-HACK "Cutting">)
	       (T
		<TELL "You couldn't possibly cut " THEO
		      " with " THEI ,PERIOD>)>
	 T>

<DEFINE V-RING-FOR ()
	<COND (<IS? ,PRSO ,PERSON>
	       <TELL CTHEO " must be busy elsewhere." CR>)
	      (T
	       <TELL CTHEO " is unlikely to respond." CR>)>>

<DEFINE V-RING ()
	 <COND (<PRSO? ROOMS>
		<COND (<HERE? OUTSIDE-HOUSE>
		       <PERFORM ,V?RING ,MANSION-BELL>)
		      (T
		       <TELL "There's nothing here to ring." CR>)>)
	       (T
	        <TELL ,CANT "ring " A ,PRSO ,PERIOD>)>
	 T>

<DEFINE V-RIP ()
	 <TELL "You couldn't possibly rip " THEO>
	 <COND (<NOT <PRSI? HANDS>>
		<TELL " with " THEI>)>
	 <ZPRINT ,PERIOD>
	 T>

<DEFINE V-DIG ()
	 <WASTE-OF-TIME>
	 T>

<DEFINE V-SDIG ()
	 <PERFORM ,V?DIG ,PRSI ,PRSO>
	 ,FATAL-VALUE>

<DEFINE V-DRINK ("OPTIONAL" (FROM? <>))
	 <TELL ,CANT "drink ">
	 <COND (<T? .FROM?>
		<TELL "from ">)>
	 <TELL D ,NOT-HERE-OBJECT ,PERIOD>	
	 T>

<DEFINE V-DRINK-FROM ()
	 <V-DRINK T>
	 T>

<DEFINE V-DROP ("AUX" VAL)
	 <COND (<==? <SET VAL <IDROP>> ,FATAL-VALUE>
		,FATAL-VALUE)
	       (<T? .VAL>
		<SAY-DROPPED>
		T)
	       (T T)>>

<DEFINE SAY-DROPPED ()
	 <COND (<OR <T? ,P-MULT?>
		    <PROB 50>>
		<TELL "Dropped." CR>)
	       (T
		<TELL "You ">
		<COND (<PROB 50>
		       <TELL "drop ">)
		      (T
		       <TELL "put down ">)>
		<TELL THEO ,PERIOD>)>
	 T>

<DEFINE IDROP IDROP ("AUX" L)
	 <SET L <LOC ,PRSO>>
	 <COND (<OR <ZERO? .L>
		    <PRSO? WINNER ME>>
		<IMPOSSIBLE>
		<RETURN <> .IDROP>)
	       (<NOT <EQUAL? .L ,PLAYER>>
		<TELL "You'd have to take " THEO>
		<COND (<AND <IS? .L ,SURFACE>
			    <N==? .L ,ENVELOPE>>
		       <TELL " off ">)
		      (T
		       <TELL " out of ">)>
		<TELL THE .L " first." CR>
		<RETURN <> .IDROP>)
	       (<AND <IS? ,PRSO ,WORN>
		     <IN? ,PRSO ,PLAYER>>
		<TAKE-OFF-PRSO-FIRST>)>
	 <COND (<IS? ,HERE ,SPECIAL-DROP>
		<COND (<==? <FALLS T> ,FATAL-VALUE>
		       ,FATAL-VALUE)
		      (T <>)>)
	       (T
		<MOVE ,PRSO ,HERE>
		T)>>

<DEFINE PRSO-SLIDES-OFF-PRSI ()
	 <COND (<==? ,PRSO ,MONEY>
		<TELL "Maybe you ought to hold on to your money." CR>)
	       (T
		<TELL CTHEO " slide">
		<COND (<NOT <IS? ,PRSO ,PLURAL>>
		       <TELL "s">)>
		<TELL " off " THEI " and ">
		<FALLS>)>
	 T>

<DEFINE FALLS FF ("OPTIONAL" (SAYTHEO <>) "AUX" (OBJ ,PRSO))
	 <COND (<HERE? IN-COMPLEX>
		<RETURN <HANDLE-COMPLEX-DROP .OBJ> .FF>)
	       (<HERE? BANK>
		<RETURN <HANDLE-BANK-DROP .OBJ> .FF>)>
	 <COND (.SAYTHEO <TELL CTHEO " ">)>
	 <COND (<HERE? IN-TREE>
		<MOVE .OBJ ,IN-POT>
		<SETG P-IT-OBJECT ,NOT-HERE-OBJECT>
		<TELL "falls out of sight." CR>
		T)
	       (<HERE? OUTSIDE-PLANE IN-AIR>
		<ZREMOVE .OBJ>
		<SETG P-IT-OBJECT ,NOT-HERE-OBJECT>
		<TELL "disappears below you." CR>
		T)
	       (<HERE? AIRPORT-CONCOURSE AIRPORT-ENTRANCE AIRLINE-DESK>
		<MOVE .OBJ ,LANDF>
		<SETG P-IT-OBJECT ,NOT-HERE-OBJECT>
		<TELL "disappears amid the teeming crowd." CR>
		T)
	       (<HERE? PILLAR-A PILLAR-B>
		<MOVE .OBJ ,LANDF>
		<SETG P-IT-OBJECT ,NOT-HERE-OBJECT>
		<TELL "falls out of sight." CR>
		T)
	       (<BOTTOM-DUCT?>
		<COND (<IS? ,GRATE ,OPENED>
		       <MOVE .OBJ ,LANDF>
		       <SETG P-IT-OBJECT ,NOT-HERE-OBJECT>
		       <TELL 
"falls through the open grate and disappears." CR>)
		      (T
		       <MOVE .OBJ ,GRATE>
		       <TELL "lands on the grate." CR>)>
		T)
	       (<HERE? DUCT TOWER-DUCT>
		<COND (<IS? ,GRATE ,OPENED>
		       <MOVE .OBJ ,LANDF>)
		      (T
		       <MOVE .OBJ ,GRATE>)>
		<SETG P-IT-OBJECT ,NOT-HERE-OBJECT>
		<TELL "slides down into " THE ,DUCT
		      " and disappears." CR>
		T)
	       (T
		<MOVE .OBJ ,HERE>
		<TELL "land">
		<COND (<NOT <IS? .OBJ ,PLURAL>>
		       <TELL "s">)>
		<TELL " at your feet." CR>
		T)>>

<DEFINE V-EAT ()
	 <COND (<EQUAL? ,WINNER ,PLAYER>
		<NOT-LIKELY ,PRSO "would agree with you">)
	       (T
		<TELL "\"It" PNEXT ,LIKELIES
		      " that " THEO " would agree with me.\"" CR>)>
	 T>

<DEFINE V-ENTER () ; ("AUX" (VEH <>))
	 <COND (<PRSO? ROOMS>
		<DO-WALK ,P?IN>)
	       (<IS? ,PRSO ,CLOTHING>
		<TELL "[Presumably, you mean WEAR " THEO
		      "." ,BRACKET>
		<PERFORM ,V?WEAR ,PRSO>)
	       (T
		<IMPOSSIBLE>)>
	 T>

<DEFINE V-ESCAPE ()
	 <COND (<IS? ,PRSO ,PLACE>
		<NOT-IN>)
	       (T
		<V-WALK-AROUND>)>
	 T>

<DEFINE PRE-DUMB-EXAMINE ()
	 <COND ;(<ZERO? ,LIT?>
		<TOO-DARK>)
	       (<LOOK-INTDIR?>)
	       (T
		<COND (<NOT <IS? ,EYES ,SEEN>>
		       <MAKE ,EYES ,SEEN>
		       <TELL 
"[Presumably, you mean LOOK AT " THEO
", not LOOK INSIDE or LOOK UNDER or LOOK BEHIND " THEO "." ,BRACKET>)>
		<PERFORM ,V?EXAMINE ,PRSO>)>
	 T>

<DEFINE V-DUMB-EXAMINE ()
	 <V-EXAMINE>
	 T>

<DEFINE LOOK-INTDIR? LOOK ("AUX" PTR TBL X)
	 <COND ;(<PRSO? RIGHT LEFT>
		T)
	       (<NOT <PRSO? INTDIR>>		   
		<RETURN <> .LOOK>)
	       (T
		; "This is an LTABLE, so we don't have the cretinism of
		   initializing PTR to the length of a table that's defined
		   somewhere else and getting it wrong."
		<SET X <ZGET ,DIRTABLES 0>>
		<SET PTR <ZGET .X 0>>
		<SET PTR <- .PTR 1>>
		<SET X <ZREST .X 2>>
		<SET TBL <ZGET ,DIRTABLES 1>>
		<REPEAT ()
			<COND (<EQUAL? ,P-DIRECTION <ZGET .X .PTR>>
			       <SET X <GETP ,HERE <ZGET .TBL .PTR>>>
			       <COND (<T? .X>
				      <SEE-DIR .X>
				      <RETURN T .LOOK>)>
			       <RETURN>)
			      (<L? <SET PTR <- .PTR 1>> 0>
			       <RETURN>)>>)>
	 <SET X <GETP ,HERE ,P?SEE-ALL>>
	 <COND (<T? .X>
		<SEE-DIR .X>
		<RETURN T .LOOK>)>
	 <NOTHING-INTERESTING>
	 <TELL " in that direction" ,PERIOD>
	 T>
		 	       
<DEFINE SEE-DIR (X)
	 <THIS-IS-IT .X>
	 <TELL ,YOU-SEE>
	 <COND (<AND <NOT <IS? .X ,NOARTICLE>>
		     <NOT <IS? .X ,PLURAL>>>
		<TELL "the ">)>
	 <TELL D .X " that way." CR>
	 T>

<CONSTANT DIRTABLES
	<PTABLE
	 <PLTABLE ; "P?SW P?SE P?NW P?NE" P?WEST P?SOUTH P?EAST P?NORTH>
	 <PTABLE ; "P?SEE-SW P?SEE-SE P?SEE-NW P?SEE-NE" 
		 P?SEE-W P?SEE-S P?SEE-E P?SEE-N>>>
	 
;<DEFINE PRE-EXAMINE ()
	 <COND (<ZERO? ,LIT?>
		<TOO-DARK>
		,FATAL-VALUE)
	       (T
		<>)>>

<DEFINE V-EXAMINE ()
	 <COND (<IS? ,PRSO ,OPENABLE>
	        <TELL "It looks as if " THEO>
		<IS-ARE>
		<COND (<IS? ,PRSO ,OPENED>
		       <TELL "open">)
		      (T
		       <TELL "closed">)>
	        <ZPRINT ,PERIOD>
		T)
	       (<IS? ,PRSO ,SURFACE>
	      	<TELL ,YOU-SEE>
		<PRINT-CONTENTS ,PRSO>
		<TELL " on " THEO>
	        <ZPRINT ,PERIOD>
		T)
	       (<IS? ,PRSO ,CONTAINER>
		<COND (<OR <IS? ,PRSO ,OPENED>
			   <IS? ,PRSO ,TRANSPARENT>>
		       <V-LOOK-INSIDE>)
		      (T
		       <ITS-CLOSED ,PRSO>)>
		T)
	       (<LOOK-INTDIR?>
		T)
	       (<AND <IS? ,PRSO ,PERSON>
		     <SEE-ANYTHING-IN? ,PRSO>>
	        <TELL CTHEO " has ">
		<PRINT-CONTENTS ,PRSO>
		<ZPRINT ,PERIOD>
		T)
	       (T
		<NOTHING-INTERESTING>
		<TELL " about " THEO ,PERIOD>)>
	 T>

<DEFINE NOTHING-INTERESTING ()
	 <COND (<PROB 50>
		<TELL ,YOU-SEE "no">)
	       (T
		<TELL ,CANT "see any">)>
	 <TELL "thing " PNEXT ,YAWNS>
	 T>

;<SETG YAWNS
	<LTABLE 2 "unusual" "interesting" "extraordinary" "special">>

;<DEFINE PRE-WATCH ()
	 <COND (<PRE-EXAMINE>
		T)
	       (T
		<>)>>

<DEFINE V-WATCH ()
         <COND (<IS? ,PRSO ,PERSON>
		<TELL CTHEO>
		<ISNT-ARENT>
		<TELL "doing anything " PNEXT ,YAWNS>)
	       (T
		<TELL "Nothing " PNEXT ,YAWNS " is happening">)>
         <ZPRINT ,PERIOD>
	 T>		

<DEFINE V-EXIT ("AUX" L)
	 <COND (<PRSO? ROOMS>
		<DO-WALK ,P?OUT>)
	       (T
		<SET L <LOC ,PRSO>>
		<COND (<IS? ,PRSO ,PLACE>
		       <NOT-IN>)
		      (<AND <T? .L>
			    <IS? .L ,CONTAINER>
			    <VISIBLE? ,PRSO>>
		       <TELL "[from " D .L ,BRACKET>
		       <PERFORM ,V?TAKE ,PRSO>)
		      (T
		       <DO-WALK ,P?OUT>)>)>
	 T>

<DEFINE V-FILL ()
	 <HOW?>
       ; <COND (<ZERO? ,PRSI>
	        <TELL "There's nothing to fill it with." CR>
		<RTRUE>)
	       (T 
		<HOW?>)>
	 T>

<DEFINE V-FILL-IN ()
	 <COND (<WRONG-WINNER?>
		,FATAL-VALUE)
	       (T
		<WASTE-OF-TIME>)
	       ;(<NOT <IS? ,PRSO ,TAKEABLE>>
		T)
	       ;(T
		<WASTE-OF-TIME>
		T)>>

<DEFINE V-ERASE ERASE ()
	 <COND (<NOT <IS? ,PRSO ,TAKEABLE>>
		T)
	       ;(<NOT <IN? ,PENCIL ,PLAYER>>
		<TELL "You don't have an eraser." CR>
		<RETURN T .ERASE>)>
	 <IMPOSSIBLE>
	 T>

<DEFINE V-FIND ("AUX" L)
	 <SET L <LOC ,PRSO>>
	 <COND (<ZERO? .L>
		<DO-IT-YOURSELF>)
	       	(<PRSO? ME HANDS>
	        <TELL "You're right here." CR>)
	       (<IN? ,PRSO ,PLAYER>
		<TELL "You're holding it." CR>)
	       (<OR <IN? ,PRSO ,HERE>
		    <AND <IN? ,PRSO ,LOCAL-GLOBALS>
			 <GLOBAL-IN? ,PRSO ,HERE>>>
		<ITS-RIGHT-HERE>)
	       (<AND <OR <IS? .L ,PERSON>
			 <IS? .L ,LIVING>>
		     <VISIBLE? .L>>
	        <TELL CTHE .L " has it." CR>)
	       (<AND <SEE-INSIDE? .L>
		     <VISIBLE? .L>>
	        <SAY-ITS>
		<COND (<IS? .L ,SURFACE>
		       <TELL "on ">)
		      (T
		       <TELL "in ">)>
		<TELL THE .L ,PERIOD>)
	       (T
		<DO-IT-YOURSELF>)>
	 T>

<DEFINE DO-IT-YOURSELF ()
         <TELL "You'll have to do that " D ,ME ,PERIOD>>

<DEFINE ITS-RIGHT-HERE ()
	 <SAY-ITS>
	 <TELL "right here in front of you." CR>>

<DEFINE SAY-ITS ()
         <COND (<IS? ,PRSO ,PLURAL>
		<TELL "They're ">)
	       (<IS? ,PRSO ,FEMALE>
		<TELL "She's ">)
	       (<IS? ,PRSO ,PERSON>
		<TELL "He's ">)
	       (T
		<TELL "It's ">)>
	 T>
	 
<DEFINE V-FLY ()
	 <TELL ,CANT "possibly do that." CR>
	 T>

<DEFINE V-FOLD ()
	 <TELL "Please do not fold, spindle, or mutilate valuable Infocom property." CR>
	 T>

<DEFINE V-UNFOLD ()
	 <IMPOSSIBLE>
	 T>

<DEFINE V-UNTANGLE ()
       	 <TELL CTHEO " isn't tangled." CR>
	 T>

<DEFINE V-FOLLOW FOLLOW ()
	 <COND (<ZERO? ,PRSO>
		<CANT-SEE-ANY>
		<RETURN ,FATAL-VALUE .FOLLOW>)>
         <COND (<IS? ,PRSO ,MUSICAL>
		<TELL "You start dancing, but can't find a beat to follow, and give up." CR>
		<RETURN T .FOLLOW>)>
	 <TELL "But ">
	 <COND (<PRSO? ME>
		<TELL "you're right here." CR>
		T)
	       (T
		<TELL THEO>
		<COND (<IS? ,PRSO ,PLURAL>
		       <TELL " are">)
		      (T
		       <TELL " is">)>
	 	<COND (<OR <VISIBLE? ,PRSO>
		    	   <IN? ,PRSO ,GLOBAL-OBJECTS>>
		       <TELL " right here">)
	       	      (T
		       <TELL "n't visible at the moment">)>
		<ZPRINT ,PERIOD>)>
	 T>

<DEFINE PRE-FEED ()
	 <COND (<PRE-GIVE T>
		T)
	       (T
		<>)>>

<DEFINE V-FEED ()
         <COND (<PRSI? ME>
		<TELL "You aren't">)
	       (T
		<TELL CTHEI " ">
		<COND (<IS? ,PRSI ,PLURAL>
		       <TELL "aren't">)
		      (T
		       <TELL "isn't">)>)>
	 <TELL " hungry enough to eat that." CR>
	 T>

<DEFINE V-SFEED ()
	 <PERFORM ,V?FEED ,PRSI ,PRSO>
	 T>

<DEFINE PRE-GIVE ("OPTIONAL" (FEED? <>))
	 <COND (<OR <ZERO? ,PRSO>
		    <ZERO? ,PRSI>>
		<REFERRING>
		T)
	       (<AND <PRSO? REQUEST-OBJECT>
		     <PRSO-NOUN-USED? ,W?PERMISSION>>
		<COND (<PRSI? THE-FLIGHT>
		       <>)
		      (T
		       <REFERRING>
		       T)>)
	       (<OR <EQUAL? ,PRSO ,PRSI>
		    <IN? ,PRSI ,GLOBAL-OBJECTS>>
		<IMPOSSIBLE>
		T)
	       (<NOT <IS? ,PRSI ,LIVING>>
		<ZPRINT ,CANT>
		<COND (<T? .FEED?>
		       <TELL "feed ">)
		      (T
		       <TELL "give ">)>
		<TELL "anything to " A ,PRSI ,PERIOD>
	        T)
	       (<AND <PRSI? ME>
		     <IN? ,PRSO ,PLAYER>>
	      	<ALREADY-HAVE-PRSO>
		T)
	       (<AND <NOT <PRSI? ME>>
		     <NOT <EQUAL? ,PRSO ,RANDOM-OBJECT ,AIRLINE-MEAL>>
		     <DONT-HAVE? ,PRSO>>
		T)
	       (<AND <IS? ,PRSO ,WORN>
		     <IN? ,PRSO ,PLAYER>>
		<TAKE-OFF-PRSO-FIRST>
		<>)
	       (T
		<>)>>

<DEFINE V-SGIVE ()
	 <PERFORM ,V?GIVE ,PRSI ,PRSO>
	 T>

<DEFINE V-GIVE ()
	 <COND (<PRSI? ME>
		<NOBODY-TO-ASK>)
	       (<IS? ,PRSO ,PERSON>
		<TELL CTHEI " shows little interest in your offer." CR>)
	       (T
		<NOT-LIKELY ,PRSI "would accept your offer">)>
	 T>

<DEFINE PRE-TRADE-FOR ()
	 <COND (<OR <ZERO? ,PRSO>
		    <ZERO? ,PRSI>>
		<REFERRING>
		T)
	       (<OR <EQUAL? ,PRSO ,PRSI>
		    <IN? ,PRSI ,GLOBAL-OBJECTS>
		    <AND <NOT <IS? ,PRSI ,TAKEABLE>>
			 <NOT <IS? ,PRSI ,TRYTAKE>>>>
		<IMPOSSIBLE>
		T)
	       (<IN? ,PRSI ,PLAYER>
	      	<TELL "You already have " A ,PRSI ,PERIOD>
		T)
	       (<AND <IS? ,PRSO ,WORN>
		     <IN? ,PRSO ,PLAYER>>
		<TAKE-OFF-PRSO-FIRST>
		<>)
	       (T
		<>)>>

<DEFINE V-TRADE-FOR ("AUX" L)
	 <SET L <LOC ,PRSI>>
	 <COND (<ZERO? .L>
		<IMPOSSIBLE>)
	       (<IS? .L ,PERSON>
		<TELL CTHE .L " seems reluctant to give up " THEI ,PERIOD>)
	       (T
		<TELL "Why not just pick up " THEI " instead?" CR>)>
	 T>	       

<DEFINE V-SSEND ()
  <PERFORM ,PRSA ,PRSI ,PRSO>>

<DEFINE V-SEND ()
  <COND (<==? ,WINNER ,PLAYER>
	 <TELL "Whatever it is you're trying to do, you don't have to do it."
	       CR>)
	(T
	 <TELL CTHE ,WINNER " doesn't seem to hear you." CR>)>>

<DEFINE V-SELL ()
	 <COND (<NOT <EQUAL? ,WINNER ,PLAYER>>
		<NOT-LIKELY ,WINNER "is interested in selling anything">)
	       (<PRSI? PRSO ME WINNER>
		<IMPOSSIBLE>)
	       (<NOT <IS? ,PRSI ,PERSON>>
		<NOT-LIKELY ,PRSI "would buy anything">)
	       (T
		<NOT-A "P-123/43A" "salesperson">)>
	 T>

<DEFINE V-SSELL ()
	 <PERFORM ,V?SELL ,PRSI ,PRSO>
	 T>
		       		       
<DEFINE PRE-SHOW ()
	 <COND (<OR <ZERO? ,PRSO>
		    <ZERO? ,PRSI>>
		<REFERRING>
		T)
	       (<OR <EQUAL? ,PRSO ,PRSI>
		    <IN? ,PRSI ,GLOBAL-OBJECTS>>
		<IMPOSSIBLE>
		T)
	       (<RAND-PRSI? ,BABY-OBJECT> <>)
	       (<NOT <IS? ,PRSI ,LIVING>>
		<TELL ,CANT "show things to " A ,PRSI ,PERIOD>
		T)
	       (<AND <PRSI? ME>
		     <IN? ,PRSO ,PLAYER>>
	        <ALREADY-HAVE-PRSO>
		T)
	       (<AND <NOT <PRSI? ME>>
		     <NOT <EQUAL? ,PRSO ,RANDOM-OBJECT ,AIRLINE-MEAL>>
		     <DONT-HAVE? ,PRSO>>
		T)
	       (T
		<>)>>

<DEFINE V-SSHOW ()
	 <PERFORM ,V?SHOW ,PRSI ,PRSO>
	 T>

<DEFINE S-IF-SINGULAR ("OPT" (OBJ <>))
  <COND (<F? .OBJ> <SET OBJ ,PRSI>)>
  <COND (<F? .OBJ> <SET OBJ ,PRSO>)>
  <COND (<NOT <IS? .OBJ ,PLURAL>>
	 <TELL "s">)>>

<DEFINE V-SHOW ()
	 <TELL CTHEI " glance">
	 <S-IF-SINGULAR>
	 <TELL " at " THEO ", but make">
	 <S-IF-SINGULAR>
	 <TELL " no comment." CR>
	 T>

<DEFINE V-REFUSE ()
	 <COND (<NOT <IS? ,PRSO ,TAKEABLE>>
		<WASTE-OF-TIME>)
	       (T
		<TELL "How could you turn down " A ,PRSO
		      "? It must be awfully tempting!" CR>)>
	 T>

<DEFINE V-HIDE ()
	 <TELL ,CANT "hide from bureaucracies." CR>
	 T>

<DEFINE V-KICK ()
	 <HACK-HACK "Kicking">
	 T>

<DEFINE V-BOUNCE ()
	 <COND (<PRSO? ROOMS>
		<WASTE-OF-TIME>)
	       (T
		<IMPOSSIBLE>)>
	 T>

<DEFINE V-KILL ()
	 <COND (<NOT <IS? ,PRSO ,LIVING>>
		<TELL ,CANT "possibly attack " A ,PRSO>
		<COND (<AND <T? ,PRSI>
			    <NOT <PRSI? HANDS>>>
		       <TELL ", even with " A ,PRSI>)>
	        <ZPRINT ,PERIOD>)
	       (T
		<V-HIT>)>
	 T> 

<DEFINE V-HIT ()
         <TELL "Attacking " THEO>
	 <COND (<AND <T? ,PRSI>
		     <NOT <PRSI? HANDS>>>
		<TELL " with " A ,PRSI>)>
	 <WONT-HELP>
	 T>

<DEFINE V-KNOCK ()
	 <COND (<IS? ,PRSO ,DOORLIKE>
		<COND (<IS? ,PRSO ,OPENED>
		       <ALREADY-OPEN>)
		      (T
		       <TELL "There's no answer." CR>)>)
	       (<IS? ,PRSO ,PERSON>
		<PERFORM ,V?USE ,PRSO>)
	       (T
		<WASTE-OF-TIME>)>
	 T>

<DEFINE V-KISS ()
	 <WASTE-OF-TIME>
	 T>

<DEFINE V-SHUT-UP ()
  <COND (<PRSO? ROOMS>
	 <COND (<N==? ,WINNER ,PLAYER>
		<TELL CTHE ,WINNER " doesn't make any of the rude remarks that you deserve, but doesn't shut up, either." CR>)
	       (T
		<TELL "You fall silent for a moment, then realise that this won't get you anywhere." CR>)>)
	(<OR <IS? ,PRSO ,LIVING>
	     <IS? ,PRSO ,PERSON>>
	 <COND (<N==? ,WINNER ,PLAYER>
		<COND (<==? ,WINNER ,PRSO>
		       <PERFORM ,V?SHUT-UP ,ROOMS>)
		      (T
		       <TELL CTHE ,WINNER
			     " is too well-bred to attempt that." CR>)>)
	       (T
		<TELL "Don't be rude." CR>)>)
	(T
	 <TELL CTHEO " can't shut up. It's too stupid." CR>)>>

<DEFINE V-LAMP-OFF ()
	 <COND (<PRSO? ROOMS>
		<YOU-FROB <> "pause">
		<TELL "for a moment." CR>)
	       (T
		<V-LAMP-ON T>)>
	 T>

<DEFINE V-LAMP-ON ("OPTIONAL" (OFF? <>))
	 <TELL "You couldn't turn that ">
	 <COND (<T? .OFF?>
		<TELL "off">)
	       (T
		<TELL "on">)>
	 <COND (<NOT <EQUAL? ,PRSI <> ,HANDS>>
		<TELL ", " D ,PRSI " or no " D ,PRSI>)>
	 <ZPRINT ,PERIOD>
	 T>

<DEFINE V-LEAP ()
	 <COND (<NOT <PRSO? ROOMS>>
	        <TELL "That'd be a cute trick." CR>)
	       (T
		<WASTE-OF-TIME>)>
	 T>

<DEFINE V-LEAVE ()
	 <COND (<IS? ,PRSO ,PLACE>
		<NOT-IN>)
	       (<OR <PRSO? ROOMS>
		    <NOT <IS? ,PRSO ,TAKEABLE>>>
		<DO-WALK ,P?OUT>)
	       (<NOT <DONT-HAVE? ,PRSO>>
		<PERFORM ,V?DROP ,PRSO>)>
	 T>

<DEFINE V-SLEEP ()
         <V-LIE-DOWN>
	 T>

<DEFINE V-LIE-DOWN ()
       	 <TELL ,THIS-IS "no time for resting." CR>
	 T>

<DEFINE V-LISTEN ("AUX" (OBJ <>))
	 <COND (<PRSO? ROOMS SOUNDS>
		<SET OBJ <GETP ,HERE ,P?HEAR>>
		<COND (<ZERO? .OBJ>
		       <TELL ,DONT "hear anything "
			     PNEXT ,YAWNS ,PERIOD>)
		      (<IN? ,NERD ,HERE>
		       <TELL "You hear a steady but low-level whining." CR>)
		      (T
		       <PERFORM ,V?LISTEN .OBJ>)>)
	       (T
		<TELL "At the moment, " THEO>
		<IS-ARE>
		<TELL "silent." CR>)>
	 T>

<DEFINE V-LOCK ()
	 <COND (<OR <IS? ,PRSO ,OPENABLE>
		    <IS? ,PRSO ,CONTAINER>>
		<COND (<IS? ,PRSO ,OPENED>
		       <YOUD-HAVE-TO "close" ,PRSO>)
		      (<IS? ,PRSO ,LOCKED>
		       <TELL CTHEO>
		       <IS-ARE>
		       <TELL "already locked." CR>)
	       	      (T
		       <THING-WONT-LOCK ,PRSI ,PRSO>)>)
	       (T
		<CANT-LOCK>)>
	 T>

<VOC "UNLOCKED" ADJ>

<DEFINE V-UNLOCK ()
	 <COND (<OR <IS? ,PRSO ,OPENABLE>
		    <IS? ,PRSO ,CONTAINER>>
		<COND (<OR <IS? ,PRSO ,OPENED>
		           <NOT <IS? ,PRSO ,LOCKED>>>
		       <TELL CTHEO>
		       <ISNT-ARENT>
		       <TELL "locked." CR>)
	       	      (T
		       <THING-WONT-LOCK ,PRSI ,PRSO T>)>)
	       (T
		<CANT-LOCK T>)>
	 T>

<DEFINE CANT-LOCK ("OPTIONAL" (UN? <>))
	 <ZPRINT ,CANT>
	 <COND (<T? .UN?>
		<TELL "un">)>
	 <TELL "lock " A ,PRSO ,PERIOD>
	 T>

<DEFINE THING-WONT-LOCK (THING CLOSED-THING "OPTIONAL" (UN? <>))
	 <TELL CTHE .THING " won't ">
	 <COND (<T? .UN?>
		<TELL "un">)>
	 <TELL "lock " THE .CLOSED-THING ,PERIOD>
	 T>

;<DEFINE V-SCREW ()
	 <TELL ,CANT "screw " THEO " into " THEI ,PERIOD>
	 T>

;<DEFINE V-SCREW-WITH ()
	 <NOT-LIKELY ,PRSI "could help you do that">
	 T>

;<DEFINE V-UNSCREW ()
	 <TELL ,CANT "unscrew " THEO>
	 <COND (<NOT <PRSI? HANDS>>
		<TELL ", with or without " THEI>)>
	 <ZPRINT ,PERIOD>
	 T>

;<DEFINE V-UNSCREW-FROM ()
	 <COND (<PRSO? PRSI>
		<IMPOSSIBLE>)
	       (<NOT <IN? ,PRSO ,PRSI>>
		<COND (<IS? ,PRSI ,LIVING>
		       <TELL CTHEI " doesn't have " THEO ,PERIOD>)
		      (T
		       <TELL CTHEO>
		       <ISNT-ARENT>
		       <COND (<IS? ,PRSI ,SURFACE>
			      <TELL "on ">)
			     (T
			      <TELL "in ">)>
		       <TELL THEI ,PERIOD>)>)
	       (T
		<TELL ,CANT "unscrew " THEO ,PERIOD>)>
	 T>

<DEFINE V-UNTIE ()
	 <ZPRINT ,CANT>
	 <ZPRINTB ,P-PRSA-WORD>
	 <SPACE>
	 <TELL A ,PRSO ,PERIOD>
	 T>

<DEFINE V-LOOK ()
	 <COND (<DESCRIBE-ROOM T>
		<DESCRIBE-OBJECTS>)>
	 T>

<DEFINE V-LOOK-ON ()
	 <COND ;(<ZERO? ,LIT?>
		<TOO-DARK>
		,FATAL-VALUE)
	       (<IS? ,PRSO ,SURFACE>
		<TELL ,YOU-SEE>
		<PRINT-CONTENTS ,PRSO>
		<TELL " on " THEO ,PERIOD>
		T)
	       (<IS? ,PRSO ,READABLE>
		<TELL CTHEO " is undecipherable." CR>
		T)
	       (T
		<NOTHING-INTERESTING>
		<TELL " on " THEO ,PERIOD>
		T)>>	       

<DEFINE V-LOOK-BEHIND ()
	 <COND ;(<ZERO? ,LIT?>
		<TOO-DARK>
		,FATAL-VALUE)
	       (<IS? ,PRSO ,DOORLIKE>
		<COND (<IS? ,PRSO ,OPENED>
		       <CANT-SEE-MUCH>)
		      (T
		       <ITS-CLOSED ,PRSO>)>
		T)
	       (<OR <IS? ,PRSO ,PLACE>
		    <IS? ,PRSO ,LOCATION>>
		<HACK-HACK "Looking behind">
		T)
	       (T
		<TELL "There's nothing behind " THEO ,PERIOD>
		T)>>

<DEFINE V-LOOK-DOWN ("AUX" X)
	 <COND ;(<ZERO? ,LIT?>
		<TOO-DARK>)
	       (<IS? ,PRSO ,PLACE>
		<CANT-SEE-MUCH>)
	       (<PRSO? ROOMS>
		<COND (<F? <SET X <GETP ,HERE ,P?BELOW>>>
		       <SET X ,GROUND>
		       <COND (<IS? ,HERE ,INDOORS>
			      <PUTP .X ,P?OBJ-NOUN ,W?FLOOR>)
			     (T
			      <PUTP .X ,P?OBJ-NOUN ,W?GROUND>)>)>
		<PERFORM ,V?EXAMINE .X>)
	       (T
		<PERFORM ,V?LOOK-INSIDE ,PRSO>)>
	 T>

<DEFINE V-LOOK-UP ("AUX" (X <>))
	 <COND ;(<ZERO? ,LIT?>
		<TOO-DARK>
		,FATAL-VALUE)
	       (<PRSO? ROOMS>
		<SET X <GETP ,HERE ,P?OVERHEAD>>
		<COND (<T? .X>
		       <PERFORM ,V?EXAMINE .X>)
		      (T
		       <NOTHING-INTERESTING>
		       <ZPRINT ,PERIOD>)>
		T)
	       (T
		<TELL ,CANT "look up " A ,PRSO ,PERIOD>
		T)>>

<DEFINE V-LOOK-INSIDE ()
	 <COND ;(<ZERO? ,LIT?>
		<TOO-DARK>)
	       (<IS? ,PRSO ,PLACE>
		<CANT-SEE-MUCH>)
	       (<IS? ,PRSO ,PERSON>
		<NOT-A "Q\33-86-A" "surgeon">)
	       (<IS? ,PRSO ,LIVING>
		<NOT-A "Q\33-86-B" "veterinarian">)
	       (<IS? ,PRSO ,CONTAINER>
		<COND (<AND <NOT <IS? ,PRSO ,OPENED>>
			    <NOT <IS? ,PRSO ,TRANSPARENT>>>
		       <ITS-CLOSED ,PRSO>)
		      (T
		       <TELL ,YOU-SEE>
		       <PRINT-CONTENTS ,PRSO>
		       <TELL " in " THEO ,PERIOD>)>)
	       (<IS? ,PRSO ,DOORLIKE>
		<COND (<IS? ,PRSO ,OPENED>
		       <CANT-SEE-MUCH>)
		      (T
		       <ITS-CLOSED ,PRSO>)>)
	       (T
		<TELL ,CANT "look inside " A ,PRSO ,PERIOD>)>
	 T>

<DEFINE V-LOOK-OUTSIDE ()
	 <COND ;(<ZERO? ,LIT?>
		<TOO-DARK>)
	       (<PRSO? ROOMS>
		<COND (<IS? ,HERE ,INDOORS>
		       <NOTHING-INTERESTING>
		       <TELL " outside." CR>)
		      (T
		       <YOURE-ALREADY "outside">)>)
	       (<IS? ,PRSO ,DOORLIKE>
		<COND (<IS? ,PRSO ,OPENED>
		       <CANT-SEE-MUCH>)
		      (T
		       <ITS-CLOSED ,PRSO>)>)
	       (T
		<TELL ,CANT "look out of " A ,PRSO ,PERIOD>)>
	 T>

<DEFINE V-SLOOK-THRU ()
	 <PERFORM ,V?LOOK-THRU ,PRSI ,PRSO>
	 T>

<DEFINE V-LOOK-THRU ()
	 <COND ;(<ZERO? ,LIT?>
		<TOO-DARK>
		,FATAL-VALUE)
	       (<AND <T? ,PRSI>
		     <NOT <IS? ,PRSI ,TRANSPARENT>>>
		<TELL ,CANT "look through that." CR>
		T)
	       (T
		<NOTHING-INTERESTING>
		<ZPRINT ,PERIOD>
		T)>>

<DEFINE V-LOOK-UNDER ()
	 <COND ;(<ZERO? ,LIT?>
		<TOO-DARK>
		,FATAL-VALUE)
	       (T
		<NOTHING-INTERESTING>
		<TELL " under " THEO ,PERIOD>
		T)>>

;<DEFINE V-WEDGE ()
	 <PERFORM ,V?LOOSEN ,PRSI ,PRSO>
	 T>

<DEFINE V-LOOSEN ()
	 <WASTE-OF-TIME>
	 T>

<DEFINE V-LOWER ()
	 <COND (<PRSO? ROOMS>
		<DO-WALK ,P?DOWN>)
	       (T
		<V-RAISE>)>
	 T>

<DEFINE V-MAKE ()
	 <HOW?>
	 T>

<DEFINE V-MELT ()
	 <HOW?>
	 T>

<DEFINE V-MOVE ()
	 <COND (<PRSO? ROOMS>
		<COND (<N==? ,WINNER ,PLAYER>
		       <TELL CTHE ,WINNER " is apparently quite happy to
stay right there." CR>
		       ,FATAL-VALUE)
		      (T
		       <V-WALK-AROUND>
		       T)>)
	       (<IS? ,PRSO ,TAKEABLE>
		<TELL "Moving " THEO " " PNEXT ,HO-HUM 
		      ,PERIOD>)
	       (T
		<TELL ,CANT "possibly move " THEO ,PERIOD>)>>

<DEFINE V-MUNG ()
	 <HACK-HACK "Trying to destroy">
	 T>

<DEFINE V-SPAY ()
  <PERFORM ,V?GIVE ,PRSO ,PRSI>
  T>

<DEFINE V-PAY ()
	 <PERFORM ,V?GIVE ,PRSI ,PRSO>
	 T>

<DEFINE V-CASH ()
  <TELL ,CANT "cash " THEO " here." CR>>
	       
<DEFINE V-PLAY ()
	 <COND (<PRSO? ROOMS>
		<WASTE-OF-TIME>)
	       (T
		<HACK-HACK "Playing with">)>
	 T>

<DEFINE V-PICK ()
	 <COND (<IS? ,PRSO ,OPENABLE>
		<NOT-A "Q\33-86-C" "locksmith">)
	       (T
		<IMPOSSIBLE>)>
	 T>

<DEFINE V-POINT ()
	 <COND (<T? ,PRSI>
		<COND (<IS? ,PRSI ,PERSON>
		       <TELL CTHEI>
		       <COND (<PRSO? PRSI>
			      <TELL " looks confused." CR>)
			     (T
			      <TELL " glances at " THEO
				    ", but doesn't respond." CR>)>)
		      (T
		       <NOT-LIKELY ,PRSI "would respond">)>)
	       (T
		<TELL "You point at " THEO ", but nothing "
		      PNEXT ,YAWNS " happens." CR>)>
	 T>

<DEFINE V-SPOINT-AT ()
	 <PERFORM ,V?POINT-AT ,PRSI ,PRSO>
	 T>

<DEFINE V-POINT-AT ()
	 <TELL "You ">
	 <ZPRINTB ,P-PRSA-WORD>
	 <SPACE>
	 <TELL THEO " at " THEI ", but nothing " PNEXT ,YAWNS
	       " happens." CR>
	 T>

<DEFINE V-POUR ()
	 <COND (<PRSO? HANDS>
		<TELL "[To do that, just DROP EVERYTHING.]" CR>
		,FATAL-VALUE)
	       (<PRSO? POCKET>
		<YOUD-HAVE-TO "take off" ,CLOTHES>
		T)
	       (<IS? ,PRSO ,SURFACE>
		<EMPTY-PRSO ,GROUND>
		T)
	       (<IS? ,PRSO ,CONTAINER>
		<COND (<IS? ,PRSO ,OPENED>
		       <EMPTY-PRSO ,GROUND>)
		      (T
		       <ITS-CLOSED>)>
		T)
	       (T
		<TELL ,CANT "empty that." CR>
		T)>>

<DEFINE V-POUR-FROM ()
	 <COND (<PRSI? HANDS>
		<PERFORM ,V?DROP ,PRSO>)
	       (<PRSI? POCKET>
		<YOUD-HAVE-TO "take off" ,CLOTHES>)
	       (<AND <NOT <IS? ,PRSI ,CONTAINER>>
		     <NOT <IS? ,PRSI ,SURFACE>>>
		<ZPRINT ,CANT>
		<ZPRINTB ,P-PRSA-WORD>
		<TELL " things from " A ,PRSI ,PERIOD>)
	       (<AND <IS? ,PRSI ,CONTAINER>
		     <NOT <IS? ,PRSI ,OPENED>>>
		<ITS-CLOSED ,PRSI>)
	       (<IN? ,PRSO ,PRSI>
		<COND (<IS? ,PRSO ,TAKEABLE>
		       <TELL CTHEO>
		       <SPACE>
		       <FALLS>)
		      (T
		       <IMPOSSIBLE>)>)
	       (T
		<TELL CTHEO " isn't in " THEI ,PERIOD>)>
	 T>

<DEFINE V-EMPTY-INTO ()
	 <COND (<PRSI? HANDS ME>
		<V-EMPTY ,PLAYER>)
	       (<PRSI? GROUND>
		<V-EMPTY ,PRSI>)
	       (<IS? ,PRSI ,SURFACE>
		<V-EMPTY ,PRSI>)
	       (<IS? ,PRSI ,CONTAINER>
		<COND (<IS? ,PRSI ,OPENED>
		       <V-EMPTY ,PRSI>)
		      (T
		       <ITS-CLOSED ,PRSI>)>)
	       (T
		<TELL ,CANT "empty " THEO " into " THEI ,PERIOD>)>
	 T>

<DEFINE V-EMPTY ("OPTIONAL" (DEST <>))
	 <COND (<ZERO? .DEST>
		<SET DEST ,PLAYER>)>
	 <COND (<IS? ,PRSO ,SURFACE>
		<EMPTY-PRSO .DEST>)
	       (<IS? ,PRSO ,CONTAINER>
		<COND (<IS? ,PRSO ,OPENED>
		       <EMPTY-PRSO .DEST>)
		      (T
		       <ITS-CLOSED ,PRSO>)>)
	       (T
		<TELL ,CANT "possibly empty " THEO ,PERIOD>)>
	 T>
		
<DEFINE EMPTY-PRSO (DEST "AUX" OBJ NXT X)
	 <SET OBJ <FIRST? ,PRSO>>
	 <COND (<ZERO? .OBJ>
		<TELL "There's nothing ">
		<COND (<IS? ,PRSO ,SURFACE>
		       <TELL "on ">)
		      (T
		       <TELL "in ">)>
		<TELL THEO ,PERIOD>)
	       (T
		<SETG P-MULT? T>	
		<REPEAT ()
			<SET NXT <NEXT? .OBJ>>
			<TELL CTHE .OBJ ": ">
			<COND (<EQUAL? .DEST ,PLAYER>
			       <SET X <PERFORM ,V?TAKE .OBJ ,PRSO>>
			       <COND (<EQUAL? .X ,FATAL-VALUE>
				      <RETURN>)>)
			      (<EQUAL? .DEST ,GROUND>
			       <COND (<IS? ,PRSO ,PLURAL>
				      <TELL "They ">)
				     (T
				      <TELL "It ">)>
			       <FALLS>)
			      (<G? <- <+ <WEIGHT .DEST>:FIX <WEIGHT .OBJ>:FIX>
				      <GETP .DEST ,P?SIZE>:FIX>
				   <GETP .DEST ,P?CAPACITY>:FIX>
			       <TELL "There isn't enough room ">
			       <COND (<IS? .DEST ,CONTAINER>
				      <TELL "in ">)
				     (T
				      <TELL "on ">)>
			       <TELL THE .DEST ,PERIOD>)
			      (T
			       <MOVE .OBJ .DEST>
			       <TELL "Done." CR>)>
			<SET OBJ .NXT>
			<COND (<ZERO? .OBJ>
			       <RETURN>)>>
		<SETG P-MULT? <>>)>
	 T>

<DEFINE V-PULL ()
	 <HACK-HACK "Pulling on">
	 T>

<DEFINE V-PUSH ()
	 <HACK-HACK "Pushing around">
	 T>

<DEFINE V-PUSH-TO ()
	 <COND (<AND <PRSO? HANDS>
		     <T? ,PRSI>>
		<PERFORM ,V?REACH-IN ,PRSI>)
	       (T
		<TELL ,CANT "push " THEO " around like that." CR>)>
	 T>

<DEFINE PRE-POCKET ()
	 <COND (<WRONG-WINNER?>
		T)
	       (<IN? ,PRSO ,GLOBAL-OBJECTS>
		<IMPOSSIBLE>
		T)
	       (<IN? ,PRSO ,POCKET>
		<TELL CTHEO>
		<IS-ARE>
		<TELL "already in " D ,POCKET ,PERIOD>
		T)
	       (T
		<>)>>
	 
<DEFINE V-POCKET ()
	 <PERFORM ,V?PUT ,PRSO ,POCKET>
	 T>

<DEFINE PRE-DROP ()
	<COND (<==? ,P-PRSA-WORD ,W?DEPOSIT>
	       <COND (<HERE? BANK>
		      <COND (<PRSO? MONEY CHECK> <>)
			    (ELSE
			     <TELL "The bank does not accept deposits in kind."
				   CR>
			      T)>)
		     (ELSE <>)>)
	      (ELSE <>)>>

<DEFINE PRE-PUT ()
	 <COND (<PRSO? CLOTHES>
		<INAPPROPRIATE>
		T)
	       (<PRSO? PRSI>
		<HOW?>
		T)
	       ;(<PRSI? INTDIR RIGHT LEFT>
		<TELL "[You must specify an object.]" CR>
		T)
	       (<PRSI? HANDS>
		<NOT-LIKELY ,PRSO "would fit very well">
		T)
	       (<EQUAL? ,FEET ,PRSO ,PRSI>
		<WASTE-OF-TIME>
		T)
	       (<==? ,PRSI ,MOUTH> <>)
	       (<IN? ,PRSI ,GLOBAL-OBJECTS>
		<IMPOSSIBLE>
		T)
	       (<PRSO? HANDS>
		<PERFORM ,V?REACH-IN ,PRSI>
		T)
	       (<IN? ,PRSO ,PRSI>
		<TELL CTHEO>
		<IS-ARE>
		<TELL "already ">
		<COND (<IS? ,PRSI ,SURFACE>
		       <TELL "o">)
		      (T
		       <TELL "i">)>
		<TELL "n " THEI ,PERIOD>
		T)
	       (<EQUAL? ,PRSO ,TREATS ,MPLUG ,BWIRE ,RWIRE ,AIRLINE-MEAL> <>)
	       (<OR <EQUAL? ,PRSO ,PRSI>
		    <IN? ,PRSO ,GLOBAL-OBJECTS>
		    <NOT <IS? ,PRSO ,TAKEABLE>>>
		<IMPOSSIBLE>
		T)
	       (<==? ,PRSI ,RANDOM-OBJECT> <>)
	       (<NOT <ACCESSIBLE? ,PRSI>>
		<CANT-SEE-ANY ,PRSI>
		T)
	       (<AND <IS? ,PRSO ,WORN>
		     <IN? ,PRSO ,PLAYER>
		     <NOT <PRSI? ME>>>
		<TAKE-OFF-PRSO-FIRST>
		<>)
	       (T
		<>)>>

<DEFINE TAKE-OFF-PRSO-FIRST ()
	 <UNMAKE ,PRSO ,WORN>
	 <TELL "[taking off " THEO " first" ,BRACKET>         
	 T>

<DEFINE PRE-PUT-ON ()
	 <COND (<EQUAL? ,PRSI ,WALLS ,GROUND>
		<>)
	       (<PRE-PUT>
		T)
	       (<PRSI? SHITMAIL AIRLINE-MEAL> <>)
	       (<EQUAL? ,RANDOM-PERSON ,PRSO ,PRSI> <>)
	       (<NOT <IS? ,PRSI ,SURFACE>>
		<NO-GOOD-SURFACE>
		T)
	       (T
		<>)>>

<DEFINE NO-GOOD-SURFACE ()
	 <TELL "There's no good surface on " THEI ,PERIOD>
	 T>

<DEFINE V-PUT-ON () 
	 <COND (<PRSI? ME>
		<PERFORM ,V?WEAR ,PRSO>)
	       (T
		<V-PUT>)>
	 T>

<DEFINE V-PUT PUT ("AUX" L)
	 <SET L <LOC ,PRSO>>
	 <COND (<OR <ZERO? .L>
		    <AND <T? ,PRSI>
		     	 <NOT <IS? ,PRSI ,SURFACE>>
		     	 <NOT <IS? ,PRSI ,CONTAINER>>			 
			 <NOT <IS? ,PRSI ,OPENED>>
		     	 <NOT <IS? ,PRSI ,OPENABLE>>>>
		<IMPOSSIBLE>
		<RETURN T .PUT>)
	       (<AND <NOT <IS? ,PRSI ,OPENED>>
		     <NOT <IS? ,PRSI ,SURFACE>>>
		<THIS-IS-IT ,PRSI>
		<TELL CTHEI>
		<ISNT-ARENT ,PRSI>
		<TELL "open." CR>
		<RETURN T .PUT>)
	       (<G? <- <+ <WEIGHT ,PRSI> <WEIGHT ,PRSO>>
		       <GETP ,PRSI ,P?SIZE>:FIX>
		    <GETP ,PRSI ,P?CAPACITY>:FIX>
		<TELL "There isn't enough room ">
		<COND (<==? ,PRSI ,UNDER-SEAT> T)
		      (<IS? ,PRSI ,CONTAINER>
		       <TELL "in ">)
		      (T
		       <TELL "on ">)>
		<TELL THEI ,PERIOD>
		<RETURN T .PUT>)
	       (<NOT <EQUAL? .L ,PLAYER>>
		<TELL "Maybe you should take " THEO>
		<COND (<AND <IS? .L ,SURFACE>
			    <N==? .L ,ENVELOPE>>
		       <TELL " off ">)
		      (T
		       <TELL " out of ">)>
		<TELL THE .L " first." CR>
		<RETURN T .PUT>)>
	 <MOVE ,PRSO ,PRSI>
	 <MAKE ,PRSO ,TOUCHED>
	 <COND (<T? ,P-MULT?>
		<TELL "Done." CR>
		<RETURN T .PUT>)>
	  <TELL "You put " THEO>
	  <COND (<==? ,PRSI ,UNDER-SEAT> T)
		(<IS? ,PRSI ,CONTAINER>
		 <TELL " in">)
		(T
		 <TELL " on">)>
	  <TELL " " THEI ,PERIOD>
	  T>

<DEFINE PRE-SINGLE-CONNECT ()
  <COND (<OR <T? ,OBJECTS-GROUPED>
	     <AND <F? ,P-MULT?>
		  <PRSO-NOUN-USED? ,W?WIRES>>> <>)
	(<T? ,P-MULT?>
	 <SETG P-MULT? <>>
	 <COND (<==? <ZGET ,P-PRSO 0> 2>
		<PERFORM ,V?PLUG <ZGET ,P-PRSO 1> <ZGET ,P-PRSO 2>>
		T)
	       (T
		<TELL "You can connect only two objects at a time." CR>
		,FATAL-VALUE)>)
	(T
	 <ZPUT ,P-ITBL ,P-PREP2
	       ,PR?TO>
	 <SYNTAX-CHECK T>
	 ,FATAL-VALUE)>>

<DEFINE V-SINGLE-CONNECT ()
  <TELL "You can never get here." CR>>

<DEFINE V-PLUG ()
	 <ZPRINT ,CANT>
	 <ZPRINTB ,P-PRSA-WORD>
	 <SPACE>
	 <TELL THEO " into ">
	 <COND (<T? ,PRSI>
		<TELL THEI>)
	       (T
		<TELL "anything">)>
	 <ZPRINT ,PERIOD>
	 T>
	
<DEFINE V-REPLUG ()
	 <TELL CTHEO " was never connected to ">
	 <COND (<T? ,PRSI>
		<TELL THEI ,PERIOD>)
	       (T
		<TELL "anything." CR>)>
	 T>

<DEFINE V-UNPLUG ()
	 <TELL CTHEO>
	 <ISNT-ARENT>
	 <TELL "connected to ">
	 <COND (<T? ,PRSI>
		<TELL THEI>)
	       (T
		<TELL "anything">)>
	 <ZPRINT ,PERIOD>
	 T>

<DEFINE V-PUT-BEHIND ()
	 <TELL "That hiding place is too obvious." CR>
	 T>

<DEFINE V-PUT-UNDER ()
         <TELL ,CANT "put anything under that." CR>
	 T>
	       
;<DEFINE V-RAPE ()
	 <TELL "What a wholesome idea." CR>
	 T>

<DEFINE V-RAISE ()
	 <COND (<PRSO? ROOMS>
		<V-STAND>)
	       (T
		<HACK-HACK "Toying in this way with">)>
	 T>

<DEFINE V-REACH-IN ("AUX" OBJ)
	 <SET OBJ <FIRST? ,PRSO>>
	 <COND (<OR <IS? ,PRSO ,PERSON>
		    <IS? ,PRSO ,LIVING>>
		<NOT-A "Q\33-86-A" "surgeon">)
	       (<IS? ,PRSO ,DOORLIKE>
		<COND (<IS? ,PRSO ,OPENED>
		       <TELL "You reach into " THEO
			     ", but experience nothing "
			     PNEXT ,YAWNS ,PERIOD>)
		      (T
		       <ITS-CLOSED>)>)
	       (<NOT <IS? ,PRSO ,CONTAINER>>
		<IMPOSSIBLE>)
	       (<NOT <IS? ,PRSO ,OPENED>>
		<TELL "It's not open." CR>)
	       (<OR <ZERO? .OBJ>
		    <NOT <IS? .OBJ ,TAKEABLE>>>
		<TELL "It's empty." CR>)
	       (T
		<SETG P-IT-OBJECT .OBJ>
		<TELL "You reach into " THEO " and feel something." CR>)>
	 T>

<DEFINE V-READ ()
	 <COND ;(<ZERO? ,LIT?>
		<TOO-DARK>
		,FATAL-VALUE)
	       (<NOT <IS? ,PRSO ,READABLE>>
		<HOW-READ>
		<TELL "?" CR>)
	       (T
		<TELL "There's nothing written on it." CR>)>>

<DEFINE V-READ-TO ()
	 <COND ;(<ZERO? ,LIT?>
		<TOO-DARK>
		,FATAL-VALUE)
	       (<NOT <IS? ,PRSO ,READABLE>>
		<HOW-READ>
		<TELL " to " A ,PRSI "?" CR>)
	       (<EQUAL? ,WINNER ,PLAYER>
		<NOT-LIKELY ,PRSI "would appreciate your reading">
		T)
	       (T
		<TELL "Maybe you ought to do it." CR>)>>

<DEFINE HOW-READ ()
	 <TELL "How can you read " A ,PRSO>
	 T>

<DEFINE V-RELEASE ()
	 <COND (<IN? ,PRSO ,WINNER>
		<PERFORM ,V?DROP ,PRSO>)
	       (T
		<COND (<PRSO? ME>
		       <TELL "You aren't ">)
	              (T
		       <TELL CTHEO>
		       <ISNT-ARENT>)>
	        <TELL "confined by anything." CR>)>
	 T>
		
<DEFINE V-REPLACE ()
	 <COND (<PRSO? ME>
		<TELL "Easily done." CR>)
	       (T
		<TELL CTHEO " doesn't need replacement." CR>)>
	 T>

<DEFINE V-REPAIR ()
	 <COND (<PRSO? ME>
		<TELL "You aren't ">)
	       (T
		<TELL CTHEO>
		<ISNT-ARENT>)>
	 <TELL "in need of repair." CR>
	 T>

<DEFINE V-HELP ()
	 <COND (<OR <F? ,PRSO>
		    <PRSO? ME>>
		<TELL 
"[If you're really stuck, maps and InvisiClues(TM) Hint Booklets are available at most Infocom dealers, or use the order form included, at the last minute and at great expense, in your ">
		<ITALICIZE "Bureaucracy">
		<TELL " package.]" CR>)
	       (T
		<TELL CTHEO>
		<COND (<IS? ,PRSO ,PLURAL>
		       <TELL " do">)
		      (T
		       <TELL " does">)>
		<TELL "n't need any help." CR>)>
	 T>

<DEFINE V-RIDE ()
	 <COND (<IS? ,PRSO ,LIVING>
		<NOT-LIKELY ,PRSO "wants to play piggyback">)
	       (T
		<TELL ,CANT "ride that." CR>)>
	 T>

<DEFINE V-TOUCH ()
	 <HACK-HACK "Fiddling with">
	 T>

<DEFINE V-STOUCH-TO ()
	 <PERFORM ,V?TOUCH-TO ,PRSI ,PRSO>
	 T>

<DEFINE V-TOUCH-TO ()
	 <COND (<PRSO? HANDS>
		<PERFORM ,V?TOUCH ,PRSI>)
	       (T
		<TELL "You ">
		<ZPRINTB ,P-PRSA-WORD>
		<TELL " " THEO " next to " THEI
		      ", but nothing " PNEXT ,YAWNS " happens." CR>)>
	 T>	 

<DEFINE V-TYPE () <TELL ,CANT "type on that." CR>>

<DEFINE V-BOW ()
	 <HACK-HACK "Paying respect to">
	 T>

<DEFINE V-SEARCH ()
	 <COND (<IS? ,PRSO ,PLACE>
		<CANT-SEE-MUCH>)
	       (<IS? ,PRSO ,CONTAINER>
		<COND (<AND <NOT <IS? ,PRSO ,OPENED>>
			    <NOT <IS? ,PRSO ,TRANSPARENT>>>
		       <YOUD-HAVE-TO "open" ,PRSO>)
		      (T
		       <TELL ,YOU-SEE>
		       <PRINT-CONTENTS ,PRSO>
		       <TELL " inside " THEO ,PERIOD>)>)
	       (<IS? ,PRSO ,SURFACE>
		<TELL ,YOU-SEE>
		<PRINT-CONTENTS ,PRSO>
		<TELL " on " THEO ,PERIOD>)
	       (<IS? ,PRSO ,PERSON>
		<PERFORM ,V?USE ,PRSO>) 
	       (T
		<NOTHING-INTERESTING>
		<ZPRINT ,PERIOD>)>
	 T>

<DEFINE V-SHAKE ("AUX" X)
	 <COND (<IS? ,PRSO ,PERSON>
		<PERFORM ,V?ALARM ,PRSO>)
	       (<AND <NOT <IS? ,PRSO ,TAKEABLE>>
		     <NOT <IS? ,PRSO ,TRYTAKE>>>
		<HACK-HACK "Shaking">)
	       (T
		<WASTE-OF-TIME>)>
	 T>

<DEFINE V-SHOOT ()
	 <TELL ,DONT "have any weapons." CR>
	 T>

<DEFINE V-SIT ()
	 <COND (<HERE? SEAT>
		<YOURE-ALREADY "quite comfortable">)
	       (<AND <PRSO? ROOMS>
		     <HERE? AISLE>>
		<COND (<==? <COUNT-OCCUPIED-SEATS> 3>
		       <COND (<NOT <AND <OCCUPIED? ,SEAT-B>
					<OCCUPIED? ,SEAT-C>>>
			      <DO-WALK ,P?WEST>)
			     (T
			      <DO-WALK ,P?EAST>)>)
		      (T
		       <TELL "There's more than one empty seat here." CR>)>)
	       (T
		<NO-PLACE-TO-PRSA>)>
	 T>

<DEFINE NO-PLACE-TO-PRSA ()
	 <TELL "There's no place to ">
	 <ZPRINTB ,P-PRSA-WORD>
	 <TELL " here." CR>
	 T>

<DEFINE V-SMELL ("AUX" (OBJ <>))
	 <COND (<PRSO? ROOMS>
		<SET OBJ <GETP ,HERE ,P?ODOR>>
		<COND (<ZERO? .OBJ>
		       <TELL ,DONT "smell anything " PNEXT ,YAWNS
			     ,PERIOD>)
		      (T
		       <PERFORM ,V?SMELL .OBJ>)>)
	       (T
		<TELL "It smells just like " A ,PRSO ,PERIOD>)>
	 T>

<DEFINE V-SPIN ()
	 <COND (<PRSO? ROOMS ME>
		<TELL "You begin to feel a little dizzy." CR>)
	       (T
		<TELL ,CANT "spin that." CR>)>
	 T>

<DEFINE V-DUCK ()
	 <WASTE-OF-TIME>
	 T>

<DEFINE V-STAND ()
	 <COND (<AND <IN? ,PLAYER ,JAIL> <IS? ,GENERATOR ,SEEN>>
		<TELL "You stop pedalling and get off " THE ,GENERATOR
			    ,PERIOD>
		<UNMAKE ,GENERATOR ,SEEN>)
	       (<IN? ,PLAYER ,SEAT>
		<DO-WALK ,P?OUT>)
	       (ELSE
		<ALREADY-STANDING>)>
	 T>

<DEFINE ALREADY-STANDING ()
	 <YOURE-ALREADY "standing">
	 T>

<DEFINE V-STAND-ON ()
	 <WASTE-OF-TIME>
	 T>

<DEFINE V-STAND-UNDER ()
	 <IMPOSSIBLE>
	 T>

<DEFINE V-SWING ()
	 <COND (<ZERO? ,PRSI>
		<WASTE-OF-TIME>)
	       (T
		<PERFORM ,V?KILL ,PRSI ,PRSO>)>
	 T>

<DEFINE V-SWIM ()
	 <COND (<PRSO? ROOMS>
		<NO-PLACE-TO-PRSA>)
	       (<AND <PRSO? INTDIR>
		     <T? ,P-DIRECTION>
		     <EQUAL? ,WINNER ,PLAYER>>
		<ZPRINT ,CANT>
		<ZPRINTB ,P-PRSA-WORD>
		<TELL " that way from here." CR>)
	       (T
		<IMPOSSIBLE>)>
	 T>

<DEFINE V-DIVE ()
	 <COND (<HERE? IN-AIR OUTSIDE-PLANE>
		<YOURE-ALREADY "doing all you can">)
	       (T
		<V-SWIM>)> 
	 T>

<DEFINE V-SGET-FOR ()
	 <PERFORM ,V?TAKE ,PRSI>
	 T>

<DEFINE V-GET-FOR ()
	 <PERFORM ,V?TAKE ,PRSO>
	 T>

<DEFINE V-TAKE-WITH ()
	 <HOW?>
	 T>

<DEFINE V-GET-OFF () <V-TAKE-OFF T>>

<DEFINE V-TAKE-OFF TAKE-OFF ("OPT" (GET <>) "AUX" OBJ)
	 <COND (<AND <PRSO? ROOMS> <NOT .GET>>
		<SET OBJ <FIRST? ,WINNER>>
		<REPEAT ()
			<COND (<ZERO? .OBJ>
			       <V-WALK-AROUND>
			       <RETURN T .TAKE-OFF>)
			      (<IS? .OBJ ,WORN>
			       <RETURN>)>
			<SET OBJ <NEXT? .OBJ>>>
		<TELL "[" THE .OBJ ,BRACKET>
		<SET OBJ <PERFORM ,V?TAKE-OFF .OBJ>>)
	       (<PRSO? CLOTHES FEET>
		<INAPPROPRIATE>)
	       (<IS? ,PRSO ,PLACE>
		<NOT-IN>)
	       (<IS? ,PRSO ,TAKEABLE>
		<COND (<AND <IN? ,PRSO ,WINNER>
		            <IS? ,PRSO ,WORN>>
		       <UNMAKE ,PRSO ,WORN>
		       <TELL "You take off " THEO ,PERIOD>)
		      (<IN? ,PRSO ,WINNER>
		       <PERFORM ,V?DROP ,PRSO>)
		      (T
		       <PERFORM ,V?TAKE ,PRSO>)>)
	       (<IS? ,PRSO ,VEHBIT>
		<PERFORM ,V?EXIT ,PRSO>)
	       (T
		<IMPOSSIBLE>)>
	 T>

<DEFINE V-TASTE ()
	 <PERFORM ,V?EAT ,PRSO>
	 T>

<DEFINE V-ADJUST ()
	 <TELL CTHEO " doesn't need adjustment." CR>
	 T>

"*** CHARACTER INTERACTION DEFAULTS ***"

<DEFINE SILLY-SPEAK? ()
	 <COND (<N==? ,WINNER ,PLAYER> <>)
	       (<EQUAL? ,PRSO <> ,ROOMS>
		<>)
	       (<NOT <IS? ,PRSO ,PERSON>>
		<NOT-LIKELY ,PRSO "would respond">
	 	<PCLEAR>
		T)
	       (<PRSO? ME PRSI WINNER>
		<WASTE-OF-TIME>
		<PCLEAR>
		T)
	       (T
		<THIS-IS-IT ,PRSO>
		<>)>>

<DEFINE NO-RESPONSE ("AUX" OBJ)
	 <COND (<N==? ,WINNER ,PLAYER> <SET OBJ ,WINNER>)
	       (T <SET OBJ ,PRSO>)>
	 <TELL CTHE .OBJ>
	 <COND (<IS? .OBJ ,PLURAL>
		<TELL " don't">)
	       (T
		<TELL " doesn't">)>
	 <TELL " respond." CR>
	 <PCLEAR>
	 T>

<DEFINE V-ASK-ABOUT ()
	 <COND (<SILLY-SPEAK?>
		,FATAL-VALUE)
	       (<EQUAL? ,WINNER ,PRSI>
		<WASTE-OF-TIME>
		,FATAL-VALUE)
	       (<PRSO? ME>
		<TALK-TO-SELF>
		T)
	       (T
		<NO-RESPONSE>
		T)>>

"CHAR = character, OBJ = object of interest,
 SUB-TBL = LTABLE of <OBJECT 'string'> tables, FLAG = char's 'told' flag."

<DEFINE ASK-CHAR-ABOUT ASK
	(CHAR OBJ SUB-TBL FLAG "OPT" (INV-FCN <>)
	 "AUX" (PTR:FIX 1) LEN:FIX TBL SUBJECT)
	 <SET LEN <ZGET .SUB-TBL 0>>
	 <REPEAT ()
		 <SET TBL <ZGET .SUB-TBL .PTR>>
		 <SET SUBJECT <ZGET .TBL 0>>
		 <COND (<EQUAL? .OBJ .SUBJECT>
			<COND (<AND <N==? .FLAG 0> <IS? .SUBJECT .FLAG>>
			       <TELL CTHE .CHAR
" sighs. \"I already told you about ">
			       <COND (<EQUAL? .SUBJECT .CHAR>
				      <TELL "myself">)
				     (<EQUAL? .SUBJECT ,WRISTWATCH>
				      <TELL " the time">)
				     (T
				      <TELL THE .SUBJECT>)>
			       <TELL ".\"" CR>
			       <RETURN T .ASK>)>
			<COND (<N==? .FLAG 0> <MAKE .SUBJECT .FLAG>)>
			<TELL "\"" <ZGET .TBL 1> "\"" CR>
			<RETURN T .ASK>)
		       (<G? <SET PTR <+ .PTR 1>> .LEN>
			<RETURN>)>>
	 <COND (<NOT <VISIBLE? .OBJ>>
		<COND (<T? .INV-FCN>
		       <ZAPPLY .INV-FCN .CHAR .OBJ>)
		      (T
		       <TELL CTHE .CHAR 
" looks puzzled. \"I'm not sure I know what you're talking about.\"" CR>)>)
	       (T
		<TELL CTHE .CHAR " shrugs. \"What about it?\"" CR>)>
	 T>

<DEFINE IGNORES (WHO)
	 <PCLEAR>
	 <TELL CTHE .WHO>
	 <COND (<VERB? THANK>
		<TELL " nods, but says nothing">)
	       (T
		<COND (<PROB 50>
		       <TELL " decide"> 
		       <COND (<NOT <IS? .WHO ,PLURAL>>
			      <TELL "s">)>
		       <TELL " to ignore">)
		      (T
		       <TELL " pretend">
		       <COND (<NOT <IS? .WHO ,PLURAL>>
			      <TELL "s">)>
		       <TELL " not to hear">)>
		<TELL " your request">)>
	 <TELL ,PERIOD>
	 T>

<DEFINE V-REPLY ("AUX" WHO)
	 <COND (<SILLY-SPEAK?>
		,FATAL-VALUE)
	       (T
		<NO-RESPONSE>
		T)>>

<DEFINE V-STUPID-ASK ("AUX" PERS)
  <COND (<SET PERS <ANYONE-HERE?>>
	 <PERFORM ,V?ASK-ABOUT .PERS ,PRSO>)
	(T
	 <TELL "There doesn't seem to be anyone here to ask." CR>
	 ,FATAL-VALUE)>>

<DEFINE V-QUESTION ()
	 <COND (<EQUAL? ,WINNER ,PLAYER>
		<TO-DO-THING-USE "ask about" "ASK CHARACTER ABOUT">
		,FATAL-VALUE)
	       (T
		<NO-RESPONSE>
		T)>>
		        
<DEFINE V-ALARM ALARM ()
	 <COND (<SILLY-SPEAK?>
		<RETURN ,FATAL-VALUE .ALARM>)>
	 <COND (<PRSO? ROOMS ME>
		<YOURE-ALREADY "wide awake">)
	       (<IS? ,PRSO ,LIVING>
		<TELL CTHEO>
		<IS-ARE>
		<TELL "already wide awake." CR>)
	       (T
		<IMPOSSIBLE>)>
	 T>

<DEFINE V-YELL ()
	 <COND (<PRSO? ROOMS>
		<TELL "You begin to get a sore throat." CR>)
	       (T
		<NOT-LIKELY ,PRSO "would respond">)>
	 T>

<DEFINE V-SAY ("AUX" PERSON)
	 <COND (<CHECK-FOR-PARANOID>
		T)
	       (<AND <PRSO? INTNUM>
		     <EQUAL? ,P-PRSA-WORD ,W?CALL>>
		<PERFORM ,V?PHONE ,PRSO>)
	       (<EQUAL? ,WINNER ,PLAYER>
	        <COND (<AND <SET PERSON <ANYONE-HERE?>>
			    <T? ,QUOTE-FLAG>
			    <T? ,P-CONT>>
		       <SETG WINNER .PERSON>)
		      (<T? .PERSON>
		       <WAY-TO-TALK>)
		      (T
		       <TALK-TO-SELF>)>)
	       (T
		<NO-RESPONSE>)>
	 T>

<DEFINE V-GOODBYE ()
	 <V-HELLO>
	 T>

<DEFINE V-HELLO ()
         <COND (<SILLY-SPEAK?>
	        ,FATAL-VALUE)
	       (<PRSO? ROOMS>
		<TALK-TO-SELF>
		T)
	       (<AND <T? ,PRSO>
		     <IS? ,PRSO ,LIVING>>
		<TELL CTHEO " nods politely." CR>
		T)
	       (<N==? ,WINNER ,PLAYER>
		<TELL CTHE ,WINNER " nods politely." CR>
		T)
	       (T
		<NO-RESPONSE>
		T)>>
	 
<DEFINE V-WAVE-AT ()
	 <V-WHAT>
	 T>

<OBJECT REQUEST-OBJECT
	(LOC GLOBAL-OBJECTS)
	(DESC "that")
	(FLAGS NODESC NOARTICLE)
	(SYNONYM GRANTED DENIED REQUEST PERMISSION)
	(ACTION REQUEST-OBJECT-F)>

<DEFINE REQUEST-OBJECT-F ()
  <COND (<HERE? IN-TOWER>
	 <COND (<FLIGHT-DONE?>)
	       (<NOUN-USED? ,W?REQUEST ,W?PERMISSION>
		<COND (<VERB? DENY>
		       <TURN-AROUND-PLANE>)
		      (<VERB? GRANT>
		       <GRANT-PLANE-REQUEST>)>)
	       (<VERB? REQUEST>
		<COND (<NOUN-USED? ,W?GRANTED>
		       <GRANT-PLANE-REQUEST>)
		      (<NOUN-USED? ,W?DENIED>
		       <TURN-AROUND-PLANE>)>)
	       (T
		<REFERRING>)>)
	(T
	 <REFERRING>)>
  T>

<DEFINE V-REQUEST ("AUX" L)
	 <SET L <ANYONE-HERE?>>
	 <COND (<ZERO? .L>
		<NOBODY-TO-ASK>)
	       (T
		<SPOKEN-TO .L>
		<PERFORM ,V?ASK-FOR .L ,PRSO>)>
	 T>	       

<DEFINE V-GRANT ()
	 <REFERRING>
	 T>

<DEFINE V-DENY ()
	 <REFERRING>
	 T>	 

<DEFINE V-ASK-FOR ("AUX" WHO)
	 <COND (<SILLY-SPEAK?>
		,FATAL-VALUE)
	       (<OR <EQUAL? ,WINNER ,PRSI>
		    <NOT <IS? ,PRSI ,TAKEABLE>>>
		<IMPOSSIBLE>
		T)
	       (T
		<NO-RESPONSE>
		T)>>

<DEFINE V-TELL ()
	 <COND (<CHECK-OZ-ROYALTY ,PRSO>
		<COND (<AND <T? ,P-CONT>
			    <F? ,P-ALT-CONT>>
		       <SETG P-ALT-CONT ,P-CONT>)>
		<PCLEAR>
		,FATAL-VALUE)
	       (<SILLY-SPEAK?>
		,FATAL-VALUE)
	       (<PRSO? ME>
		<COND (<EQUAL? ,WINNER ,PLAYER>
		       <TALK-TO-SELF>)
		      (T
		       <NO-RESPONSE>)>
		T)
	       (T
		<COND (<NOT <PRSO? INCIDENT UNFORTUN>>
		       <COND (<==? <SETG QCONTEXT ,PRSO> ,RANDOM-PERSON>
			      <SETG QCONTEXT-ROOM ,SEAT>)
			     (T
			      <SETG QCONTEXT-ROOM <LOC ,PRSO>>)>)>
	        <COND (<T? ,P-CONT>
		       <SETG P-ALT-CONT ,P-CONT>
		       <SETG WINNER ,PRSO>
		       <THIS-IS-IT ,PRSO>)
		      (T
		       <NO-RESPONSE>)>
		T)>>

<DEFINE PRE-TIME ("AUX" (ONP ,NOW-PRSI?))
	<SETG NOW-PRSI? T>
	<COND (<AND <PRSI? ,WRISTWATCH>
		    <PRSO? ,ME>
		    <PRSI-NOUN-USED? ,W?TIME>>
	       <SETG NOW-PRSI? .ONP>
	       <>)
	      (<N==? ,WINNER ,PLAYER>
	       <PERFORM ,V?TELL-ABOUT ,PRSO ,PRSI>)
	      (T
	       <SETG NOW-PRSI? .ONP>
	       <TELL "That makes no sense to computers." CR>
	       T)>>

<DEFINE PRE-WHAT ()
	<COND (<AND <PRSO? ,WRISTWATCH> <PRSO-NOUN-USED? ,W?TIME>>
	       <PERFORM ,V?TELL-TIME ,ME ,WRISTWATCH>)
	      (ELSE <>)>>
	       

<DEFINE V-TELL-TIME ()
	<V-TIME>>

<DEFINE V-TELL-ABOUT ()
	 <COND (<NOT <EQUAL? ,WINNER ,PLAYER>>
		<TELL CTHE ,WINNER>
		<COND (<PRSO? ME>
		       <TELL
" shrugs. \"I don't know anything about " THEI " you don't know." CR>)
		      (T
		       <TELL " snorts. \"Don't be ridiculous.\"" CR>)>)
	       (<PRSO? ME>
		<PERFORM ,V?EXAMINE ,PRSI>)
	       (T
		<V-WHAT>)>
	 T>

<DEFINE V-THANK ("AUX" OBJ)
	 <COND (<SILLY-SPEAK?>
		,FATAL-VALUE)
	       (<EQUAL? ,WINNER ,PLAYER>
		<COND (<F? ,PRSO>
		       <SET OBJ <ANYONE-HERE?>>)
		      (T
		       <SET OBJ ,PRSO>)>
		<COND (<==? .OBJ ,PLAYER>
		       <TELL "Self-congratulations">
		       <WONT-HELP>)
		      (.OBJ
		       <TELL "There's no need to thank " THE .OBJ ,PERIOD>)
		      (T
		       <TELL "You're welcome" ,PERIOD>)>
		T)>>

<DEFINE V-WHO ()
	 <V-WHAT>
	 T>

<DEFINE V-WHERE ()
	 <V-WHAT>
	 T>

<DEFINE V-WHAT ()
	 <COND (<SILLY-SPEAK?>
		,FATAL-VALUE)
	       (T
		<NO-RESPONSE>
		T)>>

<DEFINE V-THROUGH ()
	 <COND (<PRSO? ROOMS>
		<DO-WALK ,P?IN>
		T)
	       (<IS? ,PRSO ,LIVING>
		<V-LOOK-INSIDE>
		;<V-RAPE>
		T)
	       (T
		<IMPOSSIBLE>)>
	 T>

<DEFINE V-STHROW ()
	 <PERFORM ,V?THROW ,PRSI ,PRSO>
	 T>
		
<DEFINE PRE-THROW-OVER ()
	 <COND (<PRE-THROW>
		T)
	       (T
		<>)>>

<DEFINE V-THROW-OVER ()
	 <WASTE-OF-TIME>
	 T>

<DEFINE PRE-THROW ()
	 <COND (<==? ,PRSO ,AIRLINE-MEAL> <>)
	       (<PRE-PUT>
		T)
	       (T
		<>)>>

<DEFINE V-THROW ()
	 <COND (<IDROP>
		<TELL "Thrown" ,PCR CTHEO " lands on the ">
		<COND (<IS? ,HERE ,INDOORS>
		       <TELL "floor">)
		      (T
		       <TELL "ground">)>
		<TELL " nearby." CR>)>
	 T>
	 
<DEFINE V-TIE ()
	 <TELL ,CANT "possibly tie " THEO>
	 <COND (<T? ,PRSI>
		<TELL " to " THEI>)>
	 <ZPRINT ,PERIOD>
	 T>

<DEFINE V-TIE-UP ()
	 <TELL ,CANT "tie anything with that." CR>
	 T>

<DEFINE V-TURN ()
	 <COND (<AND <NOT <IS? ,PRSO ,TAKEABLE>>
		     <NOT <IS? ,PRSO ,TRYTAKE>>>
		<IMPOSSIBLE>)
	       (T
		<HACK-HACK "Turning">)>
	 T>

<DEFINE V-TURN-TO ()
	 <COND (<VISIBLE? ,PRSO>
		<PERFORM ,V?WATCH ,PRSO>)
	       (T
		<TELL ,DONT "see " THEO ,PERIOD>)>
	 T>

<DEFINE DO-WALK (DIR1 "OPTIONAL" (DIR2 <>) (DIR3 <>) "AUX" X)
	 <SETG P-WALK-DIR .DIR1>
	 <SET X <PERFORM ,V?WALK .DIR1>>
	 <COND (<AND <T? .DIR2>
		     <NOT <EQUAL? .X <> ,FATAL-VALUE>>>
		<ZCRLF>
		<SETG P-WALK-DIR .DIR2>
		<SET X <PERFORM ,V?WALK .DIR2>>
		<COND (<AND <T? .DIR3>
		            <NOT <EQUAL? .X <> ,FATAL-VALUE>>>
		       <ZCRLF>
		       <SETG P-WALK-DIR .DIR3>
		       <SET X <PERFORM ,V?WALK .DIR3>>)>)>
	 .X>

<DEFINE V-WALK WALK ("AUX" PT PTS STR OBJ RM)
	 <COND (<ZERO? ,P-WALK-DIR>
		<COND (<T? ,PRSO>
		       <TELL "[Presumably, you mean WALK TO " THEO 
			     "." ,BRACKET>
		       <PERFORM ,V?WALK-TO ,PRSO>)
		      (T
		       <V-WALK-AROUND>)>
		<RETURN T .WALK>)>
	 <SET PT <GETPT ,HERE ,PRSO>>
	 <COND (<T? .PT>
		<SET PTS <PTSIZE .PT>>
		<COND (<EQUAL? .PTS ,UEXIT>
		       <SET RM <GET-REXIT-ROOM .PT>>
		       <GOTO .RM>
		       <RETURN T .WALK>)
		      (<EQUAL? .PTS ,NEXIT>
		       <TELL <GET .PT ,NEXITSTR> CR>
		       <RETURN ,FATAL-VALUE .WALK>)
		      (<EQUAL? .PTS ,FEXIT>
		       <SET RM <APPLY <GET .PT ,FEXITFCN>>>
		       <COND (<ZERO? .RM>
			      <RETURN ,FATAL-VALUE .WALK>)
			     (T
			      <GOTO .RM>
			      <RETURN T .WALK>)>)
		      (<EQUAL? .PTS ,CEXIT>
		       <COND (<VALUE <GETB .PT ,CEXITFLAG>>
			      <GOTO <GET-REXIT-ROOM .PT>>
			      <RETURN T .WALK>)>
		       <SET STR <GET .PT ,CEXITSTR>>
		       <COND (<T? .STR>
			      <TELL .STR CR>
			      <RETURN ,FATAL-VALUE .WALK>)
			     (T
			      <CANT-GO>
			      <RETURN ,FATAL-VALUE .WALK>)>)
		      (<EQUAL? .PTS ,DEXIT>
		       <SET OBJ <GET-DOOR-OBJ .PT>>
		       <SET STR <GET .PT ,DEXITSTR>>
		       <COND (<IS? .OBJ ,OPENED>
			      <GOTO <GET-REXIT-ROOM .PT>>
			      <RETURN T .WALK>)
			     (<T? .STR>
			      <TELL .STR CR>
			      <THIS-IS-IT .OBJ>
			      <RETURN ,FATAL-VALUE .WALK>)
			     (T
			      <ITS-CLOSED .OBJ>
			      <RETURN ,FATAL-VALUE .WALK>)>)>)
	       (<AND <EQUAL? ,P-WALK-DIR ,P?OUT>
		     <NOT <IS? ,HERE ,INDOORS>>>
		<YOURE-ALREADY "outside">
		<RETURN ,FATAL-VALUE .WALK>)
	       (<AND <EQUAL? ,P-WALK-DIR ,P?IN>
		     <IS? ,HERE ,INDOORS>>
		<YOURE-ALREADY "inside">
		<RETURN ,FATAL-VALUE .WALK>)
	       (T
		<CANT-GO>
		<RETURN ,FATAL-VALUE .WALK>)>>

; <DEFINE BLOCKS-YOUR-PATH ("OPTIONAL" (OBJ <>))
	 <COND (<T? .OBJ>
		<THIS-IS-IT .OBJ>
		<TELL CTHE .OBJ>)>
	 <TELL " blocks your path." CR>
	 <RTRUE>>	 

<DEFINE V-WALK-AROUND ()
	 <PCLEAR>
	 <TELL "Which way do you want to go?" CR>
	 T>

<DEFINE GET-SYN (OBJ "AUX" TBL SYN)
  <SET TBL <GETPT .OBJ ,P?SYNONYM>>
  <COND (<EQUAL? <SET SYN <ZGET .TBL 0>> ,W?ZZZP ,W?B ,W?C ,W?D ,W?E>
	 <ZGET .TBL 1>)
	(T .SYN)>>

<DEFINE V-RETURN ("AUX" SYN TBL)
  <COND (<NOT <IS? ,PRSO ,LOCATION>>
	 <SET SYN <GET-SYN ,PRSO>>
	 <FAKE-VERB/NOUN ,W?GIVE <> <> .SYN>
	 ,FATAL-VALUE)
	(T
	 <PERFORM ,V?WALK-TO ,PRSO>)>>

<DEFINE ALREADY-THERE ()
  <YOURE-ALREADY "there">>

<DEFINE PRE-WALK-TO ()
	<COND (<AND <HERE? LAV-LOBBY>
		    <PRSO? LAV-LOBBY>
		    <PRSO-NOUN-USED? ,W?LAVATORY ,W?BATHROOM ,W?LAV>>
               <>)
	      (<AND <PRSO? HERE>
		    <NOT <EQUAL? ,PRSO ,SEAT ,AISLE ,BROOM>>
		    <N==? ,PRSO ,FROOM>>
	       <ALREADY-THERE>
	       T)
	      (<AND <PRSO? RANDOM-OBJECT>
		    <==? <GETP ,PRSO ,P?PSEUDO-TABLE> ,HATCH-OBJECT>>
	       <>)
	      (<AND <NOT <IS? ,PRSO ,LOCATION>>
		    <NOT <IS? ,PRSO ,PLACE>>
		    <NOT <IN? ,PRSO ,LOCAL-GLOBALS>>
		    <N==? ,PRSO ,ROOMS>>
	       <COND (<VERB? RETURN> <>)
		     (T
		      <TELL ,CANT "go to " THE ,PRSO "." CR>)>)
	      (<IN? ,PRSO ,ROOMS>
	       <COND (<OR <AND <IS? ,HERE ,IN-TERMINAL>
			       <IS? ,PRSO ,IN-TERMINAL>>
			  <AND <IS? ,HERE ,IN-TOWN>
			       <IS? ,PRSO ,IN-TOWN>>
			  <AND <IS? ,HERE ,IN-AIRPLANE>
			       <IS? ,PRSO ,IN-AIRPLANE>>>
		      ; "Make sure we aren't doing something ridiculous"
		      <>)
		     (T
		      <TELL ,CANT "get there from here." CR>)>)
	      (T <>)>>

<CONSTANT WALKING-TABLE <ITABLE 8 0>>

<DEFINE PERFORM-WALK-TO WALK-TO (ROOM "AUX" TT (WT ,WALKING-TABLE)
				 (CT 0) CF)
  <SET CF <GETP .ROOM ,P?ENTER-FROM>>
  <COND (<OR <F? .CF>
	     ; "Room has no enter from property"
	     <N==? ,HERE <ZGET .CF 1>>
	     ; "Or we're not in the room in question">
	 ; "If we're next door, stop"
	 <REPEAT ()
	   <COND (<T? <SET TT <GETP ,HERE ,P?EXIT-TO>>>
		  ; "First follow whatever path is set up to get out of here"
		  <GOTO .TT>
		  <COND (<N==? .TT ,HERE>
			 ; "Goto failed for some reason"
			 <RETURN <> .WALK-TO>)>
		  <COND (<EQUAL? ,HERE .ROOM .CF>
			 ; "Stop if we're where we want to be, or if we're
			    supposed to enter from here."
			 <RETURN T .WALK-TO>)>)
		 (T <RETURN>)>>)>
  <REPEAT ((TROOM .ROOM))
    ; "Now build the path to get into the new place"
    <COND (<T? <SET TT <GETP .TROOM ,P?ENTER-FROM>>>
	   <ZPUT .WT .CT <ZGET .TT 0>>
	   <ZPUT .WT <SET CT <+ .CT 1>> <SET TROOM <ZGET .TT 1>>>
	   <SET CT <+ .CT 1>>
	   <COND (<==? ,HERE <ZGET .TT 1>>
		  ; "Stop when we reach our current location"
		  <RETURN>)>)
	  (T
	   <RETURN>)>>
  <COND (<G? .CT 0>
	 ; "Go to the beginning of the entry path"
	 <COND (<N==? ,HERE <SET CF <ZGET .WT <SET CT <- .CT 1>>>>>
		<GOTO .CF>)>
	 <REPEAT (OH)
	   ; "And follow it"
	   <SET OH ,HERE>
	   <DO-WALK <ZGET .WT <SET CT <- .CT 1>>>>
	   <COND (<==? .OH ,HERE> <RETURN>)>
	   <COND (<L=? <SET CT <- .CT 1>> 0>
		  <RETURN>)>>)
	(T
	 <GOTO .ROOM>)>>

<DEFINE V-WALK-TO ()
	 <COND (<IN? ,PRSO ,ROOMS>
		<PERFORM-WALK-TO ,PRSO>)
	       (<PRSO? ROOMS>
		<V-WALK-AROUND>)
	       (<PRSO? INTDIR>
		<DO-WALK ,P-DIRECTION>)
	       ;(<PRSO? RIGHT LEFT>
		<MORE-SPECIFIC>)
	       (T
		<V-FOLLOW>)>
	 T>

<DEFINE V-WAIT ("OPTIONAL" (N:FIX 3) "AUX" (X <>))
	 <COND (<WRONG-WINNER?>
		,FATAL-VALUE)
	       (T
		<TELL "Time passes." CR>
		<REPEAT ()
			<COND (<OR <T? .X>
				   <L? .N 1>>
			       <RETURN>)
			      (<CLOCKER>
			       <SET X T>
			       <SETG CLOCK-WAIT? T>)>
			<SET N <- .N 1>>>
		T)>>

<DEFINE V-WAIT-FOR ()
	 <COND (<WRONG-WINNER?>
		,FATAL-VALUE)
	       (<PRSO? INTNUM>
		<COND (<ZERO? ,P-NUMBER>
		       <SETG CLOCK-WAIT? T>
		       <IMPOSSIBLE>)
		      (<G? ,P-NUMBER:FIX 120>
		       <SETG CLOCK-WAIT? T>
		       <TELL "[That's too long to WAIT.]" CR>)
		      (T
		       <V-WAIT <- ,P-NUMBER:FIX 1>>)>
		T)
	       (<VISIBLE? ,PRSO>
		<TELL CTHEO>
		<IS-ARE>
		<TELL "already here." CR>
		T)
	       (T
		<TELL "You may be waiting quite a while." CR>
		T)>>

<DEFINE V-WEAR ()
	 <COND (<OR <AND <IN? ,PRSO ,WINNER>
		         <IS? ,PRSO ,WORN>>
		    <PRSO? CLOTHES POCKET>>
		<YOURE-ALREADY "wearing" <>>
		<TELL " " THEO ,PERIOD>)
	       (<NOT <IS? ,PRSO ,CLOTHING>>
		<TELL ,CANT "wear " THEO ,PERIOD>)
	       (<DONT-HAVE? ,PRSO>)
	       (T
		<MAKE ,PRSO ,WORN>
		<YOU-FROB <>
			  <COND (<==? ,WINNER ,PLAYER> "put")
				(T "obligingly put")>
			  "on">
		<TELL THEO ,PERIOD>)>
	 T>

<DEFINE V-WIND ()
	 <TELL ,CANT "wind " A ,PRSO ,PERIOD>
	 T>

<DEFINE PRE-TAKE PRE-TAKE ("OPTIONAL" (L <>) "AUX" WHO)
	 <COND (<IN? ,PRSO ,GLOBAL-OBJECTS>
		<IMPOSSIBLE>
		<RETURN T .PRE-TAKE>)>
	 <SET L <LOC ,PRSO>>
	 <COND (<OR <PRSO-NOUN-USED? ,W?STICKER ,W?STAMP ,W?AI\-AI>
		    <PRSO-NOUN-USED? ,W?MONKEY ,W?APE>> <>)
	       (<EQUAL? .L ,WINNER>
		<COND (<EQUAL? ,WINNER ,PLAYER>
		       <TELL "You're ">)
		      (T
		       <TELL CTHE ,WINNER>
		       <IS-ARE ,WINNER>)>
		<TELL "already ">
		<COND (<IS? ,PRSO ,WORN>
		       <TELL "wear">)
		      (T
		       <TELL "hold">)>
		<TELL "ing " THEO ,PERIOD>
		T)
	       (<==? .L ,OTHER-TRAP-DOOR> <>)
	       (<AND <T? .L>
		     <IS? .L ,CONTAINER>
		     <IS? .L ,OPENABLE>
		     <NOT <IS? .L ,OPENED>>>
		<YOU-FROB <> "can't" <> T>
		<TELL "reach into " THE .L ". It's closed." CR>
		T)
	       (<T? ,PRSI>
		<COND (<PRSO? PRSI>
		       <COND (<OR <EQUAL? <ZGET ,P-NAMW 0> <ZGET ,P-NAMW 1>>
				  <EQUAL? <ZGET ,P-ADJW 0> <ZGET ,P-ADJW 1>>>
			      <IMPOSSIBLE>
			      T)
			     (T
			      <>)>)			    
		      (<PRSI? ME>
		       <COND (<EQUAL? ,WINNER ,PLAYER>
			      <NOBODY-TO-ASK>
			      T)
			     (<NOT <EQUAL? .L ,PLAYER>>
			      <TELL ,DONT "have " THEO ,PERIOD>
			      T)
			     (T
			      <>)>)
		      (<PRSI? PAINTING> <>)
		      (<NOT <EQUAL? .L ,PRSI>>
		       <COND (<IS? ,PRSI ,PERSON>
			      <COND (<==? ,PRSI ,RANDOM-PERSON>
				     <>)
				    (T
				     <TELL CTHEI " isn't carrying "
					   THEO ,PERIOD>)>)
			     (T
			      <TELL CTHEO>
			      <ISNT-ARENT>
			      <COND (<IS? ,PRSI ,SURFACE>
				     <TELL "on ">)
				    (T
				     <TELL "in ">)>
			      <TELL THEI ,PERIOD>)>)
		      (T
		       <>)>)
	       (T
		<>)>>

<DEFINE V-TAKE ("AUX" L)
	 <SET L <ITAKE>>
	 <COND (<T? .L>
		<COND (<T? ,P-MULT?>
		       <TELL "Taken." CR>)
		      (<OR <IS? .L ,CONTAINER>
			   <IS? .L ,SURFACE>
			   <IS? .L ,PERSON>
			   <IS? .L ,LIVING>>
		       <YOU-FROB <> "take">
		       <TELL THEO>
		       <COND (<IS? .L ,CONTAINER>
			      <TELL " out of ">)
			     (<AND <IS? .L ,SURFACE>
				   <N==? .L ,UNDER-SEAT>>
			      <TELL " off ">)   
			     (T
			      <TELL " from ">)>
			<TELL THE .L ,PERIOD>)
		       (<PROB 50>
			<TELL "Taken." CR>)
		       (T
			<COND (<EQUAL? ,P-PRSA-WORD
				       ,W?GRAB ,W?SEIZE ,W?SNATCH>
			       <YOU-FROB ,P-PRSA-WORD>
			       <PRINTC 32>)
			      (<PROB 50>
			       <YOU-FROB <> "pick" "up">)
			      (T
			       <YOU-FROB <> "take">)>
			 <TELL THEO ,PERIOD>)>
	      ; <SET L <GETP ,PRSO ,P?VALUE>>
	      ; <COND (<T? .L>
		       <PUTP ,PRSO ,P?VALUE 0>
		       <UPDATE-SCORE .L>)>)>
	 T>

<DEFINE YOU-FROB ("OPT" (WRD <>) (S1 <>) (S2 <>) (PLURAL? <>))
  <COND (<==? ,WINNER ,PLAYER>
	 <SET PLURAL? T>
	 <TELL "You">)
	(T
	 <COND (<IS? ,WINNER ,PLURAL>
		<SET PLURAL? T>)>
	 <TELL CTHE ,WINNER>)>
  <TELL " ">
  <COND (.WRD
	 <ZPRINTB .WRD>
	 <COND (<F? .PLURAL?> <TELL "s">)>)
	(.S1
	 <TELL .S1>
	 <COND (<F? .PLURAL?> <TELL "s">)>
	 <COND (.S2
		<TELL " " .S2>)>)>
  <TELL " ">>

<MSETG FUMBLE-NUMBER 15>
<MSETG LOAD-ALLOWED 100>

<SETG MAIL-COUNT 0>

<DEFINE ITAKE ITAKE ("OPTIONAL" (VB T) "AUX" L ML DE)
	 <COND (<OR <ZERO? ,PRSO>
		    <ZERO? <LOC ,PRSO>>>
		<CANT-SEE-ANY>
		<RETURN <> .ITAKE>)>
	 <SET L <LOC ,PRSO>>
	 <THIS-IS-IT ,PRSO>
	 <COND (<NOT <IS? ,PRSO ,TAKEABLE>>
		<COND (<T? .VB>
		       <IMPOSSIBLE>)>
		<>)
	       (<AND <IS? .L ,CONTAINER>
		     <IS? .L ,OPENABLE>
		     <NOT <IS? .L ,OPENED>>>
		<COND (<T? .VB>
		       <YOUD-HAVE-TO "open" .L>)>
		<>)
	       (<AND <NOT <IN? .L ,WINNER>>
		     <G? <+ <WEIGHT ,PRSO> <WEIGHT ,WINNER>> ,LOAD-ALLOWED>>
	        <COND (<T? .VB>
		       <COND (<FIRST? ,WINNER>
			      <TELL "Your load is">)
			     (T
			      <TELL CTHEO " is">)>
		       <TELL " too heavy." CR>)>
		<>)
	       (<G? <CCOUNT ,WINNER> ,FUMBLE-NUMBER>
		<COND (<T? .VB>
		       <TELL "You're holding too much already." CR>)>
		<>)
	       (T
	      	; "This will be a number from -1 to -4, depending on the object
		   (if it is mail).  Or between 1 and 4 if it has been
		   transformed"
		<SET ML <GETP ,PRSO ,P?MAIL-LETTER>>
		<COND (<L? .ML 0>
		       <SET ML <- 0 .ML>>
		       <COND (<NOT <IS? ,PRSO ,TOUCHED>>
			      <SET L <LOC ,PRSO>>
			      <MAKE ,PRSO ,TOUCHED>
			      ; "Get the dir entry associated with it--
				 printa, etc."
			      <SET DE <ZGET ,PRINTR-TABLE <- .ML 1>>>
			      ; "And stuff in there the next program to
				 print"
			      <DIR-ROUTINE .DE
					   <ZGET ,RPRINTR-TABLE ,MAIL-COUNT>>
			      <SETG MAIL-COUNT <+ ,MAIL-COUNT 1>>
			      <SETG PRSO <PICK-NEXT ,MAILING-LIST>>
			      ; "Save the letter for the description of the
				 object"
			      <PUTP ,PRSO ,P?MAIL-LETTER .ML>
			      <ZPUT <GETPT ,PRSO ,P?SYNONYM> 0
				    <COND (<==? .ML 1> ,W?B)
					  (<==? .ML 2> ,W?C)
					  (<==? .ML 3> ,W?D)
					  (T ,W?E)>>
			      <TELL "Most of the mail is rather useless, not even worth picking up. ">
			      <COND (<N==? ,PRSO ,ENVELOPE>
				     ; "Not the last one"
				     <TELL "You do find " A ,PRSO ", though."
					   CR>)
				    (T
				     ; "Leave the remnants of the check
					around."
				     <SETUP-CHECK .L>
				     <TELL "Amid the junk, you find " A ,PRSO
					   " and " A ,BOSS-CHECK
					   ". You regretfully leave "
					   THE ,BOSS-CHECK " behind, and take "
					   THE ,PRSO ,PERIOD>)>
			      <UPDATE-SCORE 1>
			      <SET L <>>
			      <SETG P-IT-OBJECT ,PRSO>
			      <SETG P-MULT? T>)
			     (ELSE
			      <TELL "You probably shouldn't push your luck in illegally looking at other people's mail." CR>
			      <RETURN <> .ITAKE>)>)>
		<MAKE ,PRSO ,TOUCHED>
		<UNMAKE ,PRSO ,NODESC>
		<UNMAKE ,PRSO ,NOALL>
		<MOVE ,PRSO ,WINNER>
		.L)>>  "So that .L an be analyzed."

<CONSTANT MAILING-LIST <TABLE (LENGTH PATTERN (BYTE [REST WORD]))
			       #BYTE 0 MAGAZINE FLYER COUPON ENVELOPE>>

"Count # objects being carried by THING."

<DEFINE CCOUNT (THING "AUX" OBJ (CNT 0))
	 <SET OBJ <FIRST? .THING>>
	 <REPEAT ()
		 <COND (<ZERO? .OBJ>
			<RETURN>)
		       (<AND <NOT <IS? .OBJ ,WORN>>
			     <NOT <EQUAL? .OBJ ,POCKET>>>
			<SET CNT <+ .CNT 1>>)>
		 <SET OBJ <NEXT? .OBJ>>>
	 .CNT>

"Return total weight of objects in THING."

<DEFINE WEIGHT (THING "AUX" OBJ (WT:FIX 0))
	 <SET OBJ <FIRST? .THING>>
	 <REPEAT ()
		 <COND (<ZERO? .OBJ>
			<RETURN>)
		       (<NOT <EQUAL? .OBJ ,POCKET>>
			<COND (<AND <EQUAL? .THING ,WINNER>
				    <IS? .OBJ ,WORN>>
			       <SET WT <+ .WT 1>>)
			      (T
			       <SET WT <+ .WT <WEIGHT .OBJ>>>)>)>
		 <SET OBJ <NEXT? .OBJ>>>
	 <SET OBJ <GETP .THING ,P?SIZE>>
	 <COND (<T? .OBJ>
		<SET WT <+ .WT .OBJ:FIX>>)>
	 .WT>

<DEFINE DESCRIBE-ROOM DR ("OPTIONAL" (LOOK? <>) "AUX" (V? <>) ACT STR)
         <COND (<OR <T? .LOOK?>
		    <EQUAL? ,VERBOSITY 2>>
		<SET V? T>)>
	 <COND ;(<ZERO? ,LIT?>
		<TELL "It's completely dark." CR>
		<RETURN <> .DR>)
	       (<NOT <IS? ,HERE ,TOUCHED>>
		<MAKE ,HERE ,TOUCHED>
		<SET V? T>)>
         <COND (<IN? ,HERE ,ROOMS>
	        <HLIGHT ,H-BOLD>
	        <SAY-HERE>
		<HLIGHT ,H-NORMAL>
		<ZCRLF>)>
	 <COND (<OR <T? .LOOK?>
		    <T? ,VERBOSITY>>
	        <SET ACT <GETP ,HERE ,P?ACTION>>
	        <SET STR <GETP ,HERE ,P?LDESC>>
		; "Re-invent stuff so don't need action routine for every
		   room just to describe it."
		<COND (<T? .V?>
		       <COND (<T? ,VERBOSITY>
			      <ZCRLF>)>
		       <COND (<T? .STR>
			      <TELL .STR CR>)
			     (<T? .ACT>
			      <ZAPPLY .ACT ,M-LOOK>)>)>)>
	 ;,LIT?
	 T>

<MSETG REXIT 0>
<MSETG UEXIT 2>
<MSETG NEXIT 3>
<MSETG FEXIT 4>
<MSETG CEXIT 5>
<MSETG DEXIT 6>

<MSETG NEXITSTR 0>
<MSETG FEXITFCN 0>
<MSETG CEXITFLAG 4>
<MSETG CEXITSTR 1>
<MSETG DEXITOBJ 1>
<MSETG DEXITSTR 2>

<SETG GOTO-LOC <>>

<DEFINE NERD-SAYS-WAIT ()
  <TELL "\"Hey! Wait!\" cries " THE ,NERD>
  <GENDER-PRINT ". \"Can I go out with your sister?\""
		". \"Would you like to go out with me?\"">
  <ZCRLF>>

<DEFINE GOTO GOTO (WHERE "OPTIONAL" (LOOK? T) (NOEXIT? <>) "AUX" X)
	 <SETG GOTO-LOC .WHERE>
	 <COND (<AND <F? .NOEXIT?>
		     <T? <ZAPPLY <GETP ,HERE ,P?ACTION> ,M-EXIT>>>
		; "Let the place we are handle this first..."
		<RETURN T .GOTO>)>
	 <COND (<IN? ,NERD ,HERE>
		<ZREMOVE ,NERD>
		<UNMAKE ,NERD ,TOUCHED>
		<NERD-SAYS-WAIT>
		<ZCRLF>)>
	 <SETG HERE .WHERE>
	 <MOVE ,PLAYER .WHERE>
	 ;<SETG LIT? <IS-LIT?>>
	 <SET X <ZAPPLY <GETP ,HERE ,P?ACTION> ,M-ENTERING>>
	 <COND (<NOT <EQUAL? ,HERE .WHERE>>
		<RETURN T .GOTO>)
	       (<T? .LOOK?>
		<COND (<DESCRIBE-ROOM>
		       <COND (<T? ,VERBOSITY>
		       	      <DESCRIBE-OBJECTS>)>)>)>
	 <SET X <ZAPPLY <GETP ,HERE ,P?ACTION> ,M-ENTERED>>
	 <RESET-THEM>
	 T>

<DEFINE RESET-THEM ()
	 <COND (<NOT <VISIBLE? ,P-IT-OBJECT>>
		<SETG P-IT-OBJECT ,NOT-HERE-OBJECT>)>
	 <COND (<NOT <VISIBLE? ,P-THEM-OBJECT>>
		<SETG P-THEM-OBJECT ,NOT-HERE-OBJECT>)>
	 <COND (<NOT <VISIBLE? ,P-HIM-OBJECT>>
		<SETG P-HIM-OBJECT ,NOT-HERE-OBJECT>)>
	 <COND (<NOT <VISIBLE? ,P-HER-OBJECT>>
		<SETG P-HER-OBJECT ,NOT-HERE-OBJECT>)>
	 T>

<DEFINE HACK-HACK (STR)
	 <TELL .STR>
	 <SPACE>
	 <TELL THEO " " PNEXT ,HO-HUM ,PERIOD>
	 T>

<CONSTANT HO-HUM
	<TABLE (LENGTH PATTERN (BYTE [REST WORD]))
	       #BYTE 0 
	 "is not permitted in this story without prior written consent, in triplicate, from Infocom, Inc"
	 "is a violation of the Cambridge Convention, which prohibits it in humourous games"
	 "cannot be allowed until your bank acknowledges your change-of-address form"
	 "may not be attempted by anyone using a computer"
	 "is not permitted until you obtain your physician's approval, and submit Form 691/05/Z, in person, to the Office of Forms in Vladivostok">>

<DEFINE IMPOSSIBLE ()
	 <TELL PNEXT ,YUKS ,PERIOD>
	 T> 
	 
<CONSTANT YUKS
	<TABLE (LENGTH PATTERN (BYTE [REST WORD])) #BYTE 0
	 "That's impossible"
	 "What a ridiculous concept"
	 "You can't be serious">>

;<DEFINE TOO-DARK ()
	 <TELL "It's too dark to see." CR>
	 T>

<DEFINE CANT-GO ()
	 <COND (<IS? ,HERE ,INDOORS>
		<TELL "There's no exit ">)
	       (T
		<TELL ,CANT "go ">)>
	 <TELL "that way." CR>
	 T>

<DEFINE ALREADY-OPEN ()
	 <ITS-ALREADY "open">
	 T>

<DEFINE ALREADY-CLOSED ()
	 <ITS-ALREADY "closed">
	 T>

<DEFINE ITS-ALREADY (STR)
	 <TELL "It's already " .STR ,PERIOD>
	 T>

<DEFINE REFERRING ()
	 <TELL "[To what are you referring?]" CR>
	 T>

<DEFINE MORE-SPECIFIC ()
	 <TELL "[You really must be more specific.]" CR>
	 T>

<DEFINE WASTE-OF-TIME ()
	 <TELL PNEXT ,POINTLESS ,PERIOD>
	 T>

<CONSTANT POINTLESS
	<TABLE (LENGTH PATTERN (BYTE [REST WORD])) #BYTE 0
	 "There's no point in doing that"
	 "That would be pointless"
	 "That's a pointless thing to do">>

<DEFINE PUZZLED (WHO)
	 <LOOKS-PUZZLED .WHO>
	 <COND (<PROB 50>
		<COND (<IS? .WHO ,PLURAL>
		       <TELL "Pardon us">)
		      (ELSE
		       <TELL "Pardon me">)>)
	       (T
		<TELL "Huh">)>
	 <TELL "?\"" CR>
	 T>

<DEFINE LOOKS-PUZZLED (WHO)
	 <PCLEAR>
	 <TELL CTHE .WHO " ">
	 <COND (<PROB 50>
		<COND (<IS? .WHO ,PLURAL>
		       <TELL "look ">)
		      (ELSE
		       <TELL "looks ">)>)
	       (<IS? .WHO ,PLURAL> <TELL "appear ">)
	       (T
		<TELL "appears ">)>
	 <TELL PNEXT ,PUZZLES ". \"">
	 T>

<CONSTANT PUZZLES
	<TABLE (LENGTH PATTERN (BYTE [REST WORD]))
	       #BYTE 0 "puzzled" "bewildered" "confused" "perplexed">>

<DEFINE V-SWRAP ()
	 <PERFORM ,V?WRAP-AROUND ,PRSI ,PRSO>
	 T>

<DEFINE V-WRAP-AROUND ()
	 <TELL "You couldn't possibly ">
	 <ZPRINTB ,P-PRSA-WORD>
	 <SPACE>
	 <TELL THEO " around " THEI ,PERIOD>
	 T>

<DEFINE V-DRESS ()
	 <COND (<PRSO? ROOMS>
		<YOURE-ALREADY "dressed">)
	       (<IS? ,PRSO ,PERSON>
	       	<TELL CTHEO " is already dressed." CR>)
	       (T
		<TELL ,CANT "dress " A ,PRSO ,PERIOD>)>
	 T>

<DEFINE V-UNDRESS ()
	 <COND (<OR <PRSO? ROOMS>
		    <IS? ,PRSO ,PERSON>>
		<INAPPROPRIATE>)
	       (T
		<ZPRINT ,CANT>
		<ZPRINTB ,P-PRSA-WORD>
		<SPACE>
		<TELL A ,PRSO ,PERIOD>)>
	 T>
		 
<DEFINE V-PHONE ()
	 <COND (<AND <T? ,PRSI>
		     <NOT <PRSI? MACHINE>>
		     <NOT <PRSI? AIRPHONE>>>
		<TELL "Too bad " THEI " isn't a telephone." CR>)
	       (<HERE? LAV-LOBBY>
		<COND (<NOT <IN? ,BEEZER ,AIRPHONE>>
		       <TELL "You have to give the phone a valid credit card first." CR>)
		      (<PRSO? ROOMS>
		       <TELL "You fiddle aimlessly with " THE ,AIRPHONE
			     ,PERIOD>)
		      (<PRSO? INTNUM>
		       <DO-CALL>)
		      (T
		       <BOGUS-CALL>)>)
	       (<PRSO? ROOMS>
		<TELL "You fiddle aimlessly with " THE ,MACHINE ,PERIOD>)
	       (<NOT <VISIBLE? ,MACHINE>>
		<CANT-SEE-ANY-STR "telephones">)
	       (<IS? ,MACHINE ,SEEN>
		<TELL "You'd have to hang up first." CR>)
	       (<PRSO? MACHINE>
		<TELL "You have to give a phone number, as in \"CALL 555-1212.\"" CR>)
	       (<PRSO? INTNUM>
		<DO-CALL>)
	       (T
		<BOGUS-CALL>)>
	 T>

<DEFINE BOGUS-CALL ()
  <COND (<OR <IN? ,PRSO ,ROOMS>
	     <IS? ,PRSO ,PLACE>>
	 <TELL ,CANT "call there." CR>)
	(<NOT <IS? ,PRSO ,PERSON>>
	 <TELL "Unfortunately, " THEO " doesn't have a phone." CR>)
	(<VISIBLE? ,PRSO>
	 <TELL "But " THEO " is right here!" CR>)
	(T
	 <WASTE-OF-TIME>)>>

<DEFINE DO-CALL ("AUX" (NUM 0))
  <COND (<T? ,END-GAME?>
	 <TELL "Your phone seems to be disconnected; there's no dialling tone."
	       CR>)
	(<ZERO? ,P-EXCHANGE>
	 <COND (<ZERO? ,P-NUMBER>
		<SET NUM 411>)>
	 <TELL
	  "An operator tells you to dial " N .NUM " if you need assistance." CR>)
	(<OR <AND <ZERO? ,P-EXCHANGE>
		  <==? ,P-NUMBER 411>>
	     <AND <==? ,P-EXCHANGE 555>
		  <==? ,P-NUMBER 1212>>>
	 <TELL "An operator suggests that you look the number up and save us all a lot of trouble." CR>)
	(<AND <EQUAL? ,P-EXCHANGE
		      <ZGET ,PHONE-NUMBERS ,OHOME-NUMBER-X>>
	      <EQUAL? ,P-NUMBER
		      <ZGET ,PHONE-NUMBERS ,OHOME-NUMBER>>
	      <IS? ,PAGE-1 ,SEEN>>
	 <TELL "Someone answers the phone but you can't tell who it is because
of the noise of raucous shouting, chinking glasses and laughter. In the
background, you hear someone cry \"Hey! Remember how dull this place was when
old ">
	 <PRINT-NAME>
	 <TELL " lived here?\" and then the line goes dead." CR>)
	(<AND <EQUAL? ,P-EXCHANGE
		      <ZGET ,PHONE-NUMBERS ,OBANK-NUMBER-X>>
	      <EQUAL? ,P-NUMBER
		      <ZGET ,PHONE-NUMBERS ,OBANK-NUMBER>>
	      <IS? ,PAGE-2 ,SEEN>>
	 <COND (<HERE? LAV-LOBBY>
		<STUPID-CALL>)
	       (T
		<CALL-BANK>)>)
	(<AND <EQUAL? ,P-EXCHANGE
		      <ZGET ,PHONE-NUMBERS ,BANK-NUMBER-X>>
	      <EQUAL? ,P-NUMBER
		      <ZGET ,PHONE-NUMBERS ,BANK-NUMBER>>
	      <IS? ,PAGE-2 ,SEEN>>
	 <COND (<HERE? LAV-LOBBY>
		<STUPID-CALL>)
	       (T
		<CALL-BANK T>)>)
	(<AND <EQUAL? ,P-EXCHANGE
		      <ZGET ,PHONE-NUMBERS ,WORK-NUMBER-X>>
	      <EQUAL? ,P-NUMBER
		      <ZGET ,PHONE-NUMBERS ,WORK-NUMBER>>
	      <IS? ,PAGE-3 ,SEEN>>
	 <TELL "You get through to Ollie Fassbaum's secretary who tells you:
\"Mr Fassbaum says he's out,\" and hangs up." CR>)
	(<AND <EQUAL? ,P-EXCHANGE
		      <ZGET ,PHONE-NUMBERS ,OLD-FRIEND-X>>
	      <EQUAL? ,P-NUMBER
		      <ZGET ,PHONE-NUMBERS ,OLD-FRIEND>>>
	 <TELL "\"Hi! You have reached ">
	 <SHOW-FIELD ,LAST-FRIEND>
	 <TELL " and ">
	 <GENDER-PRINT "Trent" "Tiffany">
	 <TELL ". Sorry we can't take your call, but we're on the yacht right
now. Leave your message and we'll get right back to you. Unless it's ">
	 <PRINT-NAME>
	 <TELL ". If it's ">
	 <PRINT-NAME>
	 <TELL ", bug off. Just leave us alone, okay? Thank you for calling.
Have a good day! (Except ">
	 <PRINT-NAME>
	 <TELL ".)\"" CR>)
	(<AND <EQUAL? ,P-EXCHANGE
		      <ZGET ,PHONE-NUMBERS ,NEW-FRIEND-X>>
	      <EQUAL? ,P-NUMBER
		      <ZGET ,PHONE-NUMBERS ,NEW-FRIEND>>>
	 <TELL "\"Hi! This is ">
	 <SHOW-FIELD ,FRIEND>
	 <TELL "! You have reached my old number. Everyone knows my new
number except ">
	 <PRINT-NAME>
	 <TELL ". Hi, ">
	 <PRINT-FIRST-NAME>
	 <TELL ". I've left you. It's all over. I tried to write, but you
didn't reply. I expect you'll come up with some flaky line about your mail
being misdelivered. That's typical of you, ">
	 <PRINT-FIRST-NAME>
	 <TELL ". If you think about it, you'll understand.\"" CR>)
	(<AND <EQUAL? ,P-EXCHANGE
		      <ZGET ,PHONE-NUMBERS ,CAB-NUMBER-X>>
	      <EQUAL? ,P-NUMBER
		      <ZGET ,PHONE-NUMBERS ,CAB-NUMBER>>
	      <IS? ,PAGE-3 ,SEEN>>
	 <COND (<HERE? LAV-LOBBY>
		<STUPID-CALL>)
	       (T
		<CALL-CAB>)>)
	(<CALLING-HOME?>
	 <COND (<NOT <HERE? LAV-LOBBY>>
		<TELL "Not surprisingly, the line is busy." CR>)
	       (T
		<TELL "Your faithful answering machine clicks on. \"Hi, this is ">
		<PRINT-NAME>
		<TELL ". I can't come to the phone...\" Suddenly, someone
breaks in. \"Don't worry, loser, we're
taking good care of your house while you're gone.\" You hear raucous laughter and
the sound of glass breaking. Whoever it is hangs up." CR>)>)
	(T
	 <TELL "Your call goes off into the ether... ">
	 <COND
	  (<PROB 20>
	   <TELL "There's no answer." CR>)
	  (<PROB 30>
	   <TELL
	    "The telephone is answered. \"Hello? Hello? Hey, what is this, a crank call?\" The telephone hangs up." CR>)
	  (T
	   <TELL "You get a busy signal." CR>)>)>
  <COND (<HERE? LAV-LOBBY>
	 <MOVE ,BEEZER ,PLAYER>
	 <MAKE ,AIRPHONE ,OPENED>
	 <TELL CR
	       "The telephone spits out your " D ,BEEZER ", thanks you for using
it, and suggests that you have a wonderful day. While you're idly contemplating
your next step, you remember to take your " D ,BEEZER ,PERIOD>)>
  T>

<DEFINE STUPID-CALL ()
  <TELL "You realise that this call is going to cost a small fortune, if it
hasn't already, and hang up before anyone answers." CR>>

<DEFINE V-HANGUP ("AUX" OBJ)
	 <COND (<AND <PRSO? ROOMS>
		     <NOT <VISIBLE? ,MACHINE>>
		     <NOT <IS? ,AIRPHONE ,TOUCHED>>>
		<TELL "There's nothing here to hang up." CR>)
	       (<PRSO? ROOMS MACHINE AIRPHONE>
		<COND (<PRSO? ROOMS>
		       <COND (<HERE? LAV-LOBBY>
			      <SET OBJ ,AIRPHONE>)
			     (T
			      <SET OBJ ,MACHINE>)>)
		      (T
		       <SET OBJ ,PRSO>)>
		<COND (<==? .OBJ ,MACHINE>
		       <COND
			(<IS? ,MACHINE ,SEEN>
			 <UNMAKE ,MACHINE ,SEEN>
			 <COND (<NOT <IS? ,CABSOUND ,NOARTICLE>>
				<CABSOUND-OFF>)>
			 <COND (<NOT <IS? ,BANKSOUND ,NODESC>>
				<BANKSOUND-OFF>)>
			 <TELL "You hang up " THE ,MACHINE ,PERIOD>)
			(T
			 <TELL CTHE ,MACHINE " is already hung up." CR>)>)
		      (T
		       <PERFORM ,V?HANGUP ,AIRPHONE>)>)
	       (T
		<TELL ,CANT "hang up " A ,PRSO ,PERIOD>)>
	 T>
	 
<DEFINE V-SHORT ()
	 <IMPOSSIBLE>
	 T>

<DEFINE V-HOLD ()
  <COND (<N==? ,PRSO ,ROOMS>
	 <PERFORM ,V?TAKE ,PRSO>)
	(<IN? ,BEEZER ,AIRPHONE>
	 <TELL "No, other people are supposed to put you on hold." CR>)
	(<IS? ,MACHINE ,SEEN>
	 <COND (<G? ,HOLD-TURNS 0>
		<YOURE-ALREADY "on hold">)
	       (T
		<TELL "Fortunately, there's no hold button on this phone."
		      CR>)>)
	(T
	 <TELL "What do you want to hold?" CR>
	 <ORPHAN-VERB <> ,ACT?TAKE>
	 ,FATAL-VALUE)>>

<DEFINE V-STINGLAI VS ("AUX" (WHO ,WINNER))
  <COND (<==? ,WINNER ,PLAYER>
	 <SET WHO <ANYONE-HERE?>>)>
  <COND (<OR <PRSO? CHUTE>
	     <RAND-PRSO? ,FAKE-CHUTE-OBJECT>>
	 <COND (<PRSO-NOUN-USED? ,W?KA\'ABI>
		<COND (<AND <T? .WHO>
			    <OR <N==? .WHO ,RANDOM-PERSON>
				<N==? <GETP .WHO ,P?PSEUDO-TABLE>
				      ,PERSON-MASK>>>
		       <COND (<==? .WHO ,FLIGHT-ATTENDANT>
			      <ASK-FOR-STINGLAI>
			      <RETURN T .VS>)
			     (T
			      <TELL CTHE .WHO " look">
			      <COND (<NOT <IS? .WHO ,PLURAL>>
				     <TELL "s">)>
			      <TELL " at you strangely. Is it
your pronunciation, you wonder, or your breath?" CR>
			      <RETURN ,FATAL-VALUE .VS>)>)
		      (T
		       <TELL "Sorry, that's not in a language we understand."
			     CR>
		       <RETURN T .VS>)>)>)>
  <COND (<T? .WHO>
	 <TELL CTHE .WHO " seems to be suffering from some form of
cognitive dissonance, and doesn't understand you." CR>)
	(T
	 <TELL "Sorry, that's not in any language we know of." CR>)>>
