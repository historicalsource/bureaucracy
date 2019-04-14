"AIRPORT for BUREAUCRACY: Copyright 1987 Infocom, Inc. All rights reserved."

"Current airport theory: There are N (,AIRPORT-ROOMS) parallel sets of rooms:
1 through N-1 are random airlines, N is Air Zalagasa. Every entrance except
N has a sign for Air Zalagasa; the first entrance you arrive at has a sign
for Omnia Gallia, which is accurate.
The Omnia Gallia desk is just being closed when you arrive at it; you are
directed to Air Zalagasa. Following the signs will lead you in a circle.
You have to go outside and find the entrance that isn't Air Zalagasa, where
you will find the AZ desk.
You can either exchange your ticket for a direct flight, which costs too much,
or you can get a flight through Zalagasa for the price of the ticket. Once
the ticket has been exchanged, you realise that the flight you've been hearing
about is the one you're on, and it's gonzo. The ticket agent refers you to
Omnia Gallia, since it's really their ticket.

1) You can't exchange your ticket until Omnia Gallia has been sold, which
happens when you see their desk.
2) You can't ever arrive at your gate: when you exchange tickets, you are
informed that the flight has already left the gate, so there's no gate to go
to. This happens even when the flight is recalled.
3) You must therefore recall the flight via the controllers, and arrive at
the gate on the shoulders of the cheering crowd. If you haven't exchanged
your ticket, you won't be allowed on the airplane, and will probably have
a stroke.
"

<FILE-FLAGS MDL-ZIL?>

<USE "NEWSTRUC">

<DEFINE-GLOBALS AIRPORT-GLOBALS
		(AIRPORT-ROOM-NUM:FIX BYTE 0)
		(OMNIA-GALLIA-ENTRANCE:FIX BYTE 0)
		(AIR-ZALAGASA-ENTRANCE:FIX BYTE 0)
		(AIRPORT-SEEN-BITS:FIX 0)
		(CURRENT-DESK-ID:FIX BYTE 0)
		(JUST-HEARD? BYTE 0)
		(JUST-PAGED? BYTE 0)
		(DESK-SCRIPT BYTE 0)
		(DESK-ZSCRIPT BYTE 0)
		(DESK-LOSER? BYTE 0)
		(CLERK-LISTENING? BYTE 0)
		(CLERK-WORKING? BYTE <>)
		(AT-ZALAGASA? BYTE 0)
		(WAITING-FOR-CASH? BYTE 0)
		(TICKET-SCREW? BYTE 0)
		(PILLAR-MENTIONED? BYTE <>)
		(DUCT-NUMBER BYTE 0)
		(FLIGHT-RECALLED? BYTE <>)
		(FLIGHT-GONE? BYTE <>)
		(TOWER-SCRIPT BYTE 4)
		(SPEAKER-DEAD? BYTE <>)
		(MUSIC-DEAD? BYTE <>)
		(AOS-BP? BYTE <>)
		(CHANGE-DESK? BYTE <>)>

<CONSTANT PATRONS <PLTABLE "the owner of a Baader-Meinhof shoulder-bag which
has just exploded outside the terminal"
			   "the Zalagasan Catering Corps representative"
			   "whoever has lost something which we don't know what it is"
			   "the Deep Thought Corporation repair crew"
			   "anyone interested in seeing some gladiator movies"
			   "anyone who fancies making some announcements like these"
			   "whoever dropped no tea in the main concourse"
			   "anyone finding a digital watch engraved 'Prosser'"
			   "anyone who knows where the white courtesy phone is located">>
;<CONSTANT PATRONS <PLTABLE "the owner of a large penguin named Dennis"
			       "the owner of a female ostrich named Daisy"
			       "Mr Steviros Meretziokolis"
			       "someone familiar with devil worship"
			       "the President of El Paso Blubber Corporation"
			       "Mr Arthur Dent"
			       "my mother"
			       "the Nobel Peace Prize winner of 1904"
			       "Professor Moriarty"
			       "a llama farmer"
			       "someone else"
			       "Queen Mum">>

; "So courtesy phone will be known, but never found"
<VOC "COURTESY" ADJ>
<VOC "WHITE" ADJ>
<VOC "WORKMAN" OBJECT>

<OBJECT AIRPORT
	(LOC GLOBAL-OBJECTS)
	(DESC "airport")
	(FLAGS NODESC VOWEL PLACE)
	(SYNONYM AIRPORT TERMINAL GATE BUILDING)
	(ADJECTIVE AIRPORT)
	(ACTION AIRPORT-F)>

<DEFINE AIRPORT-F ()
	 <COND (<NOT <IS? ,HERE ,IN-TERMINAL>>
		<COND (<VERB? WALK-TO>
		       <COND (<IS? ,HERE ,IN-TOWN>
			      <TELL "We'd suggest either sprouting wings and
flying, or calling a cab." CR>)
			     (T
			      <TELL "Perhaps you should grow some wings first."
				    CR>)>)
		      (T
		       <CANT-FROM-HERE>)>
		T)
	       (<AND <VERB? WALK-TO FIND>
		     <NOUN-USED? ,W?GATE>>
		<TELL "Aha! As we suspected, you haven't taken your airport
navigation course yet. Try again when you have." CR>)
	       (<HERE-F>
		T)
	       (T
		<>)>>

<OBJECT SKYCAPS
	(LOC LOCAL-GLOBALS)
	(DESC "skycaps")
	(FLAGS NODESC PLURAL LIVING PERSON)
	(SYNONYM SKYCAP SKYCAPS HANDLER HANDLERS)
	(ADJECTIVE BAGGAGE)
	(ACTION SKYCAPS-F)>

<CONSTANT SKYCAP-DOINGS
	<TABLE (LENGTH PATTERN (BYTE [REST WORD]))
	       #BYTE 0 
		"discussing the weather"
		"watching passengers struggle with their luggage"
		"talking about bad working conditions"
		"playing cards"
		"scratching themselves">>

<DEFINE SKYCAPS-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-WINNER>
		<TELL CTHE ,WINNER " make a point of ignoring you." CR>
		,FATAL-VALUE)
	       (<THIS-PRSI?>
		<COND (<VERB? GIVE SHOW>
		       <TELL CTHEI " show not the slightest interest." CR>
		       T)
		      (T <>)>)
	       (<VERB? TELL>
		<>)
	       (<VERB? HELLO WAVE-AT QUESTION THANK GOODBYE YELL>
		<TELL CTHEO
" don't seem to be paying attention to you, busy as they
are " PNEXT ,SKYCAP-DOINGS ,PERIOD>
		T)
	       (<VERB? EXAMINE WATCH>
		<TELL "They're " PNEXT ,SKYCAP-DOINGS ,PERIOD>
		T)
	       (<HURTING?>
		<TELL
"No use. It would only give the others something else to talk about." CR>
		T)
	       (T
		<>)>>

"*** AIRPORT CROWD ***"

<OBJECT AIRPORT-CROWD
	(LOC LOCAL-GLOBALS)
	(DESC "crowd")
	(FLAGS NODESC PERSON LIVING PLURAL)
	(SYNONYM CROWD PEOPLE ONLOOKERS EVERYONE EVERYBODY FOLKS)
	(ACTION AIRPORT-CROWD-F)>

<DEFINE AIRPORT-CROWD-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<T? .CONTEXT>
		<>)
	       (<THIS-PRSI?>
		<COND (<VERB? GIVE SHOW>
		       <TELL "Nobody in " THEI
			     " shows any interest in " THEO ,PERIOD>
		       T)
		      (T
		       <>)>)
	       (<VERB? TELL ASK-ABOUT ASK-FOR TELL-ABOUT YELL QUESTION
		       REPLY HELLO GOODBYE THANK>
		<COND (<T? <MUSIC-DEAD?>>
		       <TELL "The cheering of " THEO
			     " drowns out your words." CR>)
		      (<HERE? PILLAR-A PILLAR-B>
		       <TELL CTHEO 
 " look at you strangely, but don't respond." CR>)
		      (T
		       <CROWD-IGNORES-YOU>)>
		,FATAL-VALUE)
	       (<VERB? EXAMINE WATCH>
		<COND (<T? <MUSIC-DEAD?>>
		       <TELL CTHEO " are cheering wildly at you." CR>)
		      (<HERE? PILLAR-A PILLAR-B>
		       <TELL CTHEO 
			     " are obviously amused by your exploits." CR>)
		      (T
		       <CROWD-IGNORES-YOU>)>
		T)
	       (<VERB? WAVE-AT BOW>
		<COND (<T? <MUSIC-DEAD?>>
		       <TELL CTHEO " cheer all the louder." CR>)
		      (<HERE? PILLAR-A PILLAR-B>
		       <TELL "A few members of " THEO " wave back." CR>)
		      (T
		       <CROWD-IGNORES-YOU>)>
		T)
	       (<VERB? WALK-TO FIND>
		<COND (<HERE? PILLAR-A PILLAR-B>
		       <COND (<VERB? FIND>
			      <TELL "They're directly below you." CR>)
			     (T
			      <TELL "You could always climb down the pillar."
				    CR>)>)>)
	       (T
		<>)>>			    

<DEFINE CROWD-IGNORES-YOU ()
	 <TELL "Nobody pays any attention to you." CR>>

<DEFINE VISIT-AIRPORT ("OPT" (EXIT-ROUTINE? <>) "AUX" N)
	<AIRPORT-ROOM-NUM <SET N <ZRANDOM ,AIRPORT-ROOMS>>>
	<OMNIA-GALLIA-ENTRANCE .N>
	<COND (<L=? .N </ <+ ,AIRPORT-ROOMS 1> 2>>
	       <AIR-ZALAGASA-ENTRANCE ,AIRPORT-ROOMS>)
	      (T
	       <AIR-ZALAGASA-ENTRANCE 1>)>
	<REPEAT ((NN 1))
	  <AIRPORT-ROOM-NUM .NN>
	  <LIST-AIRLINES T>
	  <COND (<G? <SET NN <+ .NN 1>> ,AIRPORT-ROOMS>
		 <RETURN>)>>
	<AIRPORT-ROOM-NUM .N>
	<COND (<F? .EXIT-ROUTINE?>
	       <SETG HERE ,AIRPORT-ENTRANCE>
	       <MOVE ,PLAYER ,HERE>)>
	<COND (<META-IN? ,ABOOK ,HERE>
	       ; "Is loser carrying address book?"
	       <QUEUE I-LOSE-BOOK <ZRANDOM 7>>)>
	<QUEUE I-TERMINAL>
	<DEQUEUE I-TUNE-TIMER>
	;<SETG HUNGER 0>
	<TELL "You arrive at " THE ,AIRPORT ,PCR>
	<COND (<F? .EXIT-ROUTINE?>
	       <V-LOOK>
	       T)
	      (T
	       ,AIRPORT-ENTRANCE)>>

<DEFINE I-LOSE-BOOK LB ("AUX" (AL <LOC ,ABOOK>))
  <COND (<IN? ,ABOOK ,LANDF>
	 <ZREMOVE ,ABOOK>
	 <RETURN <> .LB>)
	(<META-IN? ,ABOOK ,PLAYER>
	 ; "Still carrying it?"
	 <COND (<HERE? IN-TOWER LANDF>
		<QUEUE I-LOSE-BOOK -1>
		<RETURN <> .LB>)>
	 <DEQUEUE I-LOSE-BOOK>
	 <ZCRLF>
	 <COND (<EQUAL? ,HERE ,PILLAR-A ,PILLAR-B ,DUCT ,TOWER-DUCT>
		<TELL CTHE ,ABOOK " falls out of ">
		<COND (<IN? ,ABOOK ,POCKET> <TELL D ,POCKET>)
		      (<NOT <IN? ,ABOOK ,PLAYER>>
		       <TELL THE .AL>)
		      (T <TELL "your grasp">)>
		<TELL " and ">
		<COND (<EQUAL? ,HERE ,PILLAR-A ,PILLAR-B>
		       <TELL "disappears into the crowd">)
		      (T
		       <TELL "slides out of sight down the duct">)>)
	       (<NOT <IN? ,ABOOK ,PLAYER>>
		<TELL "After a slight disturbance in the vicinity of ">
		<COND (<==? .AL ,POCKET> <TELL D .AL>)
		      (T <TELL THE .AL>)>
		<TELL ", you notice that your " D ,ABOOK " has vanished">)
	       (T
		<TELL "Amid the mob, you find that your " D ,ABOOK " has slipped out of your grasp">)>
	 <TELL ,PERIOD>)>
  <ZREMOVE ,ABOOK>
  T>

<OBJECT AIRPORT-ENTRANCE
	(LOC ROOMS)
	(DESC "Airport Entrance")
	(FLAGS IN-TERMINAL LIGHTED LOCATION SPECIAL-DROP)
	(NORTH PER ENTER-CONCOURSE)
	(IN PER INTO-CONCOURSE)
	(EAST PER NEXT-ENTRANCE)
	(SOUTH PER SOUTH-FROM-ENTRANCE)
	(WEST PER PREVIOUS-ENTRANCE)
	(OUT PER WHICH-WAY-OUT)
	(GLOBAL AIRPORT-CROWD SKYCAPS AIRPORT-MUSIC THE-FLIGHT SIGNS)
	(OVERHEAD SIGNS)
	(HEAR AIRPORT-MUSIC)
	(THINGS PSEUDO-VEC)
	(ACTION AIRPORT-ENTRANCE-F)>

<MSETG AIRPORT-ROOMS 5>

<DEFINE SOUTH-FROM-ENTRANCE ()
  <COND (<==? <AIRPORT-ROOM-NUM> ,AIRPORT-ROOMS>
	 ,LANDF)
	(T
	 <TELL "Busy traffic blocks your path." CR>
	 <>)>>

<DEFINE DO-LSH (CT "AUX" (BIT 1))
  <REPEAT ()
    <COND (<L? <SET CT <- .CT 1>> 1> <RETURN>)>
    <SET BIT <* .BIT 2>>>
  .BIT>

<DEFINE SEEN-BIT-HACK (RM FACT "AUX" BIT)
  <SET BIT <* <DO-LSH <AIRPORT-ROOM-NUM>> .FACT>>
  <SETG OLD-HERE <>>
  <COND (<NOT <BTST <AIRPORT-SEEN-BITS> .BIT>>
	 ;<0? <ANDB .BIT <AIRPORT-SEEN-BITS>>>
	 <UNMAKE .RM ,TOUCHED>
	 <AIRPORT-SEEN-BITS <ORB <AIRPORT-SEEN-BITS> .BIT>>)
	(T
	 <MAKE .RM ,TOUCHED>)>
  T>

<DEFINE INTO-CONCOURSE ()
  <COND (<==? <AIRPORT-ROOM-NUM> ,AIRPORT-ROOMS>
	 <TELL "[Which way do you want to go in, north or south?]" CR>
	 <>)
	(T
	 <ENTER-CONCOURSE>)>>

<DEFINE ENTER-CONCOURSE ()
  <CHANGE-DESK? T>
  <COND (<==? <AIRPORT-ROOM-NUM> <AIR-ZALAGASA-ENTRANCE>>
	 ,ZALAGASA-CONCOURSE)
	(T
	 <SEEN-BIT-HACK ,AIRPORT-CONCOURSE 32>
	 ,AIRPORT-CONCOURSE)>>

<DEFINE NEXT-ENTRANCE ("AUX" (N <AIRPORT-ROOM-NUM>))
  <COND (<==? .N ,AIRPORT-ROOMS>
	 <AIRPORT-ROOM-NUM 0>
	 <NEXT-ENTRANCE>)
	(T
	 <AIRPORT-ROOM-NUM <SET N <+ .N 1>>>
	 <SEEN-BIT-HACK ,AIRPORT-ENTRANCE 1>
	 ,AIRPORT-ENTRANCE)>>

<DEFINE PREVIOUS-ENTRANCE ("AUX" (N <AIRPORT-ROOM-NUM>))
  <COND (<==? .N 1>
	 <AIRPORT-ROOM-NUM <+ ,AIRPORT-ROOMS 1>>
	 <PREVIOUS-ENTRANCE>)
	(T
	 <AIRPORT-ROOM-NUM <SET N <- .N 1>>>
	 <SEEN-BIT-HACK ,AIRPORT-ENTRANCE 1>
	 ,AIRPORT-ENTRANCE)>>

<DEFINE AIRPORT-ENTRANCE-F ("OPT" (CONTEXT <>))
  <COND (<==? .CONTEXT ,M-ENTERING>
	 <LIST-AIRLINES T>)
	(<==? .CONTEXT ,M-LOOK>
	 <TELL "You're at an entrance marked:" CR>
	 <LIST-AIRLINES <>>
	 <TELL "Other entrances stretch off to the east and west">
	 <COND (<==? <AIRPORT-ROOM-NUM> ,AIRPORT-ROOMS>
		<TELL "; there's a Lost and Found office to the south">)>
	 <TELL ,PERIOD>
	 T)
	(T <>)>>

;"Theory of airlines: there are 32 airlines known about. Of these, two
  are special: Omnia Gallia and Air Zalagasa. Each entrance except
  AIR-ZALAGASA-ENTRANCE has a pointer to AZ and some other airlines.
  At that location in the concourse, there is some desk, neither AZ nor
  any of the other airlines mentioned on the sign. The exception is that
  OG's desk, which is closed, is always inside the entrance marked OG.
  Whenever you visit an entrance, one of the signs is being changed from
  X to Y."

<CONSTANT AIRLINE-NAMES
	  <PTABLE "Omnia Gallia" "Air Zalagasa"
		  "Nocturnal Aviation" "Trans-Galaxy Airlines"
		  "Agony Airlines" "Frontline Airlines"
		  "Flying Boxcar" "Untied"
		  "Northwest Accident" "Massive"
		  "Low Ceiling" "Pan Universal"
		  "Quantum Airways" "Gamma Airlines"
		  "People's Distress" "NewZork Air"
		  "British Underocean" "Air Frog"
		  "Air Worst" "Worsted Airlines"
		  "Air Moosehead" "Foster Airways"
		  "Kirin Airlines" "Air Laphroig"
		  "Air America" "Tickoff Air"
		  "KiwiAir" "Aerotica"
		  "Continental Breakfast" "General Aviation"
		  "Fred's" "BoingJets">>

<MSETG OMNIA-ID 0>
<MSETG ZALAGASA-ID 1>
<MSETG NOCTURNAL-ID -2>
<MSETG TRANS-GALAXY-ID -3>
<MSETG ALLEGHENY-ID 4>
<MSETG FRONTLINE-ID -5>
<MSETG BOXCAR-ID -6>
<MSETG UNTIED-ID 7>
<MSETG NORTHWEST-ID -8>
<MSETG MASSIVE-ID -9>
<MSETG BIG-SKY-ID -10>
<MSETG PAN-UNIVERSAL-ID -11>
<MSETG QUANTUM-ID -12>
<MSETG GAMMA-ID -13>
<MSETG DISTRESS-ID -14>
<MSETG NEWZORK-ID -15>
<MSETG BRITISH-ID -16>
<MSETG FROG-ID -17>
<MSETG WORST-ID 18>
<MSETG WORSTED-ID -19>
<MSETG MOOSEHEAD-ID 20>
<MSETG FOSTER-ID -21>
<MSETG KIRIN-ID -22>
<MSETG LAPHROIG-ID 23>
<MSETG AMERICA-ID 24>
<MSETG TICKOFF-ID -25>
<MSETG KIWI-ID -26>
<MSETG AEROTICA-ID 27>
<MSETG CONTINENTAL-ID -28>
<MSETG GENERAL-ID -29>
<MSETG FRED-ID -30>
<MSETG BOING-ID -31>

<CONSTANT AIRLINE-LOOKUP
	  <PLTABLE <VOC "OMNIA" ADJ> <VOC "GALLIA" OBJECT> ,OMNIA-ID
		  <VOC "AIR" ADJ> <VOC "ZALAGASA" OBJECT> ,ZALAGASA-ID
		  <VOC "NOCTURNAL" ADJ> <VOC "AVIATION" OBJECT> ,NOCTURNAL-ID
		  <VOC "TRANS" ADJ> <VOC "GALAXY" OBJECT> ,TRANS-GALAXY-ID
		  <VOC "TRANS-GALAXY" ADJ> <VOC "AIRLINES" OBJECT>
		  ,TRANS-GALAXY-ID
		  <VOC "AGONY" ADJ> <VOC "AIRLINES" OBJECT> ,ALLEGHENY-ID
		  <VOC "FRONTLINE" ADJ> <VOC "AIRLINES" OBJECT> ,FRONTLINE-ID
		  <VOC "FLYING" ADJ> <VOC "BOXCAR" OBJECT> ,BOXCAR-ID
		  <VOC "UNTIED" ADJ> <VOC "AIRLINES" OBJECT> ,UNTIED-ID
		  <VOC "NORTHWEST" ADJ> <VOC "ACCIDENT" OBJECT> ,NORTHWEST-ID
		  <VOC "NORTH" ADJ> <VOC "WEST" ADJ> ,NORTHWEST-ID
		  <VOC "NORTHWEST" ADJ> <VOC "AIRLINES" OBJECT> ,NORTHWEST-ID
		  <VOC "MASSIVE" ADJ> <VOC "AIRLINES" OBJECT> ,MASSIVE-ID
		  <> <VOC "MASSIVE" OBJECT> ,MASSIVE-ID
		  <VOC "LOW" ADJ> <VOC "CEILING" OBJECT> ,BIG-SKY-ID
		  <VOC "PAN" ADJ> <VOC "UNIVERSAL" OBJECT> ,PAN-UNIVERSAL-ID
		  <VOC "QUANTUM" ADJ> <VOC "AIRWAYS" OBJECT> ,QUANTUM-ID
		  <VOC "GAMMA" ADJ> <VOC "AIRLINES" OBJECT> ,GAMMA-ID
		  <VOC "PEOPLE'S" ADJ> <VOC "DISTRESS" OBJECT> ,DISTRESS-ID
		  <VOC "PEOPLES" ADJ> <VOC "DISTRESS" OBJECT> ,DISTRESS-ID
		  <VOC "NEWZORK" ADJ> <VOC "AIR" OBJECT> ,NEWZORK-ID
		  <VOC "NEW" ADJ> <VOC "ZORK" OBJECT> ,NEWZORK-ID
		  <VOC "BRITISH" ADJ> <VOC "UNDEROCEAN" OBJECT> ,BRITISH-ID
		  <VOC "AIR" ADJ> <VOC "FROG" OBJECT> ,FROG-ID
		  <VOC "AIR" ADJ> <VOC "WORST" OBJECT> ,WORST-ID
		  <VOC "WORSTED" ADJ> <VOC "AIRLINES" OBJECT> ,WORSTED-ID
		  <VOC "AIR" ADJ> <VOC "MOOSEHEAD" OBJECT> ,MOOSEHEAD-ID
		  <VOC "FOSTER" ADJ> <VOC "AIRWAYS" OBJECT> ,FOSTER-ID
		  <VOC "KIRIN" ADJ> <VOC "AIRLINES" OBJECT> ,KIRIN-ID
		  <VOC "AIR" ADJ> <VOC "LAPHROIG" OBJECT> ,LAPHROIG-ID
		  <VOC "AIR" ADJ> <VOC "AMERICA" OBJECT> ,AMERICA-ID
		  <VOC "TICKOFF" ADJ> <VOC "AIR" OBJECT> ,TICKOFF-ID
		  <VOC "KIWIAIR" ADJ> <> ,KIWI-ID
		  <VOC "KIWI" ADJ> <VOC "AIR" OBJECT> ,KIWI-ID
		  <VOC "AEROTICA" ADJ> <> ,AEROTICA-ID
		  <VOC "CONTINENTAL" ADJ> <VOC "BREAKFAST" OBJECT>
		  ,CONTINENTAL-ID
		  <VOC "GENERAL" ADJ> <VOC "AVIATION" OBJECT>
		  ,GENERAL-ID
		  <VOC "FRED" ADJ> <> ,FRED-ID
		  <VOC "FREDS" ADJ> <> ,FRED-ID
		  <VOC "FRED'S" ADJ> <> ,FRED-ID
		  <VOC "BOING" ADJ> <VOC "JETS" OBJECT> ,BOING-ID
		  <VOC "BOINGJETS" ADJ> <> ,BOING-ID>>

<CONSTANT AIRLINE-BITS
	  <ITABLE <* 2 ,AIRPORT-ROOMS> 0>>

<DEFINE DO-ORB (OFFS "AUX" (TBL ,AIRLINE-BITS) (N <- <* ,AIRPORT-ROOMS 2> 2>)
		(RES 0))
  <REPEAT ()
    <SET RES <ORB <ZGET .TBL <+ .N .OFFS>> .RES>>
    <COND (<L? <SET N <- .N 2>> 0>
	   <RETURN>)>>
  .RES>

<DEFINE FIND-FREE-BIT (WD "OPT" (USED? <>) "AUX" (MSK 1) (N 16))
  <REPEAT ()
    <COND (.USED?
	   <COND (<AND <BTST .WD .MSK>
		       ;<NOT <0? <ANDB .WD .MSK>>>
		       <NOT <EQUAL? .MSK 1 2>>>
		  <RETURN>)>)
	  (T
	   <COND (<NOT <BTST .WD .MSK>>
		  ;<0? <ANDB .WD .MSK>>
		  <RETURN>)>)>
    <COND (<L? <SET N <- .N 1>> 1>
	   <RETURN>)>
    <SET MSK <* .MSK 2>>>
  .MSK>

<DEFINE BIT-TRANS (WD "AUX" (N 0))
  <COND (<NOT <0? <ANDB .WD 1>>>
	 0)
	(T
	 <SET WD <ANDB </ .WD 2> *77777*>>
	 <SET N 1>
	 <REPEAT ()
	   <COND (<NOT <0? <ANDB .WD 1>>> <RETURN>)>
	   <COND (<G=? <SET N <+ .N 1>> 16> <RETURN>)>
	   <SET WD </ .WD 2>>>
	 .N)>>

<DEFINE LIST-AIRLINES (CHANGE? "AUX" (NN <AIRPORT-ROOM-NUM>)
		       W1 W2 U1 U2 OLD NEW)
  <SET NN <- .NN 1>>
  <SET NN <* .NN 2>>
  <SET W1 <ZGET ,AIRLINE-BITS .NN>>
  <SET W2 <ZGET ,AIRLINE-BITS <+ .NN 1>>>
  ; "Get all bits used so far."
  <SET U1 <DO-ORB 0>>
  <SET U2 <ORB <DO-ORB 1> 3>>
  <COND (<AND <0? .W1> <0? .W2>>
	 ; "Haven't visited this room yet"
	 <COND (<==? <AIRPORT-ROOM-NUM> <OMNIA-GALLIA-ENTRANCE>>
		<SET W2 <ORB .W2 1>>)>
	 <COND (<N==? <AIRPORT-ROOM-NUM> <AIR-ZALAGASA-ENTRANCE>>
		<SET W2 <ORB .W2 2>>)>
	 <REPEAT ((N 4) B)
	   <COND (<N==? .U1 *177777*>
		  <SET B <FIND-FREE-BIT .U1>>
		  <SET W1 <ORB .W1 .B>>
		  <SET U1 <ORB .U1 .B>>
		  <SET N <- .N 1>>)>
	   <COND (<0? .N> <RETURN>)>
	   <COND (<N==? .U2 *177777*>
		  <SET B <FIND-FREE-BIT .U2>>
		  <SET W2 <ORB .W2 .B>>
		  <SET U2 <ORB .U2 .B>>
		  <SET N <- .N 1>>)>
	   <COND (<0? .N> <RETURN>)>>
	 <ZPUT ,AIRLINE-BITS .NN .W1>
	 <ZPUT ,AIRLINE-BITS <+ .NN 1> .W2>)
	(.CHANGE?
	 <TELL ,YOU-SEE "a Deep Thought Corporation computer repairman in ">
	 <SHOW-FIELD ,LEAST-FAVORITE-COLOR>
	 <TELL " overalls peering blankly at one of the computerised
signs which is changing from ">
	 <COND (<PROB 50>
		<SET W1 <ORB <ANDB .W1 <XORB <SET OLD <FIND-FREE-BIT .W1 T>>
					     -1>>
			     <SET NEW <FIND-FREE-BIT .U1>>>>
		<TELL <AIRLINE-STR <+ <BIT-TRANS .OLD> 16>>
		      " to "
		      <AIRLINE-STR <+ <BIT-TRANS .NEW> 16>>>) 
	       (T
		<SET W2 <ORB <ANDB .W2 <XORB <SET OLD <FIND-FREE-BIT .W2 T>>
					     -1>>
			     <SET NEW <FIND-FREE-BIT .U2>>>>
		<TELL <AIRLINE-STR <BIT-TRANS .OLD>>
		      " to "
		      <AIRLINE-STR <BIT-TRANS .NEW>>>)>
	 <TELL ", whereupon he disappears into the crowd" ,PCR>
	 <ZPUT ,AIRLINE-BITS .NN .W1>
	 <ZPUT ,AIRLINE-BITS <+ .NN 1> .W2>)
	(T
	 <LIST-BITS .W1 16>
	 <LIST-BITS .W2 0>)>>

<DEFINE LIST-BITS (WD OFFS "AUX" (MSK 1) (N 0))
  <REPEAT ()
    <COND (<BTST .WD .MSK>
	   ;<NOT <0? <ANDB .WD .MSK>>>
	   <TELL "  " <AIRLINE-STR <+ .N .OFFS>> CR>)>
    <COND (<G? <SET N <+ .N 1>> 15> <RETURN>)>
    <SET MSK <* .MSK 2>>>>

<DEFINE AIRLINE-STR (N)
  <COND (<L? .N 0>
	 <ZGET ,AIRLINE-NAMES <- 0 .N>>)
	(T
	 <ZGET ,AIRLINE-NAMES .N>)>>



<OBJECT AIRPORT-CONCOURSE
	(LOC ROOMS)
	(DESC "Airport Concourse")
	(FLAGS IN-TERMINAL LIGHTED LOCATION INDOORS SPECIAL-DROP)
	(OUT TO AIRPORT-ENTRANCE)
	(SOUTH TO AIRPORT-ENTRANCE)
	(NORTH TO AIRLINE-DESK)
	(EAST PER NEXT-CONCOURSE)
	(WEST PER PREVIOUS-CONCOURSE)
	(HEAR AIRPORT-MUSIC)
	(OVERHEAD SIGNS)
	(GLOBAL AIRPORT-CROWD SKYCAPS AIRPORT-MUSIC THE-FLIGHT SIGNS
		ACTUAL-DESK ACTUAL-ZDESK)
	(THINGS PSEUDO-VEC)
	(ACTION AIRPORT-CONCOURSE-F)>

; "Move around the concourse. Always skip the zalagasa concourse, no
   matter where it is."
<DEFINE NEXT-CONCOURSE ("AUX" (N <AIRPORT-ROOM-NUM>))
  <AIRPORT-ROOM-NUM <SET N <+ .N 1>>>
  <CHANGE-DESK? T>
  <COND (<==? .N <AIR-ZALAGASA-ENTRANCE>>
	 <NEXT-CONCOURSE>)
	(<G? .N ,AIRPORT-ROOMS>
	 <AIRPORT-ROOM-NUM 0>
	 <NEXT-CONCOURSE>)
	(T
	 <SEEN-BIT-HACK ,AIRPORT-CONCOURSE 32>
	 ,AIRPORT-CONCOURSE)>>

<DEFINE PREVIOUS-CONCOURSE ("AUX" (N <AIRPORT-ROOM-NUM>))
  <AIRPORT-ROOM-NUM <SET N <- .N 1>>>
  <CHANGE-DESK? T>
  <COND (<==? .N <AIR-ZALAGASA-ENTRANCE>>
	 <PREVIOUS-CONCOURSE>)
	(<==? .N 0>
	 <AIRPORT-ROOM-NUM <+ ,AIRPORT-ROOMS 1>>
	 <PREVIOUS-CONCOURSE>)
	(T
	 <SEEN-BIT-HACK ,AIRPORT-CONCOURSE 32>
	 ,AIRPORT-CONCOURSE)>>

<DEFINE AIRPORT-CONCOURSE-F ("OPT" (CONTEXT <>))
  <COND (<==? .CONTEXT ,M-ENTERING>
	 <COND (<T? <CHANGE-DESK?>>
		<SETUP-SIGNS-AND-DESK>)>
	 <CHANGE-DESK? <>>
	 <AOS-BP? <>>
	 <COND (<==? ,HERE ,ZALAGASA-CONCOURSE>)
	       (<AND <IS? ,AIRPORT-CONCOURSE ,TOUCHED>
		     <==? <AIRPORT-ROOM-NUM>
			  <OMNIA-GALLIA-ENTRANCE>>>
		<AOS-BP? T>)>)
	(<==? .CONTEXT ,M-ENTERED>
	 <COND (<T? <AOS-BP?>>
		<AOS-BP? <>>
		<UPDATE-BP 4>)>)
	(<==? .CONTEXT ,M-LOOK>
	 <TELL "You're in the main concourse. To the north, there's a ticket
desk for " <AIRLINE-STR <CURRENT-DESK-ID>> "; overhead are signs pointing to various
airlines:" CR>
	 <LIST-SIGNS>
	 <TELL "The concourse continues to the east and west; there's an exit
to the south." CR>)
	(T <>)>>

<DEFINE LIST-SIGNS ("AUX" (CS ,CURRENT-SIGNS) (N 0) TS)
  <REPEAT ()
    <SET TS <ZGET .CS .N>>
    <TELL "  " <ZGET .CS <SET N <+ .N 1>>> ": "
	  <AIRLINE-STR .TS> CR>
    <COND (<G=? <SET N <+ .N 1>> 10> <RETURN>)>>>

<DEFINE SETUP-SIGNS-AND-DESK ("AUX" (RN <AIRPORT-ROOM-NUM>)
				    (NN <* <- .RN 1> 2>) WD
			      (FACT 0) (CS ,CURRENT-SIGNS) SOURCE TT
			      DEST)
  <AT-ZALAGASA? <>>
  <COND (<==? ,HERE ,ZALAGASA-CONCOURSE>
	 <MOVE ,AIRCLERK ,ZALAGASA-DESK>
	 <SET WD ,ZALAGASA-ID>
	 <AT-ZALAGASA? T>)
	(<==? .RN
	      <OMNIA-GALLIA-ENTRANCE>>
	 ; "Omnia gallia desk is always in right place"
	 <ZREMOVE ,AIRCLERK>
	 <SET WD ,OMNIA-ID>)
	(T
	 <MOVE ,AIRCLERK ,AIRLINE-DESK>
	 ; "Pick one of the neighboring entrances"
	 <COND (<PROB 50>
		<COND (<L? <SET NN <- .NN 2>> 0>
		       <SET NN <- <* ,AIRPORT-ROOMS 2> 2>>)>)
	       (<G=? <SET NN <+ .NN 2>> <* ,AIRPORT-ROOMS 2>>
		<SET NN 0>)>
	 <COND (<PROB 50>
		<SET WD <ZGET ,AIRLINE-BITS .NN>>)
	       (T
		<SET WD <ZGET ,AIRLINE-BITS <+ .NN 1>>>
		<SET FACT 16>)>
	 ; "Pick a random airline that's listed on one of the neighboring
	    entrances. Air Zalagasa & Omnia Gallia will never be used."
	 <SET WD <+ <BIT-TRANS <FIND-FREE-BIT .WD T>> .FACT>>)>
  ; "This will always be positive"
  <CURRENT-DESK-ID .WD>
  ; "Zero vector of current signs"
  <REPEAT ((N 0))
    <ZPUT .CS .N 0>
    <COND (<G? <SET N <+ .N 1>> 9> <RETURN>)>>
  ; "Put air zalagasa in somewhere"
  <SET NN <ZRANDOM 5>>
  <SET NN <- .NN 1>>
  <SET NN <* 2 .NN>>
  <COND (<==? ,HERE ,ZALAGASA-CONCOURSE>
	 ; "If at zalagasa, use omnia gallia instead."
	 <ZPUT .CS .NN ,OMNIA-ID>
	 <COND (<G? .RN <OMNIA-GALLIA-ENTRANCE>>
		<ZPUT .CS <+ .NN 1> "west">)
	       (T
		<ZPUT .CS <+ .NN 1> "east">)>)
	(T
	 <ZPUT .CS .NN ,ZALAGASA-ID>
	 <COND (<G? .RN <AIR-ZALAGASA-ENTRANCE>>
		<ZPUT .CS <+ .NN 1> "west">)
	       (T
		<ZPUT .CS <+ .NN 1> "east">)>)>
  <SET SOURCE <ZREST ,AIRLINE-LOOKUP 2>>
  <COND (<SET TT <INTBL? <CURRENT-DESK-ID> .SOURCE
			 <ZGET ,AIRLINE-LOOKUP 0>>>
	 ; "Find the airline ID"
	 <MAKE ,AIRLINE-DESK ,VOWEL>)
	(<SET TT <INTBL? <- 0 <CURRENT-DESK-ID>> .SOURCE
			 <ZGET ,AIRLINE-LOOKUP 0>>>
	 ; "Either way"
	 <UNMAKE ,AIRLINE-DESK ,VOWEL>)>
  <SET SOURCE <ZBACK .TT 4>>
  <COPY-SYNS .SOURCE <GETPT ,ACTUAL-DESK ,P?SYNONYM>>
  <COPY-SYNS .SOURCE <GETPT ,AIRCLERK ,P?ADJECTIVE>
	     <GETPT ,ACTUAL-DESK ,P?ADJECTIVE>>
  <SET DEST <GETPT ,AIRCLERK ,P?SYNONYM>>
  <COND (<PROB 50>
	 <MAKE ,AIRCLERK ,FEMALE>
	 <ZPUT .DEST 0 ,W?WOMAN>
	 <ZPUT .DEST 1 ,W?LADY>
	 <ZPUT .DEST 2 ,W?ZZZP>)
	(T
	 <UNMAKE ,AIRCLERK ,FEMALE>
	 <ZPUT .DEST 0 ,W?MAN>
	 <ZPUT .DEST 1 ,W?GUY>
	 <ZPUT .DEST 2 ,W?FELLOW>)>
  ; "Now pick a set of random airlines that are mentioned outside."
  <REPEAT ((N 0) (M 0) NW)
    <COND (<OR <G? .M ,AIRPORT-ROOMS>
	       <G? .N 9>>
	   <RETURN>)>
    <COND (<N==? <ZGET .CS <+ .N 1>> 0>
	   <SET N <+ .N 2>>
	   <AGAIN>)>
    <COND (<==? .RN <+ .M 1>>
	   <SET M <+ .M 1>>
	   <AGAIN>)>
    <PROG (FACT (WHICH? <PROB 50>))
      <COND (.WHICH?
	     <SET NW <ZGET ,AIRLINE-BITS <* .M 2>>>
	     <SET FACT 16>)
	    (T
	     <SET NW <ZGET ,AIRLINE-BITS <+ 1 <* .M 2>>>>
	     <SET FACT 0>)>
      <COND (<==? <SET NW <+ .FACT <BIT-TRANS <FIND-FREE-BIT .NW T>>>>
		  .WD>
	     ; "Don't include the airline whose desk is here..."
	     <COND (.WHICH? <SET WHICH? <>>)
		   (T <SET WHICH? T>)>
	     <AGAIN>)>>
    <ZPUT .CS .N .NW>
    <ZPUT .CS <SET N <+ .N 1>>
	  <COND (<G? <+ .M 1> .RN> "east")
		(T "west")>>
    <SET N <+ .N 1>>
    <SET M <+ .M 1>>>>

<DEFINE COPY-SYNS (SOURCE DEST "OPT" (DEST2 <>) "AUX" (LEN 2))
  <REPEAT (X)
    <COND (<T? <SET X <ZGET .SOURCE <SET LEN <- .LEN 1>>>>>
	   <ZPUT .DEST .LEN .X>
	   <COND (<T? .DEST2>
		  <ZPUT .DEST2 .LEN .X>)>)>
    <COND (<L? .LEN 1> <RETURN>)>>>

<CONSTANT CURRENT-SIGNS
	  <ITABLE 10 0>>

<OBJECT LANDF
	(LOC ROOMS)
	(DESC "Lost and Found")
	(FLAGS NO-NERD LIGHTED LOCATION IN-TERMINAL INDOORS)
	(NORTH TO AIRPORT-ENTRANCE)
	(OUT TO AIRPORT-ENTRANCE)
	(GLOBAL LANDF-DOOR)
	(LDESC "You're in the Airport's Lost and Found office. A doorway leads north.")
	(THINGS PSEUDO-VEC)>

<OBJECT AIRLINE-DESK
	(LOC ROOMS)
	(SDESC SDESC-DESK)
	(FLAGS IN-TERMINAL LIGHTED LOCATION INDOORS SPECIAL-DROP)
	(SOUTH TO AIRPORT-CONCOURSE)
	(WEST PER PREVIOUS-CONCOURSE)
	(EAST PER NEXT-CONCOURSE)
	(GLOBAL AIRPORT-CROWD SKYCAPS AIRPORT-MUSIC THE-FLIGHT SIGNS
		ACTUAL-ZDESK)
	(OVERHEAD SIGNS)
	(ACTION AIRLINE-DESK-F)
	(THINGS PSEUDO-VEC)>

<OBJECT ACTUAL-DESK
	(LOC AIRLINE-DESK)
	(DESC "desk")
	(SDESC SDESC-DESK)
	(FLAGS NODESC SURFACE PLACE)
	(CAPACITY 25)
	(GENERIC GENERIC-DESK-F)
	(SYNONYM ZZZP ZZZP ZZZP DESK)
	(ADJECTIVE ZZZP ZZZP ZZZP AIRLINE AIRLINES CHECK-IN TICKET)
	(ACTION ACTUAL-DESK-F)>

<DEFINE GENERIC-DESK-F (TBL "AUX" LEN)
  <SET LEN <ZGET .TBL 0>>
  <SET TBL <ZREST .TBL 2>>
  <COND (<AND <==? .LEN 2>
	      <INTBL? ,ACTUAL-DESK .TBL .LEN>
	      <INTBL? ,ACTUAL-ZDESK .TBL .LEN>>
	 <COND (<HERE? AIRPORT-CONCOURSE AIRLINE-DESK>
		,ACTUAL-DESK)
	       (<HERE? ZALAGASA-CONCOURSE ZALAGASA-DESK>
		,ACTUAL-ZDESK)>)>>

<DEFINE SDESC-DESK ()
  <TELL <AIRLINE-STR <CURRENT-DESK-ID>> " desk">>

<DEFINE ACTUAL-DESK-F ()
	 <COND (<THIS-PRSI?>
		<COND (<VERB? PUT-ON PUT>
		       <TELL "You should " ITAL "never" " put something on
someone's desk without permission. Didn't you learn " ITAL "anything" " in
primary school?" CR>)
		      (T <>)>)
	       (<VERB? EXAMINE>
		<TELL "It's an intensely wonderful and deeply moving desk." CR>
		T)
	       (<VERB? WALK-TO>
		<COND (<PRSO? ACTUAL-DESK>
		       <COND (<HERE? AIRPORT-CONCOURSE>
			      <DO-WALK ,P?NORTH>)
			     (<HERE? ZALAGASA-CONCOURSE>
			      <CANT-SEE-ANY ,PRSO>)
			     (<HERE? AIRLINE-DESK>
			      <ALREADY-THERE>)
			     (T
			      <TELL "You'll have to find it first." CR>)>
		       T)
		      (<PRSO? ACTUAL-ZDESK>
		       <COND (<HERE? ZALAGASA-CONCOURSE>
			      <DO-WALK ,P?NORTH>)
			     (<HERE? ZALAGASA-DESK>
			      <ALREADY-THERE>)
			     (<HERE? AIRPORT-CONCOURSE>
			      <CANT-SEE-ANY ,PRSO>)
			     (T
			      <TELL "You'll have to find it first." CR>)>
		       T)>)
	       (<AND <VERB? LOOK-BEHIND>
		     <OR <N==? <CURRENT-DESK-ID> ,OMNIA-ID>
			 <PRSO? ,ACTUAL-ZDESK>>>
		<TELL "There's a clerk standing behind the desk." CR>)
	       (<VERB? WALK-AROUND>
		<COND (<OR <N==? <CURRENT-DESK-ID> ,OMNIA-ID>
			   <PRSO? ,ACTUAL-ZDESK>>
		       <TELL "The clerk blocks your path, and directs you back to the front of the desk." CR>)
		      (T
		       <TELL "There's no path around the desk." CR>)>)
	       (T
		<>)>>

; "Room function"
<DEFINE AIRLINE-DESK-F ADF ("OPT" (CONTEXT <>) "AUX" SOURCE DEST LEN DEST2 TT)
  <COND (<==? .CONTEXT ,M-LOOK>
	 <TELL "You're standing in ">
	 <COND (<==? <CURRENT-DESK-ID> ,OMNIA-ID>
		<TELL "front of the deserted Omnia Gallia desk." CR>
		<RETURN T .ADF>)>
	 <COND (<T? <CLERK-LISTENING?>>
		<TELL "front of ">)
	       (T
		<TELL "line at ">)>
	 <TELL THE ,ACTUAL-DESK ", just north of the concourse.">
	 <COND (<T? <CLERK-LISTENING?>>
		<TELL " " CTHE ,AIRCLERK
		       " is looking at you expectantly.">)
	       (<NOT <IN? ,FATSO ,HERE>>
		<TELL " A number of people are waiting in front of you in
an annoying manner.">)>
	 <ZCRLF>)
	(<==? .CONTEXT ,M-EXIT>
	 <ZREMOVE ,OMNIA-SIGN>
	 <DEQUEUE I-DESK>
	 <DEQUEUE I-ZALAGASA-DESK>
	 <CLERK-LISTENING? <>>
	 <ZREMOVE ,FATSO>
	 <COND (<AND <==? ,HERE ,ZALAGASA-DESK>
		     <N==? <DESK-LOSER?> 2>>
		<DESK-LOSER? 1>)>
	 <>)
	(<==? .CONTEXT ,M-ENTERING>
	 <COND (<N==? ,HERE ,ZALAGASA-DESK>
		<SEEN-BIT-HACK ,AIRLINE-DESK 1024>)>
	 <COND (<==? <CURRENT-DESK-ID> ,OMNIA-ID>
		<MOVE ,OMNIA-SIGN ,HERE>
		<COND (<NOT <IS? ,AIRLINE-DESK ,TOUCHED>>
		       <TELL "As you approach the desk, you notice a sign, which
a departing Deep Thought Corporation repairman in ">
		       <SHOW-FIELD ,LEAST-FAVORITE-COLOR>
		       <TELL " overalls has just finished fiddling with" ,PCR>
		       <WINDOW ,OMNIA-SIGN-TEXT <> <> <> 13>)>
		<RETURN <> .ADF>)
	       (<==? ,HERE ,ZALAGASA-DESK>
		<COND (<OR <T? <FLIGHT-RECALLED?>>
			   <T? <FLIGHT-GONE?>>>
		       <DESK-LOSER? 3>)
		      (<N==? <DESK-LOSER?> 1>
		       <DESK-ZSCRIPT 0>)>
		<QUEUE I-ZALAGASA-DESK>)
	       (T
		<DESK-SCRIPT 0>
		<QUEUE I-DESK>)>
	 <>)
	(T <>)>>

<OBJECT OMNIA-SIGN
	(FLAGS READABLE NODESC)
	(DESC "notice")
	(SYNONYM SIGN NOTICE)
	(ADJECTIVE LARGE)
	(ACTION OMNIA-SIGN-F)>

<DEFINE OMNIA-SIGN-F ()
	<COND (<AND <THIS-PRSO?>
		    <VERB? READ EXAMINE>>
	       <DISPLAY-SIGN ,OMNIA-SIGN-TEXT>)
	      (T <>)>>

<DEFINE DISPLAY-SIGN (TBL "AUX" (LEN <ZGET .TBL 0>))
  <SET LEN <- .LEN 1>>
  <SET TBL <ZREST .TBL 4>>
  <REPEAT ()
    <TELL <ZGET .TBL 0>>
    <ZCRLF>
    <COND (<L? <SET LEN <- .LEN 1>> 1> <RETURN>)>
    <SET TBL <ZREST .TBL 2>>>>

<CONSTANT OMNIA-SIGN-TEXT
	  <PLTABLE 33
		   "Omnia Gallia airlines has been "
		   "sold; we no longer fly out of  "
		   "this airport. For further      "
		   "information, contact the Air   "
		   "Zalagasa desk.                 ">>

<DEFINE I-TERMINAL IT ("OPT" (CR T) "AUX" P)
  <COND (<HERE? IN-TOWER> <>)
	(<T? <JUST-HEARD?>>
	 <JUST-HEARD? <>>
	 <RETURN <> .IT>)
	(<T? <JUST-PAGED?>>
	 <JUST-PAGED? <>>)
	(<PROB 20>
	 <JUST-PAGED? T>
	 <COND (<T? .CR> <ZCRLF>)>
	 <TELL "\"Omnia Gallia paging passenger ">
	 <PRINT-NAME>
	 <TELL "; please pick up the white courtesy phone.\"" CR>
	 <RETURN T .IT>)>
  <COND (<PROB 30>
	 <COND (<T? .CR> <ZCRLF>)>
	 <TELL
"\"Your attention, please. Would " PONE ,PATRONS
" please pick up the white courtesy phone.\"" CR>
	 <RETURN T .IT>)
	(<PROB 50>
	 <NEXT-TOON>
	 <COND (<T? .CR> <ZCRLF>)>
	 <TELL "You hear ">
	 <SAY-MUZAK>
	 <TELL " being played very ">
	 <COND (<AND <==? ,HERE ,ZALAGASA-CONCOURSE>
		     <T? <TICKET-SCREW?>>>
		<TELL "loudly and ">)>
	 <TELL "soothingly." CR>
	 <RETURN T .IT>)
	(T <>)>>

<DEFINE I-DESK DESK ("OPTIONAL" (CR T) "AUX" N)
  <SET N <DESK-SCRIPT>>
  <DESK-SCRIPT <SET N <+ .N 1>>>
  <COND (<OR <L=? .N 1>
	     <G? .N 4>>
	 <RETURN <> .DESK>)>
  <COND (<T? .CR> <ZCRLF>)>
  <COND (<==? .N 2>
	 <TELL "You're now the first person in line at the desk" ,PCR>
	 <WELCOME-TO-DESK>
	 T)
	(<==? .N 3>
	 <CLERK-WAITING>
	 T)
	(<==? .N 4>
	 <CLERK-BYE>
	 T)>>

<DEFINE WELCOME-TO-DESK ()
	 <CLERK-LISTENING? T>
	 <CLERK-WORKING? <>>
	 <TELL "\"Welcome to " <AIRLINE-STR <CURRENT-DESK-ID>> ", ">
	 <SIR-OR-MAAM>
	 <TELL ",\" smiles the clerk vacantly. \"May I help you?\"" CR>>

<DEFINE CLERK-WAITING ()
	 <TELL CTHE ,AIRCLERK
" glances pointedly at the growing line behind you. \"How may I help you, ">
	 <SIR-OR-MAAM>
	 <TELL "?\"" CR>>

<DEFINE CLERK-BYE ()
	 <TELL "\"Have a nice day, ">
	 <SIR-OR-MAAM>
	 <TELL ",\" smiles ">
	 <TURNING-ATTENTION>>

<DEFINE TURNING-ATTENTION ()
	 <CLERK-LISTENING? <>>
	 <COND (<HERE? ZALAGASA-DESK>
		<DESK-ZSCRIPT -1>
		<DESK-LOSER? 2>)
	       (T
		<DESK-SCRIPT -1>)>
	 <TELL THE ,AIRCLERK ", turning ">
	 <COND (<IS? ,AIRCLERK ,FEMALE>
		<TELL "her">)
	       (T
		<TELL "his">)>
	 <TELL " attention to the person behind you in line." CR>>

<OBJECT AIRCLERK
	(DESC "clerk")
	(SDESC DESCRIBE-AIRCLERK)
	(FLAGS LIVING PERSON)
	(SYNONYM ZZZP ZZZP ZZZP CLERK)
	(ADJECTIVE ZZZP ZZZP AIRLINE)
	(DESCFCN AIRCLERK-F)
	(ACTION AIRCLERK-F)>

<DEFINE DESCRIBE-AIRCLERK ()
	 <TELL <AIRLINE-STR <CURRENT-DESK-ID>> " clerk">
	 T>

<DEFINE AIRCLERK-F CLERK ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-OBJDESC>
		<TELL "A clerk is standing behind the desk, ">
		<COND (<F? <CLERK-LISTENING?>>
		       <TELL "talking to the first person in line.">)
		      (T
		       <TELL "looking at you expectantly.">)>
		T)
	       (<EQUAL? .CONTEXT ,M-WINNER>
		<CLERK-WORKING? T>
		<COND (<VERB? TAKE EXAMINE READ>
		       <SHOW-TO-AIRCLERK>
		       <RETURN ,FATAL-VALUE .CLERK>)
		      (<VERB? HELLO>
		       <TELL CTHE ,AIRCLERK " nods politely." CR>
		       <RETURN T .CLERK>)
		      (<PRSO? ME>
		       <COND (<VERB? TELL-ABOUT SSHOW>
			      <ASK-AIRCLERK-ABOUT>
			      <RETURN ,FATAL-VALUE .CLERK>)
			     (<VERB? SGIVE SSELL>
			      <ASK-AIRCLERK-FOR>
			      <RETURN ,FATAL-VALUE .CLERK>)>)
		      (<PRSI? ME>
		       <COND (<VERB? SHOW>
			      <ASK-AIRCLERK-ABOUT ,PRSO>
			      <RETURN ,FATAL-VALUE .CLERK>)
			     (<VERB? GIVE SELL>
			      <ASK-AIRCLERK-FOR ,PRSO>
			      <RETURN ,FATAL-VALUE .CLERK>)>)>
		<TELL 
"\"Any of our friendly skycaps will be happy to help you with that, ">
		<SIR-OR-MAAM>
		<TELL ",\" smiles ">
		<TURNING-ATTENTION>
		,FATAL-VALUE)
	       (<T? .CONTEXT>
		<>)
	       (<THIS-PRSI?>
		<COND (<VERB? GIVE SHOW>
		       <COND (<NOT-FIRST-IN-LINE?>
			      T)
			     (T
			      <CLERK-WORKING? T>
			      <SHOW-TO-AIRCLERK>
			      T)>)
		      (T
		       <>)>)
	       (T
		<CLERK-WORKING? T>
		<COND
		 (<VERB? TELL>
		  <COND (<NOT-FIRST-IN-LINE?>
			 ,FATAL-VALUE)
			(T
			 <>)>)
		 (<VERB? ASK-ABOUT>
		  <COND (<NOT <NOT-FIRST-IN-LINE?>>
			 <ASK-AIRCLERK-ABOUT>)>
		  T)
		 (<VERB? ASK-FOR>
		  <COND (<NOT <NOT-FIRST-IN-LINE?>>
			 <ASK-AIRCLERK-FOR>)>
		  T)
		 (T
		  <>)>)>>

<DEFINE NOT-FIRST-IN-LINE? ()
	 <COND (<ZERO? <CLERK-LISTENING?>>
		<TELL CTHE ,AIRCLERK 
" gives you an icy smile. \"I'll be pleased to help you in just a moment, ">
		<SIR-OR-MAAM>
		<TELL 
". Please let me finish helping the nice people in line before you.\"" CR>
		T)
	       (T
		<>)>>

<DEFINE ASK-AIRCLERK-ABOUT ASK-ABOUT ("OPTIONAL" (OBJ <>))
	 <COND (<ZERO? .OBJ>
		<SET OBJ ,PRSI>)>
	 <COND (<EQUAL? .OBJ ,TICKET ,ZTICKET>
		<COND (<F? <AT-ZALAGASA?>>
		       <TELL "\"You'd have to go to the airline that issued
the ticket, ">
		       <SIR-OR-MAAM>
		       <TELL ",\" notes ">
		       <TURNING-ATTENTION>
		       <RETURN T .ASK-ABOUT>)
		      (T
		       <DO-TICKET .OBJ>
		       <RETURN T .ASK-ABOUT>)>)
	       (<==? .OBJ ,AIRLINE>
		<COND (<AND <==? <GETP ,AIRLINE ,P?PSEUDO-TABLE>
				 ,OMNIA-ID>
			    <==? <CURRENT-DESK-ID> ,ZALAGASA-ID>>
		       <TELL "\"I'm authorised to exchange Omnia Gallia tickets
for Air Zalagasa tickets, under certain circumstances. If you'd just show me
your ticket, perhaps I can help you.\"" CR>
		       <RETURN T .ASK-ABOUT>)
		      (<==? <GETP ,AIRLINE ,P?PSEUDO-TABLE>
			    <CURRENT-DESK-ID>>
		       <TELL "\"That's me! What can I do for you?\"" CR>
		       <RETURN T .ASK-ABOUT>)
		      (T
		       <TELL "\"You'd be much better off at their ticket desk.
Just follow the signs,\" suggests ">
		       <TURNING-ATTENTION>
		       <RETURN T .ASK-ABOUT>)>)
	       (<AND <T? <AT-ZALAGASA?>>
		     <==? .OBJ ,THE-FLIGHT>>
		<ASK-ABOUT-42>
		<RETURN T .ASK-ABOUT>)>
	 <TELL "\"I'm afraid I'm not authorised to say anything about "
	       THE .OBJ ", ">
	 <SIR-OR-MAAM>
	 <TELL ",\" admits ">
	 <TURNING-ATTENTION>
	 T>

<DEFINE ASK-AIRCLERK-FOR ASK-FOR ("OPTIONAL" (OBJ <>))
	 <COND (<ZERO? .OBJ>
		<SET OBJ ,PRSI>)>
	 <COND (<AND <T? <AT-ZALAGASA?>>
		     <EQUAL? .OBJ ,TICKET ,ZTICKET>>
		<DO-TICKET .OBJ>
		<RETURN T .ASK-FOR>)>
	 <TELL "\"Terribly sorry, ">
	 <SIR-OR-MAAM>
	 <TELL ", but I'm afraid I'm not authorised to give you " A .OBJ
	       ",\" admits ">
	 <TURNING-ATTENTION>
	 T>

<DEFINE SHOW-TO-AIRCLERK SHOW ("OPTIONAL" (OBJ <>))
	 <COND (<ZERO? .OBJ>
		<SET OBJ ,PRSO>)>
	 <COND (<AND <T? <AT-ZALAGASA?>>
		     <T? <WAITING-FOR-CASH?>>>
		<TELL "\"I'm sorry, ">
		<SIR-OR-MAAM>
		<COND (<N==? .OBJ ,MONEY>
		       <TELL ", I'm authorised to take only cash for this
transaction.\"" CR>
		       <RETURN T .SHOW>)
		      (<GET-YES/NO ", you'll need quite a bit more than this. Would you like the direct flight instead?\"" -1
				   "A simple yes or no would suffice.\"">
		       <WAITING-FOR-CASH? <>>
		       <ZREMOVE ,TICKET>
		       <MOVE ,ZTICKET ,PLAYER>
		       <TICKET-SCREW? T>
		       <TELL "\"A wise choice. The flight through Zalagasa is
really very pleasant. Have a nice day!\" burbles ">
		       <TURNING-ATTENTION>
		       <UPDATE-SCORE 1>
		       <RETURN T .SHOW>)
		      (T
		       <TELL "\"Very well. I'll still need the $200 before I
can issue the ticket.\"" CR>
		       <RETURN T .SHOW>)>)
	       (<AND <T? <AT-ZALAGASA?>>
		     <EQUAL? .OBJ ,TICKET ,ZTICKET>>
		<DO-TICKET .OBJ>
		<RETURN T .SHOW>)
	       (<==? .OBJ ,TICKET>
		<TELL "\"You'll have to take that to the Omnia Gallia desk, ">
		<SIR-OR-MAAM>
		<TELL ". We don't honour their tickets,\" says ">)
	       (<==? .OBJ ,ZTICKET>
		<TELL "\"You'll have to take that to the Air Zalagasa desk, ">
		<SIR-OR-MAAM>
		<TELL ", although I'm not sure there is one here. I don't remember seeing it,\" says ">)
	       (T
		<TELL "\"I'm afraid I'm not authorised to comment on "
		      THE .OBJ
		      " without the approval of my supervisor,\" says ">)>
	 <TURNING-ATTENTION>
	 T>

<OBJECT SIGNS
	(LOC LOCAL-GLOBALS)
	(DESC "signs")
	(FLAGS NODESC TRYTAKE NOALL)
	(SYNONYM SIGNS SIGN)
	(ACTION SIGNS-F)>

<DEFINE SIGNS-F ()
	 <COND (<TOUCHING?>
		<TELL "The signs are high out of reach." CR>
		T)
	       (<THIS-PRSI?>
		<>)
	       (<VERB? EXAMINE LOOK-ON READ>
		<TELL "The signs here say:" CR>
		<COND (<HERE? ,AIRPORT-ENTRANCE>
		       <LIST-AIRLINES <>>)
		      (T
		       <LIST-SIGNS>)>)
	       (<VERB? FOLLOW>
		<V-WALK-AROUND>
		T)
	       (T <>)>>


<DEFINE DESC-AIRLINE ("AUX" ID)
  <COND (<G? <SET ID <GETP ,AIRLINE ,P?PSEUDO-TABLE>> -1>
	 <TELL <AIRLINE-STR .ID>>)
	(T
	 <PRINTD ,AIRLINE>)>>

<DEFINE MATCH-AIRLINE-NAME MAN (ADJ NAM TBL "AUX" TT (OBJ ,AIRLINE)
			        (LEN <ZGET .TBL 0>))
  <COND (<AND <F? .ADJ>
	      <F? .NAM>>
	 <RETURN <> .MAN>)>
  <COND (<AND <==? .NAM ,W?INTNUM>
	      <==? ,P-NUMBER 42>>
	 <RETURN ,THE-FLIGHT .MAN>)>
  <COND (<AND <SET TT <GETPT .OBJ ,P?SYNONYM>>
	      <INTBL? .NAM .TT </ <PTSIZE .TT> 2>>>
	 <SET NAM <>>)>
  <COND (<AND .ADJ
	      <SET TT <GETPT .OBJ ,P?ADJECTIVE>>
	      <INTBL? .NAM .TT </ <PTSIZE .TT> 2>>>
	 <SET ADJ <>>)>
  <COND (<NOT <OR .NAM .ADJ>>
	 <TELL "You'll have to be more specific. Do you mean ">
	 <SET TBL ,AIRLINE-NAMES>
	 <REPEAT ((N 0))
	   <TELL <ZGET .TBL .N>>
	   <COND (<G? <SET N <+ .N 1>> 30>
		  <TELL ", or " <ZGET .TBL .N> "?" CR>
		  <RETURN>)>
	   <TELL ", ">>
	 <PUTP .OBJ ,P?PSEUDO-TABLE -1>
	 .OBJ)
	(T
	 <SET TBL <ZREST .TBL 2>>
	 <REPEAT ()
	   <COND (<OR <NOT .NAM>
		      <==? .NAM <ZGET .TBL 1>>>
		  <COND (<OR <NOT .ADJ>
			     <==? .ADJ <ZGET .TBL 0>>
			     <==? .ADJ <ZGET .TBL 1>>>
			 ; "Make sure this is always positive or -1"
			 <COND (<L? <SET ADJ <ZGET .TBL 2>> 0>
				<SET ADJ <- 0 .ADJ>>)>
			 <PUTP .OBJ ,P?PSEUDO-TABLE .ADJ>
			 <RETURN>)>)>
	   <COND (<L=? <SET LEN <- .LEN 3>> 2>
		  <PUTP .OBJ ,P?PSEUDO-TABLE -1>
		  <SET OBJ <>>
		  <RETURN>)>
	   <SET TBL <ZREST .TBL 6>>>
	 .OBJ)>>

<CONSTANT PSEUDO-VEC <PTABLE MATCH-AIRLINE-NAME AIRLINE-LOOKUP>>

<OBJECT AIRLINE
	(DESC "Random Airline")
	(FLAGS NODESC NOARTICLE PLACE)
	(SYNONYM AIRLINES AIRLINE)
	(ACTION AIRLINE-F)
	(PSEUDO-TABLE 0)
	(SDESC DESC-AIRLINE)>

<DEFINE AIRLINE-F ("AUX" ID BITS (MASK 1) ARN)
	  <SET ID <GETP ,PRSO ,P?PSEUDO-TABLE>>
	  <COND (<NOT <IS? ,HERE ,IN-TERMINAL>>
		 <TELL "Airlines are usually found only at airports." CR>
		 T)
		(<THIS-PRSI?>
		 <>)
		(<VERB? EXAMINE>
		 <COND (<N==? .ID -1>
			<CANT-SEE-MUCH>)>
		 T)
		(<ENTERING?>
		 ; "See if we're at the entrance for the airline referred
		    to..."
		 <SET ID <GETP ,PRSO ,P?PSEUDO-TABLE>>
		 <COND (<==? .ID -1>
			<ORPHAN-VERB <> ,ACT?ENTER>)
		       (<HERE? ,AIRPORT-ENTRANCE>
			<SET ARN <AIRPORT-ROOM-NUM>>
			<SET ARN <- .ARN 1>>
			<COND (<G? .ID 15>
			       <SET BITS
				    <ZGET ,AIRLINE-BITS
					  <* .ARN 2>>>
			       <SET ID <- .ID 16>>)
			      (T
			       <SET BITS
				    <ZGET ,AIRLINE-BITS
					  <+ <* .ARN 2>
					     1>>>)>
			<SET MASK <DO-LSH <SET ID <+ .ID 1>>>>
			<COND (<BTST .BITS .MASK>
			       ;<NOT <0? <ANDB .BITS .MASK>>>
			       <AIRLINE-WALK ,P?NORTH>)
			      (T
			       <V-WALK-AROUND>)>)
		       (<HERE? ,AIRLINE-DESK>
			<COND (<==? .ID <CURRENT-DESK-ID>>
			       <ALREADY-THERE>
                               T)
			      (T
			       <AIRLINE-WALK ,P?SOUTH>)>)
		       (<HERE? ,AIRPORT-CONCOURSE>
			<COND (<SET MASK <INTBL? .ID ,CURRENT-SIGNS 10>>
			       <COND (<==? <ZGET .MASK 1> "east">
				      <AIRLINE-WALK ,P?EAST>)
				     (T
				      <AIRLINE-WALK ,P?WEST>)>)
			      (T
			       <V-WALK-AROUND>)>)
		       (T
			<ORPHAN-VERB <> ,ACT?ENTER>)>
		 T)
		(T
		 <>)>>

<DEFINE AIRLINE-WALK (DIR)
  <TELL "You stumble along, peering intently at the signs overhead" ,PCR>
  <DO-WALK .DIR>>


"ZALAGASA SECTION"

; "Uses same routines as normal concourse"
<OBJECT ZALAGASA-CONCOURSE
	(LOC ROOMS)
	(DESC "Airport Concourse")
	(FLAGS IN-TERMINAL LIGHTED LOCATION INDOORS SPECIAL-DROP)
	(OUT TO AIRPORT-ENTRANCE)
	(SOUTH TO AIRPORT-ENTRANCE)
	(NORTH TO ZALAGASA-DESK)
	(EAST PER NEXT-CONCOURSE)
	(WEST PER PREVIOUS-CONCOURSE)
	(UP PER UP-PILLAR)
	(OVERHEAD SIGNS)
	(GLOBAL PILLAR AIRPORT-CROWD SKYCAPS AIRPORT-MUSIC THE-FLIGHT SIGNS
		GRATE ACTUAL-DESK ACTUAL-ZDESK GSPEAKER)
	(THINGS PSEUDO-VEC)
	(ACTION ZALAGASA-CONCOURSE-F)>

<DEFINE ZALAGASA-CONCOURSE-F ("OPT" (CONTEXT <>) "AUX" VAL)
  <SET VAL <AIRPORT-CONCOURSE-F .CONTEXT>>
  <COND (<T? <SPEAKER-DEAD?>> T)
	(<T? <TICKET-SCREW?>>
	 <COND (<OR <AND <==? .CONTEXT ,M-ENTERED>
			 <F? <PILLAR-MENTIONED?>>>
		    <AND <==? .CONTEXT ,M-LOOK>
			 <T? <TICKET-SCREW?>>>>
		<PILLAR-MENTIONED? T>
		<TELL CR "You notice a pillar here, with a single Gush-O-Slush(R)
Spam-For-The-Ears(TM) speaker producing sound at a particularly high volume. In the ceiling above the pillar, there's a grate covering a duct of some sort." CR>)>)>
  .VAL>

<OBJECT ZALAGASA-DESK
	(LOC ROOMS)
	(SDESC SDESC-DESK)
	(FLAGS IN-TERMINAL LIGHTED LOCATION INDOORS SPECIAL-DROP)
	(SOUTH TO ZALAGASA-CONCOURSE)
	(WEST PER PREVIOUS-CONCOURSE)
	(EAST PER NEXT-CONCOURSE)
	(GLOBAL AIRPORT-CROWD SKYCAPS AIRPORT-MUSIC SIGNS ACTUAL-DESK)
	(OVERHEAD SIGNS)
	(ACTION AIRLINE-DESK-F)
	(THINGS PSEUDO-VEC)>

<OBJECT ACTUAL-ZDESK
	(LOC ZALAGASA-DESK)
	(DESC "Air Zalagasa desk")
	(FLAGS NODESC SURFACE PLACE)
	(CAPACITY 25)
	(SYNONYM DESK)
	(ADJECTIVE ZALAGASA AIRLINE AIRLINES CHECK-IN TICKET)
	(ACTION ACTUAL-DESK-F)>

<DEFINE I-ZALAGASA-DESK DESK ("OPTIONAL" (CR T) "AUX" N)
  <SET N <DESK-ZSCRIPT>>
  <DESK-ZSCRIPT <SET N <+ .N 1>>>
  <COND (<OR <L=? .N 1>
	     <G? .N 10>>
	 <RETURN <> .DESK>)>
  <COND (<AND <T? .CR>
	      <N==? .N 6>>
	 <ZCRLF>)>
  <COND (<==? .N 2>
	 <COND (<T? <DESK-LOSER?>>
		<CLERK-LISTENING? T>
		<CLERK-WORKING? <>>
		<TELL "Somehow, the clerk proceeded with commendable
efficiency, and you now find yourself at the front of the line">
		<COND (<N==? <DESK-LOSER?> 3>
		       <TELL " once again. \"Welcome back, ">)
		      (T
		       <TELL ". \"Good day, ">)>	
		<SIR-OR-MAAM>
		<TELL ",\" smiles the clerk. \"May I help you?\"" CR>
		<DESK-ZSCRIPT 5>
		<RETURN T .DESK>)>
	 <MOVE ,FATSO ,HERE>
	 <SETG P-HIM-OBJECT ,FATSO>
	 <TELL
"There's now only one person, a very fat man, standing in front of you. He explains to the clerk that he wishes to exchange the ticket he has for one to Mombasa the month after, only instead of it being a direct return he wants to come back via Nice instead and spend a week there or maybe longer because he's meeting his wife who'll be flying in from Rome, Italy, and can he use part of his accumulated Frequent Flyer mileage to offset the price of her connexion between Hong Kong and Rome? She'll be in Hong Kong before going to Rome, he adds, by way of explanation" ,PCR CTHE ,FATSO " seems to be tapping his feet to the indistinguishable beat of ">
	 <SAY-MUZAK>
	 <TELL ,PCR>
	 <FIRST-ZALAG-PAGE>
	 <RETURN T .DESK>)
	(<==? .N 3>
	 <TELL CTHE ,FATSO
" in front of you explains that his wife already has a ticket with Cathay Pacific from Hong Kong to Rome, and wonders if it is possible to change that to Air Zalagasa and use some of his mileage credits. The clerk explains that Air Zalagasa do not fly that route, and that mileage credits aren't transferable to other passengers anyway. The man says that he'd heard that on some airlines it was and the clerk says not as far as ">
	 <COND (<IS? ,AIRCLERK ,FEMALE>
		<TELL "s">)>
	 <TELL 
"he knows, the man says that's a pity, the clerk agrees, and starts to look up next month's flights to Mombasa." CR>
	 <SECOND-ZALAG-PAGE>)
	(<==? .N 4>
	 <TELL CTHE ,FATSO
" in front of you turns to you and smiles. \"Takes forever, doesn't it? I thought you could transfer these Frequent Flyer things. Should be able to for your wife. Isn't the music great?\" He turns back to the clerk without listening for your answer." CR>)
	(<==? .N 5>
	 <ZREMOVE ,FATSO>
	 <COND (<IS? ,AIRCLERK ,FEMALE>
		<SETG P-HIM-OBJECT ,NOT-HERE-OBJECT>)
	       (T
		<SETG P-HIM-OBJECT ,AIRCLERK>)>
	 <TELL CTHE ,AIRCLERK
	       " explains to " THE ,FATSO " in front of you that flights to Mombasa go via Paris which means changing airports, and that on his fare schedule he wouldn't be allowed a stopover in Nice." CR>
	 <LAST-ZALAG-PAGE>
	 <TELL CR CTHE ,FATSO
" in front of you says he won't bother, then, he'll just go to Nice next month as he originally planned. The clerk hopes that he has a nice day, the man walks away, and the clerk turns to you. ">
	 <DESK-LOSER? 2>
	 <WELCOME-TO-DESK>)
	(<==? .N 6>
	 <COND (<T? <CLERK-WORKING?>>
		<DESK-ZSCRIPT 5>
		<RETURN <> .DESK>)
	       (T
		<COND (.CR <ZCRLF>)>
		<CLERK-WAITING>)>)
	(T
	 <CLERK-BYE>)>
  T>

<DEFINE FIRST-ZALAG-PAGE ()
	 <JUST-HEARD? T>
	 <TELL
"A voice on the public address system says, \"Air
Zalagasa announce the imminent departure of flight 42 to Paris, with service to Zalagasa. Would all remaining passengers please check in immediately at the Air Zalagasa desk.
Thank you.\"" CR>>

<DEFINE SECOND-ZALAG-PAGE ()
	 <JUST-HEARD? T>
	 <TELL CR "\"Air
Zalagasa announce the momentary departure of flight 42 to Paris. All passengers should be on board at this time.\"" CR>>

<DEFINE LAST-ZALAG-PAGE ()
	 <JUST-HEARD? T>
	 <TELL CR "\"Air
Zalagasa announce the departure of flight 42 to Paris. This flight is now closed. Have a nice day.\"" CR>>

<CONSTANT TICKET-TYPE-TABLE
	  <PLTABLE T
		   <PLTABLE <VOC "DIRECT">>
		   <PLTABLE <VOC "NONSTOP"> <VOC "NON-STOP"> <VOC "NON">>>>

<DEFINE DO-TICKET DT (OBJ "OPT" (SWAP? T) "AUX" WD)
  <COND (<==? .OBJ ,TICKET>
	 <COND (<T? <TICKET-SCREW?>>
		<TELL "\"I've already explained that that flight is long gone.
You'll have to take care of this through Omnia Gallia or the travel agent who
originally issued the ticket. I really can't help you at all,\" apologises ">
		<TURNING-ATTENTION>
		<UPDATE-BP 2>
		<RETURN T .DT>)>
	 <SET WD
	  <GET-1-OF-N "\"Ah, Omnia Gallia. I think you'll find our food much better.
You have two choices: either you can get a ticket direct to Paris through
Zalagasa, at the same price, or for an additional $200, in cash, you can get a
nonstop to Paris. Which will it be?\""
		      ,TICKET-TYPE-TABLE
		      -1
		      "Direct, or non-stop?\"">>
	 <COND (<==? .WD ,W?DIRECT>
		<TELL "\"Very good, ">
		<SIR-OR-MAAM>
		<TELL ". Here's your new ticket, on our Flight 42. Have a nice
day!\" burbles ">
		<ZREMOVE ,TICKET>
		<MOVE ,ZTICKET ,PLAYER>
		<TICKET-SCREW? T>
		<TURNING-ATTENTION>
		<UPDATE-SCORE 1>)
	       (T
		<WAITING-FOR-CASH? T>
		<TELL "\"As you wish, ">
		<SIR-OR-MAAM>
		<TELL ". That will be $200, please.\"" CR>
		T)>)
	(<==? .OBJ ,ZTICKET>
	 <TICKET-SCREW? T>
	 <TELL "\"I'm really terribly sorry, ">
	 <SIR-OR-MAAM>
	 <TELL ", but that flight has already left the gate. " ,DONT "really
expect me to break into the tower and make it come back, now, do you? If you have any
problems, you'll have to go back to the Omnia Gallia desk, since it's really
their ticket. They may be able to give you a flight on a later date, and then
you can exchange that for one of our flights. ">
	 <COND (<T? .SWAP?>
		<TELL "Meantime, I'll just take your
new ticket, and you can have your old one back -- I don't think Omnia Gallia
would accept one of our tickets. ">
		<MOVE ,TICKET ,PLAYER>
		<ZREMOVE ,ZTICKET>)>
	 <TELL "Have a nice day!\" burbles ">
	 <TURNING-ATTENTION>
	 <UPDATE-BP 2>
	 T)>>

<DEFINE ASK-ABOUT-42 ()
  <DO-TICKET ,ZTICKET <>>>

<OBJECT PILLAR
	(LOC LOCAL-GLOBALS)
	(DESC "pillar")
	(FLAGS NODESC)
	(SYNONYM PILLAR)
	(ACTION PILLAR-F)
	(THINGS PSEUDO-VEC)>

<DEFINE PILLAR-F ()
	 <COND (<THIS-PRSI?>
		<>)
	       (<VERB? EXAMINE>
		<TELL CTHEO " is tall and narrow. The signs on it point to various airlines:" CR>
		<LIST-SIGNS>
		T)
	       (<VERB? READ LOOK-ON>
		<TELL "The signs on " THEO "say:" CR>
		<LIST-SIGNS>
		T)
	       (<VERB? CLIMB-UP CLIMB-ON CLIMB-OVER>
		<COND (<HERE? PILLAR-B DUCT>
		       <ALREADY-AT-TOP>)
		      (T
		       <DO-WALK ,P?UP>)>
		T)
	       (<VERB? CLIMB-DOWN STAND-UNDER>
		<COND (<HERE? ZALAGASA-CONCOURSE>
		       <ALREADY-AT-BOTTOM>)
		      (T
		       <DO-WALK ,P?DOWN>)>
		T)
	       (<VERB? STAND-ON RIDE>
		<COND (<HERE? ZALAGASA-CONCOURSE>
		       <DO-WALK ,P?UP>)
		      (<HERE? DUCT>
		       <DO-WALK ,P?DOWN>)
		      (T
		       <ALREADY-ON>)>
		T)
	       (<VERB? FOLLOW>
		<COND (<HERE? ZALAGASA-CONCOURSE>
		       <DO-WALK ,P?UP>)
		      (<HERE? DUCT>
		       <DO-WALK ,P?DOWN>)
		      (T
		       <V-WALK-AROUND>)>
		T)
	       (<VERB? LOOK-UP>
		<COND (<HERE? PILLAR-B>
		       <V-LOOK>)
		      (<HERE? DUCT>
		       <ALREADY-AT-TOP>)
		      (T
		       <TELL "The signs on " THEO "say:" CR>
		       <LIST-SIGNS>)>
		T)
	       (<VERB? LOOK-DOWN>
		<COND (<HERE? ZALAGASA-CONCOURSE>
		       <ALREADY-AT-BOTTOM>)
		      (T
		       <TELL "The height makes you dizzy." CR>)>
		T)
	       (T
		<>)>>

<OBJECT PILLAR-A
	(LOC ROOMS)
	(DESC "Pillar")
	(FLAGS SPECIAL-DROP NO-NERD LIGHTED LOCATION IN-TERMINAL)
	(BELOW AIRPORT-CROWD)
	(HEAR AIRPORT-MUSIC)
	(UP PER UP-PILLAR)
	(DOWN PER DOWN-PILLAR)
	(NORTH SORRY "You'd fall if you went that way.")
	(EAST SORRY "You'd fall if you went that way.")
	(SOUTH SORRY "You'd fall if you went that way.")
	(WEST SORRY "You'd fall if you went that way.")
	(GLOBAL AIRPORT-CROWD PILLAR AIRPORT-MUSIC SIGNS GRATE GSPEAKER)
	(ACTION PILLAR-A-F)
	(LDESC "You're halfway up the pillar.")
	(THINGS PSEUDO-VEC)>

<DEFINE PILLAR-A-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-ENTERED>
		<COND (<NOT <IS? ,AIRPORT-CROWD ,SEEN>>
		       <MAKE ,AIRPORT-CROWD ,SEEN>
		       <TELL CR
"A crowd of curious onlookers are gathering below." CR>
		       T)
		      (T
		       <>)>)
	       (T
		<>)>>

<DEFINE UP-PILLAR ("AUX" PH)
  <COND (<==? ,HERE ,PILLAR-A>
	 <TELL "You shin further up the pillar. This is getting very dangerous" ,PCR>
	 ,PILLAR-B)
	(<==? ,HERE ,ZALAGASA-CONCOURSE>
	 <TELL
"Dangerous. Very risky. The pillar is quite narrow and smooth, and doesn't offer much in the way of grip. Nevertheless, you manage to climb about halfway up before you take a break" ,PCR>
	 ,PILLAR-A)>>

<DEFINE DOWN-PILLAR ()
  <COND (<HERE? ,PILLAR-B>
	 <TELL "You cautiously descend the pillar" ,PCR>
	 ,PILLAR-A)
	(T
	 <TELL "You slide the last few feet to the floor">
	 <COND (<F? <MUSIC-DEAD?>>
		<TELL ,PCR>
		,ZALAGASA-CONCOURSE)
	       (T
		<TELL 
", where a grateful cheering crowd carries you shoulder high to the front of the check-in desk.">
		<COND (<META-IN? ,ABOOK ,PLAYER>
		       <REMOVE ,ABOOK>
		       <TELL " Unfortunately, the awkward position causes you to lose your " D ,ABOOK " before you arrive. At the desk">)
		      (T
		       <TELL " There">)>
		<FLIGHT-GONE? T>
		<COND (<AND <META-IN? ,ZTICKET ,PLAYER>
			    <T? <FLIGHT-RECALLED?>>>
		       <TELL ", you are quickly issued a boarding card and passed into the personal care of a passing airline official, who whisks you through all the formalities in a way which shows it's perfectly possible really, if they put their minds to it. Within three minutes you are sitting in a seat on a plane, and three minutes later still you have taken off and the plane is safely on its way to Zalagasa." CR>
		       <GO-TO-PLANE>
		       <>)
		      (<F? <FLIGHT-RECALLED?>>
		       <TELL ", an airline official points out that the
" D ,PLANE " has indeed left the terminal, so it's quite impossible for you to
board, whether or not you have a ticket. There's nothing he can do, it's too
late to recall the flight, and you'll just have to wait until another day.
Provided, of course, that Omnia Gallia will exchange your ticket. He certainly
can't provide any cash to get you home -- it's absolutely not his fault that
you missed your flight." CR>
		       <UPDATE-BP 150>
		       <>)
		      (T
		       <TELL ", an airline official expresses deep regret
that you can not be permitted to board your flight, even if you have caused it
to return to the gate. You simply don't have a valid ticket, and there's nothing
to be done about it. Furthermore, they can't hold the flight while you get one,
since it's already late. Something about his tone of voice is unbelievably
irritating." CR>
		       ; "you dead, Jack"
		       <UPDATE-BP 150>
		       <>)>)>)>>

<OBJECT PILLAR-B
	(LOC ROOMS)
	(DESC "Top of Pillar")
	(FLAGS SPECIAL-DROP NO-NERD LIGHTED LOCATION IN-TERMINAL)
	(HEAR AIRPORT-MUSIC)
	(BELOW AIRPORT-CROWD)
	(NORTH SORRY "You'd fall if you went that way.")
	(EAST SORRY "You'd fall if you went that way.")
	(SOUTH SORRY "You'd fall if you went that way.")
	(WEST SORRY "You'd fall if you went that way.")
	(UP TO DUCT IF GRATE IS OPEN)
	(IN TO DUCT IF GRATE IS OPEN)
	(DOWN PER DOWN-PILLAR)
	(GLOBAL AIRPORT-CROWD PILLAR GRATE DUCT AIRPORT-MUSIC SIGNS)
	(ACTION PILLAR-B-F)
	(THINGS PSEUDO-VEC)>

<DEFINE PILLAR-B-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL "You're at the top of the pillar. A">
		<OPEN-CLOSED ,GRATE>
		<TELL " is visible in the ceiling overhead, and there's
a speaker attached to the pillar here." CR>
		T)
	       (<EQUAL? .CONTEXT ,M-ENTERED>
		<COND (<NOT <IS? ,AIRPORT-CROWD ,TOUCHED>>
		       <MAKE ,AIRPORT-CROWD ,TOUCHED>
		       <TELL CR "The crowd below is growing." CR>
		       T)
		      (T
		       <>)>)
	       (T
		<>)>>

<OBJECT GSPEAKER
	(LOC LOCAL-GLOBALS)
	(DESC "speaker")
	(FLAGS TRYTAKE NOALL SURFACE)
	(CAPACITY 5)
	(SYNONYM SPEAKER LOUDSPEAKER)
	(ADJECTIVE GUSH\-O\-SLUSH)
	(DESCFCN GSPEAKER-F)
	(ACTION GSPEAKER-F)>

<OBJECT SPEAKER
	(LOC PILLAR-B)
	(DESC "speaker")
	(FLAGS TRYTAKE NOALL SURFACE NODESC)
	(CAPACITY 5)
	(SYNONYM SPEAKER LOUDSPEAKER)
	(ADJECTIVE GUSH\-O\-SLUSH)
	(DESCFCN GSPEAKER-F)
	(ACTION SPEAKER-F)>

<DEFINE SPEAKER-F ("OPTIONAL" (CONTEXT <>))
	<COND (<T? .CONTEXT>
	       <>)
	      (<THIS-PRSI?>
	       <COND (<VERB? PUT-ON PUT EMPTY-INTO>
		      <COND (<PRSO? RWIRE BWIRE>
			     <BEYOND-REPAIR>)
			    (T
			     <NO-GOOD-SURFACE>)>
		      T)
		     (<AND <VERB? TAKE>
			   <PRSO? BWIRE RWIRE>>
		      <PERFORM ,V?PULL ,PRSO>
		      T)
		     (T
		      <>)>)
	      (<VERB? EXAMINE LOOK-ON READ LOOK-BEHIND SEARCH>
	       <COND (<NOT <VERB? LOOK-BEHIND SEARCH>>
		      <TELL
		       "It's a perfectly ordinary Gush-O-Slush(R) Spam-For-The-Ears(TM) speaker">
		      <COND (<F? <SPEAKER-DEAD?>>
			     <TELL ", playing ">
			     <VERY-LOUDLY <>>)
			    (T
			     <TELL ".">)>
		      <ZCRLF>)>
	       <COND (<HERE? PILLAR-B>
		      <TELL CR "Peering behind " THEO ", you notice ">
		      <COND (<IS? ,RWIRE ,CONNECTED>
			     <TELL A ,RWIRE>
			     <COND (<IS? ,BWIRE ,CONNECTED>
				    <TELL " and " A ,BWIRE
					  " connected to the back." CR>)
				   (T
				    <WITH-DANGLING ,BWIRE>)>
			     T)
			    (<IS? ,BWIRE ,CONNECTED>
			     <TELL A ,BWIRE>
			     <WITH-DANGLING ,RWIRE>)
			    (T
			     <TELL A ,RWIRE " and " A ,BWIRE
				   " dangling from the back." CR>)>)>
	       T)
	      (<VERB? REPAIR>
	       <COND (<T? <SPEAKER-DEAD?>>
		      <TELL "Alas, you're not licensed to repair Gush-O-Slush(R) Spam-For-The-Ears(TM) speakers." CR>)
		     (T
		      <TELL "If anything, the speaker is working too well." CR>)>)
	      (<VERB? SHORT CROSS>
	       <COND (<T? <MUSIC-DEAD?>>
		      <CANT-SHORT-TWICE>)
		     (T
		      <TELL "Capital idea. How do you propose to do it?" CR>)>
	       T)
	      (<AND <VERB? LISTEN>
		    <F? <SPEAKER-DEAD?>>>
	       <TELL CTHEO " plays ">
	       <VERY-LOUDLY>
	       T)
	      (<VERB? EMPTY REACH-IN OPEN CLOSE>
	       <TELL CTHEO " is permanently sealed." CR>
	       T)
	      (<MOVING?>
	       <FIRMLY-ATTACHED ,PRSO ,PILLAR>
	       T)
	      (T
	       <>)>>

<DEFINE GSPEAKER-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-OBJDESC>
		<TELL 
"A speaker is attached to the top of the pillar">
		<COND (<F? <SPEAKER-DEAD?>>
		       <TELL ", playing ">
		       <VERY-LOUDLY <>>)
		      (T
		       <TELL ".">)>
		T)
	       (<T? .CONTEXT>
		<>)
	       (<OR <TOUCHING?>
		    <MOVING?>>
		<TELL ,CANT "reach " THE ,SPEAKER ,PERIOD>)
	       (<VERB? EXAMINE LOOK-ON READ>
		<COND (<NOT <VERB? LOOK-BEHIND SEARCH>>
		       <TELL
"It's a perfectly ordinary Gush-O-Slush(R) Spam-For-The-Ears(TM) speaker">
		       <COND (<F? <SPEAKER-DEAD?>>
			      <TELL ", playing ">
		       	      <VERY-LOUDLY <>>)
			     (T
			      <TELL ".">)>
		       <ZCRLF>)>
		T)
	       (<VERB? LOOK-BEHIND SEARCH>
		<TELL "You can't see much from here." CR>)
	       (<AND <VERB? LISTEN>
		     <F? <SPEAKER-DEAD?>>>
		<TELL CTHEO " plays ">
		<VERY-LOUDLY>
		T)
	       (T
		<>)>>

<DEFINE WITH-DANGLING (X)
	 <TELL " connected to the back, with "
	       A .X " dangling beside it." CR>>

<DEFINE VERY-LOUDLY ("OPTIONAL" (CR T))
	 <JUST-HEARD? T>
	 <SAY-MUZAK>
	 <TELL " very loudly and soothingly at you.">
	 <COND (<T? .CR>
		<ZCRLF>)>
	 T>

<OBJECT BWIRE
	(LOC SPEAKER)
	(DESC "black wire")
	(FLAGS NODESC TRYTAKE NOALL TOUCHED)
	(SYNONYM WIRE WIRES PAIR)
	(ADJECTIVE BLACK TWO)
	(GENERIC GENERIC-WIRE-F)
	(OTHER-WIRE RWIRE)
	(ACTION WIRES-F)>

<OBJECT RWIRE
	(LOC SPEAKER)
	(DESC "red wire")
	(FLAGS NODESC TRYTAKE NOALL TOUCHED)
	(SYNONYM WIRE WIRES PAIR)
	(ADJECTIVE RED TWO)
	(OTHER-WIRE BWIRE)
	(GENERIC GENERIC-WIRE-F)
	(ACTION WIRES-F)>

<BIT-SYNONYM TOUCHED CONNECTED>

<DEFINE WIRES-F ("AUX" X)
	 <SET X <MULTIWIRE?>>
	 <COND (<T? .X>
		.X)
	       (<THIS-PRSI?>
		<>)
	       (<VERB? EXAMINE>
		<TELL CTHEO " is ">
		<COND (<IS? ,PRSO ,CONNECTED>
		       <TELL "connected to ">)
		      (T
		       <TELL "dangling from ">)>
		<TELL "the back of " THE ,SPEAKER ,PERIOD>
		T)
	       (<VERB? PLUG TOUCH-TO SHORT CROSS>
		<COND (<IS? ,PRSO ,CONNECTED>
		       <TELL CTHEO " is already connected to "
			     THE ,SPEAKER ,PERIOD>
		       T)
		      (<EQUAL? ,PRSI <GETP ,PRSO ,P?OTHER-WIRE>>
		       <COND (<T? <MUSIC-DEAD?>>
			      <CANT-SHORT-TWICE>)
			     (T
			      <TOUCH-WIRES-TOGETHER>)>
		       T)
		      (<NOT <EQUAL? ,PRSI ,SPEAKER>>
		       <>)
		      (T
		       <BEYOND-REPAIR>
		       T)>)
	       (<VERB? REPLUG CLOSE>
		<COND (<IS? ,PRSO ,CONNECTED>
		       <TELL "You'd have to disconnect it from "
			     THE ,SPEAKER " first." CR>
		       T)
		      (<ZERO? ,PRSI>
		       <BEYOND-REPAIR>
		       T)
		      (<EQUAL? ,PRSI <GETP ,PRSO ,P?OTHER-WIRE>>
		       <COND (<T? <MUSIC-DEAD?>>
			      <CANT-SHORT-TWICE>
			      T)
			     (T <>)>)
		      (<NOT <EQUAL? ,PRSI ,SPEAKER>>
		       <>)
		      (T
		       <BEYOND-REPAIR>
		       T)>)
	       (<VERB? PULL UNPLUG LOOSEN OPEN>
		<COND (<IS? ,PRSO ,CONNECTED>
		       <MOVE ,PRSO ,PILLAR-B>
		       <SPEAKER-DEAD? T>
		       <UNMAKE ,PRSO ,CONNECTED>
		       <TELL "You grasp " THEO " and, with a firm yank, pull it out of the Gush-O-Slush(R) Spam-For-The-Ears(TM) speaker." CR>
		       <COND (<IS? <GETP ,PRSO ,P?OTHER-WIRE> ,CONNECTED>
			      <TELL CR
"Pop! The speaker emits an electric squawk and stops playing ">
			      <SAY-MUZAK>
			      <TELL " very soothingly.|
|
You hear a patter of applause from the crowd below. Alas, music can still
be heard from the many other speakers in the terminal." CR>)>
		       T)
		      (T
		       <TELL CTHEO " is already disconnected." CR>
		       T)>)
	       (T
		<>)>>

<DEFINE GENERIC-WIRE-F (TBL)
	 <COND (<EQUAL? ,P-IT-OBJECT ,BWIRE ,RWIRE>
		,P-IT-OBJECT)
	       (<PRSO-NOUN-USED? ,W?WIRES ,W?PAIR>
		,BWIRE)
	       (T <>)>>

<DEFINE MULTIWIRE? MW ("AUX" X)
	 <COND (<THIS-PRSI?>
		<RETURN <> .MW>)
	       (<AND <F? ,OBJECTS-GROUPED>
		     <F? ,P-MULT?>>
		<COND (<NOUN-USED? ,W?WIRES ,W?PAIR>
		       <COND (<F? <ADJ-USED? ,W?BLACK ,W?RED>>
			      <ZPUT ,P-PRSO 0 2>
			      <ZPUT ,P-PRSO 1 ,BWIRE>
			      <ZPUT ,P-PRSO 2 ,RWIRE>
			      <SETG OBJECTS-GROUPED T>)
			     (T
			      <TELL "There's only one wire of each colour."
				    CR>
			      <RETURN T .MW>)>)>)>
	 <COND (<F? ,OBJECTS-GROUPED>
		<>)
	       (<VERB? SHORT CROSS SINGLE-CONNECT>
		<TOUCH-WIRES-TOGETHER>
		T)
	       (T
		<MAIN-LOOP T>
		T)>>

<DEFINE CANT-SHORT-TWICE ()
	 <TELL 
"The Gush-O-Slush(R) repair crew hasn't arrived to fix the sound system yet. " ,CANT "short it out again until they do fix it. So think of something else." CR>
	 T>

<DEFINE TOUCH-WIRES-TOGETHER ()
	 <COND (<T? <MUSIC-DEAD?>>
		<CANT-SHORT-TWICE>
		T)
	       (<IS? ,BWIRE ,CONNECTED>
		<COND (<IS? ,RWIRE ,CONNECTED>
		       <TELL "The wires are">
		       <STILL-CONNECTED>)
		      (T
		       <TELL CTHE ,BWIRE " is">
		       <STILL-CONNECTED>)>
		T)
	       (<IS? ,RWIRE ,CONNECTED>
		<TELL CTHE ,RWIRE " is">
		<STILL-CONNECTED>
		T)
	       (T
		<MUSIC-DEAD? T>
		<PUTP ,PILLAR-B ,P?HEAR AIRPORT-CROWD>
		<PUTP ,PILLAR-A ,P?HEAR AIRPORT-CROWD>
		<PUTP ,DUCT ,P?HEAR 0>
		<PUTP ,TOWER-DUCT ,P?HEAR 0>
		<DEQUEUE I-TERMINAL>
		<TELL "With an electric squawk, all the other Gush-O-Slush(R) Spam-For-The-Ears(TM) speakers in the entire terminal stop playing ">
		<SAY-MUZAK>
		<TELL " very soothingly.|
|
The applause of the crowd is deafening." CR>
		<UPDATE-SCORE 1>
		T)>>

<DEFINE STILL-CONNECTED ()
	 <TELL " still connected to " THE ,SPEAKER ,PERIOD>>

<DEFINE BEYOND-REPAIR ()
	 <TELL "Sorry. You damaged " THEO " beyond repair." CR>>

<OBJECT GRATE
	(LOC LOCAL-GLOBALS)
	(DESC "grate")
	(FLAGS NODESC DOORLIKE OPENABLE SURFACE)
	(CAPACITY 50)
	(SYNONYM GRATE GRATING)
	(ADJECTIVE CLOSED SHUT)
	(ACTION GRATE-F)>

<DEFINE GRATE-F ()
	 <COND (<THIS-PRSI?>
		<>)
	       (<AND <VERB? LOOK-INSIDE LOOK-BEHIND LOOK-UNDER SEARCH>
		     <NOT <IS? ,PRSO ,OPENED>>>
		<CANT-SEE-MUCH>
		T)
	       (<ENTERING?>
		<COND (<HERE? PILLAR-B>
		       <DO-WALK ,P?UP>)
		      (<AND <HERE? DUCT>
			    <==? <DUCT-NUMBER> 0>>
		       <DO-WALK ,P?DOWN>)
		      (T
		       <TELL ,CANT "reach " THEO " from here." CR>)>)
	       (<TOUCHING?>
		<COND (<OR <HERE? PILLAR-B>
			   <AND <HERE? DUCT>
				<==? <DUCT-NUMBER> 0>>>
		       <COND (<AND <VERB? OPEN>
				   <FIRST? ,PRSO>>
			      <TELL "The objects on the grate fall out of the duct and disappear." CR>
			      <MOVE-ALL ,PRSO ,LANDF>
			      <>)
			     (T <>)>)
		      (T
		       <TELL ,CANT "reach " THEO " from here." CR>)>)
	       (T <>)>>

<OBJECT TOWER-GRATE
	(LOC LOCAL-GLOBALS)
	(DESC "grate")
	(FLAGS NODESC DOORLIKE OPENABLE)
	(SYNONYM GRATE GRATING)
	(ADJECTIVE CLOSED SHUT)
	(ACTION TOWER-GRATE-F)>

<DEFINE TOWER-GRATE-F ()
	 <COND (<THIS-PRSI?>
		<>)
	       (<VERB? LOOK-INSIDE LOOK-BEHIND LOOK-UNDER SEARCH>
		<COND (<NOT <IS? ,PRSO ,OPENED>>
		       <TELL "Try as you might, you can't see much of anything
through " THEO ,PERIOD>)
		      (T
		       <TELL ,YOU-SEE A ,CONTROLLERS ", hunched over various
consoles" ,PERIOD>)>
		T)
	       (<ENTERING?>
		<DO-WALK ,P?IN>)
	       (T
		<>)>>

<OBJECT DUCT
	(LOC ROOMS)
	(DESC "Duct")
	(FLAGS LOCATION LIGHTED SPECIAL-DROP IN-TERMINAL)
	(SYNONYM DUCT TUBE)
	(ADJECTIVE AIR CONDITIONING)
	(ACTION DUCT-F)
	(HEAR AIRPORT-MUSIC)
	(GLOBAL DUCT PILLAR GRATE)
	(NORTH PER DUCT-NORTH)
	(EAST PER DUCT-EAST)
	(WEST PER DUCT-WEST)
	(SOUTH PER DUCT-SOUTH)
	(UP PER UP-DUCT)
	(DOWN PER DOWN-DUCT)
	(OUT PER OUT-OF-DUCT)>

<DEFINE DUCT-NORTH ("AUX" (DN <DUCT-NUMBER>))
  <COND (<==? .DN 1>
	 <TELL "You hit your head against the duct. Ouch!" CR>
	 <>)
	(<==? .DN 2>
	 <DOWN-DUCT>)
	(T
	 <UP-DUCT>)>>

<DEFINE DUCT-WEST ("AUX" (DN <DUCT-NUMBER>))
  <COND (<==? .DN 3>
	 <DOWN-DUCT>)
	(T
	 <TELL "You hit your head against the duct. Ouch!" CR>
	 <>)>>

<DEFINE DUCT-EAST ("AUX" (DN <DUCT-NUMBER>))
  <COND (<==? .DN 2>
	 <UP-DUCT>)
	(T
	 <TELL "You hit your head against the duct. Ouch!" CR>
	 <>)>>

<DEFINE DUCT-SOUTH ()
  <COND (<==? <DUCT-NUMBER> 1>
	 <UP-DUCT>)
	(T
	 <TELL "You hit your head against the duct. Ouch!" CR>
	 <>)>>

<DEFINE OUT-OF-DUCT ()
  <COND (<==? <DUCT-NUMBER> 1>
	 <DOWN-DUCT>)
	(T
	 <WHICH-WAY-OUT>)>>

<DEFINE UP-DUCT ("AUX" (N <DUCT-NUMBER>))
  <TELL "You crawl higher into the duct" ,PCR>
  <COND (<==? .N 3>
	 ,TOWER-DUCT)
	(T
	 <DUCT-NUMBER <SET N <+ .N 1>>>
	 <UNMAKE ,DUCT ,TOUCHED>
	 ,DUCT)>>

<DEFINE DOWN-DUCT ("AUX" (N <DUCT-NUMBER>))
  <COND (<N==? ,HERE ,TOWER-DUCT>
	 <DUCT-NUMBER <SET N <- .N 1>>>)>
  <COND (<0? .N>
	 <COND (<NOT <IS? ,GRATE ,OPENED>>
		<TELL "The grating blocks your way." CR>
		<DUCT-NUMBER 1>
		<>)
	       (T
		,PILLAR-B)>)
	(T
	 <TELL "You slip down the duct" ,PCR>
	 <UNMAKE ,DUCT ,TOUCHED>
	 ,DUCT)>>

<DEFINE BOTTOM-DUCT? ()
  <COND (<AND <HERE? DUCT>
	      <==? <DUCT-NUMBER> 1>> T)
	(T <>)>>

<DEFINE DUCT-F ("OPTIONAL" (CONTEXT <>) "AUX" (DN <DUCT-NUMBER>))
	 <COND (<==? .CONTEXT ,M-ENTERING>
		<COND (<0? .DN> <DUCT-NUMBER 1>)>
		<COND (<BOTTOM-DUCT?> <UNMAKE ,GRATE ,INVISIBLE>)
		      (T <MAKE ,GRATE ,INVISIBLE>)>
		<>)
	       (<==? .CONTEXT ,M-LOOK>
		<COND (<==? .DN 1>
		       <TELL "You're at the bottom of an air conditioning duct that curves upward to the south. A">
		       <OPEN-CLOSED ,GRATE>
		       <TELL " leads downward." CR>)
		      (<==? .DN 2>
		       <TELL "You're in a narrow air conditioning duct that curves upward to the east, and downward to the north." CR>)
		      (<==? .DN 3>
		       <TELL "You're in a narrow air conditioning duct that curves upward to the north, and downward to the west." CR>)>)
	       (<T? .CONTEXT> <>)
	       (<THIS-PRSI?>
		<>)
	       (<VERB? CLIMB-UP CLIMB-ON CLIMB-OVER>
		<DO-WALK ,P?UP>
		T)
	       (<ENTERING?>
		<COND (<HERE? PILLAR-B>
		       <DO-WALK ,P?UP>)
		      (<HERE? IN-TOWER>
		       <DO-WALK ,P?IN>)
		      (T
		       <ALREADY-IN>)>
		T)
	       (<EXITING?>
		<COND (<HERE? PILLAR-B>
		       <NOT-IN>)
		      (T
		       <DO-WALK ,P?DOWN>)>
		T)
	       (<VERB? CLIMB-DOWN>
		<COND (<HERE? PILLAR-B>
		       <NOT-IN>)
		      (T
		       <DO-WALK ,P?DOWN>)>
		T)
	       (<HERE-F>
		T)
	       (T
		<>)>>

<OBJECT TOWER-DUCT
	(LOC ROOMS)
	(DESC "Duct")
	(FLAGS SPECIAL-DROP LIGHTED LOCATION IN-TERMINAL)
	(HEAR AIRPORT-MUSIC)
	(DOWN PER DOWN-DUCT)
	(SOUTH PER DOWN-DUCT)
	(UP SORRY "The duct doesn't go any higher.")
	(WEST SORRY "You hit your head against the duct. Ouch!")
        (NORTH SORRY "You hit your head against the duct. Ouch!")
	(IN TO IN-TOWER IF TOWER-GRATE IS OPEN)
	(EAST TO IN-TOWER IF TOWER-GRATE IS OPEN)
	(OUT PER WHICH-WAY-OUT)
	(GLOBAL TOWER-GRATE DUCT AIRPORT-MUSIC IN-TOWER)
	(ACTION TOWER-DUCT-F)>

<DEFINE TOWER-DUCT-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL 
"You're at the top end of a narrow air conditioning duct. Light filters in through a">
		<OPEN-CLOSED ,TOWER-GRATE>
		<TELL " to the east." CR>
		T)
	       (T
		<>)>>

"*** FATSO ***"

<OBJECT FATSO
	(DESC "fat man")
	(FLAGS PERSON LIVING)
	(SYNONYM MAN GUY FELLOW)
	(ADJECTIVE FAT OBESE)
	(DESCFCN FATSO-F)
	(ACTION FATSO-F)>

<DEFINE FATSO-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-OBJDESC>
		<TELL CA ,FATSO " is standing in front of you.">
		T)
	       (<T? .CONTEXT>
		<>)
	       (<THIS-PRSI?>
		<COND (<VERB? GIVE SHOW>
		       <FATSO-BUSY>
		       T)
		      (T
		       <>)>)
	       (<VERB? TELL YELL HELLO GOODBYE BOW WAVE-AT QUESTION REPLY
		       THANK ASK-FOR ASK-ABOUT>
		<FATSO-BUSY>
		,FATAL-VALUE)
	       (<VERB? EXAMINE>
		<TELL CTHEO " is chatting with " THE ,AIRCLERK ,PERIOD>
		T)
	       (<HURTING?>
		<TELL CTHEO " is too fat to notice your attempt." CR>
		T)
	       (T
		<>)>>

<DEFINE FATSO-BUSY ()
	 <TELL CTHE ,FATSO " is too busy chatting with " THE ,AIRCLERK
	       " to respond." CR>>


<OBJECT ZTICKET
	(DESC "airline ticket")
	(FLAGS TAKEABLE READABLE VOWEL)
	(SIZE 1)
	(SYNONYM TICKET PAPER)
	(ADJECTIVE AIRLINE DIRECT)
	(ACTION ZTICKET-F)>

<DEFINE ZTICKET-F ()
	 <COND (<THIS-PRSI?>
		<COND (<VERB? PUT-ON>
		       <WASTE-OF-TIME>
		       T)
		      (T
		       <>)>)
	       (<VERB? EXAMINE LOOK-ON READ>
		<TELL
"It's a round-trip ticket to Paris on Air Zalagasa flight 42, departing ">
		<SHOW-FIELD ,CITY-NAME>
		<TELL " Airport at four o'clock this afternoon." CR>
		T)
	       (T
		<>)>>

<OBJECT IN-TOWER
	(LOC ROOMS)
	(DESC "Control Tower")
	(FLAGS NODESC LOCATION IN-TERMINAL LIGHTED NO-NERD INDOORS)
	(SYNONYM TOWER)
	(ADJECTIVE CONTROL AIR TRAFFIC)
	(DOWN TO TOWER-DUCT IF TOWER-GRATE IS OPEN)
	(IN TO TOWER-DUCT IF TOWER-GRATE IS OPEN)
	(OUT TO TOWER-DUCT IF TOWER-GRATE IS OPEN)
	(NORTH SORRY "Air traffic controllers block your path.")
	(SOUTH SORRY "Air traffic controllers block your path.")
	(EAST SORRY "Air traffic controllers block your path.")
	(WEST TO TOWER-DUCT IF TOWER-GRATE IS OPEN)
	(ACTION IN-TOWER-F)
	(HEAR CONSOLE)
	(GLOBAL IN-TOWER DUCT TOWER-GRATE AIRPORT-MUSIC)
	(THINGS PSEUDO-VEC)>

<DEFINE IN-TOWER-F ("OPT" (CONTEXT <>))
	<COND (<==? .CONTEXT ,M-LOOK>
	       <TELL "You're in the air traffic control tower. There's a">
	       <OPEN-CLOSED ,TOWER-GRATE>
	       <TELL " to the west" ,PERIOD>
	       T)
	      (<==? .CONTEXT ,M-ENTERING>
	       <TELL
		"You emerge from the duct amidst a cloud of sparks and steam."
		CR CR>
	       <>)
	      (<==? .CONTEXT ,M-ENTERED>
	       <COND (<IS? ,CONTROLLERS ,NODESC>
		      <UNMAKE ,CONTROLLERS ,NODESC>
		      <TELL CR
"Several air traffic controllers are hunched over consoles." CR>)>
		<COND (<NOT <IS? ,CONTROLLERS ,SEEN>>
		       <QUEUE I-CONSOLE>
		       <TELL CR
"Since air traffic controllers spend most of their lives staring thoughtfully into the clouds, they are a superstitious lot and, understandably, they mistake you, briefly, for some species of god">
		       <COND (<T? ,SEX>
			      <TELL "dess">)>
		       <TELL ". They are also a fairly short-tempered bunch, and with reason. All their working hours are spent looking after pilots and seeing that the poor little lambs are all right and know where they're supposed to be going and don't crash into things, but ">
		       <ITALICIZE "who gets the dates">
		       <TELL " at the end of the day? Not the air traffic controllers, that's who. Bear this in mind as you strut, god">
		       <COND (<T? ,SEX>
			      <TELL "dess">)>
		       <TELL "like, before them. They may think you're a pretty heavy-duty deity right now, but they could come leaping back to their senses at any moment, and a maddened pack of air traffic controllers who realise they've been conned again is not something you would want to be set on by. Ask what you will of them, but be quick about it. And do try to sound like ">
		       <GENDER-PRINT "Sir Laurence Olivier"
				     "Katherine Hepburn">
		       <TELL " if you possibly can." CR>
		       T)
		      (T
		       <TELL 
"The air traffic controllers glare at you with undisguised hostility. \"There ">
		       <COND (<T? ,SEX>
			      <TELL "s">)>
		       <TELL "he is again!\"">
		       <POLICE>
		       T)>)
	      (<==? .CONTEXT ,M-EXIT>
	       <MAKE ,CONTROLLERS ,SEEN>
	       <DEQUEUE I-CONSOLE>
	       <>)
	      (<T? .CONTEXT> <>)
	      (<ENTERING?>
	       <DO-WALK ,P?EAST>
	       T)
	      (<HERE? TOWER-DUCT>
	       <COND (<HERE-F> T)
		     (T <>)>)
	      (<EXITING?>
	       <COND (<HERE? ,IN-TOWER>
		      <DO-WALK ,P?WEST>
		      T)
		     (T <NOT-IN> T)>)
	      (<SEEING?>
	       <CANT-SEE-MUCH> T)
	      (T <>)>>

<DEFINE I-CONSOLE CONSOLE ("OPTIONAL" (CR T) "AUX" (PLANE? T) N)
	 <COND (<OR <T? <FLIGHT-GONE?>>
		    <T? <FLIGHT-RECALLED?>>>
		<SET PLANE? <>>)>
	 <SET N <TOWER-SCRIPT>>
	 <TOWER-SCRIPT <SET N <- .N 1>>>
	 <COND (<EQUAL? .N 3>
		<COND (<F? .PLANE?>
		       <RETURN <> .CONSOLE>)
		      (<T? .CR>
		       <ZCRLF>)>
		<TELL 
"A console radio crackles to life nearby. \"Air Zalagasa flight 42 to ">
		<SHOW-FIELD ,CITY-NAME>
		<TELL " tower. Request permission to take off.\"" CR>
		<RETURN T .CONSOLE>)
	       (<EQUAL? .N 2>
	        <COND (<T? .CR>
		       <ZCRLF>)>
		<TELL 
"The controllers continue to grovel at your smoky apparition." CR>
		<COND (<F? .PLANE?>
		       <RETURN T .CONSOLE>)>
		<TELL CR "\"Air Zalagasa flight 42 to Paris, calling ">
		<SHOW-FIELD ,CITY-NAME>
		<TELL " tower.\" The radio voice sounds a bit miffed. \"Are you guys asleep up there? Permission to take off, granted or denied?\"" CR>
		<RETURN T .CONSOLE>)
	       (<EQUAL? .N 1>
		<COND (<T? .CR>
		       <ZCRLF>)>
		<TELL 
"The air traffic controllers are starting to frown. In the absence of any more smoke and lights you are beginning to appear somewhat less than immortal; distinctly shabby, in fact.|
|
There is a very very nasty pause." CR>
		<COND (<F? .PLANE?>
		       <RETURN T .CONSOLE>)>
		<TELL CR "The radio crackles with indignation. \"">
		<SHOW-FIELD ,CITY-NAME>
		<TELL " tower! ">
		<SHOW-FIELD ,CITY-NAME>
		<TELL " tower! Air Zalagasa flight 42, requesting immediate permission to take off! Permission granted or denied?\"" CR>
		<RETURN T .CONSOLE>)>
	 <COND (<T? .CR>
		<ZCRLF>)>
	 <COND (<T? .PLANE?>
		<TELL 
"The Air Zalagasa pilot on the radio utters an oath that will probably cost him his licence. ">
		<PLANE-TAKES-OFF>
		<ZCRLF>)>
	 <TELL 
"By now, the controllers have rather decided that you're not any sort of god">
	 <COND (<T? ,SEX>
		<TELL "dess">)>
	 <TELL " or deity, but are probably instead a stupid air conditioning repairperson fumbling around in the ducts with no business disrupting the vital work of air traffic controllers.">
	 <POLICE>
	 <RETURN T .CONSOLE>>
	 
<DEFINE PLANE-TAKES-OFF ()
	 <FLIGHT-GONE? T>
	 <DEQUEUE I-CONSOLE>
	 <TELL 
"Moments later, a huge intercontinental jet roars past the tower, barely missing a Piper Cub as it climbs out of sight." CR>>

<OBJECT CONSOLE
	(LOC IN-TOWER)
	(DESC "console")
	(FLAGS NODESC READABLE SURFACE)
	(CAPACITY 10)
	(SYNONYM CONSOLE CONSOLES CONTROLS READOUT READOUTS RADIO)
	(ADJECTIVE CONTROL)
	(DESCFCN CONSOLE-F)
	(ACTION CONSOLE-F)>

<DEFINE CONSOLE-F ()
	 <COND (<THIS-PRSI?>
		<COND (<PUTTING?>
		       <WASTE-OF-TIME>
		       T)
		      (T
		       <>)>)
	       (<VERB? EXAMINE READ LOOK-ON>
		<TELL 
"A readout on a nearby console shows that Air Zalagasa flight 42 is ready to take off." CR>
		T)
	       (<VERB? LISTEN>
		<I-CONSOLE <>>
		,FATAL-VALUE)
	       (T
		<>)>>

"*** CONTROLLERS ***"

<OBJECT CONTROLLERS
	(LOC IN-TOWER)
	(DESC "group of air traffic controllers")
	(FLAGS NODESC LIVING PERSON PLURAL)
	(SYNONYM GROUP BUNCH CROWD CONTROLLERS PEOPLE FOLKS)
	(ADJECTIVE AIR TRAFFIC)
	(DESCFCN CONTROLLERS-F)
	(ACTION CONTROLLERS-F)>

<DEFINE CONTROLLERS-F CONT ("OPTIONAL" (CONTEXT <>) "AUX" (FLIGHT <>)
			    (REQUEST <>))
	 <COND (<EQUAL? .CONTEXT ,M-OBJDESC>
		<TELL CA ,CONTROLLERS
		      " are staring at you">
		<COND (<NOT <IS? ,CONTROLLERS ,SEEN>>
		       <TELL " in awe">)>
		<TELL ".">
		<RETURN T .CONT>)>
	 <COND (<OR <PRSO? THE-FLIGHT>
		    <AND <PRSO? INTNUM>
			 <==? ,P-NUMBER 42>
			 <EQUAL? <ZGET ,P-ADJW 0> <>
				 ,W?FLIGHT ,W?OMNIA ,W?GALLIA>>>
		<SET FLIGHT T>)
	       (<AND <PRSO? REQUEST-OBJECT>
		     <OR <NOUN-USED? ,W?REQUEST>
			 <NOUN-USED? ,W?PERMISSION>>>
		<SET REQUEST T>)>
	 <COND (<EQUAL? .CONTEXT ,M-WINNER>
		<COND (<AND <VERB? HELLO>
			    <==? ,P-PRSA-WORD ,W?NO>
			    <PRSO? ROOMS>>
		       <THEY-STOP-FLIGHT>
		       <RETURN ,FATAL-VALUE .CONT>)
		      (<AND <VERB? DENY REFUSE LAMP-OFF>
			    <OR <T? .REQUEST> <T? .FLIGHT>>>
		       <THEY-STOP-FLIGHT>
		       <RETURN ,FATAL-VALUE .CONT>)
		      (<AND <T? .FLIGHT>
			    <OR <AND <VERB? SPIN>
				     <EQUAL? ,P-PRSA-WORD ,W?TURN ,W?RECALL>>
				<AND <VERB? LAMP-OFF>
				     <EQUAL? ,P-PRSA-WORD ,W?STOP ,W?HALT>>>>
		       <THEY-STOP-FLIGHT>
		       <RETURN ,FATAL-VALUE .CONT>)
		      (<AND <VERB? GET-FOR>
			    <T? .FLIGHT>
			    <PRSI? ME AIRPORT>>
		       <THEY-STOP-FLIGHT>
		       <RETURN ,FATAL-VALUE .CONT>)
		      (<AND <VERB? GRANT>
			    .REQUEST>
		       <THEY-RELEASE-FLIGHT>
		       <RETURN ,FATAL-VALUE .CONT>)
		      (<PRSO? ME>
		       <COND (<VERB? TELL-ABOUT>
			      <ASK-CONTROLLERS-ABOUT>
			      <RETURN ,FATAL-VALUE .CONT>)
			     (<VERB? SSHOW SGIVE SSELL>
			      <ASK-CONTROLLERS-FOR>
			      <RETURN ,FATAL-VALUE .CONT>)>)
		      (<PRSI? ME>
		       <COND (<VERB? SHOW GIVE SELL>
			      <ASK-CONTROLLERS-FOR ,PRSO>
			      <RETURN ,FATAL-VALUE .CONT>)>)>
		<TELL CTHE ,WINNER " are too awed to respond." CR>
		,FATAL-VALUE)
	       (<T? .CONTEXT>
		<RETURN <> .CONT>)
	       (<THIS-PRSI?>
		<COND (<VERB? SHOW>
		       <TELL CTHEI
			     " are struck dumb by the sight of your "
			     D ,PRSO ,PERIOD>
		       <RETURN T .CONT>)
		      (<VERB? GIVE SELL>
		       <TELL CTHEI
" are too awed by the magnificence of your offer to accept it." CR>
		       <RETURN T .CONT>)>
		<RETURN <> .CONT>)
	       (<VERB? TELL>
		<>)
	       (<VERB? EXAMINE>
		<TELL CTHEO " stare back at you in awe and wonder." CR>
		T)
	       (<VERB? ASK-ABOUT>
		<ASK-CONTROLLERS-ABOUT>
		T)
	       (<VERB? ASK-FOR>
		<ASK-CONTROLLERS-FOR>
		T)
	       (T
		<>)>>

<DEFINE ASK-CONTROLLERS-ABOUT ("OPTIONAL" (X <>))
	 <COND (<ZERO? .X>
		<SET X ,PRSI>)>
	 <TELL CTHE ,CONTROLLERS 
" seem afraid to advise to you so trivial a subject as " A .X ,PERIOD>
	 T>

<DEFINE ASK-CONTROLLERS-FOR ("OPTIONAL" (X <>))
	 <COND (<ZERO? .X>
		<SET X ,PRSI>)>
	 <TELL CTHE ,CONTROLLERS 
" turn pale with fear at your request. \"O great one, we have no " D .X
" to ">
	 <ZPRINTB ,P-PRSA-WORD>
	 <TELL " thee,\" they whisper." CR>
	 T>

<DEFINE THEY-RELEASE-FLIGHT ()
	 <COND (<SHALL-BE-DONE "granted. Take off">
		<GRANT-PLANE-REQUEST>)>
	 T>

<DEFINE THEY-STOP-FLIGHT ()
	 <COND (<SHALL-BE-DONE "denied. Return to terminal">
	 	<TURN-AROUND-PLANE>)>
	 T>

<DEFINE SHALL-BE-DONE (STR)
	 <TELL "One of the controllers prostrates himself at your words. \"">
	 <COND (<OR <T? <FLIGHT-GONE?>>
		    <T? <FLIGHT-RECALLED?>>>
		<TELL 
"Alas, O mighty one, it is too late. That flight has already ">
		<COND (<T? <FLIGHT-GONE?>>
		       <TELL "taken off!\"" CR>)
		      (T
		       <TELL "been recalled!\"" CR>)>
		<>)
	       (T
		<TELL 
"It shall be done, O mighty one!\" He turns to the radio console and barks, \"Tower to flight 42. Request " .STR " immediately!\"" CR CR>
		T)>>

<OBJECT THE-FLIGHT
	(LOC LOCAL-GLOBALS)
	(DESC "Air Zalagasa flight 42")
	(FLAGS NODESC NOARTICLE VOWEL PERSON LIVING)
	(SYNONYM FLIGHT TRIP FORTY-TWO INTNUM)
	(MATCH-NUMBER 42)
	(ADJECTIVE FLIGHT OMNIA GALLIA)
	(GENERIC GENERIC-OMNIA-F)
	(ACTION THE-FLIGHT-F)>

<DEFINE GENERIC-OMNIA-F (TBL)
	<COND (<INTBL? ,P-IT-OBJECT <ZREST .TBL 2> <ZGET .TBL 0>>
	       ,P-IT-OBJECT)
	      (<HERE? IN-TOWER>
	       ,THE-FLIGHT)
	      (T
	       <MATCH-AIRLINE-NAME ,W?OMNIA ,W?GALLIA ,AIRLINE-LOOKUP>
	       ,AIRLINE)>>

<DEFINE THE-FLIGHT-F FLIGHT ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-WINNER>
		<COND (<AND <PRSO? ME>
			    <VERB? TELL-ABOUT>>
		       <STATIC-STOPS "question">
		       <RETURN ,FATAL-VALUE .FLIGHT>)
		      (<AND <VERB? EXIT LEAVE CLIMB-OVER TAKE-OFF
				   ESCAPE FLY>
			    <PRSO? AIRPORT ROOMS>>
		       <GRANT-PLANE-REQUEST>
		       <RETURN ,FATAL-VALUE .FLIGHT>)
		      (<OR <AND <VERB? WALK-TO>
				<PRSO? AIRPORT ROOMS>>
			   <AND <VERB? SPIN>
				<EQUAL? ,P-PRSA-WORD ,W?TURN>
				<PRSO? ROOMS AIRPORT>>
			   <AND <VERB? LAMP-OFF>
				<PRSO? ROOMS>
				<EQUAL? ,P-PRSA-WORD ,W?STOP ,W?HALT>>>
		       <TURN-AROUND-PLANE>
		       <RETURN ,FATAL-VALUE .FLIGHT>)
		      (<AND <VERB? REQUEST>
			    <PRSO? REQUEST-OBJECT>>
		       <COND (<NOUN-USED? ,W?DENIED>
			      <TURN-AROUND-PLANE>
			      <RETURN ,FATAL-VALUE .FLIGHT>)
			     (<NOUN-USED? ,W?GRANTED>
			      <GRANT-PLANE-REQUEST>
			      <RETURN ,FATAL-VALUE .FLIGHT>)>)>
		<STATIC-STOPS "request">
		,FATAL-VALUE)
	       (<THIS-PRSI?>
		<COND (<AND <HERE? IN-TOWER>
			    <VERB? GIVE>
			    <PRSO? REQUEST-OBJECT>>
		       <GRANT-PLANE-REQUEST>)
		      (<VERB? ASK-ABOUT> <>)
		      (T
		       <CANT-FROM-HERE>)>
		T)
	       (<SEEING?>
		<CANT-SEE-MUCH>
		T)
	       (<TOUCHING?>
		<CANT-FROM-HERE>
		T)
	       (<VERB? EXAMINE WATCH>
		<COND (<NOT <HERE? IN-TOWER>>
		       <CANT-SEE-MUCH>)
		      (<T? <FLIGHT-GONE?>>
		       <TELL "It's already out of sight." CR>)
		      (T
		       <TELL
			"Peering outside, you can see an Air Zalagasa jet ">
		       <COND (<T? <FLIGHT-RECALLED?>>
			      <TELL "rolling towards the terminal." CR>)
			     (T
			      <TELL "waiting at the end of a runway." CR>)>)>
		T)
	       (<SEEING?>
		<CANT-SEE-MUCH>
		T)
	       (<VERB? TELL ASK-FOR ASK-ABOUT QUESTION REPLY>
		<COND (<HERE? IN-TOWER>
		       <COND (<T? <FLIGHT-DONE?>>
			      T)
			     (<VERB? TELL>
			      <>)
			     (<VERB? ASK-FOR>
			      <STATIC-STOPS "request">
			      T)
			     (<VERB? ASK-ABOUT QUESTION>
			      <STATIC-STOPS "question">
			      T)
			     (T
			      <STATIC-STOPS "comment">
			      T)>)
		      (T
		       <TELL ,CANT "talk to " Q ,PRSO " from here." CR>
		       T)>)
	       (<OR <AND <VERB? LAMP-OFF>
			 <EQUAL? ,P-PRSA-WORD ,W?STOP ,W?HALT>>
		    <AND <VERB? SPIN>
			 <EQUAL? ,P-PRSA-WORD ,W?TURN>>>
		<TURN-AROUND-PLANE>
		T)
	       (<ENTERING?>
		<V-WALK-AROUND>
		T)
	       (<EXITING?>
		<NOT-ON>
		T)
	       (T
		<>)>>

<DEFINE STATIC-STOPS (STR)
	 <TELL 
"An unfortunate burst of radio static prevents your " .STR 
" from reaching flight 42." CR>>

<DEFINE FLIGHT-DONE? ()
	 <COND (<OR <T? <FLIGHT-RECALLED?>>
		    <T? <FLIGHT-GONE?>>>
		<TELL "Too late. That flight has already ">
		<COND (<T? <FLIGHT-GONE?>>
		       <TELL "left." CR>)
		      (T
		       <TELL "been recalled." CR>)>
		T)
	       (T
		<>)>>

<DEFINE GRANT-PLANE-REQUEST ()
	 <COND (<F? <FLIGHT-DONE?>>
		<TELL 
		 "The radio heaves a sigh of relief. \"Roger, tower. Permission to take off acknowledged.\"" CR CR>
		<PLANE-TAKES-OFF>)>
	 T>

<DEFINE TURN-AROUND-PLANE ()
	 <COND (<F? <FLIGHT-DONE?>>
		<FLIGHT-RECALLED? T>
		<TELL 
"The radio mutters something impolite. \"Acknowledged, tower. We'll taxi her back to the terminal.\"" CR>
		<UPDATE-SCORE 1>)>
	 T>

<OBJECT AIRPORT-MUSIC
	(LOC LOCAL-GLOBALS)
	(DESC "sound")
	(FLAGS NODESC NOARTICLE MUSICAL)
	(SYNONYM MUSIC MUZAK ANNOUNCEMENTS SYSTEM PA SOUND)
	(ADJECTIVE MUSIC MUZAK PA)
	(ACTION AIRPORT-MUSIC-F)>

<DEFINE AIRPORT-MUSIC-F ()
	 <COND (<T? <MUSIC-DEAD?>>
		<SETG P-IT-OBJECT ,NOT-HERE-OBJECT>
		<TELL "Thankfully, you can't hear that anymore." CR>
		,FATAL-VALUE)
	       (<THIS-PRSI?>
		<>)
	       (<SEEING?>
		<CANT-SEE-ANY ,PRSO>
		T)
	       (<TOUCHING?>
		<IMPOSSIBLE>
		T)
	       (<VERB? LISTEN>
		<COND (<NOT <I-TERMINAL <>>>
		       <TELL "You don't hear anything." CR>)>
		,FATAL-VALUE)
	       (T
		<>)>>