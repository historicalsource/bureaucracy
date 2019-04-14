"AIRPORT for BUREAUCRACY: Copyright 1987 Infocom, Inc. All rights reserved."

<FILE-FLAGS MDL-ZIL?>

<USE "NEWSTRUC">

<SET-DEFSTRUCT-FILE-DEFAULTS 'NODECL ('NTH ZGET) ('PUT ZPUT)
			     ('START-OFFSET 0)>

<DEFSTRUCT TERM-TABLE TABLE
	   (JUST-HEARD? ANY)
	   (JUST-PAGED? ANY)
	   (TERMINAL-MUZAK FIX)
	   (PATRONS TABLE)>

<OBJECT AIRPORT
	(LOC GLOBAL-OBJECTS)
	(DESC "airport")
	(FLAGS NODESC VOWEL)
	(SYNONYM AIRPORT TERMINAL)
	(ADJECTIVE AIRPORT)
	(ACTION AIRPORT-F)
	(THINGS PSEUDO-VEC)>

<DEFINE AIRPORT-F ()
	 <COND (<NOT <IS? ,HERE ,IN-TERMINAL>>
		<CANT-FROM-HERE>
		T)
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

<SETG SKYCAP-DOINGS
	<LTABLE 2 
		"discussing the weather"
		"watching passengers struggle with their luggage"
		"talking about bad working conditions">>

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
are " <PICK-NEXT ,SKYCAP-DOINGS> ,PERIOD>
		T)
	       (<VERB? EXAMINE WATCH>
		<TELL "They're " <PICK-NEXT ,SKYCAP-DOINGS> ,PERIOD>
		T)
	       (<HURTING?>
		<TELL
"No use. It would only give the others something else to talk about." CR>
		T)
	       (T
		<>)>>

<DEFINE VISIT-AIRPORT ()
	 <SETG HERE ,ENT-D>
	 <MOVE ,PLAYER ,HERE>
	 <QUEUE I-TERMINAL>
	 <TELL "You arrive at " THE ,AIRPORT ,PCR>
	 <V-LOOK>
	 T>
	 
"IMPORTANT: The word AIRLINE must be the first non-specific airline synonym!"

<DEFMAC PSAIR-ADJ ('FOO)
	<FORM ZGET .FOO 0>>

<DEFMAC PSAIR-NAM ('FOO)
	<FORM ZGET .FOO 1>>

<DEFMAC PSAIR-STR ('FOO)
	<FORM ZGET .FOO 2>>

<DEFMAC PSAIR-ENT ('FOO)
	<FORM ZGET .FOO 3>>

<DEFMAC PSAIR-CODE ('FOO)
	<FORM ZGET .FOO 4>>

<MSETG PSAIR-LEN 5>

<MSETG PSAIR-GALLIA 1>
<MSETG PSAIR-ZALAGASA 2>
<MSETG PSAIR-RANDOM 3>

<MSETG PSAIR-RANDOM-NV -3>

<DEFINE DESC-AIRLINE ("AUX" TBL)
  <COND (<T? <SET TBL <GETP ,AIRLINE ,P?PSEUDO-TABLE>>>
	 <TELL <PSAIR-STR .TBL>>)
	(T
	 <PRINTD ,AIRLINE>)>>

<DEFINE MATCH-AIRLINE-NAME MAN (ADJ NAM TBL "AUX" TT (OBJ ,AIRLINE)
			        (LEN <ZGET .TBL 0>))
  <COND (<AND <F? .ADJ>
	      <F? .NAM>>
	 <RETURN <> .MAN>)>
  <COND (<AND <SET TT <GETPT .OBJ ,P?SYNONYM>>
	      <INTBL? .NAM .TT </ <PTSIZE .TT> 2>>>
	 <SET NAM <>>)>
  <COND (<AND .ADJ
	      <SET TT <GETPT .OBJ ,P?ADJECTIVE>>
	      <INTBL? .NAM .TT </ <PTSIZE .TT> 2>>>
	 <SET ADJ <>>)>
  <COND (<NOT <OR .NAM .ADJ>>
	 <TELL "You'll have to be more specific.  Do you mean ">
	 <SET TBL <ZREST .TBL 2>>
	 <REPEAT ((ANY? <>) STR)
	   <SET STR <PSAIR-STR .TBL>>
	   <SET LEN <- .LEN ,PSAIR-LEN>>
	   <SET TBL <ZREST .TBL <* ,PSAIR-LEN 2>>>
	   <COND (<NOT .ANY?>
		  <TELL .STR>)
		 (<L? .LEN ,PSAIR-LEN>
		  <TELL ", or " .STR "?">
		  <RETURN>)
		 (T
		  <TELL ", " .STR>)>
	   <SET ANY? T>>
	 <PUTP .OBJ ,P?PSEUDO-TABLE 0>
	 <>)
	(T
	 <SET TBL <ZREST .TBL 2>>
	 <REPEAT ()
	   <COND (<OR <NOT .NAM>
		      <==? .NAM <PSAIR-NAM .TBL>>>
		  <COND (<OR <NOT .ADJ>
			     <==? .ADJ <PSAIR-ADJ .TBL>>
			     <==? .ADJ <PSAIR-NAM .TBL>>>
			 <PUTP .OBJ ,P?PSEUDO-TABLE .TBL>
			 <RETURN>)>)>
	   <COND (<L=? <SET LEN <- .LEN ,PSAIR-LEN>> <- ,PSAIR-LEN 1>>
		  <PUTP .OBJ ,P?PSEUDO-TABLE 0>
		  <SET OBJ <>>
		  <RETURN>)>
	   <SET TBL <ZREST .TBL <* 2 ,PSAIR-LEN>>>>
	 .OBJ)>>

<SETG AIRLINE-LAST-USED 0>

<BIND ()
  <VOC "OMNIA" OBJECT> <VOC "GALLIA" OBJECT>
  <VOC "INTERFLUG" OBJECT> <VOC "NORDAIR" OBJECT>
  <VOC "TRANS" OBJECT> <VOC "WORLD" OBJECT>
  <VOC "AIR" OBJECT> <VOC "CARIBE" OBJECT>
  <VOC "AMERICAN" OBJECT> <VOC "TORONTO" OBJECT>
  <VOC "GUYANA" OBJECT> <VOC "AIRWAYS" OBJECT>
  <VOC "CATHAY" OBJECT> <VOC "PACIFIC" OBJECT>
  <VOC "GUADELOUPE" OBJECT> <VOC "ZALAGASA" OBJECT>
  <VOC "BRITISH" OBJECT> <VOC "AER" OBJECT>
  <VOC "LINGUS" OBJECT> <VOC "NOCTURNAL" OBJECT>
  <VOC "AVIATION" OBJECT> <VOC "CANADA" OBJECT>
  <VOC "ALITALIA" OBJECT> <VOC "ICELANDAIR" OBJECT>
  <VOC "LUFTHANSA" OBJECT> <VOC "BRANIFF" OBJECT>
  <VOC "DELTA" OBJECT> <VOC "INDIA" OBJECT> <VOC "AEROFLOT" OBJECT>
  <VOC "CONTINENTAL" OBJECT> <VOC "SWISSAIR" OBJECT>
  <VOC "EASTERN" OBJECT> <VOC "SINGAPORE" OBJECT> <VOC "QANTAS" OBJECT>
  <VOC "EL" OBJECT> <VOC "AL" OBJECT>>

<DEFINE AIRLINE-F ("AUX" TBL)
	  <COND (<NOT <IS? ,HERE ,IN-TERMINAL>>
		 <TELL "Airlines are usually found only at airports." CR>
		 T)
		(<THIS-PRSI?>
		 <>)
		(<VERB? EXAMINE>
		 <CANT-SEE-MUCH>
		 T)
		(<ENTERING?>
		 ; "See if we're at the entrance for the airline referred
		    to..."
		 <COND (<T? <SET TBL <GETP ,PRSO ,P?PSEUDO-TABLE>>>
			<COND (<EQUAL? ,HERE <PSAIR-ENT .TBL>>
			       <DO-WALK ,P?NORTH>)
			      (T
			       <V-WALK-AROUND>)>)
		       (T
			<ORPHAN-VERB>)>
		 T)
		(T
		 <>)>>

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
		<TELL CTHEO>
		<SAY-SIGNS>
		T)
	       (<VERB? FOLLOW>
		<V-WALK-AROUND>
		T)
	       (T
		<>)>>
	       
<DEFINE SAY-SIGNS ("OPTIONAL" (X <>) "AUX" TBL)
	 <COND (<ZERO? .X>
		<SET X ,HERE>)>
	 <SET TBL <GETP .X ,P?AIRLINE-LIST>>
	 <TELL " point to " <ZGET .TBL 5> " and "  <ZGET .TBL 4>
	       " to the north, " <ZGET .TBL 3> " and " <ZGET .TBL 2>
	       " to the east, and " <ZGET .TBL 1> " and " <ZGET .TBL 0>
	       " to the west." CR>
	 T>

<OBJECT PSIGNS
	(LOC LOCAL-GLOBALS)
	(DESC "signs")
	(FLAGS NODESC TRYTAKE NOALL)
	(SYNONYM SIGNS SIGN)
	(ACTION PSIGNS-F)>

<DEFINE PSIGNS-F SIGNS ()
	 <COND (<HERE? DUCT-A>
		<COND (<TOUCHING?>
		       <CANT-FROM-HERE>
		       <RETURN T .SIGNS>)
		      (<SEEING?>
		       <CANT-SEE-MUCH>
		       <RETURN T .SIGNS>)>)>
	 <COND (<THIS-PRSI?>
		<>)
	       (<VERB? EXAMINE LOOK-ON READ>
		<TELL CTHEO>
		<SAY-SIGNS ,AIR-C>
		T)
	       (<VERB? TAKE MOVE PULL PUSH TOUCH HIT KICK PLAY>
		<TELL CTHEO 
" swing around randomly when you touch them">
		<COND (<VERB? TAKE>
		       <TELL ". But they can't be removed">)>
		<ZPRINT ,PERIOD>
		T)
	       (<VERB? FOLLOW>
		<CANT-FROM-HERE>
		T)
	       (T
		<>)>>	

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
		<TELL CTHEO " is tall and narrow. The signs on it ">
		<SAY-SIGNS ,AIR-C>
		T)
	       (<VERB? READ LOOK-ON>
		<TELL "The signs on " THEO>
		<SAY-SIGNS>
		T)
	       (<VERB? CLIMB-UP CLIMB-ON CLIMB-OVER>
		<COND (<HERE? PILLAR-B DUCT-A>
		       <ALREADY-AT-TOP>)
		      (T
		       <DO-WALK ,P?UP>)>
		T)
	       (<VERB? CLIMB-DOWN STAND-UNDER>
		<COND (<HERE? AIR-C>
		       <ALREADY-AT-BOTTOM>)
		      (T
		       <DO-WALK ,P?DOWN>)>
		T)
	       (<VERB? STAND-ON RIDE>
		<COND (<HERE? AIR-C>
		       <DO-WALK ,P?UP>)
		      (<HERE? DUCT-A>
		       <DO-WALK ,P?DOWN>)
		      (T
		       <ALREADY-ON>)>
		T)
	       (<VERB? FOLLOW>
		<COND (<HERE? AIR-C>
		       <DO-WALK ,P?UP>)
		      (<HERE? DUCT-A>
		       <DO-WALK ,P?DOWN>)
		      (T
		       <V-WALK-AROUND>)>
		T)
	       (<VERB? LOOK-UP>
		<COND (<HERE? PILLAR-B>
		       <V-LOOK>)
		      (<HERE? DUCT-A>
		       <ALREADY-AT-TOP>)
		      (T
		       <TELL "The signs on " THEO>
		       <SAY-SIGNS>)>
		T)
	       (<VERB? LOOK-DOWN>
		<COND (<HERE? AIR-C>
		       <ALREADY-AT-BOTTOM>)
		      (T
		       <TELL "The height makes you dizzy." CR>)>
		T)
	       (T
		<>)>> 

<OBJECT SPEAKER
	(LOC PILLAR-B)
	(DESC "speaker")
	(FLAGS TRYTAKE NOALL SURFACE)
	(CAPACITY 5)
	(SYNONYM SPEAKER LOUDSPEAKER TANNOY)
	(ADJECTIVE GUSH\-O\-SLUSH)
	(DESCFCN SPEAKER-F)
	(ACTION SPEAKER-F)>

<DEFINE SPEAKER-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-OBJDESC>
		<TELL 
"A speaker is attached to the top of the pillar">
		<COND (<NOT <IS? ,SPEAKER ,SHORTED-OUT>>
		       <TELL ", playing ">
		       <VERY-LOUDLY <>>)
		      (T
		       <TELL ".">)>
		T)
	       (<T? .CONTEXT>
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
		       <COND (<NOT <IS? ,PRSO ,SHORTED-OUT>>
			      <TELL ", playing ">
		       	      <VERY-LOUDLY>)
			     (T
			      <TELL ".">)>
		       <ZCRLF>)>
		<TELL "Peering behind " THEO ", you notice ">
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
			     " dangling from the back." CR>)>
		T)
	       (<VERB? SHORT>
		<COND (<IS? ,PRSO ,SHORTED-OUT>
		       <CANT-SHORT-TWICE>)
		      (T
		       <TELL "Capital idea. How do you propose to do it?" CR>)>
		T)
	       (<AND <VERB? LISTEN>
		     <NOT <IS? ,SPEAKER ,SHORTED-OUT>>>
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
		
<DEFINE WITH-DANGLING (X)
	 <TELL " connected to the back, with "
	       A .X " dangling beside it." CR>>

<DEFINE VERY-LOUDLY ("OPTIONAL" (CR T))
	 <JUST-HEARD? ,TERM-TABLE T>
	 <SAY-MUZAK <TERMINAL-MUZAK ,TERM-TABLE>>
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
	       (<VERB? PLUG TOUCH-TO SHORT>
		<COND (<IS? ,PRSO ,CONNECTED>
		       <TELL CTHEO " is already connected to "
			     THE ,SPEAKER ,PERIOD>
		       T)
		      (<EQUAL? ,PRSI <GETP ,PRSO ,P?OTHER-WIRE>>
		       <COND (<IS? ,AIRPORT-MUSIC ,SHORTED-OUT>
			      <CANT-SHORT-TWICE>)
			     (T
			      <TOUCH-WIRES-TOGETHER>)>
		       T)
		      (<NOT <EQUAL? ,PRSI ,SPEAKER>>
		       <>)
		      (T
		       <BEYOND-REPAIR>
		       <>)>)
	       (<VERB? REPLUG CLOSE>
		<COND (<IS? ,PRSO ,CONNECTED>
		       <TELL "You'd have to disconnect it from "
			     THE ,SPEAKER " first." CR>
		       T)
		      (<ZERO? ,PRSI>
		       <BEYOND-REPAIR>
		       T)
		      (<EQUAL? ,PRSI <GETP ,PRSO ,P?OTHER-WIRE>>
		       <COND (<IS? ,AIRPORT-MUSIC ,SHORTED-OUT>
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
		       <MAKE ,SPEAKER ,SHORTED-OUT>
		       <UNMAKE ,PRSO ,CONNECTED>
		       <TELL "You grasp " THEO " and, with a firm yank, pull it out of the Gush-O-Slush(R) Spam-For-The-Ears speaker." CR>
		       <COND (<IS? <GETP ,PRSO ,P?OTHER-WIRE> ,CONNECTED>
			      <TELL CR
"Pop! The speaker emits an electric squawk and stops playing ">
			      <SAY-MUZAK <TERMINAL-MUZAK ,TERM-TABLE>>
			      <TELL " very soothingly.|
|
You hear a patter of applause from the crowd below." CR>)>
		       T)
		      (T
		       <TELL CTHEO " is already disconnected." CR>
		       T)>)
	       (T
		<>)>>

<DEFINE GENERIC-WIRE-F (TBL)
	 <COND (<EQUAL? ,P-IT-OBJECT ,BWIRE ,RWIRE>
		<RETURN ,P-IT-OBJECT>)
	       (<NOUN-USED? ,W?WIRES ,W?PAIR>
		<RETURN ,BWIRE>)>
	 <>>

<DEFINE MULTIWIRE? ("AUX" X)
	 <COND (<NOT <NOUN-USED? ,W?WIRES ,W?PAIR>>
		<>)
	       (<ADJ-USED? ,W?BLACK ,W?RED>
		<TELL "There's only one wire of each color." CR>
		T)	 
	       (<VERB? SHORT>
		<TOUCH-WIRES-TOGETHER>
		T)
	       (T
		<SETG P-MULT? T>
		<TELL CTHE ,RWIRE ": ">
		<COND (<THIS-PRSI?>
		       <ZPUT ,P-NAMW 1 ,W?WIRE>
		       <ZPUT ,P-OFW 1 <>>
		       <SET X <PERFORM ,PRSA ,PRSO ,RWIRE>>)
		      (T
		       <ZPUT ,P-NAMW 0 ,W?WIRE>
		       <ZPUT ,P-OFW 0 <>>
		       <SET X <PERFORM ,PRSA ,RWIRE ,PRSI>>)>
		<COND (<EQUAL? .X ,M-FATAL>
		       <SETG P-MULT? <>>
		       <RETURN .X>)>
		<TELL CTHE ,BWIRE ": ">
		<COND (<THIS-PRSI?>
		       <SET X <PERFORM ,PRSA ,PRSO ,BWIRE>>)
		      (T
		       <SET X <PERFORM ,PRSA ,BWIRE ,PRSI>>)>
		<SETG P-MULT? <>>
		.X)>>
	 
<DEFINE CANT-SHORT-TWICE ()
	 <TELL 
"The Gush-O-Slush(R) repair crew hasn't arrived to fix the sound system yet. You can't short it out again until they do fix it. So think of something else." CR>
	 T>

<DEFINE TOUCH-WIRES-TOGETHER ()
	 <COND (<IS? ,AIRPORT-MUSIC ,SHORTED-OUT>
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
		<MAKE ,AIRPORT-MUSIC ,SHORTED-OUT>
		<PUTP ,PILLAR-B ,P?HEAR ,AIRPORT-CROWD>
		<PUTP ,PILLAR-A ,P?HEAR ,AIRPORT-CROWD>
		<PUTP ,DUCT-A ,P?HEAR 0>
		<PUTP ,DUCT-B ,P?HEAR 0>
		<PUTP ,DUCT-C ,P?HEAR 0>
		<PUTP ,DUCT-D ,P?HEAR 0>
		<DEQUEUE I-TERMINAL>
		<TELL "With an electric squawk, all the other Gush-O-Slush(R) Spam-For-The-Ears(TM) speakers in the entire terminal stop playing ">
		<SAY-MUZAK <TERMINAL-MUZAK ,TERM-TABLE>>
		<TELL " very soothingly.|
|
The applause of the crowd is deafening." CR>
		T)>>		       

<DEFINE STILL-CONNECTED ()
	 <TELL " still connected to " THE ,SPEAKER ,PERIOD>>

<DEFINE BEYOND-REPAIR ()
	 <TELL "Sorry. You damaged " THEO " beyond repair." CR>>

<OBJECT CONSOLE
	(LOC IN-TOWER)
	(DESC "console")
	(FLAGS NODESC READABLE SURFACE)
	(CAPACITY 10)
	(SYNONYM CONSOLE CONSOLES CONTROLS READOUT READOUTS)
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
"A readout on a nearby console shows that Omnia Gallia flight 42 is ready to take off." CR>
		T)
	       (<VERB? LISTEN>
		<I-CONSOLE <>>
		,FATAL-VALUE)
	       (T
		<>)>>

<OBJECT AIRLINE-DESK
	(LOC AIR-B)
	(DESC "desk")
	(SDESC DESCRIBE-AIRLINE-DESK)
	(FLAGS NODESC SURFACE)
	(CAPACITY 25)
	(SYNONYM ZZZP ZZZP ZZZP DESK)
	(ADJECTIVE ZZZP ZZZP ZZZP AIRLINE AIRLINES CHECK-IN)
	(ACTION AIRLINE-DESK-F)>

<SETG DESK-ID 0>

<SETG OMNIA-SEEN? <>>

<DEFINE DESCRIBE-AIRLINE-DESK ()
	 <TELL <PSAIR-STR ,DESK-ID> " check-in desk">>

<DEFINE AIRLINE-DESK-F ()
	 <COND (<THIS-PRSI?>
		<>)
	       (<VERB? EXAMINE>
		<TELL "It's a very nice desk." CR>
		T)
	       (T
		<>)>>

<OBJECT GRATE
	(LOC LOCAL-GLOBALS)
	(DESC "grate")
	(FLAGS NODESC DOORLIKE OPENABLE)
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
	       (T
		<>)>>

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
	       (<AND <VERB? LOOK-INSIDE LOOK-BEHIND LOOK-UNDER SEARCH>
		     <NOT <IS? ,PRSO ,OPENED>>>
		<CANT-SEE-MUCH>
		T)
	       (T
		<>)>>

<OBJECT DUCT
	(LOC LOCAL-GLOBALS)
	(DESC "duct")
	(FLAGS NODESC PLACE)
	(SYNONYM DUCT TUBE)
	(ADJECTIVE AIR CONDITIONING)
	(ACTION DUCT-F)>

<DEFINE DUCT-F ()
	 <COND (<THIS-PRSI?>
		<>)
	       (<VERB? CLIMB-UP CLIMB-ON CLIMB-OVER>
		<DO-WALK ,P?UP>
		T)
	       (<ENTERING?>
		<COND (<HERE? PILLAR-B>
		       <DO-WALK ,P?UP>)
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

<OBJECT TOWER
	(LOC LOCAL-GLOBALS)
	(DESC "control tower")
	(FLAGS NODESC PLACE)
	(SYNONYM TOWER)
	(ADJECTIVE CONTROL AIR TRAFFIC)
	(ACTION TOWER-F)
	(THINGS PSEUDO-VEC)>

<DEFINE TOWER-F ()
	 <COND (<HERE? DUCT-D>
		<COND (<HERE-F>
		       T)
		      (T
		       <>)>)
	       (<ENTERING?>
		<DO-WALK ,P?EAST>
		T)
	       (<EXITING?>
		<NOT-IN>
		T)
	       (<SEEING?>
		<CANT-SEE-MUCH>
		T)
	       (T
		<>)>>
 
<OBJECT VISA-SIGN
	(LOC AGENCY)
	(DESC "sign")
	(FLAGS READABLE)
	(SYNONYM SIGN NOTICE)
	(ADJECTIVE LARGE)
	(DESCFCN VISA-SIGN-F)
	(ACTION VISA-SIGN-F)>

<DEFINE VISA-SIGN-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-OBJDESC>
		<TELL "A large sign is hanging on the wall behind the desk.">
		T)
	       (<T? .CONTEXT>
		<>)
	       (<THIS-PRSI?>
		<>)
	       (<VERB? EXAMINE READ LOOK-ON>
		<TELL "The sign says:|
|
DON'T FORGET YOUR VISA!|
|
Be sure to ask your travel agent about visa requirements!" CR>
		T)
	       (T
		<>)>>
		
<OBJECT REQUIREMENTS
	(LOC GLOBAL-OBJECTS)
	(DESC "visa requirements")
	(FLAGS NODESC PLURAL)
	(SYNONYM REQUIREMENTS VISA)
	(ADJECTIVE VISA MY)
	(ACTION REQUIREMENTS-F)>

<DEFINE REQUIREMENTS-F ()
	 <COND (<SEEING?>
		<TELL ,CANT "see any here." CR>
		,FATAL-VALUE)
	       (T
		<TELL ,CANT "do that with " Q ,REQUIREMENTS ,PERIOD>
		T)>>

<OBJECT VISA
	(LOC BTABLE)
	(DESC "your passport")
	(FLAGS NOARTICLE TAKEABLE READABLE)
	(SIZE 3)
	(SYNONYM PASSPORT VISA)
	(ADJECTIVE MY)
	(ACTION VISA-F)>

<DEFINE VISA-F ()
	 <COND (<THIS-PRSI?>
		<COND (<PUTTING?>
		       <WASTE-OF-TIME>
		       T)
		      (T
		       <>)>)
	       (<VERB? EXAMINE LOOK-ON LOOK-INSIDE READ OPEN>
		<TELL "You flip open " Q ,PRSO
", glance to make sure your French visa is still readable, shudder at the picture and close the book." CR>
		T)
	       (<VERB? CLOSE>
		<ITS-ALREADY "closed">
		T)
	       (T
		<>)>>

<OBJECT AIRPORT-MUSIC
	(LOC LOCAL-GLOBALS)
	(DESC "sound")
	(FLAGS NODESC NOARTICLE)
	(SYNONYM MUSIC MUZAK ANNOUNCEMENTS SYSTEM PA SOUND)
	(ADJECTIVE MUSIC MUZAK PA)
	(ACTION AIRPORT-MUSIC-F)>

<BIT-SYNONYM SEEN SHORTED-OUT>

<DEFINE AIRPORT-MUSIC-F ()
	 <COND (<IS? ,AIRPORT-MUSIC ,SHORTED-OUT>
		<SETG P-IT-OBJECT ,NOT-HERE-OBJECT>
		<TELL "Thankfully, you can't hear that anymore." CR>
		,FATAL-VALUE)
	       (<THIS-PRSI?>
		<>)
	       (<SEEING?>
		<TELL ,CANT "see " Q ,PRSO ,PERIOD>
		T)
	       (<TOUCHING?>
		<IMPOSSIBLE>
		T)
	       (<VERB? LISTEN>
		<I-TERMINAL <>>
		,FATAL-VALUE)
	       (T
		<>)>>

"*** AIRPORT ***"

<OBJECT ENT-A
	(LOC ROOMS)
	(DESC "Airport Entrance")
	(FLAGS LIGHTED LOCATION IN-TERMINAL)
	(HEAR AIRPORT-MUSIC)
	(NORTH PER ENTER-CONCOURSE)
	(IN PER ENTER-CONCOURSE)
	(EAST TO ENT-B)
	(SOUTH PER TRAFFIC-STOPS)
	(WEST SORRY "You don't see any more entrances that way.")
	(OUT PER WHICH-WAY-OUT)
	(GLOBAL SKYCAPS AIRPORT-CROWD AIRPORT-MUSIC)
	(ACTION ENT-A-F)
	(THINGS PSEUDO-VEC)>

<DEFINE ENT-A-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL "The entrance in front of you is marked ">
		<LIST-AIRLINES "east">
		T)
	       (T
		<>)>>

<DEFINE LIST-AIRLINES ("OPTIONAL" (STR <>) "AUX" LEN TBL)
	 <SET TBL ,AIRLINE-PSEUDOS>
	 <SET LEN <ZGET .TBL 0>>
	 <SET TBL <ZREST .TBL 2>>
	 <REPEAT ((LST1 <>) (LST2 <>) AIR)
		 <COND (<==? <PSAIR-ENT .TBL> ,HERE>
			<SET AIR <PSAIR-STR .TBL>>
			; "Found an airline for this entrance"
			<COND (.LST1
			       <COND (.LST2
				      <TELL .LST1 ", ">
				      <SET LST1 .LST2>
				      <SET LST2 .AIR>)
				     (T
				      <SET LST2 .AIR>)>)
			      (T
			       <SET LST1 .AIR>)>)>
		 <SET TBL <ZREST .TBL <* ,PSAIR-LEN 2>>>
		 <COND (<L? <SET LEN <- .LEN ,PSAIR-LEN>> ,PSAIR-LEN>
			<COND (.LST1
			       <COND (.LST2
				      <TELL .LST1 " and " .LST2>)
				     (T
				      <TELL .LST1>)>)>
			<RETURN>)>>
	 <TELL ". Other entrances stretch away to the ">
	 <COND (<ZERO? .STR>
		<TELL "east and west." CR>)
	       (T
		<TELL .STR ,PERIOD>)>
	 T>

<OBJECT ENT-B
	(LOC ROOMS)
	(DESC "Airport Entrance")
	(FLAGS IN-TERMINAL LIGHTED LOCATION)
	(HEAR AIRPORT-MUSIC)
	(NORTH PER ENTER-CONCOURSE)
	(IN PER ENTER-CONCOURSE)
	(EAST TO ENT-C)
	(SOUTH PER TRAFFIC-STOPS)
	(WEST TO ENT-A)
	(OUT PER WHICH-WAY-OUT)
	(GLOBAL AIRPORT-CROWD SKYCAPS AIRPORT-MUSIC)
	(ACTION ENT-B-F)
	(THINGS PSEUDO-VEC)>

<DEFINE ENT-B-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL "You're at an entrance marked ">
		<LIST-AIRLINES>
		T)
	       (T
		<>)>>

<OBJECT ENT-C
	(LOC ROOMS)
	(DESC "Airport Entrance")
	(FLAGS IN-TERMINAL LIGHTED LOCATION)
	(HEAR AIRPORT-MUSIC)
	(NORTH PER ENTER-CONCOURSE)
	(IN PER ENTER-CONCOURSE)
	(EAST TO ENT-D)
	(SOUTH PER TRAFFIC-STOPS)
	(WEST TO ENT-B)
	(OUT PER WHICH-WAY-OUT)
	(GLOBAL AIRPORT-CROWD SKYCAPS AIRPORT-MUSIC)
	(ACTION ENT-C-F)
	(THINGS PSEUDO-VEC)>

<DEFINE ENT-C-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL "You're at an entrance marked ">
		<LIST-AIRLINES>
		T)
	       (T
		<>)>>

<OBJECT ENT-D
	(LOC ROOMS)
	(DESC "Airport Entrance")
	(FLAGS IN-TERMINAL LIGHTED LOCATION)
	(HEAR AIRPORT-MUSIC)
	(NORTH PER ENTER-CONCOURSE)
	(IN PER ENTER-CONCOURSE)
	(EAST TO ENT-E)
	(SOUTH PER TRAFFIC-STOPS)
	(WEST TO ENT-C)
	(OUT PER WHICH-WAY-OUT)
	(GLOBAL AIRPORT-CROWD SKYCAPS AIRPORT-MUSIC)
	(ACTION ENT-D-F)
	(THINGS PSEUDO-VEC)>

<DEFINE ENT-D-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL
"You're standing in front of a huge international airport. The entrance before you is marked ">
		<LIST-AIRLINES>
		T)
	       (T
		<>)>>

<OBJECT ENT-E
	(LOC ROOMS)
	(DESC "Airport Entrance")
	(FLAGS IN-TERMINAL LIGHTED LOCATION)
	(HEAR AIRPORT-MUSIC)
	(NORTH PER ENTER-CONCOURSE)
	(IN PER ENTER-CONCOURSE)
	(EAST TO ENT-F)
	(SOUTH PER TRAFFIC-STOPS)
	(WEST TO ENT-D)
	(OUT PER WHICH-WAY-OUT)
	(GLOBAL AIRPORT-CROWD SKYCAPS AIRPORT-MUSIC)
	(ACTION ENT-E-F)
	(THINGS PSEUDO-VEC)>

<DEFINE ENT-E-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL "You're standing south of an entrance marked ">
		<LIST-AIRLINES>
		T)
	       (T
		<>)>>

<OBJECT ENT-F
	(LOC ROOMS)
	(DESC "Airport Entrance")
	(FLAGS IN-TERMINAL LIGHTED LOCATION)
	(HEAR AIRPORT-MUSIC)
	(NORTH PER ENTER-CONCOURSE)
	(IN PER ENTER-CONCOURSE)
	(EAST TO ENT-G)
	(SOUTH PER TRAFFIC-STOPS)
	(WEST TO ENT-E)
	(OUT PER WHICH-WAY-OUT)
	(GLOBAL AIRPORT-CROWD SKYCAPS AIRPORT-MUSIC)
	(ACTION ENT-F-F)
	(THINGS PSEUDO-VEC)>

<DEFINE ENT-F-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL "You're standing outside an entrance marked ">
		<LIST-AIRLINES>
		T)
	       (T
		<>)>>

<OBJECT ENT-G
	(LOC ROOMS)
	(DESC "Airport Entrance")
	(FLAGS IN-TERMINAL LIGHTED LOCATION)
	(HEAR AIRPORT-MUSIC)
	(NORTH PER ENTER-CONCOURSE)
	(IN SORRY "[Which way do you want to go in, north or east?]")
	(EAST TO LANDF IF LANDF-DOOR IS OPEN)
	(SOUTH PER TRAFFIC-STOPS)
	(WEST TO ENT-F)
	(OUT PER WHICH-WAY-OUT)
	(GLOBAL AIRPORT-CROWD SKYCAPS LANDF-DOOR AIRPORT-MUSIC)
	(ACTION	ENT-G-F)
	(THINGS PSEUDO-VEC)>

<DEFINE ENT-G-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL
"You're outside an entrance marked ">
		<LIST-AIRLINES "west">
		<TELL CR
"Looking east, you see a door marked LOST AND FOUND." CR>
		T)
	       (T
		<>)>>

<CONSTANT AIRLINE-PSEUDOS
	<PLTABLE <VOC "OMNIA" ADJ> <VOC "GALLIA" ADJ> "Omnia Gallia" ENT-B
				 ,PSAIR-GALLIA
		 <> <VOC "INTERFLUG" ADJ> "Interflug" ENT-B ,PSAIR-RANDOM
		 <> <VOC "NORDAIR" ADJ> "Nordair" ENT-A ,PSAIR-RANDOM-NV
		 <VOC "TRANS" ADJ> <VOC "WORLD" ADJ> "Trans World" ENT-A
		     ,PSAIR-RANDOM-NV
		 <VOC "AIR" ADJ> <VOC "CARIBE" ADJ> "Air Caribe" ENT-A
		     ,PSAIR-RANDOM
		 <> <VOC "AMERICAN" ADJ> "American" ENT-C ,PSAIR-RANDOM
		 <VOC "AIR" ADJ> <VOC "TORONTO" ADJ> "Air Toronto" ENT-C
		      ,PSAIR-RANDOM
		 <VOC "GUYANA" ADJ> <VOC "AIRWAYS" ADJ> "Guyana Airways" ENT-C
		      ,PSAIR-RANDOM-NV
		 <VOC "CATHAY" ADJ> <VOC "PACIFIC" ADJ> "Cathay Pacific" ENT-C
		      ,PSAIR-RANDOM-NV
		 <VOC "AIR" ADJ> <VOC "GUADELOUPE" ADJ> "Air Guadeloupe" ENT-B
		      ,PSAIR-RANDOM
		 <VOC "AIR" ADJ> <VOC "ZALAGASA" ADJ> "Air Zalagasa" ENT-A
		      ,PSAIR-ZALAGASA
		 <VOC "BRITISH" ADJ> <VOC "AIRWAYS" ADJ> "British Airways" ENT-D
		      ,PSAIR-RANDOM-NV
		 <VOC "AER" ADJ> <VOC "LINGUS" ADJ> "Aer Lingus" ENT-D
		      ,PSAIR-RANDOM
		 <VOC "NOCTURNAL" ADJ> <VOC "AVIATION" ADJ> "Nocturnal Aviation"
				     ENT-G ,PSAIR-RANDOM-NV
		 <VOC "AIR" ADJ> <VOC "CANADA" ADJ> "Air Canada" ENT-D
		      ,PSAIR-RANDOM
		 <> <VOC "ALITALIA" ADJ> "Alitalia" ENT-E ,PSAIR-RANDOM
		 <> <VOC "ICELANDAIR" ADJ> "Icelandair" ENT-E ,PSAIR-RANDOM
		 <> <VOC "LUFTHANSA" ADJ> "Lufthansa" ENT-F ,PSAIR-RANDOM-NV
		 <> <VOC "BRANIFF" ADJ> "Braniff" ENT-E ,PSAIR-RANDOM-NV
		 <> <VOC "DELTA" ADJ> "Delta" ENT-F ,PSAIR-RANDOM-NV
		 <VOC "AIR" ADJ> <VOC "INDIA" ADJ> "Air India" ENT-F ,PSAIR-RANDOM
		 <> <VOC "AEROFLOT" ADJ> "Aeroflot" ENT-F ,PSAIR-RANDOM
		 <> <VOC "CONTINENTAL" ADJ> "Continental" ENT-D ,PSAIR-RANDOM-NV
		 <> <VOC "SWISSAIR" ADJ> "Swissair" ENT-G ,PSAIR-RANDOM-NV
		 <> <VOC "EASTERN" ADJ> "Eastern" ENT-B ,PSAIR-RANDOM
		 <> <VOC "SINGAPORE" ADJ> "Singapore" ENT-D ,PSAIR-RANDOM-NV
		 <> <VOC "QANTAS" ADJ> "Qantas" ENT-G ,PSAIR-RANDOM-NV
		 <VOC "EL" ADJ> <VOC "AL" ADJ> "El Al" ENT-G ,PSAIR-RANDOM>>

<CONSTANT PSEUDO-VEC <PTABLE MATCH-AIRLINE-NAME AIRLINE-PSEUDOS>>

<OBJECT AIRLINE
	(DESC "Random Airline")
	(FLAGS NODESC NOARTICLE PLACE)
	(SYNONYM AIRLINES AIRLINE)
	(ACTION AIRLINE-F)
	(PSEUDO-TABLE AIRLINE-PSEUDOS)
	(SDESC DESC-AIRLINE)>

<SETG ENTERED-FROM 0> "Room you entered concourse from."

<DEFINE ENTER-CONCOURSE ()
	 <SETG ENTERED-FROM ,HERE>
	 <PUSH-THRU "entrance">
	 ,AIR-A>

<DEFINE EXIT-CONCOURSE ()
	 <PUSH-THRU "exit">
	 ,ENTERED-FROM>

<DEFINE PUSH-THRU (STR)
	 <TELL "You push your way through an " .STR ,PCR>>

<DEFINE TRAFFIC-STOPS ()
	 <TELL "Busy traffic blocks your path." CR>
	 <>>

<SETG NEW-SETUP? T>

<DEFINE SETUP-SIGNS ("AUX" (CNT 5) X Y)
	 <COND (<ZERO? ,NEW-SETUP?>
		<SETG NEW-SETUP? T>)
	       (T
		<SET Y <GETP ,HERE ,P?AIRLINE-LIST>>
		<REPEAT ()
			<ZPUT .Y .CNT <PSAIR-STR <PICK-NEXT-AIRLINE>>>
			<COND (<L? <SET CNT <- .CNT 1>> 0>
			       <RETURN>)>>)>
	 <>>

<DEFINE PICK-NEXT-AIRLINE ("AUX" TBL)
  <COND (<G=? ,AIRLINE-LAST-USED <ZGET ,AIRLINE-PSEUDOS 0>>
	 <SETG AIRLINE-LAST-USED 0>)>
  <SET TBL <ZREST ,AIRLINE-PSEUDOS
		  <* 2 <+ ,AIRLINE-LAST-USED 1>>>>
  <SETG AIRLINE-LAST-USED <+ ,AIRLINE-LAST-USED ,PSAIR-LEN>>
  .TBL>

<DEFINE SETUP-DESK ("AUX" (CNT 0) SOURCE DEST DEST2 X LEN)
	 <REPEAT ()
		 <SETG DESK-ID <PICK-NEXT-AIRLINE>>
		 <COND (<OR <AND <EQUAL? <PSAIR-CODE ,DESK-ID> ,PSAIR-GALLIA>
				 <EQUAL? ,ENTERED-FROM ,ENT-B>>
			    <AND <EQUAL? <PSAIR-CODE ,DESK-ID> ,PSAIR-ZALAGASA>
				 <NOT <EQUAL? ,ENTERED-FROM ,ENT-B>>>>)
		       (T
			<RETURN>)>>
	 <COND (<N==? <PSAIR-CODE ,DESK-ID> ,PSAIR-RANDOM-NV>
		; "Omnia Gallia, Air Zalagasa, and anything that's
		   PSAIR-RANDOM as opposed to PSAIR-RANDOM-NV"
		<MAKE ,AIRLINE-DESK ,VOWEL>)>
	 
       ; "Copy airline's synonyms into AIRLINE-DESK object."

	 <SET SOURCE ,DESK-ID>
	 <SET LEN 2> ; "Number of synonyms."
	 <SET DEST <GETPT ,AIRLINE-DESK ,P?SYNONYM>>
	 <REPEAT ()
		 <COND (<SET X <ZGET .SOURCE .CNT>>
			<ZPUT .DEST .CNT .X>)>
		 <COND (<G? <SET CNT <+ .CNT 1>> .LEN>
			<RETURN>)>>
	 
       ; "Copy airline's adjectives into AIRLINE-DESK and AIRCLERK."
	
         <SET SOURCE ,DESK-ID>
         <SET LEN 2> ; "Number of adjectives."
	 <SET DEST <GETPT ,AIRLINE-DESK ,P?ADJECTIVE>>		
	 <SET DEST2 <GETPT ,AIRCLERK ,P?ADJECTIVE>>
	 <SET CNT 0>
	 <REPEAT ()
		 <COND (<SET X <ZGET .SOURCE .CNT>>
			<ZPUT .DEST .CNT .X>
			<ZPUT .DEST2 .CNT .X>)>
		 <COND (<OR <G? <SET CNT <+ .CNT 1>> .LEN>
			    <G? .CNT 3>>
			<RETURN>)>>
	 
       ; "Select sex of AIRCLERK randomly."

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
	 <>>
	       	 
<OBJECT AIR-A
	(LOC ROOMS)
	(DESC "Concourse")
	(FLAGS SPECIAL-DROP LIGHTED LOCATION IN-TERMINAL)
	(HEAR AIRPORT-MUSIC)
	(NORTH TO AIR-B)
	(EAST TO AIR-B)
	(SOUTH PER EXIT-CONCOURSE)
	(WEST TO AIR-B)
	(IN TO AIR-B)
	(OUT PER EXIT-CONCOURSE)
	(GLOBAL AIRPORT-CROWD SIGNS SKYCAPS AIRPORT-MUSIC)
	(AIRLINE-LIST <TABLE 0 0 0 0 0 0>)
	(ACTION AIR-A-F)
	(THINGS PSEUDO-VEC)>

<DEFINE AIR-A-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL "You're in the concourse. Signs overhead">
		<SAY-SIGNS>
		T)
	       (<EQUAL? .CONTEXT ,M-ENTERING>
		<UNMAKE ,AIR-B ,TOUCHED>
		<SETUP-SIGNS>
		<>)
	       (<EQUAL? .CONTEXT ,M-EXIT>
		<UNMAKE ,AIR-A ,TOUCHED>
		<>)
	       (T
		<>)>>

<OBJECT AIR-B
	(LOC ROOMS)
	(DESC "Concourse")
	(SDESC DESCRIBE-AIR-B)
	(FLAGS SPECIAL-DROP LIGHTED LOCATION IN-TERMINAL)
	(HEAR AIRPORT-MUSIC)
	(DESK-NAME 0)
	(NORTH TO AIR-C)
	(EAST TO AIR-C)
	(SOUTH TO AIR-A)
	(WEST TO AIR-C)
	(IN TO AIR-C)
	(OUT TO AIR-A)
	(AIRLINE-LIST <TABLE 0 0 0 0 0 0>)
	(GLOBAL AIRPORT-CROWD SKYCAPS SIGNS AIRPORT-MUSIC)
	(ACTION AIR-B-F)
	(THINGS PSEUDO-VEC)>

<DEFINE DESCRIBE-AIR-B ()
	 <TELL <PSAIR-STR ,DESK-ID> " Desk">
	 T>

<DEFINE AIR-B-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL "You're standing in ">
		<COND (<T? ,CLERK-LISTENING?>
		       <TELL "front of ">)
		      (T
		       <TELL "line at ">)>
		<TELL THE ,AIRLINE-DESK>
		<COND (<T? ,CLERK-LISTENING?>
		       <TELL ". " CTHE ,AIRCLERK
			     " is looking at you expectantly">)
		      (<NOT <IN? ,FATSO ,AIR-B>>
		       <TELL
". A number of people are waiting in front of you in an annoying manner">)>
		<TELL ". Signs overhead">
		<SAY-SIGNS>
		T)
	       (<EQUAL? .CONTEXT ,M-ENTERING>
		<SETUP-SIGNS>
		<SETUP-DESK>
		<COND (<AND <EQUAL? <PSAIR-CODE ,DESK-ID> ,PSAIR-GALLIA>
			    <NOT ,OMNIA-SEEN?>>
		       <SETG DESK-SCRIPT ,INIT-OMNIA-SCRIPT>
		       <QUEUE I-OMNIA-DESK>)
		      (T
		       <SETG DESK-SCRIPT ,INIT-DESK-SCRIPT>
		       <QUEUE I-DESK>)>
		<>)
	       (<EQUAL? .CONTEXT ,M-EXIT>
		<COND (<AND <EQUAL? <PSAIR-CODE ,DESK-ID>  ,PSAIR-GALLIA>
			    <NOT ,OMNIA-SEEN?>>
		       <SETG OMNIA-SEEN? T>
		       <REMOVE ,FATSO>
		       <DEQUEUE I-OMNIA-DESK>)
		      (T
		       <DEQUEUE I-DESK>)>
		<>)
	       (T
		<>)>>

<OBJECT AIR-C
	(LOC ROOMS)
	(DESC "Concourse")
	(FLAGS SPECIAL-DROP LIGHTED LOCATION IN-TERMINAL)
	(HEAR AIRPORT-MUSIC)
	(NORTH TO AIR-A)
	(EAST TO AIR-A)
	(SOUTH TO AIR-A)
	(WEST TO AIR-A)
	(IN TO AIR-A)
	(OUT TO AIR-A)
	(UP PER AIR-C-UP)
	(GLOBAL AIRPORT-CROWD SIGNS SKYCAPS PILLAR AIRPORT-MUSIC)
	(AIRLINE-LIST <TABLE 0 0 0 0 0 0>)
	(ACTION AIR-C-F)
	(THINGS PSEUDO-VEC)>

<DEFINE AIR-C-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL 
"You're in the concourse. A pillar has signs on it that">
		<SAY-SIGNS>
		T)
	       (<EQUAL? .CONTEXT ,M-ENTERING>
		<UNMAKE ,AIR-B ,TOUCHED>
		<SETUP-SIGNS>
		<>)
	       (<EQUAL? .CONTEXT ,M-EXIT>
		<UNMAKE ,AIR-C ,TOUCHED>
		<>)
	       (T
		<>)>>

<DEFINE AIR-C-UP ()
	 <SETG NEW-SETUP? <>>
	 <TELL
"Dangerous. Very risky. The pillar is quite narrow and smooth, and doesn't offer much in the way of grip. Nevertheless, you manage to climb up to where the signs are" ,PCR>
	 ,PILLAR-A>

<OBJECT PILLAR-A
	(LOC ROOMS)
	(DESC "Pillar")
	(FLAGS SPECIAL-DROP NO-NERD LIGHTED LOCATION IN-TERMINAL)
	(HEAR AIRPORT-MUSIC)
	(OVERHEAD PSIGNS)
	(UP PER PILLAR-A-UP)
	(DOWN PER PILLAR-A-DOWN)
	(NORTH SORRY "You'd fall if you went that way.")
	(EAST SORRY "You'd fall if you went that way.")
	(SOUTH SORRY "You'd fall if you went that way.")
	(WEST SORRY "You'd fall if you went that way.")
	(AIRLINE-LIST <TABLE 0 0 0 0 0 0>)
	(GLOBAL AIRPORT-CROWD PILLAR PSIGNS AIRPORT-MUSIC)
	(ACTION PILLAR-A-F)
	(LDESC "You're halfway up the pillar.")
	(THINGS PSEUDO-VEC)>

<DEFINE PILLAR-A-UP ()
	 <TELL 
"You shin further up the pillar. This is getting very dangerous" ,PCR>
	 ,PILLAR-B>

<DEFINE PILLAR-A-DOWN ()
	 <TELL "You slide the last few feet to " THE ,FLOOR>
	 <COND (<NOT <IS? ,AIRPORT-MUSIC ,SHORTED-OUT>>
		<TELL ,PCR>
		,AIR-C)
	       (T
		<TELL 
", where a grateful cheering crowd carries you shoulder high to the front of the check-in desk. There, you are quickly issued a boarding card and passed into the personal care of a passing airline official, who whisks you through all the formalities in a way which shows it's perfectly possible really, if they put their minds to it. Within three minutes you are sitting in a seat on a plane, and three minutes later still you have taken off and the plane is safely on its way to Zalagasa." CR>
		<GO-TO-PLANE>
		<>)>>

<DEFINE PILLAR-A-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-ENTERED>
		<COND (<NOT <IS? ,AIRPORT-CROWD ,SEEN>>
		       <MAKE ,AIRPORT-CROWD ,SEEN>
		       <TELL CR
"A crowd of curious onlookers is gathering below." CR>
		       T)
		      (T
		       <>)>)
	       (T
		<>)>>

<OBJECT PILLAR-B
	(LOC ROOMS)
	(DESC "Top of Pillar")
	(FLAGS SPECIAL-DROP NO-NERD LIGHTED LOCATION IN-TERMINAL)
	(HEAR AIRPORT-MUSIC)
	(OVERHEAD GRATE)
	(NORTH SORRY "You'd fall if you went that way.")
	(EAST SORRY "You'd fall if you went that way.")
	(SOUTH SORRY "You'd fall if you went that way.")
	(WEST SORRY "You'd fall if you went that way.")
	(UP TO DUCT-A IF GRATE IS OPEN)
	(IN TO DUCT-A IF GRATE IS OPEN)
	(DOWN PER PILLAR-B-DOWN)
	(GLOBAL AIRPORT-CROWD PILLAR PSIGNS GRATE DUCT AIRPORT-MUSIC)
	(ACTION PILLAR-B-F)
	(THINGS PSEUDO-VEC)>

<DEFINE PILLAR-B-DOWN ()
	 <TELL "You cautiously descend the pillar" ,PCR>
	 ,PILLAR-A>

<DEFINE PILLAR-B-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL "You're at the top of the pillar. A">
		<OPEN-CLOSED ,GRATE>
		<TELL " is visible in the ceiling overhead." CR>
		T)
	       (<EQUAL? .CONTEXT ,M-ENTERED>
		<COND (<NOT <IS? ,AIRPORT-CROWD ,TOUCHED>>
		       <MAKE ,AIRPORT-CROWD ,TOUCHED>
		       <TELL CR "The crowd below is getting bigger." CR>
		       T)
		      (T
		       <>)>)
	       (T
		<>)>>

<OBJECT DUCT-A
	(LOC ROOMS)
	(DESC "Duct")
	(FLAGS SPECIAL-DROP NO-NERD LIGHTED LOCATION IN-TERMINAL)
	(HEAR AIRPORT-MUSIC)
	(DOWN TO PILLAR-B IF GRATE IS OPEN)
	(OUT TO PILLAR-B IF GRATE IS OPEN)
	(UP PER DUCT-A-UP)
	(SOUTH PER DUCT-A-UP)
	(NORTH SORRY "You hit your head against the duct. Ouch!")
	(EAST SORRY "You hit your head against the duct. Ouch!")
	(WEST SORRY "You hit your head against the duct. Ouch!")
	(GLOBAL PILLAR PSIGNS GRATE DUCT AIRPORT-MUSIC)
	(ACTION DUCT-A-F)>

<DEFINE DUCT-A-UP ()
	 <TELL "You crawl up into the duct" ,PCR>
	 ,DUCT-B>

<DEFINE DUCT-A-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL "You're at the bottom of an air conditioning duct that curves upward to the south. A">
		<OPEN-CLOSED ,GRATE>
		<TELL " leads downward." CR>
		T)
	       (<EQUAL? .CONTEXT ,M-ENTERING>
		<SETG DESK-SCRIPT 3>
		<QUEUE I-OMNIA-LEAVING>
		<>)
	       (T
		<>)>>

<OBJECT DUCT-B
	(LOC ROOMS)
	(DESC "Duct")
	(FLAGS ; LIGHTED SPECIAL-DROP NO-NERD LOCATION IN-TERMINAL)
	(HEAR AIRPORT-MUSIC)
	(DOWN PER DUCT-B-DOWN)
	(NORTH PER DUCT-B-DOWN)
	(UP PER DUCT-B-UP)
	(EAST PER DUCT-B-UP)
	(OUT PER WHICH-WAY-OUT)
	(IN PER WHICH-WAY-IN)
	(SOUTH SORRY "You hit your head against the duct. Ouch!")
        (WEST SORRY "You hit your head against the duct. Ouch!")
	(GLOBAL DUCT AIRPORT-MUSIC)
	(LDESC "You're in a narrow air conditioning duct that curves upward to the east, and downward to the north.")>

<DEFINE DUCT-B-UP ()
	 <TELL "You crawl higher into the duct" ,PCR>
	 ,DUCT-C>

<DEFINE DUCT-B-DOWN ()
	 <TELL "You slip down the duct" ,PCR>
	 ,DUCT-A>

<OBJECT DUCT-C
	(LOC ROOMS)
	(DESC "Duct")
	(FLAGS ; LIGHTED SPECIAL-DROP NO-NERD LOCATION IN-TERMINAL)
	(HEAR AIRPORT-MUSIC)
	(DOWN PER DUCT-C-DOWN)
	(WEST PER DUCT-C-DOWN)
	(UP PER DUCT-C-UP)
	(NORTH PER DUCT-C-UP)
	(OUT PER WHICH-WAY-OUT)
	(IN PER WHICH-WAY-IN)
	(SOUTH SORRY "You hit your head against the duct. Ouch!")
        (EAST SORRY "You hit your head against the duct. Ouch!")
	(GLOBAL DUCT AIRPORT-MUSIC)
	(LDESC "You're in a narrow air conditioning duct that curves upward to the north, and downward to the west.")>

<DEFINE DUCT-C-UP ()
	 <TELL "You squeeze even higher into the duct" ,PCR>
	 ,DUCT-D>

<DEFINE DUCT-C-DOWN ()
	 <TELL "You slide down the duct" ,PCR>
	 ,DUCT-B>

<OBJECT DUCT-D
	(LOC ROOMS)
	(DESC "Duct")
	(FLAGS NO-NERD SPECIAL-DROP LIGHTED LOCATION IN-TERMINAL)
	(HEAR AIRPORT-MUSIC)
	(DOWN PER DUCT-D-DOWN)
	(SOUTH PER DUCT-D-DOWN)
	(UP SORRY "The duct doesn't go any higher.")
	(WEST SORRY "You hit your head against the duct. Ouch!")
        (NORTH SORRY "You hit your head against the duct. Ouch!")
	(IN TO IN-TOWER IF TOWER-GRATE IS OPEN)
	(EAST TO IN-TOWER IF TOWER-GRATE IS OPEN)
	(OUT PER WHICH-WAY-OUT)
	(GLOBAL TOWER-GRATE DUCT AIRPORT-MUSIC)
	(ACTION DUCT-D-F)>

<DEFINE DUCT-D-DOWN ()
	 <TELL "You slip downward into the duct" ,PCR>
	 ,DUCT-C>

<DEFINE DUCT-D-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL 
"You're at the top end of a narrow air conditioning duct. Light filters in through a">
		<OPEN-CLOSED ,TOWER-GRATE>
		<TELL " to the east." CR>
		T)
	       (T
		<>)>>

<OBJECT IN-TOWER
	(LOC ROOMS)
	(DESC "Control Tower")
	(FLAGS NO-NERD LIGHTED LOCATION IN-TERMINAL)
	(HEAR CONSOLE)
	(DOWN TO DUCT-D IF TOWER-GRATE IS OPEN)
	(IN TO DUCT-D IF TOWER-GRATE IS OPEN)
	(OUT PER WHICH-WAY-OUT)
	(NORTH SORRY "Air traffic controllers block your path.")
	(SOUTH SORRY "Air traffic controllers block your path.")
        (EAST SORRY "Air traffic controllers block your path.")
	(WEST SORRY "Air traffic controllers block your path.")
	(GLOBAL DUCT TOWER-GRATE TOWER)
	(ACTION IN-TOWER-F)
	(THINGS PSEUDO-VEC)>

<DEFINE IN-TOWER-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL "You're in the air traffic control tower. A">
		<OPEN-CLOSED ,TOWER-GRATE>
		<TELL " leads downward." CR>
		T)
	       (<EQUAL? .CONTEXT ,M-ENTERED>
		<COND (<IS? ,CONTROLLERS ,NODESC>
		       <UNMAKE ,CONTROLLERS ,NODESC>
		       <TELL CR
"Several air traffic controllers are hunched over consoles." CR>)>
		<TELL CR
"You emerge from the duct amidst a cloud of sparks and steam." CR CR>
		<COND (<NOT <IS? ,CONTROLLERS ,SEEN>>
		       <MAKE ,CONTROLLERS ,SEEN>
		       <QUEUE I-CONSOLE>
		       <TELL 
"Since air traffic controllers spend most of their lives staring thoughtfully into the clouds, they are a superstitious lot and, understandably, they mistake you, briefly, for some species of god">
		       <COND (<T? ,SEX>
			      <TELL "dess">)>
		       <TELL ". They are also a fairly short-tempered bunch, and with reason. All their working hours are spent looking after pilots and seeing that the poor little lambs are all right and know where they're supposed to be going and don't crash into things, but ">
		       <ITALICIZE "who gets the dates">
		       <TELL " at the end of the day? Not the air traffic controllers, that's who. Bear this in mind as you strut, god">
		       <COND (<T? ,SEX>
			      <TELL "dess">)>
		       <TELL "like, before them. They may think you're a pretty heavy-duty diety right now, but they could come leaping back to their senses at any moment, and a maddened pack of air traffic controllers who realize they've been conned again is not something you would want to be set on by. Ask what you will of them, but be quick about it. And do try and sound like ">
		       <COND (<T? ,SEX>
			      <TELL "Katherine Hepburn">)
			     (T
			      <TELL "Sir Laurence Olivier">)>
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
	       (<EQUAL? .CONTEXT ,M-EXIT>
		<DEQUEUE I-CONSOLE>
		<>)
	       (T
		<>)>>

<OBJECT LANDF
	(LOC ROOMS)
	(DESC "Lost and Found")
	(FLAGS NO-NERD LIGHTED LOCATION IN-TERMINAL)
	(WEST TO ENT-F IF LANDF-DOOR IS OPEN)
	(OUT TO ENT-F IF LANDF-DOOR IS OPEN)
	(GLOBAL LANDF-DOOR)
	(LDESC "You're in the Airport's Lost and Found office. A door leads west.")
	(THINGS PSEUDO-VEC)>


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
		<TELL "A " Q ,FATSO " is standing in front of you.">
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

"*** AIRLINE CLERK ***"

<OBJECT AIRCLERK
	(LOC AIR-B)
	(DESC "clerk")
	(SDESC DESCRIBE-AIRCLERK)
	(FLAGS LIVING PERSON)
	(SYNONYM ZZZP ZZZP ZZZP CLERK)
	(ADJECTIVE ZZZP ZZZP ZZZP AIRLINE)
	(DESCFCN AIRCLERK-F)
	(ACTION AIRCLERK-F)>

<DEFINE DESCRIBE-AIRCLERK ()
	 <TELL <PSAIR-STR ,DESK-ID> " clerk">
	 T>

<DEFINE AIRCLERK-F CLERK ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-OBJDESC>
		<TELL "A clerk is standing behind the desk, ">
		<COND (<ZERO? ,CLERK-LISTENING?>
		       <TELL "talking to the first person in line.">)
		      (T
		       <TELL "looking at you expectantly.">)>
		T)
	       (<EQUAL? .CONTEXT ,M-WINNER>
		<COND (<VERB? TAKE EXAMINE READ>
		       <SHOW-TO-AIRCLERK>
		       <RETURN ,FATAL-VALUE .CLERK>)
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
			      <SHOW-TO-AIRCLERK>
			      T)>)
		      (T
		       <>)>)
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
		<>)>>

<DEFINE NOT-FIRST-IN-LINE? ()
	 <COND (<ZERO? ,CLERK-LISTENING?>
		<TELL CTHE ,AIRCLERK 
" gives you an icy smile. \"I'll be pleased to help you in just a moment, ">
		<SIR-OR-MAAM>
		<TELL 
". Please let me finish helping the nice people in line before you.\"" CR>
		T)
	       (T
		<>)>>

<DEFINE ASK-AIRCLERK-ABOUT ("OPTIONAL" (OBJ <>))
	 <COND (<ZERO? .OBJ>
		<SET OBJ ,PRSI>)>
	 <TELL "\"I'm afraid I'm not authorized to say anything about "
	       THE .OBJ ", ">
	 <SIR-OR-MAAM>
	 <TELL ",\" admits ">
	 <TURNING-ATTENTION>
	 T>

<DEFINE ASK-AIRCLERK-FOR ("OPTIONAL" (OBJ <>))
	 <COND (<ZERO? .OBJ>
		<SET OBJ ,PRSI>)>
	 <TELL "\"Terribly sorry, ">
	 <SIR-OR-MAAM>
	 <TELL ", but I'm afraid I'm not authorized to give you " A .OBJ
	       ",\" admits ">
	 <TURNING-ATTENTION>
	 T>

<DEFINE SHOW-TO-AIRCLERK ("OPTIONAL" (OBJ <>))
	 <COND (<ZERO? .OBJ>
		<SET OBJ ,PRSO>)>
	 <TELL "\"I'm afraid I'm not authorized to comment on "
	       THE .OBJ " without the approval of my supervisor,\" says ">
	 <TURNING-ATTENTION>
	 T>


"*** CONTROLLERS ***"

<OBJECT CONTROLLERS
	(LOC IN-TOWER)
	(DESC "group of air traffic controllers")
	(FLAGS NODESC VOWEL LIVING PERSON)
	(SYNONYM GROUP BUNCH CROWD CONTROLLERS PEOPLE FOLKS)
	(ADJECTIVE AIR TRAFFIC)
	(DESCFCN CONTROLLERS-F)
	(ACTION CONTROLLERS-F)>

<DEFINE CONTROLLERS-F CONT ("OPTIONAL" (CONTEXT <>) "AUX" (FLIGHT <>))
	 <COND (<EQUAL? .CONTEXT ,M-OBJDESC>
		<TELL "A " Q ,CONTROLLERS
		      " is staring at you in awe.">
		<RETURN T .CONT>)>
	 <COND (<OR <PRSO? FLIGHT-42>
		    <AND <PRSO? INTNUM>
			 <EQUAL? <ZGET ,P-ADJW 0> ,W?FLIGHT ,W?OMNIA
				 		 ,W?GALLIA>>>
		<SET FLIGHT T>)>
	 <COND (<EQUAL? .CONTEXT ,M-WINNER>
		<COND (<OR <AND <VERB? DENY REFUSE>
				<PRSO? REQUEST-OBJECT>
				<NOUN-USED? ,W?REQUEST>>
			   <AND <VERB? DENY REFUSE>
				<T? .FLIGHT>>
			   <AND <VERB? SPIN>
				<T? .FLIGHT>
				<EQUAL? ,P-PRSA-WORD ,W?TURN ,W?RECALL>>
			   <AND <VERB? LAMP-OFF>
			    	<T? .FLIGHT>
				<EQUAL? ,P-PRSA-WORD ,W?STOP ,W?HALT>>>
		       <THEY-STOP-FLIGHT>
		       <RETURN ,FATAL-VALUE .CONT>)
		      (<AND <VERB? GET-FOR>
			    <T? .FLIGHT>
			    <PRSI? ME AIRPORT>>
		       <THEY-STOP-FLIGHT>
		       <RETURN ,FATAL-VALUE .CONT>)
		      (<AND <VERB? GRANT>
			    <PRSO? REQUEST-OBJECT>
			    <NOUN-USED? ,W?REQUEST>>
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
		<TELL CTHE ,WINNER " is too awed to respond." CR>
		,FATAL-VALUE)
	       (<T? .CONTEXT>
		<RETURN <> .CONT>)
	       (<THIS-PRSI?>
		<COND (<VERB? SHOW>
		       <TELL CTHEI
" stare at " THEO " are struck dumb by the sight of your " D ,PRSO ,PERIOD>
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
	 <COND (<OR <IS? ,FLIGHT-42 ,FLIGHT-GONE>
		    <IS? ,FLIGHT-42 ,FLIGHT-RECALLED>>
		<TELL 
"Alas, O mighty one, it is too late. That flight has already ">
		<COND (<IS? ,FLIGHT-42 ,FLIGHT-GONE>
		       <TELL "taken off!\"" CR>)
		      (T
		       <TELL "been recalled!\"" CR>)>
		<>)
	       (T
		<TELL 
"It shall be done, O mighty one!\" He turns to the radio console and barks, \"Tower to flight 42. Request " .STR " immediately!\"" CR CR>
		T)>>
		
"*** FLIGHT 42 ***"

<OBJECT FLIGHT-42
	(LOC GLOBAL-OBJECTS)
	(DESC "flight 42")
	(FLAGS NOARTICLE NODESC PERSON LIVING)
	(SYNONYM FORTY-TWO FLIGHT PLANE JET AIRPLANE)
	(ADJECTIVE FLIGHT OMNIA GALLIA)
	(GENERIC GENERIC-OMNIA-F)
	(ACTION FLIGHT-42-F)>

<DEFINE GENERIC-OMNIA-F (TBL)
	 <COND (<INTBL? ,P-IT-OBJECT <ZREST .TBL 2> <ZGET .TBL 0>>
		,P-IT-OBJECT)
	       (<HERE? IN-TOWER>
		,FLIGHT-42)
	       (T
		<MATCH-AIRLINE-NAME ,W?OMNIA ,W?GALLIA ,AIRLINE-PSEUDOS>
		,AIRLINE)>>

<BIT-SYNONYM SEEN FLIGHT-GONE>
<BIT-SYNONYM TOUCHED FLIGHT-RECALLED>

<DEFINE FLIGHT-42-F FLIGHT ("OPTIONAL" (CONTEXT <>))
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
	       (<SEEING?>
		<CANT-SEE-MUCH>
		T)
	       (<THIS-PRSI?>
		<COND (<AND <HERE? IN-TOWER>
			    <VERB? GIVE>
			    <PRSO? REQUEST-OBJECT>>
		       <GRANT-PLANE-REQUEST>)
		      (T
		       <CANT-FROM-HERE>)>
		T)		      
	       (<TOUCHING?>
		<CANT-FROM-HERE>
		T)
	       (<VERB? EXAMINE WATCH>
		<COND (<NOT <HERE? IN-TOWER>>
		       <CANT-SEE-MUCH>)
		      (<IS? ,PRSO ,FLIGHT-GONE>
		       <TELL "It's already out of sight." CR>)
		      (T
		       <TELL
			"Peering outside, you can see an Omnia Gallia jet ">
		       <COND (<IS? ,PRSO ,FLIGHT-RECALLED>
			      <TELL "rolling towards the terminal." CR>)
			     (T
			      <TELL "waiting at the end of a runway." CR>)>)>
		T)
	       (<SEEING?>
		<CANT-SEE-MUCH>
		T)
	       (<VERB? TELL ASK-FOR ASK-ABOUT QUESTION REPLY>
		<COND (<HERE? IN-TOWER>
		       <COND (<FLIGHT-GONE?>
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

<DEFINE FLIGHT-GONE? ()
	 <COND (<OR <IS? ,FLIGHT-42 ,FLIGHT-RECALLED>
		    <IS? ,FLIGHT-42 ,FLIGHT-GONE>>
		<TELL "Too late. That flight has already ">
		<COND (<IS? ,FLIGHT-42 ,FLIGHT-GONE>
		       <TELL "left." CR>)
		      (T
		       <TELL "been recalled." CR>)>
		T)
	       (T
		<RFALSE>)>>

<DEFINE GRANT-PLANE-REQUEST ()
	 <COND (<NOT <FLIGHT-GONE?>>
		<TELL 
		 "The radio heaves a sigh of relief. \"Roger, tower. Permission to take off acknowledged.\"" CR CR>
		<PLANE-TAKES-OFF>)>
	 T>
	 
<DEFINE TURN-AROUND-PLANE ()
	 <COND (<NOT <FLIGHT-GONE?>>
		<MAKE ,FLIGHT-42 ,FLIGHT-RECALLED>
		<TELL 
"The radio mutters something impolite. \"Acknowledged, tower. We'll taxi her back to the terminal.\"" CR>)>
	 T>

"*** AIRPORT CROWD ***"

<OBJECT AIRPORT-CROWD
	(LOC LOCAL-GLOBALS)
	(DESC "crowd")
	(FLAGS NODESC PERSON LIVING)
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
		<COND (<IS? ,AIRPORT-MUSIC ,SHORTED-OUT>
		       <TELL "The cheering of " THEO
			     " drowns out your words." CR>)
		      (<HERE? PILLAR-A PILLAR-B>
		       <TELL CTHEO 
 " looks at you strangely, but doesn't respond." CR>)
		      (T
		       <CROWD-IGNORES-YOU>)>
		,FATAL-VALUE)
	       (<VERB? EXAMINE WATCH>
		<COND (<IS? ,AIRPORT-MUSIC ,SHORTED-OUT>
		       <TELL CTHEO " is cheering wildly at you." CR>)
		      (<HERE? PILLAR-A PILLAR-B>
		       <TELL CTHEO 
			     " is obviously amused by your exploits." CR>)
		      (T
		       <CROWD-IGNORES-YOU>)>
		T)
	       (<VERB? WAVE-AT BOW>
		<COND (<IS? ,AIRPORT-MUSIC ,SHORTED-OUT>
		       <TELL CTHEO " cheers all the louder." CR>)
		      (<HERE? PILLAR-A PILLAR-B>
		       <TELL "A few members of " THEO " wave back." CR>)
		      (T
		       <CROWD-IGNORES-YOU>)>
		T)
	       (T
		<>)>>			    

<DEFINE CROWD-IGNORES-YOU ()
	 <TELL "Nobody pays any attention to you." CR>>


"Airport interrupt stuff"
<SETG TERM-TABLE
      <MAKE-TERM-TABLE 'TERM-TABLE <CHTYPE <ITABLE 5 0> TERM-TABLE>
		       'JUST-HEARD? <>
		       'JUST-PAGED? <>
		       'TERMINAL-MUZAK 0
		       'PATRONS
		       <LTABLE 2
			       "the owner of a large penguin named Dennis"
			       "the owner of a female ostrich named Daisy"
			       "Mr. Steviros Meretziokolis"
			       "someone familiar with devil worship"
			       "the President of El Paso Blubber Corporation"
			       "Mr. Arthur Dent"
			       "Mr. Corky Crisp"
			       "the Nobel Peace Prize winner of 1904">>>

<DEFINE I-TERMINAL IT ("OPTIONAL" (CR T) "AUX" P M)
	 <COND (<JUST-HEARD? ,TERM-TABLE>
		<JUST-HEARD? ,TERM-TABLE <>>
		<RETURN <> .IT>)
	       (<JUST-PAGED? ,TERM-TABLE>
		<JUST-PAGED? ,TERM-TABLE <>>)
	       (<PROB 20>
		<JUST-PAGED? ,TERM-TABLE T>
	        <COND (<T? .CR>
		       <ZCRLF>)>
		<TELL "\"Air Gaul paging passenger ">
		<SHOW-FIELD ,FIRST-NAME>
		<TELL " ">
		<SHOW-FIELD ,LAST-NAME>
		<TELL ", please pick up the white courtesy phone.\"" CR>
		<RETURN T .IT>)>
	 <COND (<PROB 30>
		<COND (<T? .CR>
		       <ZCRLF>)>
		<TELL
"\"Your attention, please. Would " <PICK-NEXT <PATRONS ,TERM-TABLE>>
" please pick up the white courtesy phone.\"" CR>
		<RETURN T .IT>)
	       (<PROB 50>
		<SET P <TERMINAL-MUZAK ,TERM-TABLE>>
		<COND (<G? <SET P <+ .P 1>> ,NUMBER-OF-TUNES>
		       <SET P 0>)>
		<TERMINAL-MUZAK ,TERM-TABLE .P>
		<COND (<T? .CR>
		       <ZCRLF>)>
		<TELL "You hear ">
		<SAY-MUZAK .P>
		<TELL " being played very ">
		<COND (<HERE? PILLAR-B>
		       <TELL "loudly and ">)>
		<TELL "soothingly." CR>
		<RETURN T .IT>)
	       (T
		<RETURN <> .IT>)>>

<MSETG INIT-DESK-SCRIPT 4>
<MSETG INIT-OMNIA-SCRIPT 7>
<SETG DESK-SCRIPT 0>

<SETG CLERK-LISTENING? <>>

<DEFINE I-OMNIA-DESK DESK ("OPTIONAL" (CR T))
	<SETG DESK-SCRIPT <- ,DESK-SCRIPT 1>>
	<COND (<EQUAL? ,DESK-SCRIPT 6>
	       <RETURN <> .DESK>)
	      (<T? .CR>
	       <ZCRLF>)>
	<COND (<EQUAL? ,DESK-SCRIPT 5>
	       <MOVE ,FATSO ,AIR-B>
	       <SETG P-HIM-OBJECT ,FATSO>
	       <TELL
"There's now only one person, a very fat man, standing in front of you. He explains to the clerk that he wishes to exchange the ticket he has for one to Mombasa the month after, only instead of it being a direct return he wants to come back via Nice instead and spend a week there or maybe longer because he's meeting his wife who'll be flying in from Rome, Italy, and can he use part of his accumulated Frequent Flyer mileage to offset the price of her connection between Hong Kong and Rome? She'll be in Hong Kong before going to Rome, he adds, by way of explanation." CR>
	       <FIRST-OMNIA-PAGE>
	       <RETURN T .DESK>)
	      (<EQUAL? ,DESK-SCRIPT 4>
	       <TELL CTHE ,FATSO
" in front of you explains that his wife already has a ticket with Cathay Pacific from Hong Kong to Rome, and wonders if it is possible to change that to Omnia Gallia and use some of his mileage credits. The clerk explains that Omnia Gallia doesn't fly that route, and that mileage credits aren't transferable to other passengers anyway. The man says that he'd heard that on some airlines it was and the clerk says not as far as ">
	       <COND (<IS? ,AIRCLERK ,FEMALE>
		      <TELL "s">)>
	       <TELL 
"he knows, the man says that's a pity, the clerk agrees, and starts to look up next month's flights to Mombasa." CR>
	       <SECOND-OMNIA-PAGE>
	       <RETURN T .DESK>)
	      (<EQUAL? ,DESK-SCRIPT 3>
	       <TELL CTHE ,FATSO
" in front of you turns to you and smiles. \"Takes forever, doesn't it? I thought you could transfer these Frequent Flyer things. Should be able to for your wife. Going far?\" He turns back to the clerk without listening for your answer.">
	       <RETURN T .DESK>)
	      (<EQUAL? ,DESK-SCRIPT 2>
	       <REMOVE ,FATSO>
	       <COND (<IS? ,AIRCLERK ,FEMALE>
		      <SETG P-HIM-OBJECT ,NOT-HERE-OBJECT>)
		     (T
		      <SETG P-HIM-OBJECT ,AIRCLERK>)>
	       <TELL CTHE ,AIRCLERK
" explains to " THE ,FATSO " in front of you that flights to Mombasa go via Paris which means changing airports, and that on his fare schedule he wouldn't be allowed a stopover in Nice." CR>
	       <LAST-OMNIA-PAGE>
	       <TELL CR CTHE ,FATSO
" in front of you says he won't bother, then, he'll just go to Nice next month as he originally planned. The clerk hopes that he has a nice day, the man walks away, and the clerk turns to you. ">
	       <WELCOME-TO-DESK>
	       <RETURN T .DESK>)
	      (<EQUAL? ,DESK-SCRIPT 1>
	       <CLERK-WAITING>
	       <RETURN T .DESK>)>
	 <CLERK-BYE>
	 <RETURN T .DESK>>

<DEFINE FIRST-OMNIA-PAGE ()
	 <JUST-HEARD? ,TERM-TABLE T>
	 <TELL
"A voice on the public address system says, \"Omnia
Airways announce the imminent departure of their flight 42 to Paris. Would all remaining passengers please check in immediately at the Omnia desk.
Thank you.\"" CR>>

<DEFINE SECOND-OMNIA-PAGE ()
	 <JUST-HEARD? ,TERM-TABLE T>
	 <TELL CR "\"Omnia
Airways announce the momentary departure of their flight 42 to Paris. Would passenger ">
	 <SHOW-FIELD ,FIRST-NAME>
	 <TELL " ">
	 <SHOW-FIELD ,LAST-NAME>
	 <TELL " please check in ">
	 <ITALICIZE "immediately">
	 <TELL ". This flight is about to leave.\"" CR>>

<DEFINE LAST-OMNIA-PAGE ()
	 <JUST-HEARD? ,TERM-TABLE T>
	 <TELL CR "\"Omnia
Airways announce the departure of their flight 42 to Paris. This flight is now closed. Have a nice day.\"" CR>>

<DEFINE I-OMNIA-LEAVING LEAVING ()
	 <SETG DESK-SCRIPT <- ,DESK-SCRIPT 1>>
	 <COND (<EQUAL? ,DESK-SCRIPT 2>
		<FIRST-OMNIA-PAGE>
		<RETURN T .LEAVING>)
	       (<EQUAL? ,DESK-SCRIPT 1>
		<SECOND-OMNIA-PAGE>
		<RETURN T .LEAVING>)>
	 <LAST-OMNIA-PAGE>
	 <SETG OMNIA-SEEN? T>
	 <RETURN T .LEAVING>>

<DEFINE I-DESK DESK ("OPTIONAL" (CR T))
	 <SETG DESK-SCRIPT <- ,DESK-SCRIPT 1>>
	 <COND (<EQUAL? ,DESK-SCRIPT 3>
		<RETURN <> .DESK>)
	       (<T? .CR>
		<ZCRLF>)>
	 <COND (<EQUAL? ,DESK-SCRIPT 2>
		<TELL "You're now the first person in line at the desk" ,PCR>
		<WELCOME-TO-DESK>
		<RETURN T .DESK>)
	       (<EQUAL? ,DESK-SCRIPT 1>
		<CLERK-WAITING>
		<RETURN T .DESK>)>
	 <CLERK-BYE>
	 <RETURN T .DESK>>

<DEFINE WELCOME-TO-DESK ()
	 <SETG CLERK-LISTENING? T>
	 <TELL "\"Welcome to " <PSAIR-STR ,DESK-ID> ", ">
	 <SIR-OR-MAAM>
	 <TELL ",\" smiles the clerk. \"May I help you?\"" CR>>

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
	 <SETG CLERK-LISTENING? <>>
	 <COND (<QUEUED? I-OMNIA-DESK>
		<DEQUEUE I-OMNIA-DESK>
		<SETG OMNIA-SEEN? T>
		<QUEUE I-DESK>)>		
	 <SETG DESK-SCRIPT ,INIT-DESK-SCRIPT>
	 <TELL THE ,AIRCLERK ", turning ">
	 <COND (<IS? ,AIRCLERK ,FEMALE>
		<TELL "her">)
	       (T
		<TELL "his">)>
	 <TELL " attention to the person behind you in line." CR>>

<SETG TOWER-SCRIPT 4>

<DEFINE I-CONSOLE CONSOLE ("OPTIONAL" (CR T) "AUX" (PLANE T))
	 <COND (<OR <IS? ,FLIGHT-42 ,FLIGHT-GONE>
		    <IS? ,FLIGHT-42 ,FLIGHT-RECALLED>>
		<SET PLANE <>>)>
	 <SETG TOWER-SCRIPT <- ,TOWER-SCRIPT 1>>
	 <COND (<EQUAL? ,TOWER-SCRIPT 3>
		<COND (<ZERO? .PLANE>
		       <RETURN <> .CONSOLE>)
		      (<T? .CR>
		       <ZCRLF>)>
		<TELL 
"A console radio crackles to life nearby. \"Omnia Gallia flight 42 to ">
		<SHOW-FIELD ,CITY-NAME>
		<TELL " tower. Request permission to take off.\"" CR>
		<RETURN T .CONSOLE>)
	       (<EQUAL? ,TOWER-SCRIPT 2>
	        <COND (<T? .CR>
		       <ZCRLF>)>
		<TELL 
"The controllers continue to grovel at your smoky apparition." CR>
		<COND (<ZERO? .PLANE>
		       <RETURN T .CONSOLE>)>
		<TELL CR "\"Omnia Gallia flight 42 to Paris, calling ">
		<SHOW-FIELD ,CITY-NAME>
		<TELL " tower.\" The radio voice sounds a bit miffed. \"Are you guys asleep up there? Permission to take off, granted or denied?\"" CR>
		<RETURN T .CONSOLE>)
	       (<EQUAL? ,TOWER-SCRIPT 1>
		<COND (<T? .CR>
		       <ZCRLF>)>
		<TELL 
"The air traffic controllers are starting to frown. In the absence of any more smoke and lights you are beginning to appear somewhat less than immortal; distinctly shabby, in fact.|
|
There is a very very nasty pause." CR>
		<COND (<ZERO? .PLANE>
		       <RETURN T .CONSOLE>)>
		<TELL CR "The radio crackles with indignance. \"">
		<SHOW-FIELD ,CITY-NAME>
		<TELL " tower! ">
		<SHOW-FIELD ,CITY-NAME>
		<TELL " tower! Omnia Gallia flight 42, requesting immediate permission to take off! Permission granted or denied?\"" CR>
		<RETURN T .CONSOLE>)>
	 <COND (<T? .CR>
		<ZCRLF>)>
	 <COND (<T? .PLANE>
		<TELL 
"The Omnia Gallia pilot on the radio utters an oath that will probably cost him his license. ">
		<PLANE-TAKES-OFF>
		<ZCRLF>)>
	 <TELL 
"By now, the controllers have pretty much decided that you're not any sort of god">
	 <COND (<T? ,SEX>
		<TELL "dess">)>
	 <TELL " or deity, but are probably instead a stupid air conditioning repairperson fumbling around in the ducts with no business disrupting the vital work of air traffic controllers.">
	 <POLICE>
	 <RETURN T .CONSOLE>>
	 
<DEFINE PLANE-TAKES-OFF ()
	 <MAKE ,FLIGHT-42 ,FLIGHT-GONE>
	 <DEQUEUE I-CONSOLE>
	 <TELL 
"Moments later, a huge intercontinental jet roars past the tower, barely missing a Piper Cub as it climbs out of sight." CR>>

