<FILE-FLAGS MDL-ZIL?>

<INCLUDE "FORMDEFS" "COMPUTERDEFS">

<DEFINE START-COMPUTER (DIRTBL)
  <SETG FERROR-COUNT 0>
  <TELECOM? <>>
  ;<CLEAR-BIT-TABLE>
  <DO-PROG -1>
  <DRAW-COMPUTER-SCREEN>
  <FERROR-MSG "Press ? for help, or enter a command.">
  <LAST-LINE-USED 0>
  <COMPUTER-LOOP .DIRTBL>
  <EXIT-HACK>
  <COND (<G? ,FERROR-COUNT:FIX 0>
	 <UPDATE-BP ,FERROR-COUNT>)>
  T>

;<CONSTANT SCREEN-BIT-TABLE <ITABLE <* ,COMPUTER-WIDTH 2> (BYTE) 0>>

<ROUTINE-FLAGS CLEAN-STACK?>
<DEFINE CLEAR-SCREEN ()
  ;<CLEAR-BIT-TABLE>
  <FILES-ON-SCREEN? <>>
  <REPEAT ((N <- <LAST-LINE-USED> 1>))
    <COND (<L? .N 0> <RETURN>)>
    <SET-COMPUTER-CURS .N 0>
    <TELL  "                                      ">
    <SET N <- .N 1>>>
  <LAST-LINE-USED 0>
  <SET-COMPUTER-CURS 0 0>>

<ROUTINE-FLAGS CLEAN-STACK?>
<DEFINE CLEAR-QUADRANT (N "AUX" ;OFFS STOP X Y)
  <COND (<==? .N 1>
	 <SET X 0>
	 <SET Y 0>
	 ;<SET OFFS 0>
	 <SET STOP ,COMPUTER-WIDTH>)
	(<==? .N 0>
	 <SET X </ ,COMPUTER-WIDTH 2>>
	 <SET Y 0>
	 ;<SET OFFS ,COMPUTER-WIDTH>
	 <SET STOP <* ,COMPUTER-WIDTH 2>>)
	(<==? .N 2>
	 <SET X 0>
	 <SET Y </ ,COMPUTER-HEIGHT 2>>
	 ;<SET OFFS 1>
	 <SET STOP ,COMPUTER-WIDTH>)
	(<==? .N 3>
	 <SET X </ ,COMPUTER-WIDTH 2>>
	 <SET Y </ ,COMPUTER-HEIGHT 2>>
	 ;<SET OFFS <+ ,COMPUTER-WIDTH 1>>
	 <SET STOP <* ,COMPUTER-WIDTH 2>>)>
  ;<REPEAT ((BT ,SCREEN-BIT-TABLE))
    <PUTB .BT .OFFS 0>
    <COND (<G=? <SET OFFS <+ .OFFS 2>> .STOP>
	   <RETURN>)>>
  <SET N </ ,COMPUTER-HEIGHT 2>>
  <REPEAT ()
    <SET-COMPUTER-CURS .Y .X>
    <PRINT-SPACES </ ,COMPUTER-WIDTH 2>>
    <SET Y <+ .Y 1>>
    <COND (<0? <SET N <- .N 1>>> <RETURN>)>>>

<DEFINE SET-COMPUTER-CURS RT (Y:FIX X:FIX)
  <COND (<G? <SET Y <+ .Y 1>> <LAST-LINE-USED>>
	 <LINE-CHECK>
	 <LAST-LINE-USED .Y>)>
  <COMP-X .X>
  <COMP-Y <SET Y <- .Y 1>>>
  <SET-FORM-CURS <+ .Y ,COMPUTER-FIRST-LINE>
		 <SET X <+ .X 1>>>>

;<ROUTINE-FLAGS CLEAN-STACK?>
;<DEFINE CLEAR-BIT-TABLE ("AUX" (BT ,SCREEN-BIT-TABLE))
  <REPEAT ((N 0))
    <PUTB .BT .N 0>
    <COND (<G=? <SET N <+ .N 1>> <* ,COMPUTER-WIDTH 2>>
	   <RETURN>)>>>

<ROUTINE-FLAGS CLEAN-STACK?>
<DEFINE DRAW-COMPUTER-SCREEN ()
  <ZCRLF>
  <EXITED-ALREADY? <>>
  <COND (<T? <TELECOM?>>
	 <TELL "Boysenberry Terminal Emulator 5.21">)
	(T
	 <TELL "BCDOS 1.0">)>
  <ZCRLF>
  <TELL "All diagnostics completed|
Press any key to boot..." CR>
  <ZBUFOUT <>>
  <INPUT 1>
  <CLEAR -1>
  <SPLIT <- ,HEIGHT:FIX 1>>
  ; "So we can use form cursor addressing"
  <SETG FLINE </ <- ,HEIGHT:FIX ,COMPUTER-REAL-HEIGHT:FIX> 2>>
  <SETG FLINE <+ ,FLINE:FIX 1>>
  <SETG MARGIN </ <- ,WIDTH:FIX ,COMPUTER-REAL-WIDTH:FIX> 2>>
  <SETG MARGIN <+ ,MARGIN:FIX 1>>
  <SCREEN ,S-WINDOW>
  <ZBUFOUT <>>
  <HLIGHT ,H-NORMAL>
  <HLIGHT ,H-INVERSE>
  <BLANK-LINE ,COMPUTER-COMMAND-LINE>
  <OPEN-LINE ,COMPUTER-ERROR-LINE>
  <CLOSE-LINE ,COMPUTER-ERROR-LINE>
  <BLANK-LINE <+ ,COMPUTER-ERROR-LINE 1>>
  <REPEAT ((N:FIX ,COMPUTER-FIRST-LINE))
    <OPEN-LINE .N>
    <CLOSE-LINE .N>
    <COND (<G=? <SET N <+ .N 1>> ,COMPUTER-REAL-HEIGHT:FIX>
	   <RETURN>)>>
  <COND (<G? ,HEIGHT:FIX <+ ,FLINE:FIX ,COMPUTER-REAL-HEIGHT>>
	 <BLANK-LINE ,COMPUTER-REAL-HEIGHT>)>>

;<DEFINE WRITE-CHAR (CHAR X:FIX Y:FIX)
  <COND (<TEST-BIT-AND-SET .X .Y>
	 <SET-COMPUTER-CURS .Y .X>
	 <PRINTC .CHAR>)
	(T <>)>>

<DEFINE FORCE-CHAR (CHAR X:FIX Y:FIX)
  ;<TEST-BIT-AND-SET .X .Y>
  <SET-COMPUTER-CURS .Y .X>
  <PRINTC .CHAR>>

;<CONSTANT BIT-TABLE <TABLE (PURE BYTE) 1 2 4 8 16 32 64 128>>

;<DEFINE TEST-BIT-AND-SET (X:FIX Y:FIX "AUX" (BT ,SCREEN-BIT-TABLE) NUM VAL
			  BIT)
  <SET X <* .X 2>>
  <COND (<G=? .Y </ ,COMPUTER-HEIGHT 2>>
	 <SET X <+ .X 1>>
	 <SET Y <- .Y </ ,COMPUTER-HEIGHT 2>>>)>
  <COND (<NOT <BTST <SET NUM <GETB .BT .X>>
		    <SET B <GETB ,BIT-TABLE .Y>>>>
	 ;<0? <ANDB <SET NUM <GETB .BT .X>>
		   <SET BIT <GETB ,BIT-TABLE .Y>>>>
	 <PUTB .BT .X <ORB .NUM .BIT>>
	 T)
	(T <>)>>

<CONSTANT REAL-COMMAND-WINDOW <PTABLE
			       <MAKE-FIELD 'FIELD
					   <CHTYPE <ITABLE
						    <+ ,FIELD-DATA-OFFSET 38>
						    (BYTE)>
						   FIELD>
					   'FIELD-PROMPT "Command:"
					   'FIELD-FCN COMMAND-FIELD
					   'FIELD-PROMPTLEN 8
					   'FIELD-X 1
					   'FIELD-Y ,COMPUTER-COMMAND-LINE
					   'FIELD-MAXLEN 29
					   'FIELD-DONE 0
					   'FIELD-CURLEN 0>>>

<DEFINE COMMAND-FIELD (CONTEXT TBL "OPT" CHAR)
  <COND (<AND <==? .CONTEXT ,FORM-ADD-CHAR>
	      <0? <FIELD-CURLEN .TBL>>
	      <==? <CHTYPE .CHAR FIX> !\?>>
	 <HLIGHT ,H-NORMAL>
	 <HELP-CMD <> <> <>>
	 <HLIGHT ,H-INVERSE>
	 <SET-FORM-CURS ,FY ,FX>
	 <>)
	(<AND <==? .CONTEXT ,FORM-ADD-CHAR>
	      <L=? <CHTYPE .CHAR FIX> !\ >>
	 <FERROR "ILLEGAL-CHARACTER">
	 <>)
	(T T)>>

<DEFINE LOGIN-COMMAND-FIELD (CONTEXT TBL "OPT" CHAR)
  <COND (<AND <==? .CONTEXT ,FORM-ADD-CHAR>
	      <L=? <CHTYPE .CHAR FIX> !\ >>
	 <FERROR "ILLEGAL-CHARACTER">
	 <>)
	(T T)>>

<SETG CURRENT-DIR <>>

<DEFINE SETUP-COMMAND-LINE (PROMPT LEN "OPT" (FCN 1)
			    "AUX" (W ,REAL-COMMAND-WINDOW)
				  (FLD <ZGET .W 0>))
  <SET-FORM-CURS ,COMPUTER-COMMAND-LINE 1>
  <HLIGHT ,H-NORMAL>
  <HLIGHT ,H-INVERSE>
  <COND (<N==? .FCN 1>
	 <FIELD-FCN .FLD .FCN>)>
  <COND (.PROMPT
	 <PRINT-SPACES ,COMPUTER-WIDTH>
	 <FIELD-PROMPT .FLD .PROMPT>
	 <FIELD-PROMPTLEN .FLD .LEN>
	 <FIELD-MAXLEN .FLD <- 37 .LEN>>
	 <SET-FORM-CURS ,COMPUTER-COMMAND-LINE 1>
	 <TELL .PROMPT>)>>

<ROUTINE-FLAGS CLEAN-STACK?>
<DEFINE GET-COMMAND ("OPT" (ERR? <>)
		     "AUX" (W ,REAL-COMMAND-WINDOW) (FLD <ZGET .W 0>)
			   (TXT <ZREST .FLD <- ,FIELD-DATA-OFFSET 1>>))
  <REPEAT ()
    <SET-FORM-CURS <FIELD-Y .FLD> <+ <FIELD-X .FLD>
				     <FIELD-PROMPTLEN .FLD>>>
    <HLIGHT ,H-INVERSE>
    <PRINT-SPACES <FIELD-MAXLEN .FLD>>
    <HLIGHT ,H-INVERSE>
    <FIELD-CURLEN .FLD 0>
    <COND (<FILL-FIELD 0 .W .ERR?>
	   <HLIGHT ,H-NORMAL>
	   ; "Script, but don't print anything to screen"
	   <DUMP-STRING <FIELD-PROMPT .FLD> T T>
	   <DUMP-LTABLE .TXT T T>
	   <RETURN>)>>>

<ROUTINE-FLAGS CLEAN-STACK?>
<DEFINE COMPUTER-LOOP (DIRTBL "AUX" (W ,REAL-COMMAND-WINDOW)
		       (FLD <ZGET .W 0>) (TC <TELECOM?>))
  <SETG FORM-COMPUTER? T>
  <SETG CURRENT-DIR .DIRTBL>
  <TIMES-THROUGH-LOOP 0>
  <REPEAT ((ERR? <>) CVAL (1ST? T) CSS)
    <COND (<T? <TELECOM?>>
	   <SETUP-COMMAND-LINE "CMD:" 4 COMMAND-FIELD>)
	  (T
	   <SETUP-COMMAND-LINE "Command:" 8 COMMAND-FIELD>)>
    <COND (<T? <FERROR-ACTIVE?>>
	   <SET ERR? T>
	   <FERROR-ACTIVE? <>>)>
    <COND (<AND <NOT .ERR?>
		<NOT .1ST?>>
	   <COND (<T? <TELECOM?>>
		  <FERROR-MSG "ENTER-COMMAND">)
		 (T
		  <FERROR-MSG "Enter a command">)>)>
    <GET-COMMAND .ERR?>
    <SET ERR? <>>
    <COND (<T? .TC>
	   <COND (<G? <SET CSS <+ <SET CSS <COMMANDS-SINCE-START>> 1>> 4>
		  <COND (<T? <WILL-WIN?>>
			 <COMPUTER-WIN>
			 <RETURN>)
			(<AND <==? .CSS 5>
			      <T? <CURRENT-TARGET-NAME>>>
			 <COND (<F? <FIND-FILE <REAL-TARGET-NAME>>>
				<DIE-ON-NEXT-COMMAND 4>)
			       (T
				<INT-MESSAGE "USER RQH ACCESSING "
				      <CURRENT-TARGET-NAME>>)>)>)>
	   <COMMANDS-SINCE-START .CSS>)>
    <SET CVAL <PROCESS-COMMAND .FLD .DIRTBL>>
    <SET 1ST? <>>
    <COND (<==? .CVAL ,FATAL-VALUE> <SET ERR? T>)
	  (.CVAL <RETURN>)>
    <COND (<AND <T? .TC> <CHECK-LIMIT>>
	   <RETURN>)>
    <COND (<AND <T? .TC> <G? <TERMINATE-CURRENT> 0>>
	   <CHECK-TERMINATION T>
	   <TERMINATE-CURRENT 0>)>
    <COND (<AND <F? <CURRENT-TARGET-NAME>>
		<G? <LINES-TO-NEXT-TARGET> 0>>
	   <LINE-CHECK T>)>
    <COND (<T? <DIE-ON-NEXT-COMMAND>>
	   <SECURITY-COMES T>)>
    <REMAINING-TARGET-TURNS <- <REMAINING-TARGET-TURNS> 1>>
    <COND (<==? <REMAINING-TARGET-TURNS> 0>
	   <TERMINATE-CURRENT <ZRANDOM 4>>)>
    <COND (<T? <EXITED-ALREADY?>> <RETURN>)>>>

<DEFINE INT-MESSAGE (STR1 STR2 "OPT" (STR3 <>) "AUX" (OX ,FORM-X) (OY ,FORM-Y))
  <CLEAR-FERROR>
  <SET-FORM-CURS ,COMPUTER-ERROR-LINE 1>
  <SOUND ,S-BOOP>
  <HLIGHT ,H-NORMAL>
  <TELL .STR1>
  <TELL .STR2>
  <COND (<T? .STR3> <TELL .STR3>)>
  <DELAY 2>
  <SET-FORM-CURS .OY .OX>>

<CONSTANT TARGETS <TABLE FIDUC-FILE MENU-FILE AIRPLANE-FILE
			 POST-FILE ZBUG-FILE TRAVEL-FILE>>

<SETG REFRESH-COUNT 3>

<CONSTANT ITARGETS <PTABLE FIDUC-FILE MENU-FILE AIRPLANE-FILE
			   POST-FILE ZBUG-FILE TRAVEL-FILE>>

<MSETG TARGET-COUNT 6>

<CONSTANT TARGET-NAMES <PTABLE <PTABLE <PLTABLE (STRING) "FIDUC.HAK">
				       "FIDUC.HAK">
			       <PTABLE <PLTABLE (STRING) "MENU.HAK">
				       "MENU.HAK">
			       <PTABLE <PLTABLE (STRING) "AIRPLANE.HAK">
				       "AIRPLANE.HAK">
			       <PTABLE <PLTABLE (STRING) "POST.HAK">
				       "POST.HAK">
			       <PTABLE <PLTABLE (STRING) "ZBUG.HAK">
				       "ZBUG.HAK">
			       <PTABLE <PLTABLE (STRING) "TRAVEL.HAK">
				       "TRAVEL.HAK">>>

<DEFINE SETUP-NEXT-TARGET ("AUX" (TRIES 0) N:FIX (TARG <>) DIR)
  <REPEAT ()
    <COND (<T? <SET TARG
		    <ZGET ,TARGETS <SET N <- <ZRANDOM ,TARGET-COUNT>:FIX 1>>>>>
	   <RETURN>)
	  (<G? <SET TRIES <+ .TRIES 1>> ,TARGET-COUNT>
	   <SET N 0>
	   <REPEAT ()
	     <COND (<T? <SET TARG <ZGET ,TARGETS .N>>>
		    <RETURN>)>
	     <COND (<G=? <SET N <+ .N 1>> ,TARGET-COUNT>
		    <RETURN>)>>
	   <RETURN>)>>
  <COND (.TARG
	 <ZPUT ,TARGETS .N <>>
	 <SET TRIES <ZGET ,TARGET-NAMES .N>>
	 <CURRENT-TARGET-NAME <ZGET .TRIES 1>>
	 <REAL-TARGET-NAME <ZGET .TRIES 0>>
	 <COMMANDS-SINCE-START 0>
	 <REMAINING-TARGET-TURNS <+ <ZRANDOM 3>:FIX 5>>
	 <COND (<OR <F? <FIND-FILE ,HAK-PROG-NAME>>
		    <F? <SET DIR <FIND-FILE <REAL-TARGET-NAME>>>>>
		; "Trying to start up with non-existent file"
		<DIE-ON-NEXT-COMMAND 1>)
	       (<N==? <ZGET <ZGET .DIR 0> 1> .TARG>
		<DIE-ON-NEXT-COMMAND 2>)>)
	(T
	 ; "Used 'em all up, loser"
	 <DIE-ON-NEXT-COMMAND 3>)>>

<DEFINE LINE-CHECK ("OPT" (FORCE? <>) "AUX" LC:FIX)
  <COND (<F? <TELECOM?>>)
	(<AND <F? .FORCE?> <G? <TERMINATE-CURRENT> 0>>
	 <CHECK-TERMINATION>)
	(<G? <LINES-TO-NEXT-TARGET> 0>
	 <COND (<OR .FORCE?
		    <L=? <SET LC <- <SET LC <LINES-TO-NEXT-TARGET>> 1>> 0>>
		<LINES-TO-NEXT-TARGET 0>
		<SETUP-NEXT-TARGET>
		<COND (<F? <DIE-ON-NEXT-COMMAND>>
		       <INT-MESSAGE "USER RQH ABOUT TO USE "
			     <CURRENT-TARGET-NAME>>)>)
	       (T
		<LINES-TO-NEXT-TARGET .LC>
		<>)>)>>

<DEFINE CHECK-TERMINATION ("OPT" (FORCE? <>)
			   "AUX" (TC:FIX <TERMINATE-CURRENT>))
  <COND (<OR .FORCE?
	     <L=? <SET TC <- .TC 1>> 0>>
	 <TERMINATE-CURRENT .TC>
	 <FERROR-ACTIVE? T>
	 <COND (<T? <CURRENT-TARGET-NAME>>
		<INT-MESSAGE "USER RQH THROUGH WITH " <CURRENT-TARGET-NAME>>)>
	 <CURRENT-TARGET-NAME <>>
	 <REAL-TARGET-NAME <>>
	 <LINES-TO-NEXT-TARGET <ZRANDOM 5>>
	 T)
	(T
	 <TERMINATE-CURRENT .TC>
	 <>)>>

<DEFINE CHECK-LIMIT ("AUX" (N <TIMES-THROUGH-LOOP>))
  <TIMES-THROUGH-LOOP <SET N <+ .N 1>>>
  <COND (<G? .N 50>
	 <SECURITY-COMES>
	 T)
	(T <>)>>

<DEFINE PROCESS-COMMAND PC (FLD DIRTBL)
  <COND (.DIRTBL
	 <REPEAT ((FLDSTR <ZREST .FLD <- ,FIELD-DATA-OFFSET 1>>) DE
		  (LEN:FIX <ZGET .DIRTBL 0>) (DT <ZREST .DIRTBL 2>))
	   <SET DE <ZGET .DT 0>>
	   <COND (<NOT <NEQ-TBL <ZREST .DE <- ,DIR-DATA-OFFSET 1>>
				.FLDSTR>>
		  <RETURN <ZAPPLY <DIR-ROUTINE .DE> .FLD .DE .DIRTBL>
			  .PC>)>
	   <COND (<0? <SET LEN <- .LEN 1>>>
		  <RETURN>)>
	   <SET DT <ZREST .DT 2>>>
	 <COND (<T? <TELECOM?>>
		<FERROR "CMD-NOT-FOUND">)
	       (T
		<FERROR "Command not found">)>
	 ,FATAL-VALUE)
	(T <>)>>

<CONSTANT HELP-TABLE <PLTABLE "Type the name of a command, followed"
			      "by a carriage return. ? or HELP gets"
			      "this listing; DIR lists other"
			      "commands. QUIT turns computer off."
			      "DIR listing follows.">>

<CONSTANT TELECOM-HELP-TABLE
	  <PLTABLE "TYPE THE NAME OF A COMMAND, FOLLOWED"
		   "BY A CARRIAGE RETURN. ? OR HELP GETS"
		   "THIS LISTING. QUIT OR LOGOUT"
		   "DISCONNECTS FROM MAINFRAME AND TURNS"
		   "TERMINAL OFF. COMMAND LISTING FOLLOWS.">>

<DEFINE HELP-CMD (ARG1 ARG2 ARG3 "AUX" CTBL)
  <CLEAR-SCREEN>
  <COND (<T? <TELECOM?>>
	 <SET CTBL ,TELECOM-HELP-TABLE>)
	(T
	 <SET CTBL ,HELP-TABLE>)>
  <DUMP-TABLE .CTBL>
  <DIR-CMD .ARG1 .ARG2 ,CURRENT-DIR <ZGET .CTBL 0>>
  <>>

<DEFINE WHO-CMD (FLD ENTRY DIR)
  <CLEAR-SCREEN>
  <DUMP-STRING "USER    DATA                PROGRAM" T>
  <SET-COMPUTER-CURS 1 0>
  <DUMP-STRING "RQH     DVH2                CHA/OS" T>
  <SET-COMPUTER-CURS 2 0>
  <DUMP-STRING "RQH     " T>
  <SET-COMPUTER-CURS 2 8>
  <COND (<F? <CURRENT-TARGET-NAME>>
	 <DUMP-STRING "DVH2                CHA/OS" T>)
	(T
	 <DUMP-STRING <CURRENT-TARGET-NAME> T>
	 <SET-COMPUTER-CURS 2 28>
	 <DUMP-STRING "HAK" T>)>
  <>>

<ROUTINE-FLAGS CLEAN-STACK?>
<DEFINE DIR-CMD (FLD ENTRY DIR "OPT" (FLINE?:FIX 0)
		 "AUX" (N:FIX <ZGET .DIR 0>))
  <COND (<0? .FLINE?> <CLEAR-SCREEN>)>
  <SET-COMPUTER-CURS .FLINE? 0>
  <COND (<TELECOM?>
	 <DUMP-STRING "COMMAND LIST:" T>)
	(T
	 <DUMP-STRING "Command list:" T>)>
  <SET FLINE? <+ .FLINE? 1>>
  <SET DIR <ZREST .DIR 2>>
  <REPEAT (DE)
    <SET-COMPUTER-CURS .FLINE? 2>
    <SET DE <ZGET .DIR 0>>
    <COND (<0? <ANDB <DIR-BITS .DE> ,DIR-ENTRY-INVISIBLE>>
	   <DUMP-LTABLE <ZREST .DE <- ,DIR-DATA-OFFSET 1>> T>
	   <COND (<T? <DIR-HELP .DE>>
		  <SET-COMPUTER-CURS .FLINE? <+ 2 <DIR-NAMLEN .DE>>>
		  <DUMP-STRING <DIR-HELP .DE> T>)>
	   <SET FLINE? <+ .FLINE? 1>>)>
    <SET DIR <ZREST .DIR 2>>
    <COND (<L=? <SET N <- .N 1>> 0> <RETURN>)>>
  <>>

<DEFINE DUMP-STRING (STR "OPT" (SCRIPT? <>) (NOSCREEN? <>))
  <COND (<T? .STR>
	 <COND (<F? .NOSCREEN?> <TELL .STR>)>
	 <COND (<T? .SCRIPT?>
		<SCREEN ,S-TEXT>
		<DIROUT ,D-SCREEN-OFF>
		<TELL "[" .STR "]" CR>
		<DIROUT ,D-SCREEN-ON>
		<SCREEN ,S-WINDOW>)>)>>

<DEFINE DUMP-LTABLE (TBL "OPT" (SCRIPT? <>) (NOSCREEN? <>)
		     "AUX" (N:FIX <GETB .TBL 0>))
  <COND (<F? .NOSCREEN?>
	 <REPEAT ((OFF 1))
	   <PRINTC <GETB .TBL .OFF>>
	   <COND (<G? <SET OFF <+ .OFF 1>> .N> <RETURN>)>>)>
  <COND (<T? .SCRIPT?>
	 <SCREEN ,S-TEXT>
	 <DIROUT ,D-SCREEN-OFF>
	 <TELL "[">
	 <DUMP-LTABLE .TBL <> <>>
	 <TELL "]" CR>
	 <DIROUT ,D-SCREEN-ON>
	 <SCREEN ,S-WINDOW>
	 <COND (<F? .NOSCREEN?>
		<SET-COMPUTER-CURS <COMP-Y> <+ <COMP-X> .N>>)>)>>

<ROUTINE-FLAGS CLEAN-STACK?>
<DEFINE DUMP-TABLE (TBL "OPT" (FLINE:FIX 0) "AUX" SLINE:FIX DLINE:FIX
		    (N:FIX <ZGET .TBL 0>) (REMAIN:FIX .N))
  ; "SLINE is current line on screen, DLINE is line of document,
     REMAIN is lines left in document, N is total lines in document"
  <COND (<G? .N <- ,COMPUTER-HEIGHT .FLINE>>
	 <SET DLINE <- ,COMPUTER-HEIGHT .FLINE>>)
	(T
	 <SET DLINE .N>)>
  <PROG ()
    <COND (<G? .REMAIN <- ,COMPUTER-HEIGHT .FLINE>>
	   <SET SLINE <- ,COMPUTER-HEIGHT 1>>
	   <SET REMAIN <- .REMAIN ,COMPUTER-HEIGHT .FLINE>>)
	  (T
	   <SET SLINE <+ <- .REMAIN 1> .FLINE>>
	   <SET REMAIN 0>)>
    <REPEAT ()
      <SET-COMPUTER-CURS .SLINE 0>
      <LINE-CHECK>
      <DUMP-STRING <ZGET .TBL .DLINE>>
      <COND (<L? <SET SLINE <- .SLINE 1>> .FLINE> <RETURN>)>
      <SET DLINE <- .DLINE 1>>>
    <COND (<G? .REMAIN 0>
	   <COND (<G? <SET DLINE <+ <- .N .REMAIN> ,COMPUTER-HEIGHT>> .N>
		  <SET DLINE .N>)>
	   <FERROR-MSG "Strike any key to see next page">
	   <INPUT 1>
	   <HLIGHT ,H-NORMAL>
	   <CLEAR-SCREEN>
	   <SET FLINE 0>
	   <AGAIN>)>>
  <SCREEN ,S-TEXT>
  <DIROUT ,D-SCREEN-OFF>
  <TELL "[">
  <REPEAT ((N:FIX <ZGET .TBL 0>) (CT:FIX 1) ST)
    <COND (<T? <SET ST <ZGET .TBL .CT>>>
	   <TELL <ZGET .TBL .CT>>)>
    <ZCRLF>
    <COND (<G? <SET CT <+ .CT 1>> .N> <RETURN>)>>
  <TELL "]" CR>
  <DIROUT ,D-SCREEN-ON>
  <SCREEN ,S-WINDOW>
  T>

<DEFINE WRITE-TABLE-TO-COMPUTER (TBL)
  <TELECOM? <>>
  <SETG FORM-COMPUTER? T>
  <DRAW-COMPUTER-SCREEN>
  <HLIGHT ,H-NORMAL>
  <DUMP-TABLE .TBL>
  <EXIT-HACK>>

<DEFINE FERROR-MSG (STR)
  <CLEAR-FERROR>
  <COND (.STR
	 <HLIGHT ,H-NORMAL>
	 <SET-FORM-CURS ,COMPUTER-ERROR-LINE 1>
	 <TELL .STR>
	 <HLIGHT ,H-INVERSE>)>>

<DEFINE EXIT-HACK EH ("OPT" (QUIET? <>))
  <COND (<T? <EXITED-ALREADY?>>
	 <RETURN T .EH>)>
  <COND (<NOT .QUIET?>
	 <COND (<T? <TELECOM?>>
		<FERROR-MSG "Disconnect requested. Strike any key.">
		<COND (<T? <WILL-WIN?>>
		       <COMPUTER-DEAD? T>
		       <QUEUE I-COMPUTER-DIES 1>)>)
	       (T
		<FERROR-MSG "Shutdown requested. Strike any key.">)>
	 <BLANK-LINE ,COMPUTER-COMMAND-LINE>
	 <SET-FORM-CURS ,COMPUTER-COMMAND-LINE 1>
	 <INPUT 1>)>
  <HLIGHT ,H-NORMAL>
  <CLEAR ,S-WINDOW>
  <CLEAR ,S-TEXT>
  <INIT-STATUS-LINE>
  <COND (<NOT .QUIET?>
	 <ZCRLF>
	 <TELL "Your screen goes blank." CR>)>
  <EXITED-ALREADY? T>
  T>

<DEFINE QUIT-CMD (ARG1 ARG2 ARG3)
  T>

<DEFINE CLEAR-CMD (ARG1 ARG2 ARG3)
  <COND (<F? <TELECOM?>>
	 <DO-PROG -1>)>
  <CLEAR-SCREEN>
  <>>

<CONSTANT HACK-TABLE
	  <PLTABLE
	   " The Strange and Terrible History of"
	   "             Bureaucracy"
	   <>
	   "Once upon a time Douglas Adams and"
	   "Steve Meretzky collaborated on a game"
	   "called \"The Hitchhikers Guide to the"
	   "Galaxy.\" Everyone wanted a sequel, but"
	   "Douglas thought it might be fun to do"
	   "something different first. He called"
	   "that something \"Bureaucracy,\" and"
	   "wanted Marc Blank to work on it with"
	   "him. Of course, Marc was busy, and"
	   "Douglas was busy, and by the time they"
	   "could both work on it, they were too"
	   "busy to work on it. So, Jerry Wolper"
	   "got a free trip to Las Vegas to talk"
	   "to Douglas about it before it was"
	   "decided to let it rest for a while"
	   "instead. Jerry decided to go back to"
	   "school, so Marc and Douglas spent some"
	   "time on Nantucket looking at llamas,"
	   "drinking Chateau d'Yquem, and arguing"
	   "about puzzles. Nothing much happened"
	   "for a while, except that Marc and"
	   "Douglas got distracted again. Paul"
	   "DiLascia decided to give it a try, but"
	   "changed his mind and kept working on"
	   "Cornerstone. Marc went to work for"
	   "Simon and Schuster, and Paul went to"
	   "work for Interleaf. Jeff O'Neill"
	   "finished Ballyhoo, and, casting about"
	   "for a new project, decided to take it"
	   "on, about the time Jerry graduated."
	   "Jeff got a trip to London out of it."
	   "Douglas was enthusiastic, but busy"
	   "with a movie. Progress was slow, and"
	   "then Douglas was very busy with"
	   "something named \"Dirk Gently.\" Jeff"
	   "decided it was time to work on"
	   "something else, and Brian Moriarty"
	   "took it over. He visited England, and"
	   "marvelled at Douglas's CD collection,"
	   "but progress was slow. Eventually he"
	   "decided it was time to work on"
	   "something else. Paul made a cameo"
	   "appearance, but decided to stay at"
	   "Interleaf instead. So Chris Reeve and"
	   "Tim Anderson took it over, and mucked"
	   "around a lot. Finally, back in Las"
	   "Vegas, Michael Bywater jumped (or was"
	   "pushed) in and came to Boston for some"
	   "serious script-doctoring, which made"
	   "what was there into what is here. In"
	   "addition, there were significant"
	   "contributions from Liz Cyr-Jones,"
	   "Suzanne Frank, Gary Brennan, Tomas"
	   "Bok, Max Buxton, Jon Palace, Dave"
	   "Lebling, Stu Galley, Linde Dynneson,"
	   "and others too numerous to mention."
	   "Most of these people are not dead yet,"
	   "and apologise for the inconvenience.">>

<DEFINE HACK-CMD (ARG1 ARG2 ARG3)
  <CLEAR-SCREEN>
  <DUMP-TABLE ,HACK-TABLE>
  <>>

<CONSTANT HACK-DIR <DIR-ENTRY HACK-CMD "NOOZ" <>>>
<CONSTANT HELP-DIR <DIR-ENTRY HELP-CMD "HELP" <> DIR-ENTRY-INVISIBLE>>
<CONSTANT QUIT-DIR <DIR-ENTRY QUIT-CMD "QUIT" <> DIR-ENTRY-INVISIBLE>>
<CONSTANT DIR-DIR <DIR-ENTRY DIR-CMD "DIR" <> DIR-ENTRY-INVISIBLE>>
<CONSTANT CLEAR-DIR <DIR-ENTRY CLEAR-CMD "CLEAR" ": Clear the screen">>
<CONSTANT TCLEAR-DIR <DIR-ENTRY CLEAR-CMD "CLR" ": CLEAR THE SCREEN">>


<DEFINE RUN-TELE-COMM ("AUX" (F 0))
  <COND (<T? <COMPUTER-DEAD?>>
	 <TELL CR "The mainframe doesn't seem to be responding, so your Boysenberry rejects the modular plug. Have you messed up the computer system?" CR>)
	(T
	 <COND (<NOT <L? <SETG REFRESH-COUNT <- ,REFRESH-COUNT 1>> 0>>
		<REPEAT ((N 0))
		  <ZPUT ,TARGETS .N <ZGET ,ITARGETS .N>>
		  <COND (<G? <SET N <+ .N 1>> <- ,TARGET-COUNT 1>>
			 <RETURN>)>>)>
	 <SETG FORM-COMPUTER? T>
	 <TELECOM? T>
	 <DRAW-COMPUTER-SCREEN>
	 <SET-COMPUTER-CURS 0 0>
	 <HLIGHT ,H-NORMAL>
	 <DUMP-STRING "CONNECTION IN PROGRESS...." T>
	 <DELAY 1>
	 <SET-COMPUTER-CURS 2 0>
	 <DUMP-STRING "CONNECTED TO DVH2 NODE 0106. WAITING." T>
	 <DELAY 1>
	 <COND (<DO-LOGIN>
		<SET-COMPUTER-CURS 4 0>
		<DUMP-STRING "LOGON AT ">
		<TELL N ,HOURS ":">
		<COND (<L? ,MINUTES:FIX 10> <TELL "0">)>
		<TELL N ,MINUTES>
		<SET-COMPUTER-CURS 6 0>
		<DUMP-STRING "DVH2 CHA/OS: ? OR HELP FOR HELP" T>
		<TELECOM? T>
		<SETUP-NEXT-TARGET>
		<REMAINING-TARGET-TURNS 2>
		<FERROR-MSG "ENTER-COMMAND">
		<COND (<F? <DIE-ON-NEXT-COMMAND>>
		       <COMPUTER-LOOP ,TELECOM-TABLE>)
		      (<F? <EXITED-ALREADY?>>
		       <SECURITY-COMES T>)>)>
	 <EXIT-HACK>)>>

<CONSTANT LOGIN-NAME <TABLE (PURE LENGTH STRING) "RANDOM-Q-HACKER">>

<CONSTANT PASSWORD <TABLE (PURE LENGTH STRING) "RAINBOW-TURTLE">>


<CONSTANT DELAYS <PTABLE (BYTE) 1 ; "ZIL"
			 10	; "ZIP20"
			 1	; "APPLE II"
			 4	; "MAC"
			 4	; "AMIGA"
			 4	; "ST"
			 1	; "COMPAQ/PC"
			 1	; "128"
			 1	; "64...">>

<DEFINE DELAY ("OPT" (SEC:FIX 1) "AUX" (N:FIX <GETB ,DELAYS <LOWCORE INTID>>))
  ; "N is number of 1000s to count down to get 1-sec. delay"
  <SET N <* 1000 .N .SEC>>
  <REPEAT ()
    <COND (<L=? <SET N <- .N 1>> 0> <RETURN>)>>>

"Login stuff"
<ROUTINE-FLAGS CLEAN-STACK?>
<DEFINE DO-LOGIN DL ("AUX" (CT 8)
		     (FLD <ZREST <ZGET ,REAL-COMMAND-WINDOW 0>
				 <- ,FIELD-DATA-OFFSET 1>>)
		     (GOOD-NAME? <>) (GOOD-PASSWORD? <>))
  <REPEAT ()
    <COND (<==? .CT 1>
	   <FERROR-MSG "ABSOLUTELY-YOUR-LAST-CHANCE,-BOZO">)
	  (T
	   <FERROR-MSG "ENTER-YOUR-ID,-OR-QUIT-TO-DISCONNECT">)>
    <SETUP-COMMAND-LINE "ID:" 3 LOGIN-COMMAND-FIELD>
    <GET-COMMAND>
    <COND (<NOT <NEQ-TBL .FLD ,QUIT-TABLE>>
	   <RETURN <> .DL>)
	  (<NEQ-TBL .FLD ,LOGIN-NAME>
	   <SET GOOD-NAME? <>>)
	  (T
	   <SET GOOD-NAME? T>)>
    <FERROR-MSG "ENTER-YOUR-PASSWORD">
    <SETUP-COMMAND-LINE "PSSWD:" 6 COMMAND-PASSWORD>
    <GET-COMMAND>
    <COND (<AND .GOOD-NAME? <NEQ-TBL .FLD ,PASSWORD>>
	   <SET GOOD-PASSWORD? <>>)
	  (T
	   <SET GOOD-PASSWORD? T>)>
    <COND (<AND <T? .GOOD-NAME?>
		<T? .GOOD-PASSWORD?>>
	   <RETURN>)>
    <COND (<L? <SET CT <- .CT 1>> 1>
	   <SECURITY-COMES>
	   <RETURN <> .DL>)>>>

<DEFINE SECURITY-COMES ("OPT" (LOSSAGE? <>) "AUX" (SC <EXITED-ALREADY?>)
			(DC? <DIE-ON-NEXT-COMMAND>))
  <EXIT-HACK T>
  <TELL "Unfortunately, it would seem that the nerd has noticed ">
  <COND (<F? .SC>
	 <COND (<AND .LOSSAGE?
		     <N==? .DC? 3>>
		<COND (<EQUAL? .DC? 1 4>
		       <TELL "that someone deleted a file he wanted to use">)
		      (T
		       <TELL "that someone changed a file he wanted to use">)>)
	       (T
		<TELL "the infinitesimal increase in response time on
his terminal">)>
	 <TELL " and realised that you are there">)
	(T
	 <TELL "your picture on his monitor">)>
  <TELL ,PCR
	"Doors slam shut all around you, and freon gas is discharged into
the room. You continue to breathe normally for a bit, and then you breathe
abnormally. Then you breathe normally again, just for a change" ,PCR
	"Suddenly, a small hatch opens low in the wall and a horde of little
tiny automatic nerds with dirty spectacles and greasy hair shuffle in,
twitching and whining and fiddling with their little hex calculators.
You briefly wonder why you have received a social call from the MIT
freshman year, then realise that the little nerdlets are in fact the
nerd's private army.|
|
Not a very good army, it's true, but then they don't have to be. The
freon gas is killing you quite satisfactorily, thank you; all the robot
nerdlets have to do is laugh at you, which they do. And all ">
  <ITALICIZE "you">
  <TELL " have to do is expire, which (knowing your place in the scheme
of things) you do.|
|
The last thing you hear before you die is one of the little nerdlets
saying \"">
  <GENDER-PRINT "Hey, fellas, look! His stack is running into his heap!"
		"Hey! Wait! Would you like to go out with me?">
  <TELL "\"">
  <JIGS-UP>>

<CONSTANT QUIT-TABLE <TABLE (PURE STRING LENGTH) "QUIT">>

<DEFINE COMMAND-PASSWORD (CONTEXT TBL "OPT" CHAR:FIX)
  <COND (<==? .CONTEXT ,FORM-DO-ECHO?> <>)
	(T T)>>

; "Actual mainframe simulation here..."
<CONSTANT LOGOUT-DIR <DIR-ENTRY QUIT-CMD "LOGOUT" <> DIR-ENTRY-INVISIBLE>>

<CONSTANT WHO-DIR <DIR-ENTRY WHO-CMD "WHO" ": LIST USERS">>

<CONSTANT DIRLIST-DIR <DIR-ENTRY DIRLIST-CMD "DIR" ": LIST FILE NAMES">>

<CONSTANT TYPE-DIR <DIR-ENTRY TYPE-CMD "TYP" ": SHOW FILE ON SCREEN">>

<CONSTANT RENAME-DIR <DIR-ENTRY RENAME-CMD "REN" ": RENAME A FILE">>

<CONSTANT COPY-DIR <DIR-ENTRY COPY-CMD "COP" ": COPY A FILE">>

<CONSTANT DELETE-DIR <DIR-ENTRY DELETE-CMD "DEL" ": ERASE A FILE">>

<CONSTANT RUN-DIR <DIR-ENTRY RUN-CMD "RUN" ": RUN A PROGRAM">>

<CONSTANT TELECOM-TABLE
	  <PLTABLE HELP-DIR QUIT-DIR
		   LOGOUT-DIR WHO-DIR TCLEAR-DIR
		   DIRLIST-DIR TYPE-DIR RENAME-DIR
		   COPY-DIR DELETE-DIR RUN-DIR>>

<MSETG MAX-FILENAME 15>

<CONSTANT HAK-PROG-NAME <PLTABLE (STRING) "HAK.EXE">>

<CONSTANT FILE-TABLE
	  <LTABLE <TABLE <TABLE (STRING) <BYTE 9> "PLANE.EXE      ">
			 PLANE-FILE>
		  <TABLE <TABLE (STRING) <BYTE 7> "HAK.EXE        ">
			 HAK-FILE>
		  <TABLE <TABLE (STRING) <BYTE 9> "FIDUC.HAK      ">
			 FIDUC-FILE>
		  <TABLE <TABLE (STRING) <BYTE 8> "MENU.HAK       ">
			 MENU-FILE>
		  <TABLE <TABLE (STRING) <BYTE 12> "AIRPLANE.HAK   ">
			 AIRPLANE-FILE>
		  <TABLE <TABLE (STRING) <BYTE 8> "POST.HAK       ">
			 POST-FILE>
		  <TABLE <TABLE (STRING) <BYTE 8> "ZBUG.HAK       ">
			 ZBUG-FILE>
		  <TABLE <TABLE (STRING) <BYTE 10> "TRAVEL.HAK     ">
			 TRAVEL-FILE>
		  <TABLE <TABLE (STRING) <BYTE 8> "DVH2.HAK       ">
			 DVH2-FILE>
		  <TABLE <TABLE (STRING) <BYTE 0> "               ">
			 <>>
		  <TABLE <TABLE (STRING) <BYTE 0> "               ">
			 <>>
		  <TABLE <TABLE (STRING) <BYTE 0> "               ">
			 <>>
		  <TABLE <TABLE (STRING) <BYTE 0> "               ">
			 <>>
		  <TABLE <TABLE (STRING) <BYTE 0> "               ">
			 <>>>>

<CONSTANT FIDUC-FILE
	  <PLTABLE <>
		   ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"
		   ";;; FILLMORE FIDUCIARY TRUST       ;;;"
		   ";;; CENTRAL COMPUTER ACCESS        ;;;"
		   ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"
		   <>
		   ".RUN"
		   "LOGON SLARTIBARTFAST"
		   <>
		   <>
		   "[NON-ASCII CHARACTERS ENCOUNTERED]">>

<CONSTANT MENU-FILE
	  <PLTABLE <>
		   ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"
		   ";;; GENERAL RESTAURANT ACCESS CODE ;;;"
		   ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"
		   <>
		   "; THIS CAN HACK ANY RESTAURANT WITH"
		   "; COMPUTERISED INVENTORY, ORDER ENTRY,"
		   "; OR BOOKKEEPING."
		   <>
		   ".RUN"
		   <>
		   "[NON-ASCII CHARACTERS ENCOUNTERED]">>

<CONSTANT AIRPLANE-FILE
	  <PLTABLE <>
		   ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"
		   ";;; FAA TRAFFIC CONTROL COMPUTER   ;;;"
		   ";;; AND NATIONAL WEATHER SERVICE   ;;;"
		   ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"
		   <>
		   "; USE THIS TO CAUSE THE WEATHER"
		   "; SERVICE TO ISSUE BOGUS FORECASTS,"
		   "; AND TO CAUSE ANY ARBITRARY AIRCRAFT"
		   "; TO BE ROUTED TO ANY ARBITRARY"
		   "; LOCATION."
		   <>
		   "[NON-ASCII CHARACTERS ENCOUNTERED]">>

<CONSTANT POST-FILE
	  <PLTABLE <>
		   ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"
		   ";;; POSTAL MISDIRECTION HACK       ;;;"
		   ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"
		   <>
		   "; IN ADVANCED COUNTRIES, THIS CAN"
		   "; CAUSE MAIL TO ANY SPECIFIED ADDRESS"
		   "; TO BE DELIVERED TO ANY OTHER ADDRESS"
		   "; WITHOUT USING TELL-TALE FORWARDING"
		   "; STICKERS"
		   <>
		   ".READ COUNTRY"
		   ".READ STATE OR PROVINCE"
		   ".READ CITY"
		   ".READ STREET"
		   ".READ NUMBER"
		   ".READ APARTMENT"
		   ".RUN"
		   <>
		   "[NON-ASCII CHARACTERS ENCOUNTERED]">>

<CONSTANT ZBUG-FILE
	  <PLTABLE <>
		   ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"
		   ";;; NATIVES                        ;;;"
		   ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"
		   <>
		   "; CONNECT TO ZALAGASA BOYSENBERRY"
		   "; USERS' GROUP COMPUTERS, JUST TO MAKE"
		   "; SURE THEY AREN'T GETTING ANYWHERE"
		   "; THEY DON'T BELONG"
		   <>
		   "[NON-ASCII CHARACTERS ENCOUNTERED]">>

<CONSTANT TRAVEL-FILE
	  <PLTABLE <>
		   ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"
		   ";;; TRAVEL AGENCY AND AIRLINE      ;;;"
		   ";;; RESERVATIONS MANIPULATION      ;;;"
		   ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"
		   <>
		   "; MANIPULATE AIRLINE RESERVATIONS --"
		   "; ROUTE SELECTED TRAVELLER TO ANY"
		   "; DESIRED DESTINATION, WITH ANY"
		   "; DESIRED INTERMEDIATE STOPS. CAN"
		   "; ALSO CAUSE AIRLINES TO AUTOMATICALLY"
		   "; ROUTE GROUPS OF TRAVELLERS"
		   "; INCORRECTLY."
		   <>
		   "[NON-ASCII CHARACTERS ENCOUNTERED]">>

<CONSTANT DVH2-FILE
	  <PLTABLE <>
		   ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"
		   ";;; EMERGENCY DVH2 CHA/OS ACCESS   ;;;"
		   ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"
		   <>
		   ";;===>>>WARNING<<<==="
		   ";; MAKE SURE THIS ISN'T DIRECTED AT A"
		   ";; FRIENDLY COMPUTER!!! IT WILL NEVER"
		   ";; WORK AGAIN!!!"
		   <>
		   "[NON-ASCII CHARACTERS ENCOUNTERED]">>

<CONSTANT EXE-FILES <PLTABLE PLANE-FILE HAK-FILE>>
<CONSTANT HAK-FILES <PLTABLE FIDUC-FILE MENU-FILE AIRPLANE-FILE POST-FILE
			     ZBUG-FILE TRAVEL-FILE DVH2-FILE>>

<DEFINE HAK-FILE (DIRPTR "AUX" ND)
  <COND (<==? <FIND-FILE ,HAK-PROG-NAME> .DIRPTR>
	 <FERROR "HAK-BUSY-USER-RQH">)
	(T
	 <FERROR "HAK-CANT-RUN-WITH-WRONG-NAME">)>
  ,FATAL-VALUE>

<SETG PLANE-SUMMONED? <>>

<DEFINE PLANE-FILE (DIRPTR)
  <DUMP-STRING "AIRPLANE REQUEST" T>
  <SET-COMPUTER-CURS 1 0>
  <DUMP-STRING "TRANSMITTING..." T>
  <DELAY>
  <SET-COMPUTER-CURS 3 0>
  <DUMP-STRING "RECEIVED..." T>
  <DELAY>
  <SET-COMPUTER-CURS 5 0>
  <DELAY>
  <DUMP-STRING "CONFIRMED..." T>
  <DELAY>
  <SET-COMPUTER-CURS 7 0>
  <DUMP-STRING "ACKNOWLEDGED..." T>
  <SETG PLANE-SUMMONED? T>
  <>>

; "Returns the directory rested to the appropriate entry, or false"
<DEFINE FIND-FILE (NMTBL "AUX" (DIR ,FILE-TABLE) (LEN:FIX <ZGET .DIR 0>) DE)
  <SET DIR <ZREST .DIR 2>>
  <REPEAT ()
    <SET DE <ZGET .DIR 0>>
    <COND (<AND <T? <ZGET .DE 1>>
		<NOT <NEQ-TBL .NMTBL <ZGET .DE 0>>>>
	   <RETURN>)>
    <COND (<L? <SET LEN <- .LEN 1>> 1>
	   <SET DIR <>>
	   <RETURN>)>
    <SET DIR <ZREST .DIR 2>>>
  .DIR>

<DEFINE FILE-NAME-FCN (CONTEXT TBL "OPT" CHAR)
 T>

<DEFINE GET-FILE-NAME (MSG:STRING "OPT" (OLD? T))
  <COND (<AND <T? .OLD?>
	      <F? <FILES-ON-SCREEN?>>>
	 <LIST-DIR-OF-FILES ,FILE-TABLE>)>
  <FERROR-MSG .MSG>
  <SETUP-COMMAND-LINE "FILE-NAME:" 10 FILE-NAME-FCN>
  <GET-COMMAND>
  <ZREST <ZGET ,REAL-COMMAND-WINDOW 0>
	 <- ,FIELD-DATA-OFFSET 1>>>

<ROUTINE-FLAGS CLEAN-STACK?>
<DEFINE LIST-DIR-OF-FILES (DIR:TABLE "OPT" (CMD? <>)
			   "AUX" (LEN:FIX <ZGET .DIR 0>)
			   (LINE:FIX 0))
  <CLEAR-SCREEN>
  <SET-COMPUTER-CURS .LINE 0>
  <FILES-ON-SCREEN? T>
  <COND (.CMD?
	 <DUMP-STRING "DIR DVH2<CHA/OS.OP>*.*" T>)
	(T
	 <DUMP-STRING "FILES:" T>)>
  <SET LINE <+ .LINE 1>>
  <SET DIR <ZREST .DIR 2>>
  <REPEAT (DE)
    <SET-COMPUTER-CURS .LINE 2>
    <SET DE <ZGET .DIR 0>>
    <COND (<T? <ZGET .DE 1>>
	   <DUMP-LTABLE <ZGET .DE 0> T>
	   <SET LINE <+ .LINE 1>>)>
    <COND (<L? <SET LEN <- .LEN 1>> 1>
	   <RETURN>)>
    <SET DIR <ZREST .DIR 2>>>>

<DEFINE DIRLIST-CMD (FLD ENTRY DIR)
  <LIST-DIR-OF-FILES ,FILE-TABLE T>
  <>>

<DEFINE RUN-CMD (FLD ENTRY DIR "AUX" FNT)
  <SET FNT <GET-FILE-NAME "ENTER-NAME-OF-FILE-TO-RUN">>
  <COND (<SET ENTRY <FIND-FILE .FNT>>
	 <CLEAR-SCREEN>
	 <SET DIR <ZGET <ZGET .ENTRY 0> 1>>
	 <COND (<NOT <INTBL? .DIR <ZREST ,EXE-FILES 2>
			     <ZGET ,EXE-FILES 0>>>
		<FERROR "INVALID-FILE-FORMAT">
		,FATAL-VALUE)
	       (T
		<ZAPPLY .DIR .ENTRY>)>)
	(T
	 <FERROR "FILE-NOT-FOUND">
	 ,FATAL-VALUE)>>

<DEFINE TYPE-CMD (FLD ENTRY DIR "AUX" FNT)
  <SET FNT <GET-FILE-NAME "ENTER-NAME-OF-FILE-TO-SHOW">>
  <COND (<SET DIR <FIND-FILE .FNT>>
	 <CLEAR-SCREEN>
	 <SET DIR <ZGET <ZGET .DIR 0> 1>>
	 <COND (<INTBL? .DIR <ZREST ,EXE-FILES 2> <ZGET ,EXE-FILES 0>>
		<FERROR "INVALID-FILE-FORMAT">
		,FATAL-VALUE)
	       (T
		<DUMP-TABLE .DIR 0>
		<>)>)
	(T
	 <FERROR "FILE-NOT-FOUND">
	 ,FATAL-VALUE)>>

<DEFINE RENAME-CMD (FLD ENTRY DIR "AUX" FNT ND)
  <SET FNT <GET-FILE-NAME "ENTER-NAME-OF-FILE-TO-RENAME">>
  <COND (<SET DIR <FIND-FILE .FNT>>
	 ;"Pointer to old file"
	 <SET FNT <GET-FILE-NAME "ENTER-NEW-FILE-NAME" <>>>
	 <FILES-ON-SCREEN? <>>
	 <COND (<SET ND <FIND-FILE .FNT>>
		; "Existing file will go away, permanently, maybe"
		<COND (<==? .ND .DIR> T)
		      (<==? .ND <FIND-FILE ,HAK-PROG-NAME>>
		       <FILES-ON-SCREEN? T>
		       <FERROR "FILE-PROTECTION-VIOLATION">)
		      (<CONFIRM-OVERWRITE>
		       <DO-COPY .DIR .ND>
		       <ZPUT <ZGET .DIR 0> 1 <>>)
		      (T
		       <FILES-ON-SCREEN? T>
		       <FERROR "RENAME-ABORTED">)>)
	       (T
		<COPY-NAME .FNT .DIR>)>
	 <CHECK-WINNING?>
	 <>)
	(T
	 <FERROR "FILE-NOT-FOUND">
	 ,FATAL-VALUE)>>

<DEFINE CONFIRM-OVERWRITE ("AUX" (FLD <ZREST <ZGET ,REAL-COMMAND-WINDOW 0>
					     <- ,FIELD-DATA-OFFSET 1>>))
  <FERROR "TARGET-FILE-ALREADY-EXISTS">
  <SETUP-COMMAND-LINE "Y-TO-OVERWRITE:" 15 <>>
  <GET-COMMAND>
  <COND (<AND <G=? <GETB .FLD 0>:FIX 1>
	      <==? <GETB .FLD 1>:FIX !\Y>>
	 <FERROR-MSG "OVERWRITTEN">
	 T)
	(T <>)>>

; "Make files have same contents. DE1 source, DE2 dest"
<DEFINE DO-COPY (DE1 DE2)
  <SET DE1 <ZGET .DE1 0>>
  <SET DE2 <ZGET .DE2 0>>
  <ZPUT .DE2 1 <ZGET .DE1 1>>>

<DEFINE COPY-NAME (FNT DIR "AUX" NMLEN:FIX)
  <SET DIR <ZGET <ZGET .DIR 0> 0>>
  <COND (<G? <SET NMLEN <GETB .FNT 0>> ,MAX-FILENAME>
	 <SET NMLEN ,MAX-FILENAME>)>
  <PUTB .DIR 0 .NMLEN>
  <REPEAT ()
    <PUTB .DIR .NMLEN <GETB .FNT .NMLEN>>
    <COND (<L? <SET NMLEN <- .NMLEN 1>> 1>
	   <RETURN>)>>>

<DEFINE COPY-CMD (FLD ENTRY DIR "AUX" FNT ND)
  <SET FNT <GET-FILE-NAME "ENTER-NAME-OF-FILE-TO-COPY">>
  <COND (<SET DIR <FIND-FILE .FNT>>
	 ;"Pointer to old file"
	 <SET FNT <GET-FILE-NAME "ENTER-NAME-OF-NEW-FILE" <>>>
	 <COND (<SET ND <FIND-FILE .FNT>>
		<COND (<==? .ND <FIND-FILE ,HAK-PROG-NAME>>
		       <FERROR "FILE-PROTECTION-VIOLATION">)
		      (<CONFIRM-OVERWRITE>
		       ; "Existing file will go away, permanently"
		       <DO-COPY .DIR .ND>)
		      (T
		       <FERROR "COPY-ABORTED">)>
		<CHECK-WINNING?>
		,FATAL-VALUE)
	       (<SET ND <FIND-FREE-FILE>>
		<FILES-ON-SCREEN? <>>
		<COPY-NAME .FNT .ND>
		<DO-COPY .DIR .ND>
		<CHECK-WINNING?>
		<>)
	       (T
		<FERROR "DIRECTORY-IS-FULL">
		,FATAL-VALUE)>)
	(T
	 <FERROR "FILE-NOT-FOUND">
	 ,FATAL-VALUE)>>

<DEFINE CHECK-WINNING? ("AUX" DIR)
  <COND (<AND <T? <REAL-TARGET-NAME>>
	      <SET DIR <FIND-FILE <REAL-TARGET-NAME>>>
	      <==? <ZGET <ZGET .DIR 0> 1> ,DVH2-FILE>
	      <L? <COMMANDS-SINCE-START> 4>>
	 <WILL-WIN? T>)>>

<DEFINE FIND-FREE-FILE ("AUX" (TBL ,FILE-TABLE) (LEN <ZGET .TBL 0>))
  <REPEAT ()
    <COND (<F? <ZGET <ZGET .TBL .LEN> 1>>
	   <SET TBL <ZREST .TBL <* .LEN 2>>>
	   <RETURN>)>
    <COND (<L? <SET LEN <- .LEN 1>> 1>
	   <SET TBL <>>
	   <RETURN>)>>
  .TBL>

<DEFINE DELETE-CMD (FOO BAR BLETCH "AUX" FNT DIR)
  <SET FNT <GET-FILE-NAME "ENTER-NAME-OF-FILE-TO-ERASE">>
  <COND (<SET DIR <FIND-FILE .FNT>>
	 <ZPUT <ZGET .DIR 0> 1 <>>
	 <FILES-ON-SCREEN? <>>
	 <>)
	(T
	 <FERROR "FILE-NOT-FOUND">
	 ,FATAL-VALUE)>>

<DEFINE COMPUTER-WIN ()
  <CLEAR-SCREEN>
  <DUMP-STRING "AUTO SHUTDOWN IN PROGRESS">
  <DELAY 2>
  <EXIT-HACK T>
  <COMPUTER-DEAD? T>
  <I-COMPUTER-DIES <>>>

<DEFINE I-COMPUTER-DIES ("OPT" (CR T))
  <COND (.CR
	 <ZCRLF>
	 <TELL "Suddenly, everything becomes much quieter.">)
	(T
	 <TELL "The DVH2 shuts down.">)>
  <TELL
" In the distance you hear a familiar gloomy moan like
a damp llama, as the nerd yells and screams at his huge computer.|
|
\"I'll give you ">
  <SAY-NERD-MONEY>
  <TELL " to get working again,\" he yells, but unfortunately,
thanks to your timely intervention, he has hacked into his own mainframe
and destroyed its crucial I/O operations" ,PERIOD>
  <UPDATE-SCORE 1>>