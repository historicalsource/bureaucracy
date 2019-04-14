"BANK for BUREAUCRACY: Copyright 1987 Infocom, Inc. All rights reserved."

<FILE-FLAGS MDL-ZIL?>

<INCLUDE "FORMDEFS" "BANKDEFS">

<CONSTANT TELLER-SUBJECTS
	<PLTABLE
	 <PTABLE BANK "We make it easy for you.">
	 <PTABLE TELLER "Worked here all my life.">
	 <PTABLE WRISTWATCH "What do you think I am, a clock?">
	 <PTABLE WFORM "If you wish to make a withdrawal, you'll need one.">
	 <PTABLE DFORM "If you wish to make a deposit, you'll need one.">
	 <PTABLE QUEEN-MUM "I haven't the vaguest idea what you're talking about.">
	 <PTABLE NERD "Him? He's at the back of half our troubles, if you ask me.">>>

<CONSTANT CASH-CHECK-SCRIPT
      <PTABLE "THIS WINDOW FOR CHECK CASHING ONLY"
	      " cash a check?\""
	      "Please give me the check"
	      <>
	      "She takes the cheque and says, \"Please show me some ID.\"">>

<CONSTANT WITHDRAWAL-SCRIPT
      <PTABLE "THIS WINDOW FOR WITHDRAWALS ONLY"
	      " make a withdrawal?\""
	      "Here is a withdrawal slip"
	      WFORM
	      "\"May I see some ID please.\"">>

<CONSTANT DEPOSIT-SCRIPT
      <PTABLE "THIS WINDOW FOR DEPOSITS ONLY"
	      " make a deposit?\""
	      "Here is a deposit slip"
	      DFORM
	      "\"Please show me some ID.\"">>

<CONSTANT CHANGE-ADDRESS-SCRIPT
      <PTABLE "THIS WINDOW FOR ADDRESS CHANGES ONLY"
	      " file a change of address?\""
	      "Our records show that we already sent you a change-of-address form. We cannot allow more than one form to be outstanding for any one customer at any one time. I am only doing my job"
	      <>
	      <>>>

<OBJECT WFORM
	(DESC "withdrawal slip")
	(FLAGS TAKEABLE READABLE)
	(SIZE 2)
	(SYNONYM SLIP FORM BALANCE MINIMUM WITHDRAWAL)
	(ADJECTIVE WITHDRAWAL ADDRESS CHANGE MINIMUM)
	(GENERIC SLIP-F)
	(LOSING 0)
	(ACTION WDFORM-F)>

<OBJECT DFORM
	(DESC "deposit slip")
	(FLAGS TAKEABLE READABLE)
	(SIZE 2)
	(SYNONYM SLIP FORM DEPOSIT)
	(ADJECTIVE DEPOSIT)
	(GENERIC SLIP-F)
	(LOSING 0)
	(ACTION WDFORM-F)>

<DEFINE SLIP-F (TBL "AUX" LEN)
	<SET LEN <ZGET .TBL 0>>
	<SET TBL <ZREST .TBL 2>>
	<COND (<NOT <HERE? BANK>> <>)
	      (<EQUAL? <TELLER-NUMBER>
		       <ZABS <TELLER-WITHDRAW>>
		       <ZABS <TELLER-ADDR-CHANGE>>>
	       ,WFORM)
	      (<EQUAL? <TELLER-NUMBER>
		       <ZABS <TELLER-DEPOSIT>>>
	       ,DFORM)
	      (<AND <VERB? ASK-ABOUT> <PRSO? TELLER>>
	       <COND (<F? <LOC ,DFORM>> ,DFORM)
		     (<F? <LOC ,WFORM>> ,WFORM)
		     (ELSE <>)>)
	      (ELSE <>)>>

<DEFINE WDFORM-F ("AUX" (DEP <>) AMT)
	<COND (<OR <NOUN-USED? ,W?BALANCE ,W?MINIMUM>
		   <ADJ-USED? ,W?MINIMUM>>
	       <IMPOSSIBLE>
	       T)
	      (<ADJ-USED? ,W?ADDRESS ,W?CHANGE>
	       <TELL ,YOU-SEE "no address change form." CR>
	       T)
	      (<THIS-PRSO?>
	       <COND (<==? ,PRSO ,DFORM>
		      <SET AMT <TELLER-AMOUNT-ON-DEPOSIT-FORM>>
		      <SET DEP T>)
		     (ELSE
		      <SET AMT <TELLER-AMOUNT-ON-WITHDRAWAL-FORM>>)>
	       <COND (<AND <VERB? MAKE>
			   <NOUN-USED? ,W?DEPOSIT ,W?WITHDRAWAL>>
		      <PERFORM ,V?ASK-ABOUT ,TELLER ,PRSO>)
		     (<VERB? FILL-IN>
		      <TELLER-DRUGS 0>
		      <PUTP ,PRSO ,P?LOSING 0>	;"Clear error"
		      <TELLER-CURRENT-FORM ,PRSO>
		      <COND (.DEP
			     <FILL-FORM 
			      ,BANK-FORM-DEPOSIT
			      "              DEPOSIT SLIP              ">)
			    (ELSE
			     <FILL-FORM
			      ,BANK-FORM-WITHDRAW
			      "            WITHDRAWAL SLIP             ">)>
		      <TELL "You have now filled out the slip." CR>
		      T)
		     (<VERB? EXAMINE READ>
		      <COND (<N==? .AMT 0>
			     <TELL "Your " D ,PRSO " is filled out:" CR>
			     <SHOW-FIELDS <COND (.DEP ,BANK-FORM-DEPOSIT)
						(ELSE ,BANK-FORM-WITHDRAW)>>)
			    (T
			     <TELL CTHEO
				   " looks like any other bank slip."
			    CR>)>
		      T)
		     (ELSE <>)>)>>

<DEFINE IBANK-LAST-NAME (CONTEXT TBL "OPT" (CHAR <>))
	<BCHECK .CONTEXT .TBL .CHAR ,LAST-NAME>>

<DEFINE IBANK-FIRST-NAME (CONTEXT TBL "OPT" (CHAR <>))
	<BCHECK .CONTEXT .TBL .CHAR ,FIRST-NAME>>

<DEFINE IBANK-MIDDLE-INITIAL (CONTEXT TBL "OPT" (CHAR <>))
	<BCHECK .CONTEXT .TBL .CHAR ,MIDDLE-INITIAL>>

<DEFINE BCHECK (CONTEXT TBL CHAR FIELD)
	<COND (<==? .CONTEXT ,FORM-ADD-CHAR>
	       <FF-NAME .CONTEXT .TBL .CHAR>)
	      (<==? .CONTEXT ,FORM-EXIT-FIELD>
	       <BCOMPARE-FIELDS .TBL <ZGET ,LICENSE-FORM
					   <SET FIELD <+ .FIELD 1>>>
				.FIELD>)
	      (T T)>>

<DEFINE BCOMPARE-FIELDS CF (TBL1 TBL2 FIELD "AUX" (LEN <FIELD-CURLEN .TBL1>)
			    (TCF <TELLER-CURRENT-FORM>))
  <SET FIELD <DO-LSH .FIELD>>
  <COND (<NEQ-TBL <ZREST .TBL1 <- ,FIELD-DATA-OFFSET 1>>
		  <ZREST .TBL2 <- ,FIELD-DATA-OFFSET 1>>>
	 ; "Set error bit"
	 <PUTP .TCF ,P?LOSING <ORB <GETP .TCF ,P?LOSING> .FIELD>>
	 T)
	(T
	 ; "Clear error bit"
	 <PUTP .TCF ,P?LOSING <ANDB <GETP .TCF ,P?LOSING>
				    <XORB .FIELD -1>>>
	 T)>>

<DEFINE BANK-CHECK-AMOUNT (CONTEXT TBL "OPT" (CHAR <>) "AUX" X)
	<COND (<==? .CONTEXT ,FORM-EXIT-FIELD>
	       <SET X <TEXT-TO-VALUE <ZREST .TBL <- ,FIELD-DATA-OFFSET 1>>
				     T>>
	       <COND (<==? .X -2>
		      <FERROR "Not a legal number">
		      <>)
		     (<==? .X -1>
		      <FERROR "Much too much">
		      <>) 
		     (<==? .X 0>
		      <FERROR "Not the old $0 trick">
		      <>)
		     (<==? ,PRSO ,WFORM>
		      <TELLER-AMOUNT-ON-WITHDRAWAL-FORM .X>
		      T)
		     (ELSE
		      <TELLER-AMOUNT-ON-DEPOSIT-FORM .X>
		      T)>)
	      (<==? .CONTEXT ,FORM-ADD-CHAR>
	       <COND (<CHECK-NUMBER .CHAR> T)
		     (<==? .CHAR %<ASCII !\.>> T)
		     (<==? .CHAR %<ASCII !\- >>
		      <FERROR "- is OK for us not you">
		      <>)
		     (T
		      <FERROR "Not a number">
		      <>)>)
	      (T T)>>

<DEFINE BANK-CHECK-DEAL (CONTEXT TBL "OPT" (CHAR <>) "AUX" X)
	<COND (<==? .CONTEXT ,FORM-EXIT-FIELD>
	       <COND (<EQUAL? <FIELD-DATA .TBL> %<ASCII !\Y> %<ASCII !\y>>
		      <TELLER-DRUGS 1>
		      <COND (<==? ,PRSO ,WFORM>
			     <FERROR "You look like a sleazebag" T>)
			    (ELSE
			     <FERROR "You'll get caught" T>)>)
		     (T
		      <TELLER-DRUGS 2>
		      <COND (<==? ,PRSO ,WFORM>
			     <FERROR "Not what our spies say" T>)
			    (ELSE
			     <FERROR "Must have mugged an old lady" T>)>)>
	       3)
	      (<==? .CONTEXT ,FORM-ADD-CHAR>
	       <COND (<OR <EQUAL? .CHAR %<ASCII !\Y> %<ASCII !\y>>
			  <EQUAL? .CHAR %<ASCII !\N> %<ASCII !\n>>>
		      T)
		     (T
		      <FERROR "Entry not Y or N">
		      <>)>)
	      (<==? .CONTEXT ,FORM-FIELD-RESET>
	       <TELLER-DRUGS 0>)
	      (T T)>>

<DEFINE BANK-DRUGS (CONTEXT TBL "OPT" (CHAR <>) "AUX" X)
	<COND (<==? .CONTEXT ,FORM-OK-TO-ENTER-FIELD?>
	       <COND (<==? <TELLER-DRUGS> 1>
		      T)
		     (ELSE <>)>)
	      (<==? .CONTEXT ,FORM-EXIT-FIELD>
	       T)
	      (<==? .CONTEXT ,FORM-ADD-CHAR>
	       <FF-NAME .CONTEXT .TBL .CHAR>)
	      (T T)>>

<DEFINE TO-BANK TB ("AUX" (BA <TELLER-BANK-HOURS>) H
		          T1 T2 T3 T4 (CLOSED <>))
	 <COND (<T? ,END-GAME?>
		<FROB-IS-CLOSED "bank">
		<RETURN <> .TB>)>
	 <TELLER-STATE ,STATE-INIT>
	 <TELLER-NUMBER 0>
	 <COND (<==? .BA 0>
		<COND (<PROB 50>
		       <SET BA <ZRANDOM 10>>
		       <TELLER-BANK-HOURS <- 0 .BA>>
		       <SET CLOSED T>)
		      (ELSE
		       <SET BA <+ <ZRANDOM 10> 20>>
		       <TELLER-BANK-HOURS .BA>)>
		<SET T1 <ZRANDOM ,NUMBER-TELLERS>>
		<TELLER-ADDR-CHANGE .T1>
		<SET T2 <ZRANDOM ,NUMBER-TELLERS>>
		<COND (<==? .T2 .T1>
		       <COND (<==? .T2 ,NUMBER-TELLERS>
			      <SET T2 1>)
			     (ELSE
			      <SET T2 <+ .T2 1>>)>)>
		<SET T3 <ZRANDOM ,NUMBER-TELLERS>>
		<REPEAT ()
			<COND (<EQUAL? .T3 .T1 .T2>
			       <COND (<==? .T3 ,NUMBER-TELLERS>
				      <SET T3 1>)
				     (ELSE
				      <SET T3 <+ .T3 1>>)>)
			      (ELSE <RETURN>)>>
		<SET T4 <ZRANDOM ,NUMBER-TELLERS>>
		<REPEAT ()
			<COND (<EQUAL? .T4 .T3 .T1 .T2>
			       <COND (<==? .T4 ,NUMBER-TELLERS>
				      <SET T4 1>)
				     (ELSE
				      <SET T4 <+ .T4 1>>)>)
			      (ELSE <RETURN>)>>
		<TELLER-CHECK-CASH .T2>
		<TELLER-WITHDRAW .T3>
		<TELLER-DEPOSIT .T4>
		<QUEUE I-BANK-HOURS>)
	       (<L? .BA 0>
		<SET BA <- 0 .BA>>
		<SET CLOSED T>)>
	 <COND (<T? .CLOSED>
		<TELL "You discover the bank is closed for ">
		<PRINT-BANK-DELTA .BA>
		<TELL ,PERIOD>
		<I-BANK-HOURS>
		<>)
	       (ELSE
		<TELL "As you enter, you hear an announcement say, \"WARNING: The bank will close in ">
		<PRINT-BANK-DELTA .BA>
		<TELL ".\"" CR CR>
		,BANK)>>

<DEFINE PRINT-BANK-DELTA (BA "AUX" H)
	<SET H </ .BA 60>>
	<SET BA <MOD .BA 60>>
	<COND (<N==? .H 0>
	       <TELL N .H " hour">
	       <COND (<N==? .H 1> <TELL "s">)>
	       <COND (<N==? .BA 0> <TELL " and ">)>)>
	<COND (<N==? .BA 0>
	       <TELL N .BA " minute">
	       <COND (<N==? .BA 1> <TELL "s">)>)>>		

<DEFINE I-BANK-HOURS ("AUX" (BA <TELLER-BANK-HOURS>) I
			    (VAL <>))
	<SET I <ZABS .BA>>
	<COND (<==? <SET I <- .I 1>> 0>
	       <COND (<AND <NOT <IN? ,PLAYER ,BANK>>
			   <NOT <IN? ,PLAYER ,ST-A>>>
		      <DEQUEUE I-BANK-HOURS>
		      <SET I 0>)
		     (<AND <G? .BA 0> <IN? ,PLAYER ,BANK>>
		      <TELL CR
			    "Unfortunately, the bank has closed. ">
		      <LEAVE-BANK T>
		      <SET VAL T>)
		     (<G? .BA 0>
		      <SET I <- 0 <ZRANDOM 10>>>)
		     (ELSE
		      <SET I <+ <ZRANDOM 10> 20>>)>)
	      (<L? .BA 0> <SET I <- 0 .I>>)>
	<TELLER-BANK-HOURS .I>
	.VAL>

<CONSTANT BANK-THINGS
	  <PTABLE MATCH-TELLER-NAME <>>>

<OBJECT BANK
	(LOC ROOMS)
	(SDESC BANK-DESC-BRIEF)
	(FLAGS NO-NERD IN-TOWN LIGHTED LOCATION INDOORS SPECIAL-DROP)
	(THINGS BANK-THINGS)
	(OUT TO ST-A)
	(SOUTH PER EXIT-BANK-CHECK)
	(NORTH PER TELLER-GOTO-F)
	(EAST PER NEXT-TELLER-F)
	(WEST PER PREV-TELLER-F)
	(IN SORRY "You're already inside as far as you can go.")
	(ACTION BANK-F)
	(EXIT-TO ST-A)
	(ENTER-FROM <PTABLE P?NORTH ST-A>)>

<DEFINE BANK-DESC-BRIEF ()
	<COND (<==? <TELLER-NUMBER> 0>
	       ; "This will be capitalized by SAY-HERE..."
	       <TELL "bank">)
	      (ELSE
	       <TELL "Teller #" N <TELLER-NUMBER>>)>>

<DEFINE BANK-F ("OPTIONAL" (CONTEXT <>)
		     "AUX" (TN <TELLER-NUMBER>)
			   (BA <TELLER-BANK-HOURS>))
	<COND (<==? .CONTEXT ,M-END>
	       <COND (<AND <VERB? WAIT> <T? <TELLER-IDLE>>>
		      <MORE-TELLER-INTERACTION
		       <TELLER-CURRENT-SCRIPT>>
		      T)
		     (ELSE <>)>)
	      (<==? .CONTEXT ,M-EXIT>
	       <RESET-BANK>
	       <>)
	      (<==? .CONTEXT ,M-LOOK>
	       <COND (<==? .TN 0>
		      <TELL "You are in The Fillmore Fiduciary Trust Bank. There is an exit to the south and teller windows to the north." CR>)
		     (ELSE
		      <TELL "You are in The Fillmore Fiduciary Trust Bank at teller window number " N .TN ,PERIOD>)>)
	      (<==? .CONTEXT ,M-ENTERED>
	       <THIS-IS-IT ,TELLER>
	       <DISPLAY-PLACE>
	       <HANDLE-TELLER-NUMBER>
	       T)
	      (<T? .CONTEXT> <>)
	      (<AND <ENTERING?>
		    <HERE? ST-A>>
	       <DO-WALK ,P?NORTH>)
	      (<VERB? OPEN>
	       <COND (<HERE? BANK>
		      <TELL "How could it be closed if you are in it?" CR>)
		     (<OR <T? ,END-GAME?> <L? .BA 0>>
		      <TELL "The bank will open in its own good time." CR>)
		     (<==? .BA 0>
		      <TELL "Why don't you find out if it's closed first?"
			    CR>)
		     (ELSE <TELL "It's already open." CR>)>
	       T)
	      (<VERB? EXAMINE>
	       <TELL "It looks a bit like a bank but actually rather like a travel agency." CR>
	       T)>>

<DEFINE RESET-BANK ()
	<TELLER-IDLE <>>
	<TELLER-CURRENT-SCRIPT <>>
	<COND (<F? <LOC ,DFORM>>
	       <TELLER-AMOUNT-ON-DEPOSIT-FORM 0>)>
	<COND (<F? <LOC ,WFORM>>
	       <TELLER-AMOUNT-ON-WITHDRAWAL-FORM
		     0>)>
	T>

;"HANDLE-BANK-DROP is called from verbs to prevent dropping in the bank."

<DEFINE HANDLE-BANK-DROP (OBJ)
	<COND (<==? ,P-PRSA-WORD ,W?DEPOSIT>
	       <PERFORM ,V?GIVE .OBJ ,TELLER>)
	      (ELSE
	       <TELL CTHE .OBJ>
	       <SETG P-MULT? <>>
	       <COND (<==? .OBJ ,MONEY>
		      <REMOVE .OBJ>
		      <TELL " is scooped up by ">
		      <COND (<T? <TELLER-PLAYER-WARNED?>>
			     <TELL "the special polyester employee">)
			    (T
			     <TELL "an efficient looking bank employee
made out of that special polyester reserved for people who work in banks">)>
		      <TELL ". He lectures you for a while on the evils of
littering, then pockets the money and leaves" ,PERIOD>)
		     (<T? <TELLER-PLAYER-WARNED?>>
		      <TELLER-PLAYER-WARNED? <>>
		      <TELL " is returned to you by the special polyester employee who warned you earlier. However, he is not as patient this time. ">
		      <LEAVE-BANK <>>
		      ,FATAL-VALUE)
		     (ELSE
		      <TELLER-PLAYER-WARNED? T>
		      <TELL " is returned to you by an efficient looking bank employee made out of that special polyester reserved for people who work in banks. He informs you that it is against bank policy for customers to drop things (except of course money) in the bank. As a matter of fact, he's pretty fed up, what with the computer foul-ups and the itching polyester and so forth, so he's going to throw you out next time. You bet he is! He then disappears" ,PERIOD>
		      T)>)>>

<DEFINE LEAVE-BANK (FLG)
	<TELL "You are whisked out of the bank with an efficiency that the bank obviously never applies to approving mortgages or clearing out-of-state cheques">
	<TELLER-NUMBER 0>
	<TELLER-STATE ,STATE-INIT>
	<COND (<IN? ,CHECK ,TELLER>
	       <TELL ". Fortunately, your cheque is returned to you">
	       <MOVE ,CHECK ,PLAYER>)>
	<TELL ,PERIOD>
	<COND (.FLG <ZCRLF>)>
	<GOTO ,ST-A .FLG>>

<OBJECT TELLER-WINDOWS
	(LOC LOCAL-GLOBALS)
	(DESC "teller window")
	(FLAGS NODESC PLACE)
	(ADJECTIVE TELLER)
	(SYNONYM WINDOW WINDOWS)
	(ACTION TELLER-WINDOW-F)>

<SETG NEW-TELLER 0>

<DEFINE TELLER-WINDOW-F ("AUX" NUM)
  <COND (<VERB? WALK-TO ENTER>
	 <COND (<F? ,NEW-TELLER>
		<>)
	       (<==? ,NEW-TELLER -1>
		<TELL "Which window do you want to go to?" CR>
		<ORPHAN-VERB <> ,ACT?ENTER>
		T)
	       (<==? <TELLER-NUMBER>
		     ,NEW-TELLER>
		<ALREADY-THERE>
		T)
	       (T
		<SET NUM ,NEW-TELLER>
		<SETG NEW-TELLER 0>
		<GOTO <NEXT-TELLER-F .NUM>>
		T)>)
	(T <>)>>

<DEFINE TELLER-GOTO-F ( )
	<COND (<==? <TELLER-NUMBER> 0>
	       <TELLER-NUMBER ,MID-TELLER>
	       <SETG OLD-HERE <>>
	       <RESET-BANK>
	       ,BANK)
	      (ELSE
	       <TELL "There is no exit that way." CR>
	       <>)>>

<DEFINE NEXT-TELLER-F ("OPT" (NTN <>)
		       "AUX" (TN <TELLER-NUMBER>))
	<COND (<AND <F? .NTN>
		    <OR <==? .TN 0> <==? .TN ,NUMBER-TELLERS>>>
	       <TELL "There is no exit that way." CR>
	       <>)
	      (ELSE
	       <SETG OLD-HERE <>>
	       <COND (<F? .NTN>
		      <TELLER-NUMBER <SET TN <+ .TN 1>>>)
		     (T
		      <TELLER-NUMBER .NTN>)>
	       <RESET-BANK>
	       ,BANK)>>

<DEFINE PREV-TELLER-F ("AUX" (TN <TELLER-NUMBER>))
	<COND (<L=? .TN 1>
	       <TELL "There is no exit that way." CR>
	       <>)
	      (ELSE
	       <TELLER-NUMBER <SET TN <- .TN 1>>>
	       <RESET-BANK>
	       <SETG OLD-HERE <>>
	       ,BANK)>>

<DEFINE EXIT-BANK-CHECK ("AUX" (OT <TELLER-NUMBER>))
	<TELLER-NUMBER 0>
	<COND (<N==? .OT 0>
	       <SETG OLD-HERE <>>
	       ,BANK)
	      (ELSE
	       ,ST-A)>>

<DEFINE HANDLE-TELLER-NUMBER ("AUX" (TN <TELLER-NUMBER>)
				    A B C D)
	<SET A <TELLER-ADDR-CHANGE>>
	<SET B <TELLER-CHECK-CASH>>
	<SET C <TELLER-WITHDRAW>>
	<SET D <TELLER-DEPOSIT>>
	<COND
	 (<==? .TN 0> T)
	 (T
	  <ZCRLF>
	  <COND(<==? .TN <ZABS .A>>
		<TELLER-ADDR-CHANGE <- 0 <ZABS .A>>>
		<TELLER-INTERACTION ,CHANGE-ADDRESS-SCRIPT .A>)
	       (<==? .TN <ZABS .B>>
		<TELLER-CHECK-CASH <- 0 <ZABS .B>>>
		<TELLER-INTERACTION ,CASH-CHECK-SCRIPT .B>)
	       (<==? .TN <ZABS .C>>
		<TELLER-WITHDRAW <- 0 <ZABS .C>>>
		<TELLER-INTERACTION ,WITHDRAWAL-SCRIPT .C>)
	       (<==? .TN <ZABS .D>>
		<TELLER-DEPOSIT <- 0 <ZABS .D>>>
		<TELLER-INTERACTION ,DEPOSIT-SCRIPT .D>)
	       (ELSE
		<SAY-SIGN>)>)>>

<DEFINE ZABS (X) <COND (<L? .X 0> <- 0 .X>) (ELSE .X)>>

<DEFINE TELLER-INTERACTION (SCR FIRST)
	<TELLER-CURRENT-SCRIPT .SCR>
	<SAY-SIGN>
	<COND (<G? .FIRST 0>
	       <ZCRLF>
	       <MORE-TELLER-INTERACTION .SCR>)
	      (T
	       <TELLER-IDLE T>
	       T)>>

;<DEFINE I-TELLER-WAKE-UP ()
	<MORE-TELLER-INTERACTION
	 <TELLER-CURRENT-SCRIPT>>
	T>

<DEFINE MORE-TELLER-INTERACTION (SCR "AUX" FCN OBJ)
	<TELL "The teller at the window says, \"Do you wish to">
	<TELL <ZGET .SCR ,TELLER-INTRO> CR>
	<TELLER-STATE ,STATE-INIT>
	<COND (<SAID-YES? "Just answer yes or no!">
	       <SET OBJ <ZGET .SCR ,TELLER-OBJ>>
	       <COND (<T? .OBJ>
		      <COND (<F? <LOC .OBJ>>
			     <TELL "\"Here is " A .OBJ
				   ",\" she says as she hands you one." CR>
			     <THIS-IS-IT .OBJ>
			     <COND (<==? .OBJ ,DFORM>
				    <TELLER-CASH-GIVEN 0>
				    <TELLER-AMOUNT-ON-DEPOSIT-FORM 0>)
				   (ELSE
				    <TELLER-AMOUNT-ON-WITHDRAWAL-FORM
					  0>)>
			     <MOVE .OBJ ,PLAYER>)
			    (ELSE
			     <TELL "\"I've run out of " D .OBJ
				   "s,\" she says. \"I hope you have one.\"" CR>)>)
		     (ELSE
		      <TELL "\"" <ZGET .SCR ,TELLER-SECOND>
			    ",\" she says." CR>)>)
	      (ELSE
	       <TELL CTHE ,TELLER " instructs you to go to window ">
	       <PROG ((N <RANDOM ,NUMBER-TELLERS>))
	         <COND (<==? .N <TELLER-NUMBER>>
			<COND (<==? .N 1>
			       <SET N 3>)
			      (<==? .N ,NUMBER-TELLERS>
			       <SET N 5>)
			      (T
			       <SET N <+ .N 1>>)>)>
		 <TELL N .N ,PERIOD>>)>>

<OBJECT TELLER
	(LOC BANK)
	(DESC "bank teller")
	(FLAGS LIVING FEMALE PERSON NODESC)
	(SYNONYM TELLER WOMAN LADY)
	(ADJECTIVE BANK)
	(DESCFCN TELLER-F)
	(CONTFCN TELLER-F)
	(ACTION TELLER-F)>

<DEFINE TELLER-F TELLER ("OPTIONAL" (CONTEXT <>))
    <COND
        (<EQUAL? <TELLER-NUMBER>
		 <ZABS <TELLER-ADDR-CHANGE>>
		 <ZABS <TELLER-CHECK-CASH>>
		 <ZABS <TELLER-WITHDRAW>>
		 <ZABS <TELLER-DEPOSIT>>>
	 <COND (<EQUAL? .CONTEXT ,M-OBJDESC>
		<TELL CA ,TELLER " is at the window.">
		T)
	       (<EQUAL? .CONTEXT ,M-CONT>
		<COND (<TOUCHING?>
		       <CANT-SEE-ANY <COND (<THIS-PRSO?> ,PRSO)
					   (T ,PRSI)>>
		       T)
		      (T
		       <>)>)
	       (<EQUAL? .CONTEXT ,M-WINNER>
		<COND (<VERB? STINGLAI> <RETURN <> .TELLER>)
		      (<VERB? EXAMINE READ LOOK-ON>
		       <SHOW-TELLER-PRSO>)
		      (<VERB? TAKE>
		       <GIVE-TELLER-PRSO>)
		      (<PRSO? ME>
		       <COND (<VERB? TELL-ABOUT TELL-TIME>
			      <ASK-TELLER-ABOUT ,PRSI>)
			     (<VERB? SSHOW>
			      <TELLER-SHOWS-YOU ,PRSI>)
			     (<VERB? SGIVE SSELL>
			      <ASK-TELLER-FOR ,PRSI>)
			     (T
			      <IGNORES ,TELLER>)>)
		      (<PRSI? ME>
		       <COND (<VERB? SHOW>
			      <TELLER-SHOWS-YOU ,PRSO>)
			     (<VERB? GIVE SELL>
			      <ASK-TELLER-FOR ,PRSO>)
			     (T
			      <IGNORES ,TELLER>)>)
		      (<VERB? HELLO>
		       <TELL CTHE ,TELLER " says, \"Hi.\"" CR>)
		      (<AND <VERB? WHAT>
			    <PRSO? WRISTWATCH>
			    <NOUN-USED? ,W?TIME>>
		       <TELL "I'm sorry ">
		       <SIR-OR-MAAM>
		       <TELL " I am not allowed to tell you that." CR>)
		      (T
		       <IGNORES ,TELLER>)>
		,FATAL-VALUE)
	       (<T? .CONTEXT>
		<>)
	       (<THIS-PRSI?>
		<COND (<VERB? GIVE>
		       <GIVE-TELLER-PRSO>
		       T)
		      (<VERB? SHOW>
		       <SHOW-TELLER-PRSO>
		       T)
		      (T
		       <>)>)
	       (<VERB? TELL>
		<>)
	       (<VERB? ASK-ABOUT>
		<ASK-TELLER-ABOUT ,PRSI>
		T)
	       (<VERB? ASK-FOR>
		<ASK-TELLER-FOR ,PRSI>
		T)
	       (<VERB? EXAMINE>
		<TELL "She looks a bit like a bank teller but actually rather more like a travel agent." CR>
		T)
	       (T
		<>)>)
	(<HERE? IN-COMPLEX> <>)
	(ELSE
	 <TELL "There is no teller here." CR>
	 ,FATAL-VALUE)>>
		
<DEFINE GIVE-TELLER-PRSO () <GIVE-SHOW-TELLER-PRSO T>>
	
<DEFINE SHOW-TELLER-PRSO () <GIVE-SHOW-TELLER-PRSO <>>>

<DEFINE GIVE-SHOW-TELLER-PRSO (GIVE? "AUX" (SCR <TELLER-CURRENT-SCRIPT>)
			       (FLG <>))
	<COND (<ZERO? .SCR>
	       <TELL CTHE ,TELLER " seems to be asleep." CR>)
	      (<==? .SCR ,CASH-CHECK-SCRIPT>
	       <COND (<==? ,PRSO ,CHECK> <CHECK-CHECK ,PRSO .GIVE?>)
		     (<NOT <CHECK-BRUSH-OFF ,PRSO .GIVE?>> <SET FLG T>)>)
	      (<==? .SCR ,DEPOSIT-SCRIPT>
	       <COND (<AND <F? <LOC ,DFORM>>
			   <==? <TELLER-AMOUNT-ON-DEPOSIT-FORM> 0>
			   <F? <LOC ,WFORM>>
			   <==? <TELLER-AMOUNT-ON-WITHDRAWAL-FORM> 0>>
		      <ASK-TELLER-ABOUT ,PRSO>)
		     (<NOT <DEPOSIT-CHECK ,PRSO .GIVE?>>
		      <COND (<NOT <DEPOSIT-BRUSH-OFF ,PRSO .GIVE?>>
			     <SET FLG T>)>)
		     (ELSE
		      <TELLER-IDLE <>>)>)
	      (<==? .SCR ,WITHDRAWAL-SCRIPT>
	       <COND (<AND <F? <LOC ,WFORM>>
			   <==? <TELLER-AMOUNT-ON-WITHDRAWAL-FORM> 0>>
		      <ASK-TELLER-ABOUT ,PRSO>)
		     (<NOT <WITHDRAW-CHECK ,PRSO .GIVE?>>
		      <COND (<NOT <WITHDRAWAL-BRUSH-OFF ,PRSO .GIVE?>>
			     <SET FLG T>)>)
		     (ELSE
		      <TELLER-IDLE <>>)>)
	      (<==? .SCR ,CASH-CHECK-SCRIPT>
	       <COND (<NOT <CHECK-CHECK ,PRSO .GIVE?>>
		      <COND (<NOT <CHECK-BRUSH-OFF ,PRSO .GIVE?>>
			     <SET FLG T>)>)>)
	      (T <SET FLG T>)>
	<COND (.FLG <TELL CTHE ,TELLER " is not interested in " THE ,PRSO
			  ,PERIOD>)>
	T>	 

<DEFINE TELLER-SHOWS-YOU (OBJ)
	 <COND (<EQUAL? .OBJ ,ME ,TELLER>
		<PUZZLED ,TELLER>)
	       (<IN? .OBJ ,TELLER>
		<TELL "\"Look for yourself,\" she replies." CR>)
	       (T
		<TELL CTHE ,TELLER " shrugs. \"Look at ">
		<COND (<IS? .OBJ ,PLURAL>
		       <TELL "them">)
		      (T
		       <TELL "it">)>
		<TELL " yourself.\"" CR>)>
	 T>
	       
<DEFINE ASK-TELLER-FOR (OBJ)
	 <COND (<EQUAL? .OBJ ,ME ,TELLER>
		<PUZZLED ,TELLER>)
	       (<EQUAL? .OBJ ,DFORM ,WFORM ,MONEY ,CHECK>
		<ASK-TELLER-ABOUT .OBJ T>)
	       (T
		<TELL CTHE ,TELLER " snorts. \"I can't ">
		<COND (<VERB? REQUEST ASK-FOR>
		       <TELL "give you">)
		      (<VERB? ASK-ABOUT>
		       <TELL "tell you anything about">)
		      (T
		       <ZPRINTB ,P-PRSA-WORD>
		       <TELL " you">)>
		<TELL " that!\"" CR>)>
	 T>	 

<DEFINE ASK-TELLER-ABOUT (OBJ "OPT" (FOR <>)
			  "AUX" (SCR <TELLER-CURRENT-SCRIPT>)
				 (MBAL <>) (BAL <>) (ADF <>)
				 (NONSENSE <>))
	<COND (<PRSI? WFORM>
	       <SETG NOW-PRSI? T>
	       <COND (<NOUN-USED? ,W?BALANCE ,W?MINIMUM>
		      <COND (<ADJ-USED? ,W?WITHDRAWAL ,W?ADDRESS ,W?CHANGE>
			     <SET NONSENSE T>)
			    (<OR <ADJ-USED? ,W?MINIMUM>
				 <NOUN-USED? ,W?MINIMUM>>
			     <SET MBAL T>)
			    (ELSE
			     <SET BAL T>)>)
		     (<ADJ-USED? ,W?MINIMUM> <SET NONSENSE T>)
		     (<ADJ-USED? ,W?ADDRESS ,W?CHANGE>
		      <SET ADF T>)>
	       <SETG NOW-PRSI? <>>)>
	<COND (<T? .NONSENSE>
	       <TELL CTHE ,TELLER " says, \"What are you talking about?\"" CR>)
	      (<T? .MBAL>
	       <TELL CTHE ,TELLER " says, \"$10 is the minimum.\"" CR>)
	      (<T? .BAL>
	       <TELL CTHE ,TELLER " says, \"I'm not allowed give out balances.\"" CR>)
	      (<==? .SCR ,DEPOSIT-SCRIPT>
	       <COND (<AND <F? <LOC ,DFORM>>
			   <==? <TELLER-AMOUNT-ON-DEPOSIT-FORM> 0>>
		      <TELLER-IDLE <>>
		      <MORE-TELLER-INTERACTION .SCR>)
		     (<==? .OBJ ,DFORM>
		      <COND (<F? <LOC ,DFORM>>
			     <COND (<T? .FOR>
				    <TELL CTHE ,TELLER " says, \"It's against bank policy to give it back to you.\"" CR>)
				   (<OR <IN? ,CHECK ,TELLER>
					<IN? ,MONEY ,TELLER>
					<N==? <TELLER-CASH-GIVEN> 0>>
				    <TELL CTHE ,TELLER " says, \"I have it. All I need is to see some ID.\"" CR>)
				   (ELSE
				    <TELL CTHE ,TELLER " says, \"I have it. Just give me the money or check to deposit.\"" CR>)>)
			    (<OR <IN? ,CHECK ,TELLER>
				 <IN? ,MONEY ,TELLER>
				 <N==? <TELLER-CASH-GIVEN> 0>>
			     <TELL CTHE ,TELLER " says, \"I need it to finish the deposit.\"" CR>)
			    (ELSE
			     <TELL CTHE ,TELLER " says, \"Return it to me when you have filled it out.\"" CR>)>)
		     (<EQUAL? .OBJ ,CHECK ,MONEY>
		      <COND (.FOR
			     <COND (<OR <AND <==? .OBJ ,CHECK>
					     <IN? ,CHECK ,TELLER>>
					<AND <==? .OBJ ,CHECK>
					     <N==? <TELLER-CASH-GIVEN> 0>>>
				    <TELL CTHE ,TELLER " says, \"I can't return that to you, it's against the rules.\"">)
				    (ELSE
				     <TELL CTHE TELLER " says, \"Read my lips!\" as she mouths the word DEPOSIT." CR>)>)
			    (ELSE
			     <TELL CTHE ,TELLER " says, \"I can deposit checks or money for you.\"" CR>)>)
		     (<OR <T? .ADF> <==? .OBJ ,WFORM>>
		      <TELL CTHE ,TELLER
			    " says, \"Go ask the correct teller.\"" CR>)
		     (ELSE
		      <ASK-CHAR-ABOUT ,TELLER .OBJ ,TELLER-SUBJECTS 0>)>)
	      (<==? .SCR ,WITHDRAWAL-SCRIPT>
	       <COND (<AND <F? .ADF>
			   <F? <LOC ,WFORM>>
			   <==? <TELLER-AMOUNT-ON-WITHDRAWAL-FORM> 0>>
		      <TELLER-IDLE <>>
		      <MORE-TELLER-INTERACTION .SCR>)
		     (<AND <==? .OBJ ,WFORM> <F? .ADF>>
		      <COND (<F? <LOC ,WFORM>>
			      <COND (<T? .FOR>
				     <TELL CTHE ,TELLER " says, \"It's against bank policy to give it back to you.\"" CR>)
				    (ELSE
				     <TELL CTHE ,TELLER " says, \"I have it. All I need is to see some ID.\"">)>)
			    (ELSE
			     <TELL CTHE ,TELLER " says, \"Return it to me when you have filled it out.\"" CR>)>)
		     (<==? .OBJ ,MONEY>
		      <TELL CTHE ,TELLER
			    " says, \"You get money when you complete a withdrawal.\"" CR>)
		     (<OR <EQUAL? .OBJ ,CHECK ,DFORM ,WFORM> <T? .ADF>>
		      <TELL CTHE ,TELLER
			    " says, \"Go ask the correct teller.\"" CR>)
		     (ELSE
		      <ASK-CHAR-ABOUT ,TELLER .OBJ ,TELLER-SUBJECTS 0>)>)
	      (<==? .SCR ,CASH-CHECK-SCRIPT>
	       <COND (<IN? ,CHECK ,PLAYER>
		      <MORE-TELLER-INTERACTION .SCR>)
		     (<EQUAL? .OBJ ,CHECK ,MONEY>
		      <TELL CTHE ,TELLER " says, \"This is where you cash checks." CR>)
		     (<EQUAL? .OBJ ,WFORM ,DFORM>
		      <TELL CTHE ,TELLER
			    " says, \"Go ask the correct teller.\"" CR>)
		     (ELSE
		      <ASK-CHAR-ABOUT ,TELLER .OBJ ,TELLER-SUBJECTS 0>)>)
	      (<OR <T? .ADF>
		   <AND <==? .OBJ ,PRSO> <ZERO? <ZGET ,P-ADJW 0>>>
		   <AND <==? .OBJ ,PRSI> <ZERO? <ZGET ,P-ADJW 0>>>>
	       <TELL CTHE ,TELLER " says, \"I don't have any here.\"" CR>)
	      (<EQUAL? .OBJ ,MONEY ,CHECK ,WFORM ,DFORM>
	       <TELL CTHE ,TELLER
		     " says, \"Go ask the correct teller.\"" CR>)
	      (<==? .OBJ ,QUEEN-MUM>
	       <TELL "\"Who? No one I've ever heard of.\"" CR>)
	      (ELSE
	       <MORE-TELLER-INTERACTION .SCR>)>
	T>

<DEFINE CHECK-CHECK (OBJ GIVE)
	<COND (<==? .OBJ ,CHECK>
	       <TELLER-IDLE <>>
	       <TELL <ZGET ,CASH-CHECK-SCRIPT ,TELLER-THIRD> CR>
	       <MOVE .OBJ ,TELLER>
	       <TELLER-STATE ,STATE-RUN-F2>
	       T)
	      (ELSE
	       <>)>>

<DEFINE CHECK-BRUSH-OFF (OBJ GIVE)
	<COND (<NOT <IN? ,CHECK ,TELLER>> <>)
	      (<EQUAL? .OBJ ,BEEZER ,EXCESS ,VISA>
	       <TELL CTHE ,TELLER " looks at " THE .OBJ>
	       <COND (.GIVE <TELL " and returns it to you">)>
	       <TELL ". She ">
	       <COND (.GIVE <TELL "also ">)>
	       <TELL "returns your " D ,CHECK " to you. She says, \"Your ID's OK, but I'm afraid I've run out of negative money; the Treasury has it all.\"" CR>
	       <MOVE ,CHECK ,PLAYER>
	       <TELLER-STATE ,STATE-INIT>
	       T)
	      (ELSE
	       <>)>>

<DEFINE WITHDRAW-CHECK (OBJ GIVE)
	<COND (<==? .OBJ ,WFORM>
	       <COND (<==? <TELLER-AMOUNT-ON-WITHDRAWAL-FORM> 0>
		      <TELL CTHE ,TELLER
			    " asks you to fill out the withdrawal slip."
			    CR>)
		     (ELSE
		      <ZREMOVE ,WFORM>
		      <TELL <ZGET ,WITHDRAWAL-SCRIPT ,TELLER-THIRD> CR>
		      <TELLER-STATE ,STATE-RUN-F2>)>
	       T)
	      (<==? .OBJ ,DFORM>
	       <TELL CTHE ,TELLER " looks at " THE ,DFORM " and says, \"If you planned on depositing a negative check here, you've got the right idea but I can't really help you.\"" CR>
	       T)
	      (<==? .OBJ ,CHECK>
	       <W-CHECK>
	       T)
	      (ELSE <>)>>

<SETG BANK-SCORED? <>>

<DEFINE WITHDRAWAL-BRUSH-OFF (OBJ GIVE "AUX" W:FIX B:FIX TB:FIX
			      (DO-HUNGER? <>) (DO-SCORE? <>))
	<COND (<T? <LOC ,WFORM>> <>)
	      (<==? .OBJ ,CHECK> <W-CHECK>)
	      (<EQUAL? .OBJ ,BEEZER ,EXCESS ,VISA>
	       <TELL CTHE ,TELLER " looks at " THE .OBJ>
	       <COND (.GIVE <TELL " and returns it to you">)>
	       <SET W
		    <TELLER-AMOUNT-ON-WITHDRAWAL-FORM>>
	       <TELLER-AMOUNT-ON-WITHDRAWAL-FORM 0>
	       <SET B <TELLER-AMOUNT-IN-ACCT>>
	       <SET TB <- .B .W>>
	       <COND (<T? <GETP ,WFORM ,P?LOSING>>
		      <TELL ". She says, \"Your ID doesn't correspond with your "
			    D ,WFORM>)
		     (<AND <G? .W 0> <G=? .TB ,MINIMUM-BALANCE>>
		      <TELL ". She hands you your money and says, \"Your new balance is ">
		      <MONEY-D .TB>
		      <TELLER-AMOUNT-IN-ACCT .TB>
		      <SET DO-HUNGER? T>
		      <THIS-IS-IT ,MONEY>
		      <COND (<IN? ,MONEY ,PLAYER>
			     <SETG CASH <+ ,CASH .W>>)
			    (ELSE
			     <MOVE ,MONEY ,PLAYER>
			     <COND (<NOT ,BANK-SCORED?> <SET DO-SCORE? T>)>
			     <SETG CASH .W>)>)
		     (ELSE
		      <COND (<OR <L? .W 0> <L? .TB 0>>
			     <TELL ". She says, \"I'm afraid you have only ">
			     <MONEY-D .B>
			     <TELL " in your account. That is insufficient to cover your withdrawal">)
			    (ELSE
			     <TELL ". She says, \"You have only ">
			     <MONEY-D .B>
			     <TELL " in your account. That withdrawal would put your balance below the minimum balance of $10">)>)>
	       <TELL ". Have a nice day.\"" CR>
	       <TELLER-STATE ,STATE-INIT>
	       <COND (<AND .DO-HUNGER?
			   <QUEUED? I-HUNGER>
			   <L? ,HUNGER 180>>
		      <COND (<L? ,HUNGER 160>
			     <SETG HUNGER 159>
			     <I-HUNGER>)>
		      <SETG HUNGER 180>)
		     (T
		      <UPDATE-BP 3>)>
	       <COND (.DO-SCORE?
		      <SETG BANK-SCORED? T>
		      <UPDATE-SCORE 1>)>
	       T)
	      (ELSE <>)>>

<DEFINE W-CHECK ()
	<TELL CTHE ,TELLER " glances at " THE ,CHECK " and says, \"Withdrawing a negative check is like making a deposit. I can't do that.\"" CR>>

<DEFINE DEPOSIT-CHECK (OBJ GIVE "AUX" (FORM? <>))
	<SET FORM? <D-FORM?>>
	<COND (<OR <AND <==? .OBJ ,DFORM>
			<==? <TELLER-AMOUNT-ON-DEPOSIT-FORM> 0>>
		   <AND <==? .OBJ ,WFORM>
			<==? <TELLER-AMOUNT-ON-WITHDRAWAL-FORM> 0>>>
	       <TELL CTHE ,TELLER " asks you to fill out " THE .OBJ
		     ,PERIOD>
	       T)
	      (<AND <==? .OBJ ,MONEY> <NOT ,P-DOLLAR-FLAG>>
	       <SPECIFY-AN-AMOUNT>
	       <ZCRLF>
	       T)
	      (<EQUAL? .OBJ ,DFORM ,WFORM ,CHECK ,MONEY>
	       <COND (<AND <==? .OBJ ,MONEY> <N==? ,CASH ,P-NUMBER>>
		      <TELLER-CASH-GIVEN
			    <+ <TELLER-CASH-GIVEN>
			       ,P-NUMBER>>
		      <REDUCE-CASH>)
		     (<EQUAL? .OBJ ,DFORM ,WFORM>
		      <ZREMOVE .OBJ>
		      <SET FORM? T>)
		     (ELSE
		      <MOVE .OBJ ,TELLER>)>
	       <COND (<AND .FORM?
			   <OR <IN? ,CHECK ,TELLER>
			       <IN? ,MONEY ,TELLER>
			       <N==? <TELLER-CASH-GIVEN>
				     0>>>
		      <TELL <ZGET ,DEPOSIT-SCRIPT ,TELLER-THIRD> CR>
		      <TELLER-STATE ,STATE-RUN-F2>)
		     (ELSE
		      <TELL "She takes " THE .OBJ " and asks you for the ">
		      <COND (<EQUAL? .OBJ ,DFORM ,WFORM>
			     <TELL "cheque or money." CR>)
			    (ELSE
			     <TELL "deposit slip." CR>)>)>
	       T)
	      (ELSE <>)>>

<DEFINE D-FORM? ()
	<COND (<AND <F? <LOC ,DFORM>> <N==? <TELLER-AMOUNT-ON-DEPOSIT-FORM> 0>>
	       ,DFORM)
	      (<AND <F? <LOC ,WFORM>>
		    <N==? <TELLER-AMOUNT-ON-WITHDRAWAL-FORM> 0>>
	       ,WFORM)>>

<DEFINE DEPOSIT-BRUSH-OFF (OBJ GIVE "AUX" W:FIX B:FIX TB:FIX (FRM <>))
	<SET FRM <D-FORM?>>
	<COND (<AND .FRM
		    <OR <N==? <TELLER-CASH-GIVEN> 0>
			<IN? ,MONEY ,TELLER>
			<IN? ,CHECK ,TELLER>>>
	       <COND (<EQUAL? .OBJ ,BEEZER ,EXCESS ,VISA>
		      <TELL CTHE ,TELLER " looks at " THE .OBJ>
		      <COND (.GIVE <TELL " and returns it to you">)>
		      <COND (<==? .FRM ,DFORM>
			     <SET W
				  <TELLER-AMOUNT-ON-DEPOSIT-FORM>>
			     <TELLER-AMOUNT-ON-DEPOSIT-FORM 0>)
			    (ELSE
			     <SET W
				  <TELLER-AMOUNT-ON-WITHDRAWAL-FORM>>
			     <TELLER-AMOUNT-ON-WITHDRAWAL-FORM 0>)>
		      <SET B <TELLER-AMOUNT-IN-ACCT>>
		      <SET TB <+ .B .W>>
		      <COND (<T? <GETP .FRM ,P?LOSING>>
			     <TELL ". She says (while returning your ">
			     <COND (<OR <G? <TELLER-CASH-GIVEN> 0>
					<IN? ,MONEY ,TELLER>>
				    <TELL "cash">
				    <COND (<NOT <IN? ,MONEY ,PLAYER>>
					   <MOVE ,MONEY ,PLAYER>)>
				    <SETG CASH <+ <TELLER-CASH-GIVEN>
						  ,CASH>>)
				   (T
				    <TELL "cheque">
				    <MOVE ,CHECK ,PLAYER>)>
			     <TELL "), \"Your ID doesn't correspond to your "
				   D .FRM>)
			    (<AND <==? .FRM ,DFORM> <IN? ,CHECK ,TELLER>>
			     <TELL ". She says (while returning your cheque), \"I'd need another ">
			     <MONEY-D <+ 7500 .W>>
			     <TELL " to complete this transaction. Perhaps you should try the withdrawal window">
			     <MOVE ,CHECK ,PLAYER>)
			    (<AND <==? .FRM ,WFORM> <NOT <IN? ,CHECK ,TELLER>>>
			     <TELL ". She says (while returning your money), \"This won't do. You must use a deposit slip">
			     <COND (<NOT <IN? ,MONEY ,PLAYER>>
				    <MOVE ,MONEY ,PLAYER>)>
			     <SETG CASH <+ <TELLER-CASH-GIVEN>
					   ,CASH>>)
			    (<OR <AND <IN? ,CHECK ,TELLER>
				      <==? .W ,CHECK-AMOUNT>>
				 <AND <IN? ,MONEY ,TELLER> <==? ,CASH .W>>
				 <==? .W <TELLER-CASH-GIVEN>>>
			     <TELLER-AMOUNT-IN-ACCT .TB>
			     <TELL ". She says, \"">
			     <COND (<IN? ,CHECK ,TELLER>
				    <TELL "Let's see, you are depositing -$75 using a withdrawal slip. Since a withdrawal slip is the negative of a deposit slip, negative of -$75 is $75. It all makes perfect sense. ">
				    <ZREMOVE ,CHECK>)>
			     <TELL "Your new balance is ">
			     <MONEY-D .TB>)
			    (<NOT <IN? ,CHECK ,TELLER>>
			     <TELL ". She says (while returning your cash), \"You gave me ">
			     <COND (<IN? ,MONEY ,TELLER> <MONEY-D ,CASH>)
				   (ELSE <MONEY-D <TELLER-CASH-GIVEN>>)>
			     <TELL ", but your deposit slip says ">
			     <COND (<G? .W 0> <MONEY-D .W>)
				   (ELSE
				    <TELL "$">
				    <SHOW-FIELD ,BANK-AMOUNT
						,BANK-FORM-DEPOSIT>)>
			     <COND (<IN? ,MONEY ,TELLER> <MOVE ,MONEY ,PLAYER>)
				   (ELSE
				    <SETG CASH <+ <TELLER-CASH-GIVEN>
						  ,CASH>>)>)
			    (ELSE
			     <TELL ". She says (while returning your cheque), \"You must deposit exactly the check amount">
			     <MOVE ,CHECK ,PLAYER>)>
		      <TELL ". Have a nice day.\"" CR>
		      <TELLER-STATE ,STATE-INIT>
		      T)
		     (ELSE <>)>)
	      (ELSE <>)>>

<OBJECT TELLER-SIGN
	(LOC BANK)
	(FLAGS NODESC)
	(DESC "teller window sign")
	(SYNONYM SIGN)
	(ADJECTIVE TELLER)
	(ACTION TELLER-SIGN-F)>

<DEFINE TELLER-SIGN-F ()
  <COND (<VERB? READ EXAMINE>
	 <SAY-SIGN>)
	(T <>)>>

<DEFINE SAY-SIGN ("AUX" SCR)
  <SET SCR <TELLER-CURRENT-SCRIPT>>
  <COND (<T? .SCR>
	 <TELL "This window has a sign above it that says:" CR
	       <ZGET .SCR ,TELLER-SIGNS>>)
	(T
	 <TELL "A sign on the window says ">
	 <ITALICIZE "NEXT WINDOW PLEASE">)>
  <TELL ,PERIOD>>

<DEFINE MATCH-TELLER-NAME (ADJ NAM ARG "AUX" NUM)
  <COND (<AND <EQUAL? .ADJ ,W?TELLER ,W?WINDOW>
	      <==? .NAM ,W?INTNUM>>
	 <COND (<OR <G? ,P-NUMBER ,NUMBER-TELLERS>
		    <L=? ,P-NUMBER 0>
		    <NOT <HERE? BANK>>>
		<>)
	       (T
		<SETG NEW-TELLER ,P-NUMBER>
		,TELLER-WINDOWS)>)
	(<EQUAL? .NAM ,W?TELLER ,W?WINDOW ,W?WINDOWS>
	 <COND (<EQUAL? .ADJ <> ,W?TELLER>
		<SETG NEW-TELLER -1>
		,TELLER-WINDOWS)
	       (<==? .ADJ ,W?NEXT>
		<COND (<OR <==? <SET NUM <TELLER-NUMBER>>
				0>
			   <==? .NUM ,NUMBER-TELLERS>>
		       <>)
		      (T
		       <SETG NEW-TELLER <+ .NUM 1>>
		       ,TELLER-WINDOWS)>)
	       (T <>)>)
	(T <>)>>

<VOC "NEXT" ADJ>

<SETG HOLDING-FOR-PONGO? <>>
<SETG HOLDING-FOR-ADDRESS? <>>

<DEFINE HOLD-BANK ()
  <ITALICIZE "Click">
  <TELL "! You hear ">
  <SAY-MUZAK>
  <ZPRINT ,PERIOD>
  <SETUP-BANKMUSIC>>

<DEFINE I-BANK IB ("OPTIONAL" (CR T) "AUX" Y:<OR FIX FALSE> WHO)
	 <COND (<NOT <VISIBLE? ,MACHINE>>
		<RETURN <> .IB>)>
	 <NEXT-TOON>
	 <COND (<T? .CR>
		<ZCRLF>)>
	 <SET Y <BANKTALK>>
	 <COND (<T? .Y>
		<SET WHO <ZGET <GETPT ,BANKSOUND ,P?SYNONYM> 0>>
		<COND (<G? <SET Y <+ .Y 1>> 3>
		       <COND (<EQUAL? .WHO ,W?BONGO>
			      <TELL
"\"Yap yap yap!\" says Bongo. \"Be right back!">)
			     (T
			      <IN-CAPS .WHO>
			      <COND (<PROB 50>
				     <TELL " coughs discreetly">)
				    (T
				     <TELL " clears ">
				     <COND (<IS? ,BANKSOUND ,FEMALE>
					    <TELL "her">)
					   (T
					    <TELL "his">)>
				     <TELL " throat">)>
		       	      <TELL 
". \"Let me put you on hold for a moment">
		       	      <PONGO-MAAM .WHO>
		       	      <TELL ".">)>
		       <TELL "\"" CR CR>
		       <HOLD-BANK>
		       <RETURN T .IB>)>
		<BANKTALK .Y>
		<COND (<EQUAL? .Y 3>
		       <COND (<EQUAL? .WHO ,W?BONGO>
			      <TELL "Bongo says, \"Bark bark bark!\"" CR>
			      <RETURN T .IB>)>
		       <TELL "\"Is there anything else I can do for you">
		       <PONGO-MAAM .WHO>
		       <TELL "?\" asks ">
		       <IN-CAPS .WHO>
		       <TELL " brightly." CR>
		       <RETURN T .IB>)
		      (<EQUAL? .WHO ,W?BONGO>
		       <TELL "\"Yap yap yap!\" says Bongo." CR>
		       <RETURN T .IB>)>
		<IN-CAPS .WHO>
		<TELL " asks, \"How exactly may I help you">
		<PONGO-MAAM .WHO>
		<TELL "?\"" CR>
		<RETURN T .IB>)
	       (<KEEP-HOLDING? 5>
		<TELL CTHE ,GBANK " plays you ">
		<SAY-MUZAK>
		<ZPRINT ,PERIOD>
		<RETURN T .IB>)>
	 <SET WHO <SETUP-BANKSOUND>>
	 <TELL "A ">
	 <COND (<EQUAL? .WHO ,W?PONGO>
		<TELL "high, raspy">)
	       (<EQUAL? .WHO ,W?BONGO>
		<TELL "squeaky cartoon">)
	       (T
		<TELL "young ">
		<COND (<EQUAL? .WHO ,W?PAULETTE ,W?NANCY>
		       <TELL "wo">)>
		<TELL "man's">)>
	 <TELL " voice interrupts ">		
	 <SAY-MUZAK>
	 <TELL ". \"Thank you for waiting. ">
	 <COND (<T? ,HOLDING-FOR-ADDRESS?>
		<SETG HOLDING-FOR-ADDRESS? <>>
		<SETG HOLDING-FOR-PONGO? <>>
		<TELL "I checked our records, and we sent a change-of-address
form to you at 5 Hippo Vista in Rhinoceros. Since bank policy prohibits more
than one outstanding change-of-address form per customer, we can't do anything
more until you return that. Thank you for calling Fillmore, and have a nice
day.\"" CR CR>
		<ITALICIZE "Click!">
		<TELL " You hear a dialling tone, and hang up." CR>
		<UNMAKE ,MACHINE ,SEEN>
		<BANKSOUND-OFF>
		T)
	       (<T? ,HOLDING-FOR-PONGO?>
		<SETG HOLDING-FOR-PONGO? <>>
		<TELL "I talked to Pongo, who said, '"
		      PONE ,PONGO-STUFF
		      "'\"" CR>)
	       (T
		<TELL "My name is ">
		<IN-CAPS .WHO>
		<COND (<EQUAL? .WHO ,W?BONGO ,W?PONGO>
		       <TELL ", the Bank ">
		       <COND (<EQUAL? .WHO ,W?BONGO>
			      <TELL "Dog">)
			     (T
			      <TELL "Parrot">)>)>
		<TELL ". ">
		<COND (<EQUAL? .WHO ,W?BONGO>
		       <TELL "Ruff ruff ruff!\"" CR>
		       <RETURN T .IB>)>
		<TELL "How may I help you?\"" CR>
		<RETURN T .IB>)>>
		
<CONSTANT PONGO-STUFF
	  <PLTABLE "Squawk! Pongo want a cracker!"
		   "We make it easy for you! Squawk!"
		   "Squawk! Children have feelings, too! Squawk!"
		   "Consider us your friend! Squawk! Squawk!">>

<DEFINE PONGO-MAAM (WHO)
	 <COND (<NOT <EQUAL? .WHO ,W?PONGO>>
		<TELL ", ">
		<SIR-OR-MAAM>)>>
	 
<VOC "PROBLEM" NOUN> <VOC "COMPLAINT" NOUN> <VOC "TROUBLE" NOUN>
<VOC "ADDRESS" <>> <VOC "CUSTOMER" NOUN> <VOC "SERVICE" NOUN>
<VOC "FORMS" NOUN>

<DEFINE BANKWORD? BW (PTR:FIX
		      "AUX" (CREDIT <>) (ADDR <>) (PROBLEM <>) LEN:FIX WRD
			    (BONGO? <>) (MONEY? <>) (FORM <>) (FIRST 2)
			    (BAL <>) (PERSON <>) (HOLD <>))
	 <SET WRD <BANKTALK>>
	 <SET WRD <ZGET <GETPT ,BANKSOUND ,P?SYNONYM> 0>>
	 <COND (<EQUAL? .WRD ,W?BONGO>
		<SET BONGO? T>)>
	 <SET LEN ,P-LEN>
	 <REPEAT ()
		 <COND (<L? <SET LEN <- .LEN 1>> 0>
			<RETURN>)>
		 <SET WRD <ZGET ,P-LEXV .PTR>>
		 <COND (<EQUAL? .WRD ,W?HOLD>
			<SET HOLD .WRD>)
		       (<EQUAL? .WRD ,W?FORM ,W?FORMS>
			<SET FORM .WRD>)
		       (<OR <EQUAL? .WRD ,W?PROBLEM ,W?COMPLAINT ,W?TROUBLE>
		    	    <EQUAL? .WRD ,W?CUSTOMER ,W?SERVICE>>
			<SET PROBLEM .WRD>)
	       	       (<EQUAL? .WRD ,W?ADDRESS>
			<SET ADDR .WRD>)
	       	       (<EQUAL? .WRD ,W?MONEY ,W?CASH>
			<SET MONEY? .WRD>)
		       (<OR <EQUAL? .WRD ,W?CREDIT ,W?CARD ,W?BEEZER>
		    	    <EQUAL? .WRD ,W?EXCESS>>
			<SET CREDIT .WRD>)
		       (<==? .WRD ,W?BALANCE>
			<SET BAL .WRD>)
		       (<AND <L=? .FIRST 0>
			     <OR <EQUAL? .WRD ,W?BONGO ,W?PONGO ,W?PAULETTE>
				 <EQUAL? .WRD ,W?CLINT ,W?ROGER ,W?NANCY>>>
			<SET PERSON .WRD>)>
		 <SET FIRST <- .FIRST 1>>
		 <SET PTR <+ .PTR ,P-LEXELEN>>>
	 <COND (<AND <T? .BONGO?>
		     <OR <T? .PROBLEM>
			 <T? .ADDR>
			 <T? .CREDIT>
			 <T? .MONEY?>
			 <T? .FORM>
			 <T? .BAL>
			 <T? .PERSON>
			 <T? .HOLD>>>
		<TELL PNEXT ,BONGO-STUFF CR CR>
		<ITALICIZE "Click!">
		<TELL " You hear a dialling tone, and hang up." CR>
		<UNMAKE ,MACHINE ,SEEN>
		<BANKSOUND-OFF>
		<RETURN T .BW>)
	       (<T? .FORM>
		<TELL "\"You can obtain any forms you need at your local branch of Fillmore Fiduciary.\"" CR>)
	       (<T? .PROBLEM>
		<TELL "\"Any difficulties you may be experiencing ">
		<COND (<T? .ADDR>
		       <TELL "with addressing ">)
		      (<T? .CREDIT>
		       <TELL "with credit cards ">)>
		<TELL 
"should be addressed to our Customer Service Department.\"" CR>)
	       (<T? .ADDR>
		<TELL "\"If you could hold for just a second, I'll look into that.\" ">
		<SETG HOLDING-FOR-PONGO? .WRD>
		<SETG HOLDING-FOR-ADDRESS? T>
		<HOLD-BANK>
		<RETURN T .BW>)
	       (<T? .CREDIT>
		<TELL 
"\"Our Credit Card Department may be able to help.\"" CR>)
	       (<T? .PERSON>
		<TELL "\"Any comments you may have about bank personnel should
be submitted on FFT Form 98/7/203/G/I/G/O. It's out of stock here, but I think
the Auckland branch has some.\"" CR>)
	       (<T? .MONEY?>
		<TELL
		 "\"We're very fond of money here at Fillmore Fiduciary.\""
		 CR>)
	       (<T? .BAL>
		<TELL
		 "\"We can't discuss account balances on the phone.\"" CR>)
	       (<T? .HOLD>
		<TELL "\"No, ">
		<ITALICIZE "we">
		<TELL " tell ">
		<ITALICIZE "you">
		<TELL " when to hold.\"" CR>)
	       (T
		<RETURN <> .BW>)>
	 <BANKTALK 3>
	 <RETURN T .BW>>

<OBJECT BANKSOUND
	(LOC GLOBAL-OBJECTS)
	(DESC "that sound")
	(SDESC SAY-BANKSOUND)
	(FLAGS NODESC INVISIBLE)
	(SYNONYM ZZZP ZZZP ZZZP SOUND
	 	 PAULETTE NANCY BONGO DOG PONGO PARROT)
	(ADJECTIVE BANK)
	(GENERIC GENERIC-SOUND)
        (ACTION BANKSOUND-F)>

<DEFINE SAY-BANKSOUND ("AUX" X)
	 <SET X <ZGET <GETPT ,BANKSOUND ,P?SYNONYM> 0>>
	 <COND (<EQUAL? .X ,W?MUSIC>
		<DO-PRINT-WORD .X>)
	       (T
		<IN-CAPS .X>)>>

<VOC "MUZAK" NOUN> <VOC "PARROT" NOUN> <VOC "DOG" NOUN>

<DEFINE BANKSOUND-OFF ()
	 <MAKE ,BANKSOUND ,INVISIBLE>
	 <MAKE ,BANKSOUND ,NODESC>
	 <BANKTALK 0>
	 <SETG HOLDING-FOR-PONGO? <>>
	 <DEQUEUE I-BANK>>

<DEFINE SETUP-BANKSOUND SB ("AUX" TBL X Y)
	 <SETG HOLD-TURNS 0>
	 <BANKTALK 1>
	 <UNMAKE ,BANKSOUND ,INVISIBLE>
	 <MAKE ,BANKSOUND ,NOARTICLE>
	 <MAKE ,BANKSOUND ,LIVING>
	 <MAKE ,BANKSOUND ,PERSON>
	 <SET TBL <GETPT ,BANKSOUND ,P?SYNONYM>>
	 <ZPUT .TBL 2 ,W?VOICE>
	 <COND (<OR ,HOLDING-FOR-PONGO? <PROB 33>>
		<COND (,HOLDING-FOR-PONGO?
		       <SET X ,HOLDING-FOR-PONGO?>)
		      (T
		       <SET X <PICK-NEXT ,BANKNAMES>>)>
		<COND (<EQUAL? .X ,W?PAULETTE ,W?NANCY>
		       <MAKE ,BANKSOUND ,FEMALE>
		       <SET Y ,W?WOMAN>)
		      (T
		       <SET Y ,W?MAN>)>)
	       (<PROB 50>
		<SET X ,W?BONGO>
		<SET Y ,W?DOG>)
	       (T
		<SET X ,W?PONGO>
		<SET Y ,W?PARROT>)>
	 <ZPUT .TBL 0 .X>
	 <ZPUT .TBL 1 .Y>
	 <THIS-IS-IT ,BANKSOUND>
	 <RETURN .X .SB>>

<CONSTANT BONGO-STUFF
	  <TABLE (LENGTH PATTERN (BYTE [REST WORD]))
		 #BYTE 0
		  "Bongo says, \"You'll have to pardon me, there seems to
be a cat in the bank.\" You hear the screech of a cat, the scream of an old
woman, several very fragile things being knocked off shelves, another screech
from the cat, then someone yelling, \"Bad dog! Bad! Bad!\" Finally Bongo
returns, panting, \"Hello, this is Bongo. Sorry, I forgot what we were talking
about. Please call back.\""
		  "Bongo says, \"It's time for my walk. You'll have to call
back.\""
		  "Bongo says, \"There seems to be a bone on the floor here,
so I'll be busy for a while. Please call back later.\"">>

<DEFINE BANKSOUND-F BF ("OPTIONAL" (CONTEXT <>) "AUX" (BSNAME <>) STR)
	<COND (<IS? ,BANKSOUND ,NODESC>
	       <COND (<VERB? PHONE>
		      <COND (<IS? ,PAGE-2 ,SEEN>
			     <SETG P-NUMBER
				   <ZGET ,PHONE-NUMBERS ,BANK-NUMBER-X>>
			     <SETG P-NUMBER
				   <ZGET ,PHONE-NUMBERS ,BANK-NUMBER>>
			     <PERFORM ,V?PHONE ,INTNUM>)
			    (T
			     <PERFORM ,V?PHONE ,ROOMS>)>
		      T)
		     (T
		      <REFERRING>
		      ,FATAL-VALUE)>)
	      (<==? <BANKTALK> 0>
	       <TELL "You're still on hold." CR>)
	      (<EQUAL? .CONTEXT ,M-WINNER>
	       <SETG WINNER ,PLAYER>
	       <PERFORM ,V?ASK-ABOUT ,BANKSOUND>
	       ,FATAL-VALUE)
	      (<T? .CONTEXT> <>)
	      (<VERB? TELL>
	       <COND (<SET STR <CHECK-OZ-ROYALTY ,BANKSOUND T>>
		      <TELL CTHEO " whispers, \"" .STR ".\"" CR>)
		     (T <>)>)
	      (<AND <THIS-PRSI?>
		    <VERB? GIVE>>
	       <TELL "Although " Q ,PRSI " would undoubtedly like having that,
you can't really do much giving over the phone." CR>)
	      (<VERB? ASK-ABOUT ASK-FOR>
	       <SET BSNAME <ZGET <GETPT ,BANKSOUND ,P?SYNONYM> 0>>
	       <COND (<==? .BSNAME ,W?PONGO>
		      <TELL "\"Squawk! Pongo want a dollar!\"" CR>)
		     (<==? .BSNAME ,W?BONGO>
		      <TELL "\"Yap, yap, yap.\"" CR>)
		     (T
		      <IN-CAPS .BSNAME>
		      <COND (<VERB? HELLO THANK>
			     <TELL " grunts in response." CR>)
			    (T
			     <SETG HOLDING-FOR-PONGO? .BSNAME>
			     <TELL " says, \"I'll have to ask my supervisor. Please hold.\"" CR CR>
			     <HOLD-BANK>)>)>
	       ,FATAL-VALUE)
	      (<VERB? HANGUP>
	       <COND (<IS? ,MACHINE ,SEEN>
		      <UNMAKE ,MACHINE ,SEEN>
		      <BANKSOUND-OFF>
		      <TELL "You slam the receiver down with a satisfying ">
		      <ITALICIZE "crash">
		      <TELL ,PCR>
		      <UPDATE-BP -2>)
		     (T
		      <TELL "You aren't on the phone." CR>)>
	       T)
	      (<OR <TOUCHING?>
		   <VERB? EXAMINE>>
	       <CANT-FROM-HERE>
	       T)
	      (T
	       <>)>>

<DEFINE SETUP-BANKMUSIC ("AUX" TBL)
	 <BANKTALK 0>
	 <UNMAKE ,BANKSOUND ,LIVING>
	 <UNMAKE ,BANKSOUND ,PERSON>
	 <UNMAKE ,BANKSOUND ,FEMALE>
	 <UNMAKE ,BANKSOUND ,NOARTICLE>
	 <SET TBL <GETPT ,BANKSOUND ,P?SYNONYM>>
	 <ZPUT .TBL 0 ,W?MUSIC>
	 <ZPUT .TBL 1 ,W?MUZAK>
	 <ZPUT .TBL 2 ,W?ZZZP>
	 <SETG P-IT-OBJECT ,BANKSOUND>
	 <SETG P-HIM-OBJECT ,NOT-HERE-OBJECT>
	 <SETG P-HER-OBJECT ,NOT-HERE-OBJECT>>
