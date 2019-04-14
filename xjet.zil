"XJET for BUREAUCRACY: Copyright 1987 Infocom, Inc. All rights reserved."

<FILE-FLAGS MDL-ZIL?>

<INCLUDE "XJETDEFS">

"New Bywater theory"

<DEFINE GO-TO-PLANE ()
	 <ZREMOVE ,ZTICKET>
	 <DEQUEUE I-TERMINAL>
	 <DEQUEUE I-ZALAGASA-DESK>
	 <DEQUEUE I-DESK>
	 <QUEUE I-PHONES>
	 <MAKE ,SEATBELT ,WORN>
	 <MOVE ,SEATBELT ,PLAYER>
	 <SETG HERE ,SEAT>
	 <MOVE ,PLAYER ,HERE>
	 ; "Put smoker/non-smoker in next seat."
	 <INITIALIZE-SEATS>
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

<OBJECT CALL-BUTTON
	(LOC SEAT)
	(DESC "attendant button")
	(FLAGS VOWEL NODESC)
	(SYNONYM BUTTON)
	(ADJECTIVE CALL ATTENDANT)
	(ACTION PLANE-BUTTON-F)>

<OBJECT LIGHT-BUTTON
	(LOC SEAT)
	(DESC "light button")
	(FLAGS NODESC)
	(SYNONYM BUTTON SWITCH)
	(ADJECTIVE LIGHT)
	(ACTION PLANE-BUTTON-F)>

<OBJECT RECLINE-BUTTON
	(LOC SEAT)
	(DESC "recline button")
	(FLAGS NODESC)
	(SYNONYM BUTTON)
	(ADJECTIVE RECLINE)
	(ACTION PLANE-BUTTON-F)>

<DEFINE PLANE-BUTTON-F ()
  <COND (<THIS-PRSI?> <>)
	(<VERB? PUSH>
	 <COND (<T? <BUTTONS-OFF?>>
		<COND (<F? <PHONES-PLUGGED-IN?>>
		       <TELL
			"You hear a tiny metallic voice whispering nearby."
			CR>)
		      (<NOT <IS? ,PHONES ,WORN>>
		       <TELL
			"You hear a small metallic voice whispering nearby."
			CR>)
		      (T
		       <TELL "\"Welcome to seat ">
		       <SAY-AFFECTED-SEAT ,PRSO>
		       <TELL
". Your Comf-O-Mat electrically-controlled passenger station has been
centrally disabled at this time for your comfort and safety. We will be
making this facility available to you after takeoff, or after we reach
our assigned cruising altitude. Or possibly after we have finished reading
the passenger manifest and laughing at your silly names. Oops. This is a
recording.\"" CR>)>)
	       (<PRSO? CALL-BUTTON>
		<LIGHT-UP-SEAT>)
	       (<PRSO? LIGHT-BUTTON>
		<RECLINE-SEAT>)
	       (T
		<CALL-SEAT>)>)>>

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
	   <COND (<==? .START ,SEAT-A>
		  <SET START ,SEAT-D>)
		 (T
		  <SET START </ .START 2>>)>
	   <SET OFFS <+ .OFFS 1>>)
	  (T
	   <COND (<==? .START ,SEAT-D>
		  <SET START ,SEAT-A>)
		 (T
		  <SET START <* .START 2>>)>
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

<DEFINE RECLINE-SEAT ("AUX" (ROW <GEN-ROW 3>) (SEAT <GEN-SEAT -1>) WHO)
  <COND (<AND <==? .ROW 3>
	      <==? .SEAT ,SEAT-A>
	      <T? <MEAL-HERE?>>>
	 <TELL "There is a dreadful wet squelch from towards the front of the
cabin, and, briefly, a whiff of something truly hellish." CR>
	 <MEAL-SQUASHED? T>)
	(<F? <MEAL-HERE?>>
	 <TELL "You hear an angry cry from ">
	 <COND (<G? .ROW ,CURRENT-ROW>
		<TELL "behind">)
	       (T
		<TELL "ahead">)>
	 <TELL ", but can't determine the cause." CR>)
	(T
	 <DESCRIBE-SPLAT .ROW .SEAT>)>>

<DEFINE DESCRIBE-SPLAT (ROW SEAT "AUX" (WHO <GET-OCCUPANT .ROW .SEAT>))
  <COND (<F? .WHO>
	 <TELL "As nearly as you can tell, nothing happens." CR>)
	(T
	 <QUEUE I-CLEANUP-FOOD 2>
	 <COND
	  (<F? <RANDOM-PERSON-F ,M-FACE-IN-FOOD .WHO>>
	   <TELL "There is a wet squelch and a hoarse shout of dismay from
the ">
	   <COND (<G? .ROW ,CURRENT-ROW>
		  <TELL "back">)
		 (T
		  <TELL "front">)>
	   <TELL " of the cabin." CR>)>)>>

<CONSTANT SEAT-LIGHTS <ITABLE (BYTE)
			      </ <+ ,AISLE-COUNT 1> 2>>>

<DEFINE LIGHT-UP-SEAT LUS ("AUX" (ROW <GEN-ROW -1>)
		       (SEAT ,CURRENT-SEAT) (BIT .SEAT) OFFS BITS WHICH)
  <COND (<0? <MOD .ROW 2>> <SET BIT <* .SEAT 16>>)>
  <COND (<OR <==? ,CURRENT-ROW 1>
	     <F? <SET WHICH <SAY-HEAD .ROW .SEAT>>>>
	 <TELL "You don't notice any changes." CR>
	 <RETURN T .LUS>)>
  <COND (<BTST <SET BITS <GETB ,SEAT-LIGHTS <SET OFFS </ .ROW 2>>>>
	       .BIT>
	 ; "Lights already on"
	 <PUTB ,SEAT-LIGHTS .OFFS <ANDB .BITS <XORB .BIT -1>>>
	 <TELL " stops shining.">)
	(T
	 <TELL " starts to shine.">
	 <PUTB ,SEAT-LIGHTS .OFFS <ORB .BITS .BIT>>)>
  <ZCRLF>>
	
<DEFINE SAY-HEAD (ROW SEAT "AUX" WHICH)
  <COND (<T? <SET WHICH <GET-OCCUPANT .ROW .SEAT>>>
	 <TELL "The head of the ">
	 <COND (<==? <SET WHICH <GET-OCCUPANT .ROW .SEAT>> -1>
		<TELL "person">)
	       (T
		<RANDOM-PERSON-F ,M-SHORTDESC .WHICH>)>
	 <TELL " in front of you">)
	(T <>)>>

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
	       <TELL "The in-flight magazine is packed with useful information
about duty-free cigarettes, interesting llama-wool clothes and pygmy hog
breeding. There is a competition prize of $25,000 for the best photograph
of the amazingly rare Ai-Ai, and a long article which tells you far more
than you wanted to know about the damned creature, illustrated with a
fuzzy photograph which could equally well be a dingo's armpit on a dark
night, and another article on the legendary Zalagasan princess Ani-Ta'a,
a hypermanic virago who, according to the caption below her picture, could
enslave men and terrify babies at a single glance.|
|
The last item you read is a particularly boastful and disgusting article
on the various types of cannibalism priacticed in Zalagasa. Hardly any of
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
in a shiny Air Zalagasa airplane to which all sorts of terrible things are
happening.|
|
The first picture shows a happy smiling stewardess waving her arms in the
air. The second picture shows some happy, smiling Zalagasan passengers
cheerfully rmemoving false teeth, wigs, glass eyes, spectacles, and ornamental
nose bones. The third picture shows some Zalagasan passengers who are almost
certainly happy and smiling but you can't tell because they are all bent
double, clasping their knees. The fourth picture appears to have been chewed
off by a llama or something, so you can't tell what the happy, smiling
Zalagasans which it undoubtedly showed were actually doing." CR>)>>

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
  <COND (<EQUAL? .WHICH ,MOMMA-PERSON ,GRANDMA-PERSON> T)
	(T <>)>>

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
	<COND (<AND <==? ,CURRENT-SEAT ,SEAT-A>
		    <==? ,CURRENT-ROW 3>
		    <F? <MEAL-SQUASHED?>>
		    <T? <MEAL-HERE?>>>
	       <TELL "Gingerly edging past your dish of virulent food, you
get out of your seat" ,PCR>)
	      (<OR <AND <==? ,CURRENT-SEAT ,SEAT-A>
			<SET NEIGHBOR <GET-SEAT ,SEAT-B>>>
		   <AND <==? ,CURRENT-SEAT ,SEAT-D>
			<SET NEIGHBOR <GET-SEAT ,SEAT-C>>>>
	       <COND (<PROB 20>
		      <TELL "You stumble over your neighbor's feet as you leave your seat, causing some irritated mutterings" ,PCR>)>)>>

<CONSTANT NORMAL-SEAT
	  <PLTABLE SEATBELT SEAT-POCKET UNDER-SEAT CALL-BUTTON
		   LIGHT-BUTTON RECLINE-BUTTON RECEPTACLE>>
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
	 <COND (<NOT <META-IN? ,SAFETY-SECOND ,PLAYER>>
		<REMOVE ,SAFETY-SECOND>)>
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
<MSETG BABY-OBJECT <+ ,OBJECT-BREAK 5>>
<MSETG MOVIE-OBJECT <+ ,OBJECT-BREAK 6>>

<MSETG SMOKER-PERSON 1>
<MSETG GRANDMA-PERSON 2>
<MSETG MOMMA-PERSON 3>
<MSETG BALD-PERSON 4>
<MSETG FAT-PERSON 5>
<MSETG POLITICIAN-PERSON 6>
<MSETG ZALAGASAN-PERSON 7>
<MSETG PERSON-COUNT 7>

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
	(<==? .WHICH ,GRANDCHILDREN-OBJECT>
	 <TELL "grandchildren">)
	(<==? .WHICH ,MEAL-OBJECT>
	 <TELL "meal">)
	(<==? .WHICH ,BABY-OBJECT>
	 <TELL "baby">)
	(<==? .WHICH ,MOVIE-OBJECT>
	 <TELL "movie">)>>

<DEFINE ON-PLANE? ()
  <COND (<IS? ,HERE ,IN-AIRPLANE> T)
	(T <>)>>

<DEFINE RANDOM-OBJECT-F ("OPT" (CONTEXT <>)
			 "AUX" (WHICH <GETP ,RANDOM-OBJECT ,P?PSEUDO-TABLE>)
			       STR)
	<COND (<==? .WHICH ,HATCH-OBJECT>
	       <COND (<==? .CONTEXT ,M-OBJDESC>
		      <TELL "escape hatch">)
		     (<T? .CONTEXT> <>)
		     (<NOT <EQUAL? ,HERE ,LAV-LOBBY ,OUTSIDE-PLANE>>
		      <CANT-SEE-ANY <> "the hatch">)
		     (<THIS-PRSI?>
		      <>)
		     (<VERB? EXAMINE>
		      <COND (<G? <HATCH-OPEN?> 1>
			     <TELL "The hatch is open." CR>)
			    (T
			     <TELL "It is incredibly complicated with a huge
handle saying \"LIFT THEN PULL\" although you can bet it's not as easy as
that." CR>)>)
		     (<VERB? LIFT>
		      <COND (<G? <HATCH-OPEN?> 0>
			     <TELL "Determined to win your bet, are you?" CR>
			     <HATCH-LOSER? T>)
			    (T
			     <HATCH-OPEN? 1>
			     <TELL "That wasn't too bad. Bet the next step is
a real killer." CR>)>)
		     (<VERB? PULL>
		      <COND (<0? <HATCH-OPEN>>
			     <TELL "Determined to win your bet, are you?" CR>
			     <HATCH-LOSER? T>)
			    (T
			     <HATCH-OPEN 2>
			     <COND (<T? <HATCH-LOSER?>>
				    <TELL "Although you tried, y">)
				   (T
				    <TELL "Y">)>
			     <TELL "ou lost your bet. It is as easy as that"
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
\"We aren't going to crash after all--it was just a computer malfunction.
Thank you for choosing Air Zalagasa, and have a nice day.\"|
|
She frees the ripcord and you plummet down" ,PCR>
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
		   ,SMOKER-PERSON>>

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

<DEFINE LAV-LOBBY-F ("OPT" (CONTEXT <>) "AUX" (HO <HATCH-OPEN?>))
  <COND (<==? .CONTEXT ,M-ENTERING>
	 <SETG CURRENT-ROW ,AISLE-COUNT>
	 <>)
	(<AND <==? .CONTEXT ,M-BEG>
	      <G=? .HO 2>>
	 <COND (<VERB? JUMP>
		<TELL "No." CR>
		<COND (<G=? <SET HO <+ .HO 1>> 4>
		       <TELL CR ">">
		       <PRINTC <INPUT 1>>
		       <TELL "Too late to say anything now. The slipstream has
pulled you out of the aircraft and you think you are falling through the air."
			     CR>
		       <HATCH-OPEN? 0>
		       <GO-OUTSIDE-PLANE>)>
		T)
	       (T
		<TELL "The rush of air exiting the cabin keeps you from
moving." CR>
		T)>)
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
	(SDESC "sink")
	(FLAGS NODESC)
	(SYNONYM SINK BASIN)
	(ADJECTIVE LAVATORY)
	(ACTION SINK-F)>

<DEFINE SINK-F ()
  <COND (<THIS-PRSO?>
	 <COND (<VERB? CLEAN>
		<TELL "It's already pretty clean." CR>)
	       (<VERB? EXAMINE LOOK-INSIDE>
		<TELL "It's an ordinary spotless airplane sink."
		      CR>)>)>>

<OBJECT LAVATORY
	(LOC ROOMS)
	(OUT TO LAV-LOBBY IF LAV-DOOR IS OPEN ELSE
	 "Better open the door first.")
	(NORTH TO LAV-LOBBY IF LAV-DOOR IS OPEN ELSE
	 "Better open the door first.")
	(SYNONYM LAVATORY BATHROOM CAN LAV)
	(DESC "Lavatory")
	(LDESC "You are in the bathroom. There is a washbasin, a W.C., and an electric socket here.")
	(FLAGS IN-AIRPLANE LOCATION LIGHTED INDOORS NO-NERD)
	(THINGS SEAT-PSEUDO-VEC)
	(GLOBAL LAV-DOOR FLIGHT-ATTENDANT SEATBELT-LIGHT)
	(ACTION LAVATORY-F)>

<CONSTANT BATHROOM-LOCKED
	  <PLTABLE "the sound of tuneful bassoon-playing"
		   "the sound of frantic typing"
		   "what could be a pygmy hog giving birth to an exceptionally
large litter"
		   "a champagne cork popping">>

<DEFINE LAVATORY-F LAV ("OPT" (CONTEXT 0))
  <COND (<==? .CONTEXT ,M-ENTERING>
	 <SETG CURRENT-ROW ,AISLE-COUNT>
	 <COND (<IS? ,LAV-DOOR ,LOCKED>
		<SETG HERE ,LAV-LOBBY>
		<MOVE ,PLAYER ,HERE>
		<TELL "The bathroom is engaged. From within, you hear "
		      PONE ,BATHROOM-LOCKED ,PCR>
		<RETURN T .LAV>)>
	 <UNMAKE ,LAV-DOOR ,OPENED>
	 <MAKE ,LAV-DOOR ,LOCKED>
	 <COND (<AND <T? <MEAL-EATEN?>>
		     <F? <QUEUED? I-DIE-IN-LAV>>>
		<QUEUE I-DIE-IN-LAV 5>)>
	 <TELL "Naturally, you close and lock the door when you enter" ,PCR>
	 <>)
	(<==? .CONTEXT ,M-EXIT>
	 <MAKE ,LAV-DOOR ,OPENED>
	 <UNMAKE ,LAV-DOOR ,LOCKED>
	 <>)
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

<DEFINE GO-OUTSIDE-PLANE ()
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
" who was kind enough to give you a parachute is standing with her back to the window." CR>>

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
			     <TELL "\"I'm sorry, " <STR-SIR-OR-MAAM>
				   ", but I'm not authorized to say anything about that.\"">)>)>)
	      (<VERB? RING-FOR>
	       <COND (<NOT <EQUAL? ,HERE ,SEAT>>
		      <TELL ,CANT "find anything to summon one with."
			    CR>)
		     (T
		      <PERFORM ,V?PUSH ,CALL-BUTTON>)>)
	      (T
	       <TELL "There doesn't seem to be a " D ,FLIGHT-ATTENDANT
		     " nearby. Perhaps you should ring for one." CR>
	       <COND (<VERB? TELL>
		      <PCLEAR>
		      ,FATAL-VALUE)
		     (T T)>)>>



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
	 <TELL "As you may recall, it's an electric toothbrush. You should
plug it in and turn it on first." CR>)
	(T
	 <TELL "In our advanced culture, it's traditional to use " A
	       ,TOOTHBRUSH " for this particular task." CR>)>>

<OBJECT TOOTHBRUSH
	(DESC "toothbrush")
	(SYNONYM TOOTHBRUSH BRUSH)
	(ADJECTIVE TOOTH ELECTRIC)
	(FLAGS TAKEABLE TOOL)
	(ACTION TOOTHBRUSH-F)>

<DEFINE TOOTHBRUSH-F ()
  <COND (<THIS-PRSO?>
	 <COND (<VERB? USE>
		<DO-BRUSH-TEETH>)
	       (<VERB? LAMP-ON>
		<COND (<IS? ,TOOTHBRUSH ,TOUCHED>
		       <TELL "Unfortunately the flow of current into the
toothbrush creates a colossal electric surge in the W.C. flushing mechanism.
The resulting suction draws you inexorably into the pan and through the little
aluminium flap....." CR>
		       <JIGS-UP>)>)
	       (<VERB? UNPLUG>
		<UNMAKE ,TOOTHBRUSH ,TOUCHED>
		<TELL
		 "Go ahead, but you'll never get your teeth clean that way."
		 CR>)
	       (<VERB? PLUG>
		<MAKE ,TOOTHBRUSH ,TOUCHED>
		<TELL "OK." CR>)>)
	(<THIS-PRSI?>
	 <COND (<N==? ,PRSO ,TEETH>
		<TELL "That hardly seems necessary." CR>)
	       (T
		<DO-BRUSH-TEETH>)>)>>

<OBJECT AIRLINE-MEAL
	(DESC "noisome stew")
	(SYNONYM SPECIALTY FOOD MEAL STEW DINNER LLAMA)
	(ADJECTIVE ZALAGASAN LLAMA)
	(GENERIC GENERIC-FOOD-F)
	(ACTION AIRLINE-MEAL-F)>

<VOC "CHICKEN">
<VOC "KIEV">
<VOC "FILET">

<DEFINE AIRLINE-MEAL-F ()
  <COND (<THIS-PRSO?>
	 <COND (<VERB? TAKE>
		<TELL "As you terribly, terribly warily pick up your hateful
food, a flight attendant appears. His expression speaks louder than words.
You put the food back on your table.|
|
\"Please finish your delicious Zalagasan delicacy, " <STR-SIR-OR-MAAM>
",\" says the attendant." CR>
		T)
	       (<OR <VERB? THROW DROP>
		    <HURTING?>>
		<TELL "Realising the danger that some of the hateful food
might splash back on yourself, you think better of it." CR>)
	       (<VERB? EAT>
		<TELL "You hold your breath and cram the disgusting food into
your mouth. It writhes distinctly on the way down. You hear groans of disgust
and disbelief from your fellow passengers." CR>
		<FOOD-EATEN? T>
		<QUEUE I-ATE-FOOD 2>
		T)
	       (<VERB? EXAMINE>
		<COND (<LOOKED-AT-FOOD?>
		       <TELL "Very well. It's horrible. At first you think
\"Ho hum, don't mind eating it, but I wouldn't want to tread in it\" but then
you decide that it's even worse than that. It seems to be composed of old
shoe-leather and a number of small greenish, mutated things with too many
heads. Innumerable tiny eyes peer up at you from the plate." CR>)
		      (T
		       <LOOKED-AT-FOOD? T>
		       <TELL "You don't want to." CR>)>)
	       (<VERB? SMELL>
		<TELL "It gives off a hogo you could hang your hat on. The top
note is brassy and farinaceous, with a hot blast of rubber and photographic
fixer, and an underlying hint of mossy teeth and old man's vest." CR>)
	       (<VERB? PUT>
		<COND (<PRSI? SEAT-POCKET>
		       <TELL PONE ,FOOD-IN-POCKET CR>)
		      (T
		       <TELL "You seem to have developed a sneaking affection
for " THEI ", which is incompatible with forcing this into it." CR>)>)>)
	(<THIS-PRSI?>
	 <COND (<VERB? TRADE-FOR>
		<TELL "Everyone around you seems to have finished eating already. And it looked wonderful, too." CR>)>)>>

<CONSTANT FOOD-IN-POCKET
	  <PLTABLE "As you gingerly pick up your bowl of hateful
food, the flight attendant appears. You read her mind. It says \"I can read
your mind, buster. Put that food down or else.\"|
|
You put the food down again."
		   "As you grasp the edge of the bowl to execute this cunning
plan, something in your food definitely twitches. You recoil in horror.">>

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
"You just make out the words \"Chowmail Overnight\" written on " THEO ,PERIOD>
		       <RETURN T .CHUTE>)>
		<TELL
"It's on your back, you know, so you can't tell much">
		<COND (<IN? ,RIPCORD ,PRSO>
		       <TELL
". A red handle attached to a cord is fluttering nearby, though">)>
		<ZPRINT ,PERIOD>
		T)
	       (<VERB? LOOK-ON READ>
		<TELL "The words \"Chowmail Overnight\" are silkscreened on "
		      THEO ,PERIOD>
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
