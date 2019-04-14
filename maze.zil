"MAZE for BUREAUCRACY: Copyright 1987 Infocom, Inc. All rights reserved."

<FILE-FLAGS MDL-ZIL?>

<INCLUDE "COMPUTERDEFS">

<OBJECT MAZE-ROOM
	(LOC ROOMS)
	(SYNONYM NUMBER INSCRIPTION GEAR SWITCHGEAR)
	(ADJECTIVE SWITCH)
	(SDESC SDESC-MAZE)
	(FLAGS PLACE NODESC LIGHTED INDOORS NOARTICLE)
	(EAST PER MAZE-EXIT)
	(WEST PER MAZE-EXIT)
	(NORTH PER MAZE-EXIT)
	(SOUTH PER MAZE-EXIT)
	(UP PER MAZE-EXIT)
	(DOWN PER MAZE-EXIT)
	(OUT PER MAZE-EXIT)
	(ACTION MAZE-ROOM-F)>

<SETG CURRENT-MAZE-ROOM 0>
<SETG LAST-MAZE-ROOM 0>
<MSETG MAZE-STEPS 6>
<SETG MAZE-STEPS-TAKEN 0>
<SETG MAZE-LOSING? <>>

<DEFINE MAZE-ROOM-F ("OPT" (CONTEXT <>) "AUX" DIF)
  <COND (<==? .CONTEXT ,M-LOOK>
	 <TELL "You are in a switchgear room, with exits in all directions.
Inscribed on the wall is the number " N ,CURRENT-MAZE-ROOM ,PERIOD>)
	(<AND <==? .CONTEXT ,M-BEG>
	      <VERB? SAVE>>
	 <TELL "Under Article 42 of the Cambridge Convention, we are required
to notify you that using SAVE won't help you to solve this maze. For further
information, contact the Commission for Helping Out Maze Players." CR>
	 <>)
	(<==? .CONTEXT ,M-ENTERING>
	 <UNMAKE ,MAZE-ROOM ,TOUCHED>
	 <COND (<0? ,CURRENT-MAZE-ROOM:FIX>
		<SETG MAZE-STEPS-TAKEN 0>)>
	 <SETG LAST-MAZE-ROOM ,CURRENT-MAZE-ROOM>
	 ; "Make sure the maze room number is always bigger"
	 <SETG CURRENT-MAZE-ROOM <+ <ZRANDOM 12>:FIX
				    <* ,MAZE-STEPS-TAKEN:FIX 25>>>
	 ; "Now adjust this so the last digit of the difference is between
	    0 and 5:  suppose the difference is 11. We add 8, making the
	    difference 19, then add something between 1 and 6, giving something
	    from 20 to 25. Similarly, if the difference is 8, we add 1,
	    the difference is 9, and win again."
	 <SETG CURRENT-MAZE-ROOM
	       <+ ,CURRENT-MAZE-ROOM:FIX
		  <- 9 <MOD <- ,CURRENT-MAZE-ROOM:FIX ,LAST-MAZE-ROOM:FIX> 10>>
		  <ZRANDOM 6>:FIX>>
	 <POLICE-AREA ,MAZE-ROOM <> ,IN-CLEARING>)
	(<T? .CONTEXT> <>)
	(<AND <VERB? READ EXAMINE>
	      <NOUN-USED? ,W?NUMBER ,W?INSCRIPTION>>
	 <COND (<AND <N==? ,HERE ,MAZE-ROOM>
		     <F? <GETP ,HERE ,P?STADDR>>>
		<CANT-SEE-ANY-STR "any number">)
	       (T
		<TELL "It's just an unadorned inscription of the number ">
		<COND (<GETP ,HERE ,P?STADDR>
		       <TELL N <GETP ,HERE ,P?STADDR>>)
		      (T
		       <TELL N ,CURRENT-MAZE-ROOM>)>
		<TELL ,PERIOD>)>)>>

<DEFINE SDESC-MAZE ()
  <TELL "Switchgear room " N ,CURRENT-MAZE-ROOM>>

<DEFINE MAZE-EXIT ()
  <SETG OLD-HERE <>>
  <COND (<0? ,MAZE-STEPS-TAKEN:FIX>
	 <SETG MAZE-STEPS-TAKEN 1>
	 ,MAZE-ROOM)
	(T
	 ; "New theory:  don't fall back into jungle until right number
	    of steps taken..."
	 <COND (<F? <CHECK-MAZE>>
		; "Losing, don't forget to screw the guy later"
		<SETG MAZE-LOSING? T>)>
	 <SETG MAZE-STEPS-TAKEN <+ ,MAZE-STEPS-TAKEN:FIX 1>>
	 <COND (<==? ,MAZE-STEPS-TAKEN ,MAZE-STEPS>
		<SETG MAZE-STEPS-TAKEN 0>
		<SETG CURRENT-MAZE-ROOM 0>
		<COND (,MAZE-LOSING?
		       <SETG MAZE-LOSING? <>>
		       ,IN-CLEARING)
		      (T
		       ,INNER-ROOM)>)
	       (T
		,MAZE-ROOM)>)>>

<DEFINE CHECK-MAZE ("AUX" N:FIX DIR)
  ; "CURRENT-MAZE-ROOM always > LAST-MAZE-ROOM; get the last digit of the
     difference"
  <SET N <MOD <- ,CURRENT-MAZE-ROOM ,LAST-MAZE-ROOM> 10>>
  <COND (<==? .N 0> <SET DIR ,P?EAST>)
	(<==? .N 1> <SET DIR ,P?SOUTH>)
	(<==? .N 2> <SET DIR ,P?UP>)
	(<==? .N 3> <SET DIR ,P?NORTH>)
	(<==? .N 4> <SET DIR ,P?DOWN>)
	(<==? .N 5> <SET DIR ,P?WEST>)>
  <COND (<==? ,P-WALK-DIR .DIR> T)
	(T <>)>>

;"ODD-GATE-SOLVED? determines whether gate appears here or not..."
<OBJECT INNER-ROOM
	(LOC ROOMS)
	(DESC "Airlock")
	(FLAGS PLACE LIGHTED INDOORS NO-NERD)
	(ACTION INNER-ROOM-F)
	(IN PER ENTER-IN-INNER)
	(NORTH PER ENTER-COMPLEX)
	(SOUTH SORRY "You can't find the entrance you must undoubtedly have used.")
	(WEST PER ENTER-CARD-ROOM)>

<DEFINE ENTER-IN-INNER ("AUX" (CT 0) (GATE-OK? <>))
	<COND (<AND <==? ,ODD-GATE-SOLVED? ,HERE>
		    <IS? ,ODD-GATE ,OPENED>>
	       ; "Gate is open"
	       <SET GATE-OK? T>
	       <SET CT <+ .CT 1>>)>
	<COND (<IS? ,OTHER-TRAP-DOOR ,OPENED>
	       ; "Trap door is open"
	       <SET CT <+ .CT 1>>)>
	<COND (<==? .CT 1>
	       ; "Only one place to enter"
	       <COND (.GATE-OK?
		      ; "It's the gate"
		      <DO-WALK ,P?WEST>
		      <>)
		     (T
		      ; "The complex"
		      <ENTER-COMPLEX>)>)
	      (T
	       <TELL "Which way do you want to go?" CR>
	       <>)>>

<DEFINE INNER-ROOM-F ("OPT" (CONTEXT <>) "AUX" VEC)
  <COND (<==? .CONTEXT ,M-ENTERING>
	 <COND (<N==? ,ODD-GATE-SOLVED? ,IN-CLEARING>
		<MOVE ,ODD-GATE ,INNER-ROOM>
		<RESET-GATE-STATE>)>
	 <COND (<NOT <IS? ,INNER-ROOM ,TOUCHED>>
		<TELL "As you approach what seems to be a blank wall, it slides open,
then closes again after you pass through. It looks like a blank wall from the
other side, too." CR CR>)>
	 <>)
	(<==? .CONTEXT ,M-LOOK>
	 <TELL "This is a bare, inhospitable room. Nothing actually happens
here at all; it is merely a sort of nasty one-way filter. It's a bit like being
inside the \"mind\" of a tax inspector, really.|
|
In fact, it is an airlock. The door by which you entered has disappeared,
flush with the wall. A door leads north. Pretty atmospheric, eh?" CR>
	 <COND (<N==? ,ODD-GATE-SOLVED? ,IN-CLEARING>
		<TELL CR "To the west, you see a">
		<OPEN-CLOSED ,ODD-GATE>
		<TELL ,PERIOD>)>)
	(T <>)>>

<DEFINE ENTER-CARD-ROOM ()
  <COND (<==? ,ODD-GATE-SOLVED? ,IN-CLEARING>
	 <TELL "There's no exit that way." CR>
	 <>)
	(<IS? ,ODD-GATE ,OPENED>
	 ,CARD-ROOM)
	(T
	 <TELL CTHE ,ODD-GATE " is closed." CR>
	 <>)>>

<SETG COMPLEX-POS 0>
<SETG COMPLEX-LOOKED? <>>
<SETG COMPLEX-DROP? <>>

<CONSTANT ALT-COMPLEX-WINDOW-DESC
	  <PTABLE "a picture of a Chowmail Overnite delivery man delivering llama food to
a llama owner whose llama is hungry, which is why the llama owner ordered
the llama food in the first place."
		  "an image of the waiter and waitress bringing customers the food they ordered, and looking very unhappy about it."
		  "a picture of a stockbroker putting some customer's money into an
incredibly underpriced stock that he found on his own."
		  "an image of a confused-looking bank teller sitting behind an open window. Above the window, a sign says \"CHECK CASHING, DEPOSITS, WITHDRAWALS, INFORMATION, ASSISTANCE, CHANGE OF ADDRESS.\""
		  "an image of an utterly bewildered traveller who has mysteriously arrived
at the right airline desk with the right ticket to the place he wanted to go
to, being assigned a window seat in smoking, which is just what he wanted."
		  "an image of a computer room with a dirty great mainframe, and banks of
things which they put in computer rooms so that people can look at them
and say \"Hey, those lights should be flashing but they aren't, someone
must have killed the computer.\"|
|
The nerd is standing with his finger in an I/O port trying to stem the
flood of bits leaking out onto the floor. He looks distinctly like a
nerd who has suddenly realised that it would all have been a lot better
if he had spent his time having drinks at parties and going out with girls
instead of playing with computers.">>

<CONSTANT COMPLEX-WINDOW-DESC
	  <PTABLE				;"Descriptions of windows"
			"an image of the llama-food salesman walking around your neighbourhood practising making deliveries to the wrong address."
			"an image of the waiter and waitress practising making customers go through complicated orders multiple times."
			"an image of a stockbroker staring dumbfounded at his computer
screen, on which you can just make out an order to sell Frobozzco as soon
as its price drops five more points."
			"an image of the bank teller moving \"NEXT WINDOW PLEASE\" signs from window to window in the bank."
			"a split-screen display. On the left side, there's
a very confused Russian gentleman standing next to his aeroplane in what looks
to be a town near Baffin Bay; on the right, an American is wondering why he's
in Jakarta. They're both supposed to be in Geneva, which is where their pilots'
computers claim they are."
			"an image of a computer room with a dirty great mainframe and banks of those
flashing lights they put in computer rooms so that people think \"Gosh,
how complicated computers are, and how amazingly clever the people who
work them must be.\"|
|
The nerd is sitting at a terminal, hacking away. He looks about as happy
as someone who has clearly never been out with girls can look.
Above his head is a monitor screen, showing a really rather attractive
individual looking at a monitor screen which shows a computer
room with a dirty great mainframe...">>
;<SETG COMPLEX-DATA
      <TABLE	0				;"Current position"
		<>				;"Done a look?"
		<>				;"Attempted a DROP?"
		<PTABLE				;"Descriptions of windows"
			"the llama-food salesman walking around your neighbourhood practising making deliveries to the wrong address."
			"the waiter and waitress practising making customers go through complicated orders multiple times."
			"the bank teller moving \"NEXT WINDOW PLEASE\" signs from window to window in the bank."
			"the travel agent routing people from New York to Bermuda via Baffin Bay and Jakarta."
			;"the nerd looking for lost things to try to return to unsuspecting owners."
			"the bookshop clerk making illegal copies of popular computer adventure games."
			"the nerd staring intently at a computer screen. Also in the picture is another monitor screen, which shows someone standing in a corridor."
			;"the macaw and the matron debating irrelevant political issues.">
		;<PTABLE <PLTABLE DMAN NERD>
			<PLTABLE WAITER WAITRESS CLERK ADVENTURE>
			<PLTABLE TELLER MACAW MATRON>>
		;0>>

<DEFINE ENTER-COMPLEX ()
  <COND (<IS? ,OTHER-TRAP-DOOR ,OPENED>
	 <TELL "You stumble through a brightly lit corridor. As
you go, you hear the airlock door slam shut; when you reach the end of the
corridor, you look
around and find that the wall behind you has no opening" ,PERIOD>
	 <SETG COMPLEX-POS 0>
	 <UPDATE-SCORE 2>
	 <ZCRLF>
	 ,IN-COMPLEX)
	(T
	 <TELL "The airlock door is closed." CR>
	 <>)>>

<OBJECT OTHER-TRAP-DOOR
	(LOC INNER-ROOM)
	(DESC "airlock door")
	(FLAGS DOORLIKE OPENABLE LOCKED CONTAINER TRANSPARENT VOWEL)
	(SYNONYM DOOR SLOT READER HOLE LOCK DOOR AIRLOCK)
	(ADJECTIVE CLOSED SHUT KEY AIRLOCK CARD READER DOOR)
	(CAPACITY 0)
	(SIZE 255)
	(CONTFCN OTHER-TRAP-DOOR-F)
	(DESCFCN OTHER-TRAP-DOOR-F)
	(ACTION OTHER-TRAP-DOOR-F)>

<DEFINE OTHER-TRAP-DOOR-F ("OPT" (CONTEXT <>) "AUX" (SS <GET-SYSTOLIC>))
  <COND (<==? .CONTEXT ,M-OBJDESC>
	 <TELL "There's a">
	 <OPEN-CLOSED ,OTHER-TRAP-DOOR>
	 <TELL " in the north wall, with a card reader slot in it.">
	 <COND (<IN? ,KEY ,OTHER-TRAP-DOOR>
		<TELL " There's a " D ,KEY " in the slot.">)>
	 T)
	(<==? .CONTEXT ,M-CONT>
	 <COND (<AND <VERB? TAKE>
		     <NOT <IS? ,OTHER-TRAP-DOOR ,OPENED>>>
		<MAKE ,OTHER-TRAP-DOOR ,OPENED>
		<V-TAKE>
		<UNMAKE ,OTHER-TRAP-DOOR ,OPENED>
		T)>)
	(<T? .CONTEXT> <>)
	(<THIS-PRSI?>
	 <COND (<VERB? PUT>
		<COND (<PRSO? KEY>
		       <COND (<IS? ,OTHER-TRAP-DOOR ,LOCKED>
			      <MOVE ,KEY ,OTHER-TRAP-DOOR>
			      <PERFORM ,V?UNLOCK ,OTHER-TRAP-DOOR ,KEY>)
			     (T
			      <TELL CTHE ,OTHER-TRAP-DOOR " is already
unlocked." CR>)>)
		      (<OR <NOUN-USED? ,W?SLOT ,W?READER ,W?HOLE>
			   <NOUN-USED? ,W?LOCK>>
		       <COND (<IN? ,KEY ,OTHER-TRAP-DOOR>
			      <TELL "There is already a key-card there." CR>)
			     (T
			      <TELL CTHEO " doesn't fit into the slot."
				    CR>)>)
		      (ELSE
		       <TELL "Putting things in airlock doors is not allowed." CR>
		       <SETG P-MULT? <>>
		       T)>)
	       (ELSE <>)>)
	(<OR <VERB? UNLOCK>
	     <AND <VERB? OPEN OPEN-WITH>
		  <T? ,PRSI>>>
	 <COND (<IS? ,PRSO ,LOCKED>
		<COND (<OR <PRSI? KEY>
			   <IN? ,KEY ,OTHER-TRAP-DOOR>>
		       <TELL
			"The card slides smoothly in the reader slot, and you hear what could be a bolt snapping back." CR>
		       <UNMAKE ,PRSO ,LOCKED>)>)>)
	(<VERB? LOCK>
	 <COND (<NOT <IS? ,PRSO ,LOCKED>>
		<COND (<OR <PRSI? KEY>
			   <IN? ,KEY ,OTHER-TRAP-DOOR>>
		       <TELL "The card slides smoothly into the reader slot."
			     CR>
		       <UNMAKE ,PRSO ,OPENED>
		       <MAKE ,PRSO ,LOCKED>)>)>)
	(<AND <VERB? OPEN>
	      <NOUN-USED? ,W?LOCK>>
	 <PERFORM ,V?UNLOCK ,PRSO>)
	(<VERB? OPEN PULL>
	 <COND (<IS? ,PRSO ,LOCKED>
		<COND (<G=? .SS 125>
		       <TELL "Despite your increased strength, " THEO
			     " doesn't move. Perhaps it's locked">)
		      (T
		       <TELL CTHEO " doesn't budge">)>
		<TELL ,PERIOD>
		<UPDATE-BP 2>)
	       (<G=? .SS 140>
		<TELL "Your current rage level is so great that you have the
strength of ten." CR>
		<V-OPEN>
		T)
	       (T
		<COND (<L=? .SS 121>
		       <TELL "In your current relaxed state, you can't get "
			     THEO " to move at all">)
		      (<L=? .SS 125>
		       <TELL CTHEO
		        " seems to budge a little, but springs back in place">)
		      (T
		       <TELL "You pull with all your strength, but " THEO
			     " opens only a little">)>
		<TELL ,PERIOD>
		<UPDATE-BP 3>
		T)>)
	(<NOUN-USED? ,W?HOLE ,W?READER ,W?SLOT>
	 <COND (<VERB? EXAMINE>
		<TELL "It's just a normal sort of card-reader slot, with ">
		<COND (<IN? ,KEY ,OTHER-TRAP-DOOR>
		       <TELL "a " D ,KEY " in it">)
		      (T
		       <TELL "nothing in it">)>
		<TELL ,PERIOD>)
	       (<VERB? LOOK-INSIDE>
		<COND (<IN? ,KEY ,OTHER-TRAP-DOOR>
		       <TELL "That's tough to do with " A ,KEY
			     " in it." CR>)
		      (T
		       <TELL "There's nothing interesting in the slot." CR>)>)
	       (<ENTERING?>
		<TELL "Come off it." CR>)>)
	(<ENTERING?>
	 <DO-WALK ,P?DOWN>)
	(T <>)>>

<OBJECT IN-COMPLEX
	(LOC ROOMS)
	(DESC "Persecution Complex")
	(EAST PER COMPLEX-MOVE)
	(WEST PER COMPLEX-MOVE)
	(SYNONYM HALL COMPLEX)
	(ADJECTIVE PERSECUTION)
	(FLAGS PLACE LIGHTED INDOORS SPECIAL-DROP NO-NERD)
	(ACTION IN-COMPLEX-ROOM-F)>

<DEFINE HANDLE-COMPLEX-DROP (OBJ)
	<SETG P-MULT? <>>
	<COND (<T? ,COMPLEX-DROP?>
	       <TELL "This time you throw all caution to the wind, but your luck runs out. ">
	       <SECURITY-COMES>)
	      (ELSE
	       <SETG COMPLEX-DROP? T> 
	       <TELL "As you start to " WORD ,P-PRSA-WORD " " THE .OBJ
		     " you get the distinct feeling you're being watched and that dropping something will arouse someone's attention. So you think better of it." CR>)>>

<MSETG NUM-PERSECUTION-WINDOWS 6>
<MSETG NUM-PERSECUTION-WINDOWS-BY-2 </ ,NUM-PERSECUTION-WINDOWS 2>>
<MSETG NUM-COMPLEX-POSITIONS <+ ,NUM-PERSECUTION-WINDOWS-BY-2 1>>

<DEFINE IN-COMPLEX-ROOM-F ("OPT" (CONTEXT <>)
			   "AUX" (POS ,COMPLEX-POS) OBJS
				 (LOOK? ,COMPLEX-LOOKED?)
				 CNT)
	<COND (<==? .CONTEXT ,M-LOOK>
	       <SETG COMPLEX-LOOKED? T>
	       <TELL "You are in " THE ,IN-COMPLEX ". It is a long brightly lit hall running ">
	       <COND (<==? .POS 0> <TELL "west">)
		     (<==? .POS ,NUM-COMPLEX-POSITIONS> <TELL "east">)
		     (T <TELL "east and west">)>
	       <TELL ", with " N ,NUM-PERSECUTION-WINDOWS-BY-2 " TV screens on each side of the hall. The screens resemble the security monitors one might find at a guard's station.">
	       <COND (<==? .POS 0> <TELL " There is a sign here.">)
		     (<==? .POS ,NUM-COMPLEX-POSITIONS>
		      <TELL " There is an exit to the west.">)
		     (ELSE
		      <TELL " There are TV screens to your right and left.">)>
	       <ZCRLF>
	       T)
	      (<==? .CONTEXT ,M-ENTERED>
	       <COND (<==? .POS 0>
		      <COND (<ZERO? .LOOK?>
			     <TELL CR "There is a sign here.">)>)
		     (<==? .POS ,NUM-COMPLEX-POSITIONS>
		      <>)
		     (ELSE
		      ;<SET POS <- .POS 1>>
		      ;<SET OBJS <ZGET <ZGET ,COMPLEX-DATA ,COMPLEX-AUX-OBJS>
				      .POS>>
		      ;<GET-OBJS .OBJS>
		      ;<ZPUT ,COMPLEX-DATA ,COMPLEX-CURRENT-OBJS .OBJS>
		      <COND (<ZERO? .LOOK?>
			     <TELL CR
			      "There are screens to your right and left.">)>)>
	       <COND (<ZERO? .LOOK?> <ZCRLF>)>
	       <SETG COMPLEX-LOOKED? <>>
	       T)
	      (<==? .CONTEXT ,M-ENTERING>
	       <COND (<==? .POS ,NUM-COMPLEX-POSITIONS>
		      <MOVE ,MPLUG ,IN-COMPLEX>)
		     (T
		      <ZREMOVE ,MPLUG>)>
	       <>)
	      (<AND <==? .CONTEXT ,M-END>
		    <VERB? LOOK>>
	       <SETG COMPLEX-LOOKED? <>>)
	      ;(<==? .CONTEXT ,M-BEG>
	       <SETG COMPLEX-LOOKED? <>>
	       <SET OBJS <ZGET ,COMPLEX-DATA ,COMPLEX-CURRENT-OBJS>>
	       <SET CNT <ZGET .OBJS 0>>
	       <SET OBJS <ZREST .OBJS 2>>
	       <COND (<AND <NOT <VERB? EXAMINE LOOK-ON>>
			   <N==? .POS 0>
			   <N==? .POS ,NUM-COMPLEX-POSITIONS>
			   <N==? ,PRSA ,V?WALK>
			   <OR <INTBL? ,WINNER .OBJS .CNT>
			       <INTBL? ,PRSO .OBJS .CNT>
			       <INTBL? ,PRSI .OBJS .CNT>>>
		      <TELL "The screen is obviously unbreakable. We're not talking two-way cable here, either, so interaction is out of the question." CR>
		      ,FATAL-VALUE)
		     (ELSE <>)>) 
	      (T <>)>>

;<DEFINE PERSON? (OBJ)
	<AND <T? .OBJ>
	     <IS? .OBJ ,PERSON>
	     <N==? .OBJ ,ME>>>

<DEFINE COMPLEX-MOVE ("AUX" (X ,COMPLEX-POS))
	<COND (<==? ,P-WALK-DIR ,P?EAST>
	       <COND (<==? .X 0>
		      <TELL "You are at the end of hall and can go no further."
			    CR>
		      <>)
		     (ELSE
		      <SET X <- .X 1>>
		      ;<COND (<N==? .X <- ,NUM-COMPLEX-POSITIONS 1>>
			     <REMOVE-OBJS <ZGET ,COMPLEX-DATA
						,COMPLEX-CURRENT-OBJS>>)>
		      <SETG COMPLEX-POS .X>
		      ,IN-COMPLEX)>)
	      (<==? .X ,NUM-COMPLEX-POSITIONS>
	       ,UNDER-TRAP-DOOR)
	      (ELSE
	       <SETG COMPLEX-POS <+ .X 1>>
	       ;<COND (<N==? .X 0>
		      <REMOVE-OBJS <ZGET ,COMPLEX-DATA
						,COMPLEX-CURRENT-OBJS>>)>
	       ,IN-COMPLEX)>>

<OBJECT PERSECUTION-SIGN
	(LOC IN-COMPLEX)
	(DESC "sign")
	(FLAGS NODESC)
	(SYNONYM NOTICE SIGN)
	(ACTION PNOTICE-F)>

<CONSTANT PNOTICE-TXT
	  <PLTABLE 33
		  "           REMINDER            "
		  "                               "
		  "      This week, work on       "
		  <>
		  <>
		  "        now at Happitec        ">>

<DEFINE PNOTICE-F ()
	<COND (<VERB? READ EXAMINE LOOK-ON>
	       <TELL "You read the notice." CR>
	       <WINDOW ,PNOTICE-TXT
		       <ZREST <ZGET ,LICENSE-FORM <+ ,FIRST-NAME 1>>
			      <- ,FIELD-DATA-OFFSET 1>>
		       <ZREST <ZGET ,LICENSE-FORM <+ ,LAST-NAME 1>>
			      <- ,FIELD-DATA-OFFSET 1>>>
	       T)
	      (ELSE <>)>>

<OBJECT WINDOW-R
	(DESC "right observation screen")
	(LOC IN-COMPLEX)
	(FLAGS NODESC)
	(SYNONYM SCREENS SCREEN MONITOR)
	(ADJECTIVE OBSERVATION RIGHT SECURITY TV TELEVISION)
	(ACTION RWINDOW-F)>

<OBJECT WINDOW-L
	(DESC "left observation screen")
	(FLAGS NODESC)
	(LOC IN-COMPLEX)
	(SYNONYM SCREENS SCREEN MONITOR)
	(ADJECTIVE OBSERVATION LEFT SECURITY TV TELEVISION)
	(ACTION LWINDOW-F)>

<DEFINE LWINDOW-F () <LRWINDOW-F T>>

<DEFINE RWINDOW-F () <LRWINDOW-F <>>>

<DEFINE LRWINDOW-F LF (LEFT? "AUX" (POS ,COMPLEX-POS))
	<COND (<==? .POS 0>
	       <TELL "You'll need to go west to do anything with the screens." CR>
	       <RETURN T .LF>)
	      (<==? .POS ,NUM-COMPLEX-POSITIONS>
	       <TELL "You'll need to go east to do anything with the screens." CR>
	       <RETURN T .LF>)>
	<COND (.LEFT?
	       <SET POS <+ .POS ,NUM-PERSECUTION-WINDOWS-BY-2>>)>
	<COND (<VERB? EXAMINE LOOK-ON LOOK-INSIDE>
	       <TELL "You look at this screen and see ">
	       <SET POS <- .POS 1>>
	       <COND (<T? <COMPUTER-DEAD?>>
		      <TELL <ZGET ,ALT-COMPLEX-WINDOW-DESC .POS>>)
		     (T
		      <TELL <ZGET ,COMPLEX-WINDOW-DESC .POS>>)>
	       <ZCRLF>
	       T)
	      (ELSE
	       <>)>>

;<DEFINE REMOVE-OBJS (LTBL "AUX" LEN)
	<COND (<T? .LTBL>
	       <SET LEN <ZGET .LTBL 0>>
	       <REPEAT ()
		       <ZREMOVE <ZGET .LTBL .LEN>>
		       <COND (<L=? <SET LEN <- .LEN 1>> 0>
			      <RETURN>)>>)>
	T>

;<DEFINE GET-OBJS (LTBL "AUX" LEN TMP)
	<COND (<T? .LTBL>
	       <SET LEN <ZGET .LTBL 0>>
	       <REPEAT ()
		       <SET TMP <ZGET .LTBL .LEN>>
		       <MOVE .TMP ,IN-COMPLEX>
		       <MAKE .TMP ,NODESC>
		       <COND (<L=? <SET LEN <- .LEN 1>> 0>
			      <RETURN>)>>)>
	T>

<OBJECT UNDER-TRAP-DOOR
	(LOC ROOMS)
	(FLAGS PLACE LIGHTED INDOORS NO-NERD)
	(SYNONYM SHAFT AIRSHAFT GRAFFITI GRAFFITO)
	(ADJECTIVE AIR)
	(DESC "air shaft")
	(EAST TO IN-COMPLEX)
	(OUT PER UP-TO-LANDING-STRIP)
	(UP PER UP-TO-LANDING-STRIP)
	(ACTION UNDER-TRAP-DOOR-F)>

<DEFINE SAY-GRAFFITI ()
  <TELL "\"This is the werst departure luonge what I ever seen\". The
others are unreadable." CR>>

<DEFINE UNDER-TRAP-DOOR-F ("OPT" (CONTEXT <>))
  <COND (<==? .CONTEXT ,M-LOOK>
	 <TELL "This is a room where hot air is discharged, even barer than
the airlock. It's like being inside the President's mind, except for the
scrawled graffiti on the walls, one of which says, ">
	 <SAY-GRAFFITI>
	 <TELL CR "An exit leads up." CR>
	 T)
	(<T? .CONTEXT> <>)
	(<HERE? UNDER-TRAP-DOOR>
	 <COND (<VERB? READ>
		<SAY-GRAFFITI>)
	       (<VERB? CLIMB-UP>
		<DO-WALK ,P?UP>)
	       (<VERB? EXAMINE>
		<PERFORM ,V?LOOK>)>)
	(<HERE? LANDING-STRIP>
	 <COND (<VERB? CLIMB-UP CLIMB-DOWN>
		<DO-WALK ,P?DOWN>)
	       (<VERB? EXAMINE READ>
		<TELL "It's the top end of an air shaft. It's probably
impossible to climb back down." CR>)
	       (<ENTERING?>
		<DO-WALK ,P?DOWN>)
	       (<AND <THIS-PRSI?>
		     <VERB? PUT PUT-ON>>
		<ZREMOVE ,PRSO>
		<TELL CTHEO " falls out of sight; presently, you hear it
hitting the bottom of the shaft. Wasn't that fun?" CR>)>)
	(T
	 <TELL "There's no air shaft here." CR>)>>

<DEFINE UP-TO-LANDING-STRIP ()
  <TELL "You struggle up the air shaft, and find yourself back above ground">
  <COND (<AND <F? <COMPUTER-DEAD?>>
	      <NOT ,PLANE-SUMMONED?>>
	 <TELL ", where you see a primitive landing strip hacked out of the jungle.||"
	       "Look. Um...|
|
We're not quite sure how to put this, so we got the lawyers to draft something
instead.|
|
\"Infocom Inc. currently possesses no mechanism for allowing proactive
product end-users\" -- sorry about the tacky '80s MBA jargon, but you
know how lawyers " ITAL "love" " bull like that -- \"to escape from
interactive fiction situations without having made the least attempt
to solve the puzzles.|
|
\"The normal penalty under these circumstances would be death. However,
we are prepared to offer you the option of
returning whence you came.|
|
\"Actually, this isn't really an option. Look at it from our point of
view. Suppose you said 'To hell with it, I'd rather die', where would
we be then? We'd have no option but to sue the guts out of you. And
have you the remotest idea of the paperwork " ITAL "that" " would involve?
We have wives and families, you know, and girlfriends, and sometimes we just
like to go bowling of an evening or just hang out at the gas station,
drinking Fresca and bad-mouthing the treasury.|
|
\"So: back you go.\"|
|
Sorry about that. That's what the lawyers say, so that's what has to
happen" ,PCR>
	 ,IN-COMPLEX)
	(T
	 <TELL ,PCR>
	 ,LANDING-STRIP)>>

<OBJECT LANDING-STRIP
	(DESC "landing strip")
	(LOC ROOMS)
	(FLAGS PLACE NODESC LIGHTED NO-NERD)
	(SYNONYM STRIP JUNGLE)
	(ADJECTIVE LANDING AIR)
	(WEST SORRY "The jungle that surrounds the landing strip is impenetrable. You may, quite rightly, ask how there happens to be a landing strip in the midst of it. Well, we aren't sure, but it happened.")
	(NORTH SORRY "The jungle that surrounds the landing strip is impenetrable. You may, quite rightly, ask how there happens to be a landing strip in the midst of it. Well, we aren't sure, but it happened.")
	(SOUTH SORRY "The jungle that surrounds the landing strip is impenetrable. You may, quite rightly, ask how there happens to be a landing strip in the midst of it. Well, we aren't sure, but it happened.")
	(EAST SORRY "The jungle that surrounds the landing strip is impenetrable. You may, quite rightly, ask how there happens to be a landing strip in the midst of it. Well, we aren't sure, but it happened.")
	(DOWN PER DOWN-FROM-STRIP)
	(UP SORRY "All in due course.")
	(GLOBAL UNDER-TRAP-DOOR)
	(ACTION LANDING-STRIP-F)>

<SETG DOWN-FROM-STRIP-COUNT 0>

<DEFINE DOWN-FROM-STRIP ("AUX" (DFS ,DOWN-FROM-STRIP-COUNT))
  <COND (<0? .DFS>
	 <TELL "It was hard enough climbing up. Climbing down is
practically impossible">)
	(T
	 <TELL "All right, climbing down is " ITAL "absolutely"
	       " impossible, due to the law of gravity.|
|
This may seem like a pretty feeble excuse to you. You're right. ">
	 <COND (<T? <COMPUTER-DEAD?>>
		<TELL "If we let you back down there now, we'd have to
show the nerd running amok, crazed with grief over the death of his
computer, and you'd have to be able to fight him, or console him, or
whatever's appropriate, and it would just be too painful for us. "
		      ITAL "Ergo" ", you'll have to stay here">)
	       (T
		<TELL "We could let you go back down, but what would it
buy you? You'd miss the " D ,PLANE " you so painstakingly called, and then
we'd have to have some inventive way for you to die in the middle of the
jungle, and all in all you're better off staying up here. So there you have
it">)>)>
  <SETG DOWN-FROM-STRIP-COUNT <SET DFS <+ .DFS 1>>>
  <TELL ,PERIOD>
  <>>

<SETG LS-MOVE-COUNT 0>

<DEFINE LANDING-STRIP-F ("OPT" (CONTEXT <>))
  <COND (<==? .CONTEXT ,M-ENTERING>
	 <DEQUEUE I-NERD>
	 <COND (<NOT ,PLANE-SUMMONED?>
		<QUEUE I-PLANE-ARRIVES -1>
		<SETG LS-MOVE-COUNT 7>)
	       (<NOT <QUEUED? I-PLANE-ARRIVES>>
		<QUEUE I-PLANE-ARRIVES -1>)>
	 <>)
	(<AND <==? .CONTEXT ,M-BEG>
	      <NOT ,PLANE-SUMMONED?>>
	 <COND (<==? ,LS-MOVE-COUNT 255>
		<TELL "Infocom regrets that the laws of nature were
suspended for only one turn. You crash to the ground with some interesting new
theories forming in your mind on the method of proof-by-induction.
Unfortunately, before you can organise your thoughts into anything which
would be remotely acceptable as a Ph.D. dissertation -- even at Caltech -- you die.">
		<JIGS-UP>
		T)
	       (<L=? <SETG LS-MOVE-COUNT <- ,LS-MOVE-COUNT 1>> 0>
		<COND (<VERB? WAIT>
		       <TELL "There is a limit to human patience. You are
really fed up now, and wish you were dead. Fair enough.">
		       <JIGS-UP>
		       T)
		      (<VERB? WALK>
		       <COND (<==? ,P-WALK-DIR ,P?DOWN>
			      <TELL "A reasonable suggestion. A line from
John Donne comes into your mind:|
|
\"The grave's a fine and private place|
But none, methinks, do there embrace.\"|
|
Just as you realise that this is, in fact, a line from Andrew Marvell,
you die. What a bitch, eh?">
			      <JIGS-UP>
			      T)
			     (<==? ,P-WALK-DIR ,P?UP>
			      <TELL "You were planning to fly, perhaps?
Nah, you wouldn't want to try that without an " D ,PLANE ". There probably
won't be one showing up here, since you neglected to ask for one, so you're
doomed to die here in the jungle.">
			      <JIGS-UP>
			      T)>)
		      (<VERB? FLY>
		       <TELL "Right-ho. You are de... Oh -- sorry. Misheard
you. Thought you said \"Die\". Ah well; too late now.">
		       <JIGS-UP>
		       T)
		      (T <>)>)
	       (<AND <VERB? WALK>
		     <==? ,P-WALK-DIR ,P?UP>>
		<TELL "What in?" CR>)
	       (<VERB? FLY>
		<SETG LS-MOVE-COUNT 255>
		<TELL "You flap your arms wildly and, in defiance of the
laws of nature, rise slowly off the ground." CR>
		T)
	       (T <>)>)
	(<==? .CONTEXT ,M-LOOK>
	 <TELL "This is a bare landing strip surrounded by jungle. An
air shaft leads down." CR>)
	(<T? .CONTEXT> <>)
	(<VERB? EXAMINE LOOK-ON>
	 <COND (<NOUN-USED? ,W?JUNGLE>
		<TELL "It's the usual impenetrable Zalagasan jungle." CR>)
	       (T
		<PERFORM ,V?LOOK>)>)>>

<SETG PLANE-ARRIVE-COUNT 4>

<DEFINE I-PLANE-ARRIVES ()
  <COND (<==? <SETG PLANE-ARRIVE-COUNT <- ,PLANE-ARRIVE-COUNT 1>> 2>
	 <TELL CR
	       "In the distance you hear the sound of Zalagasans having
a huge row about whether bearnaise sauce or grated Parmesan is better
with boiled visitor." CR>)
	(<==? ,PLANE-ARRIVE-COUNT 0>
	 <DEQUEUE I-PLANE-ARRIVES>
	 <COND (<NOT ,PLANE-SUMMONED?>
		<TELL CR
		      "At this point, you'd expect the Zalagasans to start
droning, and then that would turn into an " D ,PLANE ", and you'd fly out of
here. Unfortunately, the plane doesn't know it's supposed to show up here,
since you never told it to,
so that doesn't happen. The Zalagasans continue to row about bearnaise
sauce and grated Parmesan." CR>)
	       (T
		<TELL CR
"For some reason, the Zalagasans have started droning... or have they?
No, it is the sound of an aircraft in the distance. The sound of the
engines gets louder and louder until suddenly an ancient DC-3 appears
nightmarishly low above the treetops, circles the airfield once, and
lands with a cloud of dust and a squeal of brakes.|
|
The door opens and you leap on board to be greeted by a ">
		<GENDER-PRINT "beautiful copilot"
			      "ruggedly handsome flight attendant">
		<TELL ". \"You finally fixed that dreadful nerd,\" ">
		<GENDER-PRINT "she" "he">
		<TELL " says. \"You wouldn't believe what he was doing, even to
our own navigation systems. It was as if he didn't care who he
inconvenienced, even himself, as long as he was hacking. Gosh, I'm just so
grateful I could die!\"|
|
With that, the ">
		<GENDER-PRINT "copilot" "flight attendant">
		<TELL " enfolds you in ">
		<GENDER-PRINT "her" "his">
		<TELL " arms and you begin to realise why people like
private " D ,PLANE "s" ,PCR>
		<COND (<T? <COMPUTER-DEAD?>>
		       <MOVE ,END-MAIL ,FROOM>
		       <TELL "After an eventful and invigorating flight, you land
at your home airport, pass through customs without the least difficulty, and are
ushered into a waiting taxi, which drives you straight to the wrong place.
Perhaps you thought that the taxi company was being fouled up by the
nerd. Wrong. Taxi companies foul up because that's what they like doing"
			     ,PERIOD>
		       <SETG END-GAME? T>
		       <UPDATE-SCORE 2>
		       <ZCRLF>
		       <UNMAKE ,FROOM ,TOUCHED>
		       <UNMAKE ,BROOM ,TOUCHED>
		       <UNMAKE ,PORCH-DOOR ,OPENED>
		       <MAKE ,PORCH-DOOR ,LOCKED>
		       <UNMAKE ,BWGATE ,OPENED>
		       <MAKE ,BWGATE ,LOCKED>
		       <GOTO ,THALL T <>>)
		      (T
		       <TELL "You " ITAL "knew"
			     " something was up, didn't you?
Quite right.|
|
The pilot comes back to where you are sitting, spoiling your tasty fun.
You wonder why he is not flying the " D ,PLANE ", but when he explains that
the computerised navigation system appears to be going haywire due to
outside intervention, you realise why he is not flying it. There would
be little point.|
|
You realise just " ITAL "how" " little when the " D ,PLANE " goes into a steep
spiral dive and you hear a loud bang followed by a toneless but exuberant
rendition of an ancient Zalagasan song about what a coincidence it is
that, just when everyone is feeling peckish and wondering about sending
out for a 48-inch deep-dish pizza with extra everything, there should be
a convenient lunch delivery.|
|
Your last words are \"Hey! I don't " ITAL "like" " anchovies!\" But the
Zalagasans put them on you anyway.">
		       <JIGS-UP>
		       T)>)>)
	(T <>)>>

<OBJECT END-MAIL
	(DESC "new letter")
	(FLAGS TAKEABLE READABLE)
	(SYNONYM LETTER)
	(ADJECTIVE NEW)
	(ACTION END-MAIL-F)>

<DEFINE END-MAIL-F ()
  <COND (<VERB? TAKE>
	 <TELL "This is a letter addressed to you, from your bank." CR>
	 <MOVE ,END-MAIL ,PLAYER>
	 T)
	(<VERB? OPEN>
	 <TELL "OK." CR>)
	(<AND <THIS-PRSO?>
	      <VERB? DROP PUT PUT-ON>>
	 <TELL "Before disposing of " THEO ", you sensibly read it.">
	 <PERFORM ,V?READ ,PRSO>
	 T)
	(<AND <THIS-PRSO?>
	      <VERB? READ EXAMINE>>
	 <TELL CR CR "\"Dear ">
	 <GENDER-PRINT "Mr " "Ms ">
	 <PRINT-LAST-NAME>
	 <TELL ",|
|
I would like on behalf of Fiduciary to apologize profusely for the
problems you have been encountering lately. This was due partly to
mysterious computer problems which have suddenly ceased to plague us,
but also to the inability of our staff to show any initiative at all
when confronted with a systems breakdown.|
|
I have immediately initiated a training program to counteract this
ridiculous bureaucracy, and trust that in your future dealings with
Fiduciary you will have no cause for complaint.|
|
By way of compensation I have waived all interest and administration
charges for this quarter, and would also like you to accept this free
first-class ticket to Paris.|
|
I also enclose your check book and a new Gold Beezer card and have
raised your credit limit to $10,000.|
|
Sincerely yours,|
|
Joel X. Slartibartfast|
PRESIDENT\"|
|
Glowing with pleasure at your notable victory, you do not even notice that
the bank letter has been redirected from your old address, to which it was
originally sent. You have a nice hot drink and turn in for the night, humming
a happy little song about how much you are looking forward to your trip to
Paris. You are particularly pleased with your impression of the accordion
accompaniment and fall asleep with the words \"">
	 <GENDER-PRINT "Bonjour, Ma'm'selle" "Ooh la la, M'sieu">
	 <TELL "\" on your lips.|
|
You have won. Thank you for playing Bureaucracy, and if your future
entertainment plans should include interactive fiction, please think
of Infocom. Have a nice day." CR>
	 <UPDATE-SCORE 1>
	 <COND (<N==? ,DO-SCORE? 2> <ZCRLF>)>
	 <V-QUIT <>>)>>

