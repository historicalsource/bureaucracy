"FORMS for BUREAUCRACY: Copyright (C)1987 Infocom, Inc. All rights reserved."

<FILE-FLAGS MDL-ZIL?>

<INCLUDE "OLD-PARSERDEFS" "FORMDEFS" "COMPUTERDEFS">

<SETG MARGIN 0>
<SETG FLINE 0>
<GDECL (MARGIN FLINE) FIX>

<CONSTANT FORM-HISTORY <ITABLE 20 (BYTE)>>

<SETG FORM-COMPUTER? <>>

<DEFINE DRAW-FORM (WHICH NAME)
	<SETG MARGIN </ <- ,WIDTH ,FORM-WIDTH> 2>>
	<SETG MARGIN <+ ,MARGIN 1>>
	<SETG FLINE </ <- ,HEIGHT ,FORM-LENGTH> 2>>
	<SETG FLINE <+ ,FLINE 1>>
	<CLEAR -1>
	<SPLIT <- ,HEIGHT 1>>
	<SCREEN ,S-WINDOW>
	<ZBUFOUT <>>
	<HLIGHT ,H-NORMAL>
	<HLIGHT ,H-INVERSE>
	<BLANK-LINE 0>
	<SET-FORM-CURS 1 0>
	<TELL .NAME>
	<BLANK-LINE 2>
	<OPEN-LINE 3>
	<TELL "Type ^ to back up a field. Thank you.">
	<CLOSE-LINE 3>
	<BLANK-LINE 4>
	<REPEAT ((RLINE ,FIRST-FORM-LINE)
		 (LEN:FIX <ZGET .WHICH 0>) (FIELDS <ZREST .WHICH 2>) TF)
	  <COND (<0? .LEN>
		 <BLANK-LINE <+ .RLINE 1>>
		 <RETURN>)>
	  <SET TF <ZGET .FIELDS 0>>
	  <OPEN-LINE <SET RLINE <FIELD-Y .TF>>>
	  <TELL <FIELD-PROMPT .TF>>
	  <COND (<AND <G? .LEN 1>
		      <SET TF <ZGET .FIELDS 1>>
		      <==? <FIELD-Y .TF> .RLINE>>
		 <SET-FORM-CURS .RLINE <FIELD-X .TF>>
		 <SET FIELDS <ZREST .FIELDS 2>>
		 <SET LEN <- .LEN 1>>
		 <TELL <FIELD-PROMPT .TF>>)>
	  <CLOSE-LINE .RLINE>
	  <SET FIELDS <ZREST .FIELDS 2>>
	  <SET LEN <- .LEN 1>>>
	<HLIGHT ,H-NORMAL>>

<DEFINE SET-FORM-CURS (Y:FIX X:FIX)
	<SETG FORM-X .X>
	<SETG FORM-Y .Y>
	<CURSET <+ ,FLINE .Y> <+ .X ,MARGIN>>>

<DEFINE BLANK-LINE (N)
	<SET-FORM-CURS .N 0>
	<PRINT-SPACES ,FORM-WIDTH>>

<DEFINE OPEN-LINE (N)
	<SET-FORM-CURS .N 0>
	<TELL " ">
	<HLIGHT ,H-NORMAL>
	<HLIGHT ,H-BOLD>>

<DEFINE CLOSE-LINE (N)
	<SET-FORM-CURS .N <- ,FORM-WIDTH 1>>
	<HLIGHT ,H-NORMAL>
	<HLIGHT ,H-INVERSE>
	<TELL " ">>

<BUILD-FORM LICENSE-FORM
            (LAST-NAME "Last name:" 21 "Chomper" FF-NAME
	     <PLTABLE "How embarrassing for you"
		      "A well-known criminal family">)
	    (FIRST-NAME "First name:" 25 "Random" FF-NAME
	     <PLTABLE "Your parents had the last laugh">)
	    (MIDDLE-INITIAL "Middle initial:" 1 "Q" FF-MIDDLE-INITIAL)
	    (YOUR-SEX "Your sex (M/F):" 1 "M" FF-SEX)
	    (STREET-NUMBER "House number:" 4 "69"
			   FF-STREET-NUMBER
			   <PLTABLE "Due to be condemned">)
	    (STREET-NAME "Street name:" 24 "Mandalay"
	     <PLTABLE "The bad part of town"
		      "Next to the dump">)
	    (CITY-NAME "City:" 18 "Newton" <PLTABLE "What a dump"
						    "What a pit"
						    "You'd better move again">)
	    (STATE-NAME "State:" 5 "MA" FF-STATE)
	    (ZIP-CODE "Zip:" 6 "02174")
	    (PHONE-NUMBER "Phone:" 17 "646 9105" FF-PHONE-NUMBER)
	    (EMPLOYER-NAME "Last employer but one:" 14 "Infocom"
			   <PLTABLE "Now in Chapter 11"
				    "Now in liquidation"
				    "A sweatshop"
				    "Run by Bozo the Clown"
				    "Much happier without you">)
	    (LEAST-FAVORITE-COLOR "Least favourite colour:" 12 "red"
	     FF-LEAST-FAVORITE-COLOR)
	    (FRIEND "Name of girl/boy friend:" 11 "Dunbar"
		    <PLTABLE "What a dog"
			     "Still? You should have learned"
			     "Surely you can do better"
			     "One of a long line of losers">)
	    (LAST-FRIEND "Previous girl/boy friend:" 10 "None"
			 <PLTABLE "You were better off then"
				  "One of a long line of losers"
				  "Now a millionaire"
				  "Now a famous porno star">)>

<SETG SEX <>>	; "True--> female"
<SETG FX 0>
<SETG FY 0>
<GDECL (FX FY) FIX>

<DEFINE FERROR (STR "OPT" (NOTE? <>))
	 <CLEAR-FERROR>
	 <SETG FERROR-COUNT <+ ,FERROR-COUNT:FIX 1>>
	 <COND (,FORM-COMPUTER?
		<SET-FORM-CURS ,COMPUTER-ERROR-LINE 1>
		<HLIGHT ,H-NORMAL>)
	       (T
		<SET-FORM-CURS ,ERROR-LINE 1>
		<HLIGHT ,H-BOLD>)>
	 <COND (<T? .NOTE?>
		<TELL "NOTE">)
	       (T
		<TELL "ERROR">)>
	 <TELL ": " .STR ".">
	 <HLIGHT ,H-NORMAL>
	 <COND (,FORM-COMPUTER? <HLIGHT ,H-INVERSE>)>
	 <SET-FORM-CURS ,FY ,FX>
	 <SOUND ,S-BOOP>>

<DEFINE CLEAR-FERROR ()
	 <SCREEN ,S-WINDOW>
	 <HLIGHT ,H-NORMAL>
	 <COND (,FORM-COMPUTER?
		<SET-FORM-CURS ,COMPUTER-ERROR-LINE 1>
		<PRINT-SPACES ,COMPUTER-WIDTH>
		<HLIGHT ,H-INVERSE>)
	       (T
		<SET-FORM-CURS ,ERROR-LINE 1>
		<PRINT-SPACES <- ,FORM-WIDTH 2>>)>
	 <SET-FORM-CURS ,FY ,FX>>

<DEFINE FILL-FIELD FF (FIELD:FIX WHICH "OPT" (ERR? <>)
		       "AUX" (CNT 0) (PTR ,FIELD-DATA-OFFSET)
		       MAX CHAR:FIX TBL:FIELD OLDLEN (ECHO? T))
        <COND (,FORM-COMPUTER?
	       <HLIGHT ,H-INVERSE>)
	      (T
	       <HLIGHT ,H-NORMAL>)>
	<SET TBL <ZGET .WHICH .FIELD>>
	<COND (<AND <T? <FIELD-FCN .TBL>>
		    <F? <ZAPPLY <FIELD-FCN .TBL> ,FORM-DO-ECHO? .TBL>>>
	       <SET ECHO? <>>)>
	<SET MAX <FIELD-MAXLEN .TBL>>
	<SETG FX <+ <FIELD-X .TBL> <FIELD-PROMPTLEN .TBL>>>
	<SETG FY <FIELD-Y .TBL>>
	<SET OLDLEN <FIELD-CURLEN .TBL>>
	<SET-FORM-CURS ,FY ,FX>
	<COND (<AND <ZERO? .CNT>
		    <G? .OLDLEN 0>>
	       <FIELD-CURLEN .TBL 0>
	       <SET OLDLEN 0>
	       <PRINT-SPACES .MAX>
	       <SET-FORM-CURS ,FY ,FX>)>
	<REPEAT ()
	  <SET CHAR <INPUT 1>>
	  <COND (<==? .CHAR 13> ; "CR?"
		 <COND (<0? .CNT>
			<COND (<G? .OLDLEN 0>
			       <RETURN T .FF>)>
			<SET ERR? T>
			<COND (<T? <TELECOM?>>
			       <FERROR "INCOMPLETE-FIELD-ENTRY">)
			      (T
			       <FERROR "Incomplete field entry">)>
			<AGAIN>)
		       (T
			<COND (.ERR?
			       <SET ERR? <>>
			       <CLEAR-FERROR>)>
			<FIELD-CURLEN .TBL .CNT>
			<FORM-NAME .FIELD>
			<RETURN T .FF>)>)
		(<EQUAL? .CHAR %<ASCII !\^> 14>
		 <COND (.ERR?
			<CLEAR-FERROR>)>
		 <COND (<G? .OLDLEN 0>
			<FIELD-CURLEN .TBL .OLDLEN>)>
		 <RETURN <> .FF>)
		(<EQUAL? .CHAR 127 8> ; "Backspace?"
		 <COND (<0? .CNT>
			<SET ERR? T>
			<COND (<T? <TELECOM?>>
			       <FERROR "1ST-CHAR-IN-FIELD">)
			      (T
			       <FERROR "1st char in field">)>
			<AGAIN>)>
		 <COND (.ERR?
			<SET ERR? <>>
			<CLEAR-FERROR>)>
		 <FIELD-CURLEN .TBL <SET CNT <- .CNT 1>>>
		 <COND (.ECHO?
			<SETG FX <- ,FX 1>>
			<SET-FORM-CURS ,FY ,FX>
			<PRINTC 32>
			<SET-FORM-CURS ,FY ,FX>)>
		 <PUTB .TBL <SET PTR <- .PTR 1>> 0>
		 <AGAIN>)
		(<==? .CNT .MAX>
		 <SET ERR? T>
		 <FERROR "End of field">
		 <AGAIN>)
		(<OR <F? <FIELD-FCN .TBL>>
		     <ZAPPLY <FIELD-FCN .TBL> ,FORM-ADD-CHAR .TBL .CHAR>>
		 ; "OK to use this char?"
		 <COND (<AND <G? .CHAR %<- <ASCII !\a> 1>>
			     <L? .CHAR %<+ <ASCII !\z> 1>>>
			<SET CHAR <- .CHAR 32>>)>
		 <COND (.ECHO?
			<PRINTC .CHAR>
			<SETG FX <+ ,FX 1>>)>
		 <PUTB .TBL .PTR .CHAR>
		 <SET PTR <+ .PTR 1>>
		 <FIELD-CURLEN .TBL <SET CNT <+ .CNT 1>>>)
		(T
		 <SET ERR? T>
		 <AGAIN>)>
	  <COND (.ERR?
		 <SET ERR? <>>
		 <CLEAR-FERROR>)>>>

"Functions for individual fields"

<DEFINE FF-STATE (CONTEXT TBL "OPT" CHAR)
  <COND (<AND <==? .CONTEXT ,FORM-UPPERCASE?>
	      <==? <FIELD-CURLEN .TBL> 2>>
	 2)
	(T T)>>

<DEFINE FF-LEAST-FAVORITE-COLOR (CONTEXT TBL "OPT" CHAR)
  <COND (<==? .CONTEXT ,FORM-UPPERCASE?> <>)
	(T T)>>

<DEFINE FF-STREET-NUMBER FFS (CONTEXT TBL "OPT" CHAR "AUX" X
			      (VAL T))
  <COND (<==? .CONTEXT ,FORM-OK-TO-ENTER-FIELD?>
	 ; "Force street number after name..."
	 <COND (<F? <FIELD-DONE <ZGET ,LICENSE-FORM <+ ,STREET-NAME 1>>>>
		<>)
	       (T T)>)
	(<==? .CONTEXT ,FORM-EXIT-FIELD>
	 <SET X <TEXT-TO-VALUE
		 <SET TBL <ZREST .TBL <- ,FIELD-DATA-OFFSET 1>>>>>
	 <COND (<L? .X 10>
		<FERROR "We know it's actually 15">
		<PUTB .TBL 0 2>
		<PUTB .TBL 1 %<ASCII !\1>>
		<PUTB .TBL 2 %<ASCII !\5>>
		<SET X 15>
		<SET VAL 3>)>
	 <PUTP ,OUTSIDE-HOUSE ,P?STADDR .X>
	 <PUTP ,OUTSIDE-MANSION ,P?STADDR <SET X <+ .X 1>>>
	 <PUTP ,OUTSIDE-FARM ,P?STADDR <SET X <+ .X 1>>>
	 <PUTP ,OUTSIDE-FORT ,P?STADDR <SET X <+ .X 1>>>
	 <PUTP ,ST-B ,P?STADDR <SET X <- .X 4>>>
	 <PUTP ,ST-A ,P?STADDR <SET X <- .X 1>>>
	 .VAL)
	(<==? .CONTEXT ,FORM-ADD-CHAR>
	 <COND (<CHECK-NUMBER .CHAR> T)
	       (T
		<FERROR "Not a number">
		<>)>)
	(T T)>>

<DEFINE FF-PHONE-NUMBER (CONTEXT TBL "OPT" CHAR)
  <COND (<==? .CONTEXT ,FORM-ADD-CHAR>
	 <COND (<OR <CHECK-NUMBER .CHAR>
		    <EQUAL? .CHAR 32 %<ASCII !\->>
		    <EQUAL? .CHAR %<ASCII !\(> %<ASCII !\)>>>
		T)
	       (T
		<FERROR "Invalid character">
		<>)>)
	(T T)>>

<DEFINE CHECK-NUMBER (CHAR:FIX)
  <COND (<AND <G=? .CHAR %<ASCII !\0>>
	      <L=? .CHAR %<ASCII !\9>>>
	 T)
	(T <>)>>

<DEFINE FF-SEX (CONTEXT TBL "OPT" CHAR)
  <COND (<==? .CONTEXT ,FORM-EXIT-FIELD>
	 <COND (<EQUAL? <FIELD-DATA .TBL> %<ASCII !\F> %<ASCII !\f>>
		<SETG SEX T>)
	       (T
		<SETG SEX <>>)>
	 T)
	(<==? .CONTEXT ,FORM-ADD-CHAR>
	 <COND (<OR <EQUAL? .CHAR %<ASCII !\M> %<ASCII !\m>>
		    <EQUAL? .CHAR %<ASCII !\F> %<ASCII !\f>>>
		T)
	       (T
		<FERROR "Entry not M or F">
		<>)>)
	(T T)>>

<DEFINE FF-MIDDLE-INITIAL (CONTEXT TBL "OPT" CHAR:FIX)
  <COND (<==? .CONTEXT ,FORM-ADD-CHAR>
	 <COND (<OR <AND <G=? .CHAR %<ASCII !\A>>
			 <L=? .CHAR %<ASCII !\Z>>>
		    <AND <G=? .CHAR %<ASCII !\a>>
			 <L=? .CHAR %<ASCII !\z>>>>
		T)
	       (T
		<FERROR "Invalid character">
		<>)>)
	(T T)>>

<DEFINE FF-NAME FF-NAME (CONTEXT TBL "OPT" CHAR)
  <COND (<==? .CONTEXT ,FORM-ADD-CHAR>
	 <COND (<EQUAL? .CHAR 32 %<ASCII !\'> %<ASCII !\->>
		<COND (<0? <FIELD-CURLEN .TBL>>
		       <FERROR "Illegal 1st character">
		       <>)
		      (T
		       <REPEAT ((PTR ,FIELD-DATA-OFFSET)
				(CNT <FIELD-CURLEN .TBL>))
			 <COND (<==? <CHTYPE <GETB .TBL .PTR> FIX> .CHAR>
				<COND (<==? .CHAR 32>
				       <FERROR "Too many spaces">)
				      (<==? .CHAR %<ASCII !\'>>
				       <FERROR "Too many apostrophes">)
				      (T
				       <FERROR "Too many hyphens">)>
				<RETURN <> .FF-NAME>)>
			 <COND (<0? <SET CNT <- .CNT 1>>>
				<RETURN>)>
			 <SET PTR <+ .PTR 1>>>
		       T)>)
	       (T T)>)
	(T T)>>

<DEFINE FORM-NAME FN (FIELD "AUX" (SPTR ,FIELD-DATA-OFFSET)
		   (DPTR ,FIELD-DATA-OFFSET) (CNT 1) (CAP? <>)
		   LEN TBL CHAR:FIX (UC? T) (ALL-UC? <>) TV)
	 <SET TBL <ZGET ,LICENSE-FORM <SET FIELD <+ .FIELD 1>>>>
	 <SET LEN <FIELD-CURLEN .TBL>>
         <COND
	  (<0? .LEN>
	   <RETURN <> .FN>)
	  (T
	   <COND (<AND <T? <FIELD-FCN .TBL>>
		       <F? <SET TV <ZAPPLY <FIELD-FCN .TBL>
					   ,FORM-UPPERCASE? .TBL>>>>
		  <SET UC? <>>)>
	   <COND (<==? .TV 2> <SET ALL-UC? T>)>
	   <REPEAT ()
		 <SET CHAR <CHTYPE <GETB .TBL .SPTR> FIX>>
		 <COND (<AND <G? .CHAR %<- <ASCII !\A> 1>>
			     <L? .CHAR %<+ <ASCII !\Z> 1>>>
			<COND (<F? .UC?>
			       <SET CHAR <+ .CHAR 32>>)
			      (<OR <T? .ALL-UC?> <==? .CNT 1>>
			       T)
			      (.CAP?
			       <SET CAP? <>>)
			      (T
			       <SET CHAR <+ .CHAR 32>>)>)
		       (<EQUAL? .CHAR 32 %<ASCII !\'> %<ASCII !\->>
			<COND (<NOT .CAP?>
			       <SET CAP? T>)
			      (T
			       <SET SPTR <+ .SPTR 1>>
			       <COND (<G? <SET CNT <+ .CNT 1>> .LEN>
				      <RETURN>)>
			       <AGAIN>)>)>
		 <PUTB .TBL .DPTR .CHAR>
		 <SET DPTR <+ .DPTR 1>>
		 <SET SPTR <+ .SPTR 1>>
		 <COND (<G? <SET CNT <+ .CNT 1>> .LEN>
			<RETURN>)>>)>>

<DEFINE GET-FORM ("AUX" X)
	<CLEAR -1>
        <ZCRLF>
	<ZCRLF>
	<ZCRLF>
	<HLIGHT ,H-BOLD>
	<TELL "Important!" CR>
	<HLIGHT ,H-NORMAL>
	<TELL CR 
"Our records show that you do not have a licence to operate this software.|
|
Normally, you would be required to complete a Licence Application Form and mail it (with proof of purchase) to our Licensing Department, and then wait the customary four to six weeks for processing.|
|
Luckily, for your convenience, we have, at the last minute and at great expense, installed a remarkable new on-line electronic application form on this very disk, which will be processed by our modern 24-hour computer service moments after you fill it in.|
|
[Press any key to begin.]" CR>
	<DEBUGGING-CODE
	 <COND (<N==? <SET X <INPUT 1>> 127>
		<FILL-FORM ,LICENSE-FORM
			   "      SOFTWARE LICENCE APPLICATION      ">)
	       (T
		<CLEAR -1>
		<INIT-STATUS-LINE>
		<ZCRLF>)>
	 <BIND ()
	   <INPUT 1>
	   <FILL-FORM ,LICENSE-FORM
		      "      SOFTWARE LICENCE APPLICATION      ">>>>
	 
<DEFINE PICK-FIELD (WHICH LEN:FIX HISTVEC:TABLE HISTLEN:FIX "AUX" N F)
  <REPEAT ((PASSES 0) (M 0))
    <COND (<G? <SET PASSES <+ .PASSES 1>> .LEN>
	   ; "If we've been through the loop too many times without a hit,
	      just start at the beginning and proceed until we find something
	      or run out (in 2nd case, return -1)"
	   <COND (<G? <SET M <+ .M 1>> .LEN>
		  <SET N -1>
		  <RETURN>)>
	   <SET N <- .M 1>>)
	  (T
	   <SET N <ZRANDOM .LEN>>
	   <SET N <- .N 1>>)>
    <COND (<0? <FIELD-DONE <SET F <ZGET .WHICH .N>>>>
	   <COND (<OR <F? <FIELD-FCN .F>>
		      <T? <ZAPPLY <FIELD-FCN .F> ,FORM-OK-TO-ENTER-FIELD? .F>>>
		  <FIELD-DONE <ZGET .WHICH .N> 1>
		  <PUTB .HISTVEC .HISTLEN .N>
		  <RETURN>)>)>>
  .N>

<SETG FERROR-COUNT 0>

<DEFINE FILL-FORM (WHICH NAME "AUX" X TBL Y
		   (FIELDCT:FIX <ZGET .WHICH 0>) (HIST ,FORM-HISTORY)
		   (HISTLEN 0) N (BOGUS-ERRORS 0))
  <SETG FORM-COMPUTER? <>>
  <SETG FERROR-COUNT 0>
  <DRAW-FORM .WHICH .NAME>
  <SET WHICH <ZREST .WHICH 2>>
  <REPEAT ((ZZ:FIX 0) F)
    <COND (<AND <T? <FIELD-DONE <SET F <ZGET .WHICH .ZZ>>>>
		<T? <FIELD-FCN .F>>>
	   <ZAPPLY <FIELD-FCN .F> ,FORM-FIELD-RESET .F>)>
    <FIELD-DONE <ZGET .WHICH .ZZ> 0>
    <COND (<G=? <SET ZZ <+ .ZZ 1>> .FIELDCT> <RETURN>)>>
  <SET N <PICK-FIELD .WHICH .FIELDCT .HIST 0>>
  <SET BOGUS-ERRORS 0>
  <REPEAT ((ERR? <>) ERRVAL)
	  <SET X <FILL-FIELD .N .WHICH .ERR?>>
	  <SET ERR? <>>
	  <SET TBL <ZGET .WHICH .N>>
	  <COND (<NOT .X>
		 <COND (<0? .HISTLEN>
			<FERROR "Top of form">
			<SET ERR? T>
			<AGAIN>)>
		 <SET X <+ <FIELD-X .TBL>
			   <FIELD-PROMPTLEN .TBL>>>
		 <SET Y <FIELD-Y .TBL>>
		 <SET-FORM-CURS .Y .X>
		 <HLIGHT ,H-NORMAL>
		 <PRINT-SPACES <FIELD-MAXLEN .TBL>>
		 <FIELD-CURLEN .TBL 0>
		 ; "Put this field back on the list"
		 <FIELD-DONE .TBL 0>
		 ; "And find the one we were in before"
		 <SET N <CHTYPE <GETB .HIST <SET HISTLEN <- .HISTLEN 1>>> FIX>>
		 <AGAIN>)
		(<T? <FIELD-FCN .TBL>>
		 <SET ERRVAL <ZAPPLY <FIELD-FCN .TBL> ,FORM-EXIT-FIELD .TBL>>
		 <COND (<F? .ERRVAL>
			<SET ERR? T>
			<AGAIN>)>
		 <COND (<EQUAL? .ERRVAL ,FATAL-VALUE 3>
			<SET ERR? T>
			<COND (<AND <==? .ERRVAL ,FATAL-VALUE>
				    <L=? <SET BOGUS-ERRORS <+ .BOGUS-ERRORS 1>>
					 3>>
			       <AGAIN>)>)>)>
	  <COND (<AND <PROB 35>
		      <F? .ERR?>
		      <T? <FIELD-ABUSE .TBL>>>
		 <FERROR <PICK-ONE <FIELD-ABUSE .TBL>> T>
		 <SET ERR? T>)>
	  <COND (<==? <SET HISTLEN <+ .HISTLEN 1>> .FIELDCT>
		 <RETURN>)>
	  <SET BOGUS-ERRORS 0>
	  <SET N <PICK-FIELD .WHICH .FIELDCT
			     .HIST .HISTLEN>>
	  <COND (<==? .N -1> <RETURN>)>>
  <CLEAR ,S-WINDOW>
  <CLEAR ,S-TEXT>
  ; "Does SCREEN S-TEXT..."
  <INIT-STATUS-LINE>
  <ZCRLF>
  <COND (<G? ,FERROR-COUNT:FIX 0>
	 <UPDATE-BP ,FERROR-COUNT>
	 <ZCRLF>)>
  <DIROUT ,D-SCREEN-OFF>
  <SHOW-FIELDS <ZBACK .WHICH 2>>
  <DIROUT ,D-SCREEN-ON>
  T>

"Some constants to prevent number overflows"

<MSETG MAX-NUM *77777*>		;"Largest positive number on 16 bit machine."
<MSETG MAX-NUM-DIV-10
       </ ,MAX-NUM 10>>		;"Largest div by 10"
<MSETG MAX-NUM-DIV-100
       </ ,MAX-NUM-DIV-10 10>>	;"Largest div by 100"

"Expects address of an ASCII byte table, 0th byte = length. Returns value.
 If DOT-OK is true, allows a decimal and in fact makes it 100 times bigger
 if no decimal point. Returns -1 if overflow and -2 if too many dots."

<DEFINE TEXT-TO-VALUE TTV (TBL "OPTIONAL" (DOT-OK <>)
			       "AUX" (SUM:FIX 0) LEN:FIX X:FIX (DOT-SEEN <>))
	<SET LEN <CHTYPE <GETB .TBL 0> FIX>>
	<REPEAT ((PTR:FIX 1))
		<SET X <CHTYPE <GETB .TBL .PTR> FIX>>
		<COND (<AND <G? .X %<- <ASCII !\0> 1>>
			    <L? .X %<+ <ASCII !\9> 1>>>
		       <COND (<G? .SUM ,MAX-NUM-DIV-10>
			      <RETURN -1 .TTV>)>
		       <SET SUM <* .SUM 10>>
		       <SET X <- .X %<ASCII !\0>>>
		       <COND (<G? .SUM <- ,MAX-NUM .X>>
			      <RETURN -1 .TTV>)>
		       <SET SUM <+ .SUM .X>>)
		      (<AND .DOT-OK <==? .X %<ASCII !\.>>>
		       <SET DOT-OK <>>
		       <SET DOT-SEEN T>)
		      (T
		       <RETURN -2 .TTV>)>
		<COND (<G? <SET PTR <+ .PTR 1>> .LEN>
		       <COND (<AND .DOT-OK <NOT .DOT-SEEN>>
			      <COND (<G? .SUM ,MAX-NUM-DIV-100>
				     <RETURN -1 .TTV>)>
			      <SET SUM <* .SUM 100>>)>
		       <RETURN>)>>
	<RETURN .SUM .TTV>>

<DEFINE PRINT-FULL-NAME ()
  <PRINT-NAME T>>

<DEFINE PRINT-NAME ("OPT" (FULL? <>))
  <PRINT-FIRST-NAME>
  <TELL " ">
  <COND (.FULL?
	 <SHOW-FIELD ,MIDDLE-INITIAL>
	 <TELL ". ">)>
  <PRINT-LAST-NAME>>

<DEFINE PRINT-FIRST-NAME ()
  <SHOW-FIELD ,FIRST-NAME>>

<DEFINE PRINT-LAST-NAME ()
  <SHOW-FIELD ,LAST-NAME>>

<DEFINE SHOW-FIELD (FIELD "OPT" (FORM <>))
	 <COND (<NOT .FORM>
		<SET FORM ,LICENSE-FORM>)>
	 <PRINT-VAL <ZGET .FORM <SET FIELD <+ .FIELD 1>>>>>

<DEFINE SHOW-FIELDS ("OPT" (FIELDS <>) "AUX" TF LEN:FIX)
	 <COND (<NOT .FIELDS>
		<SET FIELDS ,LICENSE-FORM>)>
	 <SET LEN <ZGET .FIELDS 0>>
	 <REPEAT ((CT 1))
	   <SET TF <ZGET .FIELDS .CT>>
	   <TELL <FIELD-PROMPT .TF> " ">
	   <PRINT-VAL .TF:FIELD>
	   <ZCRLF>
	   <COND (<G? <SET CT <+ .CT 1>> .LEN> <RETURN>)>>>

<DEFINE PRINT-VAL (TF:FIELD "AUX" (PTR ,FIELD-DATA-OFFSET)
		   CHAR (LEN <FIELD-CURLEN .TF>))
	<COND (<0? .LEN> <TELL "[no value]">)
	      (T
	       <REPEAT ((CNT 1))
		 <SET CHAR <CHTYPE <GETB .TF .PTR> FIX>>
		 <PRINTC .CHAR>
		 <SET PTR <+ .PTR 1>>
		 <COND (<G? <SET CNT <+ .CNT 1>> .LEN>
			<RETURN>)>>)>>
