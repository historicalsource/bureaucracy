"PARSER for BUREAUCRACY: (C)1987 Infocom, Inc. All rights reserved."

<FILE-FLAGS MDL-ZIL?>

<INCLUDE "OLD-PARSERDEFS" "FORMDEFS" "BANKDEFS" "XXJETDEFS">

<SETG20 SIBREAKS ".,\"!?">

<SETG DO-WINDOW <>>

<CONSTANT P-OCL1 <ITABLE NONE 25>>
<CONSTANT P-OCL2 <ITABLE NONE 25>>

<SETG P-NAM <>>

<SETG P-XNAM <>>

;<SETG P-NAMW <TABLE 0 0>>

<SETG P-ADJ <>>

<SETG P-XADJ <>>

;<SETG P-ADJW <TABLE 0 0>>

<SETG P-PHR 0>	"Which noun phrase is being parsed?"

;<SETG P-OFW <TABLE 0 0>>

;<SETG P-PRSO <ITABLE NONE 32>>

;<SETG P-PRSI <ITABLE NONE 32>>

<CONSTANT P-BUTS <ITABLE NONE 32>>

<SETG P-MERGE <ITABLE NONE 32>>

;<SETG P-GETFLAGS 0>

<SETG P-AND <>>

<VOC "#" BUZZ>

<SETG P-FOUND-REMOTELY <>>
;<SETG PRSA 0>
;<SETG PRSI 0>
;<SETG PRSO 0>
<SETG P-TABLE 0>
;<SETG P-SYNTAX 0>
<SETG P-LEN 0>
<SETG P-DIRECTION 0>
;<SETG HERE 0>

;<SETG P-LEXV <ITABLE 59 (LEXV) 0 #BYTE 0 #BYTE 0>>
<CONSTANT P-INBUF <ITABLE 99 (BYTE LENGTH) 0>>
<CONSTANT RESERVE-INBUF <ITABLE 99 (BYTE LENGTH) 0>> ; "RETROFIX #36"

"Parse-cont variable"

;<SETG P-CONT <>>
<SETG P-ALT-CONT <>>

;<SETG P-IT-OBJECT <>>
;<SETG P-HER-OBJECT <>>
;<SETG P-HIM-OBJECT <>>
;<SETG P-THEM-OBJECT <>>

"Orphan flag"

;<SETG P-OFLAG <>>

;<SETG P-MERGED <>>
<SETG P-ACLAUSE <>>
<SETG P-ANAM <>>

;<SETG P-ITBL <TABLE 0 0 0 0 0 0 0 0 0 0>>
<CONSTANT P-OTBL <TABLE 0 0 0 0 0 0 0 0 0 0>>
<CONSTANT P-VTBL <TABLE 0 0 0 0>>
<CONSTANT P-OVTBL <TABLE 0 0 0 0>>
<SETG P-NCN 0>

;<SETG QUOTE-FLAG <>>

;<SETG P-WON <>>

;<SETG P-WALK-DIR <>>
<SETG P-END-ON-PREP <>>

<CONSTANT AGAIN-LEXV <ITABLE 59 (LEXV) 0 #BYTE 0 #BYTE 0>>
<CONSTANT RESERVE-LEXV <ITABLE 59 (LEXV) 0 #BYTE 0 #BYTE 0>>
<SETG RESERVE-PTR <>>

<CONSTANT OOPS-INBUF <ITABLE 99 (BYTE LENGTH) 0>>
<CONSTANT OOPS-TABLE <TABLE <> <> <> <>>>
<SETG AGAIN-DIR <>> ; "FIX #44"

<SETG P-PRSA-WORD <>>
<SETG P-DIR-WORD <>>

<DEFINE STUFF-WORD (WD SLOT:FIX "AUX" (LV ,RESERVE-LEXV)
		    SV (IV ,RESERVE-INBUF) TN:FIX)
  ; "Number of words now in LEXV"
  <PUTB .LV ,P-LEXWORDS <+ .SLOT 1>>
  <COND (<G? .SLOT 0>
	 ; "Rest down to last slot used"
	 <SET SLOT <- .SLOT 1>>
	 <SET LV <ZREST .LV <+ <* 2 ,P-LEXSTART:FIX>
			       <* 2 .SLOT ,P-LEXELEN:FIX>>>>
	 ; "Rest inbuf to somewhere safe..."
	 <SET TN <* 2 <+ 2 <GETB .LV 3>:FIX>>>
	 <SET IV <ZREST .IV .TN>>
	 <SET LV <ZREST .LV 2>>)
	(T
	 <SET TN 0>)>
  ; "Now rest LEXV to slot we actually want to use"
  <SET LV <ZREST .LV 2>>
  ; "Save length byte of inbuf"
  <SET SV <GETB .IV 0>>
  <PUTB .IV 0 0>
  <PUTB .IV 1 0>
  ; "Print the word into the inbuf"
  <DIROUT ,D-SCREEN-OFF>
  <DIROUT ,D-TABLE-ON .IV>
  <ZPRINTB .WD>
  <DIROUT ,D-TABLE-OFF>
  <DIROUT ,D-SCREEN-ON>
  ; "Save stuff in lexv"
  <ZPUT .LV 0 .WD>
  <PUTB .LV 3 <+ .TN 2>>
  <PUTB .LV 2 <ZGET .IV 0>>
  <SET TN <+ .TN 2 <ZGET .IV 0>>>
  ; "Restore first word of inbuf"
  <PUTB .IV 0 .SV>
  <PUTB .IV 1 0>
  <PUTB ,RESERVE-INBUF 1 .TN>
  <SETG RESERVE-PTR 1>
  T>

<DEFINE FAKE-VERB/NOUN (VERB:ANY PREP ADJ NOUN:ANY
			"AUX" (SV <GETB ,RESERVE-INBUF 0>) (CT 1))
  <STUFF-WORD .VERB 0>
  <COND (<T? .PREP>
	 <STUFF-WORD .PREP 1>
	 <SET CT 2>)>
  <COND (<T? .ADJ>
	 <STUFF-WORD .ADJ .CT>
	 <SET CT <+ .CT 1>>)>
  <STUFF-WORD .NOUN .CT>
  <COND (<AND <PARSER T>
	      <F? ,P-OFLAG>>
	 <SETG P-WON T>
	 <MAIN-LOOP <> T>)>>

" Grovel down the input finding the verb, prepositions, and noun clauses.
   If the input is <direction> or <walk> <direction>, fall out immediately
   setting PRSA to ,V?WALK and PRSO to <direction>. Otherwise, perform
   all required orphaning, syntax checking, and noun clause lookup."

<DEFINE PARSER PARSER ("OPT" (NOCRLF? <>)
		       "AUX" (PTR:<OR FIX FALSE> ,P-LEXSTART) WRD (VAL 0)
		       (VERB <>) (OF-FLAG <>) (CNT-OMERGED -1)
		       (LEN:FIX 0) (DIR <>) (NW 0) (LW 0) OWINNER)
	<REPEAT ()
		<SET CNT-OMERGED <+ .CNT-OMERGED 1>>
		<COND (<G? .CNT-OMERGED ,P-ITBLLEN:FIX>
		       <RETURN>)
		      (T
		       <COND (<ZERO? ,P-OFLAG>
			      <ZPUT ,P-OTBL .CNT-OMERGED
				    <ZGET ,P-ITBL .CNT-OMERGED>>)>
		       <ZPUT ,P-ITBL .CNT-OMERGED 0>)>>
        <SETG CURRENT-OZ-VICTIM <>>
	<SETG P-NAM <>>
	<SETG P-ADJ <>>
	<SETG P-XNAM <>>
	<SETG P-XADJ <>>
	<SETG P-DIR-WORD <>>
	<COND (<ZERO? ,P-OFLAG>
	       <ZPUT ,P-OCL1 ,P-MATCHLEN 0>
	       <ZPUT ,P-OCL2 ,P-MATCHLEN 0>
	       <SETG P-LASTADJ <>>
	       <ZPUT ,P-NAMW 0 <>>
	       <ZPUT ,P-NAMW 1 <>>
	       <ZPUT ,P-ADJW 0 <>>
	       <ZPUT ,P-ADJW 1 <>>
	       <ZPUT ,P-OFW 0 <>>
	       <ZPUT ,P-OFW 1 <>>)>
	<SET CNT-OMERGED ,P-MERGED>
	<SETG P-MERGED <>>
	<SETG P-END-ON-PREP <>>
	<ZPUT ,P-PRSO ,P-MATCHLEN 0>
	<ZPUT ,P-PRSI ,P-MATCHLEN 0>
	<ZPUT ,P-BUTS ,P-MATCHLEN 0>
	<SET OWINNER ,WINNER>
	<COND (<AND <ZERO? ,QUOTE-FLAG>
		    <NOT <EQUAL? ,WINNER ,PLAYER>>>
	       <SETG WINNER ,PLAYER>
	       <SETG HERE <LOC ,WINNER>>
	       ;<COND (<NOT <IS? <LOC ,WINNER> ,VEHBIT>>
		      <SETG LAST-PLAYER-LOC ,HERE>
		      <SETG HERE <LOC ,WINNER>>)>
	       ;<SETG LIT? <IS-LIT?>>)>
	<COND (<T? ,RESERVE-PTR>
	       <SET PTR ,RESERVE-PTR>
	       <STUFF ,P-LEXV ,RESERVE-LEXV>
	       <INBUF-STUFF ,P-INBUF ,RESERVE-INBUF> ; "FIX #36"
	       <COND (<AND <T? ,VERBOSITY>
			   <EQUAL? ,PLAYER ,WINNER>
			   <F? .NOCRLF?>>
		      <ZCRLF>)>
	       <SETG RESERVE-PTR <>>
	       <SETG P-CONT <>>)
	      (<T? ,P-CONT>
	       <SET PTR ,P-CONT>
	       <SETG P-CONT <>>
	       <COND (<AND <T? ,VERBOSITY>
			   <EQUAL? ,PLAYER ,WINNER>>
		      <ZCRLF>)>)
	      (T
	       <SETG WINNER ,PLAYER>
	       <SETG QUOTE-FLAG <>>
	       <SETG HERE <LOC ,WINNER>>
	       ;<COND (<NOT <IS? <LOC ,WINNER> ,VEHBIT>>
		      <SETG LAST-PLAYER-LOC ,HERE>
		      <SETG HERE <LOC ,WINNER>>)>
	       ;<SETG LIT? <IS-LIT?>>
	       <DISPLAY-PLACE>
	       <DISPLAY-BP>
	       <COND (<T? ,DO-WINDOW>
		      <WINDOW ,DO-WINDOW>
		      <SETG DO-WINDOW <>>
		      <ZCRLF>)
		     (<T? ,VERBOSITY>
		      <ZCRLF>)>
	       <TELL ">">
	       <ZREAD ,P-INBUF ,P-LEXV>)>
	<SET NOCRLF? <>>
	<SETG P-LEN <GETB ,P-LEXV ,P-LEXWORDS>>
	<COND (<EQUAL? <ZGET ,P-LEXV .PTR> ,W?QUOTE> ; "Quote first token?"
	       <SET PTR <+ .PTR ,P-LEXELEN:FIX>>    ; "If so, ignore it."
	       <SETG P-LEN <- ,P-LEN:FIX 1>>)>
	<COND (<EQUAL? <ZGET ,P-LEXV .PTR> ,W?THEN ,W?PLEASE ,W?SO>
	       <SET PTR <+ .PTR ,P-LEXELEN:FIX>> ; "Ignore boring 1st words."
	       <SETG P-LEN <- ,P-LEN:FIX 1>>)>
	<COND (<AND <L? 1 ,P-LEN:FIX>
		    <EQUAL? <ZGET ,P-LEXV .PTR> ,W?GO> ; "GO first input word?"
		    <SET NW <ZGET ,P-LEXV <+ .PTR ,P-LEXELEN>>>
		    <WT? .NW ,PS?VERB ;,P1?VERB>   ;" followed by verb?">
	       <SET PTR <+ .PTR ,P-LEXELEN:FIX>>	;"If so, ignore it."
	       <SETG P-LEN <- ,P-LEN:FIX 1>>)>
	<COND (<ZERO? ,P-LEN>
	       <TELL "[What?]" CR>
	       <RETURN <> .PARSER>)
	      (<EQUAL? <ZGET ,P-LEXV .PTR> ,W?OOPS>
	       <COND (<EQUAL? <ZGET ,P-LEXV <+ .PTR ,P-LEXELEN:FIX>>
			      ,W?PERIOD ,W?COMMA>
		      <SET PTR <+ .PTR ,P-LEXELEN:FIX>>
		      <SETG P-LEN <- ,P-LEN:FIX 1>>)> ; "FIX #38"
	       <COND (<NOT <G? ,P-LEN:FIX 1>>
		      <TELL "[" ,CANT "use OOPS that way.]" CR>
		      <RETURN <> .PARSER>)
		     (<ZGET ,OOPS-TABLE ,O-PTR>
		      <COND (<G? ,P-LEN:FIX 2> ; "FIX #39"
			     <TELL
			      "[Only the first word after OOPS is used.]" CR>)>
		      <ZPUT ,AGAIN-LEXV <ZGET ,OOPS-TABLE ,O-PTR>
			    <ZGET ,P-LEXV <+ .PTR ,P-LEXELEN>>>
		      <SETG WINNER .OWINNER> ;"Fixes OOPS w/chars"
		      <INBUF-ADD <GETB ,P-LEXV <+ <* .PTR ,P-LEXELEN:FIX> 6>>
				 <GETB ,P-LEXV <+ <* .PTR ,P-LEXELEN:FIX> 7>>
			       <+ <* <ZGET ,OOPS-TABLE ,O-PTR> ,P-LEXELEN:FIX>
				  3>>
		      <STUFF ,P-LEXV ,AGAIN-LEXV>
		      <SETG P-LEN <GETB ,P-LEXV ,P-LEXWORDS>>
		      <SET PTR <ZGET ,OOPS-TABLE ,O-START>>
		      <INBUF-STUFF ,P-INBUF ,OOPS-INBUF>
		      <SET NOCRLF? T>)
		     (T
		      <ZPUT ,OOPS-TABLE ,O-END <>>
		      <TELL
"[There was no word to replace in that sentence.]" CR>
		      <RETURN <> .PARSER>)>)
	      (T
	       <ZPUT ,OOPS-TABLE ,O-END <>>)>
	<COND (<EQUAL? <ZGET ,P-LEXV .PTR> ,W?AGAIN ,W?G>
	       <COND (<OR <T? ,P-OFLAG>
			  <ZERO? ,P-WON>
			  <ZERO? <GETB ,OOPS-INBUF 1>>> ; "FIX #50"
		      <TELL "[" ,CANT "use AGAIN that way.]" CR>
		      <RETURN <> .PARSER>)
		     (<G? ,P-LEN:FIX 1>
		      <COND (<OR <EQUAL? <ZGET ,P-LEXV <+ .PTR ,P-LEXELEN:FIX>>
					,W?PERIOD ,W?COMMA ,W?THEN>
				 <EQUAL? <ZGET ,P-LEXV <+ .PTR ,P-LEXELEN:FIX>>
					,W?AND>>
			     <SET PTR <+ .PTR <* 2 ,P-LEXELEN:FIX>>>
			     <PUTB ,P-LEXV ,P-LEXWORDS
				   <- <GETB ,P-LEXV ,P-LEXWORDS>:FIX 2>>)
			    (T
			     <DONT-UNDERSTAND>
			     <RETURN <> .PARSER>)>)
		     (T
		      <SET PTR <+ .PTR ,P-LEXELEN:FIX>>
		      <PUTB ,P-LEXV ,P-LEXWORDS
			    <- <GETB ,P-LEXV ,P-LEXWORDS>:FIX 1>>)>
	       <COND (<G? <GETB ,P-LEXV ,P-LEXWORDS>:FIX 0>
		      <STUFF ,RESERVE-LEXV ,P-LEXV>
		      <INBUF-STUFF ,RESERVE-INBUF ,P-INBUF> ; "FIX #36"
		      <SETG RESERVE-PTR .PTR>)
		     (T
		      <SETG RESERVE-PTR <>>)>
	     ; <SETG P-LEN <GETB ,AGAIN-LEXV ,P-LEXWORDS>>
	       <SETG WINNER .OWINNER>
	       <SETG P-MERGED .CNT-OMERGED>
	       <INBUF-STUFF ,P-INBUF ,OOPS-INBUF>
	       <STUFF ,P-LEXV ,AGAIN-LEXV>
	       <SET DIR ,AGAIN-DIR> ; "FIX #44"
	       <SET CNT-OMERGED -1>
	       <COND (<T? <SETG P-CONT ,P-ALT-CONT>>
		      <SETG P-LEN <- <GETB ,P-LEXV ,P-LEXWORDS>:FIX
				     </ <- ,P-CONT:FIX ,P-LEXSTART:FIX>
					,P-LEXELEN:FIX>>>
		      <PUTB ,P-LEXV ,P-LEXWORDS ,P-LEN>)>
	       <REPEAT ()
		       <COND (<G? <SET CNT-OMERGED <+ .CNT-OMERGED 1>>
				  ,P-ITBLLEN:FIX>
		              <RETURN>)
		             (T
		              <ZPUT ,P-ITBL .CNT-OMERGED
				    <ZGET ,P-OTBL .CNT-OMERGED>>)>>)
	      (T
	       <SETG P-DOLLAR-FLAG <>>
	       <SETG P-NUMBER -1> ; "Fixed BM 2/28/86"
	       <SETG P-SEAT-NUMBER -1>
	       <COND (<F? .NOCRLF?>
		      <SETG P-ALT-CONT <>>)>
	       <STUFF ,AGAIN-LEXV ,P-LEXV>
	       <INBUF-STUFF ,OOPS-INBUF ,P-INBUF>
	       <ZPUT ,OOPS-TABLE ,O-START .PTR>
	       <ZPUT ,OOPS-TABLE ,O-LENGTH <* 4 ,P-LEN:FIX>> ; "FIX #37"
	       <SET LEN ; "FIX #43"
		    <* 2 <+ .PTR <* ,P-LEXELEN:FIX
				    <GETB ,P-LEXV ,P-LEXWORDS>:FIX>>>>
	       <ZPUT ,OOPS-TABLE ,O-END <+ <GETB ,P-LEXV
						 <SET LEN <- .LEN 1>>>:FIX
					   <GETB ,P-LEXV
						 <SET LEN <- .LEN 1>>>:FIX>>
	       <SETG RESERVE-PTR <>>
	       <SET LEN ,P-LEN>
	       <SETG P-DIRECTION <>>
	       <SETG P-NCN 0>
	       <SETG P-GETFLAGS 0>
	       <ZPUT ,P-ITBL ,P-VERBN 0>
	       <COND (<DO-BANKWORD? .PTR>
		      <RETURN <> .PARSER>)>
	       <REPEAT ()
		<COND (<L? <SETG P-LEN <- ,P-LEN:FIX 1>> 0>
		       <SETG QUOTE-FLAG <>>
		       <RETURN>)>
		<SET WRD <ZGET ,P-LEXV .PTR>>
		<COND (<AND <T? .WRD>
			    <F? <SET WRD <NOT-BUZZER-WORD? .WRD .PTR>>>>
		       <RETURN <> .PARSER>)
		      (<OR <T? .WRD>
			   <SET WRD <NUMBER? .PTR>>
			 ; <SET WRD <NAME? .PTR>>>
		       <COND (<ZERO? ,P-LEN>
			      <SET NW 0>)
			     (T
			      <SET NW <ZGET ,P-LEXV <+ .PTR ,P-LEXELEN:FIX>>>)>
		       <COND (<AND <EQUAL? .WRD ,W?TO>
				   <EQUAL? .VERB ,ACT?TELL ,ACT?ASK>>
			      <ZPUT ,P-ITBL ,P-VERB ,ACT?TELL>
			    ; <SET VERB ,ACT?TELL>
			      <SET WRD ,W?QUOTE>)
			     (<AND <EQUAL? .WRD ,W?THEN ; ,W?PERIOD>
				 ; <NOT <EQUAL? .NW ,W?THEN ,W?PERIOD>>
				   <G? ,P-LEN:FIX 0> ; "FIX #40"
				   <ZERO? .VERB>
				   <ZERO? ,QUOTE-FLAG>>
			      <ZPUT ,P-ITBL ,P-VERB ,ACT?TELL>
			      <ZPUT ,P-ITBL ,P-VERBN 0>
			      <SET WRD ,W?QUOTE>)
			     (<AND <EQUAL? .WRD ,W?PERIOD>
				   <OR <EQUAL? .LW ,W?DR ,W?MR ,W?MRS>
				       ;<EQUAL? .LW ,W?CO ,W?CORP ,W?INC>>>
			      <SETG P-NCN <- ,P-NCN:FIX 1>>
			      <CHANGE-LEXV .PTR .LW T>
			      <SET WRD .LW>
			      <SET LW 0>)>  ; "FIX #40"
		       <COND ; (<AND <EQUAL? .WRD ,W?PERIOD>
				     <EQUAL? .LW ,W?DR ,W?MR ,W?MRS>>
			        <SET LW 0>)
			     (<EQUAL? .WRD ,W?THEN ,W?PERIOD ,W?QUOTE>
			      <COND (<EQUAL? .WRD ,W?QUOTE>
				     <COND (<T? ,QUOTE-FLAG>
					    <SETG QUOTE-FLAG <>>)
					   (T
					    <SETG QUOTE-FLAG T>)>)>
			      <OR <ZERO? ,P-LEN>
				  <SETG P-CONT <+ .PTR ,P-LEXELEN:FIX>>>
			      <PUTB ,P-LEXV ,P-LEXWORDS ,P-LEN>
			      <RETURN>)
			     (<AND <SET VAL
					<WT? .WRD
					     ,PS?DIRECTION
					     ,P1?DIRECTION>>
				   <EQUAL? .VERB <> ,ACT?WALK ,ACT?GO>
				   <OR <EQUAL? .LEN 1>
				       <AND <EQUAL? .LEN 2>
					    <EQUAL? .VERB ,ACT?WALK ,ACT?GO>>
				       <AND <EQUAL? .NW ,W?THEN ,W?PERIOD
						    	,W?QUOTE>
					    <G? .LEN 1 ;2>>
				     ; <AND <EQUAL? .NW ,W?PERIOD>
					    <G? .LEN 1>>
				       <AND <T? ,QUOTE-FLAG>
					    <EQUAL? .LEN 2>
					    <EQUAL? .NW ,W?QUOTE>>
				       <AND <G? .LEN 2>
					    <EQUAL? .NW ,W?COMMA ,W?AND>>>>
			      <SET DIR .VAL>
			      <SETG P-DIR-WORD .WRD>
			      <COND (<EQUAL? .NW ,W?COMMA ,W?AND>
				     <CHANGE-LEXV <+ .PTR ,P-LEXELEN:FIX>
					          ,W?THEN>)>
			      <COND (<NOT <G? .LEN 2>>
				     <SETG QUOTE-FLAG <>>
				     <RETURN>)>)
			     (<AND <SET VAL <WT? .WRD ,PS?VERB ,P1?VERB>>
				   <ZERO? .VERB>>
			      <SETG P-PRSA-WORD .WRD> ; "For RUN, etc."
			      <SET VERB .VAL>
			      <ZPUT ,P-ITBL ,P-VERB .VAL>
			      <ZPUT ,P-ITBL ,P-VERBN ,P-VTBL>
			      <ZPUT ,P-VTBL 0 .WRD>
			      <PUTB ,P-VTBL 2 <GETB ,P-LEXV
						    <SET OF-FLAG
							 <+ <* .PTR 2> 2>>>>
			      <PUTB ,P-VTBL 3 <GETB ,P-LEXV <+ .OF-FLAG 1>>>
			      <SET OF-FLAG <>>)
			     (<OR <SET VAL <WT? .WRD ,PS?PREPOSITION 0>>
				  <EQUAL? .WRD ,W?A ,W?EVERYTHING>
				  <EQUAL? .WRD ,W?BOTH ,W?ALL>
				  <WT? .WRD ,PS?ADJECTIVE>
				  <WT? .WRD ,PS?OBJECT>>
			      ; "Used to be <OR <SET VAL ...>
						<AND <OR ...>
						     <SET VAL 0>>>
				 but that loses, and isn't needed because
				 VAL is set to 0 by the WT? anyway..."
			      <COND (<AND .VAL
					  <EQUAL? .WRD ,W?BACK>
					  <NOT <EQUAL? .VERB ,ACT?HAND>>>
				     <SET VAL 0>)>
			      <COND (<AND <G? ,P-LEN:FIX 1>
					  ; "1 IN RETROFIX #34"
					  <EQUAL? .NW ,W?OF>
					  <NOT <EQUAL? .VERB
						       ;,ACT?MAKE ,ACT?TAKE>>
					  <ZERO? .VAL>
					  <NOT <EQUAL? .WRD ,W?A>>
					  <NOT <EQUAL? .WRD ,W?ALL ,W?BOTH
						            ,W?EVERYTHING>>>
				   ; <COND (<EQUAL? .WRD ,W?BOTTOM>
					    <SET BOTTOM T>)>
				     <ZPUT ,P-OFW ,P-NCN .WRD> ; "Save OF-word"
				     <SET OF-FLAG T>)
				    (<AND <T? .VAL>
				          <OR <ZERO? ,P-LEN>
					      <EQUAL? .NW ,W?THEN ,W?PERIOD>>>
				     <SETG P-END-ON-PREP T>
				     <COND (<L? ,P-NCN:FIX 2>
					    <ZPUT ,P-ITBL ,P-PREP1 .VAL>
					    <ZPUT ,P-ITBL ,P-PREP1N .WRD>)>)
				    (<EQUAL? ,P-NCN 2>
				     <TELL
"[There are too many nouns in that sentence.]" CR>
				     <RETURN <> .PARSER>)
				    (T
				     <SETG P-NCN <+ ,P-NCN:FIX 1>>
				     <OR <SET PTR <CLAUSE .PTR .VAL .WRD>>
					 <RETURN <> .PARSER>>
				     <COND (<L? .PTR 0>
					    <SETG QUOTE-FLAG <>>
					    <RETURN>)>)>)

			     (<EQUAL? .WRD ,W?OF> ; "RETROFIX #34"
			      <COND (<OR <ZERO? .OF-FLAG>
					 <EQUAL? .NW ,W?PERIOD ,W?THEN>>
				     <CANT-USE .PTR>
				     <RETURN <> .PARSER>)
				    (T
				     <SET OF-FLAG <>>)>)
			     (<WT? .WRD ,PS?BUZZ-WORD>)
			     (<AND <EQUAL? .VERB ,ACT?TELL>
				   <WT? .WRD ,PS?VERB ;,P1?VERB>>
			      <WAY-TO-TALK>
			      <RETURN <> .PARSER>)
			     (T
			      <CANT-USE .PTR>
			      <RETURN <> .PARSER>)>)
		      (T
		       <UNKNOWN-WORD .PTR>
		       <RETURN <> .PARSER>)>
		<SET LW .WRD>
		<SET PTR <+ .PTR ,P-LEXELEN:FIX>>>)>
	<ZPUT ,OOPS-TABLE ,O-PTR <>>
	<COND (<T? .DIR>
	       <SETG PRSA ,V?WALK>
	       <SETG P-WALK-DIR .DIR>
	       <SETG AGAIN-DIR .DIR> ; "FIX #44"
	       <SETG PRSO .DIR>
	       <SETG P-OFLAG <>>
	       <RETURN T .PARSER>)>
	<SETG P-WALK-DIR <>>
	<SETG AGAIN-DIR <>> ; "FIX #44"
	<COND (<AND <T? ,P-OFLAG>
		    <ORPHAN-MERGE>>
	       <SETG WINNER .OWINNER>)
	    ; (T
	       <SETG BOTTOM? .BOTTOM>)>
      ; <COND (<ZERO? <ZGET ,P-ITBL ,P-VERB>>
	       <ZPUT ,P-ITBL ,P-VERB ,ACT?TELL>)> ; "Why was this here?"
	<COND (<AND <SYNTAX-CHECK>
		    <SNARF-OBJECTS>
		    <MANY-CHECK>
		  ; <TAKE-CHECK>
		    <ITAKE-CHECK ,P-PRSO <GETB ,P-SYNTAX ,P-SLOC1>>
		    <ITAKE-CHECK ,P-PRSI <GETB ,P-SYNTAX ,P-SLOC2>>>
	       T)>>

<DEFINE CHANGE-LEXV (PTR:FIX WRD "OPTIONAL" (PTRS? <>) "AUX" X:FIX Y:FIX Z:FIX)
	 <COND (<T? .PTRS?>
		<SET X <+ 2 <* 2 <- .PTR ,P-LEXELEN>>>>
		<SET Y <GETB ,P-LEXV .X>>
		<SET Z <+ 2 <* 2 .PTR>>>
		<PUTB ,P-LEXV .Z .Y>
		<PUTB ,AGAIN-LEXV .Z .Y>
		<SET Y <GETB ,P-LEXV <SET X <+ 1 .X>>>>
		<SET Z <+ 3 <* 2 .PTR>>>
		<PUTB ,P-LEXV .Z .Y>
		<PUTB ,AGAIN-LEXV .Z .Y>)>
	 <ZPUT ,P-LEXV .PTR .WRD>
	 <ZPUT ,AGAIN-LEXV .PTR .WRD>
	 T>

<OBJECT HELLO-OBJECT
	(LOC GLOBAL-OBJECTS)
	(DESC "that")
	(FLAGS NODESC NOARTICLE)
	(SYNONYM HELLO GOODBYE HI BYE)
	(ACTION WAY-TO-TALK)>

<DEFINE WAY-TO-TALK ("OPTIONAL" (Q? <>))
	 <PCLEAR>
	 <TELL "[Refer to your ">
	 <ITALICIZE "Bureaucracy">
	 <TELL " manual for the correct way to address characters.]" CR>
	 ,FATAL-VALUE>

"Check whether word pointed at by PTR is the correct part of speech.
   The second argument is the part of speech (,PS?<part of speech>). The
   3rd argument (,P1?<part of speech>), if given, causes the value
   for that part of speech to be returned."

<DEFINE DO-WT? (PTR BIT "OPTIONAL" (B1:FIX 5) "AUX" (OFFS:FIX ,P-P1OFF) TYP)
	<COND (<BTST <SET TYP <GETB .PTR ,P-PSOFF>> .BIT>
	       <COND (<G? .B1 4>
		      T)
		     (T
		      <SET TYP <BAND .TYP ,P-P1BITS>>
		      <COND (<NOT <EQUAL? .TYP .B1>>
			     <SET OFFS <+ .OFFS 1>>)>
		      <GETB .PTR .OFFS>)>)>>

"Scan through a noun phrase, leaving a pointer to its starting location:"

<DEFINE CLAUSE CLAUSE
	(PTR:FIX VAL WRD "AUX" OFF:FIX NUM:FIX (ANDFLG <>)
	 (FIRST?? T) NW (LW 0))
	<SET OFF <* <- ,P-NCN:FIX 1> 2>>
	<COND (<T? .VAL>
	       <ZPUT ,P-ITBL <SET NUM <+ ,P-PREP1:FIX .OFF>> .VAL>
	       <ZPUT ,P-ITBL <+ .NUM 1> .WRD>
	       <SET PTR <+ .PTR ,P-LEXELEN:FIX>>)
	      (T
	       <SETG P-LEN <+ ,P-LEN:FIX 1>>)>
	<COND (<ZERO? ,P-LEN>
	       <SETG P-NCN <- ,P-NCN:FIX 1>>
	       <RETURN -1 .CLAUSE>)>
	<ZPUT ,P-ITBL <SET NUM <+ ,P-NC1:FIX .OFF>> <ZREST ,P-LEXV <* .PTR 2>>>
	<COND (<DO-BANKWORD? .PTR>
	       <RETURN <> .CLAUSE>)>
	<REPEAT ()
		<COND (<L? <SETG P-LEN <- ,P-LEN:FIX 1>> 0>
		       <ZPUT ,P-ITBL <+ .NUM 1> <ZREST ,P-LEXV <* .PTR 2>>>
		       <RETURN -1 .CLAUSE>)>
		<SET WRD <ZGET ,P-LEXV .PTR>>
		<COND (<AND <T? .WRD>
			    <F? <SET WRD <NOT-BUZZER-WORD? .WRD .PTR>>>>
		       <RETURN <> .CLAUSE>)
		      (<OR <T? .WRD>
			   <SET WRD <NUMBER? .PTR>>
			 ; <SET WRD <NAME? .PTR>>>
		       <COND (<ZERO? ,P-LEN>
			      <SET NW 0>)
			     (T
			      <SET NW <ZGET ,P-LEXV <+ .PTR ,P-LEXELEN:FIX>>>
			      <COND (<ZERO? .NW> ; "FIX"
				     <SET NW
					  <NUMBER? <+ .PTR
						      ,P-LEXELEN:FIX>>>)>)>
		     ; <COND (<AND <EQUAL? .WRD ,W?OF>
				   <EQUAL? <ZGET ,P-ITBL ,P-VERB>
					   ,ACT?MAKE ,ACT?TAKE>>
			      <CHANGE-LEXV .PTR ,W?WITH>
			      <SET WRD ,W?WITH>)>
		       <COND (<AND .FIRST?? ;"LIE DOWN ON, OPEN BACK DOOR..."
				   <OR <EQUAL? .WRD ,W?THE ,W?A ,W?AN>
				       <AND .VAL
					    <WT? .WRD ,PS?PREPOSITION>
					    <NOT <WT? .WRD ,PS?ADJECTIVE>>>>>
			      <ZPUT ,P-ITBL .NUM
				    <ZREST <ZGET ,P-ITBL .NUM> 4>>)
			     (<AND <EQUAL? .WRD ,W?PERIOD>
				   <EQUAL? .LW ,W?MR ,W?MRS ,W?MISS>>
			      <SET LW 0>)
			     (<EQUAL? .WRD ,W?AND ,W?COMMA>
			      <SET ANDFLG T>)
			     (<EQUAL? .WRD ,W?ALL ,W?BOTH ,W?EVERYTHING>
			    ; <OR <EQUAL? .WRD ,W?ALL ,W?BOTH ,W?ONE>
				  <EQUAL? .WRD ,W?EVERYTHING>>
			      <COND (<EQUAL? .NW ,W?OF>
				     <SETG P-LEN <- ,P-LEN:FIX 1>>
				     <SET PTR <+ .PTR ,P-LEXELEN:FIX>>)>)
			     (<OR <EQUAL? .WRD ,W?THEN ,W?PERIOD>
				  <AND <WT? .WRD ,PS?PREPOSITION>
				       <ZGET ,P-ITBL ,P-VERB>
				       <NOT .FIRST??>>>
			      <SETG P-LEN <+ ,P-LEN:FIX 1>>
			      <ZPUT ,P-ITBL
				   <+ .NUM 1>
				   <ZREST ,P-LEXV <* .PTR 2>>>
			      <RETURN <- .PTR ,P-LEXELEN:FIX> .CLAUSE>)
			     ;"3/16/83: This clause used to be later."
			     (<AND <T? .ANDFLG>
				   <OR ;"3/25/83: next statement added."
				       <ZERO? <ZGET ,P-ITBL ,P-VERBN>>
				       ;"10/26/84: next stmt changed"
				       <VERB-DIR-ONLY? .WRD>>>
			      <SET PTR <- .PTR 4>>
			      <CHANGE-LEXV <+ .PTR 2> ,W?THEN>
			      <SETG P-LEN <+ ,P-LEN:FIX 2>>)
			     (<WT? .WRD ,PS?OBJECT>
			      <COND (<AND <G? ,P-LEN:FIX 0>
					  <EQUAL? .NW ,W?OF>
					  <NOT <EQUAL? .WRD ,W?ALL ; ,W?ONE
						            ,W?EVERYTHING>>>
				     <ZPUT ,P-OFW <- ,P-NCN:FIX 1> .WRD>)
				    (<AND <WT? .WRD ,PS?ADJECTIVE
					       ;,P1?ADJECTIVE>
					  ; "Word is also an adjective"
					  <T? .NW>
					  ; "And is followed by a noun"
					  <WT? .NW ,PS?OBJECT>>
				     <COND (<EQUAL? .WRD ,W?TELLER ,W?AISLE
						    ,W?ROW ,W?CARD>
					    ; "kludge to allow teller to work
					       well as adj and noun..."
					    <COND (<NOT <EQUAL? .NW ,W?WINDOW
								,W?WINDOWS
								,W?SIGN
								,W?INTNUM
								,W?\#
								,W?READER>>
						   ; "End the clause NOW,
						      because not teller window
						      or teller sign"
						   <ZPUT ,P-ITBL
							 <+ .NUM 1>
							 <ZREST ,P-LEXV
								<* <+ .PTR 2>
								   2>>>
						   <RETURN .PTR .CLAUSE>)>)>
				     T)
				    (<AND <ZERO? .ANDFLG>
					  <NOT <EQUAL? .NW ,W?BUT ,W?EXCEPT>>
					  <NOT <EQUAL? .NW ,W?AND ,W?COMMA>>>
				     <ZPUT ,P-ITBL
					  <+ .NUM 1>
					  <ZREST ,P-LEXV <* <+ .PTR 2> 2>>>
				     <RETURN .PTR .CLAUSE>)
				    (T
				     <SET ANDFLG <>>)>)

       ; "Next clause replaced by following one to enable OLD WOMAN, HELLO"

			   ; (<AND <OR <T? ,P-MERGED>
				       <T? ,P-OFLAG>
				       <T? <ZGET ,P-ITBL ,P-VERB>>>
				   <OR <WT? .WRD ,PS?ADJECTIVE>
				       <WT? .WRD ,PS?BUZZ-WORD>>>)
			     (<OR <WT? .WRD ,PS?ADJECTIVE>
				  <WT? .WRD ,PS?BUZZ-WORD>>
			      T)
			     (<AND <T? .ANDFLG>
				   <ZERO? <ZGET ,P-ITBL ,P-VERB>>>
			      <SET PTR <- .PTR 4>>
			      <CHANGE-LEXV <+ .PTR 2> ,W?THEN>
			      <SETG P-LEN <+ ,P-LEN 2>>)
			     (<WT? .WRD ,PS?PREPOSITION>
			      T)
			     (T
			      <CANT-USE .PTR>
			      <RETURN <> .CLAUSE>)>)
		      (T
		       <UNKNOWN-WORD .PTR>
		       <RETURN <> .CLAUSE>)>
		<SET LW .WRD>
		<SET FIRST?? <>>
		<SET PTR <+ .PTR ,P-LEXELEN:FIX>>>>

<DEFINE SPOKEN-TO (WHO)
         <COND (<OR <NOT <EQUAL? .WHO ,QCONTEXT>>
		    <NOT <EQUAL? ,HERE ,QCONTEXT-ROOM>>>
		<COND (<==? <SETG QCONTEXT .WHO> ,RANDOM-PERSON>
		       <SETG QCONTEXT-ROOM ,SEAT>)
		      (<==? ,QCONTEXT ,NATIVES>
		       <SETG QCONTEXT-ROOM ,HERE>)
		      (T
		       <SETG QCONTEXT-ROOM <LOC .WHO>>)>
	        <THIS-IS-IT .WHO>
	        <TELL "[spoken to " THE .WHO ,BRACKET>)>
	 T>

<DEFINE THIS-IS-IT (OBJ)
         <COND (<OR <EQUAL? .OBJ <> ,PLAYER ,NOT-HERE-OBJECT ,ME>
		    <EQUAL? .OBJ ,INTDIR ,INTNUM ;,RIGHT>
		    <EQUAL? .OBJ ;,LEFT ,INCIDENT>>)
	       (<AND <VERB? WALK WALK-TO>
		     <EQUAL? .OBJ ,PRSO>>)
	       (<AND <IS? .OBJ ,PERSON>
		     <F? <IS? .OBJ ,PLURAL>>
		     <N==? .OBJ ,MACAW>>
		<COND (<IS? .OBJ ,FEMALE>
		       <SETG P-HER-OBJECT .OBJ>)
		      (T
		       <SETG P-HIM-OBJECT .OBJ>)>)
	       (<IS? .OBJ ,PLURAL>
		<SETG P-THEM-OBJECT .OBJ>)
	       (T
		<SETG P-IT-OBJECT .OBJ>)>
	 T>

<DEFINE FAKE-ORPHAN ("AUX" TMP)
	 <ORPHAN ,P-SYNTAX <>>
	 <BE-SPECIFIC>
	 <SET TMP <ZGET ,P-OTBL ,P-VERBN>>
	 <COND (<ZERO? .TMP>
		<TELL "tell">)
	       (<ZERO? <GETB ,P-VTBL 2>>
		<TELL WORD <ZGET .TMP 0>>)
	       (T
		<WORD-PRINT <GETB .TMP 2> <GETB .TMP 3>>
		<PUTB ,P-VTBL 2 0>)>
	 <COND (,P-SYNTAX
		<PREP-PRINT <GETB ,P-SYNTAX ,P-SPREP1> T>)>
	 <SETG P-OFLAG T>
	 <SETG P-WON <>>
	 <TELL "?]" CR>>

;<SETG NOW-PRSI? <>>

<MSETG NSVERBS 19> "Number of SEEVERBS"

<CONSTANT SEEVERBS
	<PTABLE V?EXAMINE V?LOOK V?LOOK-INSIDE V?LOOK-ON V?READ V?FIND
		V?SEARCH V?SHOW V?LOOK-UNDER V?LOOK-BEHIND V?LOOK-THRU
		V?LOOK-DOWN V?LOOK-UP V?READ-TO V?LOOK-OUTSIDE V?COUNT
		V?WATCH V?ADJUST V?POINT>>

<SETG PERFORMING? <>>

<DEFINE PERFORM PERFORM (A "OPTIONAL" (O <>) (I <>)
		    "AUX" (V <>) OA OO OI ONP (WHO <>) ;(TUCH <>)
			  (OP ,PERFORMING?) OV)
	#DECL ((A) FIX (O) <OR FALSE OBJECT FIX> (I) <OR FALSE OBJECT>)
	<COND (<AND <NOT <EQUAL? ,WINNER ,PLAYER>>
		    <NOT <IS? ,WINNER ,PERSON>>>
	       <NOT-LIKELY ,WINNER "would respond">
	       <PCLEAR>
	       <RETURN ,FATAL-VALUE .PERFORM>)>
	<SET OA ,PRSA>
	<SET OO ,PRSO>
	<SET OI ,PRSI>
	<SET ONP ,NOW-PRSI?>
        <SET WHO <ANYONE-HERE?>>
	<SETG PRSA .A>
	;<COND (<AND <ZERO? ,LIT?>
		    <SEEING?>>
	       <TOO-DARK>
	       <RETURN ,FATAL-VALUE .PERFORM>)>
	<SETG PERFORMING? T>
	<SET V ,FATAL-VALUE>
	<PROG ()
	  <COND (<NOT <EQUAL? .A ,V?WALK>>
		 <COND (<AND <EQUAL? ,WINNER ,PLAYER>
			     <VERB? WHO WHAT WHERE>>
			<COND (<ZERO? .WHO>
			       <NOBODY-TO-ASK>
			       <RETURN>)
			      (T
			       <SETG WINNER .WHO>
			       <SPOKEN-TO .WHO>)>)
		       (<AND <EQUAL? ,WINNER ,PLAYER>
			     <EQUAL? .O ,ME>
			     <VERB? TELL TELL-ABOUT ASK-ABOUT ASK-FOR
				    QUESTION REPLY THANK YELL HELLO GOODBYE
				    SAY ALARM>>
			<COND (<ZERO? .WHO>
			       <TALK-TO-SELF>
			       <RETURN>)
			      (T
			       <SETG WINNER .WHO>
			       <SPOKEN-TO .WHO>)>)>
		 <COND (<EQUAL? ,YOU .I .O>
			<COND (<EQUAL? ,WINNER ,PLAYER>
			       <COND (<ZERO? .WHO>
				      <TALK-TO-SELF>
				      <RETURN>)
				     (T
				      <SETG WINNER .WHO>
				      <SPOKEN-TO .WHO>)>)
			      (T
			       <COND (<==? <SETG QCONTEXT ,WINNER>
					   ,RANDOM-PERSON>
				      <SETG QCONTEXT-ROOM ,SEAT>)
				     (T
				      <SETG QCONTEXT-ROOM <LOC ,WINNER>>)>
			       <SET WHO ,WINNER>)>
			<COND (<EQUAL? .I ,YOU>
			       <SET I .WHO>)>
			<COND (<EQUAL? .O ,YOU>
			       <SET O .WHO>)>)>
		 <COND (<AND <EQUAL? ,IT .I .O>
			     <NOT <ACCESSIBLE? ,P-IT-OBJECT>>>
			<COND (<ZERO? .I>
			       <FAKE-ORPHAN>)
			      (T
			       <CANT-SEE-ANY ,P-IT-OBJECT>)>
			<RETURN>)>
		 <COND (<EQUAL? ,THEM .I .O>
			<COND (<VISIBLE? ,P-THEM-OBJECT>
			       <COND (<EQUAL? ,THEM .O>
				      <SET O ,P-THEM-OBJECT>)>
			       <COND (<EQUAL? ,THEM .I>
				      <SET I ,P-THEM-OBJECT>)>)
			      (T
			       <COND (<ZERO? .I>
				      <FAKE-ORPHAN>)
				     (T
				      <CANT-SEE-ANY ,P-THEM-OBJECT>)>
			       <RETURN>)>)>
		 <COND (<EQUAL? ,HER .I .O>
			<COND (<VISIBLE? ,P-HER-OBJECT>
			       <COND (<NOT <IS? ,P-HER-OBJECT ,FEMALE>>
				      <TELL "This " D ,P-HER-OBJECT
					    " is a man."
					     CR>
				      <RETURN>)>
			       <COND (<AND <EQUAL? ,P-HER-OBJECT ,WINNER>
					   <NO-OTHER? T>>
				      <RETURN>)>
			       <COND (<EQUAL? ,HER .O>
				      <SET O ,P-HER-OBJECT>)>
			       <COND (<EQUAL? ,HER .I>
				      <SET I ,P-HER-OBJECT>)>)
			      (T
			       <COND (<ZERO? .I>
				      <FAKE-ORPHAN>)
				     (T
				      <CANT-SEE-ANY ,P-HER-OBJECT>)>
			       <RETURN>)>)>
		 <COND (<EQUAL? ,HIM .I .O>
			<COND (<VISIBLE? ,P-HIM-OBJECT>
			       <COND (<IS? ,P-HIM-OBJECT ,FEMALE>
				      <TELL "This " D ,P-HIM-OBJECT
					    " is a woman." CR>
				      <RETURN>)>
			       <COND (<AND <EQUAL? ,P-HIM-OBJECT ,WINNER>
					   <NO-OTHER?>>
				      <RETURN>)>
			       <COND (<EQUAL? ,HIM .O>
				      <SET O ,P-HIM-OBJECT>)>
			       <COND (<EQUAL? ,HIM .I>
				      <SET I ,P-HIM-OBJECT>)>)
			      (T
			       <COND (<ZERO? .I>
				      <FAKE-ORPHAN>)
				     (T
				      <CANT-SEE-ANY ,P-HIM-OBJECT>)>
			       <RETURN>)>)>
		 <COND (<EQUAL? .O ,IT>
			<SET O ,P-IT-OBJECT>)>
		 <COND (<EQUAL? .I ,IT>
			<SET I ,P-IT-OBJECT>)>)>
	  <SETG PRSI .I>
	  <SETG PRSO .O>
	  <SET V <>>
	  <COND (<AND <NOT <EQUAL? .A ,V?WALK>>
		      <EQUAL? ,NOT-HERE-OBJECT ,PRSO ,PRSI>>
		 <SET V <ZAPPLY ,NOT-HERE-OBJECT-F>>
		 <COND (<T? .V>
			<SETG P-WON <>>)>)>
	  ; <THIS-IS-IT ,PRSI>
	  <THIS-IS-IT ,PRSO>
	  <SET O ,PRSO>
	  <SET I ,PRSI>
	  <COND (<ZERO? .V>
		 <COND (<AND <N==? ,WINNER ,PLAYER>
			     <EQUAL? ,WINNER .O .I>>
			<TELL CTHE ,WINNER " quite properly ignore">
			<COND (<NOT <IS? ,WINNER ,PLURAL>> <TELL "s">)>
			<TELL " you." CR>
			<SET V ,FATAL-VALUE>)
		       (T
			<SET V <ZAPPLY <GETP ,WINNER ,P?ACTION> ,M-WINNER>>)>)>
	  <COND (<ZERO? .V>
		 <COND (<T? <LOC ,WINNER>>
			<SET V <ZAPPLY <GETP <LOC ,WINNER> ,P?ACTION>
				       ,M-BEG>>)>)>
	  <COND (<ZERO? .V>
		 <SET V <ZAPPLY <ZGET ,PREACTIONS .A>>>)>
	  ;<COND (<OR <TOUCHING?>
		     <HURTING?>>
		 <SET TUCH T>)>
	  <COND (<NOT <EQUAL? .A ,V?TELL-ABOUT ,V?ASK-ABOUT ,V?ASK-FOR>>
		 <SETG NOW-PRSI? T>
		 <COND (<AND <ZERO? .V>
			     <T? .I>
			     <NOT <EQUAL? .A ,V?WALK>>
			     <LOC .I>>
			<SET V <GETP <LOC .I> ,P?CONTFCN>>
			<COND (<T? .V>
			       <SET V <ZAPPLY .V ,M-CONT>>)>)>
		 <SETG NOW-PRSI? <>>
		 <COND (<AND <ZERO? .V>
			     <T? .O>
			     <NOT <EQUAL? .A ,V?WALK>>
			     <LOC .O>>
			<SET V <GETP <LOC .O> ,P?CONTFCN>>
			<COND (<T? .V>
			       <SET V <ZAPPLY .V ,M-CONT>>)>)>
		 <SETG NOW-PRSI? T>
		 <COND (<AND <ZERO? .V>
			     <T? .I>>
			<SET V <ZAPPLY <GETP .I ,P?ACTION>>>)>)
		(T
		 <THIS-IS-IT ,PRSI>)>
	  <SETG NOW-PRSI? <>>
	  <COND (<AND <ZERO? .V>
		      <T? .O>
		      <NOT <EQUAL? .A ,V?WALK>>>
		 <SET V <ZAPPLY <GETP .O ,P?ACTION>>>)>
	  <COND (<ZERO? .V>
		 <SET V <ZAPPLY <ZGET ,ACTIONS .A>>>)>
	  <COND (<AND <N==? .V ,FATAL-VALUE>
		      <T? <LOC ,WINNER>>>
		 <SET OV <ZAPPLY <GETP <LOC ,WINNER> ,P?ACTION>
				 ,M-END>>
		 <COND (<T? .OV> <SET V .OV>)>)>
	  <SETG PRSA .OA>
	  <SETG PRSO .OO>
	  <SETG PRSI .OI>
	  <SETG NOW-PRSI? .ONP>>
	<SETG PERFORMING? .OP>
	.V>

<DEFINE NO-OTHER? ("OPTIONAL" (FEMALE? <>) "AUX" OBJ)
	 <SET OBJ <FIRST? ,HERE>>
	 <REPEAT ()
		 <COND (<T? .OBJ>
			<COND (<AND <NOT <EQUAL? .OBJ ,WINNER>>
				    <IS? .OBJ ,PERSON>>
			       <COND (<T? .FEMALE?>
				      <COND (<IS? .OBJ ,FEMALE>
					     <RETURN>)>)
				     (<NOT <IS? .OBJ ,FEMALE>>
				      <RETURN>)>)>
			<SET OBJ <NEXT? .OBJ>>)
		       (T
			<RETURN>)>>
	 <COND (<ZERO? .OBJ>
		<LOOKS-PUZZLED ,WINNER>
		<TELL "To whom are you referring?\"" CR>
		T)
	       (T
		<>)>>

<DEFINE NOBODY-TO-ASK ()
	 <PCLEAR>
	 <TELL "There's nobody here to ask." CR>>

<DEFINE TALK-TO-SELF ()
	 <PCLEAR>
	 <TELL "[You must address characters directly.]" CR>>

<CONSTANT BUZZTABLE
	<PTABLE
	 <PLTABLE <VOC "WHY" <>> <VOC "HOW" <>> <VOC "HOW\'S" <>>
		  <VOC "WHEN" <>> <VOC "WHEN\'S" <>> <VOC "WOULD" <>>
		  <VOC "COULD" <>> <VOC "SHOULD" <>>>
	 <PLTABLE <VOC "THAT\'S" <>> <VOC "I\'M" <>>
		  <VOC "DID" <>> <VOC "THEY\'RE" <>> <VOC "SHALL" <>>
		  <VOC "DO" <>> <VOC "HAVE" <>> <VOC "ANY" <>>
		  <VOC "I\'LL" <>> <VOC "WHICH" <>> <VOC "WE\'RE" <>>
		  <VOC "I\'VE" <>> <VOC "WON\'T" <>> <VOC "HAS" <>>
		  <VOC "YOU\'RE" <>> <VOC "HE\'S" <>> <VOC "SHE\'S" <>>
		  <VOC "WILL" <>> <VOC "WERE" <>>>
	 <PLTABLE <VOC "ZERO" <>> <VOC "EIGHT" <>> <VOC "NINE" <>>
		  <VOC "TEN" <>> <VOC "ELEVEN" <>> <VOC "TWELVE" <>>
		; <VOC "THIRTEEN" <>> <VOC "FOURTEEN" <>> <VOC "FIFTEEN" <>>
		  <VOC "SIXTEEN" <>> <VOC "SEVENTEEN" <>> <VOC "EIGHTEEN" <>>
		  <VOC "NINETEEN" <>> ; <VOC "TWENTY" <>> ; <VOC "THIRTY" <>>
		  <VOC "FORTY" <>> ; <VOC "FIFTY" <>> <VOC "SIXTY" <>>
		  <VOC "SEVENTY" <>> <VOC "EIGHTY" <>> <VOC "NINETY" <>>
		  <VOC "HUNDRED" <>> <VOC "THOUSAND" <>> <VOC "MILLION" <>>
		  <VOC "BILLION" <>>>
	 <PLTABLE <VOC "CURSE" <>> <VOC "GODDAMNED" <>> <VOC "CUSS" <>>
		  <VOC "DAMN" <>> <VOC "FUCK" <>>
		  <VOC "SHITHEAD" <>> <VOC "BASTARD" <>> <VOC "ASS" <>>
		  <VOC "FUCKING" <>> <VOC "BITCH" <>> <VOC "DAMNED" <>>
		  <VOC "COCKSUCKER" <>> <VOC "FUCKED" <>> <VOC "PEE" <>>
		  <VOC "CUNT" <>> <VOC "ASSHOLE" <>> <VOC "PISS" <>>
		  <VOC "SUCK" <>> <VOC "SHIT" <>> <VOC "CRAP" <>> >
	 <PLTABLE <VOC "NE" <>> <VOC "NW" <>> <VOC "SE" <>> <VOC "SW" <>>
		  <VOC "NORTHEAST" <>> <VOC "NORTHWEST" <>>
		  <VOC "SOUTHEAST" <>> <VOC "SOUTHWEST" <>> >
	 >>

<DEFINE NOT-BUZZER-WORD? (WORD PTR "AUX" TBL X (BT ,BUZZTABLE))
         <SET TBL <ZGET .BT 0>>
	 <COND (<INTBL? .WORD <ZREST .TBL 2> <ZGET .TBL 0>>
	        <TO-DO-THING-USE "ask about" "ASK CHARACTER ABOUT">
	        <>)
	       (<INTBL? .WORD <ZREST <SET TBL <ZGET .BT 1>> 2>
			<ZGET .TBL 0>>
	        <WAY-TO-TALK T>
		<>)
	       (<INTBL? .WORD <ZREST <SET TBL <ZGET .BT 2>> 2>
			<ZGET .TBL 0>>
	        <TELL "[" ,DONT "need to use that " D ,INTNUM>
		<TO-COMPLETE>
		<>)
	       (<INTBL? .WORD <ZREST <SET TBL <ZGET .BT 3>> 2>
			<ZGET .TBL 0>>
	        <TELL
"This is a delicate, sensitive, well-brought-up game which does not recognise
the word... well, whatever it was you just said that we do not recognise.
What would Miss Manners say">
		<COND (<EQUAL? .WORD ,W?SHITHEAD ,W?BASTARD ,W?ASSHOLE
			       ,W?COCKSUCKER>
		       <TELL ", you " WORD .WORD "?">)
		      (<EQUAL? .WORD ,W?CURSE ,W?CUSS> <TELL "?">)
		      (<EQUAL? .WORD ,W?GODDAMNED ,W?DAMN ,W?DAMNED>
		       <TELL ", damn it?">)
		      (<EQUAL? .WORD ;,W?HELL ,W?FUCK>
		       <TELL
			"? Who the " WORD .WORD
			" do you think you are, anyway?">)
		      (<EQUAL? .WORD ,W?FUCKING ,W?FUCKED ,W?CUNT>
		       <TELL
			"? What sort of fucking asshole are you anyway?">)
		      (T
		       <TELL "? What the hell do you think this is?">)>
		<TELL " Please use another, nice word instead." CR>
		<>)
	       (<INTBL? .WORD <ZREST <SET TBL <ZGET .BT 4>> 2>
			<ZGET .TBL 0>>
		<V-BAD-DIRECTION>
		<>)
	       (<OR <EQUAL? .WORD ; ,W?ZORK ,W?XYZZY ,W?GRUE>
		    <EQUAL? .WORD ,W?PLUGH ,W?SAILOR>>
		<TELL "[Sigh.]" CR>
		<>)
	       (<OR <EQUAL? .WORD ,W?QUIETLY ,W?SLOWLY ,W?CAREFULLY>
		    <EQUAL? .WORD ,W?CLOSELY ,W?QUICKLY ,W?RAPIDLY>>
	        <TELL "[Adverbs (such as \"">
	        <TELL WORD .WORD>
	        <TELL "\") aren't needed">
	        <TO-COMPLETE>
		<>)
	       (<EQUAL? .WORD ,W?\!>
		<TELL "There's absolutely ">
		<ITALICIZE "no">
		<TELL " need to get excited!!!" CR>
		<UPDATE-BP 2>
		<COND (<G=? .PTR 0> <ZPUT ,P-LEXV .PTR ,W?PERIOD>)>
		,W?PERIOD)
	       (T
		.WORD)>>

<DEFINE VERB-DIR-ONLY? (WRD)
	 <COND (<AND <NOT <WT? .WRD ,PS?OBJECT>>
	             <NOT <WT? .WRD ,PS?ADJECTIVE>>
	             <OR <WT? .WRD ,PS?DIRECTION>
		         <WT? .WRD ,PS?VERB>>>
		T)
	       (T
		<>)>>

<BUZZ AGAIN G OOPS>

"For AGAIN purposes, put contents of one LEXV table into another."

<DEFINE STUFF (DEST SRC "OPTIONAL" (MAX:FIX 29)
		         "AUX" (CTR:FIX 1))
	 <PUTB .DEST 0 <GETB .SRC 0>>
	 <PUTB .DEST 1 <GETB .SRC 1>>
	 <SET DEST <ZREST .DEST <* ,P-LEXSTART:FIX 2>>>
	 <SET SRC <ZREST .SRC <* ,P-LEXSTART:FIX 2>>>
	 <REPEAT ()
	         <ZPUT .DEST 0 <ZGET .SRC 0>>
	         <PUTB .DEST 2 <GETB .SRC 2>>
		 <PUTB .DEST 3 <GETB .SRC 3>>
		 <COND (<G? <SET CTR <+ .CTR 1>> .MAX>
		        <RETURN>)>
		 <SET DEST <ZREST .DEST <* 2 ,P-LEXELEN:FIX>>>
		 <SET SRC <ZREST .SRC <* 2 ,P-LEXELEN:FIX>>>>>

"Put contents of one INBUF into another."

<DEFINE INBUF-STUFF (DEST SRC "AUX" CNT:FIX)
	 <SET CNT <- <GETB .SRC 0> 1>>
	 <REPEAT ()
		 <PUTB .DEST .CNT <GETB .SRC .CNT>>
		 <COND (<L? <SET CNT <- .CNT 1>> 0>
			<RETURN>)>>>

"Put the word in the positions specified from P-INBUF to the end of
OOPS-INBUF, leaving the appropriate pointers in AGAIN-LEXV."

<DEFINE INBUF-ADD (LEN:FIX BEG:FIX SLOT:FIX "AUX" DBEG:FIX (CTR:FIX 0) TMP)
	 <SET TMP <ZGET ,OOPS-TABLE ,O-END>>
	 <COND (<T? .TMP>
		<SET DBEG .TMP>)
	       (T
		<SET DBEG <+ <GETB ,AGAIN-LEXV
				   <SET TMP <ZGET ,OOPS-TABLE ,O-LENGTH>>>
			     <GETB ,AGAIN-LEXV <+ .TMP 1>>>>)>
	 <ZPUT ,OOPS-TABLE ,O-END <+ .DBEG .LEN>>
	 <REPEAT ()
	         <PUTB ,OOPS-INBUF <+ .DBEG .CTR>
		                   <GETB ,P-INBUF <+ .BEG .CTR>>>
	         <SET CTR <+ .CTR 1>>
	         <COND (<EQUAL? .CTR .LEN>
			<RETURN>)>>
	 <PUTB ,AGAIN-LEXV .SLOT .DBEG>
	 <PUTB ,AGAIN-LEXV <- .SLOT 1> .LEN>
	 T>

;<SETG P-NUMBER -1>
<SETG P-EXCHANGE 0>
;<SETG P-DOLLAR-FLAG <>>
;<SETG P-SEAT-NUMBER -1>

<DEFINE NUMBER? (PTR:FIX "AUX" VAL TCHR BPTR CNT)
  <COND (<SET VAL <DO-NUMBER? .PTR>> .VAL)
	(T
	 <SET CNT <GETB <ZREST ,P-LEXV <* .PTR 2>> 2>>
	 <SET BPTR <GETB <ZREST ,P-LEXV <* .PTR 2>> 3>>
	 <SET TCHR <GETB ,P-INBUF <- .BPTR 1>>>
	 <PUTB ,P-INBUF <- .BPTR 1> .CNT>
	 <SET VAL <NEQ-TBL <ZREST <ZGET ,LICENSE-FORM <+ ,STREET-NAME 1>>
				  <- ,FIELD-DATA-OFFSET 1>>
			   <ZREST ,P-INBUF <- .BPTR 1>>>>
	 <PUTB ,P-INBUF <- .BPTR 1> .TCHR>
	 <COND (<NOT .VAL>
		<CHANGE-LEXV .PTR ,W?ZZSTREET>
		,W?ZZSTREET)
	       (T <>)>)>>

<DEFINE DO-NUMBER? NN (PTR:FIX "OPT" (CNT:FIX 0) "AUX"
		     BPTR:FIX CHR:FIX (SUM:FIX 0)
		    (TIM:<OR FIX FALSE> <>) (EXC <>) (DOLLAR <>) CCTR
		    (TMP <>) NW (SAVED-PTR .PTR) (MINUS? <>))
	 <COND (<0? .CNT>
		<SET CNT <GETB <ZREST ,P-LEXV <* .PTR 2>> 2>>
		<SET TMP T>)>
	 <SET BPTR <GETB <ZREST ,P-LEXV <* .PTR 2>> 3>>
	 <SET CHR <GETB ,P-INBUF <+ .BPTR .CNT -1>>>
	 <COND (<AND .TMP
		     <G=? .CNT 2>
		     <B-THRU-E? .CHR>
		     <OR <N==? <GETB ,P-INBUF <+ .BPTR .CNT -2>>
			       %<ASCII !\->>
			 <G=? .CNT 3>>>
		; "Handle case of seat number (13b, whatever). Pseudo handler
		   for seat will do the right thing with this. First make sure
		   it ends with a letter, and is long enough"
		<SET CNT <- .CNT 1>>
		<COND (<==? <GETB ,P-INBUF <+ .BPTR .CNT -1>>
			    %<ASCII !\->>
		       ; "kludge so 13-b works as well as 13b"
		       <SET CNT <- .CNT 1>>)>
		<COND (<==? <SET TMP <DO-NUMBER? .PTR .CNT>>
			    ,W?INTNUM>
		       ; "Got a real number before the seat letter, so
			  win."
		       <COND (<G=? .CHR %<ASCII !\a>>
			      <SET CHR <- .CHR %<ASCII !\b>>>)
			     (T
			      <SET CHR <- .CHR %<ASCII !\B>>>)>
		       ; "Get a code number for the seat..."
		       <SETG P-SEAT-NUMBER <+ <* <- ,P-NUMBER:FIX 1> 4> .CHR>>
		       <SETG P-NUMBER -1>
		       <RETURN ,W?INTNUM .NN>)
		      (T
		       ; "Lost, so just give up"
		       <RETURN <> .NN>)>)>
	 <REPEAT ()
		 <COND (<L? <SET CNT <- .CNT 1>> 0>
			<RETURN>)>
		 <SET CHR <GETB ,P-INBUF .BPTR>>
		 <COND (<==? .CHR %<ASCII !\#>> T)
		       (<EQUAL? .CHR %<ASCII !\:>>
			<COND (<T? .EXC>
			       <RETURN <> .NN>)>
			<SET TIM .SUM>
			<SET SUM 0>)
		       (<EQUAL? .CHR %<ASCII !\->>
			<COND (<T? .TIM>
			       <RETURN <> .NN>)>
			<SET MINUS? T>
			<SET EXC .SUM>
			<SET SUM 0>)
		       (<G? .SUM 9999>
			<RETURN <> .NN>)
		       (<EQUAL? .CHR %<ASCII !\$>>
			<SET DOLLAR T>)
		       (<AND <G? .CHR %<- <ASCII !\0> 1>>
			     <L? .CHR %<+ <ASCII !\9> 1>>>
			<SET SUM <+ <* .SUM 10> <- .CHR %<ASCII !\0>>>>)
		       (T
			<RETURN <> .NN>)>
		 <SET BPTR <+ .BPTR 1>>>
	 <CHANGE-LEXV .PTR ,W?INTNUM>
	 <COND (<G? ,P-LEN:FIX 1>
		<SET NW <ZGET ,P-LEXV <+ .PTR ,P-LEXELEN>>>)
	       (T
		<SET NW <>>)>
	 <COND (<AND <T? .DOLLAR>
		     <EQUAL? .NW ,W?PERIOD>
		     <G=? ,P-LEN:FIX 2>>
		<SET TMP <CENTS-CHECK <+ .PTR <* ,P-LEXELEN 2>>>>
		<COND (<T? .TMP>
		       <COND (<EQUAL? .TMP 100>
			      <SET TMP 0>)>
		       <SET SUM <+ <* 100 .SUM> .TMP>>
		       <SET CCTR <- ,P-LEN:FIX 2>>
		       <REPEAT ()
			 <COND (<L? <SET CCTR <- .CCTR 1>> 0>
				<SETG P-LEN <- ,P-LEN:FIX 2>>
				<PUTB ,P-LEXV ,P-LEXWORDS
				      <- <GETB ,P-LEXV ,P-LEXWORDS>:FIX
					 2>>
				<RETURN>)>
			 <SET PTR <+ .PTR ,P-LEXELEN>>
			 <CHANGE-LEXV .PTR
				      <ZGET ,P-LEXV <+ .PTR <* 2 ,P-LEXELEN>>>>
			 <PUTB ,P-LEXV <+ <* .PTR 2> 2>
			       <GETB ,P-LEXV
				     <+ <* <+ .PTR <* 2 ,P-LEXELEN>> 2> 2>>>
			 <PUTB ,P-LEXV <+ <* .PTR 2> 3>
			       <GETB ,P-LEXV
				     <+ <* <+ .PTR <* 2 ,P-LEXELEN>> 2> 3>>>>)
		      (ELSE <SET SUM <* .SUM 100>>)>)
	       (<T? .DOLLAR> <SET SUM <* .SUM 100>>)>
	 <COND (<EQUAL? .NW ,W?CENT ,W?CENTS>
		<SET DOLLAR T>)
	       (<INTBL? .NW <GETPT ,MONEY ,P?SYNONYM>
			</ <PTSIZE <GETPT ,MONEY ,P?SYNONYM>> 2>>
		; "Check synonyms from money object"
		<SET DOLLAR T>
		<SET SUM <* .SUM 100>>)>
	 <COND (<G? .SUM 9999>
		<RETURN <> .NN>)
	       (<T? .EXC>
		<SETG P-EXCHANGE .EXC>)
	       (<T? .TIM>
		<SETG P-EXCHANGE 0>
		<COND (<G? .TIM 23>
		       <RETURN <> .NN>)
		      (<G? .TIM 19>
		       T)
		      (<G? .TIM 12>
		       <RETURN <> .NN>)
		      (<G? .TIM  7>
		       T)
		      (T
		       <SET TIM <+ 12 .TIM>>)>
		<SET SUM <+ .SUM <* .TIM 60>>>)
	       (T
		<SETG P-EXCHANGE 0>)>
	 <COND (.MINUS?
		<RETURN <>>)>
	 <SETG P-DOLLAR-FLAG .DOLLAR>
	 <SETG P-NUMBER .SUM>
	 <COND (<AND <T? .DOLLAR>
		     <G? .SUM 0>>
		<CHANGE-LEXV .SAVED-PTR ,W?MONEY>
		,W?MONEY)
	       (T
		<SETG P-DOLLAR-FLAG <>>
		<SETG P-SEAT-NUMBER -1>
		,W?INTNUM)>>

<DEFINE B-THRU-E? (CHR:FIX)
	<COND (<AND <G=? .CHR %<ASCII !\B>> <L=? .CHR %<ASCII !\E>>>
	       T)
	      (<AND <G=? .CHR %<ASCII !\b>> <L=? .CHR %<ASCII !\e>>>
	       T)
	      (ELSE <>)>>

<DEFINE CENTS-CHECK CC (PTR:FIX "AUX" (CCTR 0) (SUM:FIX 0)
			CNT:FIX BPTR CHR:FIX)
	 <SET CNT <GETB <ZREST ,P-LEXV <* .PTR 2>> 2>>
	 <SET BPTR <GETB <ZREST ,P-LEXV <* .PTR 2>> 3>>
	 <REPEAT ()
		 <COND (<L? <SET CNT <- .CNT 1>> 0>
			<RETURN>)>
		 <SET CHR <GETB ,P-INBUF .BPTR>>
		 <COND (<G? <SET CCTR <+ .CCTR 1>> 2>
			<RETURN <> .CC>)>
		 <COND (<AND <L? .CHR 58>
			     <G? .CHR 47>>
			<SET SUM <+ <* .SUM 10> <- .CHR 48>>>)
		       (T
			<RETURN <> .CC>)>
		 <SET BPTR <+ .BPTR 1>>>
	 <COND (<ZERO? .SUM>
		100)
	       (<EQUAL? .CCTR 1>
		<* 10 .SUM>)
	       (T
		.SUM)>>

"New ORPHAN-MERGE."

;<SETG P-LASTADJ <>>

<DEFINE ORPHAN-VERB ("OPT" (WRD <>) (ACT <>))
	 <SETG P-WON <>>
	 <SETG P-CONT <>>
	 <COND (.WRD
		<ZPUT ,P-VTBL 0 .WRD>)>
	 <COND (.ACT
		<ZPUT ,P-OTBL ,P-VERB .ACT>)
	       (T
		<ZPUT ,P-OTBL ,P-VERB <ZGET ,P-ITBL ,P-VERB>>)>
	 <ZPUT ,P-OVTBL 0 <ZGET ,P-VTBL 0>>
	 <PUTB ,P-OVTBL 2 <GETB ,P-VTBL 2>>
	 <PUTB ,P-OVTBL 3 <GETB ,P-VTBL 3>>
	 <ZPUT ,P-OTBL ,P-VERBN ,P-VTBL>
	 <ZPUT ,P-OTBL ,P-PREP1 0>
	 <ZPUT ,P-OTBL ,P-PREP1N 0>
	 <ZPUT ,P-OTBL ,P-PREP2 0>
	 <ZPUT ,P-OTBL 5 0>
	 <ZPUT ,P-OTBL ,P-NC1 1>
	 <ZPUT ,P-OTBL ,P-NC1L 0>
	 <ZPUT ,P-OTBL ,P-NC2 0>
	 <ZPUT ,P-OTBL ,P-NC2L 0>
	 <SETG P-OFLAG T>>

<DEFINE ORPHAN-MERGE MERGE ("AUX" (CNT:FIX -1) TEMP VERB BEG END
			    (ADJ <>) WRD (WHICH 1))
   <SETG P-OFLAG <>>
   <SET WRD <ZGET <ZGET ,P-ITBL ,P-VERBN> 0>>
   <COND (<OR <EQUAL? <WT? .WRD ,PS?VERB ,P1?VERB> <ZGET ,P-OTBL ,P-VERB>>
	      <WT? .WRD ,PS?ADJECTIVE>>
	  <SET ADJ T>)
	 (<AND <WT? .WRD ,PS?OBJECT ,P1?OBJECT>
	       <ZERO? ,P-NCN>>
	  <ZPUT ,P-ITBL ,P-VERB 0>
	  <ZPUT ,P-ITBL ,P-VERBN 0>
	  <ZPUT ,P-ITBL ,P-NC1 <ZREST ,P-LEXV 2>>
	  <ZPUT ,P-ITBL ,P-NC1L <ZREST ,P-LEXV 6>>
	  <SETG P-NCN 1>)>
   <SET VERB <ZGET ,P-ITBL ,P-VERB>>
   <COND (<AND <T? .VERB>
	       <F? .ADJ>
	       <NOT <EQUAL? .VERB <ZGET ,P-OTBL ,P-VERB>>>>
	  <RETURN <> .MERGE>)
	 (<EQUAL? ,P-NCN 2>
	  <RETURN <> .MERGE>)
	 (<EQUAL? <ZGET ,P-OTBL ,P-NC1> 1>
	  <SET TEMP <ZGET ,P-ITBL ,P-PREP1>>
	  <COND (<EQUAL? .TEMP 0 <ZGET ,P-OTBL ,P-PREP1>>
		 <COND (<T? .ADJ>
			<ZPUT ,P-OTBL ,P-NC1 <ZREST ,P-LEXV 2>>
			<COND (<ZERO? <ZGET ,P-ITBL ,P-NC1L>>
			       <ZPUT ,P-ITBL ,P-NC1L <ZREST ,P-LEXV 6>>)>
			<COND (<ZERO? ,P-NCN>
			       <SETG P-NCN 1>)>)
		       (T
			<ZPUT ,P-OTBL ,P-NC1 <ZGET ,P-ITBL ,P-NC1>>
			;<ZPUT ,P-OTBL ,P-NC1L <ZGET ,P-ITBL ,P-NC1L>>)>
		 <ZPUT ,P-OTBL ,P-NC1L <ZGET ,P-ITBL ,P-NC1L>>)
		(T
		 <RETURN <> .MERGE>)>)
	 (<EQUAL? <ZGET ,P-OTBL ,P-NC2> 1>
	  <SET WHICH 2>
	  <SET TEMP <ZGET ,P-ITBL ,P-PREP1>>
	  <COND (<EQUAL? .TEMP 0 <ZGET ,P-OTBL ,P-PREP2>>
		 <COND (<T? .ADJ>
			<ZPUT ,P-ITBL ,P-NC1 <ZREST ,P-LEXV 2>>
			<COND (<ZERO? <ZGET ,P-ITBL ,P-NC1L>>
			       <ZPUT ,P-ITBL ,P-NC1L <ZREST ,P-LEXV 6>>)>)>
		 <ZPUT ,P-OTBL ,P-NC2 <ZGET ,P-ITBL ,P-NC1>>
		 <ZPUT ,P-OTBL ,P-NC2L <ZGET ,P-ITBL ,P-NC1L>>
		 <SETG P-NCN 2>)
		(T
		 <RETURN <> .MERGE>)>)
	 (<T? ,P-ACLAUSE>
	  <COND (<AND <NOT <EQUAL? ,P-NCN 1>>
		      <ZERO? .ADJ>>
		 <SETG P-ACLAUSE <>>
		 <RETURN <> .MERGE>)
		(T
		 <COND (<N==? ,P-ACLAUSE ,P-NC1> <SET WHICH 2>)>
		 <SET BEG <ZGET ,P-ITBL ,P-NC1>>
		 <COND (<T? .ADJ>
			<SET BEG <ZREST ,P-LEXV 2>>
			<SET ADJ <>>)>
		 <SET END <ZGET ,P-ITBL ,P-NC1L>>
		 <REPEAT ()
			 <SET WRD <ZGET .BEG 0>>
			 <COND (<EQUAL? .BEG .END>
				<COND (<T? .ADJ>
				       <CLAUSE-WIN .ADJ>
				       <RETURN>)
				      (T
				       <SETG P-ACLAUSE <>>
				       <RETURN <> .MERGE>)>)
			       (<OR <EQUAL? .WRD ,W?ALL ,W?ONE ,W?BOTH>
				    <AND <BTST <GETB .WRD ,P-PSOFF>
					       ,PS?ADJECTIVE> ;"same as WT?"
					 <ZERO? .ADJ>
				         <ADJ-CHECK .WRD .ADJ>>>
				<SET ADJ .WRD>)
			       (<EQUAL? .WRD ,W?ONE>
				<CLAUSE-WIN .ADJ>
				<RETURN>)
			       (<AND <BTST <GETB .WRD ,P-PSOFF> ,PS?OBJECT>
				     <EQUAL? <ZREST .BEG ,P-WORDLEN:FIX> .END>>
				<COND (<EQUAL? .WRD ,P-ANAM>
				       <CLAUSE-WIN .ADJ>)
				      (T
				       <CLAUSE-WIN>)>
				<RETURN>)>
			 <SET BEG <ZREST .BEG ,P-WORDLEN>>
			 <COND (<ZERO? .END>
				<SET END .BEG>
				<SETG P-NCN 1>
				<ZPUT ,P-ITBL ,P-NC1 <BACK .BEG 4>>
				<ZPUT ,P-ITBL ,P-NC1L .BEG>)>>)>)>
   <ZPUT ,P-VTBL 0 <ZGET ,P-OVTBL 0>>
   <PUTB ,P-VTBL 2 <GETB ,P-OVTBL 2>>
   <PUTB ,P-VTBL 3 <GETB ,P-OVTBL 3>>
   <ZPUT ,P-OTBL ,P-VERBN ,P-VTBL>
   <PUTB ,P-VTBL 2 0>
 ; <AND <NOT <EQUAL? <ZGET ,P-OTBL ,P-NC2> 0>>
	<SETG P-NCN 2>>
   <REPEAT ()
	   <COND (<G? <SET CNT <+ .CNT 1>> ,P-ITBLLEN:FIX>
		  <SETG P-MERGED .WHICH>
		  <RETURN T .MERGE>)
		 (T
		  <ZPUT ,P-ITBL .CNT <ZGET ,P-OTBL .CNT>>)>>>

<DEFINE ADJ-CHECK (WRD ADJ)
  <COND (<F? .ADJ> T)
	(<EQUAL? .ADJ ,W?OPEN ,W?OPENED ,W?CLOSED ,W?SHUT ,W?CREDIT
		 ,W?MY ,W?YOUR> T)
	(T <>)>>

<SETG P-LASTADJ <>>

<DEFINE CLAUSE-WIN ("OPTIONAL" (ADJ <>))
	<COND (<T? .ADJ>
	       <SETG P-LASTADJ .ADJ>
	       <ZPUT ,P-ITBL ,P-VERB <ZGET ,P-OTBL ,P-VERB>>)
	      (T
	       <SET ADJ T>)>
      <CLAUSE-COPY ,P-OTBL ,P-OTBL ,P-ACLAUSE <+ ,P-ACLAUSE:FIX 1>
		   <COND (<EQUAL? ,P-ACLAUSE ,P-NC1> ,P-OCL1)
			 (ELSE ,P-OCL2)> .ADJ>
      <COND (<NOT <EQUAL? <ZGET ,P-OTBL ,P-NC2> 0>>
	     <SETG P-NCN 2>)>
      <SETG P-ACLAUSE <>>
      T>

"Print undefined word in input. PTR points to the unknown word in P-LEXV"

<DEFINE WORD-PRINT (CNT:FIX BUF:FIX)
	 <REPEAT ()
		 <COND (<L? <SET CNT <- .CNT 1>> 0>
			<RETURN>)
		       (T
			<PRINTC <GETB ,P-INBUF .BUF>>
			<SET BUF <+ .BUF 1>>)>>>

<CONSTANT UNKNOWN-MSGS
        <PLTABLE
	 <PTABLE "You must have special permission to use the word "
		 "\" in this story.">
	 <PTABLE "The word "
		 "\" hasn't been approved for use in this story.">
	 <PTABLE "This story isn't allowed to recognise the word "
		 ".\"">>>

<DEFINE UNKNOWN-WORD (PTR:FIX "AUX" BUF MSG)
	<ZPUT ,OOPS-TABLE ,O-PTR .PTR>
	<SET MSG <PICK-ONE ,UNKNOWN-MSGS>>
	<TELL "[" <ZGET .MSG 0> "\"">
	<WORD-PRINT <GETB <ZREST ,P-LEXV <SET BUF <* .PTR 2>>> 2>
		    <GETB <ZREST ,P-LEXV .BUF> 3>>
	<SETG QUOTE-FLAG <>>
	<SETG P-OFLAG <>>
	<TELL <ZGET .MSG 1> "]" CR>>

" Perform syntax matching operations, using P-ITBL as the source of
   the verb and adjectives for this input. Returns false if no
   syntax matches, and does it's own orphaning. If return is true,
   the syntax is saved in P-SYNTAX."

<SETG P-SLOCBITS 0>

<DEFINE SYNTAX-CHECK CHECK ("OPT" (NOGWIM? <>)
			    "AUX" SYN LEN:FIX NUM:FIX OBJ
			    (DRIVE1 <>) (DRIVE2 <>)
			     PREP VERB)
	<SET VERB <ZGET ,P-ITBL ,P-VERB>>
	<COND (<ZERO? .VERB>
	       <NOT-IN-SENTENCE "any verbs">
	       <RETURN <> .CHECK>)>
	<SET SYN <ZGET ,VERBS <- 255 .VERB>>>
	<SET LEN <GETB .SYN 0>>
	<SET SYN <ZREST .SYN>>
	<REPEAT ()
		<SET NUM <BAND <GETB .SYN ,P-SBITS> ,P-SONUMS>>
		<COND (<G? ,P-NCN:FIX .NUM>
		       T) ;"Added 4/27/83"
		      (<AND <NOT <L? .NUM 1>>
			    <ZERO? ,P-NCN>
			    <OR <ZERO? <SET PREP <ZGET ,P-ITBL ,P-PREP1>>>
				<EQUAL? .PREP <GETB .SYN ,P-SPREP1>>>>
		       <SET DRIVE1 .SYN>)
		      (<EQUAL? <GETB .SYN ,P-SPREP1> <ZGET ,P-ITBL ,P-PREP1>>
		       <COND (<AND <EQUAL? .NUM 2>
				   <EQUAL? ,P-NCN 1>>
			      <SET DRIVE2 .SYN>)
			     (<EQUAL? <GETB .SYN ,P-SPREP2>
				      <ZGET ,P-ITBL ,P-PREP2>>
			      <SYNTAX-FOUND .SYN>
			      <RETURN T .CHECK>)>)>
		<COND (<L? <SET LEN <- .LEN 1>> 1>
		       <COND (<OR <T? .DRIVE1>
				  <T? .DRIVE2>>
			      <RETURN>)
			     (T
			      <DONT-UNDERSTAND>
			      <RETURN <> .CHECK>)>)
		      (T
		       <SET SYN <ZREST .SYN ,P-SYNLEN>>)>>
	<COND (<AND <F? .NOGWIM?>
		    <T? .DRIVE1>
		    <SET OBJ
			 <GWIM <GETB .DRIVE1 ,P-SFWIM1>
			       <GETB .DRIVE1 ,P-SLOC1>
			       <GETB .DRIVE1 ,P-SPREP1>>>>
	       <COND (<G? <BAND <GETB .DRIVE1 ,P-SBITS> ,P-SONUMS> 1>
		      ; "Found first object, but need second"
		      <RETURN
		       <FAKE-VERB/NOUN ,P-PRSA-WORD
				      <COND (<GETB .DRIVE1 ,P-SPREP1>
					     <PREP-FIND
					      <GETB .DRIVE1 ,P-SPREP1>>)
					    (T <>)>
				      <COND (<GETPT .OBJ ,P?ADJECTIVE>
					     <ZGET <GETPT .OBJ ,P?ADJECTIVE>
						   0>)>
				      <ZGET <GETPT .OBJ ,P?SYNONYM> 0>>
		       .CHECK>)>
	       <ZPUT ,P-PRSO ,P-MATCHLEN 1>
	       <ZPUT ,P-PRSO 1 .OBJ>
	       <SYNTAX-FOUND .DRIVE1>)
	      (<AND <F? .NOGWIM?>
		    <T? .DRIVE2>
		    <SET OBJ
			 <GWIM <GETB .DRIVE2 ,P-SFWIM2>
			       <GETB .DRIVE2 ,P-SLOC2>
			       <GETB .DRIVE2 ,P-SPREP2>>>>
	       <ZPUT ,P-PRSI ,P-MATCHLEN 1>
	       <ZPUT ,P-PRSI 1 .OBJ>
	       <SYNTAX-FOUND .DRIVE2>)
	      (<EQUAL? .VERB ,ACT?FIND ; ,ACT?WHAT>
	       <TELL "You'll have to do that yourself." CR>
	       <>)
	      (T
	       <COND (<EQUAL? ,WINNER ,PLAYER>
		      <ORPHAN .DRIVE1 .DRIVE2>
		      <TELL "[Wh">)
		     (T
		      <TELL
"[Your command wasn't complete. Next time, type wh">)>
	       <COND (<EQUAL? .VERB ,ACT?WALK ,ACT?GO>
		      <TELL "ere">)
		     (<OR <AND <T? .DRIVE1>
			       <EQUAL? <GETB .DRIVE1 ,P-SFWIM1> ,PERSON>>
			  <AND <T? .DRIVE2>
			       <EQUAL? <GETB .DRIVE2 ,P-SFWIM2> ,PERSON>>>
		      <TELL "om">)
		     (T
		      <TELL "at">)>
	       <COND (<EQUAL? ,WINNER ,PLAYER>
		      <TELL " do you want to ">)
		     (T
		      <TELL " you want " THE ,WINNER " to ">)>
	       <VERB-PRINT>
	       <COND (<T? .DRIVE2>
		      <CLAUSE-PRINT ,P-NC1 ,P-NC1L>)>
	       <SETG P-END-ON-PREP <>>
	       <PREP-PRINT <COND (<T? .DRIVE1>
				  <GETB .DRIVE1 ,P-SPREP1>)
				 (T
				  <GETB .DRIVE2 ,P-SPREP2>)>>
	       <COND (<EQUAL? ,WINNER ,PLAYER>
		      <SETG P-OFLAG T>
		      <TELL "?]" CR>)
		     (T
		      <SETG P-OFLAG <>>
		      <TELL ".]" CR>)>
	       <>)>>

<DEFINE VERB-PRINT ("AUX" TMP)
	<SET TMP <ZGET ,P-ITBL ,P-VERBN>>	;"? ,P-OTBL?"
	<COND (<ZERO? .TMP>
	       <TELL "tell">)
	      (<ZERO? <GETB ,P-VTBL 2>>
	       <TELL WORD <ZGET .TMP 0>>)
	      (T
	       <WORD-PRINT <GETB .TMP 2> <GETB .TMP 3>>
	       <PUTB ,P-VTBL 2 0>)>>

<DEFINE ORPHAN (D1 D2 "AUX" (CNT:FIX -1))
	<COND (<ZERO? ,P-MERGED>
	       <ZPUT ,P-OCL1 ,P-MATCHLEN 0>
	       <ZPUT ,P-OCL2 ,P-MATCHLEN 0>)>
	<ZPUT ,P-OVTBL 0 <ZGET ,P-VTBL 0>>
	<PUTB ,P-OVTBL 2 <GETB ,P-VTBL 2>>
	<PUTB ,P-OVTBL 3 <GETB ,P-VTBL 3>>
	<REPEAT ()
		<COND (<G? <SET CNT <+ .CNT 1>> ,P-ITBLLEN:FIX>
		       <RETURN>)
		      (T
		       <ZPUT ,P-OTBL .CNT <ZGET ,P-ITBL .CNT>>)>>
	<COND (<EQUAL? ,P-NCN 2>
	       <CLAUSE-COPY ,P-ITBL ,P-OTBL
			    ,P-NC2 ,P-NC2L ,P-OCL2 ; ,P-NC2 ; ,P-NC2L>)>
	<COND (<NOT <L? ,P-NCN:FIX 1>>
	       <CLAUSE-COPY ,P-ITBL ,P-OTBL
			    ,P-NC1 ,P-NC1L ,P-OCL1 ; ,P-NC1 ; ,P-NC1L>)>
	<COND (<T? .D1>
	       <ZPUT ,P-OTBL ,P-PREP1 <GETB .D1 ,P-SPREP1>>
	       <ZPUT ,P-OTBL ,P-NC1 1>)
	      (<T? .D2>
	       <ZPUT ,P-OTBL ,P-PREP2 <GETB .D2 ,P-SPREP2>>
	       <ZPUT ,P-OTBL ,P-NC2 1>)>>

<DEFINE CLAUSE-PRINT (BPTR EPTR "OPTIONAL" (THE? T))
	<COND (<F? <BUFFER-PRINT <ZGET ,P-ITBL .BPTR> <ZGET ,P-ITBL .EPTR>
				 .THE?>>
	       <TELL "that">)>>

<DEFINE BUFFER-PRINT (BEG END CP "AUX" (NOSP <>) WRD (FIRST?? T) (PN <>)
		      (SOMETHING? <>))
	 <REPEAT ()
		<COND (<EQUAL? .BEG .END>
		       <RETURN>)
		      (T
		       <COND (<T? .NOSP>
			      <SET NOSP <>>)
			     (T
			      <TELL " ">)>
		       <SET WRD <ZGET .BEG 0>>
		       <COND (<OR <AND <EQUAL? .WRD ,W?HIM>
				       <NOT <VISIBLE? ,P-HIM-OBJECT>>>
				  <AND <EQUAL? .WRD ,W?HER>
				       <NOT <VISIBLE? ,P-HER-OBJECT>>>
				  <AND <EQUAL? .WRD ,W?THEM>
				       <NOT <VISIBLE? ,P-THEM-OBJECT>>>>
			      <SET PN T>)>
		       <COND (<EQUAL? .WRD ,W?PERIOD>
			      <SET NOSP T>)
			     (<AND <OR <WT? .WRD ,PS?BUZZ-WORD>
				       <WT? .WRD ,PS?PREPOSITION>>
				   <NOT <WT? .WRD ,PS?ADJECTIVE>>
				   <NOT <WT? .WRD ,PS?OBJECT>>>
			      <SET NOSP T>)
			     (<EQUAL? .WRD ,W?ME>
			      <TELL D ,PLAYER>
			      <SET SOMETHING? T>
			      <SET PN T>)
			     (<INTBL? .WRD <ZREST ,CAPS 2> <ZGET ,CAPS 0>>
			    ; <NAME? .WRD>
			      <CAPITALIZE .BEG>
			      <SET SOMETHING? T>
			      <SET PN T>)
			     (T
			      <SET SOMETHING? T>
			      <COND (<AND <T? .FIRST??>
					  <ZERO? .PN>
					  <T? .CP>>
				     <TELL "the ">)>
			      <COND (<==? .WRD ,W?INTNUM>
				     <COND (<AND <==? ,P-NUMBER -1>
						 <G=? ,P-SEAT-NUMBER:FIX 0>>
					    <TELL N <+ </ ,P-SEAT-NUMBER:FIX 4>
						       1>
						  CHAR
						  <GETB ,SEAT-LETTERS
							<MOD
							 ,P-SEAT-NUMBER:FIX
							 4>>>)
					   (T
					    <TELL N ,P-NUMBER>)>)
				    (<OR <T? ,P-OFLAG>
					 <T? ,P-MERGED>>
				     <TELL WORD .WRD>)
				    (<AND <EQUAL? .WRD ,W?IT>
					  <VISIBLE? ,P-IT-OBJECT>>
				     <TELL D ,P-IT-OBJECT>)
				    (<AND <EQUAL? .WRD ,W?HER>
					  <ZERO? .PN>>
				     <TELL D ,P-HER-OBJECT>)
				    (<AND <EQUAL? .WRD ,W?THEM>
					  <ZERO? .PN>>
				     <TELL D ,P-THEM-OBJECT>)
				    (<AND <EQUAL? .WRD ,W?HIM>
					  <ZERO? .PN>>
				     <TELL D ,P-HIM-OBJECT>)
				    (T
				     <WORD-PRINT <GETB .BEG 2>
						 <GETB .BEG 3>>)>
			      <SET FIRST?? <>>)>)>
		<SET BEG <ZREST .BEG ,P-WORDLEN>>>
	 .SOMETHING?>

"List of words to be capitalised."

<CONSTANT CAPS
       <PLTABLE <VOC "ACCIDENT" <>>
<VOC "AEROTICA" <>>
<VOC "AGONY" <>>
<VOC "AIR" <>>
<VOC "AIRLINES" <>>
<VOC "AIRWAYS" <>>
<VOC "AMERICA" <>>
<VOC "AMERICAN" <>>
<VOC "AVIATION" <>>
<VOC "LOW" <>>
<VOC "CEILING" <>>
<VOC "BOING" <>>
<VOC "BOINGJETS" <>>
<VOC "BONGO" NOUN>
<VOC "BOXCAR" <>>
<VOC "BOYSENBERRY" <>>
<VOC "BREAKFAST" <>>
<VOC "BRITISH" <>>
<VOC "CALIFORNIA" <>>
<VOC "CLINT" NOUN>
<VOC "CONTINENTAL" <>>
<VOC "DISTRESS" <>>
<VOC "DOCTOR" <>>
<VOC "DR" <>>
<VOC "E" <>>
<VOC "FIDUCIARY" <>>
<VOC "FILLMORE" <>>
<VOC "FLYING" <>>
<VOC "FOSTER" <>>
<VOC "FRED" <>>
<VOC "FRED'S" <>>
<VOC "FREDS" <>>
<VOC "FRENCH" <>>
<VOC "FROG" <>>
<VOC "FRONTLINE" <>>
<VOC "GALAXY" <>>
<VOC "GALLIA" <>>
<VOC "GAMMA" <>>
<VOC "GENERAL" <>>
<VOC "GERMAN" <>>
<VOC "I" <>>
<VOC "ITALIAN" <>>
<VOC "JETS" <>>
<VOC "KIRIN" <>>
<VOC "KIWI" <>>
<VOC "KIWIAIR" <>>
<VOC "LAPHROIG" <>>
<VOC "LLAMEX" <>>
<VOC "LLAMEX\(R\)" <>>
<VOC "MASSIVE" <>>
<VOC "MISS" <>>
<VOC "MOOSEHEAD" <>>
<VOC "MR" ADJ>
<VOC "MRS" ADJ>
<VOC "N" <>>
<VOC "NANCY" NOUN>
<VOC "NEW" <>>
<VOC "NEWZORK" <>>
<VOC "NOCTURNAL" <>>
<VOC "NORTH" <>>
<VOC "NORTHWEST" <>>
<VOC "NORTHWEST" <>>
<VOC "OMNIA" <>>
<VOC "PAN" <>>
<VOC "PAULETTE" NOUN>
<VOC "PEOPLE'S" <>>
<VOC "PEOPLES" <>>
<VOC "PONGO" NOUN>
<VOC "QUANTUM" <>>
<VOC "ROGER" NOUN>
<VOC "S" <>>
<VOC "SWISS" <>>
<VOC "TICKOFF" <>>
<VOC "TRANS" <>>
<VOC "TRANS-GALAXY" <>>
<VOC "TRUST" <>>
<VOC "UNDEROCEAN" <>>
<VOC "UNIVERSAL" <>>
<VOC "UNTIED" <>>
<VOC "W" <>>
<VOC "WEST" <>>
<VOC "WORST" <>>
<VOC "WORSTED" <>>
<VOC "ZALAGASA" <>>
<VOC "ZALAGASAN" <>>
<VOC "ZORK" <>>
>>

<DEFINE CAPITALIZE (PTR:FIX)
	 <COND (<OR <T? ,P-OFLAG>
		    <T? ,P-MERGED>>
		<TELL WORD <ZGET .PTR 0>>)
	       (T
		<PRINTC <- <GETB ,P-INBUF <GETB .PTR 3>>:FIX 32>>
		<WORD-PRINT <- <GETB .PTR 2>:FIX 1> <+ <GETB .PTR 3>:FIX 1>>)>>

<DEFINE PREP-PRINT (PREP "OPTIONAL" (SP? T) "AUX" WRD)
	<COND (<AND <T? .PREP>
		    <ZERO? ,P-END-ON-PREP>>
	       <COND (<T? .SP?>
		      <TELL " ">)>
	       <SET WRD <PREP-FIND .PREP>>
	       <TELL WORD .WRD>
	       <COND (<AND <EQUAL? ,W?SIT <ZGET <ZGET ,P-ITBL ,P-VERBN> 0>>
			   <EQUAL? ,W?DOWN .WRD>>
		      <TELL " on">)>
	       <COND (<AND <EQUAL? ,W?GET <ZGET <ZGET ,P-ITBL ,P-VERBN> 0>>
			   <EQUAL? ,W?OUT .WRD>> ; "Will it ever work? --SWG"
		      <TELL " of">)>
	       T)>>

"Pointers used by CLAUSE-COPY (source/destination beginning/end pointers)."

<DEFINE CLAUSE-COPY (SRC DEST BB EE OCL "OPT" (INSRT <>)
		      "AUX" BEG END OBEG:FIX CNT:FIX B E (FLG <>))
	<SET BEG <ZGET .SRC .BB>>
	<SET END <ZGET .SRC .EE>>
	<SET OBEG <ZGET .OCL ,P-MATCHLEN>>
	<COND
	 (<AND <==? .BEG <ZREST .OCL 2>>
	       .INSRT>
	  <SET OBEG 0>
	  <SET FLG T>)>
	<REPEAT ()
		<COND (<EQUAL? .BEG .END> <RETURN>)>
		<COND (<AND .INSRT
			    <EQUAL? ,P-ANAM <ZGET .BEG 0>>>
		       ; "Place to do insert?"
		       <SET B <ZGET ,P-ITBL ,P-NC1>>
		       <SET E <ZGET ,P-ITBL ,P-NC1L>>
		       <COND (<T? .FLG>
			      ; "Is this a normal case?"
			      <PROG ()
			        <SET CNT 0>
				; "Find out how many spaces to make"
				<COND (<==? .INSRT T>
				       ; "Replacing name, so n-1"
				       <ZPUT .BEG 0 <ZGET .B 0>>
				       <ZPUT .BEG 1 0>
				       ; "Do the first one"
				       <SET B <ZREST .B ,P-WORDLEN>>
				       <REPEAT ()
				         <COND (<==? .B .E> <RETURN>)>
					 <SET B <ZREST .B ,P-WORDLEN>>
					 <SET CNT <+ .CNT 1>>>)
				      (T
				       <SET CNT 1>)>
				<COND
				 (<G? .CNT 0>
				  ; "Still stuff left to put in"
				  <ZPUT .OCL ,P-MATCHLEN
				      <+ <ZGET .OCL ,P-MATCHLEN>
					 <* 2 .CNT>>>
				  <COND
				   (<AND <N==? .BEG .END>
					 <N==? <ZREST .BEG ,P-WORDLEN> .END>>
				    <SET B <ZBACK .END ,P-WORDLEN>>
				    <SET E <ZREST .END <* <- .CNT 1>
							  ,P-WORDLEN>>>
				    ; "Make the space"
				    <REPEAT ()
				       <ZPUT .E 0 <ZGET .B 0>>
				       <ZPUT .E 1 <ZGET .B 1>>
				       <COND (<==? .B .BEG> <RETURN>)>
				       <SET B <ZBACK .B ,P-WORDLEN>>
				       <SET E <ZBACK .E ,P-WORDLEN>>
				       <COND (<==? .B .BEG> <RETURN>)>>)>
				  <SET END <ZREST .END <* .CNT ,P-WORDLEN>>>
				  <SET B <ZGET ,P-ITBL ,P-NC1>>
				  <SET E <ZGET ,P-ITBL ,P-NC1L>>
				  ; "And fill it up"
				  <COND (<==? .INSRT T>
					 <SET B <ZREST .B ,P-WORDLEN>>
					 <SET BEG <ZREST .BEG ,P-WORDLEN>>
					 <REPEAT ()
					    <COND (<==? .B .E> <RETURN>)>
					    <ZPUT .BEG 0 <ZGET .B 0>>
					    <ZPUT .BEG 1 0>
					    <SET B <ZREST .B ,P-WORDLEN>>
					    <SET BEG <ZREST .BEG ,P-WORDLEN>>>)
					(T
					 <ZPUT .BEG ,P-LEXELEN
					       ,P-ANAM>
					 <ZPUT .BEG <+ ,P-LEXELEN 1> 0>
					 <ZPUT .BEG 0 .INSRT>
					 <ZPUT .BEG 1 0>)>)>>
			      <RETURN>)
			     (<EQUAL? .INSRT T>
			      ; "Other case, here just add the new word"
			      <REPEAT ()
				      <COND (<EQUAL? .B .E> <RETURN>)>
				      <CLAUSE-ADD <ZGET .B 0> .OCL>
				      <SET B <ZREST .B ,P-WORDLEN>>>)
			     (ELSE
			      ; "Add the new word and the name..."
			      <COND (<NOT <EQUAL? .INSRT <ZGET .OCL 1>>>
				     <CLAUSE-ADD .INSRT .OCL>)>
			      <CLAUSE-ADD ,P-ANAM .OCL>)>)
		      (<F? .FLG>
		       <CLAUSE-ADD <ZGET .BEG 0> .OCL>)>
		<SET BEG <ZREST .BEG ,P-WORDLEN>>>
	<COND (<AND ;<EQUAL? .SRC .DEST>
		    <F? .FLG>
		    <G? .OBEG 0>
		    <SET CNT <- <ZGET .OCL ,P-MATCHLEN> .OBEG>>>
	       <ZPUT .OCL ,P-MATCHLEN 0>
	       <SET OBEG <+ .OBEG 1>>
	       <REPEAT ()
		       <CLAUSE-ADD <ZGET .OCL .OBEG> .OCL>
		       <COND (<ZERO? <SET CNT <- .CNT 2>>>
			      <RETURN>)>
		       <SET OBEG <+ .OBEG 2>>>
	       <SET OBEG 0>)>
	<ZPUT .DEST
	     .BB
	     <ZREST .OCL <+ <* .OBEG ,P-LEXELEN:FIX> 2>>>
	<ZPUT .DEST
	     .EE
	     <ZREST .OCL
		   <+ <* <ZGET .OCL ,P-MATCHLEN>:FIX ,P-LEXELEN:FIX> 2>>>>

<DEFINE CLAUSE-ADD (WRD TBL "AUX" PTR:FIX)
	<SET PTR <+ <ZGET .TBL ,P-MATCHLEN> 2>>
	<ZPUT .TBL <- .PTR 1> .WRD>
	<ZPUT .TBL .PTR 0>
	<ZPUT .TBL ,P-MATCHLEN .PTR>>

<DEFINE PREP-FIND FIND (PREP "AUX" (CNT:FIX 0) SIZE:FIX
			(PREPS:<PRIMTYPE TABLE> ,PREPOSITIONS))
	<SET SIZE <* <ZGET .PREPS 0> 2>>
	<REPEAT ()
		<COND (<G? <SET CNT <+ .CNT 1>> .SIZE>
		       <RETURN <> .FIND>)
		      (<EQUAL? <ZGET .PREPS .CNT> .PREP>
		       <RETURN <ZGET .PREPS <- .CNT 1>> .FIND>)>>>

<DEFINE SYNTAX-FOUND (SYN)
	<SETG P-SYNTAX .SYN>
	<SETG PRSA <GETB .SYN ,P-SACTION>>>

<SETG P-GWIMBIT 0>

<DEFINE GWIM (GBIT LBIT PREP "AUX" OBJ)
	<COND (<EQUAL? .GBIT ,LOCATION>
	       ,ROOMS)
	      (<AND <T? ,P-IT-OBJECT>
		    <IS? ,P-IT-OBJECT .GBIT>
		    <N==? ,P-IT-OBJECT ,NOT-HERE-OBJECT>>
	       <TELL "[">
	       <COND (<PREP-PRINT .PREP <>>
		      <SPACE>)>
	       <TELL THE ,P-IT-OBJECT ,BRACKET>
	       ,P-IT-OBJECT)
	      (T
	       <SETG P-GWIMBIT .GBIT>
	       <SETG P-SLOCBITS .LBIT>
	       <ZPUT ,P-MERGE ,P-MATCHLEN 0>
	       <COND (<GET-OBJECT ,P-MERGE <>>
		      <SETG P-GWIMBIT 0>
		      <COND (<EQUAL? <ZGET ,P-MERGE ,P-MATCHLEN> 1>
			     <SET OBJ <ZGET ,P-MERGE 1>>
			     <COND (<AND <EQUAL? ,WINNER ,PLAYER>
					 <NOT <EQUAL? .OBJ ,HANDS>>>
				    <TELL "[">
				    <COND (<PREP-PRINT .PREP <>>
					   <SPACE>)>
				    <TELL THE .OBJ ,BRACKET>)>
			     .OBJ)>)
		     (T
		      <SETG P-GWIMBIT 0>
		      <>)>)>>

<DEFINE SNARF-OBJECTS SNARF ("AUX" PTR)
	<COND (<T? <SET PTR <ZGET ,P-ITBL ,P-NC2>>>
	       ; "second noun clause?"
	       <SETG P-PHR 1>
	       <SETG P-SLOCBITS <GETB ,P-SYNTAX ,P-SLOC2>>
	       <COND (<F? <SNARFEM .PTR <ZGET ,P-ITBL ,P-NC2L> ,P-PRSI>>
		      ; "Try to find objects"
		      <RETURN <> .SNARF>)>)>
	<COND (<T? <SET PTR <ZGET ,P-ITBL ,P-NC1>>>
	       ; "1st noun clause"
	       <SETG P-PHR 0>
	       <SETG P-SLOCBITS <GETB ,P-SYNTAX ,P-SLOC1>>
	       <COND (<F? <SNARFEM .PTR <ZGET ,P-ITBL ,P-NC1L> ,P-PRSO>>
		      ; "Win if found objects..."
		      <RETURN <> .SNARF>)>)>
	<COND (<T? <ZGET ,P-BUTS ,P-MATCHLEN>>
	       <COND (<G? <ZGET ,P-PRSO ,P-MATCHLEN> 1>
		      <SETG P-PRSO <BUT-MERGE ,P-PRSO>>)
		     (T
		      <SETG P-PRSI <BUT-MERGE ,P-PRSI>>)>)>
	T>

<DEFINE BUT-MERGE (TBL "AUX" LEN:FIX BUTLEN:FIX (CNT:FIX 1)
		   (MATCHES:FIX 0) OBJ NTBL)
	<SET LEN <ZGET .TBL ,P-MATCHLEN>>
	<ZPUT ,P-MERGE ,P-MATCHLEN 0>
	<REPEAT ()
		 <COND (<L? <SET LEN <- .LEN 1>> 0>
		        <RETURN>)>
		 <SET OBJ <ZGET .TBL .CNT>>
		 <COND (<INTBL? .OBJ <ZREST ,P-BUTS 2> <ZGET ,P-BUTS 0>>
		      ; <ZMEMQ <SET OBJ <ZGET .TBL .CNT>> ,P-BUTS>
		        T)
		       (T
		        <ZPUT ,P-MERGE <+ .MATCHES 1> .OBJ>
		        <SET MATCHES <+ .MATCHES 1>>)>
		<SET CNT <+ .CNT 1>>>
	<ZPUT ,P-MERGE ,P-MATCHLEN .MATCHES>
	<SET NTBL ,P-MERGE>
	<SETG P-MERGE .TBL>
	.NTBL>

<DEFINE SNARFEM SNARFEM (PTR EPTR TBL
			 "AUX" (BUT <>) LEN WV WRD NW (WAS-ALL? <>) ONEOBJ)
   ;"Next SETG 6/21/84 for WHICH retrofix"
   <SETG P-AND <>>
   <COND (<EQUAL? ,P-GETFLAGS ,P-ALL>
	  <SET WAS-ALL? T>)>
   <SETG P-GETFLAGS 0>
   <ZPUT ,P-BUTS ,P-MATCHLEN 0>
   <ZPUT .TBL ,P-MATCHLEN 0>
   <SET WRD <ZGET .PTR 0>>
   <REPEAT ()
	   <COND (<EQUAL? .PTR .EPTR>
		  <SET WV <GET-OBJECT <OR .BUT .TBL>>>
		  <COND (<T? .WAS-ALL?>
			 <SETG P-GETFLAGS ,P-ALL>)>
		  <RETURN .WV .SNARFEM>)
		 (T
		  <COND (<==? .EPTR <ZREST .PTR ,P-WORDLEN>>
			 <SET NW 0>)
			(T <SET NW <ZGET .PTR ,P-LEXELEN>>)>
		  <COND (<EQUAL? .WRD ,W?ALL ,W?BOTH ,W?EVERYTHING>
			 <SETG P-GETFLAGS ,P-ALL>
			 <COND (<EQUAL? .NW ,W?OF>
				<SET PTR <ZREST .PTR ,P-WORDLEN>>)>)
			(<EQUAL? .WRD ,W?BUT ,W?EXCEPT>
			 <OR <GET-OBJECT <OR .BUT .TBL>>
			     <RETURN <> .SNARFEM>>
			 <SET BUT ,P-BUTS>
			 <ZPUT .BUT ,P-MATCHLEN 0>)
			(<AND <T? .WRD>
			      <F? <SET WRD <NOT-BUZZER-WORD? .WRD -1>>>>
			 <RETURN <> .SNARFEM>)
			(<EQUAL? .WRD ,W?A ; ,W?ONE>
			 <COND (<ZERO? ,P-ADJ>
				<SETG P-GETFLAGS ,P-ONE>
				<COND (<EQUAL? .NW ,W?OF>
				       <SET PTR <ZREST .PTR ,P-WORDLEN>>)>)
			       (T
				<SETG P-NAM .ONEOBJ>
				<OR <GET-OBJECT <OR .BUT .TBL>>
				    <RETURN <> .SNARFEM>>
				<AND <ZERO? .NW>
				     <RETURN T .SNARFEM>>)>)
			(<AND <EQUAL? .WRD ,W?AND ,W?COMMA>
			      <NOT <EQUAL? .NW ,W?AND ,W?COMMA>>>
			 ;"Next SETG 6/21/84 for WHICH retrofix"
			 <SETG P-AND T>
			 <OR <GET-OBJECT <OR .BUT .TBL>>
			     <RETURN <> .SNARFEM>>
			 T)
			(<WT? .WRD ,PS?BUZZ-WORD>)
			(<EQUAL? .WRD ,W?AND ,W?COMMA>)
			(<EQUAL? .WRD ,W?OF>
			 <COND (<ZERO? ,P-GETFLAGS>
				<SETG P-GETFLAGS ,P-INHIBIT>)>)
			(<AND <WT? .WRD ,PS?ADJECTIVE>
			      <ADJ-CHECK .WRD ,P-ADJ>
			      <NOT <EQUAL? .NW ,W?OF>>> ; "FIX #41"
			 <SETG P-ADJ .WRD>)
			(<WT? .WRD ,PS?OBJECT ;,P1?OBJECT>
			 <SETG P-NAM .WRD>
			 <SET ONEOBJ .WRD>)>)>
	   <COND (<NOT <EQUAL? .PTR .EPTR>>
		  <SET PTR <ZREST .PTR ,P-WORDLEN>>
		  <SET WRD .NW>)>>>

<DEFINE GET-OBJECT GET (TBL
		    "OPTIONAL" (VRB T)
		    "AUX" BTS LEN:FIX XBITS TLEN:FIX (GCHECK <>)
		          (OLEN:FIX 0) OBJ ADJ X XTBL)
 <SET XBITS ,P-SLOCBITS>
 <SET TLEN <ZGET .TBL ,P-MATCHLEN>>
;<COND (<T? ,DEBUG?>
	<TELL "[GETOBJ: TLEN=" N .TLEN "]" CR>)>
 <COND (<BTST ,P-GETFLAGS ,P-INHIBIT>
	<RETURN T .GET>)>
 <SET ADJ ,P-ADJ>
 <COND (<AND <ZERO? ,P-NAM>
	     <T? ,P-ADJ>>
	<COND (<WT? ,P-ADJ ,PS?OBJECT>
	       <SETG P-NAM ,P-ADJ>
	       <SETG P-ADJ <>>)
	      (<SET BTS <WT? ,P-ADJ ,PS?DIRECTION ,P1?DIRECTION>>
	       <SETG P-ADJ <>>
	       <ZPUT .TBL ,P-MATCHLEN 1>
	       <ZPUT .TBL 1 ,INTDIR>
	       <SETG P-DIRECTION .BTS>
	       <RETURN T .GET>)>)>
 <COND (<AND <ZERO? ,P-NAM>
	     <ZERO? ,P-ADJ>
	     <NOT <EQUAL? ,P-GETFLAGS ,P-ALL>>
	     <ZERO? ,P-GWIMBIT>>
	<COND (<T? .VRB>
	       <NOT-IN-SENTENCE "enough nouns">)>
	<RETURN <> .GET>)>
 <COND (<OR <NOT <EQUAL? ,P-GETFLAGS ,P-ALL>>
	    <ZERO? ,P-SLOCBITS>>
	<SETG P-SLOCBITS -1>)>
 <SETG P-TABLE .TBL>
 <PROG (TOBJ TTBL (WT? <>))
  ;<COND (<T? ,DEBUG?>
	  <TELL "[GETOBJ: GCHECK=" N .GCHECK "]" CR>)>
  <COND (<T? .GCHECK>
       ; <COND (<T? ,DEBUG?>
		<TELL "[GETOBJ: calling GLOBAL-CHECK]" CR>)>
	 <GLOBAL-CHECK .TBL>)
	(T
	 <COND (<IS? ,WINNER ,TRANSPARENT>
		<SET WT? T>)>
	 <UNMAKE ,WINNER ,TRANSPARENT>
	 <DO-SL ,HERE ,SOG ,SIR>
	 <MAKE ,WINNER ,TRANSPARENT>
	 ;<COND (<T? ,LIT?>
		<UNMAKE ,PLAYER ,TRANSPARENT>
		<DO-SL ,HERE ,SOG ,SIR>
		<MAKE ,PLAYER ,TRANSPARENT>)>
	 <DO-SL ,WINNER ,SH ,SC>
	 <COND (.WT?
		<MAKE ,WINNER ,TRANSPARENT>)
	       (T
		<UNMAKE ,WINNER ,TRANSPARENT>)>)>
  <SET LEN <- <ZGET .TBL ,P-MATCHLEN>:FIX .TLEN>>
; <COND (<T? ,DEBUG?>
	 <TELL "[GETOBJ: LEN=" N .LEN "]" CR>)>
  <COND (<BTST ,P-GETFLAGS ,P-ALL>)
	(<AND <BTST ,P-GETFLAGS ,P-ONE>
	      <T? .LEN>>
	 <COND (<NOT <EQUAL? .LEN 1>>
		<ZPUT .TBL 1 <ZGET .TBL <RANDOM .LEN>>>
		<TELL "[How about " THE <ZGET .TBL 1> "?]" CR>)>
	 <ZPUT .TBL ,P-MATCHLEN 1>)
	(<OR <G? .LEN 1>
	     <AND <ZERO? .LEN>
		  <NOT <EQUAL? ,P-SLOCBITS -1>>>>
	 <COND (<EQUAL? ,P-SLOCBITS -1>
		<SETG P-SLOCBITS .XBITS>
		<SET OLEN .LEN>
		<ZPUT .TBL ,P-MATCHLEN <- <ZGET .TBL ,P-MATCHLEN>:FIX .LEN>>
		<AGAIN>)
	       (T
		<ZPUT ,P-NAMW ,P-PHR ,P-NAM>
		<ZPUT ,P-ADJW ,P-PHR ,P-ADJ>
		<COND (<ZERO? .LEN>
		       <SET LEN .OLEN>)>
		; "LEN is the number of new objects found; TLEN is the number
		   of objects already in the table from previous GET-OBJECTS"
		<COND (<AND <T? ,P-NAM>
			    <SET OBJ <ZGET .TBL <+ .TLEN 1>>>>
		       ; "Rest the table down to one before the beginning
			  of the problem"
		       <SET TTBL <ZREST .TBL <* .TLEN 2>>>
		       ; "Save what's there"
		       <SET TOBJ <ZGET .TTBL 0>>
		       ; "Stuff the number of objects in"
		       <ZPUT .TTBL 0 .LEN>
		       ; "Apply the generic"
		       <SET OBJ <ZAPPLY <GETP .OBJ ,P?GENERIC> .TTBL>>
		       ; "Restore the table"
		       <ZPUT .TTBL 0 .TOBJ>
		       <COND
			(.OBJ
			 ; "Generic was happy"
			 <COND (<EQUAL? .OBJ ,NOT-HERE-OBJECT>
				<RETURN <> .GET>)>
			 <ZPUT .TBL <+ .TLEN 1> .OBJ>
			 <ZPUT .TBL ,P-MATCHLEN <+ .TLEN 1>>
			 <SETG P-NAM <>>
			 <SETG P-ADJ <>>
			 <RETURN T .GET>)>)>
		<COND (<AND <T? .VRB>
			    <NOT <EQUAL? ,WINNER ,PLAYER>>>
		       <DONT-UNDERSTAND>
		       <RETURN <> .GET>)
		      (<AND <T? .VRB>
			    <T? ,P-NAM>>
		       <SET XTBL <COND (<EQUAL? .TBL ,P-PRSO> ,P-OCL1)
				       (T ,P-OCL2)>>
		       <COND (<G? <ZGET .XTBL 0>:FIX 10>
			      <ZPUT .XTBL 0 0>
			      <TELL
"Look, you're not getting anywhere this way. Try something else." CR>)
			     (T
			      <WHICH-PRINT .TLEN .LEN .TBL>
			      <SETG P-ACLAUSE
				    <COND (<EQUAL? .TBL ,P-PRSO>
					   ,P-NC1)
					  (T
					   ,P-NC2)>>
			    ; <SETG P-AADJ ,P-ADJ>
			      <SETG P-ANAM ,P-NAM>
			      <ORPHAN <> <>>
			      <SETG P-OFLAG T>)>)
		      (<T? .VRB>
		       <NOT-IN-SENTENCE "enough nouns">)>
		<SETG P-NAM <>>
		<SETG P-ADJ <>>
		<RETURN <> .GET>)>)
	(<T? ,P-OFLAG> <RETURN <> .GET>)
	(<AND <ZERO? .LEN>
	      <T? .GCHECK>>
	 <ZPUT ,P-NAMW ,P-PHR ,P-NAM>
	 <ZPUT ,P-ADJW ,P-PHR ,P-ADJ>
	 <COND (<T? .VRB>
		<SETG P-SLOCBITS .XBITS> ; "RETROFIX #33"
		<OBJ-FOUND ,NOT-HERE-OBJECT .TBL>
		<SETG P-XNAM ,P-NAM>
		<SETG P-NAM <>>
		<SETG P-XADJ ,P-ADJ>
		<SETG P-ADJ <>>
		<RETURN T .GET>
		;<COND (<OR <T? ,LIT?>
			   <INTBL? ,PRSA ,TALKVERBS ,NTVERBS>
			 ; <SPEAKING-VERB?>>
		       <OBJ-FOUND ,NOT-HERE-OBJECT .TBL>
		       )
		      (T
		       <TOO-DARK>)>)>
	 <SETG P-NAM <>>
	 <SETG P-ADJ <>>
	 <RETURN <> .GET>)
	(<ZERO? .LEN>
	 <SET GCHECK T>
       ; <COND (<T? ,DEBUG?>
		<TELL "[GETOBJ: GCHECK set to " N .GCHECK "]" CR>)>
	 <AGAIN>)>
  <SET X <ZGET .TBL <+ .TLEN 1>>>
  <COND (<AND <T? ,P-ADJ>
	      <ZERO? ,P-NAM>
	      <T? .X>>
	 <TELL "[" THE .X ,BRACKET>)>
  <SETG P-SLOCBITS .XBITS>
  <ZPUT ,P-NAMW ,P-PHR ,P-NAM>
  <ZPUT ,P-ADJW ,P-PHR ,P-ADJ>
  <SETG P-NAM <>>
  <SETG P-ADJ <>>
  <RETURN T .GET>>>

<SETG P-MOBY-FOUND <>>



"This MOBY-FIND works in both ZIL and ZIP."

<MSETG LAST-OBJECT 0>

<COND (<NOT <GASSIGNED? ZILCH>>
       <SETG20 ZOBJS-OBLIST <CHTYPE <LOOKUP "ZOBJS"
					    <MOBLIST IZIL!-ZIL!-PACKAGE>>
				    OBLIST>>
       <SETG20 OBJECT-ATOM <LOOKUP "OBJECT" <MOBLIST ZIL!-PACKAGE>>>)>

<DEFINE SEE-INSIDE? (OBJ)
	 <COND (<ZERO? .OBJ>
		<>)
	       (<IS? .OBJ ,SURFACE>
		T)
	       (<AND <IS? .OBJ ,PERSON>
		     <N==? .OBJ ,WINNER>>
		T)
	       (<AND <==? .OBJ ,PLAYER>
		     <N==? .OBJ ,WINNER>> T)
	       (<IS? .OBJ ,LIVING>
		T)
	       (<NOT <IS? .OBJ ,CONTAINER>>
		<>)
	       (<IS? .OBJ ,OPENED>
		T)
	       (<IS? .OBJ ,TRANSPARENT>
		T)
	       (T
	    	<>)>>

<DEFINE MOBY-FIND (TBL "AUX" (OBJ 1) LEN FOO NAM ADJ)
  <SET NAM ,P-NAM>
  <SET ADJ ,P-ADJ>
  <SETG P-NAM ,P-XNAM>
  <SETG P-ADJ ,P-XADJ>
; <COND (<T? ,DEBUG?>
	 <TELL "[MOBY-FIND called, P-NAM = ">
	 <TELL WORD ,P-NAM>
	 <TELL "]" CR>)>
  <ZPUT .TBL ,P-MATCHLEN 0>
  %<COND (<GASSIGNED? ZILCH>	;<NOT <ZERO? <GETB 0 18>>>	;"ZIP case"
	 '<PROG ()
	 <REPEAT ()
		 <COND (<AND ; <SET FOO <META-LOC .OBJ T>>
			     <NOT <IN? .OBJ ,ROOMS>>
			     <SET FOO <THIS-IT? .OBJ>>>
			<SET FOO <OBJ-FOUND .OBJ .TBL>>)>
		 <COND (<G? <SET OBJ <+ .OBJ 1>> ,LAST-OBJECT>
			<RETURN>)>>>)
	(T		;"ZIL case"
	 ; "New version to run in muddle. Uses more-or-less identical
	    algorithm as above..."
	 '<MAPF <>
	    <FUNCTION (L:LIST)
	      <MAPF <>
	        <FUNCTION (ATM "AUX" VAL)
		  <COND (<AND <==? <OBLIST? .ATM> ,ZOBJS-OBLIST>
			      <GASSIGNED? .ATM>
			      <==? <TYPE <SET VAL ,.ATM>>
				   ,OBJECT-ATOM>>
			 <COND (<AND <NOT <IN? .VAL ,ROOMS>>
				     <SET FOO <THIS-IT? .VAL>>>
				<SET FOO <OBJ-FOUND .VAL .TBL>>)>)>>
		.L>>
	    ,ATOM-TABLE:VECTOR>
	 ;<PROG ()
	 <SETG P-SLOCBITS -1>
	 <SET FOO <FIRST? ,ROOMS>>
	 <REPEAT ()
		 <COND (<ZERO? .FOO>
			<RETURN>)
		       (T
			<SEARCH-LIST .FOO .TBL ,P-SRCALL T>
			<SET FOO <NEXT? .FOO>>)>>
	 <DO-SL ,LOCAL-GLOBALS 1 1 .TBL T>
	 <SEARCH-LIST ,ROOMS .TBL ,P-SRCTOP T>>)>
  <COND (<EQUAL? <SET LEN <ZGET .TBL ,P-MATCHLEN>> 1>
	 <SETG P-MOBY-FOUND <ZGET .TBL 1>>)>
  <SETG P-NAM .NAM>
  <SETG P-ADJ .ADJ>
  .LEN>

<SETG P-SPECIAL-ORPHAN <>>

<DEFINE WHICH-PRINT (TLEN:FIX LEN:FIX TBL "AUX" OBJ RLEN:FIX
		     (MT? <>))
	 <COND (<T? ,P-MERGED>
		<COND (<AND <==? ,P-MERGED 1>
			    <==? .TBL ,P-PRSO>>
		       <SET MT? T>)
		      (<AND <==? ,P-MERGED 2>
			    <==? .TBL ,P-PRSI>>
		       <SET MT? T>)>)>
	 <SET RLEN .LEN>
	 <TELL "Which">
         <COND (<OR <T? ,P-OFLAG>
		    .MT?
		    <T? ,P-AND>>
		<TELL " ">
		<COND (<AND <T? ,P-LASTADJ>
			    <N==? ,P-LASTADJ ,P-NAM>>
		       <TELL WORD ,P-LASTADJ>
		       <TELL " ">)>
		<TELL WORD ,P-NAM>)
	       (<EQUAL? .TBL ,P-PRSO>
		<CLAUSE-PRINT ,P-NC1 ,P-NC1L <>>)
	       (T
		<CLAUSE-PRINT ,P-NC2 ,P-NC2L <>>)>
	 <COND (,P-SPECIAL-ORPHAN
		<TELL ,P-SPECIAL-ORPHAN>)
	       (T
		<TELL " do you mean,">)>
	 <REPEAT ()
		 <SET TLEN <+ .TLEN 1>>
		 <SET OBJ <ZGET .TBL .TLEN>>
	         <TELL " " THE .OBJ>
		 <COND (<EQUAL? .LEN 2>
		        <COND (<NOT <EQUAL? .RLEN 2>>
			       <TELL ",">)>
		        <TELL " or">)
		       (<G? .LEN 2>
			<TELL ",">)>
		 <COND (<L? <SET LEN <- .LEN 1>> 1>
		        <TELL "?" CR>
		        <RETURN>)>>>

<DEFINE GLOBAL-CHECK CHECK (TBL
			    "AUX" LEN:FIX RMG RMGL (CNT:FIX 0) OBJ OBITS FOO
			    PO)
	<SET LEN <ZGET .TBL ,P-MATCHLEN>>
	<SET OBITS ,P-SLOCBITS>
	<SETG P-FOUND-REMOTELY <>>
	<COND (<THIS-IT? ,HERE>
	       <OBJ-FOUND ,HERE .TBL>)>
	<COND (<SET RMG <GETPT ,HERE ,P?GLOBAL>>
	       <SET RMGL <RMGL-SIZE .RMG>>
	     ; <COND (<T? ,DEBUG?>
		      <TELL "[GLBCHK: (LG) RMGL=" N .RMGL "]" CR>)>
	       <REPEAT ()
		       <COND
			(<SET OBJ <GET/B .RMG .CNT>>
			 <COND (<AND <FIRST? .OBJ>
				     <NOT <IN? .OBJ ,ROOMS>>>
				<SEARCH-LIST .OBJ .TBL ,P-SRCALL>)>
			 <COND (<THIS-IT? .OBJ>
				<OBJ-FOUND .OBJ .TBL>)>)>
		       <COND (<G? <SET CNT <+ .CNT 1>> .RMGL>
			      <RETURN>)>>)>
	; "New theory of pseudos. THINGS property is table:
	   first element is function to call to do the match,
	   second is argument to pass to that function along with
	   adjective/noun stuff. Function either returns <>,
	   object, or fatal. Fatal means you lose immediate..."
	<COND (<AND <0? <ZGET .TBL ,P-MATCHLEN>:FIX>
		    <SET RMG <GETP ,HERE ,P?THINGS>>>
	       <COND (<SET PO <ZAPPLY <ZGET .RMG 0> ,P-ADJ ,P-NAM
				      <ZGET .RMG 1>>>
		      <COND (<N==? .PO ,FATAL-VALUE>
			     <SETG P-FOUND-REMOTELY .PO>
			     <OBJ-FOUND .PO .TBL>)
			    (T
			     <RETURN <> .CHECK>)>)>)>
	<COND (<EQUAL? <ZGET .TBL ,P-MATCHLEN> .LEN>
	       <SETG P-SLOCBITS -1>
	       <SETG P-TABLE .TBL>
	       <DO-SL ,GLOBAL-OBJECTS 1 1>
	       <SETG P-SLOCBITS .OBITS>
	       <COND (<ZERO? <ZGET .TBL ,P-MATCHLEN>>
		      <COND (<VERB? EXAMINE LOOK-ON LOOK-INSIDE FIND FOLLOW
				    LEAVE SEARCH SMELL WALK-TO THROUGH
				    WAIT-FOR READ>
			     <DO-SL ,ROOMS 1 1>)>)>)>>

<DEFINE DO-SL (OBJ BIT1 BIT2 "AUX" BITS)
	<COND (<BTST ,P-SLOCBITS <+ .BIT1 .BIT2>>
	       <SEARCH-LIST .OBJ ,P-TABLE ,P-SRCALL>)
	      (T
	       <COND (<BTST ,P-SLOCBITS .BIT1>
		      <SEARCH-LIST .OBJ ,P-TABLE ,P-SRCTOP>)
		     (<BTST ,P-SLOCBITS .BIT2>
		      <SEARCH-LIST .OBJ ,P-TABLE ,P-SRCBOT>)
		     (T
		      T)>)>>

<MSETG P-SRCBOT 2>
<MSETG P-SRCTOP 0>
<MSETG P-SRCALL 1>

<DEFINE SEARCH-LIST SEARCH (OBJ TBL LVL "OPT" (IGN <>) "AUX" (ALL? <>))
 <COND (<AND <F? ,P-NAM>
	     <F? ,P-ADJ>>
	<SET ALL? T>)>
 <SET OBJ <FIRST? .OBJ>>
 <REPEAT ()
	  <COND (<ZERO? .OBJ>
		 <RETURN T .SEARCH>)
		(<AND <NOT <EQUAL? .LVL ,P-SRCBOT>>
		      <GETPT .OBJ ,P?SYNONYM>
		      <THIS-IT? .OBJ>>
		 <OBJ-FOUND .OBJ .TBL>)>
	  <COND (<AND <FIRST? .OBJ>
		      <NOT <EQUAL? .OBJ ,WINNER ,LOCAL-GLOBALS
				   	,GLOBAL-OBJECTS>>
		      <SEE-INSIDE? .OBJ>
		      <OR <N==? .LVL ,P-SRCTOP>
			  <IS? .OBJ ,SEARCH-ME>>>
		 ; "big mother change, see what happens. Used to be
		    <OR <N==? .LVL ,P-SRCTOP>
			<SEE-INSIDE? .OBJ>>"
		 ; "Don't search the pocket for ALL"
		 <COND (<AND .ALL?
			     <==? .OBJ ,POCKET>>)
		       (<AND .ALL?
			     <==? .OBJ ,WALLET>
			     <VERB? DROP PUT>>)
		       (T
			<SEARCH-LIST .OBJ .TBL
			      <COND (<IS? .OBJ ,SURFACE>
				     ,P-SRCALL)
				    (<==? .OBJ ,PLAYER>
				     ,P-SRCALL)
				    (T
				     ,P-SRCTOP)>>)>)>
	  <SET OBJ <NEXT? .OBJ>>>>

<DEFINE THIS-IT? TI (OBJ "AUX" SYNS N)
         <COND (<AND <EQUAL? ,W?INTNUM ,P-NAM ,P-ADJ>
		     <T? <SET N <GETP .OBJ ,P?MATCH-NUMBER>>>>
		; "Allow objects to match a particular number, rather than
		   any number"
		<COND (<N==? .N ,P-NUMBER>
		       <RETURN <> .TI>)>)>
	 <COND (<IS? .OBJ ,INVISIBLE>
		<>)
               (<AND <T? ,P-NAM>
	             <OR <NOT <SET SYNS <GETPT .OBJ ,P?SYNONYM>>>
		         <NOT <INTBL? ,P-NAM .SYNS </ <PTSIZE .SYNS> 2>>
			    ; <ZMEMQ ,P-NAM .SYNS
				     <- </ <PTSIZE .SYNS> 2> 1>>>>>
	        <>)
               (<AND <T? ,P-ADJ>
	             <OR <NOT <SET SYNS <GETPT .OBJ ,P?ADJECTIVE>>>
		         <NOT <INTBL? ,P-ADJ .SYNS </ <PTSIZE .SYNS> 2>>
			    ; <ZMEMQ ,P-ADJ .SYNS <RMGL-SIZE .SYNS>>>>>
	        <>)
               (<AND <T? ,P-GWIMBIT>
		     <NOT <FSET? .OBJ ,P-GWIMBIT>>>
	        <>)
	       (<AND <F? ,P-ADJ>
		     <F? ,P-NAM>>
		<COND (<OR <==? .OBJ ,POCKET>
			   <AND <==? ,P-GETFLAGS ,P-ALL>
				<IS? .OBJ ,NOALL>>>
		       <>)
		      (T T)>)
	       (T
		T)>>

<DEFINE OBJ-FOUND (OBJ TBL "AUX" PTR)
	<COND (<OR <0? <SET PTR <ZGET .TBL 0>>>
		   ; "To get around EZIP bug on IBM and 6502"
		   <NOT <INTBL? .OBJ <ZREST .TBL 2> .PTR>>>
	       <ZPUT .TBL <SET PTR <+ .PTR 1>> .OBJ>
	       <ZPUT .TBL ,P-MATCHLEN .PTR>
	       <COND (<IS? .OBJ ,NEEDS-IDENTITY>
		      <PUTP .OBJ ,P?OBJ-NOUN ,P-NAM>)>)>
	T>

<DEFINE SAY-TAKING (OBJ L)
  <TELL "[taking " THE .OBJ>
  <COND (<T? .L>
	 <COND (<IS? .L ,CONTAINER>
		<TELL " out of ">)
	       (<IS? .L ,SURFACE>
		<TELL " off ">)
	       (T
		<TELL " from ">)>
	 <TELL THE .L>)>
  <TELL " first" ,BRACKET>
  T>

<DEFINE ITAKE-CHECK CHECK (TBL BITS "AUX" (PTR:FIX 1) LEN:FIX OBJ L GOT
			   (TRIED-TAKE? <>))
	 ; "GOT has three values:  0-->ain't got it; 1-->always had it;
	    2-->took it."
	 <SET LEN <ZGET .TBL ,P-MATCHLEN>>
	 <COND (<ZERO? .LEN>
		T)
	       (<OR <BTST .BITS ,SHAVE>
		    <BTST .BITS ,STAKE>>
		<REPEAT ()
			<SET OBJ <ZGET .TBL .PTR>>
			<COND (<EQUAL? .OBJ ,IT>
			       <COND (<NOT <ACCESSIBLE? ,P-IT-OBJECT>>
				      <MORE-SPECIFIC>
				      <RETURN <> .CHECK>)>
			       <SET OBJ ,P-IT-OBJECT>)
			      (<EQUAL? .OBJ ,THEM>
			       <COND (<NOT <ACCESSIBLE? ,P-THEM-OBJECT>>
				      <MORE-SPECIFIC>
				      <RETURN <> .CHECK>)>
			       <SET OBJ ,P-THEM-OBJECT>)
			      (<EQUAL? .OBJ ,HER>
			       <COND (<NOT <ACCESSIBLE? ,P-HER-OBJECT>>
				      <MORE-SPECIFIC>
				      <RETURN <> .CHECK>)>
			       <SET OBJ ,P-HER-OBJECT>)
			      (<EQUAL? .OBJ ,HIM>
			       <COND (<NOT <ACCESSIBLE? ,P-HIM-OBJECT>>
				      <MORE-SPECIFIC>
				      <RETURN <> .CHECK>)>
			       <SET OBJ ,P-HIM-OBJECT>)>
		        <COND (<AND <NOT <EQUAL? .OBJ ,POCKET ,HANDS ,FEET>>
				    <NOT <EQUAL? .OBJ ,ME ,YOU ,ROOMS>>
				    <NOT <EQUAL? .OBJ ,INTDIR ;,RIGHT ;,LEFT>>
				    <NOT <EQUAL? .OBJ ,MPLUG ,RANDOM-OBJECT
						 ,AIRLINE-MEAL>>
				    <NOT <EQUAL? .OBJ ,RWIRE ,BWIRE>>
				    <NOT <HELD? .OBJ>>>
			       <SETG PRSO .OBJ>
			       <SET L <LOC .OBJ>>
			       <COND (<==? .L ,WALLET>
				      ; "Special code for convenience"
				      <SET GOT 2>
				      <COND
				       (<IN? .L ,POCKET>
					; "If the wallet's in the pocket..."
					<SETG PRSO .L>
					<SAY-TAKING .L <>>
					<SET TRIED-TAKE? T>
					<COND
					 (<ITAKE T>
					  <MAKE ,WALLET ,OPENED>
					  <SETG PRSO .OBJ>)
					 (T
					  <SET GOT 0>)>)
				       (<NOT <IN? .L ,PLAYER>>
					<SET GOT 0>)>
				      <COND
				       (<G? .GOT 0>
					; "Got is true if wallet is in
					   hand"
					<SAY-TAKING .OBJ .L>
					<SET TRIED-TAKE? T>
					<COND (<NOT <ITAKE T>>
					       <SET GOT 0>)>)>)
				     (<ZERO? .L>
				      <SET GOT 0>)
				     (<AND <IS? .OBJ ,TRYTAKE>
				      	   <NOT <IS? .OBJ ,TAKEABLE>>
					   <==? ,WINNER ,PLAYER>>
				      <SET GOT 0>)
				     (<AND <IN? .L ,WINNER>
					   <ZERO? ,P-MULT?>
					   <BTST .BITS ,STAKE>
					   <SAY-TAKING .OBJ .L>
					   <SET TRIED-TAKE? T>
					   <ITAKE T>>
				      <SET GOT 2>)
				     (<AND <EQUAL? .L ,WINNER>
					   <BTST .BITS ,SHAVE>>
				      <SET GOT 1>)
				     (<NOT <EQUAL? ,WINNER ,PLAYER>>
				      <SET GOT 1>)
				     (T
				      <SET GOT 0>)>
			       <COND (<AND <ZERO? .GOT>
					   <NOT <EQUAL? .L ,POCKET>>
					   <BTST .BITS ,SHAVE>>
				      <WINNER-NOT-HOLDING .TRIED-TAKE?>
				      <COND (<AND <EQUAL? .LEN .PTR>
						  <T? ,P-MULT?>>
					     <TELL "all of those things">)
					    (<EQUAL? .OBJ ,NOT-HERE-OBJECT>
					     <SETG P-IT-OBJECT .OBJ>
					     <TELL D .OBJ>)
					    (T
					     <THIS-IS-IT .OBJ>
					     <COND (.TRIED-TAKE?
						    <COND
						     (<NOT <IS? .OBJ
								,NOARTICLE>>
						      <TELL "the ">)>)
						   (<IS? .OBJ ,PLURAL>
						    <TELL "any ">)
						   (<NOT <IS? .OBJ ,NOARTICLE>>
						    <COND (<IS? .OBJ ,VOWEL>
							   <TELL "an ">)
							  (T
							   <TELL "a ">)>)>
					     <TELL D .OBJ>)>
				      <ZPRINT ,PERIOD>
				      <RETURN <> .CHECK>)
				     ;(<AND <==? .GOT 2>
					   <BTST .BITS ,STAKE>
					   <EQUAL? ,WINNER ,PLAYER>>
				      <SAY-TAKING>)>)>
			<COND (<G? <SET PTR <+ .PTR 1>> .LEN>
			       <RETURN T .CHECK>)>>)>
	 T>

<DEFINE MANY-CHECK ("AUX" (LOSS <>) TMP)
	<COND (<AND <G? <ZGET ,P-PRSO ,P-MATCHLEN>:FIX 1>
		    <NOT <BTST <GETB ,P-SYNTAX ,P-SLOC1> ,SMANY>>>
	       <SET LOSS 1>)
	      (<AND <G? <ZGET ,P-PRSI ,P-MATCHLEN>:FIX 1>
		    <NOT <BTST <GETB ,P-SYNTAX ,P-SLOC2> ,SMANY>>>
	       <SET LOSS 2>)>
	<COND (<T? .LOSS>
	       <TELL "[" ,CANT
"refer to more than one object at a time with \"">
	       <SET TMP <ZGET ,P-ITBL ,P-VERBN>>
	       <COND (<ZERO? .TMP>
		      <TELL "tell">)
		     (<OR <T? ,P-OFLAG>
			  <T? ,P-MERGED>>
		      <TELL WORD <ZGET .TMP 0>>)
		     (T
		      <WORD-PRINT <GETB .TMP 2> <GETB .TMP 3>>)>
	       <TELL ".\"]" CR>
	       <>)
	      (T
	       T)>>

;<SETG LIT? T>
;<SETG ALWAYS-LIT? <>>

;<DEFINE IS-LIT? ("OPTIONAL" (RM <>) (RMBIT T) "AUX" OHERE (LIT <>))
	<COND (<AND <T? ,ALWAYS-LIT?>
		    <EQUAL? ,WINNER ,PLAYER>>
	       T)
	      (T
	       <COND (<ZERO? .RM>
		      <SET RM ,HERE>)>
	       <SETG P-GWIMBIT ,LIGHTED>
	       <SET OHERE ,HERE>
	       <SETG HERE .RM>
	       <COND (<AND <T? .RMBIT>
			   <IS? .RM ,LIGHTED>>
		      <SET LIT T>)
		     (T
		      <ZPUT ,P-MERGE ,P-MATCHLEN 0>
		      <SETG P-TABLE ,P-MERGE>
		      <SETG P-SLOCBITS -1>
		      <COND (<EQUAL? .OHERE .RM>
			     <DO-SL ,WINNER 1 1>
			     <COND (<AND <NOT <EQUAL? ,WINNER ,PLAYER>>
					 <IN? ,PLAYER .RM>>
				    <DO-SL ,PLAYER 1 1>)>)>
		      <DO-SL .RM 1 1>
		      <COND (<G? <ZGET ,P-TABLE ,P-MATCHLEN>:FIX 0>
			     <SET LIT T>)>)>
	       <SETG HERE .OHERE>
	       <SETG P-GWIMBIT 0>
	       .LIT)>>

"PICK-NEXT expects an LTABLE (length=number of strings), with an extra
byte after the length that's initially 0."

<DEFINE PICK-NEXT (TBL "AUX" CNT:FIX STR)
	 <SET CNT <GETB .TBL 2>>
       	 <SET STR <ZGET <REST .TBL 3> .CNT>>
	 <COND (<G=? <SET CNT <+ .CNT 1>> <ZGET .TBL 0>:FIX>
		<SET CNT 0>)>
	 <PUTB .TBL 2 .CNT>
	 .STR>

<DEFINE DONT-HAVE? HAVE (OBJ "OPT" (TAKE? <>) "AUX" L O)
	 <SET L <LOC .OBJ>>
	 <COND (<ZERO? .L>
		T)
	       (<EQUAL? .L ,WINNER>
		<RETURN <> .HAVE>)
	       (<AND <IN? .L ,PLAYER>
		     <EQUAL? ,WINNER ,PLAYER>>
	      	<SET O ,PRSO>
		<SETG PRSO .OBJ>
		<COND (<AND .TAKE? <ITAKE <>>>
		       <TELL "[taking " THEO>
		       <COND (<IS? .L ,CONTAINER>
			      <TELL " out of ">)
			     (T
			      <TELL " off ">)>
		       <TELL THE .L " first" ,BRACKET>
		       <SETG PRSO .O>
		       <THIS-IS-IT ,PRSO>
		       <RETURN <> .HAVE>)
		      (T
		       <SETG PRSO .O>
		       <TELL "You'd have to take " THE .OBJ>
	               <SPACE>
		       <COND (<AND <IS? .L ,SURFACE>
				   <N==? .L ,ENVELOPE>>
		              <TELL "off">)
		             (T
		              <TELL "out">)>
	               <TELL " of " THE .L " first." CR>
		       <RETURN T .HAVE>)>)>
	 <WINNER-NOT-HOLDING>
	 <COND (<T? .OBJ>
		<COND (<IS? .OBJ ,PLURAL>
		       <TELL "any " D .OBJ>)
		      (T
		       <TELL THE .OBJ>)>)
	       (T
		<TELL D ,NOT-HERE-OBJECT>)>
	 <ZPRINT ,PERIOD>
	 T>

<DEFINE WINNER-NOT-HOLDING ("OPT" (TRIED? <>))
	 <COND (<EQUAL? ,WINNER ,PLAYER>
		<COND (.TRIED?
		       <TELL "You weren't able to take ">)
		      (T
		       <TELL "You're not holding ">)>)
	       (T
		<TELL CTHE ,WINNER " do">
		<COND (<NOT <IS? ,WINNER ,PLURAL>>
		       <TELL "es">)>
		<TELL "n't have ">)>
	 T>

<MSETG NHAVES 17> "Number of HAVEVERBS."

<CONSTANT HAVEVERBS
	<PTABLE V?DROP V?PUT V?PUT-ON V?GIVE V?SHOW V?FEED V?THROW
	        V?PUT-UNDER V?PUT-BEHIND V?THROW-OVER V?RELEASE V?TAKE-WITH
		V?TOUCH-TO V?OPEN V?OPEN-WITH V?CLOSE V?COVER>>

<MSETG NTVERBS 16> "Number of TALKVERBS."

<CONSTANT TALKVERBS
	<PTABLE
	 V?TELL V?TELL-ABOUT V?ASK-ABOUT V?ASK-FOR V?WHAT V?WHERE V?WHO
	 V?ALARM V?HELLO V?GOODBYE V?SAY V?YELL V?THANK
	 V?QUESTION V?REPLY V?WAVE-AT>>

<MSETG NTOUCHES 70> "Number of TOUCHVERBS"

<CONSTANT TOUCHVERBS
	<PTABLE
	 V?TAKE V?TAKE-OFF V?PUT V?PUT-ON V?PUT-UNDER V?PUT-BEHIND
	 V?COVER V?EMPTY-INTO V?REACH-IN V?TOUCH-TO V?TOUCH V?HIT V?KICK
	 V?MOVE V?PUSH V?PUSH-TO V?PULL V?LOWER V?RAISE V?LOOSEN
	 V?TURN-TO V?ADJUST V?SPIN V?TURN V?SHAKE
	 V?SWING V?OPEN V?OPEN-WITH V?CLOSE V?LOCK V?UNLOCK ;V?SCREW ;V?UNSCREW
	 V?PLUG V?UNPLUG V?TIE V?UNTIE V?FOLD V?UNFOLD V?LAMP-ON V?LAMP-OFF
	 V?UNTANGLE V?WRAP-AROUND V?CUT V?RIP V?MUNG V?DIG V?FILL
	 ;V?BURN-WITH V?CLEAN V?CLEAN-OFF V?BLOW-INTO V?SHOOT
	 V?WIND V?REPAIR V?REPLACE V?PICK V?MELT V?PLAY V?REPLUG
	 ;V?UNSCREW-FROM ;V?SCREW-WITH V?GIVE V?FEED V?STAND-ON V?SHORT
	 V?SIT V?LIE-DOWN V?EAT V?BITE V?TASTE V?DRINK V?DRINK-FROM
	 V?FILL-IN V?ERASE>>

<MSETG NHVERBS 14> "Number of HURTVERBS."

<CONSTANT HURTVERBS
	<PTABLE
	 V?HIT V?KICK V?KILL V?MUNG V?KNOCK V?KICK V?CUT V?RIP
	 V?BITE ;V?RAPE V?SHAKE V?UNDRESS V?PUSH V?PUSH-TO
	 V?PULL>>

<MSETG NUMPUTS 7> "# PUTVERBS."

<CONSTANT PUTVERBS
	<PTABLE V?PUT V?PUT-ON V?PUT-UNDER V?PUT-BEHIND V?THROW
	        V?THROW-OVER V?EMPTY-INTO>>

<MSETG NMVERBS 23> "Number of MOVEVERBS."

<CONSTANT MOVEVERBS
	<PTABLE
	 V?TAKE V?TAKE-OFF V?MOVE V?PULL V?PUSH V?PUSH-TO V?TURN V?RAISE
	 V?LOWER V?SPIN V?SHAKE V?PLAY V?OPEN V?OPEN-WITH V?CLOSE V?ADJUST
	 V?UNTANGLE V?SHORT
	 V?TURN-TO V?POINT-AT V?SWING V?UNPLUG V?BOUNCE>>

<DEFINE GETTING-INTO? ()
	 <COND (<OR <ENTERING?>
		    <VERB? CLIMB-ON CLIMB-UP CLIMB-OVER CROSS STAND-ON SIT
		           LIE-DOWN CLIMB-DOWN>>
		T)
	       (T
		<>)>>

<DEFINE ENTERING? ()
	 <COND (<VERB? WALK-TO ENTER THROUGH FOLLOW LEAP USE>
		T)
	       (T
		<>)>>

<DEFINE EXITING? ()
	 <COND (<VERB? EXIT LEAVE TAKE-OFF ESCAPE>
		T)
	       (T
		<>)>>

<DEFINE ANYONE-HERE? HERE ("AUX" OBJ)
	 <SET OBJ <QCONTEXT-GOOD?>>
	 <COND (<ZERO? .OBJ>
		<SET OBJ <FIRST? ,HERE>>
	        <REPEAT ()
	                <COND (<ZERO? .OBJ>
			       <COND (<EQUAL? ,RANDOM-PERSON
					      ,PRSO ,PRSI ,WINNER>
				      <SET OBJ ,RANDOM-PERSON>
				      <RETURN>)
				     (<AND <==? ,HERE ,SEAT>
					   <T? <CURRENT-NEIGHBOR>>>
				      <PUTP ,RANDOM-PERSON ,P?PSEUDO-TABLE
					    <CURRENT-NEIGHBOR>>
				      <SET OBJ ,RANDOM-PERSON>
				      <RETURN>)
				     (<AND <ON-PLANE?>
					   <IS? ,FLIGHT-ATTENDANT ,SEEN>>
				      <SET OBJ ,FLIGHT-ATTENDANT>
				      <RETURN>)
				     (<AND <HERE? AISLE>
					   <T? <CURRENT-NEIGHBOR>>>
				      <PUTP ,RANDOM-PERSON ,P?PSEUDO-TABLE
					    <CURRENT-NEIGHBOR>>
				      <SET OBJ ,RANDOM-PERSON>
				      <RETURN>)
				     (<HERE? IN-POT>
				      <SET OBJ ,NATIVES>
				      <RETURN>)>
			       <RETURN <> .HERE>)
		              (<AND <IS? .OBJ ,PERSON>
			            <NOT <IS? .OBJ ,PLURAL>>
				    <NOT <EQUAL? .OBJ ,PLAYER ,WINNER>>>
		               <RETURN>)>
			<SET OBJ <NEXT? .OBJ>>>)>
	 .OBJ>

<DEFINE QCONTEXT-GOOD? ()
	 <COND (<AND <T? ,QCONTEXT>
		     <IS? ,QCONTEXT ,PERSON>
		     <EQUAL? ,HERE ,QCONTEXT-ROOM>
		     <VISIBLE? ,QCONTEXT>>
		,QCONTEXT)
	       (T
		<>)>>

<OBJECT NOT-HERE-OBJECT
	(DESC "that")
	(FLAGS NOARTICLE)
	(ACTION NOT-HERE-OBJECT-F)>

<DEFINE NOT-HERE-OBJECT-F NOT-HERE ("AUX" TBL (PRSO? T) OBJ ; (X <>) VAL)
	 <COND (<AND <PRSO? NOT-HERE-OBJECT>
		     <PRSI? NOT-HERE-OBJECT>>
		<TELL "Those things aren't here." CR>
		<RETURN T .NOT-HERE>)
	       (<PRSO? NOT-HERE-OBJECT>
		<SET TBL ,P-PRSO>)
	       (T
		<SET TBL ,P-PRSI>
		<SET PRSO? <>>)>

	<COND (<T? .PRSO?>
		<COND (<==? ,P-XNAM ,W?E>
		       <SETG PRSO ,INTDIR>
		       <SETG P-DIRECTION ,P?EAST>
		       <RETURN <> .NOT-HERE>)
		      (<==? ,P-XNAM ,W?D>
		       <SETG PRSO ,INTDIR>
		       <SETG P-DIRECTION ,P?DOWN>
		       <RETURN <> .NOT-HERE>)
		      (<VERB? ; "WALK-TO FOLLOW" FIND WHO WHAT WHERE BUY
			      REQUEST MAKE WAIT-FOR PHONE STINGLAI>
		       <SET OBJ <FIND-NOT-HERE .TBL .PRSO?>>
		       <COND (<T? .OBJ>
			      <COND (<NOT <EQUAL? .OBJ ,NOT-HERE-OBJECT>>
				     <RETURN ,FATAL-VALUE .NOT-HERE>)>)
			     (T
			      <RETURN <> .NOT-HERE>)>)>)
	       (T
		<COND (<VERB? TELL-ABOUT ASK-ABOUT ASK-FOR>
		       <SET OBJ <FIND-NOT-HERE .TBL .PRSO?>>
		       <COND (<T? .OBJ>
			      <COND (<NOT <EQUAL? .OBJ ,NOT-HERE-OBJECT>>
				     <RETURN ,FATAL-VALUE .NOT-HERE>)>)
			     (T
			      <RETURN <> .NOT-HERE>)>)>)>

	 <TELL ,CANT>
	 <COND (<VERB? LISTEN>
		<TELL "hear">)
	       (<VERB? SMELL>
		<TELL "smell">)
	       (T
		<TELL "see">)>
	 <COND (<OR <NOT <INTBL? ,P-XNAM <ZREST ,CAPS 2> <ZGET ,CAPS 0>>>
		    <==? ,P-XNAM ,W?ZALAGASAN>>
	      ; <NOT <NAME? ,P-XNAM>>
		<TELL " any">)>
	 <NOT-HERE-PRINT .PRSO?>
	 <TELL " here." CR>
	 <PCLEAR>
	 ,FATAL-VALUE>

<DEFINE FIND-NOT-HERE (TBL PRSO? "AUX" M-F OBJ)
	<SET M-F <MOBY-FIND .TBL>>
	<COND (<EQUAL? .M-F 1>
	       <COND (<T? .PRSO?>
		      <SETG PRSO ,P-MOBY-FOUND>)
		     (T
		      <SETG PRSI ,P-MOBY-FOUND>)>
	       <>)
	      (<AND <G? .M-F:FIX 1>
		    <SET OBJ <ZAPPLY <GETP <SET OBJ <ZGET .TBL 1>> ,P?GENERIC>
				     .TBL>>>
	       <COND (<EQUAL? .OBJ ,NOT-HERE-OBJECT>
		      T)
		     (<T? .PRSO?>
		      <SETG PRSO .OBJ>
		      <>)
		     (T
		      <SETG PRSI .OBJ>
		      <>)>)
	      (<VERB? ASK-ABOUT TELL-ABOUT ASK-FOR WHO WHAT WHERE
		      FIND FOLLOW TELL>
	       <>)
	      (<ZERO? .PRSO?>
	       <TELL "You wouldn't find any">
	       <NOT-HERE-PRINT .PRSO?>
	       <TELL " there." CR>
	       T)
	      (T
	       ,NOT-HERE-OBJECT)>>

<DEFINE NOT-HERE-PRINT ("OPTIONAL" (PRSO? <>))
	 <COND (<OR <T? ,P-OFLAG>
		    <T? ,P-MERGED>>
	        <COND (<T? ,P-XADJ>
		       <PRINTC 32>
		       <TELL WORD ,P-XADJ>)>
	        <COND (<T? ,P-XNAM>
		       <PRINTC 32>
		       <TELL WORD ,P-XNAM>)>)
               (<T? .PRSO?>
	        <BUFFER-PRINT <ZGET ,P-ITBL ,P-NC1>
			      <ZGET ,P-ITBL ,P-NC1L> <>>)
               (T
	        <BUFFER-PRINT <ZGET ,P-ITBL ,P-NC2>
			      <ZGET ,P-ITBL ,P-NC2L> <>>)>>

<DEFINE STD-PRINT-CONTENTS-TEST (OBJ)
  <COND (<OR <==? .OBJ ,WINNER>
	     <IS? .OBJ ,NODESC>> <>)
	(T T)>>

<DEFINE FIND-NEXT (OBJ FIRST? TST)
  <COND (.FIRST?
	 <SET OBJ <FIRST? .OBJ>>)
	(T
	 <SET OBJ <NEXT? .OBJ>>)>
  <REPEAT ()
    <COND (<F? .OBJ> <RETURN>)
	  (<F? <ZAPPLY .TST .OBJ>>
	   ; "Skip this guy if WINNER or NODESC"
	   <SET OBJ <NEXT? .OBJ>>)
	  (T
	   <RETURN>)>>
  .OBJ>

<DEFINE PRINT-CONTENTS (THING "OPT" (TST <>)
			"AUX" OBJ NXT (1ST? T) (IT? <>) (TWO? <>))
	 <COND (<F? .TST>
		<SET TST ,STD-PRINT-CONTENTS-TEST>)>
	 <SET OBJ <FIND-NEXT .THING T .TST>>
	 <COND (<ZERO? .OBJ>
		<TELL "nothing " PNEXT ,YAWNS>)
	       (T
		<REPEAT ()
		        <COND (<T? .OBJ>
		               ; "Get the next object that's not winner and
				  not nodesc"
			       <SET NXT <FIND-NEXT .OBJ <> .TST>>
		               <COND (<T? .1ST?>
			              <SET 1ST? <>>)
			             (T
			              <COND (<T? .NXT>
				             <TELL ", ">)
				            (T
				             <TELL " and ">)>)>
		               <COND
				(<F? <ZAPPLY <GETP .OBJ ,P?DESCFCN>
					     ,M-SHORT-OBJDESC>>
				 <TELL A .OBJ>
				 <COND (<AND <SEE-INSIDE? .OBJ>
					     <SEE-ANYTHING-IN? .OBJ>
					     <NOT <IN? .OBJ ,POCKET>>>
					<COND (<IS? .OBJ ,SURFACE>
					       <TELL " (supporting ">)
					      (T
					       <TELL " (containing ">)>
					<PRINT-CONTENTS .OBJ>
					<TELL ")">)>)>
			       <COND (<IS? .OBJ ,LIGHTED>
				      <TELL " (providing light)">)>
			       <COND (<AND <ZERO? .IT?>
				           <ZERO? .TWO?>>
			              <SET IT? .OBJ>)
			             (T
			              <SET TWO? T>
			              <SET IT? <>>)>
		               <SET OBJ .NXT>)
			      (T
		               <COND (<AND <T? .IT?>
				           <ZERO? .TWO?>>
			              <THIS-IS-IT .IT?>)>
		               <RETURN>)>>)>
	 <COND (.1ST? <>) (ELSE T)>>

<DEFINE MOVE-ALL (FROM TO "AUX" OBJ NXT)
	 <SET OBJ <FIRST? .FROM>>
	 <REPEAT ()
		 <COND (<ZERO? .OBJ>
			<RETURN>)>
		 <SET NXT <NEXT? .OBJ>>
		 <MOVE .OBJ .TO>
		 <SET OBJ .NXT>>
	 T>

<OBJECT X-OBJECT>

<DEFINE DESCRIBE-OBJECTS ("OPTIONAL" (THING <>)
			   "AUX" OBJ NXT STR (1ST? T) (TWO? <>) (IT? <>)
			   	 (ANY? <>))
	 <COND (<ZERO? .THING>
		<SET THING ,HERE>)>
	 ; "Hide invisible objects"
		<SET OBJ <FIRST? .THING>>
		<COND (<ZERO? .OBJ>
		       T)
		      (T
		       <REPEAT ()
			       <COND (<ZERO? .OBJ>
				      <RETURN>)>
			       <SET NXT <NEXT? .OBJ>>
			       <COND (<OR <IS? .OBJ ,NODESC>
					  <EQUAL? .OBJ ,WINNER>>
				      <MOVE .OBJ ,DUMMY-OBJECT>)>
			       <SET OBJ .NXT>>
		       ; "If HERE, apply FDESCs and DESCFCNs
			  and eliminate those objects"
		       <COND (<EQUAL? .THING ,HERE>
			      <SET OBJ <FIRST? .THING>> ; "FDESCs"
			      <REPEAT ()
				      <COND (<ZERO? .OBJ>
					     <RETURN>)>
				      <SET NXT <NEXT? .OBJ>>
				      <SET STR <GETP .OBJ ,P?FDESC>>
				      <COND (<AND <T? .STR>
						  <NOT <IS? .OBJ ,TOUCHED>>>
					     <TELL CR .STR CR>
					     <THIS-IS-IT .OBJ>
					     <MOVE .OBJ ,DUMMY-OBJECT>)>
				      <SET OBJ .NXT>>
			      <SET OBJ <FIRST? .THING>> ; "DESCFCNs"
			      <REPEAT ()
				      <COND (<ZERO? .OBJ>
					     <RETURN>)>
				      <SET NXT <NEXT? .OBJ>>
				      <SET STR <GETP .OBJ ,P?DESCFCN>>
				      <COND (<T? .STR>
					     <ZCRLF>
					     <SET STR <ZAPPLY .STR ,M-OBJDESC>>
					     <ZCRLF>
					     <THIS-IS-IT .OBJ>
					     ; "Don't cause the thing to
						re-appear if describing it
						removes it"
					     <COND
					      (<IN? .OBJ ,HERE>
					       <MOVE .OBJ ,DUMMY-OBJECT>)>)>
				      <SET OBJ .NXT>>)>
		       ; "Print whatever's left in a nice sentence"
		       <SET OBJ <FIRST? ,HERE>>
		       <COND (<T? .OBJ>
			      <REPEAT ()
			        <COND
				 (<T? .OBJ>
				  <SET NXT <NEXT? .OBJ>>
				  <COND (<T? .1ST?>
					 <SET 1ST? <>>
					 <COND (<EQUAL? .THING
							,HERE>
						<ZCRLF>
						<COND (<T? .NXT>
						       <TELL ,YOU-SEE>)
						      (<IS? .OBJ ,PLURAL>
						       <TELL "There are ">)
						      (T
						       <TELL "There's ">)>)>)
					(T
					 <COND (<T? .NXT>
						<TELL ", ">)
					       (T
						<TELL " and ">)>)>
				  <TELL A .OBJ>
				  <COND (<IS? .OBJ ,LIGHTED>
					 <TELL " (providing light)">)>
				  <COND (<AND <SEE-INSIDE? .OBJ>
					      <SEE-ANYTHING-IN? .OBJ>>
					 <MOVE .OBJ ,X-OBJECT>)>
				  <COND (<AND <ZERO? .IT?>
					      <ZERO? .TWO?>>
					 <SET IT? .OBJ>)
					(T
					 <SET TWO? T>
					 <SET IT? <>>)>
				  <SET OBJ .NXT>)
				 (T
				  <COND (<AND <T? .IT?>
					      <ZERO? .TWO?>>
					 <THIS-IS-IT .IT?>)>
				  <COND (<EQUAL? .THING ,HERE>
					 <TELL " here">)>
				  <ZPRINT ".">
				  <SET ANY? T>
				  <RETURN>)>>)>
		       <SET OBJ <FIRST? ,X-OBJECT>>
		       <REPEAT ()
			       <COND (<ZERO? .OBJ>
				      <RETURN>)
				     (<IS? .OBJ ,SURFACE>
				      <TELL " On ">)
				     (T
				      <TELL " Inside ">)>
			       <SET ANY? T>
			       <TELL THE .OBJ " you see ">
			       <PRINT-CONTENTS .OBJ>
			       <PRINTC 46>
			       <SET OBJ <NEXT? .OBJ>>>
		       <COND (<T? .ANY?>
			      <ZCRLF>)>
		       <MOVE-ALL ,X-OBJECT .THING>
		       <MOVE-ALL ,DUMMY-OBJECT .THING>)>>

<DEFINE SEE-ANYTHING-IN? ANY (THING "AUX" OBJ)
	 <SET OBJ <FIRST? .THING>>
	 <REPEAT ()
		 <COND (<ZERO? .OBJ>
			<RETURN <> .ANY>)
		       (<AND <NOT <IS? .OBJ ,NODESC>>
			     <NOT <EQUAL? .OBJ ,WINNER>>>
			<RETURN T .ANY>)>
		 <SET OBJ <NEXT? .OBJ>>>>

<DEFINE GLOBAL-IN? (OBJ1 OBJ2 "AUX" TBL)
	 <SET TBL <GETPT .OBJ2 ,P?GLOBAL>>
	 <COND (<ZERO? .TBL>
		<>)
	       (<INTBL? .OBJ1 .TBL </ <PTSIZE .TBL> 2>>
		T)
	       (T
		<>)>>

<DEFINE HELD? (OBJ "AUX" L)
	 <COND (<ZERO? .OBJ>
		<>)
	       (<AND <NOT <IS? .OBJ ,TAKEABLE>>
		     <NOT <IS? .OBJ ,TRYTAKE>>>
		<>)
	       (T
		<SET L <LOC .OBJ>>
		<COND (<EQUAL? .L <> ,ROOMS ,GLOBAL-OBJECTS>
		       <>)
		      (<EQUAL? .L ,WINNER>
		       T)
		      (<AND <EQUAL? ,WINNER ,PLAYER>
			    <EQUAL? .L ,POCKET ,WALLET>>
		       <>)
		      (T
		       <HELD? .L>)>)>>

<DEFINE ITS-CLOSED ("OPTIONAL" (OBJ <>))
	 <COND (<ZERO? .OBJ>
		<SET OBJ ,PRSO>)>
	 <THIS-IS-IT .OBJ>
	 <TELL CTHE .OBJ>
	 <IS-ARE .OBJ>
	 <TELL "closed." CR>>

<DEFINE DO-BANKWORD? (PTR)
  <COND (<T? <BANKTALK>>
	 <BANKWORD? .PTR>)
	(T <>)>>