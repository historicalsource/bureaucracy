"NNJET for BUREAUCRACY: Copyright 1987 Infocom, Inc. All rights reserved."

<FILE-FLAGS MDL-ZIL?>

<INCLUDE "FORMDEFS" "JETDEFS">

"There are three scenarios. The first two that are played out turn out to
 be dreams, as you discover when you wake up just before crashing into the
 ground because your parachute didn't work. The third is real, and in that
 one, assuming winnage, your parachute works and you land in the stew.
 The scenarios are:
 1) Hijacking. The plane is hijacked by someone who decides to escape with
    a randomly-chosen hostage, namely you. Why? Who knows. If you do the
    wrong thing, you get blown away (of course, in the dream sequence you
    just wake up). Maybe the airplane too.
 2) Bad breath. You foolishly eat your airline food. Failure to do so gets
    you thrown off for being rude to the chef. If you do, you develop severe
    halitosis, forcing you to go brush your teeth; failure to do so gets you
    thrown off for being a chomper. When you brush your teeth, you can either
    clean out the sink (per the sign), in which case you're delayed past the
    seat-belt and return-to-seat signs coming on; you get thrown off for not
    obeying that. Otherwise, you get thrown off for not cleaning out the
    sink.
 3) Visa. You're required to fill out some entrance form, with a visa number
    that you don't have and can't get. Failure to do so results in ejection."

; "Actually move the cretinous player onto the plane..."
<DEFINE GO-TO-PLANE ()
	 <ZREMOVE ,ZTICKET>
	 <DEQUEUE I-TERMINAL>
	 <DEQUEUE I-ZALAGASA-DESK>
	 <DEQUEUE I-DESK>
	 <QUEUE I-PHONES>
	 <COND (<IN? ,COMPUTER ,PLAYER>
		<BROUGHT-COMPUTER? T>)>
	 <MAKE ,SEATBELT ,WORN>
	 <MOVE ,SEATBELT ,PLAYER>
	 <SETG HERE ,SEAT>
	 <MOVE ,PLAYER ,HERE>
	 ; "Put smoker/non-smoker in next seat."
	 <INITIALIZE-SEATS>
	 <END-CURRENT-SCENE T>
	 T>

<OBJECT PLANE
	(LOC GLOBAL-OBJECTS)
	(DESC "airplane")
	(FLAGS NODESC VOWEL PLACE)
	(SYNONYM PLANE AIRPLANE JET AIRCRAFT)
	(ACTION PLANE-F)>

<DEFINE PLANE-F ()
	<COND (<HERE? IN-AIR>
	       <TELL
		"The airplane has already flown on. You can no longer see it."
		CR>)
	      (<AND <HERE? OUTSIDE-PLANE>
		    <VERB? EXAMINE>>
	       <TELL "It's a standard Air Zalagasa jetliner, with a parachute stuck in the exit." CR>)
	      (<AND <HERE? OUTSIDE-PLANE>
		    <VERB? KNOCK>>
	       <PUTP ,RANDOM-OBJECT ,P?PSEUDO-TABLE ,HATCH-OBJECT>
	       <PERFORM ,V?KNOCK ,RANDOM-OBJECT>)
	      (<NOT <ON-PLANE?>>
	       ; "Not on the plane"
	       <CANT-FROM-HERE>
	       T)
	      (<HERE-F>
	       T)
	      (T <>)>>


"Basic airplane stuff. Aisle to move around in, seats to sit in, etc."

; "Generic AISLE room..."
<OBJECT AISLE
	(LOC ROOMS)
	(FLAGS IN-AIRPLANE LOCATION VOWEL NODESC LIGHTED INDOORS)
	(ADJECTIVE AISLE ROW)
	(SYNONYM AISLE ROW)
	(EAST PER AISLE-TO-SEAT)
	(WEST PER AISLE-TO-SEAT)
	(NORTH PER AISLE-TO-AISLE)
	(SOUTH PER AISLE-TO-AISLE)
	(ACTION AISLE-F)
	(GLOBAL	FLIGHT-ATTENDANT SEATBELT-LIGHT)
	(SDESC SDESC-AISLE)
	(THINGS SEAT-PSEUDO-VEC)>

<SETG CURRENT-ROW 0>
<SETG CURRENT-SEAT 0>

<DEFINE ROW-SEEN? (ROW "OPT" (DOSET? <>) (NEWVAL <>))
  <COND (<NOT .DOSET?>
	 <COND (<NOT <0? <ANDB <ZGET ,AISLE-STATE .ROW> ,ROW-SEEN-BIT>>> T)
	       (T <>)>)
	(T
	 <ZPUT ,AISLE-STATE .ROW
	       <COND (.NEWVAL
		      <ORB <ZGET ,AISLE-STATE .ROW> ,ROW-SEEN-BIT>)
		     (T
		      <ANDB <ZGET ,AISLE-STATE .ROW>
			    <XORB ,ROW-SEEN-BIT -1>>)>>)>>

<DEFINE STARBOARD-PERSON ("OPT" (NEW 0) (ROW 0))
  <COND (<0? .ROW> <SET ROW ,CURRENT-ROW>)>
  <COND (<0? .NEW>
	 <ANDB </ <ZGET ,AISLE-STATE .ROW>
		  ,STARBOARD-DIVISOR>
	       *17*>)
	(T
	 <ZPUT ,AISLE-STATE .ROW
	       <ORB <ZGET ,AISLE-STATE .ROW>
		    <* .NEW ,STARBOARD-DIVISOR>>>)>>

<DEFINE PORT-PERSON ("OPT" (NEW 0) (ROW 0))
  <COND (<0? .ROW>
	 <SET ROW ,CURRENT-ROW>)>
  <COND (<0? .NEW>
	 <ANDB </ <ZGET ,AISLE-STATE .ROW>
		  ,PORT-DIVISOR>
	       *17*>)
	(T
	 <ZPUT ,AISLE-STATE .ROW
	       <ORB <* .NEW ,PORT-DIVISOR>
		    <ZGET ,AISLE-STATE .ROW>>>)>>

<DEFINE GET-SEAT ("OPT" (N:FIX 0) (ROW:FIX 0))
  <COND (<0? .N> <SET N ,CURRENT-SEAT>)>
  <COND (<0? .ROW> <SET ROW ,CURRENT-ROW>)>
  <COND (<BTST <ZGET ,AISLE-STATE .ROW> .N>
	 ;<NOT <0? <ANDB .N <ZGET ,AISLE-STATE .ROW>>>>
	 <COND (<G? .N ,SEAT-B>
		; "Starboard side"
		<STARBOARD-PERSON 0 .ROW>)
	       (T
		<PORT-PERSON 0 .ROW>)>)>>

<CONSTANT SEAT-MASKS <TABLE (PURE BYTE LENGTH) ,SEAT-A ,SEAT-B
			    ,SEAT-C ,SEAT-D>>

<CONSTANT AISLE-STATE
	  <ITABLE <+ ,AISLE-COUNT 1> ,ALL-SEATS>>

<DEFINE AISLE-F AISLE (RARG "AUX" SEAT-MASK NR)
	<COND (<==? .RARG ,M-LOOK>
	       <TELL "You are standing in the aisle, at row "
		     N ,CURRENT-ROW ". ">
	       <COND (<==? <SET SEAT-MASK <ROW-SEATS>>
			   ,ALL-SEATS>
		      <TELL "All the seats in this row are occupied. ">)
		     (<0? .SEAT-MASK>
		      <TELL "This row is unoccupied. ">)
		     (T
		      <REPEAT (N (CT 1) (FF? T))
		        <SET N <GETB ,SEAT-MASKS .CT>>
			<COND (<AND <F? <GET-SEAT .N>>
				    <OCCUPIED? .N>>
			       <BOTH-SEATS .N .CT .FF? "occupied">
			       <SET CT <+ .CT 1>>)
			      (<AND <EQUAL? .CT 1 3>
				    <NOT <OCCUPIED? .N>>
				    <NOT <OCCUPIED?
					  <GETB ,SEAT-MASKS <+ .CT 1>>>>>
			       <BOTH-SEATS .N .CT .FF? "empty">
			       <SET CT <+ .CT 1>>)
			      (T
			       <DESCRIBE-SEAT <GETB ,SEAT-MASKS .CT>
					      .FF?
					      <COND (<==? .CT 4> T)
						    (T <>)>>)>
			<SET FF? <>>
			<COND (<G? <SET CT <+ .CT 1>> 4>
			       <RETURN>)>>)>
	       <DESC-SEATBELT>
	       <ZCRLF>)
	      (<==? .RARG ,M-BEG>
	       <COND (<AND <VERB? SIT>
			   <F? ,PRSO>
			   <N==? <ROW-SEATS> ,ALL-SEATS>>
		      <REPEAT ((CT 1) N)
		        <COND (<F? <OCCUPIED? <SET N <GETB ,SEAT-MASKS .CT>>>>
			       <SETG CURRENT-SEAT .N>
			       <SETUP-NEW-SEAT>
			       <GOTO ,SEAT>
			       <RETURN>)>>
		      T)
		     (T <>)>)
	      (<T? .RARG> <>)
	      (<VERB? WALK-TO>
	       <COND (<AND <SET NR <NEW-ROW>>
			   <N==? .NR ,CURRENT-ROW>>
		      <COND (<AND <HERE? LAVATORY>
				  <T? <ZAPPLY <GETP ,HERE ,P?ACTION> ,M-EXIT>>>
			     <RETURN T .AISLE>)>
		      <COND (<HERE? SEAT>
			     <COND (<STUCK-IN-SEAT?> <RETURN T .AISLE>)>
			     <LEAVE-SEAT>)>
		      <SETG CURRENT-ROW .NR>
		      <SETG OLD-HERE <>>
		      <SETG HERE ,AISLE>
		      <GOTO ,HERE>
		      T)
		     (<HERE? AISLE>
		      <ALREADY-THERE>)
		     (<HERE? SEAT>
		      <DO-WALK ,P?OUT>
		      T)
		     (<HERE? GALLEY>
		      <DO-WALK ,P?SOUTH>
		      T)
		     (<HERE? LAV-LOBBY>
		      <DO-WALK ,P?NORTH>
		      T)
		     (T <>)>)
	      (T <>)>>

<DEFINE BOTH-SEATS (MASK1 CCT FF? TAILSTRING)
  <COND (.FF?
	 <TELL "B">)
	(T
	 <TELL "b">)>
  <TELL "oth seats " CHAR <SEAT-LETTER .MASK1>
	" and " CHAR <SEAT-LETTER <GETB ,SEAT-MASKS <+ .CCT 1>>>
	" are " .TAILSTRING>
  <COND (.FF?
	 <TELL "; ">)
	(T
	 <TELL ". ">)>>

<DEFINE DESC-SEATBELT ()
	<COND (<IS? ,SEATBELT ,LIGHTED>
	       <TELL CR "The fasten seatbelt sign overhead is lighted.">)>>

<DEFINE SEAT-OK? ("OPT" (MUST-MATCH-AND-SHUT-UP <>)
		  "AUX" (NEW-ROW <NEW-ROW>) (NEW-SEAT <NEW-SEAT>))
  <COND (.MUST-MATCH-AND-SHUT-UP
	 <COND (<AND <==? ,HERE ,SEAT>
		     <==? .NEW-ROW ,CURRENT-ROW>
		     <==? .NEW-SEAT ,CURRENT-SEAT>> T)
	       (T <>)>)
	(<N==? ,HERE ,SEAT>
	 <TELL "You'd better go to a seat first." CR>
	 <>)
	(<AND <==? .NEW-ROW ,CURRENT-ROW>
	      <SAME-SIDE? .NEW-SEAT ,CURRENT-SEAT>>
	 <COND (<OCCUPIED? .NEW-SEAT>
		<TELL "That would be impolite." CR>
		<>)
	       (T T)>)
	(T
	 <TELL "You'd better go to that seat first." CR>
	 <>)>>

<DEFINE OCCUPIED? (SEAT:<OR FIX FALSE> "OPT" (ROW:<OR FIX FALSE> <>))
  <COND (<F? .SEAT> <SET SEAT ,CURRENT-SEAT>)>
  <COND (<F? .ROW> <SET ROW ,CURRENT-ROW>)>
  <COND (<BTST <ZGET ,AISLE-STATE .ROW> .SEAT>
	 ;<NOT <0? <ANDB .SEAT <ZGET ,AISLE-STATE .ROW>>>> T)
	(T <>)>>

<DEFINE DESCRIBE-SEAT (N:<OR FIX FALSE> FF? "OPT" (LAST? <>) "AUX" PERS)
  <NAME-SEAT .N .FF?>
  <COND (<F? <SET PERS <GET-SEAT .N>>>
	 <COND (<OCCUPIED? .N>
		<TELL " is occupied">)
	       (T
		<TELL " is empty">)>)
	(T
	 <TELL " is occupied by ">
	 <DESCRIBE-AIRLINE-PERSON .PERS>)>
  <COND (.LAST?
	 <TELL ". ">)
	(T
	 <TELL "; ">)>>

<DEFINE SEAT-LETTER (N:FIX)
  <COND (<==? .N ,SEAT-A> %<ASCII !\B>)
	(<==? .N ,SEAT-B> %<ASCII !\C>)
	(<==? .N ,SEAT-C> %<ASCII !\D>)
	(<==? .N ,SEAT-D> %<ASCII !\E>)>>

<DEFINE NAME-SEAT (N:FIX "OPT" (FF? <>))
  <COND (.FF?
	 <TELL "S">)
	(T
	 <TELL "s">)>
  <TELL "eat " CHAR <SEAT-LETTER .N>>>

<DEFINE SDESC-AISLE ()
  <TELL "Aisle, at row " N ,CURRENT-ROW>>

"Wander the aisle. Front goes to Galley, back goes to area outside
 lavatory."
<DEFINE CLEAN-UP-AISLE ("AUX" OBJ NO (ANY? <>))
  <SET ANY? <POLICE-AREA ,AISLE <> ,GALLEY>>
  <COND (<T? .ANY?>
	 <TELL "You hear a scurrying, then an announcement. \"The passenger
who left ">
	 <PRINT-CONTENTS ,GALLEY>
	 <TELL " in the aisle may retrieve his property in the galley, at
the front of the aircraft." CR>)>>

<DEFINE AISLE-TO-AISLE ()
  <CLEAN-UP-AISLE>
  <COND (<==? ,P-WALK-DIR ,P?NORTH>
	 <COND (<==? ,CURRENT-ROW 1>
		,GALLEY)
	       (T
		<SETG CURRENT-ROW <- ,CURRENT-ROW 1>>
		<COND (<NOT <ROW-SEEN? ,CURRENT-ROW>>
		       <ROW-SEEN? ,CURRENT-ROW T T>
		       <UNMAKE ,AISLE ,TOUCHED>)>
		<SETUP-NEIGHBOR>
		<SETG OLD-HERE <>>
		,AISLE)>)
	(<==? ,P-WALK-DIR ,P?SOUTH>
	 <COND (<==? ,CURRENT-ROW ,AISLE-COUNT>
		,LAV-LOBBY)
	       (T
		<SETG CURRENT-ROW <+ ,CURRENT-ROW 1>>
		<COND (<NOT <ROW-SEEN? ,CURRENT-ROW>>
		       <ROW-SEEN? ,CURRENT-ROW T T>
		       <UNMAKE ,AISLE ,TOUCHED>)>
		<SETG OLD-HERE <>>
		<SETUP-NEIGHBOR>
		,AISLE)>)>>

<DEFINE SETUP-NEIGHBOR ("AUX" N)
  <COND (<F? <SET N <PORT-PERSON>>>
	 <SET N <STARBOARD-PERSON>>)>
  <CURRENT-NEIGHBOR .N>>

<DEFINE AISLE-TO-SEAT ("AUX" S1 S2 A1 A2)
	<COND (<==? ,P-WALK-DIR ,P?EAST>
	       ; "North is forward, so east is to C & D"
	       <SET A1 ,SEAT-C>
	       <SET A2 ,SEAT-D>)
	      (T
	       <SET A1 ,SEAT-A>
	       <SET A2 ,SEAT-B>)>
	<SET S1 <OCCUPIED? .A1>>
	<SET S2 <OCCUPIED? .A2>>
	<COND (<AND <T? .S1> <T? .S2>>
	       <TELL "That side of this row is full. Try somewhere else." CR>
	       <>)
	      (<NOT <OR .S1 .S2>>
	       <TELL "Both seats on that side are empty, so you'll have to pick one of them." CR>
	       <>)
	      (<T? .S1>
	       <SETG CURRENT-SEAT .A2>
	       <SETUP-NEW-SEAT>
	       ,SEAT)
	      (<T? .S2>
	       <SETG CURRENT-SEAT .A1>
	       <SETUP-NEW-SEAT>
	       ,SEAT)>>

; "Miscellany around the seat."
<OBJECT SEATBELT
	(LOC SEAT)
	(DESC "seat belt")
	(FLAGS CLOTHING)
	(SYNONYM BELT SEATBELT BUCKLE)
	(ADJECTIVE SEAT MY)
	(ACTION SEATBELT-F)>

<DEFINE SEATBELT-F ()
	<COND (<THIS-PRSI?> <>)
	      (<VERB? TIE USE WEAR>
	       <COND (<IS? ,PRSO ,WORN>
		      <TELL "You are already wearing it." CR>
		      T)
		     (T
		      <MAKE ,PRSO ,WORN>
		      <MOVE ,SEATBELT ,PLAYER>
		      <TELL "You're much more comfortable, now that you don't have to sit on it." CR>
		      T)>)
	      (<VERB? UNTIE TAKE-OFF>
	       <COND (<IS? ,PRSO ,WORN>
		      <TELL "Although you can move more freely, the buckle is causing some discomfort in your posterior region." CR>
		      <MOVE ,SEATBELT ,SEAT>
		      <UNMAKE ,PRSO ,WORN>
		      T)
		     (T
		      <TELL "You aren't wearing it." CR>)>)>>

<OBJECT SEATBELT-LIGHT
	(LOC LOCAL-GLOBALS)
	(DESC "seatbelt light")
	(FLAGS NODESC READABLE)
	(SYNONYM LIGHT SIGN)
	(ADJECTIVE WARNING SEATBELT)
	(DESCFCN SEATBELT-LIGHT-F)
	(ACTION SEATBELT-LIGHT-F)>

<DEFINE SEATBELT-LIGHT-F ("OPTIONAL" (CONTEXT <>))
  <COND (<==? .CONTEXT ,M-OBJDESC>
	 <TELL "A sign overhead says FASTEN SEAT BELT.">
	 <COND (<IS? ,SEATBELT-LIGHT ,LIGHTED>
		<TELL " It is glowing.">)>)
	(<T? .CONTEXT> <>)
	(<THIS-PRSO?>
	 <COND (<VERB? EXAMINE READ>
		<SEATBELT-LIGHT-F ,M-OBJDESC>
		<ZCRLF>)>)>>

<OBJECT SEAT-POCKET
	(LOC SEAT)
	(DESC "seat pocket")
	(FLAGS CONTAINER OPENABLE OPENED)
	(CAPACITY 10)
	(SYNONYM POCKET)
	(ADJECTIVE SEAT)>

<OBJECT AIRLINE-MAGAZINE
	(LOC SEAT-POCKET)
	(DESC "airline magazine")
	(SYNONYM MAGAZINE)
	(ADJECTIVE AIRLINE)
	(FLAGS TAKEABLE READABLE VOWEL)
	(SIZE 4)
	(ACTION AIRLINE-MAGAZINE-F)>

<DEFINE AIRLINE-MAGAZINE-F ()
	<COND (<VERB? EXAMINE READ>
	       <TELL "The magazine has several articles describing the charms of the Zalagasan jungle. It does advise against visiting the jungle unarmed: between the cannibals and the poisonous reptiles, there may not be much left for the">
	       <GENDER-PRINT " " " wo">
	       <TELL "man-eating lions." CR>)>>

<OBJECT SAFETY-CARD
	(LOC SEAT-POCKET)
	(DESC "safety card")
	(SYNONYM CARD)
	(ADJECTIVE SAFETY)
	(FLAGS TAKEABLE READABLE)
	(SIZE 3)
	(ACTION SAFETY-CARD-F)>

<DEFINE SAFETY-CARD-F ()
	<COND (<VERB? EXAMINE READ>
	       <TELL "In the usual way, it points out the many safety features of the Frobozzco 105 36-passenger aircraft, including the slightly odd one of parachutes for all passengers." CR>)>>

<OBJECT UNDER-SEAT
	(LOC SEAT)
	(DESC "under the seat")
	(SYNONYM FLOOR)
	(FLAGS SURFACE NOARTICLE NODESC VOWEL)
	(ACTION UNDER-SEAT-F)
	(CAPACITY 30)>

<DEFINE UNDER-SEAT-F ()
  <COND (<VERB? LOOK-ON>
	 <COND (<FIRST? ,UNDER-SEAT>
		<TELL "Under the seat, you have ">
		<PRINT-CONTENTS ,UNDER-SEAT>
		<TELL ,PERIOD>)
	       (T
		<TELL "There's nothing under your seat." CR>)>
	 T)
	(T <>)>>

<DEFINE SDESC-SEAT ()
	<COND (<F? <NEW-ROW>>
	       <TELL "Seat " N ,CURRENT-ROW
		     CHAR <SEAT-LETTER ,CURRENT-SEAT>>)
	      (T
	       <TELL "Seat " N <NEW-ROW>
		     CHAR <SEAT-LETTER <NEW-SEAT>>>)>>

<DEFINE GET-SEX (WHICH)
  <COND (<EQUAL? .WHICH ,SMOKER-PERSON ,BUSINESS-PERSON> <>)
	(<EQUAL? .WHICH ,GRANDMA-PERSON> T)
	(T T)>>

<DEFINE SEAT-TO-AISLE ("AUX" NEIGHBOR NEW-SEAT)
	<COND (<OR <AND <G? ,CURRENT-SEAT ,SEAT-B>
			<==? ,P-WALK-DIR ,P?WEST>>
		   <AND <L? ,CURRENT-SEAT ,SEAT-C>
			<==? ,P-WALK-DIR ,P?EAST>>
		   <==? ,P-WALK-DIR ,P?OUT>>
	       ; "Move into the aisle"
	       <ROW-SEEN? ,CURRENT-ROW T T>
	       <LEAVE-SEAT>
	       ,AISLE)
	      (<OR <==? ,CURRENT-SEAT ,SEAT-A>
		   <==? ,CURRENT-SEAT ,SEAT-D>>
	       <TELL
		"That would put you outside the airplane with no parachute."
		CR>
	       <>)
	      (T
	       <COND (<==? ,CURRENT-SEAT ,SEAT-B>
		      <SET NEIGHBOR <GET-SEAT <SET NEW-SEAT ,SEAT-A>>>)
		     (T
		      <SET NEIGHBOR <GET-SEAT <SET NEW-SEAT ,SEAT-C>>>)>
	       <COND (<T? .NEIGHBOR>
		      <COND (<N==? ,SEX <GET-SEX .NEIGHBOR>>
			     <TELL "\"">
			     <GENDER-PRINT "Sir" "Madam">
			     <TELL ", kindly keep your hands to yourself!\""
				   CR>)
			    (T
			     <TELL "Your neighbor seems to fill the seat quite nicely."
				   CR>)>
		      <>)
		     (T
		      <LEAVE-SEAT>
		      <SETG CURRENT-SEAT .NEW-SEAT>
		      ,SEAT)>)>>

<DEFINE STUCK-IN-SEAT? ()
  <COND (<T? <LOSER-CANT-LEAVE-SEAT?>>
	 <TELL CTHE ,FLIGHT-ATTENDANT
	       " stops you. \"We'll tell you when you can leave your seat, "
	       <STR-SIR-OR-MAAM> ".\"" CR>
	 T)
	(T <>)>>


; "The seat itself"
<OBJECT SEAT
	(LOC ROOMS)
	(DESC "airplane seat")
	(FLAGS IN-AIRPLANE LOCATION NODESC LIGHTED NOARTICLE INDOORS NO-NERD)
	(HEAR PHONES)
	(EAST PER SEAT-TO-AISLE)
	(WEST PER SEAT-TO-AISLE)
	(NORTH SORRY "Please don't climb over the seats.")
	(SOUTH SORRY "Please don't climb over the seats.")
	(OUT PER SEAT-TO-AISLE)
	(ACTION SEAT-F)
	(SDESC SDESC-SEAT)
	(GLOBAL FLIGHT-ATTENDANT SEATBELT-LIGHT)
	(THINGS SEAT-PSEUDO-VEC)>

<DEFINE SAME-SIDE? (X Y)
  <COND (<OR <AND <L? .X ,SEAT-C>
		  <L? .Y ,SEAT-C>>
	     <AND <G? .X ,SEAT-B>
		  <G? .Y ,SEAT-B>>> T)
	(T <>)>>

<DEFINE SEAT-F SEAT ("OPT" (CONTEXT <>) "AUX" (NEW-ROW <NEW-ROW>)
		(NEW-SEAT <NEW-SEAT>))
	<COND (<==? .CONTEXT ,M-LOOK>
	       <TELL "You are in seat " N ,CURRENT-ROW
		     CHAR <SEAT-LETTER ,CURRENT-SEAT>
		     " on your unbelievably luxurious Air Zalagasa flight to wherever it is you're going." CR>
	       <COND (<T? <PHONES-PLUGGED-IN?>>
		      <TELL "Your headphones are plugged into their receptacle.">)
		     (T
		      <TELL "There's a headphone receptacle in the seat.">)>
	       <COND (<FIRST? ,UNDER-SEAT>
		      <TELL " Under the seat, you have ">
		      <PRINT-CONTENTS ,UNDER-SEAT>
		      <TELL ".">)>
	       <DESC-SEATBELT>
	       <ZCRLF>
	       <COND (<T? <CURRENT-NEIGHBOR>>
		      <TELL "In the next seat, you see ">
		      <RANDOM-PERSON-F ,M-OBJDESC <CURRENT-NEIGHBOR>>
		      <TELL ,PERIOD>)>
	       <COND (<IS? ,SEATBELT-LIGHT ,LIGHTED>
		      <SEATBELT-LIGHT-F ,M-OBJDESC>
		      <ZCRLF>)>
	       T)
	      (<==? .CONTEXT ,M-BEG>
	       <COND (<AND <ENTERING?>
			   <N==? ,PRSO ,SEAT>>
		      <STUCK-IN-SEAT?>)
		     (<AND <VERB? SIT>
			   <F? ,PRSO>>
		      <YOURE-ALREADY "sitting down">
		      T)
		     (T <>)>)
	      (<==? .CONTEXT ,M-EXIT>
	       <COND (<STUCK-IN-SEAT?> T)
		     (T
		      <MOVE ,SEATBELT ,SEAT>
		      <UNMAKE ,SEATBELT ,SEAT>
		      <COND (<IS? ,PHONES ,WORN>
			     <UNMAKE ,PHONES ,WORN>
			     <MOVE ,PHONES ,SEAT-POCKET>)>)>)
	      (<T? .CONTEXT> <>)
	      (<NOT <ON-PLANE?>>
	       <CANT-SEE-ANY ,SEAT>)
	      (<THIS-PRSI?>
	       <COND (<VERB? PUT-UNDER>
		      <COND (<SEAT-OK?>
			     <PERFORM ,V?PUT-ON ,PRSO ,UNDER-SEAT>)>
		      T)
		     (<VERB? PUT EMPTY-INTO>
		      <COND (<AND <PRSO? PHONES>
				  <VERB? PUT>>
			     <PLUG-IN-PHONES>)
			    (T
			     <TELL "[in " THE ,SEAT-POCKET ,BRACKET>
			     <PERFORM ,PRSA ,PRSO ,SEAT-POCKET>)>)>)
	      (<VERB? PLUG UNPLUG REPLUG>
	       <TELL "[" THE ,RECEPTACLE ,BRACKET>
	       <PERFORM ,PRSA ,PRSO ,RECEPTACLE>
	       T)
	      (<VERB? LEAVE STAND RAISE>
	       <COND (<F? <SEAT-OK? T>>
		      <TELL "You aren't in that seat." CR>)
		     (T
		      <LEAVE-SEAT>
		      <GOTO ,AISLE>
		      T)>)
	      (<VERB? WALK-TO SIT ENTER>
	       <COND (<AND <==? ,HERE ,LAVATORY>
			   <T? <ZAPPLY <GETP ,HERE ,P?ACTION> ,M-EXIT>>>
		      <RETURN T .SEAT>)>
	       <COND (<AND <==? ,HERE ,SEAT>
			   <==? ,CURRENT-ROW .NEW-ROW>
			   <==? ,CURRENT-SEAT .NEW-SEAT>>
		      <ALREADY-THERE>)
		     (<STUCK-IN-SEAT?> <RETURN T .SEAT>)
		     (<OCCUPIED? .NEW-SEAT .NEW-ROW>
		      <COND (<==? .NEW-ROW ,CURRENT-ROW>
			     <TELL "You can see that the seat is already taken." CR>
			     <RETURN T .SEAT>)
			    (T
			     <TELL "When you reach that row, you see that the seat of your dreams is already taken" ,PCR>
			     <COND (<==? ,HERE ,SEAT>
				    <LEAVE-SEAT>)>
			     <SETG CURRENT-ROW .NEW-ROW>
			     <SETUP-NEIGHBOR>
			     <SETG HERE ,AISLE>)>)
		     (T
		      <COND (<==? ,HERE ,SEAT> <LEAVE-SEAT>)>
		      <SETG CURRENT-ROW .NEW-ROW>
		      <SETG CURRENT-SEAT .NEW-SEAT>
		      <SETUP-NEW-SEAT>
		      <SETG OLD-HERE <>>
		      <SETG HERE ,SEAT>)>
	       <GOTO ,HERE>
	       T)
	      (<VERB? EXAMINE LOOK-INSIDE SEARCH>
	       <COND (<AND <==? .NEW-SEAT ,CURRENT-SEAT>
			   <==? .NEW-ROW ,CURRENT-ROW>>
		      <TELL "It's a perfectly ordinary airline seat." CR>)
		     (<OCCUPIED? .NEW-SEAT .NEW-ROW>
		      <TELL "It's occupied">
		      <COND (<G? <GET-SEAT .NEW-SEAT .NEW-ROW> 0>
			     <TELL " by ">
			     <RANDOM-PERSON-F ,M-OBJDESC
					      <GET-SEAT .NEW-SEAT .NEW-ROW>>)>
		      <TELL ,PERIOD>)
		     (T
		      <TELL "It's vacant." CR>)>)
	      (<F? <SEAT-OK?>> T)
	      (<VERB? LOOK-INSIDE SEARCH>
	       <COND (<==? .NEW-SEAT ,CURRENT-SEAT>
		      <PERFORM ,V?LOOK-INSIDE ,SEAT-POCKET>)
		     (T
		      <TELL "There's nothing special in " THE ,SEAT-POCKET
			    ,PERIOD>)>)
	      (<VERB? LOOK-UNDER>
	       <COND (<==? .NEW-SEAT ,CURRENT-SEAT>
		      <PERFORM ,V?LOOK-ON ,UNDER-SEAT>)
		     (T
		      <TELL "There's nothing special under that seat." CR>)>)>>

<DEFINE LEAVE-SEAT ("AUX" NEIGHBOR)
	<COND (<IS? ,SEATBELT ,WORN>
	       <UNMAKE ,SEATBELT ,WORN>
	       <MOVE ,SEATBELT ,SEAT>)>
	<COND (<OR <IS? ,PHONES ,WORN>
		   <META-IN? ,PHONES ,PLAYER>>
	       <TELL "You leave your " D ,PHONES " behind" ,PCR>
	       <UNMAKE ,PHONES ,WORN>
	       <PHONES-PLUGGED-IN? <>>
	       <MOVE ,PHONES ,SEAT-POCKET>)>
	<SETG OLD-HERE <>>
	<LAST-ROW ,CURRENT-ROW>
	<LAST-SEAT ,CURRENT-SEAT>
	<DEQUEUE I-CONVERSE>
	<COND (<OR <AND <==? ,CURRENT-SEAT ,SEAT-A>
			<SET NEIGHBOR <GET-SEAT ,SEAT-B>>>
		   <AND <==? ,CURRENT-SEAT ,SEAT-D>
			<SET NEIGHBOR <GET-SEAT ,SEAT-C>>>>
	       <COND (<PROB 20>
		      <TELL "You stumble over your neighbor's feet as you leave your seat, causing some irritated mutterings" ,PCR>)>)>>

<CONSTANT NORMAL-SEAT
	  <PLTABLE SEATBELT SEAT-POCKET UNDER-SEAT
		   RECEPTACLE>>
<CONSTANT NORMAL-SEAT-POCKET
	  <PLTABLE AIRLINE-MAGAZINE SAFETY-CARD PHONES>>

<DEFINE SETUP-NEW-SEAT ("OPT" (FORCE? <>))
  <SETUP-NEIGHBOR>
  <NEW-ROW 0>
  <NEW-SEAT 0>
  <COND (<AND <==? ,CURRENT-ROW <LAST-ROW>>
	      <==? ,CURRENT-SEAT <LAST-SEAT>>
	      <NOT .FORCE?>>
	 ; "Just returned to previous seat, so OK"
	 T)
	(T
	 <PHONES-PLUGGED-IN? <>>
	 <COND (<NOT <META-IN? ,AIRLINE-MAGAZINE ,PLAYER>>
		<MOVE ,AIRLINE-MAGAZINE ,SEAT-POCKET>)>
	 <COND (<NOT <META-IN? ,SAFETY-CARD ,PLAYER>>
		<MOVE ,SAFETY-CARD ,SEAT-POCKET>)>
	 <COND (<G? <+ <POLICE-AREA ,SEAT ,NORMAL-SEAT>
		       <POLICE-AREA ,SEAT-POCKET ,NORMAL-SEAT-POCKET>
		       <POLICE-AREA ,UNDER-SEAT <>>> 0>
		<COND (<NOT .FORCE?>
		       <FLIGHT-ATTENDANT-APPEARS>
		       <TELL "Just as you're settling in, a flustered flight attendant rushes up to you. \"You left your personal belongings in your old seat, " <STR-SIR-OR-MAAM> "! Please don't let it happen again.\"" CR CR>
		       <FLIGHT-ATTENDANT-LEAVES>)>)>)>>

<DEFINE STR-SIR-OR-MAAM ("OPT" (CAPS <>))
  <COND (<T? .CAPS>
	 <COND (<T? ,SEX> "Ma'am")
	       (T "Sir")>)
	(,SEX "ma'am")
	(T "sir")>>

"Get personal belongings out of seat, and give them to steward for return."
<DEFINE POLICE-AREA (OBJ TBL "OPT" (WHERE ,PLAYER) (DREAMING? <>)
		     "AUX" NOBJ LEN (N 0))
	<COND (<SET NOBJ <FIRST? .OBJ>>
	       <COND (.TBL
		      <SET LEN <ZGET .TBL 0>>
		      <SET TBL <ZREST .TBL 2>>)>
	       <REPEAT ()
	         <COND (<AND <OR <NOT .TBL>
				 <NOT <INTBL? .NOBJ .TBL .LEN>>>
			     <NOT <IS? .NOBJ ,PERSON>>
			     <N==? .NOBJ ,PLAYER>>
			<SET OBJ <NEXT? .NOBJ>>
			<SET N 1>
			<COND (<NOT .DREAMING?> <MOVE .NOBJ .WHERE>)>
			<SET NOBJ .OBJ>)
		       (T
			<SET NOBJ <NEXT? .NOBJ>>)>
		 <COND (<NOT .NOBJ> <RETURN>)>>)>
	.N>

<CONSTANT SEAT-TRANSLATIONS <TABLE (PURE BYTE)
				   ,SEAT-A ,SEAT-B ,SEAT-C ,SEAT-D>>

; "Make sure we've got a good seat number, and set things up so the
   parser will like it."

<CONSTANT SEAT-LETTER-NAMES
	  <PLTABLE <VOC "B" OBJECT> <VOC "C" OBJECT> <VOC "D" OBJECT>
		   <VOC "E" OBJECT>>>

<VOC "SEAT" OBJECT>
<VOC "REAR" OBJECT>
<VOC "LOBBY" OBJECT>

<DEFINE NOT-SEAT-NAME? NSN (ADJ NAM "AUX" (NMVEC <ZREST ,SEAT-LETTER-NAMES 2>)
			    (NMLEN <ZGET ,SEAT-LETTER-NAMES 0>))
  <COND (.ADJ
	 <COND (<NOT <EQUAL? .ADJ ,W?SEAT ,W?INTNUM ,W?MY ,W?AISLE ,W?ROW>>
		<COND (<NOT <INTBL? .ADJ .NMVEC .NMLEN>>
		       <RETURN T .NSN>)>)>)>
  <COND (.NAM
	 <COND (<N==? .NAM ,W?INTNUM>
		<COND (<N==? .NAM ,W?SEAT>
		       <COND (<NOT <INTBL? .NAM .NMVEC .NMLEN>>
			      T)
			     (T <>)>)
		      (T <>)>)
	       (T <>)>)
	(T <>)>>

<DEFINE MATCH-SEAT-NAME MATCH (ADJ NAM ARG "AUX" ROW SNUM
			       (NMVEC <ZREST ,SEAT-LETTER-NAMES 2>)
			       (NMLEN <ZGET ,SEAT-LETTER-NAMES 0>)
			       TAB)
  <COND (<AND <F? .ADJ>
	      <F? .NAM>>
	 <>)
	(<EQUAL? .NAM ,W?PHONE ,W?TELEPHONE ,W?REAR ,W?LOBBY>
	 ,LAV-LOBBY)
	(<OR <INTBL? .ADJ <SET TAB <GETPT ,LAVATORY ,P?SYNONYM>>
		    </ <PTSIZE .TAB> 2>>
	     <INTBL? .NAM .TAB </ <PTSIZE .TAB> 2>>>
	 ,LAVATORY)
	(<NOT-SEAT-NAME? .ADJ .NAM>
	 ; "Random person/object"
	 <REPEAT ((LEN <ZGET .ARG 0>) (VEC <ZREST .ARG 2>)
		  (COULD-BE-PERSON? <>) TMP (WIN? <>) ONAM)
	   <SET ONAM <ZGET .VEC 1>>
	   ; "Kludged due to compiler bug"
	   <COND (<OR <NOT .ADJ> <==? .ADJ <ZGET .VEC 0>>>
		  <COND (<OR <NOT .NAM> <==? .NAM .ONAM>>
			 <SET WIN? T>)>)>
	   <COND (<F? .WIN?>
		  <COND (<AND <NOT .NAM> <==? .NAM .ONAM>>
			 <SET WIN? T>)>)>
	   <COND (.WIN?
		  <COND (<G=? <SET TMP <ZGET .VEC 2>> ,OBJECT-BREAK>
			 <PUTP ,RANDOM-OBJECT ,P?PSEUDO-TABLE .TMP>
			 <RETURN ,RANDOM-OBJECT .MATCH>)
			(<AND <==? .TMP ,PURSER-PERSON>
			      <IS? ,PURSER ,SEEN>>
			 <THIS-IS-IT ,PURSER>
			 <RETURN ,PURSER .MATCH>)
			(<AND <EQUAL? ,HERE ,SEAT ,AISLE>
			      <EQUAL? .TMP <CURRENT-NEIGHBOR>>>
			 ; "Don't recognize any of these guys except
			    when they're actually present."
			 <PUTP ,RANDOM-PERSON ,P?PSEUDO-TABLE .TMP>
			 <COND (<GET-SEX .TMP>
				<MAKE ,RANDOM-PERSON ,FEMALE>)
			       (T
				<UNMAKE ,RANDOM-PERSON ,FEMALE>)>
			 <THIS-IS-IT ,RANDOM-PERSON>
			 <RETURN ,RANDOM-PERSON .MATCH>)
			(T
			 ; "Allow search to continue, since there may be
			    other matches later in the vector."
			 <SET COULD-BE-PERSON? T>)>)>
	   <COND
	    (<L? <SET LEN <- .LEN 3>> 3>
	     <COND
	      (.COULD-BE-PERSON?
	       <RETURN ,FATAL-VALUE .MATCH>)>
	     <RETURN <> .MATCH>)>
	   <SET WIN? <>>
	   <SET VEC <ZREST .VEC 6>>>)
	(<OR <INTBL? .NAM .NMVEC .NMLEN>
	     <INTBL? .ADJ .NMVEC .NMLEN>>
	 <COND (<OR <==? .ADJ ,W?SEAT>
		    <==? .ADJ ,W?INTNUM>
		    <NOT .NAM>>
		<COND (<==? .ADJ ,W?INTNUM>
		       <NEW-ROW ,P-NUMBER>)
		      (T
		       <COND (<N==? .ADJ ,W?SEAT>
			      <SET NAM .ADJ>
			      <SET ADJ <>>)>
		       <NEW-ROW ,CURRENT-ROW>)>
		<NEW-SEAT <COND (<==? .NAM ,W?B>
				 ,SEAT-A)
				(<==? .NAM ,W?C>
				 ,SEAT-B)
				(<==? .NAM ,W?D>
				 ,SEAT-C)
				(<==? .NAM ,W?E>
				 ,SEAT-D)>>
		,SEAT)>)
	(<OR <==? .NAM ,W?SEAT>
	     <F? .NAM>>
	 <COND (<N==? ,HERE ,SEAT>
		<SETG CURRENT-SEAT <LAST-SEAT>>
		<SETG CURRENT-ROW <LAST-ROW>>)>
	 <NEW-ROW ,CURRENT-ROW>
	 <NEW-SEAT ,CURRENT-SEAT>
	 ,SEAT)
	(<AND <EQUAL? .ADJ ,W?AISLE ,W?ROW>
	      <==? .NAM ,W?INTNUM>>
	 <COND (<OR <L? ,P-NUMBER 1>
		    <G? ,P-NUMBER ,AISLE-COUNT>>
		,FATAL-VALUE)
	       (T
		<NEW-ROW ,P-NUMBER>
		,AISLE)>)
	(<AND <==? .NAM ,W?INTNUM>
	      <G=? ,P-SEAT-NUMBER:FIX 0>>
	 <SET ROW <+ </ ,P-SEAT-NUMBER:FIX 4> 1>>
	 <SET SNUM <GETB ,SEAT-TRANSLATIONS <MOD ,P-SEAT-NUMBER:FIX 4>>>
	 <COND (<OR <L? .ROW 1>
		    <G? .ROW ,AISLE-COUNT>>
		,FATAL-VALUE)
	       (T
		<NEW-ROW .ROW>
		<NEW-SEAT .SNUM>
		,SEAT)>)>>

;"Object for useless random objects on the airplane: the escape
  hatch, etc."
<MSETG OBJECT-BREAK 20>
<MSETG HATCH-OBJECT <+ ,OBJECT-BREAK 1>>
<MSETG FORM-OBJECT <+ ,OBJECT-BREAK 2>>
<MSETG GRANDCHILDREN-OBJECT <+ ,OBJECT-BREAK 3>>
<MSETG MEAL-OBJECT <+ ,OBJECT-BREAK 4>>
<MSETG VISA-NUMBER-OBJECT <+ ,OBJECT-BREAK 5>>
<MSETG COMPUTER-OBJECT <+ ,OBJECT-BREAK 6>>
<MSETG BABY-OBJECT <+ ,OBJECT-BREAK 7>>
<MSETG MOVIE-OBJECT <+ ,OBJECT-BREAK 8>>
<MSETG RECIPE-OBJECT <+ ,OBJECT-BREAK 9>>

<MSETG SMOKER-PERSON 1>
<MSETG GRANDMA-PERSON 2>
<MSETG BUSINESS-PERSON 3>
<MSETG MOMMA-PERSON 4>
<MSETG PERSON-COUNT 4>
<MSETG PURSER-PERSON 5>

<OBJECT RANDOM-OBJECT
	(ACTION RANDOM-OBJECT-F)
	(SDESC SDESC-RANDOM-OBJECT)
	(DESCFCN RANDOM-OBJECT-F)
	(PSEUDO-TABLE 0)>

<DEFINE SDESC-RANDOM-OBJECT ("AUX"
			     (WHICH <GETP ,RANDOM-OBJECT ,P?PSEUDO-TABLE>))
  <COND (<F? .WHICH>
	 <TELL "something">)
	(<==? .WHICH ,HATCH-OBJECT>
	 <TELL "hatch">)
	(<==? .WHICH ,FORM-OBJECT>
	 <TELL "form">)
	(<==? .WHICH ,GRANDCHILDREN-OBJECT>
	 <TELL "grandchildren">)
	(<==? .WHICH ,MEAL-OBJECT>
	 <TELL "meal">)
	(<==? .WHICH ,VISA-NUMBER-OBJECT>
	 <TELL "visa number">)
	(<==? .WHICH ,COMPUTER-OBJECT>
	 <TELL "computer">)
	(<==? .WHICH ,BABY-OBJECT>
	 <TELL "baby">)
	(<==? .WHICH ,MOVIE-OBJECT>
	 <TELL "movie">)
	(<==? .WHICH ,RECIPE-OBJECT>
	 <TELL "recipe cartridge">)>>

<DEFINE ON-PLANE? ()
  <COND (<IS? ,HERE ,IN-AIRPLANE> T)
	(T <>)>>

<DEFINE RANDOM-OBJECT-F ("OPT" (CONTEXT <>)
			 "AUX" (WHICH <GETP ,RANDOM-OBJECT ,P?PSEUDO-TABLE>)
			       STR)
	<COND (<==? .WHICH ,FORM-OBJECT>
	       <COND (<AND <THIS-PRSI?>
			   <IS? ,PRSO ,PERSON>> <>)
		     (<AND <T? <ON-PLANE?>> <==? <CURRENT-SCENE> ,VISA-SCENE>>
		      <>)
		     (T
		      <TELL "Form? What form?" CR>)>)
	      (<==? .WHICH ,VISA-NUMBER-OBJECT>
	       <COND (<==? .CONTEXT ,M-OBJDESC> <TELL "visa number">)
		     (<T? .CONTEXT> <>)
		     (<OR <NOT <ON-PLANE?>>
			  <NOT <IN? ,IFORM ,PLAYER>>>
		      <TELL "There's no visa number to be found." CR>)
		     (<THIS-PRSI?> <>)
		     (<VERB? EXAMINE>
		      <COND (<T? <FORM-FILLED-OUT?>>
			     <TELL "You gave ">
			     <SHOW-FIELD ,IMM-VISA ,IMMIGRATION-FORM>
			     <TELL ". Hope it's right." CR>)
			    (T
			     <TELL "You'd better get a visa number soon."
				   CR>)>)>)
	      (<==? .WHICH ,HATCH-OBJECT>
	       <COND (<==? .CONTEXT ,M-OBJDESC>
		      <TELL "escape hatch">)
		     (<T? .CONTEXT> <>)
		     (<NOT <EQUAL? ,HERE ,LAV-LOBBY ,OUTSIDE-PLANE>>
		      <CANT-SEE-ANY <> "the hatch">)
		     (<THIS-PRSI?>
		      <>)
		     (<VERB? EXAMINE>
		      <TELL "The hatch is closed." CR>
		      T)
		     (<VERB? OPEN UNLOCK>
		      <COND (<==? ,HERE ,OUTSIDE-PLANE>
			     <TELL "There's no way to open the hatch from the outside when it's locked from the inside." CR>)
			    (T
			     <TELL "As you should have expected, opening the hatch causes rapid decompression of the cabin. The escaping air pushes you out the hatch, whereupon you find yourself without any means of support, visible or invisible.">
			     <JIGS-UP>
			     T)>)
		     (<VERB? CLOSE LOCK>
		      <ALREADY-CLOSED>
		      T)
		     (<VERB? KNOCK>
		      <COND (<==? ,HERE ,OUTSIDE-PLANE>
			     <TELL
"After a few moments of violent knocking, " THE ,FLIGHT-ATTENDANT
" turns around. She seems terribly pleased to be able to serve you yet again. She cheerfully opens the hatch, inquires \"May I help you?\" and thoughtfully waves goodbye as you plummet headlong into the night" ,PCR>
			     <TO-IN-AIR>
			     T)
			    (T
			     <TELL "There's no one outside to answer." CR>
			     T)>)
		     (<VERB? ENTER THROUGH>
		      <ITS-CLOSED>)
		     (<AND <EXITING?>
			   <==? ,HERE ,OUTSIDE-PLANE>>
		      <TELL "You've already done that." CR>
		      T)
		     (T <>)>)
	      (<==? .WHICH ,MOVIE-OBJECT>
	       <COND (<NOT <EQUAL? ,HERE ,AISLE ,SEAT>>
		      <CANT-SEE-ANY ,RANDOM-OBJECT>)
		     (<THIS-PRSI?> <>)
		     (<VERB? EXAMINE>
		      <DESCRIBE-MOVIE>)
		     (<VERB? LISTEN>
		      <COND (<AND <T? <PHONES-PLUGGED-IN?>>
				  <IS? ,PHONES ,WORN>>
			     <TELL "About all you can hear is small-arms fire, explosions, and occasional screams of pain." CR>)
			    (T
			     <TELL ,CANT "hear much, since the soundtrack
is (mercifully) not put on the airplane's loudspeakers." CR>)>)>)
	      (<==? .WHICH ,BABY-OBJECT>
	       <COND (<NOT <ON-PLANE?>>
		      <CANT-SEE-ANY ,RANDOM-OBJECT>)
		     (<N==? <CURRENT-NEIGHBOR> ,MOMMA-PERSON>
		      <TELL
		       "There doesn't seem to be one in the immediate vicinity."
		       CR>)
		     (<VERB? TAKE>
		      <TELL "That's probably not the best idea you ever had."
			    CR>)
		     (<VERB? EXAMINE>
		      <TELL "It's adorable, just as you'd expect." CR>)>)
	      (<OR <==? .WHICH ,COMPUTER-OBJECT>
		   <==? .WHICH ,RECIPE-OBJECT>>
	       <COND (<OR <NOT <ON-PLANE?>>
			  <N==? <CURRENT-NEIGHBOR> ,BUSINESS-PERSON>>
		      <CANT-SEE-ANY ,RANDOM-OBJECT>)
		     (<VERB? EXAMINE>
		      <COND (<==? .WHICH ,COMPUTER-OBJECT>
			     <PERFORM ,V?EXAMINE ,COMPUTER>)
			    (T
			     <PERFORM ,V?EXAMINE ,RECIPE>)>
		      T)
		     (<TOUCHING?>
		      <TELL "That would be quite rude. It isn't your "
			    D ,RANDOM-OBJECT ,PERIOD>)
		     (<THIS-PRSI?>
		      <COND (<VERB? ASK-ABOUT ASK-FOR>
			     <COND (<AND <==? ,PRSO ,RANDOM-PERSON>
					 <==? <GETP ,PRSO ,P?PSEUDO-TABLE>
					      ,BUSINESS-PERSON>>
				    <>)
				   (T
				    <TELL CTHEO " doesn't have a computer."
					  CR>)>)
			    (T <>)>)>)
	      (<==? .WHICH ,GRANDCHILDREN-OBJECT>
	       <COND (<NOT <ON-PLANE?>>
		      <CANT-SEE-ANY ,RANDOM-OBJECT>)
		     (<AND <THIS-PRSI?>
			   <VERB? ASK-ABOUT ASK-FOR>
			   <==? ,PRSO ,RANDOM-PERSON>
			   <==? <GETP ,PRSO ,P?PSEUDO-TABLE>
				,GRANDMA-PERSON>>
		      <>)
		     (T
		      <TELL
		       "That's really a rather personal question, you know."
		       CR>)>)>>

<CONSTANT OTHER-AIRPLANE-OBJECTS
	  <PLTABLE <VOC "ESCAPE" ADJ> <VOC "HATCH" OBJECT>
		   ,HATCH-OBJECT
		   <> <VOC "EXIT" OBJECT>
		   ,HATCH-OBJECT
		   <> <VOC "WINDOW" OBJECT>
		   ,HATCH-OBJECT
		   <> <VOC "FORM" OBJECT>
		   ,FORM-OBJECT
		   <VOC "HIS" ADJ> <VOC "FORM" OBJECT>
		   ,FORM-OBJECT
		   <VOC "HER" ADJ> <VOC "FORM" OBJECT>
		   ,FORM-OBJECT
		   <VOC "YOUR" ADJ> <VOC "FORM" OBJECT>
		   ,FORM-OBJECT
		   <VOC "IMMIGRATION" ADJ> <VOC "FORM" OBJECT>
		   ,FORM-OBJECT
		   <VOC "VISA" ADJ> <VOC "NUMBER" OBJECT>
		   ,VISA-NUMBER-OBJECT
		   <VOC "YOUR" ADJ> <VOC "VISA" OBJECT>
		   ,VISA-NUMBER-OBJECT
		   <VOC "YOUR" ADJ> <VOC "NUMBER" OBJECT>
		   ,VISA-NUMBER-OBJECT
		   <VOC "MY" ADJ> <VOC "VISA" OBJECT>
		   ,VISA-NUMBER-OBJECT
		   <VOC "MY" ADJ> <VOC "NUMBER" OBJECT>
		   ,VISA-NUMBER-OBJECT
		   <VOC "YOUR" ADJ> <VOC "GRANDCHILDREN" OBJECT>
		   ,GRANDCHILDREN-OBJECT
		   <> <VOC "ROGER" OBJECT>
		   ,GRANDCHILDREN-OBJECT
		   <> <VOC "DENNIS" OBJECT>
		   ,GRANDCHILDREN-OBJECT
		   <> <VOC "BRUCE" OBJECT>
		   ,GRANDCHILDREN-OBJECT
		   <> <VOC "DENNIS" OBJECT>
		   ,GRANDCHILDREN-OBJECT
		   <> <VOC "TOM" OBJECT>
		   ,GRANDCHILDREN-OBJECT
		   <VOC "YOUR" ADJ> <VOC "GRANDDAUGHTER" OBJECT>
		   ,GRANDCHILDREN-OBJECT
		   <VOC "YOUR" ADJ> <VOC "GRANDSON" OBJECT>
		   ,GRANDCHILDREN-OBJECT
		   <VOC "OLD" ADJ> <VOC "WOMAN" OBJECT>
		   ,GRANDMA-PERSON
		   <> <VOC "WOMAN" OBJECT>
		   ,GRANDMA-PERSON
		   <> <VOC "GRANDMOTHER" OBJECT>
		   ,GRANDMA-PERSON
		   <VOC "YOUR" ADJ> <VOC "COMPUTER" OBJECT>
		   ,COMPUTER-OBJECT
		   <VOC "OTHER" ADJ> <VOC "COMPUTER" OBJECT>
		   ,COMPUTER-OBJECT
		   <VOC "LAPTOP" ADJ> <VOC "COMPUTER">
		   ,COMPUTER-OBJECT
		   <VOC "HIS" ADJ> <VOC "COMPUTER">
		   ,COMPUTER-OBJECT
		   <VOC "BOYSENBERRY" ADJ> <VOC "COMPUTER" OBJECT>
		   ,COMPUTER-OBJECT
		   <> <VOC "COMPUTER" OBJECT>
		   ,COMPUTER-OBJECT
		   <VOC "BUSINESS" ADJ> <VOC "MAN" OBJECT>
		   ,BUSINESS-PERSON
		   <VOC "HARRIED" ADJ> <VOC "MAN" OBJECT>
		   ,BUSINESS-PERSON
		   <> <VOC "MAN" OBJECT>
		   ,BUSINESS-PERSON
		   <VOC "YOUR" ADJ> <VOC "CHILD" OBJECT>
		   ,BABY-OBJECT
		   <VOC "YOUR" ADJ> <VOC "BABY" OBJECT>
		   ,BABY-OBJECT
		   <VOC "YOUR" ADJ> <VOC "SON" OBJECT>
		   ,BABY-OBJECT
		   <VOC "YOUNG" ADJ> <VOC "WOMAN" OBJECT>
		   ,MOMMA-PERSON
		   <> <VOC "WOMAN" OBJECT>
		   ,MOMMA-PERSON
		   <VOC "YOUNG" ADJ> <VOC "MOTHER" OBJECT>
		   ,MOMMA-PERSON
		   <> <VOC "MOTHER" OBJECT>
		   ,MOMMA-PERSON
		   <VOC "CURRENT" ADJ> <VOC "MOVIE" OBJECT>
		   ,MOVIE-OBJECT
		   <VOC "CURRENT" ADJ> <VOC "ENTERTAINMENT" OBJECT>
		   ,MOVIE-OBJECT
		   <VOC "IRRITABLE" ADJ> <VOC "FELLOW" OBJECT>
		   ,SMOKER-PERSON
		   <VOC "IRRITABLE" ADJ> <VOC "MAN" OBJECT>
		   ,SMOKER-PERSON
		   <> <VOC "MAN" OBJECT>
		   ,SMOKER-PERSON
		   <VOC "BURLY" ADJ> <VOC "MAN" OBJECT>
		   ,PURSER-PERSON
		   <> <VOC "PURSER" OBJECT>
		   ,PURSER-PERSON>>

<CONSTANT SEAT-PSEUDO-VEC <PTABLE MATCH-SEAT-NAME OTHER-AIRPLANE-OBJECTS>>

<OBJECT GALLEY
	(LOC ROOMS)
	(SOUTH TO AISLE)
	(DESC "Airplane Galley")
	(SYNONYM GALLEY)
	(LDESC "You're in the galley at the front of the airplane. There isn't much of interest here, unless you want to hang around and annoy the flight attendants.")
	(GLOBAL FLIGHT-ATTENDANT SEATBELT-LIGHT)
	(THINGS SEAT-PSEUDO-VEC)
	(FLAGS IN-AIRPLANE LOCATION VOWEL LIGHTED INDOORS)
	(ACTION GALLEY-F)>

<DEFINE GALLEY-F ("OPT" (CONTEXT <>))
  <COND (<==? .CONTEXT ,M-ENTERING>
	 <SETG CURRENT-ROW 1>
	 <>)
	(T <>)>>

<OBJECT LAV-LOBBY
	(LOC ROOMS)
	(NORTH TO AISLE)
	(SOUTH TO LAVATORY IF LAV-DOOR IS OPEN
	       ELSE "There's already somebody in the lavatory.")
	(DESC "Rear of Airplane")
	(FLAGS IN-AIRPLANE LOCATION LIGHTED INDOORS)
	(THINGS SEAT-PSEUDO-VEC)
	(GLOBAL LAV-DOOR FLIGHT-ATTENDANT SEATBELT-LIGHT)
	(LDESC "You're in a lobby-like area near the back of the airplane, enjoying the bumpy ride. The lavatory opens off this area.")
	(ACTION LAV-LOBBY-F)>

<DEFINE LAV-LOBBY-F ("OPT" (CONTEXT <>))
  <COND (<==? .CONTEXT ,M-ENTERING>
	 <SETG CURRENT-ROW ,AISLE-COUNT>
	 <>)
	(<==? .CONTEXT ,M-EXIT>
	 <COND (<IN? ,BEEZER ,AIRPHONE>
		<TELL "You hang up the phone and take your " D ,BEEZER
		      " out." CR>
		<MAKE ,AIRPHONE ,OPENED>
		<MOVE ,BEEZER ,PLAYER>
		<>)
	       (T <>)>)
	(T <>)>>

<OBJECT SINK
	(LOC LAVATORY)
	(SDESC SDESC-SINK)
	(SYNONYM SINK BASIN)
	(ADJECTIVE LAVATORY)
	(ACTION SINK-F)>

<DEFINE SDESC-SINK ()
  <COND (<AND <T? <TEETH-BRUSHED?>>
	      <F? <SINK-CLEANED?>>>
	 <TELL "dirty sink">)
	(T
	 <TELL "spotless sink">)>>

<DEFINE SINK-F ()
  <COND (<THIS-PRSO?>
	 <COND (<VERB? CLEAN>
		<COND (<N==? ,PRSI ,TOWEL>
		       <COND (,PRSI
			      <TELL CTHE ,PRSI " probably isn't the right tool for the job." CR>)
			     (T
			      <TELL "Your bare hands wouldn't seem adequate to the task." CR>)>)
		      (T
		       <SINK-CLEANED? T>
		       <ZPUT <GETPT ,SINK ,P?ADJECTIVE> 0 ,W?SPOTLESS>
		       <ZREMOVE ,TOWEL>
		       <TELL "There, that wasn't so hard, was it? You throw
the soiled towel away, and pause briefly to admire your reflection in the
sink." CR>)>)
	       (<VERB? EXAMINE LOOK-INSIDE>
		<COND (<AND <T? <TEETH-BRUSHED?>>
			    <F? <SINK-CLEANED?>>>
		       <TELL "It's just your ordinary airplane sink, except
now it seems to have some sort of multi-colored scum all over it, and is
most unpleasant." CR>)
		      (T
		       <TELL "It's an ordinary spotless airplane sink."
			     CR>)>)>)>>

<OBJECT TOWEL
	(LOC LAVATORY)
	(FLAGS TAKEABLE TOOL)
	(DESC "paper towel")
	(SYNONYM TOWEL)
	(ADJECTIVE PAPER)>

<OBJECT LAVATORY
	(LOC ROOMS)
	(OUT TO LAV-LOBBY IF LAV-DOOR IS OPEN ELSE
	 "Better open the door first.")
	(NORTH TO LAV-LOBBY IF LAV-DOOR IS OPEN ELSE
	 "Better open the door first.")
	(SYNONYM LAVATORY BATHROOM CAN LAV)
	(DESC "Lavatory")
	(LDESC "This is just your ordinary airplane lavatory.")
	(FLAGS IN-AIRPLANE LOCATION LIGHTED INDOORS NO-NERD)
	(THINGS SEAT-PSEUDO-VEC)
	(GLOBAL LAV-DOOR FLIGHT-ATTENDANT SEATBELT-LIGHT)
	(ACTION LAVATORY-F)>

<CONSTANT LAV-SIGN-TEXT
	  <PLTABLE 33
		   "A sign on the wall says:       "
		   "\"As a courtesy to your fellow  "
		   "passengers, please wipe the    "
		   "sink clean when you're         "
		   "finished.\"                     ">>

<OBJECT LAV-SIGN
	(DESC "sign")
	(LOC LAVATORY)
	(FLAGS READABLE NODESC)
	(SYNONYM SIGN)
	(ACTION LAV-SIGN-F)>

<DEFINE LAV-SIGN-F ()
  <COND (<AND <THIS-PRSO?>
	      <VERB? READ EXAMINE>>
	 <DISPLAY-SIGN ,LAV-SIGN-TEXT>
	 T)
	(T <>)>>

<DEFINE LAVATORY-F ("OPT" (CONTEXT 0))
  <COND (<==? .CONTEXT ,M-ENTERING>
	 <SETG CURRENT-ROW ,AISLE-COUNT>
	 <UNMAKE ,LAV-DOOR ,OPENED>
	 <MAKE ,LAV-DOOR ,LOCKED>
	 <SETG DO-WINDOW ,LAV-SIGN-TEXT>
	 <TELL "Naturally, you close and lock the door when you enter" ,PCR>
	 <MOVE ,TOWEL ,LAVATORY>
	 <>)
	(<==? .CONTEXT ,M-EXIT>
	 <MAKE ,LAV-DOOR ,OPENED>
	 <UNMAKE ,LAV-DOOR ,LOCKED>
	 <COND (<AND <==? <CURRENT-SCENE> ,FOOD-SCENE>
		     <G? <MEAL-SCRIPT> 5>
		     <T? <SINK-CLEANED?>>
		     <T? <DREAMING?>>>
		; "If cleaned sink, nail for not returning to seat."
		<DEQUEUE I-RETURN-TO-SEAT>
		<DEQUEUE I-DIDNT-RETURN-TO-SEAT>
		<TELL "Somehow the combination of opening the lavatory door
and the bumpy ride wakes you up, and you realize that the entire meal was only
a dream." CR>
		<ZREMOVE ,TOOTHBRUSH>
		<END-CURRENT-SCENE>
		T)
	       (T <>)>)
	(<==? .CONTEXT ,M-BEG>
	 <COND (<VERB? SIT>
		<COND (<T? <SITTING?>>
		       <TELL "You already are." CR>)
		      (T
		       <TELL "Ah, that's better." CR>)>
		<SITTING? T>
		T)
	       (<VERB? STAND>
		<COND (<F? <SITTING?>>
		       <TELL "You already are." CR>)
		      (T
		       <TELL "OK." CR>)>
		<SITTING? <>>
		T)
	       (<VERB? WAVE-AT>
		<TELL "A voice comes from a well-hidden speaker. \"That's very
charming, ">
		<GENDER-PRINT "Mr. " "Ms. ">
		<PRINT-LAST-NAME>
		<TELL ". Now perhaps you should get on with your business and
get back to your seat.\"" CR>
		T)>)
	(<T? .CONTEXT> <>)
	(<NOT <ON-PLANE?>>
	 <TELL "There's no lavatory here, alas." CR>)
	(<THIS-PRSO?>
	 <COND (<ENTERING?>
		<COND (<==? ,HERE ,LAVATORY>
		       <ALREADY-THERE>)
		      (T
		       <COND (<==? ,HERE ,SEAT>
			      <LEAVE-SEAT>)>
		       <SETG CURRENT-ROW ,AISLE-COUNT>
		       <GOTO ,LAVATORY>
		       T)>)>)>>

<OBJECT LAV-DOOR
	(DESC "lavatory door")
	(LOC LOCAL-GLOBALS)
	(FLAGS OPENABLE OPENED)
	(SYNONYM DOOR)
	(ADJECTIVE LAVATORY BATHROOM)
	(ACTION LAV-DOOR-F)>

<DEFINE LAV-DOOR-F ()
  <COND (<THIS-PRSI?>
	 <>)
	(<VERB? OPEN>
	 <COND (<IS? ,LAV-DOOR ,LOCKED>
		<COND (<==? ,HERE ,LAV-LOBBY>
		       <TELL CTHEO " is locked. You'll have to wait." CR>
		       T)
		      (<LAVATORY-F ,M-EXIT>
		       ; "This will unlock the door, and check for waking
			  up at the end of the food scene."
		       T)
		      (T
		       <TELL "You unlock " THEO " and open it." CR>
		       T)>)
	       (T
		<>)>)
	(<VERB? LOCK>
	 <COND (<IS? ,LAV-DOOR ,LOCKED>
		<ITS-ALREADY "locked">)
	       (T
		<MAKE ,LAV-DOOR ,LOCKED>
		<ITALICIZE "Click!">
		<ZCRLF>)>)
	(<VERB? UNLOCK>
	 <COND (<IS? ,LAV-DOOR ,LOCKED>
		<UNMAKE ,LAV-DOOR ,LOCKED>
		<ITALICIZE "Click!">
		<ZCRLF>)
	       (T
		<ITS-ALREADY "unlocked">)>)
	(T <>)>>

<MSETG INIT-LIGHT-TIMER 4>
<SETG LIGHT-TIMER 4>

<DEFINE I-BELTLIGHT IB ()
	 <SETG LIGHT-TIMER <- ,LIGHT-TIMER 1>>
	 <COND (<ZERO? ,LIGHT-TIMER>
		<DEQUEUE I-BELTLIGHT>
		<MAKE ,SEATBELT-LIGHT ,NODESC>
		<UNMAKE ,SEATBELT-LIGHT ,LIGHTED>
		<SETG LIGHT-TIMER ,INIT-LIGHT-TIMER>
		<COND (<OR <EQUAL? ,HERE ,SEAT ,AISLE>
			   <EQUAL? ,HERE ,GALLEY ,LAV-LOBBY>
			   <EQUAL? ,HERE ,LAVATORY>>
		       <SETG P-IT-OBJECT ,SEATBELT-LIGHT>
		       <TELL CR 
"The FASTEN SEAT BELT sign overhead goes off." CR>
		       <RETURN T .IB>)>)>
	 <RETURN <> .IB>>

<OBJECT RECEPTACLE
	(LOC SEAT)
	(DESC "headphone receptacle")
	(FLAGS NODESC CONTAINER OPENED OPENABLE)
	(SYNONYM RECEPTACLE OUTLET JACK)
	(ADJECTIVE HEADPHONE EARPHONE PHONE)
	(GENERIC JACK-GENERIC)
	(CAPACITY 0)
	(ACTION RECEPTACLE-F)>

<DEFINE JACK-GENERIC (TBL "AUX" (LEN <ZGET .TBL 0>))
  <COND (<INTBL? ,RECEPTACLE <ZREST .TBL 2> .LEN>
	 ,RECEPTACLE)
	(T <>)>>

<DEFINE RECEPTACLE-F ()
	 <COND (<THIS-PRSI?>
		<COND (<VERB? PUT PLUG REPLUG>
		       <COND (<NOT <PRSO? PHONES>>
			      <TELL "That wouldn't fit into " THEI ,PERIOD>)
			     (T
			      <PLUG-IN-PHONES>)>
		       T)
		      (<VERB? UNPLUG>
		       <COND (<NOT <PRSO? PHONES>>
			      <TELL CTHEO>
			      <ISNT-ARENT>
			      <TELL "plugged in to " THEI ,PERIOD>)
			     (T
			      <UNPLUG-PHONES>)>
		       T)
		      (<PUTTING?>
		       <IMPOSSIBLE>
		       T)
		      (T
		       <>)>)
	       (<VERB? EXAMINE LOOK-INSIDE SEARCH>
		<COND (<T? <PHONES-PLUGGED-IN?>>
		       <TELL CTHE ,PHONES 
" is plugged in to the receptacle." CR>)
		      (T
		       <TELL "The receptacle is labeled HEADPHONES." CR>)>
		T)
	       (<VERB? OPEN CLOSE>
		<TELL CTHEO " has no door." CR>
		T)
	       (T <>)>>

<OBJECT PHONES
	(LOC SEAT-POCKET)
	(DESC "headphones")
	(FLAGS TAKEABLE CLOTHING PLURAL)
	(SYNONYM HEADPHONE PAIR SET EARPHONE EARPHONES PHONES)
	(ADJECTIVE HEAD EAR)
	(SIZE 3)
	(ACTION PHONES-F)>

<DEFINE PHONES-F ("AUX" (PLUGGED-IN? <>))
	 <COND (<T? <PHONES-PLUGGED-IN?>> <SET PLUGGED-IN? T>)>
	 <COND (<THIS-PRSI?>
		<>)
	       (<OR <VERB? DROP>
		    <PUTTING?>>
		<COND (.PLUGGED-IN?
		       <PHONES-PLUGGED-IN? <>>
		       <TELL "[unplugging " THEO " first" ,BRACKET>)>
		<>)
	       (<VERB? EXAMINE LOOK-ON>
		<TELL "It's an ordinary set of airline headphones, ">
		<COND (.PLUGGED-IN?
		       <TELL "plugged into ">)
		      (T
		       <TELL "with a plug that fits ">)>
		<TELL "a receptacle in " Q ,SEAT ,PERIOD>
		T)
	       (<VERB? WEAR>
		<COND (<IS? ,PRSO ,WORN>
		       <>)
		      (<NOT <IN? ,PRSO ,PLAYER>>
		       <>)
		      (T
		       <MAKE ,PRSO ,WORN>
		       <PHONE-TIMER 0>
		       <TELL "You put on " THEO>
		       <COND (.PLUGGED-IN?
			      <TELL ", and hear ">
			      <SAY-MUZAK <PHONE-MUSIC>>)>
		       <TELL ,PERIOD>
		       T)>)
	       (<VERB? LISTEN>
		<COND (<AND .PLUGGED-IN?
			    <IS? ,PHONES ,WORN>>
		       <TELL "You hear ">
		       <SAY-MUZAK <PHONE-MUSIC>>
		       <TELL ,PERIOD>
		       T)
		      (T
		       <TELL ,DONT "hear anything unusual." CR>
		       T)>)
	       (<VERB? UNPLUG>
		<UNPLUG-PHONES>
		T)
	       (<AND <VERB? TAKE>
		     <PRSI? RECEPTACLE>>
		<UNPLUG-PHONES>
		T)
	       (<VERB? PLUG REPLUG>
		<PLUG-IN-PHONES>
		T)
	       (T
		<>)>>

<DEFINE UNPLUG-PHONES ()
	 <COND (<F? <PHONES-PLUGGED-IN?>>
		<TELL "The headphones aren't plugged in." CR>)
	       (T
		<PHONES-PLUGGED-IN? <>>
		<TELL "You unplug the headphones." CR>)>
	 T>

<DEFINE PLUG-IN-PHONES ()
	 <COND (<T? <PHONES-PLUGGED-IN?>>
		<TELL "The headphones are already plugged in." CR>
		T)
	       (<NOT <IN? ,PHONES ,PLAYER>>
		<TELL
"You'd find that a lot easier to do if you were holding the headphones." CR>
		T)
	       (T
		<PHONES-PLUGGED-IN? T>
		<TELL "You plug in the " Q ,PHONES>
		<TELL ,PERIOD>
		<MAKE ,RECEPTACLE ,SEEN>
		T)>>

<DEFINE I-PHONES PHONES ("AUX" X Y)
	 <SET X <PHONE-TIMER>>
	 <COND (<G? <SET X <+ .X 1>> 3>
		<SET X 0>
		<SET Y <PHONE-MUSIC>>
		<COND (<G? <SET Y <+ .Y 1>> ,NUMBER-OF-TUNES>
		       <SET Y 0>)>
		<PHONE-MUSIC .Y>
		<COND (<AND <IN? ,PHONES ,PLAYER>
		     	    <IS? ,PHONES ,WORN>
		     	    <T? <PHONES-PLUGGED-IN?>>>
		       <TELL CR "You hear ">
		       <SAY-MUZAK .Y>
		       <TELL " playing on the headphones." CR>)>)>
	 <PHONE-TIMER .X>	 
	 <RETURN <> .PHONES>>

<DEFINE GO-OUTSIDE-PLANE (FATAL? "AUX" (DREAMING? <>))
	 <COND (<AND <F? .FATAL?>
		     <T? <DREAMING?>>>
		<SET DREAMING? T>)> 
	 <COND (<T? .DREAMING?>
		<TELL CR
		      "Try as you might, you can't get your parachute to open. And naturally there's no spare--these bargain flights are shockingly lacking in the basic necessities.|
|
About when you'd expect your life to pass before your eyes, you awaken in a cold sweat. It was only a dream. And you thought you couldn't sleep on airplanes." CR>
		<END-CURRENT-SCENE>)
	       (T
		<COND (<T? .FATAL?>
		       <TELL CR "As you hit the slipstream, the parachute is
ripped off your back; perhaps the purser was a little sloppy. Due to some quirk
of aerodynamics, it seems to be falling faster than you are. Presumably it's
some comfort to see a parachute, even if you can't use it.." ,PCR>)
		      (T
		       <MOVE ,CHUTE ,PLAYER>)>
		<COND (<NOT .FATAL?>
		       <UPDATE-SCORE 1>
		       <ZCRLF>
		       <QUEUE I-OUTSIDE-PLANE>
		       <GOTO ,OUTSIDE-PLANE>)
		      (T
		       <TO-IN-AIR>)>)>>

<DEFINE I-OUTSIDE-PLANE OUTSIDE ("AUX" SCRIPT)
	 <SET SCRIPT <FALL-SCRIPT>>
	 <FALL-SCRIPT <SET SCRIPT <- .SCRIPT 1>>>
	 <ZCRLF>
	 <COND (<EQUAL? .SCRIPT 4>
		<MAKE ,OUTSIDE-PLANE ,SEEN>
		<TELL
"Of course, it's absurd to suppose that you can fly, and maybe it's just the effect of not much oxygen on not much gray matter, but your fall seems to have been interrupted. This illusion is quickly dispelled as you notice that one of the straps on your " Q ,CHUTE " is caught in the plane's emergency hatch." CR>
		<RETURN T .OUTSIDE>)
	       (<EQUAL? .SCRIPT 3>
		<TELL
"You are currently freezing to death from the -20 degree temperature, suffocating from the rarified 30,000 foot air, and, as if these weren't bad enough, you're trailing about fifteen feet behind the escape hatch of your flight to Zalagasa, which you really didn't want to be on anyway." CR>
		<RETURN T .OUTSIDE>)
	       (<EQUAL? .SCRIPT 2>
		<TELL
"You now have a fine view through the window of the plane's hatch. Inside, the passengers and crew seem to be doing very little of the sort of freezing and suffocating that you are beginning to become accustomed to. ">
		<LOOK-IN-HATCH>
		<RETURN T .OUTSIDE>)
	       (<EQUAL? .SCRIPT 1>
		<TELL
"Do you realize that you are freezing to death even as you suffocate? Just a rhetorical question." CR>
		<RETURN T .OUTSIDE>)>
	 <TELL
"Your body, in its final spasms, seems unable to decide upon whether your cause of death will be the lack of oxygen or the subfreezing temperature. The winner, though, is ">
	 <COND (<PROB 50>
		<TELL "suffocation">)
	       (T
		<TELL "freezing">)>
	 <TELL ".">
	 <JIGS-UP>
	 <RETURN T .OUTSIDE>>

<DEFINE LOOK-IN-HATCH ()
	 <TELL CTHE ,FLIGHT-ATTENDANT 
" who was kind enough to help you with your departure is standing with her back to the window." CR>>

<DEFINE I-FALLING FALLING ("AUX" SCRIPT (FLOAT <>))
	 <SET FLOAT <CHUTE-OPEN?>>
	 <SET SCRIPT <FALL-SCRIPT>>
	 <FALL-SCRIPT <SET SCRIPT <- .SCRIPT 1>>>
	 <ZCRLF>
	 <COND (<EQUAL? .SCRIPT 2>
		<TELL "You're ">
		<COND (<ZERO? .FLOAT>
		       <TELL "plummeting downward at an alarming rate." CR>)
		      (T
		       <TELL "still drifting downward." CR>)>
		<RETURN T .FALLING>)
	       (<EQUAL? .SCRIPT 1>
		<COND (<ZERO? .FLOAT>
		       <TELL 
"The ground is getting very close, very quickly." CR>)
		      (T
		       <TELL "Your downward drift continues." CR>)>
		<RETURN T .FALLING>)
	       (<T? .FLOAT>
		<DEQUEUE I-FALLING>
		<GOTO ,IN-TREE <>>
		<TELL "The ground becomes visible when you're still a few hundred feet up, so you're able to watch as your " Q ,CHUTE
" grabs hold of a passing branch, sending you into a near-perfect backflip. The end result is that you are now hanging upside down, some twenty-odd feet above the ground, suspended by the remains of your " Q ,CHUTE ,PCR>
		<V-LOOK>		
		<TELL CR
"Your philosophical side tells you, \"It could be worse; it could be raining,\" while your rational side tells you that, in fact, it is." CR>       
		<RETURN T .FALLING>)>
	 <HIT-GROUND>
	 <RETURN T .FALLING>>

<OBJECT PURSER
	(DESC "purser")
	(FLAGS PERSON LIVING)
	(SYNONYM PURSER FELLOW MAN)
	(ADJECTIVE LARGE BURLY)
	(ACTION PURSER-F)>

<DEFINE PURSER-F ("OPT" (CONTEXT <>) "AUX" STR)
  <COND (<==? .CONTEXT ,M-OBJDESC>
	 <COND (<F? <PURSER-HERE?>>
		<TELL "There's no purser here." CR>)
	       (T
		<TELL "The purser is standing over you.">)>
	 T)
	(<==? .CONTEXT ,M-WINNER>
	 <TELL CTHE ,PURSER " grunts, but otherwise ignores you." CR>)
	(<T? .CONTEXT> <>)
	(<AND <THIS-PRSI?>
	      <VERB? ASK-ABOUT ASK-FOR>> <>)
	(<F? <PURSER-HERE?>>
	 <TELL "There's no purser on this flight." CR>)
	(<AND <VERB? TELL>
	      <SET STR <CHECK-OZ-ROYALTY ,PURSER T>>>
	 <TELL "Although his lips barely move, you hear " THEO " say \""
	       .STR ".\"" CR>)
	(<THIS-PRSI?>
	 <COND (<VERB? GIVE SHOW>
		<TELL CTHEI " doesn't seem interested in "
		      THEO ,PERIOD>
		T)
	       (T <>)>)
	(<VERB? TELL ASK-ABOUT ASK-FOR YELL QUESTION REPLY
		WAVE-AT BOW REFUSE THANK HELLO GOODBYE>
	 <TELL "The purser grunts in reponse." CR>
	 ,FATAL-VALUE)
	(<VERB? EXAMINE>
	 <TELL "The purser probably learned to count by keeping track of sacked quarterbacks." CR>
	 T)
	(T <>)>>

<OBJECT FLIGHT-ATTENDANT
	(LOC LOCAL-GLOBALS)
	(DESC "flight attendant")
	(FLAGS PERSON LIVING)
	(SYNONYM ZZZP ATTENDANT)
	(ADJECTIVE FLIGHT)
	(ACTION FLIGHT-ATTENDANT-F)>

<VOC "STEWARD" NOUN>
<VOC "STEWARDESS" NOUN>

<DEFINE SET-SEX (OBJ SEX "OPT" (XFEMALE <>) (MALE <>))
	<COND (.SEX
	       <MAKE .OBJ ,FEMALE>
	       <COND (<==? ,P-HIM-OBJECT .OBJ>
		      <SETG P-HIM-OBJECT <>>)>
	       <COND (.XFEMALE <ZPUT <GETPT .OBJ ,P?SYNONYM> 0 .XFEMALE>)>)
	      (T
	       <UNMAKE .OBJ ,FEMALE>
	       <COND (<==? ,P-HER-OBJECT .OBJ>
		      <SETG P-HER-OBJECT <>>)>
	       <COND (.MALE <ZPUT <GETPT .OBJ ,P?SYNONYM> 0 .MALE>)>)>
	<THIS-IS-IT .OBJ>>

<DEFINE FLIGHT-ATTENDANT-APPEARS ("AUX" FEMALE?)
	<MAKE ,FLIGHT-ATTENDANT ,SEEN>
	<DEQUEUE I-GET-ATTENDANT>
	<SET-SEX ,FLIGHT-ATTENDANT <SET FEMALE? <PROB 50>>
		 ,W?STEWARDESS ,W?STEWARD>
	<COND (.FEMALE?
	       <FLIGHT-ATTENDANT-HE/SHE "She">
	       <FLIGHT-ATTENDANT-HIM/HER "her">)
	      (T
	       <FLIGHT-ATTENDANT-HE/SHE "He">
	       <FLIGHT-ATTENDANT-HIM/HER "him">)>>

<DEFINE FLIGHT-ATTENDANT-LEAVES ()
	<LOSER-CANT-LEAVE-SEAT? <>>
	<UNMAKE ,FLIGHT-ATTENDANT ,SEEN>
	<DEQUEUE I-LOSE-ATTENDANT>>

<DEFINE I-GET-ATTENDANT ()
	<FLIGHT-ATTENDANT-APPEARS>
	<TELL CR CTHE ,FLIGHT-ATTENDANT
	      " hurries up to your row. \"May I help you, "
	      <STR-SIR-OR-MAAM> "?\"" CR>
	<QUEUE I-LOSE-ATTENDANT 2>>

<DEFINE I-LOSE-ATTENDANT ()
	<FLIGHT-ATTENDANT-LEAVES>
	<TELL CR CTHE ,FLIGHT-ATTENDANT " apologizes and hurries off. \"Mustn't keep the other passengers waiting.\"" CR>>

<DEFINE TELL-VISA-NUMBER (WHICH "AUX" (TBL <ZGET ,RANDOM-VISA-NUMBERS .WHICH>)
			  (LEN <GETB .TBL 0>))
  <SET TBL <ZREST .TBL 1>>
  <REPEAT ()
    <PRINTC <GETB .TBL 0>>
    <SET TBL <ZREST .TBL 1>>
    <COND (<0? <SET LEN <- .LEN 1>>> <RETURN>)>>>

; "Call if loser picked up a visa number from somebody. See if it's one of
   the ones he might have gotten; set GOT-VISA-NUMBER? to person he got
   it from."
<DEFINE CHECK-VISA-NUMBER CHECK ("AUX" (TBL ,RANDOM-VISA-NUMBERS) (WHICH 1)
				 VN VN1)
  <SET VN <ZREST <ZGET ,IMMIGRATION-FORM <+ ,IMM-VISA 1>>
		 <- ,FIELD-DATA-OFFSET 1>>>
  <REPEAT ()
    <COND (<T? <SET VN1 <ZGET .TBL .WHICH>>>
	   <COND (<NOT <NEQ-TBL .VN1 .VN>>
		  <GOT-VISA-NUMBER? .WHICH>
		  <RETURN T .CHECK>)>)>
    <COND (<G? <SET WHICH <+ .WHICH 1>> ,PERSON-COUNT>
	   <RETURN <> .CHECK>)>>>

<DEFINE FLIGHT-ATTENDANT-F ("OPT" (CONTEXT <>)"AUX" LOSERS-ROW)
	<COND (<IS? ,FLIGHT-ATTENDANT ,SEEN>
	       <COND (<==? .CONTEXT ,M-WINNER>
		      <COND (<VERB? HELLO>
			     <TELL "The " D ,WINNER " nods briskly." CR>)
			    (<VERB? WHAT>
			     <PERFORM ,V?ASK-ABOUT ,WINNER ,PRSO>)
			    (<VERB? GIVE>
			     <PERFORM ,V?ASK-ABOUT ,WINNER ,PRSI>)>)
		     (<T? .CONTEXT> <>)
		     (<THIS-PRSO?>
		      <COND (<VERB? TELL>
			     <>)
			    (<VERB? ASK-ABOUT ASK-FOR SHOW>
			     <COND (<FORM?>
				    <COND (<T? <FORM-SEEN?>>
					   <TELL "\"It's just a simple form you have to fill out before we land in Zalagasa. Nothing to get upset about.\""
						 CR>)
					  (T
					   <TELL "\"I'm sorry, but I don't know anything about any " D ,IFORM ".\"" CR>)>)
				   (<AND <T? <FORM-SEEN?>>
					 <RAND-PRSI? ,VISA-NUMBER-OBJECT>>
				    <TELL "\"I can't really say anything about
that. It would be cheating.\"" CR>)
				   (T
				    <TELL "\"I'm sorry, " <STR-SIR-OR-MAAM>
					  ", but I'm not authorized to say anything about that.\"">)>)>)
		     (<THIS-PRSI?>
		      <COND
		       (<VERB? GIVE SHOW>
			<COND
			 (<==? ,PRSO ,IFORM>
			  <MOVE ,PRSO ,PRSI>
			  <TELL CTHEI " accepts your form and looks it over.">
			  <COND (<T? <FORM-FILLED-OUT?>>
				 <COND (<CHECK-VISA-NUMBER>
				        <SET LOSERS-ROW
					     <GETB ,ROW-ASSIGNMENTS
						   <GOT-VISA-NUMBER?>>>
					<COND
					 (<ROW-OK? ,CURRENT-ROW
						   .LOSERS-ROW>
					  ; "Return T if direction of attendant
					     approach and direction to loser we
					     got this from match."
					  <TELL " \"Thank you very much, "
						<STR-SIR-OR-MAAM>
						". Some people just aren't
very helpful about these things.\"||">
					  
					  <COND
					   (<T? <DREAMING?>>
					    <TELL "A moment later, you hear something going on ">
					    <COND (<G? .LOSERS-ROW
						       ,CURRENT-ROW>
						   <TELL "behind you. You
look around">)
						  (T
						   <TELL "forward. You peek out of your seat">)>
					    <TELL ", and see the ">
					    <DESCRIBE-AIRLINE-PERSON
					     <GOT-VISA-NUMBER?>
					     ,M-SHORTDESC>
					    <TELL " being hustled toward the rear of the plane. There's an
announcement you don't quite catch, and suddenly an oxygen mask pops out
of the panel over your seat. As you reach for it, you bump into something,
and wake up." CR>
					    <FORM-SEEN? <>>
					    <ZREMOVE ,IFORM>
					    <DEQUEUE I-VISA>
					    <END-CURRENT-SCENE>)
					   (T
					    <TELL "A moment later, you notice
the flight attendants frantically consulting with each other, and with the ">
					    <DESCRIBE-AIRLINE-PERSON
					     <GOT-VISA-NUMBER?>
					     ,M-SHORTDESC>
					    <TELL ". An attendant, accompanied by the purser, comes to your seat" ,PCR>
					    ; "Winning case, when not dreaming"
					    <HASTA-LUMBAGO>)>
					  T)
					 (T
					  <TELL " \"I'm frightfully sorry, "
						<STR-SIR-OR-MAAM>
						", but I've already seen this
number ">
					  <COND (<==? .LOSERS-ROW ,CURRENT-ROW>
						 <TELL "in this row.">)
						(T
						 <TELL "in row " N .LOSERS-ROW
						       ".">)>
					  <TELL " We simply
can not tolerate lying on the forms, and it's clear to me that you're not
very trustworthy. Maybe you'd better fill it out again.\"" CR>)>)
				       (<PROB 33>
					<TELL " \"I'm terribly sorry, but this visa number is obviously invalid.\"" CR>)
				       (T
					<TELL " \"" ,THIS-IS "all wrong. You'll have to do it again.\"" CR>)>)>
			  T)
			 (T <>)>)>)>)
	      (<VERB? RING-FOR>
	       <COND (<NOT <EQUAL? ,HERE ,SEAT ,LAVATORY>>
		      <TELL ,CANT "find anything to summon one with."
			    CR>)
		     (<OR <QUEUED? I-GET-ATTENDANT>
			  <==? <CURRENT-SCENE> ,VISA-SCENE>>
		      <TELL
		       "In many cultures, patience is considered a virtue."
		       CR>)
		     (T
		      <QUEUE I-GET-ATTENDANT <ZRANDOM 7>>
		      <TELL "OK, but you know how busy they can get." CR>)>)
	      (T
	       <TELL "There doesn't seem to be a " D ,FLIGHT-ATTENDANT
		     " nearby. Perhaps you should ring for one." CR>
	       <COND (<VERB? TELL>
		      <PCLEAR>
		      ,FATAL-VALUE)
		     (T T)>)>>


"Nightmares"

<DEFINE END-CURRENT-SCENE ("OPT" (NOSCORE? <>) "AUX" CS)
  <LOSER-CANT-LEAVE-SEAT? <>>
  <COND (<T? <SET CS <CURRENT-SCENE>>>
	 <ZAPPLY <ZGET ,SCENE-STARTERS <SET CS <- .CS 1>>>
		 T>)>
  <COND (<F? .NOSCORE?> <UPDATE-SCORE 1>)>
  <PICK-NEXT-SCENE>
  <ZCRLF>
  <V-LOOK>>

<DEFINE PICK-NEXT-SCENE ("AUX" (TB ,ALL-SCENES) SCENE OFFS
			 (LOOPCT 0))
  ; "Find one that hasn't been used."
  <REPEAT ()
    <SET OFFS <ZRANDOM ,SCENE-COUNT>>
    <SET OFFS <- .OFFS 1>>
    <SET SCENE <GETB .TB .OFFS>>
    <COND (<AND <T? <FIRST-SCENE?>>
		<==? .SCENE ,HIJACK-SCENE>>
	   ; "Don't do the computer scene first."
	   T)
	  (<NOT <0? .SCENE>>
	   <RETURN>)>
    <COND (<G? <SET LOOPCT <+ .LOOPCT 1>> 20>
	   <SET OFFS 0>
	   <REPEAT ()
	     <SET SCENE <GETB .TB .OFFS>>
	     <COND (<AND <T? <FIRST-SCENE?>>
			 <==? .SCENE ,HIJACK-SCENE>>
		    T)
		   (<NOT <0? .SCENE>>
		    <RETURN>)>
	     <COND (<G=? <SET OFFS <+ .OFFS 1>> ,SCENE-COUNT>
		    <SET OFFS <- .OFFS 1>>
		    <RETURN>)>>
	   <RETURN>)>>
  <FIRST-SCENE? <>>
  ; "Say it's used."
  <PUTB .TB .OFFS 0>
  ; "Save it"
  <CURRENT-SCENE .SCENE>
  ; "Keep track of how many we've played."
  <SET SCENE <SCENE-NUMBER>>
  <SCENE-NUMBER <SET SCENE <+ .SCENE 1>>>
  ; "Unless it's the last one, it's just a dream."
  <COND (<==? .SCENE ,SCENE-COUNT>
	 <DREAMING? <>>)
	(T
	 <DREAMING? T>)>
  ; "Let 'er rip."
  <QUEUE I-START-SCENE 4>>

<CONSTANT SCENE-STARTERS <PTABLE START-MEAL START-VISA START-HIJACK>>

<DEFINE I-START-SCENE ()
  ; "See if the current scene thinks it's ready to roll."
  <COND (<NOT <ZAPPLY <ZGET ,SCENE-STARTERS <- <CURRENT-SCENE> 1>> <>>>
	 <QUEUE I-START-SCENE 1>)>>

<DEFINE DESCRIBE-HIJACK-VICTIM (ME?)
  <TELL ". \"You! Yeah, you. The ugly one in ">
  <COND (<NOT .ME?>
	 <TELL N <BUSINESS-ROW> CHAR <SEAT-LETTER <BUSINESS-SEAT>>>)
	(<==? ,HERE ,AISLE> <TELL "the aisle">)
	(<N==? ,HERE ,SEAT>
	 <TELL D ,HERE>)
	(T
	 <TELL N ,CURRENT-ROW CHAR <SEAT-LETTER ,CURRENT-SEAT>>)>
  <TELL ". ">>

<DEFINE START-HIJACK START-HIJACK (END? "AUX" (ME? <>) (BLAME-COMPUTER? <>)
				   (DREAMING? <T? <DREAMING?>>))
  ; "If loser didn't bring computer on board, throw off the businessman,
     who did, but only if dreaming. Otherwise, need some other excuse."
  <COND
   (<NOT .END?>
    <COND (<NOT <EQUAL? ,HERE ,SEAT ,AISLE>>
	   ; "Not in plausible location, so make him get there, and try
	      later."
	   <FORCE-RETURN-TO-SEAT 2>
	   <RETURN <> .START-HIJACK>)>
    <COND (<OR <T? <BROUGHT-COMPUTER?>>
	       .DREAMING?>
	   <SET BLAME-COMPUTER? T>)>
    <COND (<OR <T? <BROUGHT-COMPUTER?>>
	       <NOT .DREAMING?>>
	   <SET ME? T>)>
    <MOVIE-ENDS>
    <TELL "You hear a disturbance near the front of the airplane. A bearded
fellow in a curious blue hat with a red B on the front is shouting something: ">
    <COND (.BLAME-COMPUTER?
	   <TELL "\"The chompers! They're gonna crash the plane with their chomping computers!
You can't run a computer on these things without messing up the navigation!\"
Suddenly he points at ">
	   <COND (.ME?
		  <TELL "you">)
		 (T
		  <DESCRIBE-AIRLINE-PERSON ,BUSINESS-PERSON>)>
	   <DESCRIBE-HIJACK-VICTIM .ME?>
	   <TELL "You brought a computer on board, didn't you? You want us to
die, don't you? I went to MIT, I know about
those things. I want you and your chomping computer
off here right now.\"">)
	  (<T? <GOT-RECIPE?>>
	   <TELL "\"Chomping software pirates! I spend my life writing tasteful
programs, and the chompers sell it and don't give me a cent!\" He peers at
a piece of ">
	   <SHOW-FIELD ,LEAST-FAVORITE-COLOR>
	   <TELL " paper, then looks around the plane. He stops at you. ">
	   <DESCRIBE-HIJACK-VICTIM T>
	   <TELL "You got a copy of my recipe program
in ">
	   <SHOW-FIELD ,CITY-NAME>
	   <TELL ", didn't you? I have your picture right here. Well, I'm
putting a stop to this stuff right here and now.\"">)
	  (T
	   <TELL "\"Chomping yuppies and their chomping answering machines!
I call the doctor, I get an answering machine. I call the police, I get an
answering machine. I call my new neighbor, try to say hello, what do I get?
An answering machine.\" He looks at a piece of ">
	   <SHOW-FIELD ,LEAST-FAVORITE-COLOR>
	   <TELL " paper, then straight at you. \"Your phone number is ">
	   <SHOW-FIELD ,PHONE-NUMBER>
	   <TELL " isn't it? I've been trying to call you since you moved to
your new place, just being friendly, and all I ever get is your chomping
answering machine. I can't stand it.\"">)>
    <TELL CR CR "He motions to a burly young man, who is watching in great alarm. \"Don't mess with me. I want that loser off the plane, right now.\"" CR CR>
    <COND (.ME?
	   ; "Winning case"
	   <HASTA-LUMBAGO>)
	  (T
	   <TELL "The purser hustles the ">
	   <DESCRIBE-AIRLINE-PERSON ,BUSINESS-PERSON T>
	   <TELL " to the back of the plane. You feel the air rushing out, and
oxygen masks pop out all around you. Just as you're reaching for one, you
bump into something, and wake up.">
	   <END-CURRENT-SCENE>)>)
   (.DREAMING?
    <WAKE-UP-IN-SEAT>)>>

<DEFINE WAKE-UP-IN-SEAT ()
  <COND (<N==? ,HERE ,SEAT>
	 <GOTO ,SEAT <> T>
	 <DREAMING? <>>
	 <POLICE-AREA ,GALLEY <>>
	 <SETG CURRENT-ROW <LAST-ROW>>
	 <SETG CURRENT-SEAT <LAST-SEAT>>
	 <SETUP-NEW-SEAT T>)>>

; "Visa scene"
<DEFINE I-RETURN-TO-SEAT IRTS ("OPT" (N 0))
	<COND (<F? <ON-PLANE?>>
	       <RETURN <> .IRTS>)>
	<COND (<0? .N> <SET N <RETURN-TO-SEAT-WAIT>>)>
	<COND (<NOT <IS? ,SEATBELT-LIGHT ,LIGHTED>>
	       <MAKE ,SEATBELT-LIGHT ,LIGHTED>
	       <TELL CR "The FASTEN SEAT BELT light overhead blinks on." CR>)>
	<ANNOUNCE-RETURN-TO-SEAT>
	<QUEUE I-DIDNT-RETURN-TO-SEAT .N>
	T>

<DEFINE I-DIDNT-RETURN-TO-SEAT ("OPT" (FOOD-WINNER? <>) "AUX" (SJ? <>))
  <COND (<F? <ON-PLANE?>> <>)
	(<N==? ,HERE ,SEAT>
	 <TELL CR CA ,FLIGHT-ATTENDANT>
	 <COND (<AND <==? ,HERE ,LAVATORY>
		     <NOT <IS? ,LAV-DOOR ,OPENED>>>
		<TELL " knocks on the door, then opens it.">
		<SET SJ? T>)
	       (T
		<TELL " hurries up to you.">)>
	 <TELL " \"" ,THIS-IS "really unforgivable, " <STR-SIR-OR-MAAM>
	       ". People who don't pay attention to our regulations can't be permitted to continue on the flight. Why, you could be hurt!\" "
	       <FLIGHT-ATTENDANT-HE/SHE>
	       " looks thoughtful for an instant, and then reaches a decision"
	       ,PCR>
	 ; "You dead, Jack"
	 <HASTA-LUMBAGO <COND (<T? .FOOD-WINNER?> <>)
			      (T T)>
			.SJ?>
	 T)
	(T
	 <UNMAKE ,SEATBELT-LIGHT ,LIGHTED>
	 <TELL CR "The FASTEN SEAT BELT light overhead blinks off." CR>
	 T)>>

<DEFINE ANNOUNCE-RETURN-TO-SEAT ()
  <TELL CR "\"Ladies and gentlemen, the captain has turned on the FASTEN SEAT BELT sign. For your own safety and comfort, please return to your seats and keep your seat belts fastened until we turn it off. Thank you.\"" CR>>

<DEFINE START-MEAL (END? "AUX" (DREAMING? <DREAMING?>))
  <COND (.END?
	 <DEQUEUE I-MEAL>
	 <COND (.DREAMING? <WAKE-UP-IN-SEAT>)>)
	(<N==? ,HERE ,SEAT>
	 <FORCE-RETURN-TO-SEAT 2>
	 <>)
	(T
	 <MOVIE-ENDS>
	 <TELL
"A message comes over the PA system in Zalagasan and then in English. \"At
this time, we will begin meal service. Today you have your choice of Chicken
Kiev and Peking Duck, prepared at our airline's own kitchens in Djakarta.\""
CR>
	 <QUEUE I-MEAL -1>
	 <MEAL-SCRIPT 1>
	 T)>>

;"meal-state:
  1: meal has been served (always what the loser didn't want)
  2: meal done (loser either mungs it or eats it). If doesn't
     happen within five moves, give warning. If eaten, go to state 4.
  3: if meal still not eaten, throw loser off. Otherwise, to state 4.
  4: bad breath noticed--neighbor looks slightly green, rings for
     stewardess, who produces toothbrush, suggests using it.
  5: after enough moves to get to lavatory, if not there, throw
     off for having bad breath.
  6: in lavatory, immediately run return-to-seat.
  7: If don't wipe
     sink, throw off for that as soon as leaves seat; otherwise,
     too late on return to seat, throw off for that."

<DEFINE FORCE-RETURN-TO-SEAT (START "OPT" (END 5) "AUX" CLOCKER)
  <COND (<SET CLOCKER <QUEUED? I-RETURN-TO-SEAT>>
	 <COND (<L? .START <ZGET .CLOCKER ,C-TICK>>
		<ZPUT .CLOCKER ,C-TICK .START>)>)
	(<SET CLOCKER <QUEUED? I-DIDNT-RETURN-TO-SEAT>>
	 ; "Too late, loser"
	 <COND (<L? .END <ZGET .CLOCKER ,C-TICK>>
		<ZPUT .CLOCKER ,C-TICK .START>)>)
	(T
	 <QUEUE I-RETURN-TO-SEAT .START>)>
  <RETURN-TO-SEAT-WAIT .END>>

<DEFINE I-MEAL ("AUX" X Y (DREAMING? <DREAMING?>))
  <COND (<AND <N==? ,HERE ,SEAT>
	      <L=? <MEAL-SCRIPT> 5>>
	 <FORCE-RETURN-TO-SEAT 2>
	 <>)
	(T
	 <SET Y <MEAL-COUNTER>>
	 <MEAL-COUNTER <SET Y <- .Y 1>>>
	 <SET X <MEAL-SCRIPT>>
	 <COND (<==? .X 1>
		; "Time to serve meal"
		<TELL CR CA ,FLIGHT-ATTENDANT " arrives at your row, and after
some consultation with your neighbor, produces an absolutely delicious-looking
meal. \"And what would you like, " <STR-SIR-OR-MAAM> "? The Chicken
Kiev, or the Peking Duck?\"" CR>
		<PROG (WORD (DUCK? <>))
		  <SET WORD <GET-WORD>>
		  <COND (<EQUAL? .WORD ,W?PEKING ,W?DUCK>
			 <SET DUCK? T>)
			(<EQUAL? .WORD ,W?CHICKEN ,W?KIEV>
			 <SET DUCK? <>>)
			(T
			 <COOPERATE>
			 <TELL "The duck or the chicken?\"" CR>
			 <AGAIN>)>
		  <TELL "\"Oh, I'm terribly sorry, " <STR-SIR-OR-MAAM>
			", we're all out of that. Would you like the ">
		  <COND (.DUCK? <TELL "chicken">)
			(T <TELL "duck">)>
		  <TELL " instead?\"" CR>
		  <COND (<SAID-YES? "\"A simple yes or no will suffice.\"">
			 <TELL "\"Oh, no, we're out of that too. Fortunately,
there's a backup meal for these cases. I'm sure you'll find it equally
delicious--our chef takes a lot of pride in everything she makes.\"" CR CR>
			 <TELL "The noisome stew that appears before you
certainly is neither Peking Duck nor Chicken Kiev. The parts that should
be brown are greenish, and the parts that should be green are brownish.
There's also an overpowering odor of garlic." CR>
			 <MEAL-SCRIPT <SET X <+ .X 1>>>
			 <MEAL-COUNTER 5>
			 ; "5 moves to eat it"
			 <MOVE ,AIRLINE-MEAL ,PLAYER>
			 <THIS-IS-IT ,AIRLINE-MEAL>)
			(T
			 <DEQUEUE I-MEAL>
			 <TELL "\"Dear me, our chef will be ">
			 <ITALICIZE "very">
			 <TELL " upset when she hears about it. In fact,
I don't believe anything like this has ever happened before.\"||
A burly man appears at your row, and after a brief conversation " THE
,FLIGHT-ATTENDANT " nods and turns to you" ,PCR>
			 ; "Naughty, naughty"
			 <HASTA-LUMBAGO T>)>>)
	       (<OR <==? .Y 255>
		    <0? .Y>>
		; "Counter ran out"
		<COND
		 (<==? .X 2>
		  <COND (<F? <LOC ,AIRLINE-MEAL>>
			 ; "Meal eaten"
			 <COND (<==? ,SEAT ,HERE>
				<TELL CR CTHE ,FLIGHT-ATTENDANT " comes by, takes
the remnants of your meal away, and bustles on." CR>
				<ZREMOVE ,PLATE>)>
			 <MEAL-SCRIPT 4>
			 ; "Ready to offend neighbor"
			 <MEAL-COUNTER 2>)
			(<N==? ,HERE ,SEAT>
			 <FORCE-RETURN-TO-SEAT 1>
			 <MEAL-COUNTER 1>
			 <>)
			(T
			 <FLIGHT-ATTENDANT-APPEARS>
			 <TELL CR CTHE ,FLIGHT-ATTENDANT " comes by to clear away
the dishes, and sees that your plate is not clean. \""
			       <STR-SIR-OR-MAAM T>
			       "! We can't have this! Our chef would be
mortally wounded if she discovered that one of her meals was wasted. Why
not make it easy on yourself and eat the food? I'm told it's absolutely
scrumptious.\"" CR <FLIGHT-ATTENDANT-HE/SHE> " stands in the aisle, watching
you." CR>
			 ; "Now have two moves to eat the damn food,
			    otherwise thrown off."
			 <MEAL-COUNTER 2>
			 <MEAL-SCRIPT 3>)>)
		 (<==? .X 3>
		  <FLIGHT-ATTENDANT-LEAVES>
		  <COND (<F? <LOC ,AIRLINE-MEAL>>
			 <TELL CR "\"There, wasn't that yummy? I think you were
just cross because you hadn't eaten.\" " <FLIGHT-ATTENDANT-HE/SHE>
			       " takes your plate and hurries off." CR>
			 <ZREMOVE ,PLATE>
			 <MEAL-SCRIPT 4>
			 <MEAL-COUNTER 2>)
			(T
			 <TELL CR "\"This just won't do, " <STR-SIR-OR-MAAM> ".\""
			       CR CR>
			 <DEQUEUE I-MEAL>
			 ; "Tsk."
			 <HASTA-LUMBAGO T>)>)
		 (<==? .X 4>
		  ; "Anybody in neighborhood notices stench."
		  <COND (<NOT <EQUAL? ,HERE ,SEAT ,AISLE>>
			 <FORCE-RETURN-TO-SEAT 1>
			 <MEAL-COUNTER 2>
			 <>)
			(T
			 <TELL CR "You notice the people around you looking
at you strangely. And that funny taste in your mouth is becoming more
noticeable. It's possible that your meal had side effects in addition to
heartburn and a queasy feeling. In any event, one of your neighbors is ringing
for a flight attendant." CR>
			 <MEAL-COUNTER 1>
			 <MEAL-SCRIPT 5>
			 T)>)
		 (<==? .X 5>
		  <COND (<==? ,HERE ,LAVATORY>
			 <MEAL-COUNTER 1>
			 <FORCE-RETURN-TO-SEAT 1>
			 <>)
			(T
			 <FLIGHT-ATTENDANT-APPEARS>
			 <MOVE ,TOOTHBRUSH ,PLAYER>
			 <TELL CR "A flight attendant hurries up to you. \"I'm sorry to have to tell you this, " <STR-SIR-OR-MAAM>
			       ", but some of our passengers have noticed
that you're suffering from halitosis. In fact, they suggest that they may
be forced to use their discomfort bags if something isn't done about it.\" "
			       <FLIGHT-ATTENDANT-HE/SHE> " is starting to
look a little green. \"I think it would be a very good idea for you
to use this, before we have to take stronger measures.\"" CR CR
			       <FLIGHT-ATTENDANT-HE/SHE>
			       " hurries off, leaving you holding "
			       A ,TOOTHBRUSH ,PERIOD>
			 <MEAL-SCRIPT 6>
			 <COND (<EQUAL? ,HERE ,SEAT ,AISLE>
				<MEAL-COUNTER <- 14 ,CURRENT-ROW>>)
			       (<==? ,HERE ,GALLEY>
				<MEAL-COUNTER 14>)
			       (T
				<MEAL-COUNTER 4>)>)>)
		 (<==? .X 6>
		  <COND (<F? <TEETH-BRUSHED?>>
			 <COND (<==? ,HERE ,LAVATORY>
				<FORCE-RETURN-TO-SEAT 2>
				<MEAL-COUNTER 1>
				<>)
			       (T
				<TELL CR CTHE ,FLIGHT-ATTENDANT
				      " appears. \"I'm sorry, "
				      <STR-SIR-OR-MAAM>
				      ", but we gave you every chance. For the
sake of everyone's health, we're going to have to do something about this.\""
				      CR CR>
				; "Die"
				<HASTA-LUMBAGO T>)>)>)
		 (<==? .X 7>
		  <COND (<AND <N==? ,HERE ,LAVATORY>
			      <F? <SINK-CLEANED?>>>
			 <FLIGHT-ATTENDANT-APPEARS>
			 <TELL CR CTHE ,FLIGHT-ATTENDANT " tracks you down.
\"" ,THIS-IS "most regrettable, " <STR-SIR-OR-MAAM>
			      ". You brushed your teeth in the lavatory,
and left quite a mess in the sink. You're being most discourteous to your
fellow passengers, "
			      <STR-SIR-OR-MAAM>
			      ". We can't tolerate this sort of behavior
on a civilized airline.\" " <FLIGHT-ATTENDANT-HE/SHE> " is now accompanied
by a hefty young man who looks a little too eager for action" ,PCR>
			 ; "Too bad"
			 <HASTA-LUMBAGO T>)
			(<T? <SINK-CLEANED?>>
			 <TELL CR "Unfortunately, in your eagerness to leave a
clean slate (or was that \"clean sink\"?), you've neglected the request to
return to your seat." CR>
			 <DEQUEUE I-MEAL>
			 <COND (<F? .DREAMING?>
				<I-DIDNT-RETURN-TO-SEAT T>)>
			 T)
			(T
			 <MEAL-COUNTER 1>
			 <>)>)>)>)>>

<OBJECT PLATE
	(DESC "plate")
	(SYNONYM PLATE DISH)
	(FLAGS TAKEABLE SURFACE)
	(CAPACITY 5)
	(ACTION PLATE-F)>

<DEFINE PLATE-F ()
  <COND (<HURTING?>
	 <TOO-BAD-SO-SAD>
	 T)>>

<OBJECT TEETH
	(LOC GLOBAL-OBJECTS)
	(DESC "your teeth")
	(FLAGS NODESC TOUCHED NOARTICLE)
	(SYNONYM TEETH TOOTH)
	(ADJECTIVE MY)
	(ACTION TEETH-F)>

<DEFINE TEETH-F ()
  <COND (<THIS-PRSO?>
	 <COND (<VERB? CLEAN-OFF CLEAN>
		<DO-BRUSH-TEETH>)>)>>

<VOC "DIRTY" ADJ>
<VOC "SPOTLESS" ADJ>

<DEFINE DO-BRUSH-TEETH ()
  <COND (<N==? ,HERE ,LAVATORY>
	 <TELL "It would probably be appropriate to perform your ablutions in a more private place." CR>)
	(<OR <==? ,PRSI ,TOOTHBRUSH>
	     <AND <F? ,PRSI>
		  <IN? ,TOOTHBRUSH ,PLAYER>>>
	 <COND (<T? <TEETH-BRUSHED?>>
		<TELL "It hardly seems necessary, but thoroughness is sometimes
considered a virtue." CR>)
	       (T
		<TELL "After much scouring, your mouth starts to taste much less offensive. That's quite a mess you left in " THE ,SINK ", though." CR>)>
	 <TEETH-BRUSHED? T>
	 <ZPUT <GETPT ,SINK ,P?ADJECTIVE> 0 ,W?DIRTY>
	 <DEQUEUE I-RETURN-TO-SEAT>
	 <I-RETURN-TO-SEAT 5>
	 <MEAL-SCRIPT 7>
	 <MEAL-COUNTER 1>)
	(T
	 <TELL "In our advanced culture, it's traditional to use " A
	       ,TOOTHBRUSH " for this particular task." CR>)>>

<OBJECT TOOTHBRUSH
	(DESC "toothbrush")
	(SYNONYM TOOTHBRUSH BRUSH)
	(ADJECTIVE TOOTH)
	(FLAGS TAKEABLE TOOL)
	(ACTION TOOTHBRUSH-F)>

<DEFINE TOOTHBRUSH-F ()
  <COND (<THIS-PRSO?>
	 <COND (<VERB? USE>
		<DO-BRUSH-TEETH>)>)
	(<THIS-PRSI?>
	 <COND (<N==? ,PRSO ,TEETH>
		<TELL "That hardly seems necessary." CR>)
	       (T
		<DO-BRUSH-TEETH>)>)>>

<OBJECT AIRLINE-MEAL
	(DESC "noisome stew")
	(SYNONYM FOOD MEAL STEW DINNER)
	(ADJECTIVE NOISOME BROWN GREEN GARLIC)
	(GENERIC GENERIC-FOOD-F)
	(ACTION AIRLINE-MEAL-F)>

<VOC "PEKING">
<VOC "DUCK">
<VOC "CHICKEN">
<VOC "KIEV">

<DEFINE AIRLINE-MEAL-F ()
  <COND (<THIS-PRSO?>
	 <COND (<OR <HURTING?> <VERB? DROP>>
		<FLIGHT-ATTENDANT-APPEARS>
		<TELL CTHE ,FLIGHT-ATTENDANT>
		<COND (<HERE? LAVATORY> <TELL " bursts through the door.">)
		      (T <TELL " hurries up to you.">)>
		<TELL " \"Now you've done it! Our chef will never recover from this insult if we let you get away with it. I'm sorry, "
		      <STR-SIR-OR-MAAM>
		      ", but we can't permit this to continue.\"" CR CR>
		<HASTA-LUMBAGO T>
		<PCLEAR>
		,FATAL-VALUE)
	       (<VERB? EAT>
		<COND (<N==? ,HERE ,SEAT>
		       <TELL "Don't you think you'd be more comfortable in your seat? Dozens of ergonomic specialists spent many years designing it just to fit ">
		       <ITALICIZE "your">
		       <TELL " body, and here you are eating on the run. "
			     CTHE ,FLIGHT-ATTENDANT " might even consider it a gross breach of manners, and you know what that means." CR>)
		      (T
		       <ZREMOVE ,AIRLINE-MEAL>
		       <MOVE ,PLATE ,PLAYER>
		       <TELL "Well, that was positively delicious, and undoubtedly highly nutritious as well. The penicillin will certainly help keep you healthy, and there were traces of several more-or-less essential vitamins as well. All in all, most satisfactory. It did leave a slightly odd taste in your mouth, but nothing to worry about." CR>)>)
	       (<VERB? EXAMINE>
		<TELL ,THIS-IS "an offensively aromatic concoction of various mystery meats, pseudo-vegetable matter, and an indescribable sauce. Not quite Peking duck, nor yet chicken Kiev, but it probably will provide some calories."
		      CR>)>)
	(<THIS-PRSI?>
	 <COND (<VERB? TRADE-FOR>
		<TELL "Everyone around you seems to have finished eating already. And it looked wonderful, too." CR>)>)>>

<DEFINE START-VISA START-VISA (END?)
  <COND (.END?
	 <RETURN T .START-VISA>)>
  <COND (<N==? ,HERE ,SEAT>
	 <FORCE-RETURN-TO-SEAT 2>
	 <>)
	(T
	 <MOVIE-ENDS>
	 <TELL
"A message comes over the PA system in Zalagasan and then in English. \"This is your Captain speaking. At this time, the flight attendants will be passing out " Q ,IFORM 
"s which must be completed by all passengers before we land in Zalagasa. Thank you for your cooperation.\"" CR>
	 <VISA-SCRIPT 13>
	 <QUEUE I-VISA -1>
	 T)>>

<DEFINE ROW-OK? (MY-ROW LOSERS-ROW)
  <COND (<L=? .MY-ROW </ ,AISLE-COUNT 2>>
	 ; "Am I in the front of the airplane?"
	 <COND (<G=? .MY-ROW .LOSERS-ROW>
		; "Then the f.a. is headed back."
		<>)
	       (T T)>)
	(<L=? .MY-ROW .LOSERS-ROW> <>)
	(T T)>>

<DEFINE I-VISA I-VISA ("AUX" STR X)
  <COND (<N==? ,HERE ,SEAT>
	 ; "Get the loser back into a seat."
	 <COND (<G? <VISA-SLEEPING?> 2>
		<FORCE-RETURN-TO-SEAT <VISA-SLEEPING?>>)
	       (T
		<FORCE-RETURN-TO-SEAT 2>)>
	 <VISA-SLEEPING? 0>
	 <RETURN <> .I-VISA>)>
  <SET X <VISA-SCRIPT>>
  <VISA-SCRIPT <SET X <- .X 1>>>
  <COND (<G? .X 10>
	 <RETURN <> .I-VISA>)
	(<==? .X 10>
	 <FORM-SEEN? T>
	 <FLIGHT-ATTENDANT-APPEARS>
	 <MOVE ,IFORM ,PLAYER>
	 <SETG P-IT-OBJECT ,IFORM>
	 <TELL CR ,YOU-SEE A ,FLIGHT-ATTENDANT " approaching from the ">
	 <COND (<G? ,CURRENT-ROW </ ,AISLE-COUNT 2>>
		<TELL "rear">)
	       (T
		<TELL "front">)>
	 <TELL " of the airplane. " <FLIGHT-ATTENDANT-HE/SHE>
	       " hands you "
	       A ,IFORM ", and walks away." CR>
	 <FLIGHT-ATTENDANT-LEAVES>
	 T)
	(<==? .X 9>
	 <TELL CR "The passengers around you begin to fill out their "
	       Q ,IFORM "s." CR>
	 <COND (<F? <GOT-VISA-NUMBER?>>
		; "Give people some leeway at this point"
		<VISA-SLEEPING? 5>)>
	 T)
	(<==? .X 8>
	 <COND (<G? <SET X <VISA-SLEEPING?>> 0>
		<VISA-SLEEPING? <SET X <- .X 1>>>
		<VISA-SCRIPT 9>
		<RETURN <> .I-VISA>)>
	 <COND (<F? <GOT-VISA-NUMBER?>>
		<VISA-SLEEPING? 4>)
	       (T
		<VISA-SLEEPING? 2>)>
	 <TELL CR "The PA system comes to life again. \"Attention, please. Our flight attendants will be collecting " THE ,IFORM "s in a few moments. Please be sure your form is completely filled out. Thank you.\" You notice that this time the message was not delivered in Zalagasan." CR>
	 T)
	(<==? .X 7>
	 <COND (<G? <SET X <VISA-SLEEPING?>> 0>
		<VISA-SLEEPING? <SET X <- .X 1>>>
		<VISA-SCRIPT 8>
		<RETURN <> .I-VISA>)>
	 <TELL CR "The passengers around you are completing their " Q ,IFORM "s." CR>
	 T)
	(<==? .X 6>
	 <FLIGHT-ATTENDANT-APPEARS>
	 <LOSER-CANT-LEAVE-SEAT? T>
	 <TELL CR CTHE ,FLIGHT-ATTENDANT " returns and asks you for your " Q ,IFORM ,PERIOD>
	 T)
	(T
	 <COND (<IN? ,IFORM ,FLIGHT-ATTENDANT>
		<TELL CR <FLIGHT-ATTENDANT-HE/SHE>
		      " hands your form back to you, while endeavoring to look mortally offended.">
		<MOVE ,IFORM ,PLAYER>)>
	 <COND
	  (<==? .X 2>
	   <TELL CR "\"I'm afraid there are no exceptions, "
		 <STR-SIR-OR-MAAM>
		 ",\" says " THE ,FLIGHT-ATTENDANT
		 ", motioning to someone you can't see." CR>
	   T)
	  (<==? .X 1>
	   <PURSER-HERE? T>
	   <TELL CR "\"I shall have to insist that you finish filling out "
		 THE ,IFORM " ">
	   <ITALICIZE "now">
	   <TELL ",\" notes " THE ,FLIGHT-ATTENDANT ,PCR
		 "A rather burly gentleman, introduced as " THE ,PURSER
		 ", appears at your side." CR>
	   <MAKE ,PURSER ,SEEN>
	   T)
	  (<G? .X 0>
	   <ZCRLF>
	   <COND (<F? <FORM-FILLED-OUT?>>
		  <TELL "\"I'm shocked, " <STR-SIR-OR-MAAM>
			"! You haven't even started to fill out "
			THE ,IFORM ". ">
		  <ATTENDANT-COMPLAINTS 1>)
		 (<==? <ATTENDANT-COMPLAINTS> 2>
		  <TELL "\"">)
		 (T
		  <TELL
		   "\"Come, come. It's not as if we're asking anything you
don't know. ">
		  <ATTENDANT-COMPLAINTS 2>)>
	   <COND (<G=? .X 5>
		  <TELL "If you don't cooperate, you'll just make trouble for everyone on board.\"" CR>)
		 (<G=? .X 4>
		  <TELL "Unless you finish " THE ,IFORM " properly, I'm afraid that we will be unable to land.\"" CR>
		  T)
		 (<==? .X 3>
		  <TELL "The Zalagasan authorities absolutely will not permit this aircraft to land unless everyone on board has filled out "
			A ,IFORM ", " <STR-SIR-OR-MAAM> ".\"" CR>
		  T)
		 (<==? .X 2>
		  <PRINTC %<ASCII !\">>
		  T)
		 (T T)>)
	  (T
	   <DEQUEUE I-VISA>
	   <ZCRLF>
	   <HASTA-LUMBAGO T>
	   T)>)>>

<OBJECT IFORM
	(DESC "immigration form")
	(FLAGS TAKEABLE READABLE VOWEL)
	(SIZE 2)
	(SYNONYM FORM)
	(GENERIC SLIP-F)	; "To keep moby-find happy in bank"
	(ADJECTIVE IMMIGRATION VISA MY)
	(ACTION IFORM-F)>

<DEFINE IF-STARS (CONTEXT TBL "OPT" CHAR)
	<COND (<==? .CONTEXT ,FORM-ADD-CHAR>
	       <COND (<CHECK-NUMBER .CHAR> T)
		     (T <FERROR "Not a number"> <>)>)
	      (<==? .CONTEXT ,FORM-EXIT-FIELD>
	       <COND (<PROB 25>
		      <FERROR "There must be more than that">
		      ,FATAL-VALUE)
		     (<PROB 25>
		      <FERROR "Surely you jest">
		      ,FATAL-VALUE)
		     (T T)>)
	      (T T)>>

<DEFINE IF-REASON (CONTEXT TBL "OPT" CHAR)
  <COND (<==? .CONTEXT ,FORM-ADD-CHAR> T)
	(<==? .CONTEXT ,FORM-EXIT-FIELD>
	 <COND (<PROB 15>
		<FERROR "Much too silly">
		,FATAL-VALUE)
	       (<PROB 15>
		<FERROR "Not good enough">
		,FATAL-VALUE)
	       (<PROB 15>
		<FERROR "Too good to be true">
		,FATAL-VALUE)
	       (T T)>)
	(T T)>>

<DEFINE IF-VISA (CONTEXT TBL "OPT" CHAR)
  <COND (<==? .CONTEXT ,FORM-ADD-CHAR>
	 <COND (<CHECK-NUMBER .CHAR> T)
	       (T <FERROR "Not a number"> <>)>)
	(<==? .CONTEXT ,FORM-EXIT-FIELD>
	 <COND (<L? <FIELD-CURLEN .TBL> 4>
		<FERROR "Too short">
		<>)
	       (T T)>)
	(T T)>>

<DEFINE IF-DATE (CONTEXT TBL "OPT" CHAR)
  <COND (<==? .CONTEXT ,FORM-ADD-CHAR>
	 <COND (<OR <CHECK-NUMBER .CHAR>
		    <EQUAL? .CHAR %<ASCII !\/> %<ASCII !\.>
			    %<ASCII !\->>> T)
	       (T
		<FERROR "Bad character">
		<>)>)
	(<==? .CONTEXT ,FORM-EXIT-FIELD>
	 <COND (<PROB 30>
		<COND (<==? .TBL <ZGET ,IMMIGRATION-FORM
				       <+ ,IMM-RING 1>>>
		       <FERROR "Too big">)
		      (T
		       <FERROR "Too long ago">)>
		,FATAL-VALUE)
	       (T T)>)
	(T T)>>

<DEFINE IF-MIDDLE-INITIAL (CONTEXT TBL "OPT" CHAR)
  <COND (<==? .CONTEXT ,FORM-ADD-CHAR>
	 <FF-MIDDLE-INITIAL .CONTEXT .TBL .CHAR>)
	(<==? .CONTEXT ,FORM-EXIT-FIELD>
	 <COMPARE-FIELDS .TBL <ZGET ,LICENSE-FORM <+ ,MIDDLE-INITIAL 1>>>)
	(T T)>>

<DEFINE IF-FIRST-NAME (CONTEXT TBL "OPT" CHAR)
  <COND (<==? .CONTEXT ,FORM-ADD-CHAR>
	 <FF-NAME .CONTEXT .TBL .CHAR>)
	(<==? .CONTEXT ,FORM-EXIT-FIELD>
	 <COMPARE-FIELDS .TBL <ZGET ,LICENSE-FORM <+ ,FIRST-NAME 1>>>)
	(T T)>>

<DEFINE IF-LAST-NAME (CONTEXT TBL "OPT" CHAR)
  <COND (<==? .CONTEXT ,FORM-ADD-CHAR>
	 <FF-NAME .CONTEXT .TBL .CHAR>)
	(<==? .CONTEXT ,FORM-EXIT-FIELD>
	 <COMPARE-FIELDS .TBL <ZGET ,LICENSE-FORM <+ ,LAST-NAME 1>>>)
	(T T)>>

<DEFINE COMPARE-FIELDS CF (TBL1 TBL2 "AUX" (LEN <FIELD-CURLEN .TBL1>))
  <COND (<NEQ-TBL <ZREST .TBL1 <- ,FIELD-DATA-OFFSET 1>>
		  <ZREST .TBL2 <- ,FIELD-DATA-OFFSET 1>>>
	 <FERROR "We know better than that">
	 <>)
	(T T)>>

<DEFINE IFORM-F ()
	<COND (<THIS-PRSO?>
	       <COND (<VERB? FILL-IN>
		      <COND (<T? <FORM-FILLED-OUT?>>
			     <TELL "You already did it once, but if you found the experience ">
			     <ITALICIZE "that">
			     <TELL " enlightening, do go ahead. Strike any key when you're ready." CR>
			     <ZBUFOUT <>>
			     <INPUT 1>)>
		      <FILL-FORM ,IMMIGRATION-FORM
				 "       ZALAGASAN IMMIGRATION FORM       ">
		      <TELL "There, that wasn't so bad, was it?" CR>
		      <FORM-FILLED-OUT? T>
		      T)
		     (<VERB? EXAMINE READ>
		      <COND (<T? <FORM-FILLED-OUT?>>
			     <TELL "Your " D ,IFORM " has been filled out, and looks something like:" CR>
			     <SHOW-FIELDS ,IMMIGRATION-FORM>)
			    (T
			     <TELL CTHEO
				   " seems rather long, but it's probably not too hard to fill out."
			    CR>)>
		      T)
		     (<HURTING?>
		      <TOO-BAD-SO-SAD>
		      T)>)>>

<DEFINE TOO-BAD-SO-SAD ()
  <COND (<IS? ,FLIGHT-ATTENDANT ,SEEN>
	 <TELL "That probably wasn't such a great idea.">)
	(T
	 <FLIGHT-ATTENDANT-APPEARS>
	 <TELL "Apparently you made more noise than you thought. You hear someone running toward you.">)>
  <TELL CR CR>
  <HASTA-LUMBAGO T>>

<DEFINE HASTA-LUMBAGO ("OPT" (FATAL? <>) (STARTED-IN-JOHN? <>)
		       "AUX" STR
		       (DREAMING? <DREAMING?>)
		       (SHORT? <THROWN-OFF-ONCE?>))
	<SETG DO-WINDOW <>>
	<DEQUEUE I-VISA>
	<DEQUEUE I-MEAL>
	<DEQUEUE I-DIDNT-RETURN-TO-SEAT>
	<DEQUEUE I-PHONES>
	<MOVE ,PHONES ,SEAT-POCKET>
	<UNMAKE ,PHONES ,WORN>
	<FORM-SEEN? <>>
	<ZREMOVE ,IFORM>
	<FORM-SEEN? <>>
	<PURSER-HERE? <>>
	<ZREMOVE ,AIRLINE-MEAL>
	<ZREMOVE ,PLATE>
	<THROWN-OFF-ONCE? T>
	<TELL CTHE ,FLIGHT-ATTENDANT>
	<COND (<IS? ,SEATBELT ,WORN>
	       <TELL " helpfully unfastens your seat belt, and">)>
	<TELL " carefully checks to make sure you aren't absconding with any valuable airline property" ,PCR>
	<ZREMOVE ,TOOTHBRUSH>
	<ZREMOVE ,PLATE>
	<ZREMOVE ,AIRLINE-MEAL>
	<COND (<NOT .DREAMING?>
	       <DEQUEUE I-CONVERSE>
	       <UNMAKE ,SEATBELT ,WORN>
	       <MOVE ,SEATBELT ,SEAT>
	       <MOVE ,AIRLINE-MAGAZINE ,SEAT-POCKET>
	       <MOVE ,SAFETY-CARD ,SEAT-POCKET>
	       <ZREMOVE ,PLAYER>)>
	 <SET STR <FLIGHT-ATTENDANT-HE/SHE>>
	 <LOSER-CANT-LEAVE-SEAT? <>>
	 <TELL "\"I'm terribly sorry, " <STR-SIR-OR-MAAM>
	       ", but I'm afraid you'll have to leave us now.\" ">
	 <COND (<G? <+ <POLICE-AREA ,SEAT ,NORMAL-SEAT ,PLAYER .DREAMING?>
		       <POLICE-AREA ,SEAT-POCKET ,NORMAL-SEAT-POCKET
				    ,PLAYER .DREAMING?>
		       <POLICE-AREA ,UNDER-SEAT <> ,PLAYER .DREAMING?>> 0>
		<TELL .STR>
		<COND (<F? .STARTED-IN-JOHN?>
		       <TELL " checks around your seating area, and">)>
		<TELL " hands you your personal belongings. \"We wouldn't want to leave these behind, would we?\""
		      CR>)>
	 <COND (<T? .SHORT?>
		<TELL CR "You experience a strange feeling of deja vu." CR>)
	       (T
		<TELL .STR " motions to " THE ,PURSER ", who politely escorts (actually, it's much more like being carried) you to the back of the plane and straps a " Q ,CHUTE " onto your back.|
|
As " THE ,FLIGHT-ATTENDANT " lifts the handle on the emergency escape hatch, you finally get to see some emergency oxygen masks in use, as they come popping out of the ceiling. You hear an announcement: \"Ladies and gentlemen, your attention please. One of our passengers will be deplaning at this time. For your own safety and convenience, we suggest that you wear your oxygen masks until the rear hatch is closed and the cabin is repressurized. Thank you.\"|
|
A rush of cold air fills the cabin. As " THE ,PURSER " politely but firmly ejects you from the plane, " THE ,FLIGHT-ATTENDANT
" calls, \"It's been our pleasure serving you today, "
	      <STR-SIR-OR-MAAM>
	 ". If your future travel plans call for air travel to Zalagasa, we hope you'll think of us. Have a nice day!\"" CR>)>
	 <COND (<IN? ,NERD ,HERE>
		<ZREMOVE ,NERD>
		<UNMAKE ,NERD ,TOUCHED>
		<ZCRLF>
		<NERD-SAYS-WAIT>)>
	 <GO-OUTSIDE-PLANE .FATAL?>>

<OBJECT CHUTE
	(DESC "parachute")
	(FLAGS TAKEABLE WORN CLOTHING CONTAINER TRANSPARENT)
	(SYNONYM CHUTE PARACHUTE STRAP STRAPS LINE LINES SHROUD)
	(ADJECTIVE CHUTE PARACHUTE)
	(SIZE 10)
	(ACTION CHUTE-F)>

<DEFINE CHUTE-F CHUTE ()
	 <COND (<F? <LOC ,CHUTE>>
		<COND (<IS? ,HERE ,IN-AIRPLANE>
		       <TELL ,CANT "see any " D ,CHUTE ,PERIOD>
		       <RETURN T .CHUTE>)
		      (<TOUCHING?>
		       <TELL ,CANT "reach " THE ,CHUTE ,PERIOD>
		       <RETURN T .CHUTE>)>)
	       (<OR <NOUN-USED? ,W?STRAP ,W?STRAPS ,W?LINE>
		    <NOUN-USED? ,W?LINES ,W?SHROUD>>
		<COND (<THIS-PRSI?>
		       T)
		      (<VERB? EXAMINE LOOK-ON>
		       <TELL CTHEO "'s straps are ">
		       <COND (<HERE? OUTSIDE-PLANE>
			      <TELL "caught in the plane's hatch.">
			      <RETURN T .CHUTE>)
			     (<HERE? IN-AIR>
			      <TELL " fluttering in the breeze." CR>
			      <RETURN T .CHUTE>)>
		       <TELL "hopelessly tangled in the tree." CR>
		       <RETURN T .CHUTE>)
		      (<VERB? PULL MOVE PUSH LOOSEN ADJUST LOWER RAISE>
		       <COND (<HERE? IN-AIR>
			      <TELL "This has no useful effect." CR>
			      <RETURN T .CHUTE>)>
		       <TELL "You struggle to ">
		       <ZPRINTB ,P-PRSA-WORD>
		       <TELL " the straps, but to no avail." CR>
		       <RETURN T .CHUTE>)
		      (<AND <VERB? CUT>
			    <T? ,PRSI>>
		       <COND (<NOT <IS? ,PRSI ,SHARPENED>>
			      <TELL
"An ingenious idea. But you'll never sever those heavy-duty " Q ,PRSO 
" straps with " A ,PRSI ,PERIOD>
			      <RETURN T .CHUTE>)>
		       <TELL "You cleverly snip " THEO
			     "'s straps with " THEI>
		       <LOOSEN-CHUTE>
		       <RETURN T .CHUTE>)>)>
	 <COND (<THIS-PRSI?>
		<COND (<VERB? PUT-ON EMPTY-INTO>
		       <IMPOSSIBLE>
		       <RETURN T .CHUTE>)>
		<RETURN <> .CHUTE>)
	       (<VERB? EXAMINE>
		<COND (<F? <LOC ,CHUTE>>
		       <TELL CTHEO " is falling, somewhat faster than you. Perhaps you'll catch up with it in another life." CR>
		       <RETURN T .CHUTE>)
		      (<HERE? OUTSIDE-PLANE>
		       <TELL CTHEO
" is strapped to your back, which is good, and caught in the emergency exit of the plane, which is bad." CR>
		       <RETURN T .CHUTE>)
		      (<CHUTE-OPEN?>
		       <TELL
"Although you can tell it's above you somewhere, the darkness of the night prevents you from seeing very much of it." CR>
		       <RETURN T .CHUTE>)>
		<TELL
"It's on your back, you know, so you can't tell much">
		<COND (<IN? ,RIPCORD ,PRSO>
		       <TELL
". A red handle attached to a cord is fluttering nearby, though">)>
		<ZPRINT ,PERIOD>
		T)
	       (<VERB? LOOK-ON READ>
		<TELL "The words HAVE A NICE DAY are silkscreened on " THEO
		      ,PERIOD>
		T)
	       (<F? <LOC ,CHUTE>>
		<TELL ,CANT "reach " THEO ,PERIOD>)
	       (<VERB? TAKE-OFF DROP EXIT>
		<TELL "You cleverly slip " THEO " off your back">
		<LOOSEN-CHUTE>
		T)
	       (<VERB? OPEN UNFOLD>
		<OPEN-CHUTE>
		T)
	       (<VERB? CLOSE FOLD>
		<COND (<IS? ,PRSO ,OPENED>
		       <TELL "Easier said than done." CR>)
		      (T
		       <ALREADY-CLOSED>)>
		T)
	       (T <>)>>

<DEFINE LOOSEN-CHUTE ()
	 <TELL ", and immediately plummet ">
	 <ZREMOVE ,CHUTE>
	 <COND (<HERE? OUTSIDE-PLANE>
		<TELL "away from the plane." CR>
		<TO-IN-AIR>)
	       (T
		<TELL "towards the ground below." CR>
		<COND (<HERE? IN-AIR>
		       <HIT-GROUND>)
		      (T
		       <GOTO ,IN-POT <>>
		       <ZCRLF>
		       <ITALICIZE "Splash">
		       <TELL "!" CR CR>
		       <V-LOOK>
		       <THIS-IS-IT ,NATIVES>
		       <COND (<OR <NOT <META-IN? ,RECIPE ,HERE>>
				  <NOT <META-IN? ,COMPUTER ,HERE>>>
			      <NATIVES-EAT-YOU>)
			     (T
			      <UPDATE-SCORE 1>)>)>)>
	 T>

<DEFINE OPEN-CHUTE CHUTE ()
	 <COND (<CHUTE-OPEN?>
		<TELL
"You yank on " THE ,RIPCORD " again, but as " THE ,CHUTE
" is already deployed, nothing happens." CR>
		<RETURN T .CHUTE>)
	       (<HERE? OUTSIDE-PLANE>
		<TELL
"Things were bad enough with your " Q ,CHUTE " straps caught in the hatch. Pulling " THE ,RIPCORD ", as you might well have expected, has added the complication of a deployed " Q ,CHUTE " as well. The various straps, cords and other " Q ,CHUTE " paraphenalia, each going its own merry way, sends you flying in a number of very unpleasant pieces.">
		<JIGS-UP>
		<RETURN T .CHUTE>)>
	 <UNMAKE ,CHUTE ,TRANSPARENT>
	 <MAKE ,CHUTE ,OPENED>
	 <TELL
"Your luck seems to be changing. Instead of simply falling off in your hand, " THE ,RIPCORD " seems to have been actually attached to " THE ,CHUTE
", and pulling it has caused the chute to deploy. This results in a greatly slowed rate of descent." CR>
	 T>

<OBJECT RIPCORD
	(LOC CHUTE)
	(DESC "ripcord")
	(FLAGS TRYTAKE NOALL NODESC)
	(SYNONYM HANDLE CORD RIPCORD)
	(ADJECTIVE RED RIP)
	(ACTION RIPCORD-F)>

<DEFINE RIPCORD-F ()
	 <COND (<NOT <IN? ,CHUTE ,PLAYER>>
		<TELL "You'd better grow longer arms if you're going to reach "
		      THE ,RIPCORD " from here." CR>
		T)
	       (<THIS-PRSI?>
		<>)
	       (<VERB? EXAMINE LOOK-ON>
		<TELL CTHEO>
		<COND (<IS? ,CHUTE ,OPENED>
		       <TELL " you've pulled">)>
		<TELL " is dangling from " THE ,CHUTE ,PERIOD>
		T)
	       (<VERB? TAKE PULL USE PLAY>
		<OPEN-CHUTE>
		T)
	       (T
		<>)>>

<DEFINE TO-IN-AIR ()
	 <DEQUEUE I-OUTSIDE-PLANE>
	 <FALL-SCRIPT 3>
	 <QUEUE I-FALLING>
	 <GOTO ,IN-AIR T T>
	 T>

<DEFINE HIT-GROUND ()
	 <TELL
"Your fall comes to a rather abrupt end as your body hits the ground with a sickening thud.">
	 <JIGS-UP>
	 T>

<OBJECT OUTSIDE-PLANE
	(LOC ROOMS)
	(SDESC DESCRIBE-OUTSIDE-PLANE)
	(FLAGS SPECIAL-DROP NO-NERD LIGHTED LOCATION)
	(NORTH SORRY "Such directions are useless here.")
	(EAST SORRY "Such directions are useless here.")
	(SOUTH SORRY "Such directions are useless here.")
	(WEST SORRY "Such directions are useless here.")
	(DOWN SORRY "Inevitable.")
	(UP SORRY "Wishful thinking.")
	(OUT SORRY "You're already outside.")
	(IN SORRY "Wishful thinking.")
	(THINGS SEAT-PSEUDO-VEC)
	(ACTION OUTSIDE-PLANE-F)
	(GLOBAL FLIGHT-ATTENDANT)>

<DEFINE DESCRIBE-OUTSIDE-PLANE ()
	 <COND (<IS? ,OUTSIDE-PLANE ,SEEN>
		<TELL "Outside Plane">)
	       (T
		<TELL "Falling">)>
	 T>

<DEFINE OUTSIDE-PLANE-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL "You're outside the plane">
		<COND (<IS? ,OUTSIDE-PLANE ,SEEN>
		       <TELL 
", dangling from the strap of your " Q ,CHUTE
". The plane's hatch is a few feet away">)>
		<ZPRINT ,PERIOD>
		T)
	       (T
		<>)>>

<OBJECT IN-AIR
	(LOC ROOMS)
	(DESC "Falling")
	(LDESC "In midair, heading down.")
	(THINGS SEAT-PSEUDO-VEC)
	(GLOBAL CHUTE)
	(FLAGS SPECIAL-DROP LIGHTED LOCATION NO-NERD)
	(NORTH SORRY "Such directions are useless here.")
	(EAST SORRY "Such directions are useless here.")
	(SOUTH SORRY "Such directions are useless here.")
	(WEST SORRY "Such directions are useless here.")
	(DOWN SORRY "Inevitable.")
	(UP SORRY "Wishful thinking.")
	(OUT SORRY "You're already outside.")
	(IN SORRY "Wishful thinking.")
	(ACTION IN-AIR-F)>

<DEFINE IN-AIR-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL "You're ">
		<COND (<CHUTE-OPEN?>
		       <TELL "drif">)
		      (T
		       <TELL "plumme">)>
		<TELL "ting downward." CR>
		T)
	       (T
		<>)>>

<DEFINE CHUTE-OPEN? ()
	 <COND (<AND <IN? ,CHUTE ,PLAYER>
		     <IS? ,CHUTE ,WORN>
		     <IS? ,CHUTE ,OPENED>>
		T)
	       (T
		<>)>>


"Code for other passengers"
<OBJECT RANDOM-PERSON
	(ACTION RANDOM-PERSON-F)
	(DESCFCN RANDOM-PERSON-F)
	(SDESC RANDOM-PERSON-SDESC)
	(PSEUDO-TABLE 0)
	(FLAGS PERSON LIVING)>

"Initialize state of seating: all rows are full, except for smoker/non-smoker
 rows, which we handle on boarding. Other four people are put randomly around
 plane, no more than one per row."

<CONSTANT ROW-ASSIGNMENTS <TABLE (BYTE) 0 0 0 0 0 0>>

<CONSTANT RANDOM-VISA-NUMBERS <PLTABLE
			       ; "Smoker"
			       <TABLE (LENGTH BYTE PURE)
				      %<ASCII !\4> %<ASCII !\2>
				      %<ASCII !\4> %<ASCII !\2>>
			       ; "grandma"
			       <TABLE (LENGTH BYTE PURE)
				      %<ASCII !\9> %<ASCII !\0> %<ASCII !\7>
				      %<ASCII !\4> %<ASCII !\2>>
			       ; "Business person"
			       <TABLE (LENGTH BYTE PURE)
				      %<ASCII !\6> %<ASCII !\1>
				      %<ASCII !\7> %<ASCII !\4> %<ASCII !\2>>
			       ; "Momma"
			       <TABLE (LENGTH BYTE PURE)
				      %<ASCII !\0> %<ASCII !\7>
				      %<ASCII !\4> %<ASCII !\2>>>>

<DEFINE INITIALIZE-SEATS ("AUX" (RA ,ROW-ASSIGNMENTS))
  <SETG CURRENT-ROW ,INITIAL-ROW>
  <SETG CURRENT-SEAT ,SEAT-A>
  <CURRENT-NEIGHBOR <>>
  <ZPUT ,AISLE-STATE ,CURRENT-ROW <ORB ,SEAT-C ,SEAT-D>>
  <REPEAT ((WHICH 1) CROW SEAT (LOOPCT 50) (OLD-AISLE 1))
    ; "Be careful in case RANDOM breaks down..."
    <COND (<L? <SET LOOPCT <- .LOOPCT 1>> 1>
	   <SET OLD-AISLE <+ .OLD-AISLE 1>>
	   <SET CROW .OLD-AISLE>)
	  (T
	   <SET CROW <ZRANDOM ,AISLE-COUNT>>)>
    <COND (<==? <ZGET ,AISLE-STATE .CROW>
		,ALL-SEATS>
	   <SET SEAT <ZRANDOM 4>>
	   ; "Seat to leave blank"
	   <COND (<L=? .SEAT 2>
		  <PORT-PERSON .WHICH .CROW>)
		 (T
		  <STARBOARD-PERSON .WHICH .CROW>)>
	   <SET SEAT <GETB ,SEAT-MASKS .SEAT>>
	   <COND (<==? .WHICH ,BUSINESS-PERSON>
		  <BUSINESS-SEAT .SEAT>
		  <BUSINESS-ROW .CROW>)>
	   <PUTB .RA .WHICH .CROW>
	   <ZPUT ,AISLE-STATE .CROW
		 <ANDB <ZGET ,AISLE-STATE .CROW>
		       <XORB .SEAT -1>>>
	   ; "Set up personality in seat next to blank seat"
	   <SET WHICH <+ .WHICH 1>>)>
    <COND (<G? .WHICH ,PERSON-COUNT> <RETURN>)>>>

<DEFINE DESCRIBE-MOVIE ()
  <SAY-MOVIE "This is a masterpiece of the cinematic art">
  <TELL ,PERIOD>>

<DEFINE SAY-MOVIE (STR)
  <TELL .STR>
  <COND (<0? <CURRENT-STAR>>
	 <CURRENT-STAR <ZRANDOM <ZGET ,MOVIE-STARS 0>>>
	 <CURRENT-DESC <ZRANDOM <ZGET ,MOVIE-DESCS 0>>>
	 <CURRENT-WEAPON <ZRANDOM <ZGET ,MOVIE-WEAPONS 0>>>)>
  <TELL ", a movie in which " <ZGET ,MOVIE-STARS <CURRENT-STAR>> " "
	<ZGET ,MOVIE-DESCS <CURRENT-DESC>> " with "
	<ZGET ,MOVIE-WEAPONS <CURRENT-WEAPON>>>>

<DEFINE MOVIE-ENDS ()
  <ZCRLF>
  <SAY-MOVIE "You notice that the current entertainment">
  <TELL ", has ended" ,PCR>
  <CURRENT-STAR 0>>

<DEFINE DESCRIBE-AIRLINE-PERSON (N:FIX "OPT" (SHORT? <>))
  <RANDOM-PERSON-F <COND (.SHORT? ,M-SHORTDESC)
			 (T ,M-OBJDESC)> .N>>

<DEFINE RAND-PRSO? (N:FIX)
  <COND (<AND <==? ,PRSO ,RANDOM-OBJECT>
	      <==? <GETP ,PRSO ,P?PSEUDO-TABLE> .N>> T)
	(T <>)>>

<DEFINE RAND-PRSI? (N:FIX)
  <COND (<AND <==? ,PRSI ,RANDOM-OBJECT>
	      <==? <GETP ,PRSI ,P?PSEUDO-TABLE> .N>> T)
	(T <>)>>

<DEFINE FORM? ()
  <OR <==? ,PRSO ,IFORM>
      <==? ,PRSI ,IFORM>
      <RAND-PRSO? ,FORM-OBJECT>
      <RAND-PRSI? ,FORM-OBJECT>>>

<DEFINE MEAL? ()
  <OR <==? ,PRSO ,AIRLINE-MEAL>
      <==? ,PRSI ,AIRLINE-MEAL>
      <RAND-PRSO? ,MEAL-OBJECT>
      <RAND-PRSI? ,MEAL-OBJECT>>>

<DEFINE RANDOM-PERSON-SDESC ()
  <RANDOM-PERSON-F ,M-SHORTDESC>>

<DEFINE PERFORM-WITH-PLAYER (PRSA PRSO "OPT" (PRSI <>)
			     "AUX" (OWINNER ,WINNER) VAL)
  <SETG WINNER ,PLAYER>
  <SET VAL <PERFORM .PRSA .PRSO .PRSI>>
  <SETG WINNER .OWINNER>
  .VAL>

<DEFINE RANDOM-PERSON-F ("OPT" (CONTEXT 0) (N 0) "AUX" STR)
  <COND (<==? .N 0>
	 <SET N <GETP ,RANDOM-PERSON ,P?PSEUDO-TABLE>>)>
  <COND (<==? .CONTEXT ,M-WINNER>
	 <COND (<VERB? HELLO>
		; "FOO, HELLO becomes HELLO FOO"
		<PERFORM-WITH-PLAYER ,V?HELLO ,RANDOM-PERSON>
		T)
	       (<AND <VERB? SHOW>
		     <PRSI? ME>>
		<PERFORM-WITH-PLAYER ,V?ASK-ABOUT ,RANDOM-PERSON ,PRSO>)
	       (<AND <VERB? TELL TELL-TIME TELL-ABOUT>
		     <PRSO? ME>>
		<PERFORM-WITH-PLAYER ,V?ASK-ABOUT ,RANDOM-PERSON ,PRSI>)
	       (<VERB? WHAT>
		<PERFORM-WITH-PLAYER ,V?ASK-ABOUT ,RANDOM-PERSON ,PRSO>
		T)
	       (<AND <VERB? GIVE>
		     <PRSI? PLAYER ME>>
		; "FOO, GIVE ME BAR becomes TAKE BAR FROM FOO"
		<PERFORM-WITH-PLAYER ,V?TAKE ,PRSO ,RANDOM-PERSON>)
	       (<VERB? FILL-IN>
		<COND (<OR <F? <FORM?>>
			   <F? <FORM-SEEN?>>>
		       <TELL "\"I don't know what you're talking about.\"" CR>)
		      (T
		       <TELL "\"I'll take care of myself, thank you.\"" CR>
		       <COND (<==? .N ,GRANDMA-PERSON>
			      <SET-GRANDMA-HAPPY <>>)>)>
		T)
	       (<PRSO? AIRLINE-MEAL>
		<TELL CTHE ,WINNER
		      " draws back in horror at the mere sight of "
		      THEO ,PERIOD>)
	       (T <>)>)
	(<EQUAL? .CONTEXT ,M-OBJDESC ,M-SHORTDESC>
	 <COND (<0? .N> <SET N <GETP ,RANDOM-PERSON ,P?PSEUDO-TABLE>>)>
	 <COND (<==? .N ,SMOKER-PERSON>
		<COND (<==? .CONTEXT ,M-OBJDESC>
		       <TELL "an ">)>
		<TELL "irritable fellow">)
	       (<==? .N ,GRANDMA-PERSON>
		<COND (<==? .CONTEXT ,M-OBJDESC>
		       <TELL "a ">)>
		<TELL "friendly old woman">)
	       (<==? .N ,BUSINESS-PERSON>
		<COND (<==? .CONTEXT ,M-SHORTDESC>
		       <TELL "harried man">)
		      (T
		       <TELL "a harried-looking man in a suit, working at a computer">)>)
	       (<==? .N ,MOMMA-PERSON>
		<COND (<==? .CONTEXT ,M-SHORTDESC>
		       <TELL "young mother">)
		      (T
		       <TELL
			"a young mother, with her even younger child">)>)>)
	(<T? .CONTEXT> <>)
	(<AND <TOUCHING?>
	      <EQUAL? .N ,GRANDMA-PERSON ,BUSINESS-PERSON ,MOMMA-PERSON>>
	 <TELL CTHE ,RANDOM-PERSON " draws back, looking annoyed. Perhaps you should keep your hands to yourself." CR>
	 <COND (<==? .N ,GRANDMA-PERSON>
		<SET-GRANDMA-HAPPY <>>)>
	 T)
	(<AND <THIS-PRSI?>
	      <VERB? GIVE>>
	 <PERFORM ,V?SHOW ,PRSO ,PRSI>)
	(<THIS-PRSO?>
	 <COND (<VERB? TELL>
		<COND (<SET STR <CHECK-OZ-ROYALTY ,PRSO T>>
		       <TELL "You have to strain to hear. \""
			     .STR ".\"" CR>
		       <PCLEAR>
		       ,FATAL-VALUE)
		      (T <>)>)
	       (<==? .N ,GRANDMA-PERSON>
		<GRANDMA-PERSON-PRSO>)
	       (<==? .N ,SMOKER-PERSON>
		<SMOKER-PERSON-PRSO>)
	       (<==? .N ,BUSINESS-PERSON>
		<BUSINESS-PERSON-PRSO>)
	       (<==? .N ,MOMMA-PERSON>
		<MOMMA-PERSON-PRSO>)>)
	(<==? .N ,GRANDMA-PERSON>
	 <GRANDMA-PERSON-PRSI>)
	(<==? .N ,SMOKER-PERSON>
	 <SMOKER-PERSON-PRSI>)
	(<==? .N ,BUSINESS-PERSON>
	 <BUSINESS-PERSON-PRSI>)
	(<==? .N ,MOMMA-PERSON>
	 <MOMMA-PERSON-PRSI>)>>

<DEFINE SET-GRANDMA-HAPPY (ON?)
  <COND (<T? .ON?>
	 <QUEUE I-CONVERSE>
	 <GRANDMA-HAPPY? T>)
	(T
	 <DEQUEUE I-CONVERSE>
	 <GRANDMA-HAPPY? <>>)>>

<DEFINE GRANDMA-PERSON-PRSO ()
  <COND (<VERB? ASK-ABOUT ASK-FOR>
	 <COND (<FORM?>
		<COND (<T? <FORM-SEEN?>>
		       <TELL "\"Yes, wasn't it fun to fill out? These modern conveniences just amaze me. Of course, my oldest granddaughter understands them much better than I do.\"" CR>)
		      (T
		       <TELL "\"Oh, I don't know anything about any form.\""
			     CR>)>)
	       (<MEAL?>
		<TELL "\"Yes, this airline has the ">
		<ITALICIZE "best">
		<TELL " food. My grandson Bruce is a wonderful cook, and he
swears he flies sometimes just for the food.\"" CR>)
	       (<AND <RAND-PRSI? ,VISA-NUMBER-OBJECT>
		     <T? <FORM-SEEN?>>>
		<TELL "\"I hear they're sort of private--if somebody gets into
trouble and they're using your visa number, you could be blamed for it">
		<COND (<T? <GRANDMA-HAPPY?>>
		       <SET-GOT-VISA-NUMBER?>
		       <TELL ". But you seem like such a nice young ">
		       <GENDER-PRINT "man" "lady">
		       <TELL ", you'd never get into trouble. Mine is ">
		       <TELL-VISA-NUMBER ,GRANDMA-PERSON>)>
		<TELL ".\"" CR>)
	       (<RAND-PRSI? ,GRANDCHILDREN-OBJECT>
		<COND (<PROB 50>
		       <TELL "\"I wish I'd brought my pictures of them. I find it's much easier to appreciate stories about people when you can see them, don't you? My great-grandson Roger could draw them, of course; he's a wonderful artist.\"" CR>)
		      (T
		       <TELL "\"Gosh, I'm really sorry I didn't bring my pictures. Maybe when you're back home, you can come over sometime to look at all the albums.\"" CR>)>
		<SET-GRANDMA-HAPPY T>)
	       (<PRSI? RANDOM-PERSON>
		<TELL "\"Oh, I'd much rather talk about my grandchildren.\""
		      CR>)
	       (T
		<TELL "\"Golly, I don't really know much about that. Now, my grandson at Harvard, ">
		<ITALICIZE "he">
		<TELL " can talk about almost anything. Never made much sense to me, of course.\"" CR>)>)
	(<VERB? EXAMINE>
	 <TELL "Silver hair, a twinkle in the eye, a smile on the lips, and a
story always ready on the tip of the tongue. It's hard to imagine a better
neighbor for a long trip." CR>)>>

<DEFINE I-CONVERSE ()
  ; "Dequeued by LEAVE-SEAT (and sometimes HASTA-LUMBAGO)"
  <COND (<NOT <HERE? SEAT>> <>)
	(<PROB 15>
	 <TELL CR "The grandmotherly type in the next seat turns to you. \"Did I tell you about "
	       PONE ,GRANDMA-STORIES "\"" CR>
	 T)
	(T <>)>>

<CONSTANT GRANDMA-STORIES
	  <PLTABLE "the time my grandson Dennis ...? ..."
		   "my granddaughter ...? ..."
		   "Tom, my athletic ...?...">>

<DEFINE GRANDMA-PERSON-PRSI ()
  <COND (<VERB? TAKE>
	 <SET-GRANDMA-HAPPY <>>
	 <TELL "\"I don't think that would be a good idea, do you?\"" CR>)
	(<VERB? SHOW>
	 <COND (<FORM?>
		<COND (<T? <FORM-SEEN?>>
		       <TELL "\"You'd better make sure it's filled out right. I hear these Zalagasans can be ">
		       <ITALICIZE "very">
		       <TELL " strict.\"" CR>)>)
	       (<NOT <RAND-PRSO? ,VISA-NUMBER-OBJECT>>
		<PERFORM ,V?ASK-ABOUT ,PRSI ,PRSO>)
	       (T
		<PERFORM ,V?ASK-ABOUT ,PRSI ,IFORM>)>)>>

<DEFINE SMOKER-SHOOTS-YOU ()
  <TELL "\"Remember when I told you you'd live to regret
doing that? I lied.\" He pulls a gun out of his pocket and shoots you. You
in fact feel no regret, because you're dead.">
  <JIGS-UP>>

<DEFINE SMOKER-PERSON-PRSO ()
  <COND (<TOUCHING?>
	 <COND (<F? ,SEX>	; "boy touching..."
		<COND (<F? <SMOKER-IRATE?>>
		       <TELL "He draws away from you, looking shocked.
\"Touch me again and you'll live to regret it, buddy.\"" CR>
		       <SMOKER-IRATE? T>)
		      (T
		       <SMOKER-SHOOTS-YOU>
		       T)>)
	       (T
		<TELL "He looks at you coldly. \"You're not my type, lady.
So buzz off.\"" CR>)>)
	(<VERB? ASK-ABOUT ASK-FOR>
	 <COND (<MEAL?>
		<TELL "\"They should just stick with the basic stuff. Give me a llama and turnip stew any day.\"" CR>)
	       (<FORM?>
		<COND (<T? <FORM-SEEN?>>
		       <TELL "\"Harrumph. They're wasting my time, and you're wasting my time. I should shoot you, then take the plane over and crash it into the immigration office.\"" CR>)
		      (T
		       <TELL "\"All forms are a waste of time.\"" CR>)>)
	       (<AND <RAND-PRSI? ,VISA-NUMBER-OBJECT>
		     <T? <FORM-SEEN?>>>
		<COND
		 (<T? <SMOKER-IRATE?>>
		  <SMOKER-SHOOTS-YOU>)
		 (T
		  <TELL "\"Why should I tell you my visa number? I went through
hell to get one, and now you want it for free. If I had my way, you'd be stuck
at home anyway. Mess with me again, and you'll regret it.\"" CR>)>)
	       (T
		<TELL
		 "\"Why don't you make a noise like a hoop and roll away?\""
		 CR>)>)
	(<VERB? HELLO>
	 <TELL "\"Why don't you make like a pea and split?\"" CR>)
	(<VERB? EXAMINE>
	 <TELL "This gentleman looks like he might be permanently annoyed
about something. You might want to proceed with caution." CR>)
	(T <>)>>

<DEFINE SMOKER-PERSON-PRSI ()
  <COND (<VERB? TAKE>
	 <COND (<T? <SMOKER-IRATE?>>
		<SMOKER-SHOOTS-YOU>)
	       (T
		<TELL "\"Try something like that again and I guarantee you'll regret it." CR>)>
	 <SMOKER-IRATE? T>)
	(<VERB? SHOW>
	 <COND (<NOT <RAND-PRSO? ,VISA-NUMBER-OBJECT>>
		<PERFORM ,V?ASK-ABOUT ,PRSI ,PRSO>)
	       (T
		<PERFORM ,V?ASK-ABOUT ,PRSI ,IFORM>)>)>>

<DEFINE BUSINESS-PERSON-PRSO ()
  <COND (<VERB? HELLO>
	 <COND (<T? <BUSINESS-IRATE?>>
		<TELL CTHEO " nods coldly." CR>)
	       (T
		<TELL CTHEO " smiles and nods, then returns to his computer."
		      CR>)>)
	(<VERB? ASK-ABOUT ASK-FOR>
	 <COND (<FORM?>
		<COND (<T? <FORM-SEEN?>>
		       <TELL "\"A real waste of time, if you ask me. I travel
all the time, and this is the first time they've done something like this.\"
He returns to his computer." CR>)
		      (T
		       <TELL "\"What are you talking about? I never heard of any form.\"" CR>)>)
	       (<RAND-PRSI? ,VISA-NUMBER-OBJECT>
		<COND (<T? <BUSINESS-IRATE?>>
		       <TELL "\"Just leave me alone, ">
		       <LADY-OR-MISTER>
		       <TELL ".\"" CR>)
		      (<F? <FORM-SEEN?>>
		       <TELL
			"\"I really don't know what you're talking about.\""
			CR>)
		      (T
		       <SET-GOT-VISA-NUMBER?>
		       <TELL "\"Hmph. I didn't think you needed that on this
flight, so I just made one up: I'm usually pretty good at getting numbers that
sound right. This time, I used ">
		       <TELL-VISA-NUMBER ,BUSINESS-PERSON>
		       <TELL ".\"" CR>)>)
	       (<MEAL?>
		<TELL "\"I don't have much time for food, but the stuff they
have here seems pretty good. My wife likes it a lot.\"" CR>)
	       (<OR <==? ,PRSI ,COMPUTER>
		    <RAND-PRSI? ,COMPUTER-OBJECT>>
		<TELL "\"Wonderful things, aren't they? I use mine all
the time.\" His voice drops to a whisper. \"Right now, I'm entering my
wife's recipe file; there's this wonderful recipe program I got an advance
copy of.\"" CR>)
	       (<OR <==? ,PRSI ,RECIPE>
		    <RAND-PRSI? ,RECIPE-OBJECT>>
		<COND (<META-IN? ,RECIPE ,PLAYER>
		       <TELL "\"Hey, where'd you get that?\" He's whispering now.
\"The guy I got mine from swore it was the only copy, and that he'd written
it.\"" CR>)
		      (T
		       <TELL "\"Oh, it's just something I picked up. Nothing
special, but my wife likes to have her recipes on the computer.\"" CR>)>)
	       (<PRSI? RANDOM-PERSON>
		<TELL "\"I'm kind of busy right now.\"" CR>)
	       (T
		<TELL "\"What? I don't know anything about that.\"" CR>)>)
	(<VERB? EXAMINE>
	 <TELL "Your neighbor looks extremely busy, although not unfriendly.
He seems to be entering data on a Boysenberry laptop computer." CR>)>>

<DEFINE BUSINESS-PERSON-PRSI ()
  <COND (<VERB? SHOW>
	 <COND (<NOT <RAND-PRSO? ,VISA-NUMBER-OBJECT>>
		<PERFORM ,V?ASK-ABOUT ,PRSI ,PRSO>)
	       (T
		<PERFORM ,V?ASK-ABOUT ,PRSI ,IFORM>)>)
	(<VERB? TAKE>
	 <TELL "Hey, ">
	 <LADY-OR-MISTER>
	 <TELL ", take it easy. I need that." CR>
	 <BUSINESS-IRATE? T>)>>

<DEFINE MOMMA-PERSON-PRSI ()
  <COND (<VERB? SHOW>
	 <COND (<FORM?>
		<COND (<T? <FORM-SEEN?>>
		       <TELL "\"I don't understand why they wanted one for my baby. He's
not going to do anything wrong.\" She blushes as the baby spills some
partially-digested milk on her sleeve. \"At least not anything they ask
about here.\"" CR>)>)
	       (<RAND-PRSO? ,VISA-NUMBER-OBJECT>
		<PERFORM ,V?ASK-ABOUT ,PRSI ,IFORM>)
	       (T
		<PERFORM ,V?ASK-ABOUT ,PRSI ,PRSO>)>)
	(<VERB? TAKE>
	 <TELL "\"I don't think you'd want anything of mine.\"" CR>)>>

<DEFINE SET-GOT-VISA-NUMBER? ()
  <GOT-VISA-NUMBER? T>
  <COND (<G? <VISA-SCRIPT> 8>
	 <VISA-SLEEPING? 0>)>>

<DEFINE MOMMA-PERSON-PRSO ()
  <COND (<VERB? ASK-ABOUT ASK-FOR>
	 <COND (<FORM?>
		<COND (<T? <FORM-SEEN?>>
		       <TELL "\"I don't know any more than you do. I don't
understand filling out two of them, though--my baby doesn't even have a
passport, so why does he need a visa number?\"" CR>)
		      (T
		       <TELL "\"Form? I don't know anything about any form. I
thought I'd taken care of all that back home.\"" CR>)>)
	       (<MEAL?>
		<TELL "\"My husband really enjoys the food. I haven't had
any yet, though--I'm just going out to join him in Zalagasa. He's teaching
the natives about computers.\"" CR>)
	       (<RAND-PRSI? ,VISA-NUMBER-OBJECT>
		<COND
		 (<T? <FORM-SEEN?>>
		  <TELL "\"I found something on my passport that looked right.
Right under the picture on mine, it said ">
		  <TELL-VISA-NUMBER ,MOMMA-PERSON>
		  <SET-GOT-VISA-NUMBER?>
		  <TELL ".\"" CR>)
		 (T
		  <TELL "\"I don't know anything about that.\"" CR>)>)
	       (<RAND-PRSI? ,BABY-OBJECT>
		<TELL "\"Isn't he adorable? Everybody says he has my eyes, but
I think he looks just like my husband. I hope he'll be happy in Zalagasa; I
hear the natives are very fond of children.\"" CR>)
	       (T
		<TELL "She seems to be tickling her baby's feet, and doesn't
respond." CR>)>)
	(<VERB? EXAMINE>
	 <TELL "A typical young mother, if there is such a thing. The
accompanying baby seems to be fairly quiet, at least for now, and the smell
of baby powder is so far concealing any other smells he might be producing."
	       CR>)>>

<OBJECT AIRPHONE
	(LOC LAV-LOBBY)
	(DESC "telephone")
	(FDESC "On the wall, there's a telephone, with a slot for credit cards. It doesn't seem to take money for payment.")
	(FLAGS CONTAINER OPENED)
	(CAPACITY 1)
	(SYNONYM TELEPHONE PHONE AIRPHONE SLOT)
	(ADJECTIVE TELEPHONE PHONE AIR PAY)
	(ACTION AIRPHONE-F)>

<DEFINE AIRPHONE-F ()
  <COND (<THIS-PRSI?>
	 <COND (<VERB? PUT>
		<COND (<PRSO? EXCESS>
		       <TELL "The phone spits " THEO " back out, and a synthetic voice says \"Don't try to fool me with expired cards, twit.\"" CR>
		       T)
		      (<PRSO? BEEZER>
		       <MOVE ,BEEZER ,AIRPHONE>
		       <UNMAKE ,AIRPHONE ,OPENED>
		       <TELL CTHEO " vanishes inside the phone. A synthetic voice says \"Please place your call now. You'll get your card back when you're done.\"" CR>
		       T)
		      (T
		       <TELL "\"Hey, twit, don't try to fool ">
		       <ITALICIZE "me">
		       <TELL
			" with that stuff. I know a credit card when I eat it."
			CR>)>)>)
	(<VERB? EXAMINE LOOK-ON>
	 <TELL ,THIS-IS "a pay telephone. It has a slot for credit cards, but doesn't seem to accept cash." CR>)
	(<VERB? UNPLUG>
	 <TELL "Vandalism is probably not a great idea." CR>)
	(<VERB? HANGUP>
	 <COND (<IN? ,BEEZER ,AIRPHONE>
		<MAKE ,AIRPHONE ,OPENED>
		<MOVE ,BEEZER ,PLAYER>
		<TELL "The phone spits out your " D ,BEEZER ", and thanks you for your business." CR>
		T)
	       (T
		<TELL "You weren't using it anyway." CR>)>)>>
