"XXJET for BUREAUCRACY; Copyright 1987 Infocom, Inc. All rights reserved."

<INCLUDE "XXJETDEFS" "OLD-PARSERDEFS">

<FILE-FLAGS MDL-ZIL?>

<DEFINE GO-TO-PLANE ()
	 <ZREMOVE ,ZTICKET>
	 <DEQUEUE I-TUNE-TIMER>
	 <DEQUEUE I-TERMINAL>
	 <DEQUEUE I-ZALAGASA-DESK>
	 <DEQUEUE I-DESK>
	 <QUEUE I-PHONES>
	 <TUNE-TIMER 3>
	 <SETG HERE ,AISLE>
	 <MOVE ,PLAYER ,AISLE>
	 ; "Put smoker/non-smoker in next seat."
	 <INITIALIZE-SEATS>
	 <MAKE ,SEATBELT ,WORN>
	 <MOVE ,SEATBELT ,PLAYER>
	 <TELL "You are sitting in an incredibly comfortable FubAero
7-11 Air Zalagasa jet, cruising 30,000 feet above somewhere which you don't
know where it is" ,PCR>
	 <GOTO ,SEAT>
	 <QUEUE I-RUN-PLANE -1>
	 T>

<DEFINE INITIALIZE-SEATS ()
  <SET-SEAT-PERSON ,PERSON-MASK ,SEAT-B 1 T>
  <SET-SEAT-PERSON ,PERSON-MASK ,SEAT-D 1 T>
  ;<SET-SEAT-PERSON ,BALD-PERSON ,SEAT-B 2>
  <SET-SEAT-PERSON ,PERSON-MASK ,SEAT-B 2 T>
  <SET-SEAT-PERSON ,PERSON-MASK ,SEAT-D 2 T>
  <SET-SEAT-PERSON ,POLITICIANS-PERSON ,SEAT-D 3 T>
  <SET-SEAT-PERSON ,ZALAGASANS-PERSON ,SEAT-B 4 T>
  <SET-SEAT-PERSON ,GRANDMA-PERSON ,SEAT-C 5>
  <SET-SEAT-PERSON ,PERSON-MASK ,SEAT-D 5 T>
  <SET-SEAT-PERSON ,FROBOZZCO-PERSON ,SEAT-B 6 T>
  <SET-SEAT-PERSON ,FAT-PERSON ,SEAT-E 6>
  <SET-SEAT-PERSON ,SLEEPER-PERSON ,SEAT-E 7>
  <SET-SEAT-PERSON ,PERSON-MASK ,SEAT-B 7 T>
  <SET-SEAT-PERSON ,MOMMA-PERSON ,SEAT-B 8 T>
  <SET-SEAT-PERSON ,SMOKER-PERSON ,SEAT-C 9>>

<OBJECT PLANE
	(LOC GLOBAL-OBJECTS)
	(DESC "aeroplane" ;"airplane")
	(FLAGS NODESC VOWEL PLACE)
	(SYNONYM PLANE AIRPLANE AEROPLANE JET AIRCRAFT)
	(ACTION PLANE-F)>

<DEFINE PLANE-F ()
	<COND (<VERB? WAIT-FOR>
	       <COND (<ON-PLANE?>
		      <TELL "You already did that, with some success." CR>)
		     (<IS? ,HERE ,IN-TERMINAL>
		      <TELL "Normally, one must actively seek out " D ,PLANE "s
in places like this. They won't come to you." CR>)
		     (<NOT <HERE? LANDING-STRIP>>
		      <TELL "We predict that you can wait as long as you want
here, and never see an " D ,PLANE ". We could be wrong, but don't count on it."
			    CR>)
		     (<NOT ,PLANE-SUMMONED?>
		      <TELL "There is a limit to human patience, which you
soon reach. The plane still doesn't come, because it never will.">
		      <JIGS-UP>)
		     (T
		      <V-WAIT 10>)>)
	      (<HERE? IN-AIR>
	       <TELL
		"The " D ,PLANE " has already flown on. You can no longer see it."
		CR>)
	      (<AND <HERE? OUTSIDE-PLANE>
		    <VERB? EXAMINE>>
	       <TELL "It's a standard Air Zalagasa FubAero 7-11 jetliner, with a parachute stuck in the exit." CR>)
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
\
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

<DEFINE AISLE-SEEN? (ROW "OPT" (DOSET? <>) (NEWVAL <>)
		     "AUX" (BIT <DO-LSH .ROW>))
  <COND (<NOT .DOSET?>
	 <COND (<BTST <AISLE-STATE> .BIT> T)
	       (T <>)>)
	(<T? .NEWVAL>
	 <AISLE-STATE <ORB <AISLE-STATE> .BIT>>)
	(T
	 <AISLE-STATE <ANDB <AISLE-STATE> <XORB .BIT -1>>>)>>

<DEFINE SEAT-PERSON ("OPT" (N:FIX 0) (ROW:FIX 0))
  <ANDB <GET-SEAT .N .ROW> ,PERSON-MASK>>

<DEFINE OCCUPIED? ("OPT" (N:FIX 0) (ROW:FIX 0))
  <COND (<0? <SEAT-PERSON .N .ROW>> 0)
	(T 1)>>

<CONSTANT PERSON-ROWS <ITABLE ,PERSON-COUNT>>

<DEFINE SET-SEAT-PERSON (WHO:FIX SEATNUM:FIX ROW:FIX "OPT" (TWO? <>) "AUX" OLD)
  <SET OLD <SEAT-PERSON .SEATNUM .ROW>>
  <COND (<AND <G? .OLD 0>
	      <L? .OLD ,PERSON-MASK>>
	 <PUTB ,PERSON-ROWS <SET OLD <- .OLD 1>> 255>)>
  <COND (<T? .WHO> <PUTB ,PERSON-ROWS <- .WHO 1> .ROW>)>
  <SET-SEAT <ORB <ANDB <GET-SEAT .SEATNUM .ROW> <XORB ,PERSON-MASK -1>>
		 .WHO> .SEATNUM .ROW>
  <COND (.TWO?
	 <SET-SEAT <ORB <ANDB <GET-SEAT <SET SEATNUM <+ .SEATNUM 1>>>
			      <XORB ,PERSON-MASK -1>>
			.WHO>
		   .SEATNUM .ROW>)>>

<DEFINE SET-SEAT (NEW "OPT" (N:FIX 0) (ROW:FIX 0))
  <COND (<0? .N> <SET N ,CURRENT-SEAT>)>
  <COND (<0? .ROW> <SET ROW ,CURRENT-ROW>)>
  <PUTB ,ALL-SEATS <+ <* <SET ROW <- .ROW 1>> 4>
		      <SET N <- .N 1>>>
	.NEW>>

<DEFINE GET-SEAT ("OPT" (N:FIX 0) (ROW:FIX 0))
  <COND (<0? .N> <SET N ,CURRENT-SEAT>)>
  <COND (<0? .ROW> <SET ROW ,CURRENT-ROW>)>
  <GETB ,ALL-SEATS <+ <* <SET ROW <- .ROW 1>> 4>
		      <SET N <- .N 1>>>>>

<DEFINE COUNT-OCCUPIED-SEATS ("OPT" (ROW 0))
  <COND (<0? .ROW> <SET ROW ,CURRENT-ROW>)>
  <+ <OCCUPIED? ,SEAT-B .ROW>
     <OCCUPIED? ,SEAT-C .ROW>
     <OCCUPIED? ,SEAT-D .ROW>
     <OCCUPIED? ,SEAT-E .ROW>>>

<DEFINE ROW-LOOK-OK? (ROW)
  <COND (<OR <AND <G? .ROW ,CURRENT-ROW>
		  <==? ,P-DIRECTION ,P?SOUTH>>
	     <AND <L? .ROW ,CURRENT-ROW>
		  <==? ,P-DIRECTION ,P?NORTH>>> T)
	(T <>)>>

<DEFINE AISLE-F AISLE (RARG "AUX" SEAT-MASK NR P1 P2 P3 P4 CT)
	<COND (<==? .RARG ,M-LOOK>
	       <TELL "You are standing in the aisle, at row "
		     N ,CURRENT-ROW ". ">
	       <SET P1 <SEAT-PERSON ,SEAT-B>>
	       <SET P2 <SEAT-PERSON ,SEAT-C>>
	       <SET P3 <SEAT-PERSON ,SEAT-D>>
	       <SET P4 <SEAT-PERSON ,SEAT-E>>
	       <COND (<AND <T? .P1>
			   <T? .P2>
			   <T? .P3>
			   <T? .P4>>
		      <TELL "All the seats in this row are occupied. ">)
		     (<AND <F? .P1> <F? .P2> <F? .P3> <F? .P4>>
		      <TELL "This row is unoccupied. ">)
		     (T
		      <DESCRIBE-TWO-SEATS ,SEAT-B T <>>
		      <DESCRIBE-TWO-SEATS ,SEAT-D <> T>)>
	       <COND (<IS? ,FLIGHT-ATTENDANT ,SEEN>
		      <TELL CA ,FLIGHT-ATTENDANT " is waiting here. ">)>
	       <DESC-SEATBELT>
	       <ZCRLF>)
	      (<==? .RARG ,M-BEG>
	       <SET CT <COUNT-OCCUPIED-SEATS>>
	       <COND (<AND <VERB? EXAMINE>
			   <PRSO? INTDIR>>
		      <COND (<==? ,P-DIRECTION ,P?EAST>
			     <DESCRIBE-TWO-SEATS ,SEAT-D T T>
			     T)
			    (<==? ,P-DIRECTION ,P?WEST>
			     <DESCRIBE-TWO-SEATS ,SEAT-B T T>
			     T)
			    (<EQUAL? ,P-DIRECTION ,P?SOUTH ,P?NORTH>
			     ; "Looking up or down the aisle"
			     <COND
			      (<QUEUED? I-CLEANUP-FOOD>
			       <COND
				(<ROW-LOOK-OK? <SPLATTED-ROW>>
				 <DEQUEUE I-CLEANUP-FOOD>
				 <TELL "A flight attendant is wiping ">
				 <COND (<==? <SPLATTED-PERSON> ,PERSON-MASK>
					<TELL "someone down">)
				       (T
					<TELL "down ">
					<RANDOM-PERSON-F ,M-OBJDESC
							 <SPLATTED-PERSON>>)>
				 <TELL " with a wet cloth." CR>)
				(T <>)>)
			      (<QUEUED? I-FAKE-ATTENDANT>
			       <COND
				(<ROW-LOOK-OK? <DING-ROW>>
				 <DEQUEUE I-FAKE-ATTENDANT>
				 <COND (<==? <DING-ROW> 9>
					<TELL
"You witness the tail end of an argument between a flight attendant and
an angry man. The flight attendant appears to be righteously enraged
at having been summoned by the bell to attend to a passenger's needs,
and the angry man is protesting that never, never would he be so
foolish and unreasonable as even to contemplate pressing a flight attendant
call button, which he is well aware is an offence against almost everything
that it is possible to be an offence against." CR>)
				       (<0? <COUNT-OCCUPIED-SEATS <DING-ROW>>>
					<TELL "You see a bewildered
flight attendant, who perhaps is starting to believe in ghosts." CR>)
				       (T
					<TELL "You witness the tail end of
an argument between the flight attendant and a passenger; the flight attendant
seems to be insisting that in fact she was summoned, and must therefore fail
to perform some service for the passenger." CR>)>)
				(T <>)>)>)
			    (T <>)>)
		     (<AND <VERB? SIT>
			   <F? ,PRSO>
			   <N==? .CT 4>>
		      <COND (<==? .CT 3>
			     <REPEAT ((N ,SEAT-B))
			       <COND (<T? <OCCUPIED? .N>>
				      <SET N <+ .N 1>>)
				     (T
				      <SETG CURRENT-SEAT .N>
				      <RETURN>)>>
			     <SETUP-NEW-SEAT>
			     <GOTO ,SEAT>
			     T)
			    (T
			     <>)>)
		     (T <>)>)
	      (<==? .RARG ,M-ENTERED>
	       <COND (<==? ,CURRENT-ROW 8>
		      <NEXT-TO-BABY? T>)
		     (T
		      <NEXT-TO-BABY? <>>)>
	       <COND (<OR <AND <QUEUED? I-FAKE-ATTENDANT>
			       <==? ,CURRENT-ROW <DING-ROW>>>
			  <AND <QUEUED? I-CLEANUP-FOOD>
			       <==? ,CURRENT-ROW <SPLATTED-ROW>>>>
		      <FLIGHT-ATTENDANT-APPEARS>
		      <TELL CR
		       "You arrive just as the flight attendant finishes ">
		      <COND (<==? ,CURRENT-ROW <SPLATTED-ROW>>
			     <TELL "some rather nasty business involving
food">)
			    (T
			     <TELL "a heated argument about a call button">)>
		      <TELL " with one of the passengers." CR>)>
	       <>)
	      (<==? .RARG ,M-ENTERING>
	       <SET-AISLE-TOUCHED>
	       <>)
	      (<==? .RARG ,M-EXIT>
	       <COND (<AND <T? <NEXT-TO-BABY?>>
			   <0? <BABY-DISTURBED?>>>
		      <TELL "Unfortunately, you wake the baby as you tiptoe
past. It immediately emits a hateful little bleat. You wonder if it has any
llama blood in it, then it starts to scream. The mother picks it up and walks
up and down the aisle for a moment to calm it. Within seconds, it falls into
a stupid, half-witted sleep" ,PCR>
		      <BABY-DISTURBED? 1>)>
	       <NEXT-TO-BABY? <>>
	       <COND (<HERE? NERD>
		      <ZREMOVE ,NERD>
		      <NERD-SAYS-WAIT>)>
	       <>)
	      (<T? .RARG> <>)
	      (<VERB? WALK-TO>
	       <COND (<AND <SET NR <NEW-ROW>>
			   <N==? .NR ,CURRENT-ROW>>
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
	      (<TOUCHING?>
	       <TELL "Really now, you're just trying to cause trouble.
The aisle is only for walking in, nothing else." CR>)
	      (T <>)>>

<DEFINE DESCRIBE-TWO-SEATS (FIRST FF? LAST? "AUX" P1 P2)
  <SET P1 <SEAT-PERSON .FIRST>>
  <SET P2 <SEAT-PERSON <+ .FIRST 1>>>
  <COND (<EQUAL? ,PERSON-MASK .P1 .P2>
	 <BOTH-SEATS .FIRST "occupied" .FF? .LAST?>)
	(<==? .P1 .P2>
	 <DESCRIBE-PAIR .P1 .FIRST .FF? .LAST?>)
	(T
	 <DESCRIBE-SEAT .FIRST .P1 .FF? <>>
	 <DESCRIBE-SEAT <+ .FIRST 1> .P2 <> .LAST?>)>>

<DEFINE BOTH-SEATS (SEATNUM STR FF? LAST?)
  <COND (.FF?
	 <TELL "B">)
	(T
	 <TELL "b">)>
  <TELL "oth seats " CHAR <SEAT-LETTER .SEATNUM>
	" and " CHAR <SEAT-LETTER <SET SEATNUM <+ .SEATNUM 1>>>
	" are " .STR>
  <COND (<NOT .LAST?>
	 <TELL "; ">)
	(T
	 <TELL ". ">)>>

<DEFINE DESC-SEATBELT ()
	<COND (<IS? ,SEATBELT ,LIGHTED>
	       <TELL CR "The fasten seatbelt sign overhead is lit.">)>>

<DEFINE SAME-SIDE? (SEATA SEATB)
  <COND (<OR <AND <G=? .SEATA ,SEAT-C>
		  <G=? .SEATB ,SEAT-C>>
	     <AND <L=? .SEATA ,SEAT-B>
		  <L=? .SEATB ,SEAT-B>>>
	 T)
	(T <>)>>

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
	 <COND (<T? <OCCUPIED? .NEW-SEAT>>
		<TELL "That would be impolite." CR>
		<>)
	       (T T)>)
	(T
	 <TELL "You'd better go to that seat first." CR>
	 <>)>>

<DEFINE SEAT-LETTER (N:FIX)
  <GETB ,SEAT-LETTERS <- .N 1>>>

<DEFINE NAME-SEAT (N:FIX "OPT" (FF? <>))
  <COND (.FF?
	 <TELL "S">)
	(T
	 <TELL "s">)>
  <TELL "eat " CHAR <SEAT-LETTER .N>>>

<DEFINE DESCRIBE-PAIR (WHO:FIX SEATNUM FF? LAST?)
  <COND (<0? .WHO>
	 <BOTH-SEATS .SEATNUM "unoccupied" .FF? .LAST?>)
	(T
	 <COND (.FF?
		<TELL "T">)
	       (T
		<TELL "t">)>
	 <COND (<==? .WHO ,POLITICIANS-PERSON>
		<TELL "here are two politicians in seats D and E, both in obvious need of lithium therapy">)
	       (<==? .WHO ,ZALAGASANS-PERSON>
		<TELL "wo Zalagasans are sitting in seats B and C playing \"I
Left My Heart in San Francisco\" on ethnic nose flutes">)
	       (<==? .WHO ,FROBOZZCO-PERSON>
		<TELL "here are two Frobozzco executives in seats B and C">)
	       (<==? .WHO ,MOMMA-PERSON>
		<TELL "here is a mother in seat C; her baby, resting quietly
for the moment, is next to her in seat B">)>
	 <COND (.LAST? <TELL ". ">)
	       (T <TELL "; ">)>)>>

<DEFINE DESCRIBE-SEAT (N:<OR FIX FALSE> PERS FF? "OPT" (LAST? <>))
  <NAME-SEAT .N .FF?>
  <COND (<==? .PERS ,PERSON-MASK>
	 <TELL " is occupied">)
	(<0? .PERS>
	 <TELL " is empty">)
	(T
	 <TELL " is occupied by ">
	 <DESCRIBE-AIRLINE-PERSON .PERS>)>
  <COND (.LAST?
	 <COND (.FF? <TELL ,PERIOD>)
	       (T
		<TELL ". ">)>)
	(T
	 <TELL "; ">)>>

<DEFINE SDESC-AISLE ()
  <TELL "Aisle, at row " N ,CURRENT-ROW>>

"Wander the aisle. Front goes to Galley, back goes to area outside
 lavatory."
<DEFINE CLEAN-UP-AISLE ("AUX" OBJ NO (ANY? <>))
  <SET ANY? <POLICE-AREA ,AISLE <> ,GALLEY>>
  <COND (<T? .ANY?>
	 <MAKE ,FLIGHT-ATTENDANT ,NODESC>
	 <TELL "You hear a scurrying, then an announcement. \"The passenger
who left ">
	 <PRINT-CONTENTS ,GALLEY>
	 ; "In case f.a. is in galley"
	 <UNMAKE ,FLIGHT-ATTENDANT ,NODESC>
	 <TELL " in the aisle may retrieve his property in the galley, at
the front of the aircraft.\"" CR CR>)>>

<DEFINE AISLE-TO-AISLE ()
  <CLEAN-UP-AISLE>
  <COND (<==? ,P-WALK-DIR ,P?NORTH>
	 <COND (<==? ,CURRENT-ROW 1>
		,GALLEY)
	       (T
		<SETG CURRENT-ROW <- ,CURRENT-ROW 1>>
		<SETG OLD-HERE <>>
		,AISLE)>)
	(<==? ,P-WALK-DIR ,P?SOUTH>
	 <COND (<==? ,CURRENT-ROW ,AISLE-COUNT>
		,LAV-LOBBY)
	       (T
		<SETG CURRENT-ROW <+ ,CURRENT-ROW 1>>
		<SETG OLD-HERE <>>
		,AISLE)>)>>

<DEFINE SET-AISLE-TOUCHED ()
  <COND (<NOT <AISLE-SEEN? ,CURRENT-ROW>>
	 <AISLE-SEEN? ,CURRENT-ROW T T>
	 <UNMAKE ,AISLE ,TOUCHED>)
	(T
	 <MAKE ,AISLE ,TOUCHED>)>
  <SETUP-NEIGHBOR 0>>

<DEFINE SETUP-NEIGHBOR (WHICH "AUX" N CT LAST)
  <COND (<L? .WHICH 2>
	 <SET CT ,SEAT-B>
	 <COND (<0? .WHICH> <SET LAST ,SEAT-E>)
	       (T <SET LAST ,SEAT-C>)>)
	(T
	 <SET CT ,SEAT-D>
	 <SET LAST ,SEAT-E>)>
  <SET N <>>
  <REPEAT ()
    <COND (<T? <SET N <SEAT-PERSON .CT>>>
	   <RETURN>)>
    <COND (<G? <SET CT <+ .CT 1>> .LAST>
	   <RETURN>)>>
  <CURRENT-NEIGHBOR .N>
  <COND (<G? .N 0>
	 <CURRENT-NEIGHBOR-SEATNUM .CT>)>>

<DEFINE AISLE-TO-SEAT ("AUX" S1 S2 A1 A2)
	<COND (<==? ,P-WALK-DIR ,P?EAST>
	       ; "North is forward, so east is to C & D"
	       <SET A1 ,SEAT-D>
	       <SET A2 ,SEAT-E>)
	      (T
	       <SET A1 ,SEAT-B>
	       <SET A2 ,SEAT-C>)>
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
\
; "Miscellany around the seat."
<OBJECT SEATBELT
	(LOC SEAT)
	(DESC "seat belt")
	(FLAGS CLOTHING NODESC)
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
	      (<VERB? UNTIE TAKE-OFF RELEASE>
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
	 <COND (<VERB? LAMP-ON LAMP-OFF>
		<TELL CTHEO " is controlled by outside forces." CR>)
	       (<AND <VERB? PUSH>
		     <F? <ZGET ,P-ADJW 0>>>
		<PUTP ,RANDOM-OBJECT ,P?PSEUDO-TABLE ,LIGHT-BUTTON>
		<PERFORM ,PRSA ,RANDOM-OBJECT>
		T)
	       (<VERB? EXAMINE READ>
		<SEATBELT-LIGHT-F ,M-OBJDESC>
		<ZCRLF>)>)>>

<DEFINE GEN-ROW (OFFS)
  <COND (<0? <SET OFFS <+ ,CURRENT-ROW .OFFS>>>
	 ,AISLE-COUNT)
	(<==? .OFFS ,AISLE-COUNT>
	 .OFFS)
	(T <MOD .OFFS ,AISLE-COUNT>)>>

<DEFINE GEN-SEAT (OFFS "AUX" (START ,CURRENT-SEAT))
  <REPEAT ()
    <COND (<0? .OFFS> <RETURN>)>
    <COND (<L? .OFFS 0>
	   <COND (<==? .START ,SEAT-B>
		  <SET START ,SEAT-E>)
		 (T
		  <SET START <- .START 1>>)>
	   <SET OFFS <+ .OFFS 1>>)
	  (T
	   <COND (<==? .START ,SEAT-E>
		  <SET START ,SEAT-B>)
		 (T
		  <SET START <+ .START 1>>)>
	   <SET OFFS <- .OFFS 1>>)>>
  .START>

<DEFINE CALL-SEAT ("AUX" (ROW <GEN-ROW 1>) (SEAT <GEN-SEAT 2>))
  <TELL "You hear a ding-dong from ">
  <COND (<G? .ROW ,CURRENT-ROW>
	 <TELL "behind you">)
	(T
	 <TELL "far ahead">)>
  <TELL ,PERIOD>
  <DING-ROW .ROW>
  <QUEUE I-FAKE-ATTENDANT 2>>

<DEFINE I-FAKE-ATTENDANT ()
  <DING-ROW 0>
  <>>

<DEFINE I-CLEANUP-FOOD ()
  <SPLATTED-ROW 0>
  <SPLATTED-PERSON 0>
  <>>

<DEFINE RECLINE-SEAT ("AUX" (ROW <GEN-ROW 3>) (SEATNUM <GEN-SEAT -1>) WHO
		      (CT <SPLAT-COUNT>))
  <COND (<AND <==? .ROW <- <MEAL-ROW> 1>>
	      <==? .SEATNUM <MEAL-SEAT>>
	      <T? <MEAL-HERE?>>>
	 ; "Table up"
	 <SET-SEAT <ANDB <GET-SEAT <MEAL-SEAT> <MEAL-ROW>>
			  <XORB ,MEAL-MASK -1>>
		    <MEAL-SEAT> <MEAL-ROW>>
	 <TELL "There is a dreadful wet squelch from towards the ">
	 <COND (<L? <MEAL-ROW> ,CURRENT-ROW> <TELL "front">)
	       (T <TELL "rear">)>
	 <TELL " of the
cabin, and, briefly, a whiff of something truly hellish." CR>
	 <QUEUE I-CALL-CRASH 10>
	 <MEAL-SQUASHED? T>)
	(T
	 <DESCRIBE-SPLAT .ROW .SEATNUM>)>
  <COND (<G? <SET CT <+ .CT 1>> 5>
	 <TELL CR "Several of the passengers seem to be gathering in the
aisle; as they approach you, what had seemed like a low murmur becomes an
angry roar. \"Are you too blasted stupid to figure out what's going on here,
you twit? Trying to break all our necks, is that it? Well, we're not having
it!\" After they rend you limb from limb, they box you up, and toss you out
of the " D ,PLANE " over a particularly notorious den of cannibals, where you
become a picnic.">
	 <JIGS-UP>)
	(T
	 <SPLAT-COUNT .CT>)>>

<DEFINE DESCRIBE-SPLAT (ROW SEATNUM "AUX" (WHO 0) N DIR STR)
  <COND (<G? .ROW ,CURRENT-ROW>
	 <SET DIR "rear">)
	(T
	 <SET DIR "front">)>
  <COND (<L? .ROW ,AISLE-COUNT>
	 <SET WHO <SEAT-PERSON .SEATNUM <+ .ROW 1>>>)>
  <SET N .WHO>
  <COND (<F? .WHO>
	 <TELL "From somewhere in the " .DIR " of the aircraft, you
hear a sad mechanical groan, as if a tired Comf-O-Mat (TM) seat had,
for the too-manyth time, forced itself to recline abruptly, then forced
itself upright again">)
	(T
	 <QUEUE I-CLEANUP-FOOD 2>
	 <SPLATTED-ROW <SET ROW <+ .ROW 1>>>
	 <SPLATTED-PERSON .WHO>
	 <COND
	  (<OR <==? .WHO ,PERSON-MASK>
	       <NOT <0? <ANDB <GET-SEAT .SEATNUM .ROW> ,FOOD-MASK>>>
	       <F? <SET STR <ZGET ,FACE-IN-FOOD-STRS
				  <SET N <* 2 <SET N <- .N 1>>>>>>>>
	   <TELL "You hear a hoarse cry of dismay from the " .DIR
		 " of the " D ,PLANE ", but beyond the fact that someone
has obviously met with a sudden accident, you can tell nothing">)
	  (T
	   <SET-SEAT <ORB <GET-SEAT .SEATNUM .ROW> ,FOOD-MASK>
		     .SEATNUM .ROW>
	   <TELL "From somewhere ">
	   <COND (<G? ,CURRENT-ROW .ROW> <TELL "in front">)
		 (T <TELL "behind">)>
	   <TELL ", you hear a" .STR ". You immediately recognise this
as the characteristic sound of a" <ZGET ,FACE-IN-FOOD-STRS
					<SET N <+ .N 1>>>
				  " the seat in front of ">
	   <COND (<GET-SEX .WHO>
		  <SET DIR "her">
		  <SET STR "her">)
		 (T
		  <SET DIR "him">
		  <SET STR "his">)>
	   <TELL .DIR " has inexplicably shot back with astonishing
force, hitting " .DIR " on the back of " .STR
		 " head and forcing " .STR " face into " .STR
		 " food, then shot forward again with equal speed,
forcing " .STR " food into " .STR " face">)>)>
  <TELL ,PERIOD>>

<DEFINE SAY-AFFECTED-SEAT (WHICH "AUX" ROW SEATNUM)
  <COND (<==? .WHICH ,CALL-BUTTON> ;"LIGHT"
	 <SET ROW <GEN-ROW -1>>
	 <SET SEATNUM ,CURRENT-SEAT>)
	(<==? .WHICH ,LIGHT-BUTTON> ;"RECLINE"
	 <SET ROW <GEN-ROW 3>>
	 <SET SEATNUM <GEN-SEAT -1>>)
	(T
	 <SET ROW <GEN-ROW 1>>
	 <SET SEATNUM <GEN-SEAT 2>>)>
  <TELL N .ROW CHAR <GETB ,SEAT-LETTERS <SET SEATNUM <- .SEATNUM 1>>>>>

<DEFINE LIGHT-UP-SEAT LUS ("AUX" (ROW <GEN-ROW -1>) (SEATNUM ,CURRENT-SEAT)
			   DATA ON? WHICH)
  <SET DATA <GET-SEAT .SEATNUM .ROW>>
  <COND (<NOT <0? <ANDB .DATA ,LIGHT-MASK>>>
	 <SET-SEAT <ANDB .DATA <XORB ,LIGHT-MASK -1>> .SEATNUM .ROW>
	 <SET ON? <>>)
	(T
	 <SET-SEAT <ORB .DATA ,LIGHT-MASK> .SEATNUM .ROW>
	 <SET ON? T>)>
  <COND (<OR <==? ,CURRENT-ROW 1>
	     <F? <SET WHICH <SAY-HEAD .ROW .SEATNUM>>>>
	 <TELL ,DONT "notice any changes">)
	(.ON?
	 <TELL " starts to shine">)
	(T
	 <TELL " stops shining">)>
  <TELL ,PERIOD>>

<DEFINE AIR-MEAL-STATE ("OPT" (NEW 2))
  <TABLE-STATE .NEW ,MEAL-MASK>>

<DEFINE TABLE-STATE ("OPT" (NEW 2) (BIT ,TABLE-MASK)
		     "AUX" (DATA <GET-SEAT>))
  <COND (<==? .NEW 2>
	 <COND (<NOT <BTST .DATA .BIT>> <>)
	       (T T)>)
	(<0? .NEW>
	 <SET-SEAT <ANDB .DATA <XORB .BIT -1>>>)
	(T
	 <SET-SEAT <ORB .DATA .BIT>>)>>

<DEFINE SAY-HEAD (ROW SEATNUM "AUX" WHICH)
  <COND (<T? <SET WHICH <SEAT-PERSON .SEATNUM .ROW>>>
	 <TELL "The head of the ">
	 <COND (<==? .WHICH ,PERSON-MASK>
		<TELL "person">)
	       (T
		<RANDOM-PERSON-F ,M-SHORTDESC .WHICH>)>
	 <TELL " in front of you">)
	(T <>)>>



<OBJECT SEAT-POCKET
	(LOC SEAT)
	(DESC "seat pocket")
	(FLAGS CONTAINER OPENABLE OPENED NODESC)
	(CAPACITY 10)
	(SYNONYM POCKET)
	(ADJECTIVE SEAT)
	(ACTION SEAT-POCKET-F)>

<DEFINE SEAT-POCKET-F ()
  <COND (<AND <THIS-PRSI?>
	      <VERB? PUT>>
	 <COND (<==? ,PRSO ,AIRLINE-MEAL> <>)
	       (<NOT <INTBL? ,PRSO <ZREST ,NORMAL-SEAT-POCKET 2>
			     <ZGET ,NORMAL-SEAT-POCKET 0>>>
		<TELL "ZAA regulations strictly prohibit the storage of
one's personal belongings in the seat pocket. You might forget them." CR>)>)>>

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
	       <TELL "The in-flight magazine is packed with useful information
about duty-free cigarets, interesting llama-wool clothes and pygmy hog
breeding. There is a competition prize of $25,000 for the best photograph
of the amazingly rare Ai-Ai, and a long article which tells you far more
than you wanted to know about the damned creature, illustrated with a
fuzzy photograph which could equally well be a dingo's armpit on a dark
night, and another article on the legendary Zalagasan princess Ani-Ta'a,
a hypermanic virago who, according to the caption below her picture, could
enslave men and terrify babies at a single glance.|
|
The last item you read is a particularly boastful and disgusting article
on the various types of cannibalism practised in Zalagasa. Hardly any of
this material is of the slightest use to you, but you read it anyway
because that is the sort of thing people do on aeroplanes." CR>)>>

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
	       <TELL "This is a shiny card showing happy smiling Zalagasans
in a shiny Air Zalagasa " D ,PLANE " to which all sorts of terrible things are
happening.|
|
The first picture shows a happy smiling stewardess waving her arms in the
air. The second picture shows some happy, smiling Zalagasan passengers
cheerfully removing false teeth, wigs, glass eyes, spectacles, and ornamental
nose bones. The third picture shows some Zalagasan passengers who are almost
certainly happy and smiling but you can't tell because they are all bent
double, clasping their knees. The fourth picture appears to have been chewed
off by a llama or something, so you can't tell what the happy, smiling
Zalagasans which it undoubtedly showed were actually doing." CR>)>>

<OBJECT SAFETY-CARD-TWO
	(DESC "small piece of laminated card")
	(SYNONYM CARD PIECE)
	(ADJECTIVE SMALL LAMINATED PIECE CARD)
	(FLAGS TAKEABLE READABLE)
	(SIZE 1)
	(ACTION SAFETY-CARD-TWO-F)>

<DEFINE SAFETY-CARD-TWO-F ()
  <COND (<VERB? EXAMINE READ>
	 <TELL "The card is the missing bit from your safety instructions.
Gingerly avoiding the horrid little patch of dried llama-spit, you see a
really dreadful picture (specially commissioned from Zalagasa's most
famous primitive painter) of a smiling, cheerful Air Zalagasa flight
attendant dangling happily from a colossal parachute on which
is written \"STINGLAI KA'ABI.\"" CR>)>>

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

<DEFINE SEAT-TO-AISLE ("AUX" NEIGHBOR NEW-SEAT)
	<COND (<OR <AND <G? ,CURRENT-SEAT ,SEAT-C>
			<==? ,P-WALK-DIR ,P?WEST>>
		   <AND <L? ,CURRENT-SEAT ,SEAT-D>
			<==? ,P-WALK-DIR ,P?EAST>>
		   <==? ,P-WALK-DIR ,P?OUT>>
	       ; "Move into the aisle"
	       <LEAVE-SEAT>
	       ,AISLE)
	      (<OR <AND <==? ,CURRENT-SEAT ,SEAT-B>
			<==? ,P-WALK-DIR ,P?WEST>>
		   <AND <==? ,CURRENT-SEAT ,SEAT-E>
			<==? ,P-WALK-DIR ,P?EAST>>>
	       <TELL
		"That would put you outside the " D ,PLANE " with no parachute."
		CR>
	       <>)
	      (T
	       <COND (<==? ,CURRENT-SEAT ,SEAT-C>
		      <SET NEIGHBOR <SEAT-PERSON <SET NEW-SEAT ,SEAT-B>>>)
		     (T
		      <SET NEIGHBOR <SEAT-PERSON <SET NEW-SEAT ,SEAT-E>>>)>
	       <COND (<T? .NEIGHBOR>
		      <COND (<N==? ,SEX <GET-SEX .NEIGHBOR>>
			     <TELL "\"">
			     <GENDER-PRINT "Sir" "Madam">
			     <TELL ", kindly keep your hands to yourself!\""
				   CR>)
			    (T
			     <TELL "Your neighbour seems to fill the seat quite nicely."
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
	(DESC "aeroplane seat")
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

<DEFINE LOOK-FROM-SEAT (WHICH-WAY "AUX" (SS <+ ,CURRENT-SEAT .WHICH-WAY>))
  <COND (<OR <0? .SS>
	     <G? .SS 4>>
	 <>)
	(<==? <+ .SS ,CURRENT-SEAT> 5>
	 ; "seat 2 to seat 3, or vice versa--aisle"
	 <TELL "You see an aisle." CR>
	 T)
	(T
	 <DESCRIBE-SEAT .SS <SEAT-PERSON .SS> T T>
	 T)>>

<DEFINE SEAT-F SEAT ("OPT" (CONTEXT <>) "AUX" (NEW-ROW <NEW-ROW>)
		(NEW-SEAT <NEW-SEAT>) PERS)
	<COND (<==? .CONTEXT ,M-LOOK>
	       <TELL "This is an incredibly comfortable FubAero Comf-O-Mat (TM)
seat equipped with its own set of passenger station comfort controls. There
are buttons to recline the seat, call the attendant and control the lighting,
and a socket. The seat back in front of you contains a table and a pocket">
	       <COND (<FIRST? ,SEAT-POCKET>
		      <TELL "; " THE ,SEAT-POCKET " contains ">
		      <PRINT-CONTENTS ,SEAT-POCKET>)>
	       <TELL ".">
	       <COND (<IS? ,SEAT-TABLE ,SURFACE>
		      <TELL " " CTHE ,SEAT-TABLE " is down.">
		      <COND (<FIRST? ,SEAT-TABLE>
			     <TELL " It contains ">
			     <PRINT-CONTENTS ,SEAT-TABLE>
			     <TELL ".">)>)>
	       <COND (<T? <PHONES-PLUGGED-IN?>>
		      <TELL
		       " Your headphones are plugged into their receptacle.">)>
	       <COND (<NOT <IS? ,SEATBELT ,WORN>>
		      <TELL " You aren't wearing your " Q ,SEATBELT ".">)>
	       <COND (<NOT <0? <ANDB <GET-SEAT> ,LIGHT-MASK>>>
		      <TELL " Somehow, everything seems unusually bright.">)>
	       <COND (<FIRST? ,UNDER-SEAT>
		      <TELL " Under the seat, you have ">
		      <PRINT-CONTENTS ,UNDER-SEAT>
		      <TELL ".">)>
	       <DESC-SEATBELT>
	       <ZCRLF>
	       <COND (<T? <CURRENT-NEIGHBOR>>
		      <ZCRLF>
		      <COND (<OR <AND <L? ,CURRENT-SEAT ,SEAT-D>
				      <G? <CURRENT-NEIGHBOR-SEATNUM>
					  ,SEAT-C>>
				 <AND <G? ,CURRENT-SEAT ,SEAT-C>
				      <L? <CURRENT-NEIGHBOR-SEATNUM>
					  ,SEAT-D>>>
			     <TELL "Across the aisle, you see ">)
			    (T
			     <TELL "In the next seat, you see ">)>
		      <RANDOM-PERSON-F ,M-OBJDESC <CURRENT-NEIGHBOR>>
		      <TELL ,PERIOD>)>
	       <COND (<IS? ,FLIGHT-ATTENDANT ,SEEN>
		      <TELL CR CA ,FLIGHT-ATTENDANT " is standing in the aisle"
			    ,PERIOD>)>
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
		     (<AND <VERB? EXAMINE>
			   <PRSO? INTDIR>>
		      <COND (<==? ,P-DIRECTION ,P?EAST>
			     <LOOK-FROM-SEAT 1>)
			    (<==? ,P-DIRECTION ,P?WEST>
			     <LOOK-FROM-SEAT -1>)
			    (T <>)>)
		     (T <>)>)
	      (<==? .CONTEXT ,M-EXIT>
	       <COND (<STUCK-IN-SEAT?> T)
		     (T
		      <LEAVE-SEAT T>
		      <>)>)
	      (<==? .CONTEXT ,M-ENTERING>
	       <IN-SEAT? T>
	       <COND (<AND <T? <MEAL-SQUASHED?>>
			   <==? ,CURRENT-ROW <MEAL-ROW>>
			   <==? ,CURRENT-SEAT <MEAL-SEAT>>
			   <NOT <LOC ,SAFETY-CARD-TWO>>>
		      <TELL "You are in your seat. There is no sign of your
dinner which has been slammed between the table and the seat in front of you
when it reclined. Only a tiny trickle of greenish slime betrays that the
hateful food was ever there. A small piece of laminated card has fallen from
the seat-back" ,PCR>
		      <MOVE ,SAFETY-CARD-TWO ,UNDER-SEAT>
		      <COND (<QUEUED? I-CALL-CRASH>
			     <DEQUEUE I-CALL-CRASH>
			     <QUEUE I-CALL-CRASH 3>)>
		      <QUEUE I-ATTENDANT-FLUSTERED 2>)>)
	      (<T? .CONTEXT> <>)
	      (<NOT <ON-PLANE?>>
	       <CANT-SEE-ANY ,SEAT>)
	      (<AND <TOUCHING?>
		    <HERE? SEAT>
		    <OR <N==? <NEW-SEAT> ,CURRENT-SEAT>
			<N==? <NEW-ROW> ,CURRENT-ROW>>>
	       <TELL "Kindly confine your attentions to your own seat." CR>)
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
	       <COND (<AND <==? ,HERE ,SEAT>
			   <==? ,CURRENT-ROW .NEW-ROW>
			   <==? ,CURRENT-SEAT .NEW-SEAT>>
		      <ALREADY-THERE>
		      <RETURN T .SEAT>)
		     (<STUCK-IN-SEAT?> <RETURN T .SEAT>)
		     (<T? <OCCUPIED? .NEW-SEAT .NEW-ROW>>
		      <COND (<==? .NEW-ROW ,CURRENT-ROW>
			     <TELL "You can see that the seat is already taken." CR>
			     <RETURN T .SEAT>)
			    (T
			     <LEAVE-SEAT>
			     <TELL "When you reach that row, you see that the seat of your dreams is already taken" ,PCR>
			     <PERFORM ,V?WALK-TO ,AISLE>
			     <NEW-SEAT 0>
			     <RETURN T .SEAT>)>)
		     (T
		      <COND (<==? ,HERE ,SEAT> <LEAVE-SEAT>)>
		      <SETG CURRENT-ROW .NEW-ROW>
		      <SETG CURRENT-SEAT .NEW-SEAT>
		      <SETUP-NEW-SEAT>
		      <SETG OLD-HERE <>>
		      <SETG HERE ,SEAT>
		      <GOTO ,HERE>
		      T)>)
	      (<VERB? EXAMINE LOOK-INSIDE SEARCH>
	       <COND (<AND <==? .NEW-SEAT ,CURRENT-SEAT>
			   <==? .NEW-ROW ,CURRENT-ROW>
			   <HERE? SEAT>>
		      <PERFORM ,V?LOOK>)
		     (<T? <OCCUPIED? .NEW-SEAT .NEW-ROW>>
		      <TELL "It's occupied">
		      <COND (<N==? <SET PERS <GET-SEAT .NEW-SEAT .NEW-ROW>>
				   ,PERSON-MASK>
			     <TELL " by ">
			     <RANDOM-PERSON-F ,M-OBJDESC .PERS>)>
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
	      (<VERB? LIE-DOWN>
	       <PUTP ,RANDOM-OBJECT ,P?PSEUDO-TABLE ,RECLINE-BUTTON>
	       <PERFORM ,V?PUSH ,RANDOM-OBJECT>
	       T)
	      (<VERB? LOOK-UNDER>
	       <COND (<==? .NEW-SEAT ,CURRENT-SEAT>
		      <PERFORM ,V?LOOK-ON ,UNDER-SEAT>)
		     (T
		      <TELL "There's nothing special under that seat." CR>)>)>>

<DEFINE I-ATTENDANT-FLUSTERED ()
  <COND (<AND <==? ,CURRENT-ROW <MEAL-ROW>>
	      <==? ,CURRENT-SEAT <MEAL-SEAT>>
	      <HERE? SEAT>>
	 <TELL CR
	       "A flight attendant comes up to you, glowering angrily. Then she
notices that your food has gone. \"Oh... er...\" she mutters in confusion.
\"Ah... my colleague must have taken your plate. Hope you enjoyed your meal, "
	       <STR-SIR-OR-MAAM> ".\" She looks as if she is almost tempted to
be polite, except that she doesn't know how, and walks away." CR>)>>

<DEFINE I-CALL-CRASH ()
  <TELL CR
	"The flight attendant reappears. \"There is a telephone call for you, "
	<STR-SIR-OR-MAAM> ",\" she says, and walks away." CR>
  <AIRPHONE-RINGING? T>
  <QUEUE I-CRASH 10>>

<DEFINE I-CRASH ()
  <COND (<T? <AIRPHONE-RINGING?>>
	 <I-REALLY-CRASH>)
	(T
	 <FLIGHT-ATTENDANT-APPEARS>
	 <TELL CR CTHE ,FLIGHT-ATTENDANT " appears. \"If you could ">
	 <COND (<HERE? SEAT> <TELL "remain in">)
	       (T <TELL "return to">)>
	 <TELL " your
seat, " <STR-SIR-OR-MAAM> ", we'd appreciate it. We need to talk to all the
passengers about something.\"" CR CR CTHE ,FLIGHT-ATTENDANT " seems strangely
reluctant to leave." CR>
	 <QUEUE I-REALLY-CRASH 10>)>
  T>

<DEFINE I-REALLY-CRASH ()
  <TELL CR
	"A voice comes over the P.A. \"Uh, this is your, uh, Captain speaking.
At this time, we seem to be in, uh, a crash situation. The crew will soon
distribute aerial deceleration devices to themselves, then deplane.
Please remain, uh, calm.\" You (and the rest of the passengers)
eventually crash into the Zalagasan jungle, where you die.">
  <JIGS-UP>>

<DEFINE LEAVE-SEAT LEAVE ("OPT" (NOMEAL? <>) "AUX" NEIGHBOR)
	<COND (<F? <IN-SEAT?>>
	       <RETURN T .LEAVE>)>
	<IN-SEAT? <>>
	<COND (<IS? ,SEATBELT ,WORN>
	       <UNMAKE ,SEATBELT ,WORN>
	       <MOVE ,SEATBELT ,SEAT>)>
	<COND (<OR <IS? ,PHONES ,WORN>
		   <META-IN? ,PHONES ,PLAYER>>
	       <TELL "You neatly tuck your " D ,PHONES " into "
		     THE ,SEAT-POCKET ,PCR>
	       <UNMAKE ,PHONES ,WORN>
	       <PHONES-PLUGGED-IN? <>>
	       <MOVE ,PHONES ,SEAT-POCKET>)>
	<SETG OLD-HERE <>>
	<LAST-ROW ,CURRENT-ROW>
	<LAST-SEAT ,CURRENT-SEAT>
	<COND (<T? .NOMEAL?> T)
	      (<AND <T? <AIR-MEAL-STATE>>
		    <IN? ,AIRLINE-MEAL ,SEAT-TABLE>>
	       <TELL "Gingerly edging past your dish of virulent food, you
get out of your seat" ,PCR>)
	      (<OR <AND <==? ,CURRENT-SEAT ,SEAT-B>
			<T? <SET NEIGHBOR <GET-SEAT ,SEAT-C>>>>
		   <AND <==? ,CURRENT-SEAT ,SEAT-E>
			<T? <SET NEIGHBOR <GET-SEAT ,SEAT-D>>>>>
	       <COND (<PROB 20>
		      <TELL "You stumble over your neighbour's feet as you leave your seat, causing some irritated mutterings" ,PCR>)>)>>

<CONSTANT NORMAL-SEAT
	  <PLTABLE SEATBELT SEAT-POCKET UNDER-SEAT SEAT-TABLE RECEPTACLE>>
<CONSTANT NORMAL-SEAT-POCKET
	  <PLTABLE AIRLINE-MAGAZINE SAFETY-CARD PHONES SAFETY-CARD-TWO>>
<CONSTANT NORMAL-SEAT-TABLE
	  <PLTABLE AIRLINE-MEAL>>

<OBJECT SEAT-TABLE
	(LOC SEAT)
	(DESC "seat table")
	(SYNONYM TABLE)
	(ADJECTIVE SEAT)
	(FLAGS NODESC)
	(CAPACITY 3)
	(ACTION SEAT-TABLE-F)>

<DEFINE SEAT-TABLE-F ()
  <COND (<IS? ,SEAT-TABLE ,SURFACE>
	 <COND (<VERB? EXAMINE>
		<TELL "It's a seat table. It contains ">
		<PRINT-CONTENTS ,PRSO>
		<TELL ,PERIOD>)
	       (<VERB? OPEN LOWER UNFOLD>
		<TELL "It already is." CR>)
	       (<VERB? CLOSE RAISE FOLD>
		<COND (<IN? ,AIRLINE-MEAL ,PRSO>
		       <TELL "As you grasp the edge of " THEO " to execute
this cunning plan, something in your food definitely twitches. You recoil
in horror." CR>)
		      (T
		       <UNMAKE ,PRSO ,SURFACE>
		       <TABLE-STATE 0>
		       <COND (<T? <POLICE-AREA ,SEAT-TABLE <> ,UNDER-SEAT>>
			      <TELL "Cleverly enough, you've managed to spill
the contents of " THEO " under the seat." CR>)
			     (T
			      <TELL "Closed." CR>)>)>)>)
	(<VERB? OPEN LOWER UNFOLD>
	 <COND (<AND <T? <MEAL-SQUASHED?>>
		     <==? ,CURRENT-ROW <MEAL-ROW>>
		     <==? ,CURRENT-SEAT <MEAL-SEAT>>>
		<TELL "Your hand seems to stop of its own accord when
it encounters the emanations from behind " THEO ,PERIOD>)
	       (T
		<TELL "Opened." CR>
		<MAKE ,SEAT-TABLE ,SURFACE>
		<TABLE-STATE 1>)>)
	(<VERB? CLOSE RAISE FOLD>
	 <TELL "It already is." CR>)>>

<DEFINE SETUP-NEW-SEAT ("OPT" (FORCE? <>))
  <SETUP-NEIGHBOR ,CURRENT-SEAT>
  <NEW-ROW 0>
  <NEW-SEAT 0>
  <COND (<AND <==? ,CURRENT-ROW <LAST-ROW>>
	      <==? ,CURRENT-SEAT <LAST-SEAT>>
	      <NOT .FORCE?>>
	 ; "Just returned to previous seat, so OK"
	 T)
	(T
	 <PHONES-PLUGGED-IN? <>>
	 <COND (<NOT <META-IN? ,SAFETY-CARD-TWO ,PLAYER>>
		<ZREMOVE ,SAFETY-CARD-TWO>)>
	 <COND (<NOT <META-IN? ,AIRLINE-MAGAZINE ,PLAYER>>
		<MOVE ,AIRLINE-MAGAZINE ,SEAT-POCKET>)>
	 <COND (<NOT <META-IN? ,SAFETY-CARD ,PLAYER>>
		<MOVE ,SAFETY-CARD ,SEAT-POCKET>)>
	 <COND (<IN? ,AIRLINE-MEAL ,SEAT-TABLE>
		<ZREMOVE ,AIRLINE-MEAL>)>
	 <COND (<TABLE-STATE>
		<MAKE ,SEAT-TABLE ,SURFACE>)
	       (T
		<UNMAKE ,SEAT-TABLE ,SURFACE>)>
	 <COND (<G? <+ <POLICE-AREA ,SEAT ,NORMAL-SEAT>
		       <POLICE-AREA ,SEAT-POCKET ,NORMAL-SEAT-POCKET>
		       <POLICE-AREA ,UNDER-SEAT <>>
		       <POLICE-AREA ,SEAT-TABLE ,NORMAL-SEAT-TABLE>> 0>
		<COND (<NOT .FORCE?>
		       <FLIGHT-ATTENDANT-APPEARS>
		       <TELL "Just as you're settling in, a flustered flight attendant rushes up to you. \"You left your personal belongings in your old seat, " <STR-SIR-OR-MAAM> "! Please don't let it happen again.\"" CR CR>
		       <FLIGHT-ATTENDANT-LEAVES>)>)>
	 <COND (<T? <AIR-MEAL-STATE>>
		<MOVE ,AIRLINE-MEAL ,SEAT-TABLE>)>)>>

<DEFINE STR-SIR-OR-MAAM ("OPT" (CAPS <>))
  <COND (<T? .CAPS>
	 <COND (<T? ,SEX> "Ma'am")
	       (T "Sir")>)
	(,SEX "ma'am")
	(T "sir")>>

"Get personal belongings out of seat, and give them to steward for return."

<DEFINE POLICE-AREA (OBJ TBL "OPT" (WHERE ,PLAYER)
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
			<COND (.WHERE <MOVE .NOBJ .WHERE>)>
			<SET NOBJ .OBJ>)
		       (T
			<SET NOBJ <NEXT? .NOBJ>>)>
		 <COND (<NOT .NOBJ> <RETURN>)>>)>
	.N>



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

<VOC "LAVATORY" OBJECT>
<VOC "LAV" OBJECT>
<VOC "BATHROOM" OBJECT>

<DEFINE MATCH-SEAT-NAME MATCH (ADJ NAM ARG "AUX" ROW SNUM
			       (NMVEC <ZREST ,SEAT-LETTER-NAMES 2>)
			       (NMLEN <ZGET ,SEAT-LETTER-NAMES 0>)
			       TAB)
  <COND (<AND <F? .ADJ>
	      <F? .NAM>>
	 <>)
	(<AND <NOT <HERE? SEAT AISLE>>
	      <==? .NAM ,W?BUTTON>>
	 ,FATAL-VALUE)
	(<AND <F? .ADJ>
	      <==? .NAM ,W?BUTTON>>
	 <TELL "Which button do you mean, the recline button, the call button, or the light button?" CR>
	 <SETG P-ACLAUSE <COND (<==? ,P-TABLE ,P-PRSO> ,P-NC1)
			       (T ,P-NC2)>>
	 <SETG P-ANAM ,P-NAM>
	 <ORPHAN <> <>>
	 <SETG P-OFLAG T>
	 ,FATAL-VALUE)
	(<EQUAL? .NAM ,W?PHONE ,W?TELEPHONE ,W?REAR ,W?LOBBY>
	 ,LAV-LOBBY)
	(<EQUAL? .NAM ,W?LAVATORY ,W?BATHROOM ,W?LAV>
	 ,LAV-LOBBY)
	(<AND <F? .ADJ>
	      <EQUAL? .NAM ,W?AISLE ,W?ROW>>
	 ,AISLE)
	(<NOT-SEAT-NAME? .ADJ .NAM>
	 ; "Random person/object"
	 <REPEAT ((LEN <ZGET .ARG 0>) (VEC <ZREST .ARG 2>)
		  (COULD-BE-PERSON? <>) TMP (WIN? <>) ONAM
		  PPROW)
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
			(<AND <==? <SET PPROW <GETB ,PERSON-ROWS <- .TMP 1>>>
				   ,CURRENT-ROW>
			      <HERE? AISLE>>
			 <SET COULD-BE-PERSON? .TMP>)
			(<AND <HERE? SEAT>
			      <==? .PPROW <- ,CURRENT-ROW 1>>
			      <==? <SEAT-PERSON ,CURRENT-SEAT
						<- ,CURRENT-ROW 1>>
				   .TMP>>
			 <SET COULD-BE-PERSON? .TMP>)
			(<F? .COULD-BE-PERSON?>
			 ; "Allow search to continue, since there may be
			    other matches later in the vector."
			 <SET COULD-BE-PERSON? 255>)>)>
	   <COND
	    (<L? <SET LEN <- .LEN 3>> 3>
	     <COND
	      (<AND <T? .COULD-BE-PERSON?>
		    <N==? .COULD-BE-PERSON? 255>>
	       <PUTP ,RANDOM-PERSON ,P?PSEUDO-TABLE .COULD-BE-PERSON?>
	       <COND (<GET-SEX .COULD-BE-PERSON?>
		      <MAKE ,RANDOM-PERSON ,FEMALE>)
		     (T
		      <UNMAKE ,RANDOM-PERSON ,FEMALE>)>
	       <THIS-IS-IT ,RANDOM-PERSON>
	       <RETURN ,RANDOM-PERSON .MATCH>)
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
				 ,SEAT-B)
				(<==? .NAM ,W?C>
				 ,SEAT-C)
				(<==? .NAM ,W?D>
				 ,SEAT-D)
				(<==? .NAM ,W?E>
				 ,SEAT-E)>>
		,SEAT)>)
	(<OR <==? .NAM ,W?SEAT>
	     <F? .NAM>>
	 <COND (<N==? ,HERE ,SEAT>
		<NEW-ROW <LAST-ROW>>
		<NEW-SEAT <LAST-SEAT>>)
	       (T
		<NEW-ROW ,CURRENT-ROW>
		<NEW-SEAT ,CURRENT-SEAT>)>
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
	 <SET SNUM <+ <MOD ,P-SEAT-NUMBER:FIX 4> 1>>
	 <COND (<OR <L? .ROW 1>
		    <G? .ROW ,AISLE-COUNT>>
		,FATAL-VALUE)
	       (T
		<NEW-ROW .ROW>
		<NEW-SEAT .SNUM>
		,SEAT)>)>>

<DEFINE ON-PLANE? ()
  <COND (<IS? ,HERE ,IN-AIRPLANE> T)
	(T <>)>>

<OBJECT GALLEY
	(LOC ROOMS)
	(SOUTH TO AISLE)
	(DESC "Galley")
	(SYNONYM GALLEY)
	(LDESC "This is a galley. The flight attendants turn and stare at you coldly.")
	(GLOBAL FLIGHT-ATTENDANT SEATBELT-LIGHT)
	(THINGS SEAT-PSEUDO-VEC)
	(FLAGS IN-AIRPLANE LOCATION LIGHTED INDOORS)
	(ACTION GALLEY-F)>

<DEFINE GALLEY-F ("OPT" (CONTEXT <>))
  <COND (<==? .CONTEXT ,M-ENTERING>
	 <SETG CURRENT-ROW 1>
	 <>)
	(T <>)>>

<OBJECT LAV-LOBBY
	(LOC ROOMS)
	(NORTH TO AISLE)
	(SOUTH PER LAV-ENGAGED)
	(EAST SORRY "The hatch is closed.")
	(DESC "Rear of Aeroplane")
	(FLAGS IN-AIRPLANE LOCATION LIGHTED INDOORS)
	(THINGS SEAT-PSEUDO-VEC)
	(HEAR 0)
	(GLOBAL LAV-DOOR FLIGHT-ATTENDANT SEATBELT-LIGHT)
	(ACTION LAV-LOBBY-F)>

<DEFINE LAV-LOBBY-F LL ("OPT" (CONTEXT <>) "AUX" (HO <HATCH-OPEN?>))
  <COND (<==? .CONTEXT ,M-LOOK>
	 <TELL "There is a telephone here, with a slot for credit cards. The
emergency hatch lies to the east, and the lavatory is south." CR>
	 <COND (<IS? ,FLIGHT-ATTENDANT ,SEEN>
		<TELL CR CA ,FLIGHT-ATTENDANT " is waiting here" ,PERIOD>)>)
	(<==? .CONTEXT ,M-ENTERING>
	 <SETG CURRENT-ROW ,AISLE-COUNT>
	 <COND (<AND <VERB? WALK-TO>
		     <PRSO? LAV-LOBBY>
		     <PRSO-NOUN-USED? ,W?LAVATORY ,W?LAV ,W?BATHROOM>>
		<LAV-ENGAGED>
		<ZCRLF>)>
	 <>)
	(<AND <==? .CONTEXT ,M-ENTERED>
	      <T? <AIRPHONE-RINGING?>>>
	 <TELL CR "The phone is ringing." CR>
	 <THIS-IS-IT ,AIRPHONE>
	 <>)
	(<==? .CONTEXT ,M-BEG>
	 <COND (<G=? .HO 2>
		<COND (<OR <VERB? LEAP EXIT>
			   <AND <VERB? WALK>
				<EQUAL? ,P-WALK-DIR ,P?EAST ,P?OUT>>
			   <AND <ENTERING?>
				<RAND-PRSO? ,HATCH-OBJECT>>>
		       <TELL "No." CR>)
		      (<VERB? WAIT>
		       <TELL "Time passes." CR>
		       <SET HO 3>
		       T)
		      (<GAME-VERB?>
		       <RETURN <> .LL>)
		      (T
		       <TELL "The rush of air exiting the cabin keeps you from ">
		       <COND (<OR <N==? ,WINNER ,PLAYER>
				  <VERB? ASK-FOR ASK-ABOUT SAY>>
			      <TELL "being heard">)
			     (T
			      <TELL "moving">)>
		       <TELL ,PERIOD>)>
		<COND (<G=? <SET HO <+ .HO 1>> 4>
		       <ZCRLF>
		       <ZBUFOUT <>>
		       <TELL ">">
		       <PRINTC <INPUT 1>>
		       <ZCRLF>
		       <ZBUFOUT T>
		       <TELL
"Too late to say anything now. The slipstream has
pulled you out of the aircraft and you think you are falling through the air."
				CR>
		       <COND (<IN? ,NERD ,LAV-LOBBY>
			      <ZCRLF>
			      <ZREMOVE ,NERD>
			      <NERD-SAYS-WAIT>)>
		       <HATCH-OPEN? <SET HO 0>>
		       <COND (<AND <IN? ,CHUTE ,PLAYER>
				   <IS? ,CHUTE ,WORN>>
			      <GO-OUTSIDE-PLANE>)
			     (T
			      <TO-IN-AIR>)>)>
		<HATCH-OPEN? .HO>
		T)>)
	(<==? .CONTEXT ,M-EXIT>
	 <COND (<IS? ,AIRPHONE ,TOUCHED>
		<TELL "You hang up the phone">
		<COND (<IN? ,BEEZER ,AIRPHONE>
		       <MOVE ,BEEZER ,PLAYER>
		       <TELL " and take your " D ,BEEZER
			     " out">)>
		<TELL ,PERIOD>
		<MAKE ,AIRPHONE ,OPENED>
		<UNMAKE ,AIRPHONE ,TOUCHED>
		<>)
	       (T <>)>)
	(<T? .CONTEXT> <>)
	(<VERB? REPLY>
	 <PERFORM ,V?WALK-TO ,LAV-LOBBY>)
	(<AND <VERB? WALK-TO>
	      <HERE? LAV-LOBBY>
	      <PRSO-NOUN-USED? ,W?LAVATORY ,W?BATHROOM ,W?LAV>>
	 <DO-WALK ,P?SOUTH>
	 T)
	(T <>)>>

<CONSTANT BATHROOM-LOCKED
	  <PLTABLE "the sound of tuneful bassoon-playing"
		   "the sound of frantic typing"
		   "what could be a pygmy hog giving birth to an exceptionally
large litter"
		   "a champagne cork popping">>

<DEFINE LAV-ENGAGED ()
  <TELL "The lavatory is engaged. From within, you hear "
	PONE ,BATHROOM-LOCKED ,PERIOD>
  <>>

<OBJECT LAV-DOOR
	(DESC "lavatory door")
	(LOC LAV-LOBBY)
	(FLAGS OPENABLE LOCKED NODESC)
	(SYNONYM DOOR)
	(ADJECTIVE LAVATORY BATHROOM)
	(ACTION LAV-DOOR-F)>

<DEFINE LAV-DOOR-F ()
  <COND (<THIS-PRSI?>
	 <>)
	(<VERB? OPEN>
	 <COND (<IS? ,LAV-DOOR ,LOCKED>
		<LAV-ENGAGED>
		T)
	       (T
		<>)>)
	(<VERB? KNOCK>
	 <TELL "There is no response." CR>)
	(<VERB? LOCK>
	 <ITS-ALREADY "locked">)
	(<VERB? UNLOCK>
	 <TELL "You can unlock the door only from the inside." CR>)
	(T <>)>>


<OBJECT RECEPTACLE
	(LOC SEAT)
	(DESC "headphone socket")
	(FLAGS NODESC CONTAINER OPENED OPENABLE)
	(SYNONYM RECEPTACLE OUTLET JACK SOCKET)
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
" are plugged in to the receptacle." CR>)
		      (T
		       <TELL "The receptacle is labelled HEADPHONES." CR>)>
		T)
	       (<VERB? OPEN CLOSE>
		<TELL CTHEO " has no door." CR>
		T)
	       (T <>)>>

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
		<TELL "You plug in " THE ,PHONES ,PERIOD>
		<MAKE ,RECEPTACLE ,SEEN>
		T)>>

<OBJECT PHONES
	(LOC SEAT-POCKET)
	(SDESC SDESC-PHONES)
	(FLAGS TAKEABLE CLOTHING)
	(SYNONYM BULGE HEADPHONE PAIR SET EARPHONE EARPHONES PHONES PLUG)
	(ADJECTIVE HEAD EAR)
	(SIZE 3)
	(ACTION PHONES-F)>

<DEFINE SDESC-PHONES ()
  <COND (<NOT <IS? ,PHONES ,PLURAL>> <TELL "bulge">)
	(T <TELL "headphones">)>>

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
		<MAKE ,PRSO ,PLURAL>
		<TELL "It's an ordinary set of airline headphones, ">
		<COND (.PLUGGED-IN?
		       <TELL "plugged into ">)
		      (T
		       <TELL "with a plug that fits ">)>
		<TELL "a receptacle in " THE ,SEAT ,PERIOD>
		T)
	       (<VERB? WEAR>
		<COND (<IS? ,PRSO ,WORN>
		       <>)
		      (<NOT <IN? ,PRSO ,PLAYER>>
		       <>)
		      (T
		       <MAKE ,PRSO ,WORN>
		       <TUNE-TIMER 0>
		       <TELL "You put on " THEO>
		       <COND (.PLUGGED-IN?
			      <TELL ", and hear ">
			      <SAY-MUZAK>)>
		       <TELL ,PERIOD>
		       T)>)
	       (<VERB? LISTEN>
		<COND (<AND .PLUGGED-IN?
			    <IS? ,PHONES ,WORN>>
		       <TELL "You hear ">
		       <SAY-MUZAK>
		       <TELL ,PERIOD>
		       T)
		      (T
		       <TELL ,DONT "hear anything unusual." CR>
		       T)>)
	       (<VERB? UNPLUG>
		<UNPLUG-PHONES>
		T)
	       (<VERB? TAKE>
		<MAKE ,PHONES ,PLURAL>
		<COND (<PRSI? RECEPTACLE>
		       <UNPLUG-PHONES>)
		      (T <>)>)
	       (<VERB? PLUG REPLUG>
		<PLUG-IN-PHONES>
		T)
	       (T
		<>)>>

<DEFINE I-PHONES PHONES ("AUX" X Y)
	 <SET X <TUNE-TIMER>>
	 <COND (<G? <SET X <+ .X 1>> 3>
		<SET X 0>
		<NEXT-TOON>
		<COND (<AND <IN? ,PHONES ,PLAYER>
		     	    <IS? ,PHONES ,WORN>
		     	    <T? <PHONES-PLUGGED-IN?>>>
		       <TELL CR "You hear ">
		       <SAY-MUZAK>
		       <TELL " playing on the headphones." CR>)>)>
	 <TUNE-TIMER .X>	 
	 <RETURN <> .PHONES>>


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

<DEFINE FLIGHT-ATTENDANT-APPEARS ("OPT" (SEX 0) "AUX" (FEMALE? <>))
	<ATTENDANT-WORKING? T>
	<MAKE ,FLIGHT-ATTENDANT ,SEEN>
	<ATTENDANT-AT-ROW ,CURRENT-ROW>
	<COND (<0? .SEX>
	       <SET FEMALE? <PROB 50>>)
	      (<==? .SEX 1>
	       <SET FEMALE? T>)>
	<SET-SEX ,FLIGHT-ATTENDANT .FEMALE?
		 ,W?STEWARDESS ,W?STEWARD>
	<COND (.FEMALE?
	       <FLIGHT-ATTENDANT-HE/SHE "She">
	       <FLIGHT-ATTENDANT-HIM/HER "her">)
	      (T
	       <FLIGHT-ATTENDANT-HE/SHE "He">
	       <FLIGHT-ATTENDANT-HIM/HER "him">)>
	<QUEUE I-LOSE-ATTENDANT -1>
	<ATTENDANT-WORKING? T>>

<DEFINE I-LOSE-ATTENDANT ()
  <COND (<T? <ATTENDANT-WORKING?>>
	 <ATTENDANT-WORKING? <>>
	 <>)
	(<IS? ,FLIGHT-ATTENDANT ,SEEN>
	 <COND (<==? ,CURRENT-ROW <ATTENDANT-AT-ROW>>
		<TELL CR "The attendant leaves." CR>)>
	 <FLIGHT-ATTENDANT-LEAVES>)>>

<DEFINE I-FORCE-RETURN ("AUX" (VAL <>))
  <COND (<AND <T? <MEAL-HERE?>>
	      <F? <MEAL-SQUASHED?>>>
	 <COND (<OR <NOT <HERE? SEAT>>
		    <N==? ,CURRENT-ROW <MEAL-ROW>>
		    <N==? ,CURRENT-SEAT <MEAL-SEAT>>>
		<SET VAL T>
		<TELL CR "The attendant comes up to you. \"Please sit down and
finish your delicious Zalagasan dinner at this time, " <STR-SIR-OR-MAAM>
		      ".\" She escorts you to your seat.">
		<COND (<MIND-READ?>
		       <TELL " You have already been through all the
mind-reading stuff and seen this hateful hockey puck in action, so you obey
without question.">)
		      (T
		       <MIND-READ? T>
		       <TELL " As you sit down, you read her mind. It says,
\"I can read your mind, buster. Cut the nonsense and eat your delicious
food.\"">)>
		<ZCRLF>
		<NEW-SEAT ,SEAT-B>
		<NEW-ROW 3>
		<GOTO ,SEAT>)>)>
  <COND (<F? <MEAL-SQUASHED?>>
	 <QUEUE I-FORCE-RETURN 10>)>>

<DEFINE FLIGHT-ATTENDANT-LEAVES ()
	<LOSER-CANT-LEAVE-SEAT? <>>
	<UNMAKE ,FLIGHT-ATTENDANT ,SEEN>
	<ATTENDANT-AT-ROW 0>
	<DEQUEUE I-LOSE-ATTENDANT>>

<DEFINE ASK-FOR-STINGLAI ()
  <COND (<IS? ,CHUTE ,TOUCHED>
	 <TELL "\"Sorry, that's the only spare we have. We carry only enough
of them for the crew, and luckily the navigator was sick today.\"" CR>)
	(<T? <CRASH-COMING?>>
	 <MAKE ,CHUTE ,TOUCHED>
	 <TELL "\"Oh! You're one of us,\"
says the attendant, smiling. \"If I'd known, I'd never have given you the
Zalagasan Special. Awful, wasn't it?\"|
|
She hands you a parachute and helps you strap it to your back.
\"You go first,\" she smiles, \"I just have to make some pointlessly
reassuring noises to the animals back there.\" She leaves." CR>
	 <ATTENDANT-WORKING? <>>
	 <FLIGHT-ATTENDANT-LEAVES>
	 <MOVE ,CHUTE ,PLAYER>
	 <MAKE ,CHUTE ,WORN>)
	(T
	 <TELL "\"There's no need for that
now. We've never had a crash in this " D ,PLANE ".\"" CR>)>>

<DEFINE FLIGHT-ATTENDANT-F FAF ("OPT" (CONTEXT <>)"AUX" LOSERS-ROW)
	<COND (<VERB? FOLLOW>
	       <TELL "The average " D ,PRSO " is a very sensitive, delicate
creature, and might start to feel uncomfortable if a passenger started
following him (or her) around. Besides, you need only ring for one and your
slightest whim will be attended to." CR>)
	      (<AND <HERE? GALLEY>
		    <F? <CRASH-COMING?>>>
	       <TELL CTHE ,FLIGHT-ATTENDANT " hasn't warmed up any. \"I
don't know what you have in mind, but I don't want any part of it. Maybe
you'd better get back to your seat.\"" CR>
	       <PCLEAR>
	       ,FATAL-VALUE)
	      (<OR <IS? ,FLIGHT-ATTENDANT ,SEEN>
		   <HERE? GALLEY>>
	       <ATTENDANT-WORKING? T>
	       <COND (<==? .CONTEXT ,M-WINNER>
		      <COND (<VERB? STINGLAI>
			     <COND (<OR <PRSO? CHUTE>
					<RAND-PRSO? ,FAKE-CHUTE-OBJECT>>
				    <COND (<PRSO-NOUN-USED? ,W?KA\'ABI>
					   <ASK-FOR-STINGLAI>
					   <RETURN ,FATAL-VALUE .FAF>)>)>
			     <RETURN <> .FAF>)
			    (<VERB? HELLO>
			     <COND (<AND <==? ,P-PRSA-WORD ,W?NO>
					 <0?
					  <ATTENDANT-MENTIONED-REGULATIONS?>>>
				    <PUTP ,RANDOM-OBJECT ,P?PSEUDO-TABLE
					  ,REGULATIONS-OBJECT>
				    <PERFORM-WITH-PLAYER
				     ,V?ASK-ABOUT ,FLIGHT-ATTENDANT
				     ,RANDOM-OBJECT>
				    <RETURN ,FATAL-VALUE .FAF>)
				   (T
				    <TELL CTHE ,WINNER " nods briskly." CR>)>)
			    (<VERB? TAKE EAT TAKE-OFF>
			     <PERFORM-WITH-PLAYER ,V?GIVE ,PRSO ,WINNER>)
			    (<VERB? WHAT>
			     <PERFORM-WITH-PLAYER ,V?ASK-ABOUT ,WINNER ,PRSO>)
			    (<VERB? SGIVE>
			     <PERFORM-WITH-PLAYER ,V?ASK-ABOUT ,WINNER ,PRSI>)
			    (<VERB? GIVE>
			     <PERFORM-WITH-PLAYER ,V?ASK-ABOUT
						  ,WINNER ,PRSO>)
			    (T
			     <TELL CTHE ,WINNER " seems uninterested in doing
that." CR>)>
		      ,FATAL-VALUE)
		     (<T? .CONTEXT> <>)
		     (<THIS-PRSI?>
		      <COND (<VERB? GIVE SHOW>
			     <COND (<PRSO? AIRLINE-MEAL>
				    <TELL "\"" ,DONT "honestly expect me to
touch that stuff, " <STR-SIR-OR-MAAM> "?\"" CR>
				    <CHECK-REGULATIONS>
				    T)
				   (<VERB? SHOW>
				    <TELL "\"Yes, that's very nice.\"" CR>)
				   (<T? <MEAL-HERE?>>
				    <TELL "\"Really, " <STR-SIR-OR-MAAM>
					  ", you can't think you have anything
valuable enough to get me to take that thing away.\"" CR>
				    <CHECK-REGULATIONS>
				    T)
				   (T
				    <TELL "\"I'm sorry, but we're not permitted
to accept gifts from passengers.\"" CR>)>)>)
		     (<THIS-PRSO?>
		      <COND (<VERB? TELL>
			     <>)
			    (<VERB? EXAMINE>
			     <TELL "The flight attendants hired by Air
Zalagasa bear a more than passing resemblance, at least mentally, to
hockey pucks -- they're very compact, as it were. Physically, they're quite
unremarkable." CR>)
			    (<VERB? ASK-ABOUT ASK-FOR>
			     <COND (<RAND-PRSI? ,REGULATIONS-OBJECT>
				    <ATTENDANT-MENTIONED-REGULATIONS? 0>
				    <TELL
"\"The ZAA clearly states that all tables must be in their stowed position
for landing. Clearly, your table cannot be stowed (except of course by
brute force, which is prohibited) while your food is still in place.
Union rules do not permit me to remove a full plate. Therefore unless
you eat your food, I shall not be able to remove your plate, your table
will not be stowed properly, we shall not be able to land, and we shall
have to fly round and round until we run out of fuel, crash, and die.
Thank you for your attention. Sit back, relax and enjoy the flight.\"|
|
The attendant goes away." CR>
				    <FLIGHT-ATTENDANT-LEAVES>)
				   (<OR <PRSI? CHUTE>
					<RAND-PRSI? ,FAKE-CHUTE-OBJECT>>
				    <COND (<AND <PRSI-NOUN-USED? ,W?KA\'ABI>
						<PRSI-ADJ-USED? ,W?STINGLAI>>
					   <ASK-FOR-STINGLAI>)
					  (<AND <PRSO-NOUN-USED? ,W?KA\'ABI>
						<PRSO-ADJ-USED? ,W?STINGLAI>>
					   <ASK-FOR-STINGLAI>)
					  (T
					   <TELL "\"I'm awfully sorry, "
						 <STR-SIR-OR-MAAM>
						 ", but I don't know ">
					   <COND
					    (<PRSI-NOUN-USED? ,W?PARACHUTE
							      ,W?CHUTE>
					     <TELL "the word '"
						   WORD <ZGET ,P-NAMW 1> "'">)
					    (T
					     <TELL "what you're talking about">)>
					   <TELL ".\"" CR>)>)
				   (<PRSI? NERD>
				    <TELL "\"I don't know whom you're talking
about.\"" CR>)
				   (<BUTTON? ,PRSI>
				    <TELL "\"If you have any problems, simply
report them to our engineering office when you deplane.\"" CR>)
				   (T
				    <TELL "\"I'm sorry, " <STR-SIR-OR-MAAM>
					  ", but I'm not authorised to say anything about that.\"" CR>)>)>)>)
	      (<VERB? RING-FOR>
	       <COND (<NOT <EQUAL? ,HERE ,SEAT>>
		      <TELL ,CANT "find anything to summon one with."
			    CR>)
		     (T
		      <PUTP ,RANDOM-OBJECT ,P?PSEUDO-TABLE ,CALL-BUTTON>
		      <TELL "You press " THE ,RANDOM-OBJECT ,PERIOD>
		      <PERFORM ,V?PUSH ,RANDOM-OBJECT>)>)
	      (T
	       <TELL "There doesn't seem to be a " D ,FLIGHT-ATTENDANT
		     " nearby. Perhaps you should ring for one." CR>
	       <COND (<VERB? TELL>
		      <PCLEAR>
		      ,FATAL-VALUE)
		     (T T)>)>>


;<DEFINE I-RETURN-TO-SEAT IRTS ("OPT" (N 0))
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
	(T
	 <COND
	  (<N==? ,HERE ,SEAT>
	   <TELL CR CA ,FLIGHT-ATTENDANT>
	   <TELL " hurries up to you.">
	   <TELL " \"" ,THIS-IS "really unforgivable, " <STR-SIR-OR-MAAM>
		 ".\" You find yourself being frog-marched back to your seat,
where you are unceremoniously dumped" ,PCR>
	   <COND (<AND <T? <MEAL-HERE?>>
		       <F? <MEAL-EATEN?>>>
		  <TELL "\"Besides, you haven't eaten your delicious Zalagasan
dinner yet.\"" CR>)>
	   <NEW-ROW <LAST-ROW>>
	   <NEW-SEAT <LAST-SEAT>>
	   <PERFORM ,V?WALK-TO ,SEAT>
	   <DISPLAY-PLACE>
	   T)
	  (T
	   <UNMAKE ,SEATBELT-LIGHT ,LIGHTED>
	   <TELL CR "The FASTEN SEAT BELT light overhead blinks off." CR>
	   T)>
	 <COND (<T? <RETURN-TO-SEAT-ROUTINE>>
		<ZAPPLY <RETURN-TO-SEAT-ROUTINE>>)>
	 T)>>

;<DEFINE ANNOUNCE-RETURN-TO-SEAT ()
  <TELL CR "\"Ladies and gentlemen, the captain has turned on the FASTEN SEAT BELT sign. For your own safety and comfort, please return to your seats and keep your seat belts fastened until we turn it off. Thank you.\"" CR>>

;<DEFINE FORCE-RETURN-TO-SEAT (START "OPT" (END 5) (ROUTINE <>) "AUX" CLOCKER)
  <COND (<SET CLOCKER <QUEUED? I-RETURN-TO-SEAT>>
	 <COND (<L? .START <ZGET .CLOCKER ,C-TICK>>
		<ZPUT .CLOCKER ,C-TICK .START>)>)
	(<SET CLOCKER <QUEUED? I-DIDNT-RETURN-TO-SEAT>>
	 ; "Too late, loser"
	 <COND (<L? .END <ZGET .CLOCKER ,C-TICK>>
		<ZPUT .CLOCKER ,C-TICK .START>)>)
	(T
	 <QUEUE I-RETURN-TO-SEAT .START>)>
  <RETURN-TO-SEAT-ROUTINE .ROUTINE>
  <RETURN-TO-SEAT-WAIT .END>>

<OBJECT AIRLINE-MEAL
	(DESC "noisome stew")
	(SYNONYM SPECIALTY FOOD MEAL STEW DINNER LLAMA BOWL PLATE)
	(ADJECTIVE ZALAGASAN LLAMA MY NOISOME)
	(GENERIC GENERIC-FOOD-F)
	(ACTION AIRLINE-MEAL-F)>

<VOC "CHICKEN">
<VOC "KIEV">
<VOC "FILET">

<DEFINE AIRLINE-MEAL-F AMF ()
  <COND (<THIS-PRSO?>
	 <COND (<OR <VERB? THROW DROP EMPTY>
		    <HURTING?>>
		<TELL "Realising the danger that some of the hateful food
might splash back on yourself, you think better of it." CR>)
	       (<VERB? EAT>
		<TELL "You hold your breath and cram the disgusting food into
your mouth. It writhes distinctly on the way down. You hear groans of disgust
and disbelief from your fellow passengers." CR>
		<MEAL-EATEN? T>
		<ZREMOVE AIRLINE-MEAL>
		<QUEUE I-ATE-FOOD 2>
		T)
	       (<VERB? EXAMINE LOOK-INSIDE>
		<COND (<AND <NOUN-USED? ,W?BOWL ,W?PLATE>
			    <NOT <VERB? LOOK-INSIDE>>>
		       <TELL "It's a traditional Zalagasan pottery bowl, and
it looks as if you'd better not think about what it's made of." CR>)
		      (<T? <LOOKED-AT-FOOD?>>
		       <TELL "Very well. It's horrible. At first you think
\"Ho hum, don't mind eating it, but I wouldn't want to tread in it\" but then
you decide that it's even worse than that. It seems to be composed of old
shoe-leather and a number of small greenish, mutated things with too many
heads. Innumerable tiny eyes peer up at you from the plate." CR>)
		      (T
		       <LOOKED-AT-FOOD? T>
		       <TELL ,DONT "want to." CR>)>)
	       (<VERB? SMELL>
		<TELL "It gives off a hogo you could hang your hat on. The top
note is brassy and farinaceous, with a hot blast of rubber and photographic
fixer, and an underlying hint of mossy teeth and old man's vest." CR>)
	       (<VERB? PUT PUT-ON EMPTY-INTO>
		<COND (<PRSI? SEAT-POCKET UNDER-SEAT GROUND>
		       <COND (<IS? ,FLIGHT-ATTENDANT ,SEEN>
			      <TELL "Since " THE ,FLIGHT-ATTENDANT " is
still watching, you think better of this otherwise admirable plan." CR>
			      <RETURN T .AMF>)>
		       <TELL "As you gingerly pick up your bowl of hateful
food, the flight attendant appears. ">
		       <COND
			(<F? <MIND-READ?>>
			 <MIND-READ? T>
			 <TELL "You read her mind. It says \"I can read
your mind, buster. Put that food down or else.\"">)
			(T
			 <TELL "This being the mind-reading hockey puck,
nothing need be said.">)>
		       <TELL CR CR "You wisely put the food down." CR>
		       <COND (<CHECK-REGULATIONS>
			      <FLIGHT-ATTENDANT-APPEARS>)
			     (T
			      <TELL CR "She leaves." CR>)>)
		      (T
		       <TELL "You seem to have developed a sneaking affection
for " THEI ", which is incompatible with forcing your meal into it." CR>)>)
	       (<OR <VERB? TAKE>
		    <MOVING?>>
		<TELL "As you terribly, terribly warily pick up your hateful
food, ">
		<COND (<IS? ,FLIGHT-ATTENDANT ,SEEN>
		       <TELL THE ,FLIGHT-ATTENDANT " clears ">
		       <COND (<IS? ,FLIGHT-ATTENDANT ,FEMALE>
			      <TELL "her">)
			     (T
			      <TELL "his">)>
		       <TELL " throat. ">
		       <COND (<IS? ,FLIGHT-ATTENDANT ,FEMALE>
			      <TELL "Her">)
			     (T
			      <TELL "His">)>)
		      (T
		       <FLIGHT-ATTENDANT-APPEARS 2>
		       <TELL "a flight attendant appears. His">)>
		<TELL " expression speaks more loudly than words.
You put the food back on your table.|
|
\"Please finish your delicious Zalagasan delicacy, " <STR-SIR-OR-MAAM>
",\" says the attendant." CR>
		<CHECK-REGULATIONS>
		T)
	       (<TOUCHING?>
		<TELL "This food was meant to be eaten, not felt up. Though
it would undoubtedly enjoy it." CR>)>)
	(<THIS-PRSI?>
	 <COND (<VERB? PUT PUT-ON>
		<TELL "You seem to have developed a sneaking affection for "
THEO ", which is incompatible with forcing it into this." CR>)
	       (<VERB? TRADE-FOR>
		<TELL "Everyone around you seems to have finished eating already. And it looked wonderful, too." CR>)>)>>

<DEFINE CHECK-REGULATIONS ("AUX" (CT <ATTENDANT-MENTIONED-REGULATIONS?>)
			   (VAL <>))
  <COND (<0? <SET CT <- .CT 1>>>
	 <TELL CR "\"You had better eat that food, " <STR-SIR-OR-MAAM> ".
Do you not know the regulations?\"" CR>
	 <SET VAL T>)>
  <ATTENDANT-MENTIONED-REGULATIONS? .CT>
  .VAL>

<DEFINE I-ATE-FOOD ()
  <TELL CR
	"Your meal has had a chance to work for a while. You are feeling
distinctly queasy. Your fellow passengers probably would be, too, but for
the fact that every time you breathe out, more of them pass out. This
heartrending scene finally ends when some component of your breath weakens
the fuselage enough for it to burst. You plummet to the jungle floor,
where a passing Ai-Ai devours your remains.">
  <JIGS-UP>
  T>


<DEFINE SERVE-MEAL ()
  <DISPLAY-PLACE>
  <TELL CR CTHE ,FLIGHT-ATTENDANT " appears and">
  <COND (<T? <CURRENT-NEIGHBOR>>
	 <TELL ", after a brief consultation, rewards your neighbour with
a delicious concoction involving raspberries and kiwi fruit. She then">)>
  <TELL " asks you what you would like
for dinner. \"We have Chicken Kiev with raspberry vinegar and a kiwi fruit,
or we have Filet with raspberries and kiwi vinegar dressing. Which would you
prefer?\"" CR>
  <PROG (WD (CHICKEN? <>) (TD? <TABLE-STATE>))
    <SET WD <GET-WORD>>
    <COND (<EQUAL? .WD ,W?CHICKEN ,W?KIEV>
	   <SET CHICKEN? T>)
	  (<==? .WD ,W?FILET>
	   <SET CHICKEN? <>>)
	  (T
	   <COOPERATE>
	   <TELL "The Chicken or the Filet?\"" CR>
	   <AGAIN>)>
    <TELL CTHE ,FLIGHT-ATTENDANT " goes away for a while, then returns. \"We
are out of the ">
    <COND (.CHICKEN? <TELL "Chicken">)
	  (T <TELL "Filet">)>
    <TELL ", " <STR-SIR-OR-MAAM> ". Would you like the ">
    <COND (.CHICKEN? <TELL "Filet">)
	  (T <TELL "Chicken">)>
    <TELL "?\"" CR>
    <COND (<SAID-YES? "\"A simple yes or no will suffice.\"">
	   <TELL "\"We are also out of that">)
	  (T
	   <TELL "\"I'm sorry to hear that">)>
    <TELL ", " <STR-SIR-OR-MAAM> ". I do have a Zalagasan specialty: llama stewed with pulped roots
and other sorts of Zalagasan stuff. Would you like that?\"" CR>
    <SAID-YES? "\"A simple yes or no will suffice.\"">
    <TELL "\"Excellent!\" says the attendant. She ">
    <COND (<F? .TD?> <TELL "unfolds your table and ">)>
    <TELL "puts
a bowl full of something horrible which you do not want to look at on ">
    <COND (<F? .TD?> <TELL "it">)
	  (T <TELL "your table">)>
    <TELL ". The
subsequent vanishing act she puts on is a sight to behold."
	  CR>
    <MOVE ,AIRLINE-MEAL ,SEAT-TABLE>
    <THIS-IS-IT ,AIRLINE-MEAL>
    <AIR-MEAL-STATE 1>
    <MEAL-HERE? T>
    <MAKE ,SEAT-TABLE ,SURFACE>
    <TABLE-STATE 1>
    <MEAL-ROW ,CURRENT-ROW>
    <MEAL-SEAT ,CURRENT-SEAT>
    <QUEUE I-WARN-LOSER 20>
    <QUEUE I-MEAL-ESCAPES 75>
    <TELL CR "\"Ladies and gentlemen, at this time we will be enabling the
various comfort control functions of your Comf-O-Mat (TM) seats. For your
safety and comfort, please do not abuse them.\"" CR>
    <BUTTONS-OFF? <>>>>

<DEFINE I-WARN-LOSER WARN ("AUX" (MOVE? <>))
  <COND (<AND <F? <MEAL-SQUASHED?>>
	      <F? <MEAL-EATEN?>>>
	 <COND (<NOT <HERE? AISLE SEAT>>
		<QUEUE I-WARN-LOSER -1>
		<RETURN <> .WARN>)
	       (<HERE? AISLE>
		<SET MOVE? T>)
	       (<AND <HERE? SEAT>
		     <OR <N==? ,CURRENT-ROW <MEAL-ROW>>
			 <N==? ,CURRENT-SEAT <MEAL-SEAT>>>>
		<SET MOVE? T>)>
	 <DEQUEUE I-WARN-LOSER>
	 <TELL CR CA ,FLIGHT-ATTENDANT " hurries up to you. \"This is
really unforgivable, " <STR-SIR-OR-MAAM> ". You haven't eaten your delicious
Zalagasan dinner yet. Surely you must know the regulations.\"">
	 <COND (.MOVE?
		<TELL " You find yourself, as if by magic, back in
your seat, staring at the hateful thing" ,PCR>
		<NEW-ROW <MEAL-ROW>>
		<NEW-SEAT <MEAL-SEAT>>
		<PERFORM ,V?WALK-TO ,SEAT>
		<DISPLAY-PLACE>)
	       (T
		<ZCRLF>)>)>
  <FLIGHT-ATTENDANT-APPEARS>
  <DEQUEUE I-WARN-LOSER>
  T>


<DEFINE I-MEAL-ESCAPES ()
  <COND (<AND <F? <MEAL-SQUASHED?>>
	      <F? <MEAL-EATEN?>>>
	 <TELL CR
	       "After a relatively lengthy and peculiarly odorous incubation,
your Zalagasan specialty finally escapes its bowl and runs amok in the
" D ,PLANE ". Its adventures conclude, at least from your point of view, when
it enters the cockpit and forces the pilot to crash into the jungle, much
to the chagrin of those passengers who survived that long.">
	 <JIGS-UP>)>>

<DEFINE I-RUN-PLANE IRP ("AUX" (RPC <RUN-PLANE-COUNT>))
  <COND (<L? <SET RPC <+ .RPC 1>> 15>
	 <RUN-PLANE-COUNT .RPC>
	 <RETURN <> .IRP>)>
  <DEQUEUE I-RUN-PLANE>
  ; "Announce meal, then force return to seat at reasonable time."
  <TELL CR "An announcement comes over the P.A. system, with the emphasis on
all the wrong words: \"At this time, we will be serving you with dinner.
Please return to your seats for your comfort and safety.\"" CR>
  <COND (<HERE? SEAT>
	 <SERVE-MEAL>)
	(T
	 <QUEUE I-DIDNT-RETURN-TO-SEAT 5>
	 <RETURN-TO-SEAT-ROUTINE SERVE-MEAL>)>
  T>


<OBJECT RANDOM-OBJECT
	(ACTION RANDOM-OBJECT-F)
	(SDESC SDESC-RANDOM-OBJECT)
	(DESCFCN RANDOM-OBJECT-F)
	(PSEUDO-TABLE 0)>

<DEFINE RAND-PRSO? (N:FIX)
  <COND (<AND <==? ,PRSO ,RANDOM-OBJECT>
	      <==? <GETP ,PRSO ,P?PSEUDO-TABLE> .N>> T)
	(T <>)>>

<DEFINE RAND-PRSI? (N:FIX)
  <COND (<AND <==? ,PRSI ,RANDOM-OBJECT>
	      <==? <GETP ,PRSI ,P?PSEUDO-TABLE> .N>> T)
	(T <>)>>

<DEFINE SDESC-RANDOM-OBJECT ("AUX"
			     (WHICH <GETP ,RANDOM-OBJECT ,P?PSEUDO-TABLE>))
  <COND (<F? .WHICH>
	 <TELL "something">)
	(<==? .WHICH ,HATCH-OBJECT>
	 <TELL "hatch">)
	(<==? .WHICH ,GRANDCHILDREN-OBJECT>
	 <TELL "grandchildren">)
	(<==? .WHICH ,BABY-OBJECT>
	 <TELL "baby">)
	(<==? .WHICH ,BOOK-OBJECT>
	 <TELL "book">)
	(<==? .WHICH ,RECLINE-BUTTON>
	 <TELL "recline button">)
	(<==? .WHICH ,LIGHT-BUTTON>
	 <TELL "light button">)
	(<==? .WHICH ,CALL-BUTTON>
	 <TELL "call button">)
	(<==? .WHICH ,THING-OBJECT>
	 <TELL "misshapen thing">)
	(<==? .WHICH ,VOICE-OBJECT>
	 <TELL "voices">)
	(<==? .WHICH ,BUTTONS-OBJECT>
	 <TELL "set of buttons">)
	(<==? .WHICH ,FLUTE-OBJECT>
	 <TELL "nose flute">)
	(<==? .WHICH ,OTHER-FOOD-OBJECT>
	 <TELL "dinner">)
	(<==? .WHICH ,FAKE-CHUTE-OBJECT>
	 <COND (<OR <PRSI-NOUN-USED? ,W?KA\'ABI>
		    <PRSO-NOUN-USED? ,W?KA\'ABI>>
		<TELL "stinglai ka'abi">)
	       (T
		<TELL "parachute">)>)>>

<DEFINE RANDOM-OBJECT-F ROF ("OPT" (CONTEXT <>)
			 "AUX" (WHICH <GETP ,RANDOM-OBJECT ,P?PSEUDO-TABLE>)
			       STR (FOOD-HERE? <>) NS FOOD-PERSON FOOD-SEAT)
	<COND (<==? .WHICH ,OTHER-FOOD-OBJECT>
	       <COND
		(<T? <MEAL-HERE?>>
		 <COND (<HERE? SEAT>
			<COND (<T? <SET FOOD-PERSON <CURRENT-NEIGHBOR>>>
			       <SET NS
				    <GETB ,NEIGHBOR-SEATS <- ,CURRENT-SEAT 1>>>
			       <COND (<0? <ANDB <GET-SEAT .NS> ,FOOD-MASK>>
				      <SET FOOD-HERE? T>)>)>)
		       (<HERE? AISLE>
			<COND (<T? <SET FOOD-PERSON <SEAT-PERSON ,SEAT-C>>>
			       <COND (<0? <ANDB <GET-SEAT ,SEAT-C> ,FOOD-MASK>>
				      <SET FOOD-HERE? T>)>
			       <SET FOOD-SEAT ,SEAT-C>)>
			<COND (<OR <NOT .FOOD-HERE?>
				   <==? .FOOD-PERSON ,PERSON-MASK>>
			       <COND (<AND <T? <SET NS <SEAT-PERSON ,SEAT-D>>>
					   <N==? .NS ,PERSON-MASK>>
				      <SET FOOD-SEAT ,SEAT-D>
				      <SET FOOD-PERSON .NS>
				      <COND (<0? <ANDB <GET-SEAT ,SEAT-D>
						       ,FOOD-MASK>>
					     <SET FOOD-HERE? T>)
					    (T
					     <SET FOOD-HERE? <>>)>)
				     (<==? .NS ,PERSON-MASK>
				      <SET FOOD-PERSON .NS>
				      <SET FOOD-SEAT ,SEAT-D>
				      <COND (<0? <ANDB <GET-SEAT ,SEAT-D>
						       ,FOOD-MASK>>
					     <SET FOOD-HERE? T>)
					    (T
					     <SET FOOD-HERE? <>>)>)>)>)>
		 <COND (<T? .FOOD-PERSON>
			<TELL "The ">
			<COND (<==? .FOOD-PERSON ,PERSON-MASK>
			       <TELL "person in seat "
				     CHAR <GETB ,SEAT-LETTERS
						<SET FOOD-SEAT <- .FOOD-SEAT
								  1>>>>)
			      (T
			       <RANDOM-PERSON-F ,M-SHORTDESC .FOOD-PERSON>)>
			<COND (<==? .FOOD-PERSON ,SLEEPER-PERSON>
			       <COND (.FOOD-HERE?
				      <TELL " seems to be sleeping peacefully,
while managing to keep his face in both a book and his food. Surely you don't
want to bother him">)
				     (T
				      <TELL " is muttering and tossing and
turning (insofar as one can in a Comf-O-Mat (TM) seat). Were he awake, he'd
probably be quite annoyed about his missing meal">)>)
			      (<VERB? ASK-ABOUT>
			       <RETURN <> .ROF>)
			      (<VERB? REQUEST TRADE-FOR>
			       <COND (<NOT .FOOD-HERE?>
				      <TELL " doesn't seem to have any food,
probably because of something you did. Don't press your luck">)
				     (<META-IN? ,AIRLINE-MEAL ,HERE>
				      <TELL " shrinks back in horror upon
seeing what you have to offer in exchange">)
				     (T
				      <TELL " seems to wonder what you
have to offer that could possibly be as good as what's already there">)>)
			      (.FOOD-HERE?
			       <TELL " is extremely engrossed in a gourmet
delicacy. It would be rude to interrupt">)
			      (T
			       <TELL " seems not to have any food, and to
be somewhat annoyed about something. You'd best leave well enough alone">)>
			<TELL ,PERIOD>)
		       (T
			<TELL "There's no food here." CR>)>)
		(T
		 <TELL "There's no food here." CR>)>)
	      (<==? .WHICH ,FLUTE-OBJECT>
	       <COND (<AND <HERE? AISLE>
			   <==? ,CURRENT-ROW 4>>
		      <COND (<VERB? EXAMINE>
			     <TELL "It's an example of the world-famous
traditional Zalagasan nose flute." CR>)
			    (<TOUCHING?>
			     <TELL "You may not have heard that Zalagasans
are cannibals." CR>)>)
		     (T
		      <CANT-SEE-ANY ,RANDOM-OBJECT>
		      T)>)
	      (<==? .WHICH ,BUTTONS-OBJECT>
	       <COND (<NOT <HERE? SEAT>>
		      <TELL "You can't really do much with the buttons from
here." CR>
		      T)
		     (<VERB? EXAMINE>
		      <TELL "Your Comf-O-Mat (TM) seat is equipped with all
buttons necessary for your own safety and comfort: a light button, a call
button, and a recline button." CR>)
		     (<VERB? PUSH>
		      <TELL "ZAA regulations strictly prohibit pushing more
than one button at a time.">)
		     (T <>)>)
	      (<OR <==? .WHICH ,VOICE-OBJECT>
		   <AND <HERE? LAV-LOBBY>
			<VERB? LISTEN>>>
	       <COND (<AND <T? <VOICES-ONLINE?>>
			   <IS? ,AIRPHONE ,TOUCHED>>
		      <COND (<VERB? LISTEN>
			     <DEQUEUE I-SAY-VOICES>
			     <I-SAY-VOICES <>>)>)
		     (T
		      <TELL "You hear nothing." CR>)>)
	      (<==? .WHICH ,BOOK-OBJECT>
	       <COND (<AND <==? ,CURRENT-ROW 7>
			   <OR <HERE? AISLE>
			       <==? ,CURRENT-SEAT ,SEAT-D>>>
		      <COND (<==? .CONTEXT ,M-OBJDESC>
			     <TELL "copy of ">
			     <ITALICIZE "Dirk Gently">)
			    (<T? .CONTEXT> <>)
			    (<VERB? EXAMINE>
			     <TELL "It is called ">
			     <ITALICIZE "Dirk Gently's Holistic Detective
Agency.">
			     <TELL " It is unfinished." CR>)
			    (<VERB? READ>
			     <TELL ,DONT "want to." CR>)
			    (<MOVING?>
			     <TELL "No." CR>)>)
		     (T
		      <CANT-SEE-ANY ,RANDOM-OBJECT>)>)
	      (<==? .WHICH ,THING-OBJECT>
	       <COND (<==? .CONTEXT ,M-OBJDESC>
		      <TELL "misshapen thing">)
		     (<T? .CONTEXT> <>)
		     (<AND <==? ,CURRENT-ROW 5>
			   <OR <HERE? AISLE>
			       <==? ,CURRENT-SEAT ,SEAT-B>>>
		      <COND
		       (<VERB? EXAMINE>
			<TELL "It's a reasonably ordinary misshapen thing."
			      CR>)
		       (<MOVING?>
			<TELL "The ">
			<RANDOM-PERSON-F ,M-SHORTDESC ,GRANDMA-PERSON>
			<TELL " clutches " THEO
			      " more tightly. \"No, it's for my nephew.\"" CR>)
		       (T <>)>)
		     (T
		      <CANT-SEE-ANY ,PRSO>)>)
	      (<==? .WHICH ,HATCH-OBJECT>
	       <COND (<AND <HERE? SEAT>
			   <NOUN-USED? ,W?WINDOW>>
		      <TELL "As a money-saving measure, Air Zalagasa flights
don't have windows. Hence, you can't see one here." CR>
		      ,FATAL-VALUE)
		     (<==? .CONTEXT ,M-OBJDESC>
		      <TELL "escape hatch">)
		     (<T? .CONTEXT> <>)
		     (<VERB? WALK-TO>
		      <COND (<HERE? LAV-LOBBY>
			     <TELL "You're already there." CR>)
			    (T
			     <PERFORM ,V?WALK-TO ,LAV-LOBBY>)>)
		     (<NOT <EQUAL? ,HERE ,LAV-LOBBY ,OUTSIDE-PLANE>>
		      <CANT-SEE-ANY <> "the hatch">)
		     (<THIS-PRSI?>
		      <>)
		     (<VERB? EXAMINE>
		      <COND (<HERE? OUTSIDE-PLANE>
			     <TELL "It's a normal hatch, closed, from which
you're dangling." CR>)
			    (<G? <HATCH-OPEN?> 1>
			     <TELL "The hatch is open." CR>)
			    (T
			     <TELL "It is incredibly complicated with a huge
handle saying \"LIFT THEN PULL,\" although you can bet it's not as easy as
that." CR>)>)
		     (<VERB? TURN>
		      <TELL "You must be determined to prove that anything
can be difficult if enough intelligence is applied." CR>)
		     (<VERB? RAISE>
		      <COND (<G? <HATCH-OPEN?> 0>
			     <TELL "You must be determined to win that bet."
				   CR>
			     <HATCH-LOSER? T>)
			    (T
			     <HATCH-OPEN? 1>
			     <TELL "That wasn't too bad. Bet the next step is
a real killer." CR>)>)
		     (<VERB? PULL>
		      <COND (<0? <HATCH-OPEN?>>
			     <TELL "You must be determined to win that bet."
				   CR>
			     <HATCH-LOSER? T>)
			    (T
			     <HATCH-OPEN? 2>
			     <DEQUEUE I-WARN-LOSER>
			     <DEQUEUE I-MEAL-ESCAPES>
			     <DEQUEUE I-RUN-PLANE>
			     <DEQUEUE I-DIDNT-RETURN-TO-SEAT>
			     <DEQUEUE I-LOSE-ATTENDANT>
			     <COND (<T? <HATCH-LOSER?>>
				    <TELL "Although you tried, y">)
				   (T
				    <TELL "Y">)>
			     <TELL "ou lost your bet. It ">
			     <ITALICIZE "is">
			     <DEQUEUE I-CRASH>
			     <DEQUEUE I-REALLY-CRASH>
			     <TELL " as easy as that"
				   ,PCR
				   "The hatch falls open. The aircraft
immediately fills with a dense white vapour through which you can just make out oxygen masks falling from the overhead lockers." CR>)>)
		     (<VERB? OPEN UNLOCK>
		      <COND (<==? ,HERE ,OUTSIDE-PLANE>
			     <TELL "There's no way to open the hatch from the outside when it's locked from the inside." CR>)
			    (T
			     <PERFORM ,V?EXAMINE ,RANDOM-OBJECT>)>)
		     (<VERB? CLOSE LOCK>
		      <HATCH-OPEN? 0>
		      <ALREADY-CLOSED>
		      T)
		     (<VERB? KNOCK>
		      <COND (<==? ,HERE ,OUTSIDE-PLANE>
			     <TELL
CTHE ,FLIGHT-ATTENDANT " opens the door. \"Oh!\" She seems surprised.
\"We aren't going to crash after all -- it was just a computer malfunction.
Thank you for choosing Air Zalagasa, and have a nice day.\"|
|
She frees the strap and you plummet down" ,PCR>
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
		     (<VERB? LOOK-INSIDE LOOK-OUTSIDE>
		      <COND (<HERE? OUTSIDE-PLANE>
			     <TELL "You can just make out a flight attendant's
back. There's no evidence of any freezing or suffocating going on in the
airplane, but there's plenty of it going on out here." CR>)
			    (T
			     <TELL "You see thousands of Martian spacecraft massing
for an attack on Delaware...Oops! Just kidding. Actually, you see sky. And
possibly some ground, off in the distance." CR>)>)
		     (T <>)>)
	      (<==? .WHICH ,BABY-OBJECT>
	       <COND (<NOT <ON-PLANE?>>
		      <CANT-SEE-ANY ,RANDOM-OBJECT>)
		     (<N==? <CURRENT-NEIGHBOR> ,MOMMA-PERSON>
		      <TELL
		       "There doesn't seem to be one in the immediate vicinity."
		       CR>)
		     (<VERB? TAKE>
		      <TELL "Have you seen the way its mother is looking at
you? Don't even consider it." CR>)
		     (<VERB? EXAMINE>
		      <TELL "It is smiling cheerfully." CR>)
		     (<VERB? YELL ALARM>
		      <TELL "Its equipoise is undisturbed. It merely smiles."
			    CR>)
		     (<AND <THIS-PRSI?>
			   <VERB? SHOW>>
		      <COND (<PRSO? AIRLINE-MAGAZINE>
			     <COND (<G? <BABY-DISTURBED?> 1>
				    <TELL "The mother sees you coming and
drives you away" ,PCR>
				    <DO-WALK ,P?NORTH>)
				   (T
				    <BABY-DISTURBED? 2>
				    <TELL
"The baby is amused by the pretensions of the in-flight magazine. It gurgles
over the llama-wool clothes, chortles at the pygmy hogs, licks its hateful
chops over the nice arrangements of cannibal cuisine, and giggles at the
Ai-Ai. Then it sees the picture of Princess Ani-Ta'a. Its face turns
bright red and crumples up (an improvement, if anything) and it bursts
into hysterical sobs.|
|
Its mother glares at you, picks up the baby and begins to stroll up and
down the aisle, crooning horribly to her offspring." CR>)>
			     <QUEUE I-MOMMA-RETURNS 4>
			     <CURRENT-NEIGHBOR 0>
			     <CURRENT-NEIGHBOR-SEATNUM 0>
			     <SET-SEAT-PERSON 0 ,SEAT-B 8 T>)
			    (T
			     <TELL "The loathsome little creature smiles and nods." CR>)>)>)
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
		       CR>)>)
	      (<EQUAL? .WHICH ,RECLINE-BUTTON ,CALL-BUTTON ,LIGHT-BUTTON>
	       <COND (<THIS-PRSI?> <>)
		     (<NOT <HERE? SEAT>>
		      <TELL "You can't reach " THEO " from here." CR>)
		     (<VERB? PUSH>
		      <COND (<T? <BUTTONS-OFF?>>
			     <RUN-PLANE-COUNT <- <RUN-PLANE-COUNT> 1>>
			     <COND (<F? <PHONES-PLUGGED-IN?>>
				    <RUN-PLANE-COUNT <- <RUN-PLANE-COUNT> 1>>
				    <TELL "You hear a tiny metallic voice whispering nearby."
					  CR>)
				   (<NOT <IS? ,PHONES ,WORN>>
				    <RUN-PLANE-COUNT <- <RUN-PLANE-COUNT> 1>>
				    <TELL
				     "You hear a small metallic voice whispering nearby."
				     CR>)
				   (T
				    <TELL "\"Welcome to seat ">
				    <SAY-AFFECTED-SEAT .WHICH>
				    <TELL ". The ">
				    <COND (<==? .WHICH ,CALL-BUTTON>
					   <TELL "light">)
					  (<==? .WHICH ,LIGHT-BUTTON>
					   <TELL "recline">)
					  (T
					   <TELL "call">)>
				    <TELL
" function of your Comf-O-Mat electrically-controlled passenger station has been
centrally disabled at this time for your comfort and safety. We will be
making this facility available to you after takeoff, or after we reach
our assigned cruising altitude. Or possibly after we have finished reading
the passenger manifest and laughing at your silly names. Oops. This is a
recording.\"" CR>)>)
			    (<==? .WHICH ,CALL-BUTTON>
			     <LIGHT-UP-SEAT>)
			    (<==? .WHICH ,LIGHT-BUTTON>
			     <RECLINE-SEAT>)
			    (T
			     <CALL-SEAT>)>)>)>>

<DEFINE I-MOMMA-RETURNS ()
  <COND (<AND <HERE? SEAT AISLE>
	      <==? ,CURRENT-ROW 8>
	      <OR <HERE? AISLE>
		  <EQUAL? ,CURRENT-SEAT ,SEAT-B ,SEAT-C>>>
	 <TELL CR
	       "The mother returns, bearing her by now quiet infant. She
is accompanied by a flight attendant, who marches you back to your seat without
further ado." CR CR>
	 <COND (<MEAL-HERE?>
		<NEW-ROW <MEAL-ROW>>
		<NEW-SEAT <MEAL-SEAT>>)
	       (T
		<NEW-ROW 3>
		<NEW-SEAT ,SEAT-B>)>
	 <PERFORM ,V?WALK-TO ,SEAT>
	 <SET-SEAT-PERSON ,MOMMA-PERSON ,SEAT-B 8 T>
	 T)
	(T
	 <SET-SEAT-PERSON ,MOMMA-PERSON ,SEAT-B 8 T>
	 <>)>>

<CONSTANT OTHER-AIRPLANE-OBJECTS
	  <PLTABLE <VOC "ESCAPE" ADJ> <VOC "HATCH" OBJECT>
		   ,HATCH-OBJECT
		   <VOC "EMERGENCY" ADJ> <VOC "HATCH" OBJECT>
		   ,HATCH-OBJECT
		   <> <VOC "EXIT" OBJECT>
		   ,HATCH-OBJECT
		   <> <VOC "WINDOW" OBJECT>
		   ,HATCH-OBJECT
		   <> <VOC "HANDLE" OBJECT>
		   ,HATCH-OBJECT
		   <VOC "YOUR" ADJ> <VOC "NEPHEW" OBJECT>
		   ,GRANDCHILDREN-OBJECT
		   <> <VOC "ARTHUR" OBJECT>
		   ,GRANDCHILDREN-OBJECT
		   <> <VOC "BUTTONS" OBJECT>
		   ,BUTTONS-OBJECT
		   <> <VOC "CONTROLS" OBJECT>
		   ,BUTTONS-OBJECT
		   <VOC "RECLINE" ADJ> <VOC "BUTTON" OBJECT>
		   ,RECLINE-BUTTON
		   <VOC "LIGHT" ADJ> <VOC "BUTTON" OBJECT>
		   ,LIGHT-BUTTON
		   <VOC "CALL" ADJ> <VOC "BUTTON" OBJECT>
		   ,CALL-BUTTON
		   <VOC "YOUR" ADJ> <VOC "CHILD" OBJECT>
		   ,BABY-OBJECT
		   <VOC "YOUR" ADJ> <VOC "BABY" OBJECT>
		   ,BABY-OBJECT
		   <VOC "YOUR" ADJ> <VOC "SON" OBJECT>
		   ,BABY-OBJECT
		   <> <VOC "BOOK" OBJECT>
		   ,BOOK-OBJECT
		   <VOC "DIRK" ADJ> <VOC "GENTLY" OBJECT>
		   ,BOOK-OBJECT
		   <VOC "MISSHAPEN" ADJ> <VOC "THING" OBJECT>
		   ,THING-OBJECT
		   <> <VOC "REGULATIONS" OBJECT>
		   ,REGULATIONS-OBJECT
		   <> <VOC "VOICE" OBJECT>
		   ,VOICE-OBJECT
		   <> <VOC "VOICES" OBJECT>
		   ,VOICE-OBJECT
		   <VOC "NOSE" ADJ> <VOC "FLUTE" OBJECT>
		   ,FLUTE-OBJECT
		   <VOC "NOSE" ADJ> <VOC "FLUTES" OBJECT>
		   ,FLUTE-OBJECT
		   <VOC "YOUR" ADJ> <VOC "FOOD" OBJECT>
		   ,OTHER-FOOD-OBJECT
		   <VOC "YOUR" ADJ> <VOC "MEAL" OBJECT>
		   ,OTHER-FOOD-OBJECT
		   <VOC "CHICKEN" ADJ> <VOC "KIEV" OBJECT>
		   ,OTHER-FOOD-OBJECT
		   <VOC "YOUR" ADJ> <VOC "FILET" OBJECT>
		   ,OTHER-FOOD-OBJECT
		   <VOC "YOUR" ADJ> <VOC "CHICKEN" OBJECT>
		   ,OTHER-FOOD-OBJECT
		   <VOC "HIS" ADJ> <VOC "MEAL" OBJECT>
		   ,OTHER-FOOD-OBJECT
		   <VOC "HER" ADJ> <VOC "MEAL" OBJECT>
		   ,OTHER-FOOD-OBJECT
		   <VOC "MAN'S" ADJ> <VOC "MEAL" OBJECT>
		   ,OTHER-FOOD-OBJECT
		   <VOC "WOMAN'S" ADJ> <VOC "MEAL" OBJECT>
		   ,OTHER-FOOD-OBJECT
		   <VOC "HIS" ADJ> <VOC "FOOD" OBJECT>
		   ,OTHER-FOOD-OBJECT
		   <VOC "HER" ADJ> <VOC "FOOD" OBJECT>
		   ,OTHER-FOOD-OBJECT
		   <VOC "STINGLAI" ADJ> <VOC "KA'ABI" OBJECT>
		   ,FAKE-CHUTE-OBJECT
		   <> <VOC "PARACHUTE" OBJECT>
		   ,FAKE-CHUTE-OBJECT
		   <> <VOC "CHUTE" OBJECT>
		   ,FAKE-CHUTE-OBJECT
		   <VOC "OLD" ADJ> <VOC "WOMAN" OBJECT>
		   ,GRANDMA-PERSON
		   <> <VOC "WOMAN" OBJECT>
		   ,GRANDMA-PERSON
		   <> <VOC "GRANDMOTHER" OBJECT>
		   ,GRANDMA-PERSON
		   <VOC "YOUNG" ADJ> <VOC "WOMAN" OBJECT>
		   ,MOMMA-PERSON
		   <> <VOC "WOMAN" OBJECT>
		   ,MOMMA-PERSON
		   <VOC "YOUNG" ADJ> <VOC "MOTHER" OBJECT>
		   ,MOMMA-PERSON
		   <> <VOC "MOTHER" OBJECT>
		   ,MOMMA-PERSON
		   <VOC "IRRITABLE" ADJ> <VOC "FELLOW" OBJECT>
		   ,SMOKER-PERSON
		   <VOC "IRRITABLE" ADJ> <VOC "MAN" OBJECT>
		   ,SMOKER-PERSON
		   <VOC "ANGRY" ADJ> <VOC "MAN" OBJECT>
		   ,SMOKER-PERSON
		   <VOC "ANGRY" ADJ> <VOC "FELLOW" OBJECT>
		   ,SMOKER-PERSON
		   <> <VOC "MAN" OBJECT>
		   ,SMOKER-PERSON
		   <> <VOC "POLITICIANS" OBJECT>
		   ,POLITICIANS-PERSON
		   <> <VOC "ZALAGASAN" OBJECT>
		   ,ZALAGASANS-PERSON
		   ;<VOC "BALD" ADJ> ;<VOC "MAN" OBJECT>
		   ;,BALD-PERSON
		   <VOC "FAT" ADJ> <VOC "MAN" OBJECT>
		   ,FAT-PERSON
		   <VOC "FROBOZZCO" ADJ> <VOC "EXECUTIVE" OBJECT>
		   ,FROBOZZCO-PERSON
		   <VOC "SLEEPING" ADJ> <VOC "MAN" OBJECT>
		   ,SLEEPER-PERSON>>

<CONSTANT SEAT-PSEUDO-VEC <PTABLE MATCH-SEAT-NAME OTHER-AIRPLANE-OBJECTS>>

"Code for other passengers"
<OBJECT RANDOM-PERSON
	(ACTION RANDOM-PERSON-F)
	(DESCFCN RANDOM-PERSON-F)
	(SDESC RANDOM-PERSON-SDESC)
	(PSEUDO-TABLE 0)
	(FLAGS PERSON LIVING)>

<DEFINE DESCRIBE-AIRLINE-PERSON (N:FIX "OPT" (SHORT? <>))
  <RANDOM-PERSON-F <COND (.SHORT? ,M-SHORTDESC)
			 (T ,M-OBJDESC)> .N>>

<DEFINE RANDOM-PERSON-SDESC ()
  <RANDOM-PERSON-F ,M-SHORTDESC>>

<DEFINE PERFORM-WITH-PLAYER (PRSA PRSO "OPT" (PRSI <>)
			     "AUX" (OWINNER ,WINNER) VAL)
  <SETG WINNER ,PLAYER>
  <SET VAL <PERFORM .PRSA .PRSO .PRSI>>
  <SETG WINNER .OWINNER>
  .VAL>

<CONSTANT FACE-IN-FOOD-STRS
	  <PTABLE <>
		  <>
		  ;" strange, crackling sound like a pile of twigs being
stamped into a peat-bog"
		  ;" nice auntie who has been carefully pecking at her nice
food and admiring the thing she has bought for her nephew which she doesn't
know what it is, when"
		  " high-pitched, scraping sound like a large rat sliding
down a blackboard"
		  " doting mother who has been looking forward to a nourishing
meal after a day's hard baby-care when utterly without warning"
		  <>
		  <>
		  ;" nasty barking plop as if a large dog had been thrown into
a mud-hole"
		  ;"n angry man who has been rendered suddenly even more angry
when, while angrily consuming his irritating dinner"
		  " repulsive squelching mumble, as if a chattering
orangutan had suddenly had its mouth crammed full of earthworms"
		  " politician who has been (needless to say) talking
with his mouth full of airline food and"
		  " slippery sort of \"phloop!\" followed by a muffled
grunt, as if the soap had slipped out of someone's hands and hit him in
the mouth"
		  " Zalagasan businessman who has been making do with some
terribly dull Western food (when what he would really have liked is a nice
Zalagasan delicacy like llama stew with pulped roots and all sorts of stuff)
and all of a sudden"
		  ;" wet, slithery sort of clonk, as if a small
bowling-ball had been dropped onto a billiard-table smeared an inch thick
with stale peanut butter"
		  ;" bald man who has lost a lot of heat through his head
and has been restoring his calorific balance by consuming a nourishing
dinner when (O horrid but true)"
		  <>
		  <>
		  ;" wettish, muffled sound like an old llama exploding in a
fog on a distant hillside"
		  ;" fat man who has been innocently eating his fifth
dinner of the day when all of a sudden"
		  <>
		  <>
		  ;" sort of hissing, jangling \"sssplatch\" as if
a badly-made electrical device had fallen into a plate of cold porridge
and fused"
		  ;" Frobozzco executive who has interrupted his
discussion on how to use underhanded and manipulative marketing tricks
to foist his company's shoddy and unsafe products on the gullible public
to eat a tasteless meal at an inappropriate time of day, when, almost as
if it had been made by his own company,"
		  " sort of damp, gurgling grunt as if a
pygmy hog had accidentally leapt into its trough on a dark, wet night"
		  " man who has been woken up from a refreshing sleep
over his book, asked if he would like something to eat, said \"No,\"
been brought it anyway, decided he had better eat it so that they will
take it away so that he can go back to sleep, and innocently started to
eat it when, like a bolt from the blue,">>

<DEFINE RANDOM-PERSON-F ("OPT" (CONTEXT 0) (N 0) "AUX" STR (FOOD-LOSS? <>)
			 TROW TSEAT)
  <COND (<==? .N 0>
	 <SET N <GETP ,RANDOM-PERSON ,P?PSEUDO-TABLE>>)>
  <SET TROW <GETB ,PERSON-ROWS <- .N 1>>>
  <COND (<==? <SEAT-PERSON ,SEAT-B .TROW> .N>
	 <SET TSEAT ,SEAT-B>)
	(<==? <SEAT-PERSON ,SEAT-C .TROW> .N>
	 <SET TSEAT ,SEAT-C>)
	(<==? <SEAT-PERSON ,SEAT-D .TROW> .N>
	 <SET TSEAT ,SEAT-D>)
	(<==? <SEAT-PERSON ,SEAT-E .TROW> .N>
	 <SET TSEAT ,SEAT-E>)>
  <COND (<NOT <0? <ANDB <GET-SEAT .TSEAT .TROW> ,FOOD-MASK>>>
	 <SET FOOD-LOSS? T>)>
  <COND (<EQUAL? .CONTEXT ,M-OBJDESC ,M-SHORTDESC>
	 <COND (<0? .N> <SET N <GETP ,RANDOM-PERSON ,P?PSEUDO-TABLE>>)>
	 <COND (<==? .N ,GRANDMA-PERSON>
		<COND (<==? .CONTEXT ,M-OBJDESC>
		       <TELL "an ">
		       <COND (.FOOD-LOSS?
			      <TELL "annoyed ">)>
		       <TELL "old woman, clutching a misshapen thing">)
		      (T
		       <COND (.FOOD-LOSS?
			      <TELL "old woman">)
			     (T
			      <TELL "friendly old woman">)>)>)
	       (<==? .N ,MOMMA-PERSON>
		<COND (<==? .CONTEXT ,M-SHORTDESC>
		       <TELL "young mother">)
		      (T
		       <TELL
			"a young mother, with her even younger child">)>)
	       (<==? .N ,SMOKER-PERSON>
		<COND (<==? .CONTEXT ,M-OBJDESC>
		       <TELL "a red-faced, angry-looking man">)
		      (T
		       <TELL "angry fellow">)>)
	       (<==? .N ,POLITICIANS-PERSON>
		<COND (<==? .CONTEXT ,M-OBJDESC> <TELL "a ">)>
		<TELL "politician">)
	       (<==? .N ,ZALAGASANS-PERSON>
		<COND (<==? .CONTEXT ,M-OBJDESC> <TELL "a ">)>
		<TELL "Zalagasan">)
	       ;(<==? .N ,BALD-PERSON>
		<COND (<==? .CONTEXT ,M-OBJDESC> <TELL "a ">)>
		<TELL "bald man">)
	       (<==? .N ,FAT-PERSON>
		<COND (<==? .CONTEXT ,M-OBJDESC> <TELL "a ">)>
		<TELL "fat man">)
	       (<==? .N ,FROBOZZCO-PERSON>
		<COND (<==? .CONTEXT ,M-OBJDESC> <TELL "a ">)>
		<TELL "Frobozzco executive">)
	       (<==? .N ,SLEEPER-PERSON>
		<COND (<==? .CONTEXT ,M-OBJDESC>
		       <TELL "a man sleeping, his head in a book. He is snoring ">
		       <COND (.FOOD-LOSS?
			      <TELL "angrily, if that's possible">)
			     (T
			      <TELL "gently">)>)
		      (T
		       <TELL "sleeping man">)>)>)
	(<N==? <GETB ,PERSON-ROWS <- .N 1>>
	       ,CURRENT-ROW>
	 <TELL "Although you can see the">
	 <COND (<NOT <0? <ANDB <GET-SEAT ,CURRENT-SEAT
					 <- ,CURRENT-ROW 1>>
			       ,LIGHT-MASK>>>
		<TELL " shining">)>
	 <TELL " head of the ">
	 <RANDOM-PERSON-F ,M-SHORTDESC .N>
	 <TELL ", there isn't anything else you can do with ">
	 <COND (<IS? ,RANDOM-PERSON ,FEMALE> <TELL "her">)
	       (T <TELL "him">)>
	 <TELL " from here" ,PERIOD>
	 ,FATAL-VALUE)
	(<==? .CONTEXT ,M-WINNER>
	 <COND (<VERB? HELLO>
		; "FOO, HELLO becomes HELLO FOO"
		<PERFORM-WITH-PLAYER ,V?HELLO ,RANDOM-PERSON>
		,FATAL-VALUE)
	       (<VERB? STINGLAI> <>)
	       (<AND <VERB? RING-FOR>
		     <PRSO? FLIGHT-ATTENDANT>>
		<PUTP ,RANDOM-OBJECT ,P?PSEUDO-TABLE ,CALL-BUTTON>
		<PERFORM-WITH-PLAYER ,V?ASK-ABOUT ,WINNER ,RANDOM-OBJECT>
		,FATAL-VALUE)
	       (<AND <VERB? PUSH>
		     <BUTTON? ,PRSO>>
		<PERFORM-WITH-PLAYER ,V?ASK-ABOUT ,WINNER
				     ,PRSO>
		,FATAL-VALUE)
	       (<AND <VERB? SHOW>
		     <PRSI? ME>>
		<PERFORM-WITH-PLAYER ,V?ASK-ABOUT ,WINNER ,PRSO>
		,FATAL-VALUE)
	       (<AND <VERB? TELL TELL-TIME TELL-ABOUT>
		     <PRSO? ME>>
		<PERFORM-WITH-PLAYER ,V?ASK-ABOUT ,WINNER ,PRSI>
		,FATAL-VALUE)
	       (<VERB? WHAT>
		<PERFORM-WITH-PLAYER ,V?ASK-ABOUT ,WINNER ,PRSO>
		,FATAL-VALUE)
	       (<AND <VERB? GIVE>
		     <PRSI? PLAYER ME>>
		; "FOO, GIVE ME BAR becomes TAKE BAR FROM FOO"
		<PERFORM-WITH-PLAYER ,V?TAKE ,PRSO ,WINNER>
		,FATAL-VALUE)
	       (<VERB? EAT TAKE>
		<COND (<AND <VERB? EAT>
			    <PRSO? ME PLAYER>>
		       <COND (<==? .N ,ZALAGASANS-PERSON>
			      <TELL CTHE ,WINNER " seems to think you wouldn't
be tender enough. Sorry, but that's the way it is." CR>)
			     (T
			      <TELL "Cannibalism is strictly forbidden on all
Air Zalagasa flights on which foreigners are travelling." CR>)>)
		      (T
		       <PERFORM-WITH-PLAYER ,V?GIVE ,PRSO ,WINNER>)>
		,FATAL-VALUE)
	       (<AND <VERB? EXAMINE LOOK-ON>
		     <PRSO? PLAYER ME>>
		<TELL CTHE ,WINNER " tries not to look horrified at your
appearance, but makes a bad job of it." CR>)
	       (T
		<TELL CTHE ,WINNER " ignores you." CR>
		,FATAL-VALUE)>)
	(<T? .CONTEXT> <>)
	(<VERB? EXAMINE>
	 <COND (<EQUAL? .N ,GRANDMA-PERSON ,MOMMA-PERSON>
		<TELL "She's just ">
		<RANDOM-PERSON-F ,M-OBJDESC .N>)
	       (<==? .N ,SMOKER-PERSON>
		<TELL "He's ">
		<RANDOM-PERSON-F ,M-OBJDESC .N>)
	       (<EQUAL? .N ,POLITICIANS-PERSON
			,ZALAGASANS-PERSON ,FROBOZZCO-PERSON>
		<DESCRIBE-PAIR .N 0 T T>
		<TELL "It's hard to tell them one from the other">)
	       (<EQUAL? .N ;,BALD-PERSON ,FAT-PERSON>
		<TELL "Oddly, he's indistinguishable from every other ">
		<RANDOM-PERSON-F ,M-SHORTDESC .N>
		<TELL " you've ever seen on an " D ,PLANE>
		<COND (.FOOD-LOSS?
		       <TELL ", except that he looks angrier than most">)>)
	       (<==? .N ,SLEEPER-PERSON>
		<COND (.FOOD-LOSS?
		       <TELL "He seems to be very restless for someone who's
sleeping so soundly">)
		      (T
		       <TELL "He's sleeping, his head in a book">)>)>
	 <TELL ,PERIOD>)
	(<AND <THIS-PRSI?>
	      <VERB? GIVE>>
	 <PERFORM ,V?SHOW ,PRSO ,PRSI>)
	(<AND <THIS-PRSO?>
	      <VERB? TELL>>
	 <COND (<SET STR <CHECK-OZ-ROYALTY ,PRSO T>>
		<TELL "You have to strain to hear. \""
		      .STR ".\"" CR>
		<PCLEAR>
		,FATAL-VALUE)
	       (<==? .N ,SLEEPER-PERSON>
		<TELL CTHEO " seems to snore a trifle more loudly
for a bit, but otherwise doesn't respond." CR>
		,FATAL-VALUE)
	       (<==? .N ,ZALAGASANS-PERSON>
		<TELL "The Zalagasan grimaces horribly and shakes his fist (a
traditional Zalagasan gesture of confused friendliness). Perhaps he doesn't ">
		<COND (,P-CONT
		       <REPEAT ((PTR ,P-CONT) (CT ,P-LEN))
		         <COND (<G? .CT 0>
				<COND (<EQUAL? <ZGET ,P-LEXV .PTR>
					       ,W?STINGLAI ,W?KA\'ABI>
				       <TELL "understand your extremely imprecise pronunciation">
				       <RETURN>)>)
			       (T
				<TELL "speak English">
				<RETURN>)>
			 <SET PTR <+ .PTR ,P-LEXELEN>>
			 <SET CT <- .CT 1>>>)
		      (T
		       <TELL "speak English">)>
		<TELL ,PERIOD>
		,FATAL-VALUE)
	       (<==? .N ,POLITICIANS-PERSON>
		<TELL CTHEO ", as you might expect, pays absolutely
no attention to anything you say." CR>
		,FATAL-VALUE)
	       (T <>)>)
	(<==? .N ,SLEEPER-PERSON>
	 <TELL "It would be cruel to disturb his recovery from what was
obviously a very taxing experience." CR>
	 ,FATAL-VALUE)
	(<==? .N ,ZALAGASANS-PERSON>
	 <TELL "The Zalagasan grimaces horribly and shakes his fist (a
traditional Zalagasan gesture of confused friendliness). Perhaps he doesn't
speak English." " He returns to his flute-playing." CR>)
	(<==? .N ,POLITICIANS-PERSON>
	 <TELL "As you might expect, the politician pays absolutely no
attention to anything you do." CR>)
	(<==? .N ,FROBOZZCO-PERSON>
	 <TELL "The executives are too busy discussing the proper technique
for buying politicians to pay you any mind." CR>)
	(<==? .N ,FAT-PERSON>
	 <TELL "He's entirely absorbed in the contemplation of his next meal">
	 <COND (<AND <T? <MEAL-HERE?>>
		     <0? <ANDB <GET-SEAT ,SEAT-E 6> ,FOOD-MASK>>>
		<TELL ", despite the one he's now eating">)>
	 <TELL ,PERIOD>)
	(<THIS-PRSO?>
	 <COND (<==? .N ,GRANDMA-PERSON>
		<GRANDMA-PERSON-PRSO>)
	       (<==? .N ,SMOKER-PERSON>
		<SMOKER-PERSON-PRSO>)
	       (<==? .N ,MOMMA-PERSON>
		<MOMMA-PERSON-PRSO>)>)
	(<==? .N ,GRANDMA-PERSON>
	 <GRANDMA-PERSON-PRSI>)
	(<==? .N ,SMOKER-PERSON>
	 <SMOKER-PERSON-PRSI>)
	(<==? .N ,MOMMA-PERSON>
	 <MOMMA-PERSON-PRSI>)>>

<DEFINE BUTTON? (OBJ)
  <AND <==? .OBJ ,RANDOM-OBJECT>
       <EQUAL? <GETP .OBJ ,P?PSEUDO-TABLE>
	       ,LIGHT-BUTTON ,CALL-BUTTON ,RECLINE-BUTTON
	       ,BUTTONS-OBJECT>>>

<DEFINE GRANDMA-PERSON-PRSI ()
  <COND (<VERB? SHOW>
	 <TELL "\"That's very nice,\" she says">
	 <COND (<PRSO? AIRLINE-MEAL>
		<TELL ", shrinking back a little">)>
	 <TELL ,PERIOD>)
	(<VERB? TAKE>
	 <COND (<RAND-PRSO? ,OTHER-FOOD-OBJECT>
		<TELL "\"Oh, no, I'm enjoying it far too much.\"" CR>)
	       (<RAND-PRSO? ,THING-OBJECT>
		<>)>)>>

<DEFINE GRANDMA-PERSON-PRSO ()
  <COND (<VERB? HELLO>
	 <TELL "The old woman nods politely." CR>)
	(<VERB? ASK-FOR>
	 <PERFORM ,V?TAKE ,PRSI ,PRSO>)
	(<VERB? ASK-ABOUT>
	 <COND (<PRSI? NERD>
		<TELL "\"A very disturbed young man. He used to be my nephew
Arthur's best friend, heaven knows why. Then he up and moved to Zalagasa.\""
		      CR>)
	       (<BUTTON? ,PRSI>
		<TELL "\"I haven't been able to get mine to work. But they
never do on these flights.\"" CR>)
	       (<RAND-PRSI? ,THING-OBJECT>
		<TELL "\"It's for my nephew Arthur. I'm not sure what it is,
but he's very clever, and I'm sure he'll be able to figure it out.\"" CR>)
	       (<RAND-PRSI? ,OTHER-FOOD-OBJECT>
		<TELL "\"Delicious.\"" CR>)
	       (<RAND-PRSI? ,GRANDCHILDREN-OBJECT>
		<TELL "\"Poor dear. He keeps telling wild tales about
his house and Earth being destroyed on the same day. They'll probably
have to lock him up, and I blame it all on that nerd he used to hang
out with.\"" CR>)
	       (<PRSI? ,AIRLINE-MEAL>
		<TELL "\"Well, that's very nice. Not exactly my style,
but ">
		<ITALICIZE "de gustibus">
		<TELL ", I always say.\"" CR>)>)>>

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
	 <COND (<PRSI? NERD>
		<TELL "\"That shiftless little twerp. He used to be my son.
I wish he'd get a real job.\"" CR>)
	       (<BUTTON? ,PRSI>
		<TELL "\"Oh, those things never work. Wouldn't make the
damned seats any more comfortable anyway.\"" CR>)
	       (<RAND-PRSI? ,OTHER-FOOD-OBJECT>
		<TELL "\"They should just stick with the basic stuff. Fewer
berries, especially.\"" CR>)
	       (T
		<TELL
		 "\"Why don't you make a noise like a hoop and roll away?\""
		 CR>)>)
	(<VERB? HELLO>
	 <TELL "\"Why don't you make like a pea and split?\"" CR>)
	(T <>)>>

<DEFINE SMOKER-PERSON-PRSI ()
  <COND (<VERB? TAKE>
	 <COND (<T? <SMOKER-IRATE?>>
		<SMOKER-SHOOTS-YOU>)
	       (T
		<TELL "\"Try something like that again and I guarantee you'll regret it." CR>)>
	 <SMOKER-IRATE? T>)
	(<VERB? SHOW>
	 <COND (<PRSO? AIRLINE-MEAL>
		<COND (<T? <SMOKER-IRATE?>>
		       <SMOKER-SHOOTS-YOU>)
		      (T
		       <TELL "\"Do that again and you'll live to regret it.\""
			     CR>
		       <SMOKER-IRATE? T>)>)>)>>

<DEFINE MOMMA-PERSON-PRSI ()
  <COND (<VERB? SHOW>
	 <PERFORM ,V?ASK-ABOUT ,PRSI ,PRSO>)
	(<VERB? TAKE>
	 <TELL "\"I don't think you'd want anything of mine.\"" CR>)>>

<DEFINE MOMMA-PERSON-PRSO ()
  <COND (<VERB? HELLO>
	 <TELL "She nods politely." CR>)
	(<VERB? ASK-ABOUT ASK-FOR>
	 <COND (<RAND-PRSI? ,OTHER-FOOD-OBJECT>
		<TELL "\"Delicious, isn't it? I don't know how they do it
with just microwaves and plastic.\"" CR>)
	       (<RAND-PRSI? ,BABY-OBJECT>
		<TELL "\"Isn't he adorable? And smart, too. He's already
learned Latin, but we don't want him to be a nerd, so tennis lessons are
next.\"" CR>)
	       (<PRSI? NERD>
		<TELL "\"Him. He tried to put some moves on me, the little
jerk. My husband wanted to kill him, but couldn't find him anywhere.\"" CR>)
	       (<BUTTON? ,PRSI>
		<TELL "\"I haven't been able to get mine to do anything at
all. The flight attendants aren't very helpful either.\"" CR>)
	       (T
		<TELL "She seems to be tickling her baby's feet, and doesn't
respond." CR>)>)>>


<OBJECT AIRPHONE
	(LOC LAV-LOBBY)
	(DESC "telephone")
	(FLAGS CONTAINER OPENED NODESC)
	(CAPACITY 1)
	(SYNONYM TELEPHONE PHONE AIRPHONE SLOT)
	(ADJECTIVE TELEPHONE PHONE AIR PAY)
	(ACTION AIRPHONE-F)>

<DEFINE AIRPHONE-F ()
  <COND (<THIS-PRSI?>
	 <COND (<VERB? PUT>
		<COND (<PRSO? EXCESS>
		       <TELL "The phone spits " THEO " back out, and a synthetic voice says, \"Don't try to fool me with expired cards, twit.\"" CR>
		       T)
		      (<PRSO? BEEZER>
		       <MOVE ,BEEZER ,AIRPHONE>
		       <UNMAKE ,AIRPHONE ,OPENED>
		       <TELL CTHEO " vanishes inside the phone. A synthetic voice says, \"Please place your call now. You'll get your card back when you're done.\"" CR>
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
	(<VERB? LISTEN>
	 <PUTP ,RANDOM-OBJECT ,P?PSEUDO-TABLE ,VOICE-OBJECT>
	 <PERFORM ,V?LISTEN ,RANDOM-OBJECT>
	 T)
	(<OR <VERB? REPLY>
	     <AND <VERB? TAKE>
		  <T? <AIRPHONE-RINGING?>>>>
	 <COND (<T? <AIRPHONE-RINGING?>>
		<AIRPHONE-RINGING? <>>
		<TELL "\"Hello? Hello? ">
		<GENDER-PRINT "Mr " "Ms ">
		<PRINT-LAST-NAME>
		<TELL "?\"" CR>
		<COND (<SAID-YES? <>>
		       <GENDER-PRINT "\"Mr " "\"Ms ">
		       <PRINT-FULL-NAME>
		       <TELL "?\"" CR>
		       <COND (<SAID-YES? <>>
			      <TELL "\"This is Myrtle? The waitress from
the restaurant? I was just wondering, did you recall to leave me a gratuity
this morning?\"" CR>
			      <COND (<SAID-YES? <>>
				     <TELL "\"That's funny, I didn't get it.
Next time you really should find m..." CR>)
				    (T
				     <TELL "\"Oh. Well, you really should ha..."
					   CR>)>
			      <TELL CR "The line is disconnected. For a moment
you hear a hum, and then voices." CR>
			      <QUEUE I-SAY-VOICES 1>
			      <VOICES-ONLINE? T>
			      <PUTP ,LAV-LOBBY ,P?HEAR ,RANDOM-OBJECT>
			      <MAKE ,AIRPHONE ,TOUCHED>)
			     (T
			      <TELL "The caller mutters something about
scatterbrained flight attendants and hangs up."
				    CR>)>)
		      (T
		       <TELL "The caller curses very inventively for a while,
then hangs up."
			     CR>)>)
	       (T
		<TELL "But it's not ringing." CR>)>
	 T)
	(<VERB? HANGUP>
	 <PUTP ,LAV-LOBBY ,P?HEAR 0>
	 <COND (<IS? ,AIRPHONE ,TOUCHED>
		<UNMAKE ,AIRPHONE ,TOUCHED>
		<MAKE ,AIRPHONE ,OPENED>
		<TELL "The phone">
		<COND (<IN? ,BEEZER ,AIRPHONE>
		       <MOVE ,BEEZER ,PLAYER>
		       <TELL " spits out your " D ,BEEZER ", and">)>
		<TELL " thanks you for your business." CR>)
	       (T
		<TELL "You weren't using it anyway." CR>)>)>>

<DEFINE I-SAY-VOICES ("OPT" (CR T))
  <COND (<AND <HERE? LAV-LOBBY>
	      <T? <VOICES-ONLINE?>>
	      <IS? ,AIRPHONE ,TOUCHED>>
	 <PUTP ,LAV-LOBBY ,P?HEAR 0>
	 <COND (.CR <ZCRLF>)>
	 <TELL
"\"Uh, Roger, Air Zalagasa 612, say your message.\"|
|
\"Uh, Air Zalagasa 612, we have engine failure and our ">
	 <COND (<G=? <MEAL-SEAT> ,SEAT-D>
		<TELL "starboard">)
	       (T
		<TELL "port">)>
	 <TELL " wing is about to drop off. We anticipate
a crash situation at this time.\"|
|
\"Roger, Air, uh, Zalagasa 612, estimate your crash time please.\"|
|
\"Air Zalagasa 612, about five minutes from now.\"|
|
\"Understood. By the way, there was no crash filed for this time in your flight
plan. You really should apply in triplicate for permission to crash, at least
half an hour before take off.\"|
|
Click.|
|
You hang up." CR>
	 <VOICES-ONLINE? <>>
	 <UNMAKE ,AIRPHONE ,TOUCHED>
	 <CRASH-COMING? T>
	 T)
	(T <>)>>

<OBJECT CHUTE
	(DESC "parachute")
	(FLAGS TAKEABLE WORN CLOTHING CONTAINER TRANSPARENT)
	(SYNONYM CHUTE PARACHUTE STRAP STRAPS LINE LINES SHROUD
		 KA\'ABI)
	(ADJECTIVE CHUTE PARACHUTE STINGLAI)
	(SIZE 10)
	(ACTION CHUTE-F)>

<SETG CHUTE-SCORED? <>>

<DEFINE CHUTE-F CHUTE ()
	 <COND (<VERB? STINGLAI>
		<RETURN <> .CHUTE>)
	       (<F? <LOC ,CHUTE>>
		<COND (<IS? ,HERE ,IN-AIRPLANE>
		       <CANT-SEE-ANY ,CHUTE>
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
			      <TELL "caught in the plane's hatch." CR>)
			     (<HERE? IN-AIR>
			      <TELL "fluttering in the breeze." CR>)
			     (<HERE? IN-TREE>
			      <TELL "hopelessly tangled in the tree." CR>)
			     (<IS? ,CHUTE ,WORN>
			      <TELL "looped around your shoulders." CR>)
			     (T
			      <TELL "just sitting there." CR>)>
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
		       <COND (<ON-PLANE?>
			      <TELL ".|
|
Congratulations! You now get to observe the horns of a dilemma. Should you
crash into the jungle with the " D ,PLANE ", and undoubtedly die, or jump out of
the " D ,PLANE " with a ruined parachute, and undoubtedly die? Fortunately, you'll
have lots of time to weigh the pros and cons, because...">
			      <JIGS-UP>)
			     (T
			      <LOOSEN-CHUTE>)>
		       <RETURN T .CHUTE>)>)>
	 <COND (<THIS-PRSI?>
		<COND (<VERB? PUT-ON EMPTY-INTO>
		       <IMPOSSIBLE>
		       <RETURN T .CHUTE>)>
		<RETURN <> .CHUTE>)
	       (<VERB? EXAMINE LOOK-ON READ>
		<COND (<F? <LOC ,CHUTE>>
		       <TELL CTHEO " is falling, somewhat faster than you. Perhaps you'll catch up with it in another life." CR>
		       <RETURN T .CHUTE>)
		      (<HERE? OUTSIDE-PLANE>
		       <TELL CTHEO
" is strapped to your back, which is good, and caught in the emergency exit of the plane, which is bad." CR>
		       <RETURN T .CHUTE>)
		      (<CHUTE-OPEN?>
		       <TELL
"You just make out the words \"Chowmail Overnite\" written on " THEO ,PERIOD>
		       <RETURN T .CHUTE>)>
		<TELL
"It's on your back, you know, so you can't tell much">
		<COND (<IN? ,RIPCORD ,PRSO>
		       <TELL
". A red ripcord is fluttering nearby, though">)>
		<ZPRINT ,PERIOD>
		T)
	       (<F? <LOC ,CHUTE>>
		<TELL ,CANT "reach " THEO ,PERIOD>)
	       (<VERB? TAKE-OFF DROP EXIT>
		<COND (<IS? ,CHUTE ,WORN>
		       <TELL "You cleverly slip " THEO " off your back">
		       <COND (<ON-PLANE?>
			      <UNMAKE ,CHUTE ,WORN>
			      <MOVE ,CHUTE ,PLAYER>
			      <TELL ,PERIOD>)
			     (T
			      <LOOSEN-CHUTE>)>
		       T)
		      (<VERB? DROP>
		       <>)
		      (T
		       <TELL "You aren't wearing " THEO ,PERIOD>)>)
	       (<VERB? OPEN UNFOLD>
		<OPEN-CHUTE>
		T)
	       (<VERB? CLOSE FOLD>
		<COND (<IS? ,PRSO ,OPENED>
		       <TELL "Easier said than done." CR>)
		      (T
		       <ALREADY-CLOSED>)>
		T)
	       (<AND <VERB? WEAR>
		     <HERE? IN-AIR>
		     <NOT ,CHUTE-SCORED?>
		     <NOT <IS? ,PRSO ,WORN>>>
		; "Make sure we're not wearing the chute, and haven't
		   already scored this point"
		<V-WEAR>
		<UPDATE-SCORE 1>
		<SETG CHUTE-SCORED? T>
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
	 <COND (<ON-PLANE?>
		<TELL
"The size of even a modest parachute is fairly impressive when compared to
the cramped quarters inside an " D ,PLANE ". By the time you manage to untangle
yourself (and several other passengers) from the various straps, shrouds,
canopies, and cords, it's too late to jump: the " D ,PLANE " has crashed into the
jungle.">
		<JIGS-UP>
		<RETURN T .CHUTE>)
	       (<CHUTE-OPEN?>
		<TELL
"You yank on " THE ,RIPCORD " again, but as " THE ,CHUTE
" is already deployed, nothing happens." CR>
		<RETURN T .CHUTE>)
	       (<HERE? OUTSIDE-PLANE>
		<TELL
"Things were bad enough with your " Q ,CHUTE " straps caught in the hatch. Pulling " THE ,RIPCORD ", as you might well have expected, has added the complication of a deployed " Q ,CHUTE " as well. The various straps, cords and other " Q ,CHUTE " paraphernalia, each going its own merry way, send you flying in a number of very unpleasant pieces.">
		<JIGS-UP>
		<RETURN T .CHUTE>)
	       (<NOT <IS? ,CHUTE ,WORN>>
		<TELL
"When a parachute opens, it wants to decelerate rather rapidly. That's why
people wear them -- when they're falling out of airplanes, they normally want
to decelerate as well. Unfortunately, you've just encountered various of the
laws of physics, which result in the chute decelerating and ripping itself
out of your hands. The sight of the canopy billowing high above you is a great
comfort as you plunge to your death.">
		<JIGS-UP>
		<RETURN T .CHUTE>)>
	 <UNMAKE ,CHUTE ,TRANSPARENT>
	 <MAKE ,CHUTE ,OPENED>
	 <TELL
CTHE ,CHUTE " opens. You are floating serenely through a clear blue sky which is
unfortunately totally obscured by thick black clouds." CR>
	 T>

<OBJECT RIPCORD
	(LOC CHUTE)
	(DESC "ripcord")
	(FLAGS TRYTAKE NOALL NODESC)
	(SYNONYM CORD RIPCORD)
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
	 <TELL CR
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
	       (<AND <==? .CONTEXT ,M-BEG>
		     <VERB? LOOK>>
		<MAKE ,OUTSIDE-PLANE ,SEEN>
		<TELL "Good move. You are not falling through midair. The
aircraft door has blown shut again, trapping your parachute straps, from
which you are dangling." CR>
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

<DEFINE GO-OUTSIDE-PLANE ()
	 <SETG CHUTE-SCORED? T>
	 <UPDATE-SCORE 1>
	 <ZCRLF>
	 <QUEUE I-OUTSIDE-PLANE>
	 <GOTO ,OUTSIDE-PLANE>>

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
"You are currently freezing to death from the -20 degree temperature, you're suffocating from the rarified 30,000 foot air, and, as if these weren't bad enough, you're trailing about fifteen feet behind the escape hatch of your flight to Zalagasa, which you really didn't want to be on anyway." CR>
		<RETURN T .OUTSIDE>)
	       (<EQUAL? .SCRIPT 2>
		<TELL
"You now have a fine view through the window of the plane's hatch. Inside, the passengers and crew seem to be doing very little of the sort of freezing and suffocating that you are beginning to become accustomed to. ">
		<LOOK-IN-HATCH>
		<RETURN T .OUTSIDE>)
	       (<EQUAL? .SCRIPT 1>
		<TELL
"Do you realise that you are freezing to death even as you suffocate? Just a rhetorical question." CR>
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
" who was kind enough to give you a parachute is standing with her back to the window." CR>>

<DEFINE I-FALLING FALLING ("AUX" SCRIPT (FLOAT <>) (VAL <>))
	 <SET FLOAT <CHUTE-OPEN?>>
	 <SET SCRIPT <FALL-SCRIPT>>
	 <FALL-SCRIPT <SET SCRIPT <- .SCRIPT 1>>>
	 <COND (<AND .FLOAT
		     <F? <NERD-FLEW-BY?>>>
		<NERD-FLEW-BY? T>
		<SET VAL T>
		<TELL CR CTHE ,NERD " falls past you. He starts to try to sell you a walking stick for ">
		<SAY-NERD-MONEY>
		<TELL " but is gone before he has time to
speak. He has no parachute. This does not seem to worry him at all." CR>)>
	 <COND (<EQUAL? .SCRIPT 2>
		<COND (<ZERO? .FLOAT>
		       <TELL CR
			     "You're plummeting downward at an alarming rate."
			     CR>
		       <RETURN T .FALLING>)>
		<RETURN .VAL .FALLING>)
	       (<EQUAL? .SCRIPT 1>
		<COND (<ZERO? .FLOAT>
		       <TELL CR
"The ground is getting very close, very quickly." CR>)
		      (T
		       <TELL CR "Your downward drift continues." CR>)>
		<RETURN T .FALLING>)
	       (<T? .FLOAT>
		<DEQUEUE I-FALLING>
		<GOTO ,IN-TREE <>>
		<TELL CR "Crunch! You have landed in a tree. Dozens of Ai-Ais
cluster about you briefly, then flee in terror. Yet again, $25,000 has evaded
your grasp" ,PCR>
		<V-LOOK>		
		<TELL CR
"Your philosophical side tells you, \"It could be worse; it could be raining,\" while your rational side tells you that, in fact, it is." CR>       
		<RETURN T .FALLING>)>
	 <HIT-GROUND>
	 <RETURN T .FALLING>>

<DEFINE GET-SEX (WHICH)
  <COND (<EQUAL? .WHICH ,MOMMA-PERSON ,GRANDMA-PERSON> T)
	(T <>)>>