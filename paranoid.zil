"PARANOID for BUREAUCRACY. Copyright 1987 Infocom, Inc. All rights reserved."

<FILE-FLAGS MDL-ZIL?>

"*** SPY ***"

<SETG COMP-WORD-FATAL? <>>

<CONSTANT ANS-TABLE <LTABLE 0 0 0 0>>

<MSETG NO-PW-SAID 0>	; "No passwords have been exchanged"
<MSETG USER-PW-SAID 1>	; "User has correctly said the password"
<MSETG SPY-PW-SAID 2>	; "The spy has said his back"

<CONSTANT PSTRING
	  "Unfortunately, there's a radio connected to my brain">
<CONSTANT SSTRING "Actually, it's the BBC controlling us from London">

<DEFINE-GLOBALS PARANOID-GLOBALS
		(SPY-TIMER:FIX BYTE 5)
		(COM-TIMER:FIX BYTE 4)
		(USERPW ,NO-PW-SAID)
		(CRAZY-COUNT:FIX BYTE 4)
		(SOMETHING-SAID BYTE <>)>

<CONSTANT P-Q
       <TABLE ;"How many health fascists are there in the FDA?"
	      "What chemical is the international health conspiracy using to destroy our valuable body fat?"
	      "What do Ronald Wilson Reagan, Daniel Miguel Ortega, Dwight Eugene Gooden and Johnny Herman Carson have in common (and are a menace because of it)?"
	      "What device is used by the banks to keep track of the whereabouts of American citizens?"
	      "Where is the centre of communist insurgency in the United States?"
	      "The existence of which one of the fifty states of the union is a fiction invented by the Trilateral Commission for its own nefarious purposes?"
	      "What left-wing organisation foiled the coup d'etat directly after the assassination of John F. Kennedy, leading to decades of crypto-communist government in America?"
	      "What is the breeding ground for most major diseases?"
	      "How do THEY learn so much about you?"
	      "By what percentage do students who exchange digital watches with multiple partners increase their chances of contracting bubonic plague?"
	      "What local government-subsidised program poses the greatest threat to home privacy?"
	      "What are the Mexicans unleashing on the United States for refusing to grant Mexico a major-league baseball franchise?"
	      "What secret FBI surveillance method is masquerading under the guise of a public service?"
	      "Who is THEIR leader?"
	      "What well-meaning legislation was actually a communist-inspired plot to destroy the American family?"
	      "How are the dentists of America conspiring to destroy the minds of our children?">>

<CONSTANT P-A <PTABLE ;<PLTABLE <PLTABLE <STR-TABLE "42">>>
		  <PLTABLE <PLTABLE <STR-TABLE "aspartame">>
			   <PLTABLE <STR-TABLE "nutrasweet">>>
		  <PLTABLE <PLTABLE <STR-TABLE "666">>
			   <PLTABLE <STR-TABLE "6">
				    <STR-TABLE "6">
				    <STR-TABLE "6">>>
		  <PLTABLE <PLTABLE <STR-TABLE "atmS">>
			   <PLTABLE <STR-TABLE "automatic">
				    <STR-TABLE "teller">
				    <STR-TABLE "machineS">>>
		  <PLTABLE <PLTABLE <STR-TABLE "ohio">>>
		  <PLTABLE <PLTABLE <STR-TABLE "delaware">>>
		  <PLTABLE <PLTABLE <STR-TABLE "nfl">>
			   <PLTABLE <STR-TABLE "national">
				    <STR-TABLE "football">
				    <STR-TABLE "league">>>
		  <PLTABLE <PLTABLE <STR-TABLE "yogurt">>
			   <PLTABLE <STR-TABLE "yoghurt">>>
		  <PLTABLE <PLTABLE <STR-TABLE "garbage">>>
		  <PLTABLE <PLTABLE <STR-TABLE "300">>
			   <PLTABLE <STR-TABLE "300%">>>
		  <PLTABLE <PLTABLE <STR-TABLE "cable"> <STR-TABLE "tv">>
			   <PLTABLE <STR-TABLE "cable">
				    <STR-TABLE "television">>>
		  <PLTABLE <PLTABLE <STR-TABLE "killer"> <STR-TABLE "bees">>>
		  <PLTABLE <PLTABLE <STR-TABLE "traffic">
				    <STR-TABLE "helicopterS">>
			   <PLTABLE <STR-TABLE "traffic">
				    <STR-TABLE "control">
				    <STR-TABLE "helicopterS">>
			   <PLTABLE <STR-TABLE "traffic">
				    <STR-TABLE "copterS">>
			   <PLTABLE <STR-TABLE "traffic">
				    <STR-TABLE "control">
				    <STR-TABLE "copterS">>>
		  <PLTABLE <PLTABLE <STR-TABLE "queen"> <STR-TABLE "mum">>>
		  <PLTABLE <PLTABLE <STR-TABLE "gi">
				    <STR-TABLE "bill">>>
		  <PLTABLE <PLTABLE <STR-TABLE "novocaine">>>>>

<CONSTANT OZ-ROYS
      <PLTABLE "The Russians are coming! The Russians are coming!"
		"Don't give me that blue whale stuff! They're spy submarines!" 
		"The computers have come alive! They can't turn them off!" 
		"Look! Headless eyes! Headless eyes in the ozone layer!" 
		"The llamas know everything! They write it down in a little book!"
		"Laboratories! Laboratories in Utah! Where they make stuff!">>

<CONSTANT INCI-TBL
      <PLTABLE W?ACTUALLY W?COMMA W?IT\'S W?THE W?BBC W?CONTROLLING W?US
	       W?FROM W?LONDON>>

<CONSTANT UNFO-TBL
      <PLTABLE W?UNFORTUNATELY W?COMMA W?THERE\'S W?A W?RADIO W?CONNECTED
	       W?TO W?MY W?BRAIN>>

<CONSTANT CRAZIES
      <PTABLE "Suddenly a bunch of men in white coats appear and put you in a straitjacket. They throw you in a paddy wagon and take you away to an asylum. Realising that this turn of events will mean you must fill out another set of change-of-address cards, you go completely bughouse and discover true happiness
in the arms of a green llama which appears each night, high up on the rubber
wall." 
	      "Are you dabbling in controlled substances or something?" 
	      "Perhaps you should consult a psychiatrist before it's too late."
	      "What astonishing drivel. You ought to be put away." 
	      "If you go around saying things like that, people will start thinking you are a little eccentric.">>

<OBJECT SPY
	(DESC "weirdo")
	(FLAGS LIVING PERSON)
	(SYNONYM STRANGER MAN ODDITY WEIRDO FELLOW GUY WOODY)
	(DESCFCN SPY-F)
	(CONTFCN SPY-F)
	(ACTION SPY-F)>

<DEFINE SPY-F SPY ("OPTIONAL" (CONTEXT <>))
	 <COND (<AND <EQUAL? .CONTEXT ,M-OBJDESC> <HERE? IN-FORT>>
		<TELL
		 "The twitching weirdo is here. He obviously arrived before you.">)
	       (<EQUAL? .CONTEXT ,M-OBJDESC>
		<TELL "A wild-eyed, twitching oddity looking a bit like
a heavily-armed Woody Allen is standing ">
		<COND (<HERE? IN-FARM>
		       <TELL "in the open doorway">)
		      (T
		       <TELL "nearby">)>
		<TELL ", holding a small armoury of weapons which he
fingers nervously, each in its turn.">
		T)
	       (<EQUAL? .CONTEXT ,M-CONT>
		<COND (<AND <VERB? GIVE SGIVE>
			    <OR <PRSI? ME>
				<PRSO? ME>>>
		       <>)
		      (<TOUCHING?>
		       <TELL CTHE ,SPY " draws away from you nervously fingering his gun. He obviously doesn't trust you to touch anything he's holding." CR>
		       T)
		      (T
		       <>)>)
	       (<EQUAL? .CONTEXT ,M-WINNER>
		<COND (<OR <VERB? STINGLAI>
			   <AND <PRSO? CHUTE>
				<PRSO-NOUN-USED? ,W?KA\'ABI>>
			   <AND <PRSI? CHUTE>
				<PRSI-NOUN-USED? ,W?KA\'ABI>>>
		       <TELL CTHE ,SPY " glares at you. \"You a commie or
something? Speak English!\"" CR>)
		      (<AND <VERB? TAKE> <==? ,PRSO ,POWER-SAW>>
		       <GIVE-SAW-TO-SPY>)
		      (<AND <VERB? TAKE>
			    <==? ,PRSO ,HACKSAW>
			    <IN? ,SPY ,JAIL>>
		       <GIVE-HSAW-TO-SPY>)
		      (<VERB? HELLO THANK>
		       <SPY-NODS>)
		      (<PRSO? ME>
		       <COND (<AND <VERB? SGIVE>
				   <ASK-SPY-FOR ,PRSI>>)
			     (ELSE
			      <SPY-IGNORES-YOU>)>)
		      (<PRSI? ME>
		       <COND (<AND <VERB? GIVE>
				   <ASK-SPY-FOR ,PRSO>>)
			     (ELSE
			      <SPY-IGNORES-YOU>)>)
		      (<HERE? JAIL>
		       <TELL CTHE ,SPY " is fully occupied with twitching and
grimacing and trying to come up with
a way of escaping. Alas, his paranoia-riddled brain just isn't up to it." CR>)
		      (T
		       <TELL CTHE ,SPY
" seems confused by your request. Even more confused than usual, that is." CR>)>
		,FATAL-VALUE)
	       (<T? .CONTEXT> <>)
	       (<VERB? EXAMINE>
		<SPY-F ,M-OBJDESC>
		<ZCRLF>
		T)
	       (<VERB? ASK-FOR>
		<COND (<ASK-SPY-FOR ,PRSI>
		       T)
		      (ELSE
		       <SPY-IGNORES-YOU>)>)
	       (<THIS-PRSI?>
		<COND (<AND <VERB? GIVE> <==? ,PRSO ,POWER-SAW>>
		       <GIVE-SAW-TO-SPY>)
		      (<AND <VERB? GIVE>
			    <==? ,PRSO ,HACKSAW>
			    <IN? ,SPY ,JAIL>>
		       <GIVE-HSAW-TO-SPY>)>)
	       (<VERB? TELL>
		<COND (<PICK-MESSAGE 0>
		       <COND (<==? ,CURRENT-MESSAGE ,UNFO-MESSAGE>
			      <SAID-UNF-TO-SPY? T>)
			     (<F? <SAID-INC-TO-SPY? T>>
			      <RETURN <> .SPY>)>
		       <PCLEAR>
		       ,FATAL-VALUE)
		      (<T? ,COMP-WORD-FATAL?>
		       <PCLEAR>
		       ,FATAL-VALUE)
		      (ELSE <>)>)
	       (<VERB? BOW WAVE-AT HELLO>
		<SPY-NODS>
	        T)
	       (T
		<>)>>

<DEFINE ASK-SPY-FOR (OBJ)
	<COND (<==? .OBJ ,POWER-SAW>
	       <COND (<IN? ,POWER-SAW ,SPY>
		      <TELL CTHE ,SPY " gives you " THE ,POWER-SAW ,PERIOD>
		      <MOVE ,POWER-SAW ,PLAYER>)
		     (<IN? ,POWER-SAW ,PLAYER>
		      <TELL "You already have it." CR>)
		     (ELSE
		      <TELL CTHE ,SPY " isn't holding " THE
			    ,POWER-SAW ,PERIOD>)>
	       T)
	      (ELSE
	       <TELL CTHE ,SPY " glares at you suspiciously, but says nothing."
		     CR>)>>

<DEFINE SPY-IGNORES-YOU ()
	<TELL CTHE ,SPY " is too engrossed in his own problems to pay any attention to you." CR>> 

<DEFINE GIVE-SAW-TO-SPY ()
	<COND (<AND <IS? ,GENERATOR ,SEEN> <IS? ,POWER-SAW ,SEEN>>
	       <TELL CTHE ,SPY " starts the saw, cuts the door open and drops " 
		     THE ,POWER-SAW ". You get off "
		     THE ,GENERATOR ,PERIOD>
	       <MAKE ,JDOOR ,OPENED>
	       <MOVE ,POWER-SAW ,JAIL>
	       <UNMAKE ,GENERATOR ,SEEN>
	       <UNMAKE ,GENERATOR ,NODESC>
	       <QUEUE I-SPY-LEAVES 3>)
	      (<IS? ,JDOOR ,OPENED>
	       <TELL CTHE ,SPY " is no longer interested in it." CR>)
	      (ELSE
	       <TELL CTHE ,SPY " takes the saw." CR>
	       <MOVE ,POWER-SAW ,SPY>)>>

<DEFINE GIVE-HSAW-TO-SPY ()
	<COND (<IS? ,SWISS ,NODESC>
	       <TELL CTHE ,SPY " gazes intently at the hacksaw, then shakes
his head. \"That'll never cut those bars. Maybe you'd better try this.\"">
	       <SPY-GIVES-SWISS>)
	      (T
	       <TELL CTHE ,SPY
		" isn't likely to do any better with the hacksaw than you did."
		CR>)>>

<DEFINE SPY-GIVES-SWISS ()
  <TELL " He hands you a Swiss army knife from his pocket" ,PERIOD>
  <UNMAKE ,SWISS ,NODESC>
  <MOVE ,SWISS ,PLAYER>
  T>

<DEFINE SPY-NODS ()
	 <TELL CTHE ,SPY " gives you a bewildered nod." CR>>

"** THE PARANOID **"

<OBJECT THE-PARANOID
	(LOC IN-FORT)
	(DESC "paranoid")
	(FLAGS LIVING PERSON)
	(SYNONYM PARANOID SURVIVALIST MAN GUY FELLOW RAMBO OWNER)
	(DESCFCN PARA-F)
	(CONTFCN PARA-F)
	(ACTION PARA-F)>

<DEFINE PARA-F ("OPTIONAL" (CONTEXT <>)
		"AUX" (SEEN? <IS? ,THE-PARANOID ,SEEN>))
	 <MAKE ,THE-PARANOID ,SEEN>
	 <COND (<EQUAL? .CONTEXT ,M-OBJDESC>
		<TELL "The completely, utterly paranoid owner of this house is here. ">
		<COND (.SEEN?
		       <TELL "He does not look pleased.">)
		      (ELSE
		       <TELL "He is also twitching nervously, and holding a machine gun. You are surprised that there are so
many heavily-armed Woody Allens in this neighbourhood. He looks you up and down suspiciously. You get the distinct impression that touching the mail you see here would be very unwise.">
		       <UNMAKE ,PARAMAIL ,NODESC>)> 
		T)
	       (<EQUAL? .CONTEXT ,M-CONT>
		<COND (<TOUCHING?>
		       <TELL "That would be extremely unwise under the circumstances." CR>
		       T)
		      (T
		       <>)>)
	       (<EQUAL? .CONTEXT ,M-WINNER>
		<TELL CTHE ,THE-PARANOID " is strangely uninterested in your remark. Perhaps he's trying to figure out the best way to kill you." CR>
		,FATAL-VALUE)
	       (<THIS-PRSI?>
		<>)
	       (<VERB? TELL>
		<COND (<PICK-MESSAGE 0>
		       <COND (<==? ,CURRENT-MESSAGE ,UNFO-MESSAGE>
			      <TELL CTHE ,THE-PARANOID " says, \"I don't really care
about the damned radio." CR>)
			     (T
			      <TELL CTHE ,THE-PARANOID " says, \"I don't really care
about the blasted BBC." CR>)>
		       <PCLEAR>
		       ,FATAL-VALUE)
		      (<T? ,COMP-WORD-FATAL?>
		       <PCLEAR>
		       ,FATAL-VALUE)
		      (ELSE <>)>)
	       (<VERB? BOW WAVE-AT HELLO>
		<TELL CTHE ,THE-PARANOID " is not interested in such pleasantries." CR>
	        T)
	       (T
		<>)>>


<OBJECT OUTSIDE-FORT
	(LOC ROOMS)
	(DESC "Dead End")
	(SDESC SAY-STREET-ADDRESS)
	(THINGS PARSE-RANDOM-LOC-VEC)
	(FLAGS IN-TOWN LIGHTED LOCATION)
	(NORTH TO OUTSIDE-FARM)
	(EAST SORRY "Barbed wire blocks your path.")
	(WEST SORRY "Barbed wire blocks your path.")
	(SOUTH TO IN-FORT IF BWGATE IS OPEN)
	(IN TO IN-FORT IF BWGATE IS OPEN)
	(GLOBAL CAMHOUSE BWGATE STREETNUMBERS
	 	GSTREET CAB CAB-DRIVER CAMERA)
	(STADDR 72)
	(ACTION OUTSIDE-FORT-F)>

<DEFINE OUTSIDE-FORT-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL 
"You're at a dead end. A camouflaged and heavily fortified house stands to
the south. You'd expect things like a moat and drawbridge, but you can't
see them from here. There is a gate of the impenetrable sort; who knows
what delights lie behind it? The street leads north." CR>
		T)
	       (<AND <EQUAL? .CONTEXT ,M-ENTERED>
		     <F? ,END-GAME?>>
		<COND (<AND <IS? ,BWGATE ,OPENED>
			    <IN? ,THE-PARANOID ,IN-FORT>>
		       <UNMAKE ,BWGATE ,OPENED>
	 	       <MAKE ,BWGATE ,LOCKED>
		       <MAKE ,INTERCOM ,TOUCHED>
		       <TELL CR CTHE ,BWGATE
" slams shut with a bang.|
|
\"Scram!\" crackles " THE ,INTERCOM ". \"No trespassing!\"" CR>
		       T)
		      (T
		       <COM-TIMER ,SET-COM-TIMER>
		       <QUEUE I-INTERCOM>
		       <>)>)
	       (<AND <EQUAL? .CONTEXT ,M-EXIT> <F? ,END-GAME?>>
		<DEQUEUE I-INTERCOM>
		<>)
	       (T
		<>)>>

<OBJECT IN-FORT
	(LOC ROOMS)
	(DESC "Foyer")
	(FLAGS IN-TOWN NO-NERD LIGHTED LOCATION INDOORS)
	(THINGS PARSE-RANDOM-LOC-VEC)
	(ENTER-FROM <PTABLE P?SOUTH OUTSIDE-FORT>)
	(EXIT-TO OUTSIDE-FORT)
	(NORTH TO OUTSIDE-FORT)
	(OUT TO OUTSIDE-FORT)
	(DOWN TO BASEMENT)
	(GLOBAL CAMHOUSE BWGATE PAR-STAIR)
	(ACTION IN-FORT-F)>

<OBJECT JAIL
	(LOC ROOMS)
	(DESC "gaol" ;"jail")
	(SYNONYM JAIL GAOL)
	(FLAGS IN-TOWN NO-NERD LIGHTED LOCATION INDOORS)
	(NORTH TO BASEMENT)
	(OUT TO BASEMENT)
	(ENTER-FROM <PTABLE P?SOUTH BASEMENT>)
	(EXIT-TO BASEMENT)
	(GLOBAL JDOOR)
	(ACTION JAIL-D)>

<DEFINE JAIL-D ("OPTIONAL" (CONTEXT <>))
	<COND (<==? .CONTEXT ,M-LOOK>
	       <COND (<IS? ,GENERATOR ,SEEN>
		      <TELL "You are sitting on a " D ,GENERATOR
			    " pedalling madly in the gaol cell in the basement of the paranoid's house.">)
		     (ELSE
		      <TELL 
		       "You're in a gaol cell in the basement of the paranoid's house.">)>
	       <TELL " To the north is an exit into the basement. ">
	       <COND (<NOT <IS? ,JDOOR ,OPENED>>
		      <TELL "The gaol door is closed. ">)>
	       <TELL "You can see a stairway in the basement leading up." CR>
	       T)
	      (<==? .CONTEXT ,M-EXIT>
	       <COND (<IS? ,GENERATOR ,SEEN>
		      <TELL "You'd better get off " THE ,GENERATOR " first." CR>
		      T)
		     (<NOT <IS? ,JDOOR ,OPENED>>
		      <TELL CTHE ,JDOOR " is closed." CR>
		      <THIS-IS-IT ,JDOOR>
		      T)
		     (T
		      <COND (<AND <IS? ,POWER-SAW ,SEEN>
				  <META-IN? ,POWER-SAW ,PLAYER>>
			     <UNMAKE ,POWER-SAW ,SEEN>)>
		      <COND (<IN? ,JAIL ,SPY>
			     <DEQUEUE I-SPY-LEAVES>
			     <QUEUE I-SPY-LEAVES>)>
		      <>)>)
	      (<T? .CONTEXT>
	       <>)
	      (<VERB? EXAMINE LOOK-INSIDE>
	       <COND (<HERE? JAIL BASEMENT>
		      <TELL "It's just the sort of escape-proof gaol cell you'd
expect to find in a private home. There aren't any of the usual facilities
normally found in gaol cells, probably because the owner doesn't like his
guests to make extended visits." CR>)
		     (T
		      <CANT-SEE-ANY ,JAIL>)>)
	      (ELSE <>)>>

<OBJECT JDOOR
	(LOC LOCAL-GLOBALS)
	(DESC "gaol door")
	(FLAGS NODESC DOORLIKE OPENABLE)
	(SYNONYM DOOR DOORWAY BARS BAR)
	(ADJECTIVE JAIL GAOL)
	(ACTION JDOOR-F)>

<DEFINE JDOOR-F ("OPTIONAL" (CONTEXT <>))
	<COND (<THIS-PRSI?> <>)
	      (<VERB? OPEN>
	       <COND (<IS? ,JDOOR ,OPENED>
		      <TELL "It's already destroyed." CR>)
		     (ELSE
		      <TELL "The " D ,JDOOR " won't budge." CR>)>
	       T)
	      (<VERB? EXAMINE LOOK-ON>
	       <TELL "It's a perfectly ordinary " D ,JDOOR " with perfectly
ordinary high-tensile chrome molybdenum bars welded firmly into place.">
	       <COND (<IS? ,JDOOR ,OPENED>
		      <TELL " It is currently non-functional.">)>
	       <ZCRLF>
	       T)
	      (<AND <VERB? CUT> <PRSI? HACKSAW>>
	       <COND (<IS? ,JDOOR ,OPENED>
		      <TELL "It's already destroyed." CR>)
		     (ELSE
		      <TELL "It would take you forever to saw through the bars in the door with that." CR>
		      <COND (<AND <IN? ,SPY ,JAIL>
				  <IS? ,SWISS ,NODESC>>
			     <TELL CTHE ,SPY " observes your futile efforts to saw through the bars. He says, \"What a great idea! Perhaps this will help.\"">
			     <SPY-GIVES-SWISS>
			     T)
			    (ELSE T)>)>)
	      (<VERB? CLOSE>
	       <COND (<IS? ,JDOOR ,OPENED>
		      <TELL "It's destroyed and can't be closed." CR>)
		     (ELSE
		      <>)>)
	      (<ENTERING?>
	       <COND (<HERE? JAIL>
		      <DO-WALK ,P?OUT>)
		     (T
		      <DO-WALK ,P?IN>)>)
	      (ELSE <>)>>

<OBJECT BASEMENT
	(LOC ROOMS)
	(DESC "basement")
	(FLAGS IN-TOWN LIGHTED LOCATION)
	(SOUTH TO JAIL IF JDOOR IS OPEN)
	(IN TO JAIL IF JDOOR IS OPEN)
	(UP TO IN-FORT)
	(EXIT-TO IN-FORT)
	(ENTER-FROM <PTABLE P?DOWN IN-FORT>)
	(SYNONYM BASEMENT)
	(GLOBAL JDOOR PAR-STAIR)
	(ACTION BASE-F)>

<DEFINE BASE-F ("OPTIONAL" (CONTEXT <>))
	<COND (<==? .CONTEXT ,M-LOOK>
	       <TELL ,THIS-IS "the basement of the paranoid's house. At the south end of the basement is a gaol. " CTHE ,JDOOR " is ">
	       <COND (<IS? ,JDOOR ,OPENED>
		      <TELL "open. ">)
		     (ELSE
		      <TELL "closed. ">)>
	       <TELL "A stairway leads up." CR>)
	      (<T? .CONTEXT> <>)
	      (<VERB? WALK-TO>
	       <COND (<==? ,HERE ,IN-FORT>
		      <DO-WALK ,P?DOWN>)
		     (<==? ,HERE ,JAIL>
		      <DO-WALK ,P?OUT>)
		     (T
		      <TELL ,CANT "get there from here." CR>)>
	       T)>>
	       

<OBJECT PAR-STAIR 
	(LOC LOCAL-GLOBALS)
	(DESC "stairway")
	(FLAGS NODESC)
	(SYNONYM STAIRWAY STAIRS STAIR)
	(ACTION PAR-STAIR-F)>

<DEFINE PAR-STAIR-F ()
	 <COND (<THIS-PRSI?>
		<COND (<PUT-ON-STAIRS?>
		       T)
		      (T
		       <>)>)
	       (<VERB? CLIMB-DOWN STAND-UNDER>
		<COND (<HERE? IN-FORT>
		       <COND (<IN? ,THE-PARANOID ,IN-FORT>
			      <TELL "The paranoid blocks the stairs." CR>)
			     (ELSE
			      <DO-WALK ,P?DOWN>)>)
		      (T
		       <ALREADY-AT-BOTTOM>)>
		T)
	       (<VERB? CLIMB-UP CLIMB-ON CLIMB-OVER>
		<DO-WALK ,P?UP>
		T)
	       (<VERB? WALK-TO FOLLOW USE>
		<COND (<HERE? IN-FORT>
		       <COND (<IN? ,THE-PARANOID ,IN-FORT>
			      <TELL "The paranoid blocks the stairs." CR>)
			     (ELSE
			      <DO-WALK ,P?DOWN>)>)
		      (<HERE? BASEMENT>
		       <DO-WALK ,P?UP>)
		      (T
		       <V-WALK-AROUND>)>
		T)
	       (<VERB? EXAMINE LOOK-ON>
		<TELL CTHEO " leads ">
		<COND (<HERE? BASEMENT>
		       <TELL "up." CR>)
		      (T
		       <TELL "down." CR>)>
		T)
	       (<VERB? LOOK-UP>
		<COND (<HERE? IN-FORT>
		       <ALREADY-AT-TOP>)
		      (T
		       <CANT-SEE-MUCH>)>
		T)
	       (<VERB? LOOK-DOWN>
		<COND (<HERE? BASEMENT>
		       <ALREADY-AT-BOTTOM>)
		      (T
		       <CANT-SEE-MUCH>)>
		T)
	       (T
		<>)>>

<OBJECT HACKSAW
	(LOC BTABLE)
	(DESC "hacksaw")
	(FLAGS TAKEABLE SHARPENED)
	(SIZE 2)
	(SYNONYM SAW HACKSAW)
	(GENERIC GEN-SAW-F)>

<OBJECT SWISS
	(LOC SPY)
	(DESC "Swiss army knife")
	(FLAGS NODESC TAKEABLE SURFACE SEARCH-ME)
	(SIZE 2)
	(CAPACITY 0)
	(SYNONYM KNIFE BUTTON LEVER BUTTONS)
	(ADJECTIVE SWISS ARMY GENERATOR SAW POWER)
	(ACTION SWISS-F)>

<OBJECT POWER-SAW
	(DESC "power saw")
	(SYNONYM SAW POWER PLUG)
	(ADJECTIVE POWER ELECTRIC CHAIN)
	(FLAGS TAKEABLE)
	(GENERIC GEN-SAW-F)
	(ACTION POWER-F)>

<DEFINE GEN-SAW-F (TBL "AUX" LEN)
	<SET LEN <ZGET .TBL 0>>
	<SET TBL <ZREST .TBL 2>>
	<COND (<INTBL? ,MPLUG .TBL .LEN> ,MPLUG)
	      (<INTBL? ,P-IT-OBJECT .TBL .LEN>
	       ,P-IT-OBJECT)
	      (<AND <INTBL? ,POWER-SAW .TBL .LEN>
		    <VERB? PLUG UNPLUG REPLUG TAKE>>
	       ,POWER-SAW)
	      (ELSE <>)>>

<DEFINE PLAYER-CUT-DOOR ("OPT" (SILENT? <>))
	<COND (<IS? ,JDOOR ,OPENED>
	       <COND (<F? .SILENT?> <TELL "The door is already destroyed.">)>
	       <ZCRLF>)
	      (ELSE
	       <TELL "You find you can run "
		     THE ,POWER-SAW
		     " but the logistics are such that you can't cut the door and run " THE ,GENERATOR ,PERIOD>)>>

<DEFINE POWER-F ()
	<COND (<VERB? CUT>
	       <COND (<AND <IS? ,POWER-SAW ,SEEN>
			   <IS? ,GENERATOR ,SEEN>>
		      <COND (<PRSO? JDOOR>
			     <PLAYER-CUT-DOOR>)
			    (<PRSI? SPY>
			     <TELL "This isn't ">
			     <ITALICIZE "The Bureaucratic Power Saw Massacre">
			     <TELL ,PCR>)
			    (ELSE
			     <TELL "That would just be a waste of time." CR>)>)
		     (ELSE
		      <TELL "The saw has no power and does not cut anything." CR>)>)
	      (<VERB? PLUG>
	       <COND (<AND <F? ,PRSI>
			   <META-IN? ,GENERATOR ,HERE>>
		      <SETG PRSI ,GENERATOR>
		      <TELL "[into " THE ,GENERATOR ,BRACKET>)>
	       <COND (<F? ,PRSI>
		      <TELL "You have to plug " THEO " into something." CR>)
		     (<==? ,PRSI ,GENERATOR>
		      <COND (<NOT <IS? ,POWER-SAW ,SEEN>>
			     <TELL "You plug " THE ,POWER-SAW " into "
				   THE ,GENERATOR>
			     <COND (<IS? ,GENERATOR ,SEEN>
				    <TELL " and you see a spark" ,PERIOD>
				    <COND (<IN? ,POWER-SAW ,PLAYER>
					   <COND (<NOT <IS? ,JDOOR ,OPENED>>
						  <ZCRLF>
						  <PLAYER-CUT-DOOR T>)>)>)
				   (ELSE <TELL ,PERIOD>)>
			     <MAKE ,POWER-SAW ,SEEN>)
			    (ELSE
			     <ITS-ALREADY "connected">)>)
		     (T
		      <WASTE-OF-TIME>)>)
	      (<VERB? UNPLUG>
	       <COND (<F? <IS? ,PRSO ,SEEN>>
		      <TELL "It's not plugged in">)
		     (<OR <ZERO? ,PRSI> <PRSI? GENERATOR>>
		      <UNMAKE ,PRSO ,SEEN>
		      <TELL "You unplug " THEO>)
		     (ELSE
		      <TELL "It's not plugged into that">)>
	       <TELL ,PERIOD>)
	      (<VERB? TAKE>
	       <COND (<AND <IS? ,POWER-SAW ,SEEN>
			   <IS? ,GENERATOR ,SEEN>
			   <NOT <IS? ,JDOOR ,OPENED>>>
		      <MOVE ,POWER-SAW ,PLAYER>
		      <PLAYER-CUT-DOOR>)
		     (ELSE <>)>)
	      (<VERB? EXAMINE>
	       <TELL ,THIS-IS "an electric " D ,PRSO ", with a bizarre plug that won't fit standard household outlets">
	       <COND (<IS? ,PRSO ,SEEN>
		      <TELL ". It's connected to " THE ,GENERATOR>)>
	       <TELL ,PERIOD>
	       T)
	      (<VERB? LAMP-ON LAMP-OFF>
	       <TELL "There doesn't seem to be a switch.">
	       <COND (<AND <VERB? LAMP-ON> <NOT <IS? ,PRSO ,SEEN>>>
		      <TELL " Besides, it's not plugged in.">)>
	       <ZCRLF>)
	      (ELSE <>)>>

<OBJECT GENERATOR
	(DESC "portable foot-powered generator")
	(SYNONYM GENERATOR)
	(ADJECTIVE PORTABLE TAKEABLE FOOT POWERED FOOT-POWERED)
	(FLAGS TAKEABLE VEHBIT)
	(ACTION GEN-F)>

<DEFINE GEN-F ()
	<COND (<VERB? EXAMINE LOOK-ON>
	       <TELL CTHE ,GENERATOR " resembles an exercise bicycle except that the mechanism is such that using it not only provides exercise but also produces electricity. It was invented by Martin Moeller. Martin never had the willpower to exercise and he loved watching television. He invented the foot-powered generator and connected his television to it. This way he couldn't watch TV without exercising." CR>)   
	      (<VERB? SIT CLIMB-ON RIDE>
	       <COND (<IS? ,GENERATOR ,SEEN>
		      <TELL "You are already on it." CR>)
		     (ELSE
		      <TELL "You sit on " THE ,GENERATOR
			    " and start pedalling." CR>
		      <MAKE ,GENERATOR ,SEEN>
		      <MAKE ,GENERATOR ,NODESC>
		      <COND (<IS? ,POWER-SAW ,SEEN>
			     <COND (<IN? ,POWER-SAW ,SPY>
				    <TELL CTHE ,SPY
					  " starts the saw, cuts the door open and drops "
					  THE ,POWER-SAW ". You get off "
					  THE ,GENERATOR ,PERIOD>
				    <MAKE ,JDOOR ,OPENED>
				    <UNMAKE ,GENERATOR ,SEEN>
				    <UNMAKE ,GENERATOR ,NODESC>
				    <MOVE ,POWER-SAW ,JAIL>
				    <QUEUE I-SPY-LEAVES 3>)>)>)>
	       T)
	      (<OR <EXITING?> <VERB? GET-OFF>>
	       <COND (<IS? ,GENERATOR ,SEEN>
		      <TELL "You stop pedalling and get off " THE ,GENERATOR
			    ,PERIOD>
		      <UNMAKE ,GENERATOR ,SEEN>
		      <UNMAKE ,GENERATOR ,NODESC>)
		     (ELSE
		      <TELL "You're not on " THE ,GENERATOR ,PERIOD>)>)
	      (<VERB? USE>
	       <COND (<IS? ,GENERATOR ,SEEN>
		      <YOURE-ALREADY "doing that">)
		     (ELSE
		      <TELL "You're not in the right position to use "
			    THE ,GENERATOR ,PERIOD>)>)
	      (<VERB? LAMP-ON LAMP-OFF>
	       <TELL CTHEO " has no on-off switch. About all you can do is ride
it like a bicycle." CR>)
	      (<VERB? TAKE>
	       <TELL "Actually, \"portable\" has to be taken with a grain of salt. " CTHE ,GENERATOR " is too heavy." CR>)>>

<DEFINE I-SPY-LEAVES ("AUX" (SL <LOC ,SPY>) (PL <LOC ,PLAYER>))
	<COND (<==? .SL ,JAIL>
	       <COND (<==? .PL ,JAIL>
		      <TELL CR CTHE ,SPY " says \"I'm getting outa here!\" and leaves the gaol." CR>)
		     (<==? .PL ,BASEMENT>
		      <TELL CR CTHE ,SPY " follows you." CR>)>
	       <MOVE ,SPY ,BASEMENT>
	       <QUEUE I-SPY-LEAVES>)
	      (<==? .SL ,BASEMENT>
	       <COND (<==? .PL ,BASEMENT>
		      <TELL CR CTHE ,SPY " climbs the stairs." CR>)
		     (<==? .PL ,IN-FORT>
		      <TELL CR CTHE ,SPY " follows you." CR>
		      <DEQUEUE I-SPY-LEAVES>
		      <QUEUE I-SPY-ESCAPES 1>)>
	       <MOVE ,SPY ,IN-FORT>)
	      (<==? .SL ,IN-FORT>
	       <COND (<==? .PL ,IN-FORT>
		      <TELL CR CTHE ,SPY " leaves with " THE ,THE-PARANOID " in hot pursuit." CR>
		      <ZREMOVE ,SPY>
		      <ZREMOVE ,THE-PARANOID>
		      <DEQUEUE I-SPY-LEAVES>)
		     (ELSE
		      <ZREMOVE ,SPY>
		      <ZREMOVE ,THE-PARANOID>
		      <DEQUEUE I-SPY-LEAVES>)>)>>

<DEFINE I-SPY-ESCAPES ()
	<COND (<IN? ,PLAYER ,IN-FORT>
	       <ZREMOVE ,SPY>
	       <TELL CR CTHE ,SPY " runs away leaving you and " THE
		     ,THE-PARANOID " alone." CR>
	       <QUEUE I-P-KILLS-YOU 1>)>>

<DEFINE I-P-KILLS-YOU ()
	<COND (<IN? ,PLAYER ,IN-FORT>
	       <TELL CR CTHE ,THE-PARANOID " assumes you are out to get him (which you probably are) and kills you. Of course, everyone ">
	       <ITALICIZE "is">
	       <TELL " out to get him, so it doesn't help him much. As for you, maybe everyone is out to get you as well.">
	       <JIGS-UP>)>>

<DEFINE SWISS-F SWISS ()
	<COND (<NOUN-USED? ,W?BUTTON ,W?BUTTONS ,W?LEVER>
	       <COND (<VERB? PUSH PUSH-TO TURN PULL MOVE>
		      <COND (<AND <VERB? PUSH-TO>
				  <N==? ,PRSI ,SWISS>>
			     <RETURN <> .SWISS>)>
		      <COND
		       (<IN? ,SWISS ,WINNER>
			<COND (<NOUN-USED? ,W?BUTTON ,W?BUTTONS>
			       <COND (<ADJ-USED? ,W?GENERATOR>
				      <CANT-SEE-ANY-STR "any generator button">
				      ,FATAL-VALUE)
				     (<F? <LOC ,POWER-SAW>>
				      <TELL CTHE ,SWISS
					    " ejects a " D ,POWER-SAW "." CR>
				      <MOVE ,POWER-SAW ,HERE>)
				     (ELSE
				      <TELL "Nothing happens." CR>)>)
			      (<ADJ-USED? ,W?POWER ,W?SAW>
			       <CANT-SEE-ANY-STR "any saw lever">
			       ,FATAL-VALUE)
			      (<F? <LOC ,GENERATOR>>
			       <TELL CTHE ,SWISS " ejects a " D ,GENERATOR
				     "." CR>
			       <MOVE ,GENERATOR ,HERE>)
			      (ELSE
			       <TELL "Nothing happens." CR>)>)
		       (ELSE
			<TELL "You aren't holding " THE ,SWISS ,PERIOD>)>)
		     (<VERB? TAKE>
		      <TELL "Get real. " ,CANT "really think that would do
any good." CR>)>)
	      (<VERB? EXAMINE LOOK-ON>
	       <TELL ,THIS-IS
"one of those multi-function Swiss army knives. It appears to have all of the usual blades, screwdrivers, bottle openers, hair dryers and food processors one associates with such devices. In addition, there's a button marked "
		     ITAL "POWER SAW" " and a lever marked "
		     ITAL "GENERATOR" ,PERIOD>
	       T)
	      (<VERB? OPEN>
	       <COND (<IS? ,SWISS ,SHARPENED>
		      <ALREADY-OPEN>)
		     (ELSE
		      <TELL "Only one of the knife blades seems to work. You open it.">
		      <MAKE ,SWISS ,SHARPENED>)>
	       <ZCRLF>
	       T)
	      (<VERB? CLOSE>
	       <COND (<IS? ,SWISS ,SHARPENED>
		      <TELL "You push the knife blade back into the knife.">
		      <UNMAKE ,SWISS ,SHARPENED>)
		     (ELSE
		      <TELL "It's not open.">)>
	       <ZCRLF>
	       T)>>

<DEFINE IN-FORT-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<==? .CONTEXT ,M-EXIT>
		<COND (<==? ,GOTO-LOC ,JAIL> <>)
		      (<EQUAL? ,P-WALK-DIR ,P?NORTH ,P?OUT>
		       <COND (<IN? ,THE-PARANOID ,IN-FORT>
			      <TELL CTHE ,THE-PARANOID " blocks your way." CR>
			      T)
			     (ELSE
			      <UNMAKE ,BWGATE ,OPENED>
			      <MAKE ,BWGATE ,LOCKED>
			      <TELL "As you leave the house, it puts on
a very impressive display, shutting itself up after you. Finally, you pass
through the gate, which rattles shut behind you" ,PCR>
			      <>)>)
		      (<EQUAL? ,P-WALK-DIR ,P?DOWN>
		       <COND (<IN? ,THE-PARANOID ,IN-FORT>
			      <TELL CTHE ,THE-PARANOID " blocks your way." CR>
			      T)
			     (T <>)>)
		      (T <>)>)
	       (<AND <NOT <IS? ,JDOOR ,OPENED>> <EQUAL? .CONTEXT ,M-ENTERED>>
		;<QUEUE I-SPY-FOLLOW 2>
		<DISPLAY-PLACE>
		<PARANOID-IS-ANGRY>)
	       (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL "You're in the foyer of " THE ,CAMHOUSE
". You could try to exit to the north. There is a stairway leading down.
The sophisticated communications and security centre that this place
obviously possesses must be hidden somewhere else, rather like the camera." CR>
		T)
	       (T
		<>)>>

<DEFINE SPY-JIGS-UP ()
  <TELL " I'm afraid we can't allow you to live, since you've learned too
much.\"" CR CR CTHE ,THE-PARANOID " and " THE ,SPY " spend a few minutes
sharpening their numerous knives on you, as an example to others, then
(rather mercifully, in our opinion) shoot you.">
  <JIGS-UP>>

<DEFINE PARANOID-IS-ANGRY ("AUX" WRD T1 T2 T1L T2L AL J K THEQ
			   (QTB ,P-Q) (ATB ,P-A))
	<TELL CR
	      "The paranoid householder stares first at you, then at the
weirdo, with growing confusion and disbelief. He starts to say something,
then stops. He then stops starting to say it and starts. \"How come...\",
he says. Then he stops again. He clearly believes that this whole thing is
part of his paranoia, and then, equally clearly, decides that it doesn't
matter.|
|
\"Right. One of you is an impostor. I'm pretty sure that it's you, ">
	<PRINT-LAST-NAME>
	<TELL ", but, to be sure, I'm going to grill... going to ask you
a few simple questions. Right.\"" CR CR>
	;<TELL CR
	      "The paranoid says, \"Aha! One of you must be an impostor. I think I know how to find out who it is.\" The paranoid and the stranger whisper to each other for some time. Finally the paranoid says to you, \"I think you are the impostor, but I'll give you a chance to prove yourself. Please answer a few questions for me.\"" CR CR>
	<REPEAT ((I 0) (PSCORE 0))
		<COND (<==? .I ,NUM-QA>
		       <COND (<L? .PSCORE ,MIN-SCORE>
			      <TELL CTHE ,THE-PARANOID " says, \"You are obviously an impostor.">
			      <SPY-JIGS-UP>)
			     ;(<==? .PSCORE ,MAX-SCORE>
			       <TELL CTHE ,THE-PARANOID " says, \"Only a spy would know all the answers.">
			       <SPY-JIGS-UP>)
			     (ELSE
			      <TELL CTHE ,THE-PARANOID " says, \"You passed the test. This means that either one of you could be the impostor.\" He presses a button on the wall, and a trap door opens in the floor. Both you and the stranger fall into a gaol below" ,PCR>
			      <MOVE ,SPY ,JAIL>
			      <GOTO ,JAIL>)>
		       <RETURN>)>
		<SET I <+ .I 1>>
		<SET K <ZRANDOM ,NUM-Q>>
		<SET K <- .K 1>>
		<REPEAT ()
			<SET THEQ <ZGET .QTB .K>>
			<COND (<T? .THEQ>
			       <RETURN>)>
			<COND (<==? .K <- ,NUM-Q 1>> <SET K 0>)
			      (ELSE <SET K <+ .K 1>>)>>
		<TELL "\"" .THEQ "\"" CR>
		<SET AL <GET-CABWORD <> <> ,ANS-TABLE>>
		<SET T1 <ZGET .ATB .K>>
		<SET T1L <ZGET .T1 0>>
		<REPEAT ()
			<COND (<L? <SET T1L <- .T1L 1>> 0> <RETURN>)>
			<SET T1 <REST .T1 2>>
			<SET T2 <ZGET .T1 0>>
			<SET T2L <ZGET .T2 0>>
			<COND (<==? .AL .T2L>
			       <SET J 1>
			       <REPEAT ()
				       <COND (<L? <SET T2L <- .T2L 1>> 0>
					      <SET PSCORE <+ .PSCORE 1>>
					      <SET T1L 0>
					      <ZPUT .QTB .K 0>
					      <RETURN>)>
				       <COND (<W-COMP <ZGET .T2 .J>
						      <ZGET ,ANS-TABLE .J>>
					      <SET J <+ .J 1>>)
					     (<AND <==? .T1L 0>
						   <N==? <ZGET .QTB .K> 0>>
					      <ZPUT .QTB .K 0>
					      <TELL "\"Are you sure?\"" CR>
					      <COND (<SAID-YES?
						      "\"Just answer yes or no!\"">
						     <RETURN>)
						    (ELSE
						     <TELL "\"" .THEQ "\"" CR>
						     <SET AL
							  <GET-CABWORD <> <>
								,ANS-TABLE>>
						     <SET T1 <ZGET .ATB .K>>
						     <SET T1L <ZGET .T1 0>>
						     <RETURN>)>)
					     (ELSE <RETURN>)>>)
			      (<AND <==? .T1L 0> <N==? <ZGET .QTB .K> 0>>
			       <ZPUT .QTB .K 0>
			       <TELL "Are you sure?" CR>
			       <COND (<SAID-YES?
				       "Just answer yes or no!">)
				     (ELSE
				      <TELL .THEQ CR>
				      <SET AL
					   <GET-CABWORD <> <>
							,ANS-TABLE>>
				      <SET T1 <ZGET .ATB .K>>
				      <SET T1L <ZGET .T1 0>>)>)>>>>

<DEFINE W-COMP (TB1 INDX
		"AUX" (LNI </ .INDX 256>) (STRT <ANDB .INDX *377*>)
		      (ALN <GETB .TB1 0>) (I 1) (VAL T) C1 C2)
	<COND (<OR <==? .LNI .ALN> <==? .LNI <- .ALN 1>>>
	       <REPEAT ()
		       <COND (<AND <G=? <SET C1 <GETB .TB1 .I>>
					%<ASCII !\A>>
				   <L=? .C1 %<ASCII !\Z>>>
			      <SET C1 <+ .C1 %<- <ASCII !\a> <ASCII !\A>>>>)>
		       <COND (<AND <G=? <SET C2 <GETB ,P-INBUF .STRT>>
					%<ASCII !\A>>
				   <L=? .C2 %<ASCII !\Z>>>
			      <SET C2 <+ .C2 %<- <ASCII !\a> <ASCII !\A>>>>)>
		       <COND (<N==? .C1 .C2>
			      <SET VAL <>>
			      <RETURN>)>
		       <COND (<G? <SET I <+ .I 1>> .LNI>
			      <COND (<AND <N==? .LNI .ALN>
					  <N==? <GETB .TB1 .I> %<ASCII !\S>>>
				     <SET VAL <>>)>
			      <RETURN>)>
		       <SET STRT <+ .STRT 1>>>
	       .VAL)
	      (ELSE <>)>>

<OBJECT CAMHOUSE
	(LOC LOCAL-GLOBALS)
	(DESC "camouflaged house")
	(FLAGS NODESC)
	(SYNONYM HOUSE HOME BUILDING)
	(ADJECTIVE CAMOUFLAGED GREEN BROWN NEIGHBOR\'S)
	(ACTION CAMHOUSE-F)>

<DEFINE CAMHOUSE-F ()
	 <COND (<TOUCHING?>		    
		<CANT-FROM-HERE>
		T)
	       (<THIS-PRSI?>
		<>)
	       (<VERB? EXAMINE LOOK-ON>
		<TELL 
"The house is painted with broad splashes of green and brown, like an army lorry." CR>
		T)
	       (<ENTERING?>
		<COND (<HERE? OUTSIDE-FARM>
		       <DO-WALK ,P?WEST>)
		      (<HERE? OUTSIDE-FORT>
		       <DO-WALK ,P?SOUTH>)
		      (T
		       <DO-WALK ,P?EAST>)>)
	       (T
		<>)>>
		
<OBJECT INCIDENT
	(LOC GLOBAL-OBJECTS)
	(DESC "that")
	(FLAGS NODESC NOARTICLE LIVING PERSON)
	(SYNONYM ACTUALLY)
	(ACTION INCIDENT-F)>

<OBJECT UNFORTUN
	(LOC GLOBAL-OBJECTS)
	(DESC "that")
	(FLAGS NODESC NOARTICLE LIVING PERSON)
	(SYNONYM UNFORTUNATELY)
	(ACTION UNFORTUN-F)>

"INCIDENTALLY, INFOR PRINCESS DI ABOUT THE WIZARD OF OZ."

<DEFINE INCIDENT-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<VERB? TELL>
		<COND (<COMP-WORDS-FROM-INBUF ,INCI-TBL
					      2>
		       <COND (<SAID-INC-TO-SPY?> T)
			     (<QUEUED? I-INTERCOM> <INCIDENT-OK>)
			     (T
			      <SAID-CRAZY>)>)
		      (<F? ,COMP-WORD-FATAL?>
		       <COND (<F? <BOGUS-PASSWORD?>>
			      <REFERRING>)>)>)
	       (T
		<REFERRING>)>
	 <PCLEAR>
	 ,FATAL-VALUE>

<DEFINE BOGUS-PASSWORD? ()
  <COND (<AND <QUEUED? I-SPY> <L? <SPY-TIMER> 4>>
	 <SPY-CONFUSED "I thought it was something else">
	 T)
	(T
	 <CHECK-FOR-PARANOID T>)>>

<DEFINE SAID-INC-TO-SPY? ("OPT" (FORCE? <>))
  <COND (<OR .FORCE?
	     <AND <QUEUED? I-SPY> <L? <SPY-TIMER> 4>>>
	 <SPY-CONFUSED "I thought I was supposed to say that">)>>

<DEFINE CHECK-FOR-PARANOID CFP ("OPT" (BAD? <>) "AUX" CNT)
	<COND (<T? .BAD?> T)
	      (<F? <PICK-MESSAGE 0>>
	       <COND (,COMP-WORD-FATAL?
		      <PCLEAR>
		      <RETURN ,FATAL-VALUE .CFP>)>)>
	<COND (<F? .BAD?> <SETG P-ALT-CONT ,P-CONT>)>
	<COND (<AND <IN? ,PLAYER ,OUTSIDE-FORT>
		    <==? ,CURRENT-MESSAGE ,INCI-MESSAGE>
		    <F? .BAD?>>
	       <INCIDENT-OK>
	       <PCLEAR>
	       ,FATAL-VALUE)
	      (<IN? ,PLAYER ,OUTSIDE-FORT>
	       <COND (<QUEUED? I-INTERCOM>
		      <TELL "The voice says angrily, \"You can do better than that.\"" CR>
		      <COND (<IS? ,INTERCOM ,TOUCHED>
			     <COM-OFF>)
			    (ELSE <SOMETHING-SAID T>)>)
		     (ELSE
		      <TELL "The intercom is off so no one hears you." CR>)>
	       <PCLEAR>
	       ,FATAL-VALUE)
	      (<T? .BAD?> <>)
	      (<==? ,CURRENT-MESSAGE ,UNFO-MESSAGE>
	       <COND (<F? <SAID-UNF-TO-SPY?>>
		      <SAID-CRAZY>)>
	       <PCLEAR>
	       ,FATAL-VALUE)
	      (<T? ,CURRENT-MESSAGE>
	       <SAID-CRAZY>)
	      (ELSE <>)>>

<DEFINE SAID-CRAZY SC ("OPT" (NO-PERS? <>) "AUX" CNT (PERS <>))
  <PCLEAR>
  <COND (<T? .NO-PERS?> T)
	(<SET PERS <ANYONE-HERE?>>
	 <SETG CURRENT-OZ-VICTIM .PERS>
	 <COND (<==? <PERFORM ,V?TELL .PERS> ,FATAL-VALUE>
		<RETURN ,FATAL-VALUE .SC>)>)>
  <SET CNT <CRAZY-COUNT>>
  <TELL <ZGET ,CRAZIES .CNT>>
  <CRAZY-COUNT <- .CNT 1>>
  <COND (<==? .CNT 0>
	 <JIGS-UP>)
	(T
	 <ZCRLF>)>
  ,FATAL-VALUE>

<DEFINE INCIDENT-OK ()
	<COND (<NOT <IN? ,PLAYER ,OUTSIDE-FORT>>
	       <TELL "Good for them" ,PERIOD>)
	      (<F? <QUEUED? I-INTERCOM>>
	       <SAID-CRAZY T>)
	      (<NOT <IS? ,INCIDENT ,TOUCHED>>
	       <TELL CTHE ,INTERCOM
		     " is silent for a moment. \"I dunno,\" says the voice. \"I don't like the way you said that. Sounds like you're just guessing.\"" CR>
	       <UPDATE-BP 5>
	       <ZCRLF>
	       <COM-OFF>
	       T)
	      (T
	       <MAKE ,INCIDENT ,SEEN>
	       <COM-OFF>
	       <UNMAKE ,BWGATE ,LOCKED>
	       <MAKE ,BWGATE ,OPENED>		
	       <MOVE ,SPY ,IN-FORT>
	       <TELL CR 
		     "Nothing happens for a long moment. Then various rumbles
and clatters herald the house letting down its defences, one by one. Finally,
the gate swings open." CR>
	       T)>>

<MSETG UNFO-MESSAGE 1>
<MSETG INCI-MESSAGE 2>

<DEFINE PICK-MESSAGE (RST)
  <COND (<T? ,CURRENT-MESSAGE> T)
	(<COMP-WORDS-FROM-INBUF ,UNFO-TBL .RST>
	 <SETG CURRENT-MESSAGE ,UNFO-MESSAGE>)
	(<F? ,COMP-WORD-FATAL?>
	 <COND (<COMP-WORDS-FROM-INBUF ,INCI-TBL .RST>
		<SETG CURRENT-MESSAGE ,INCI-MESSAGE>)>)>
  ,CURRENT-MESSAGE>

<DEFINE COMP-WORDS-FROM-INBUF CWFI (TBL RST "AUX" BUF CNT TLEN OCNT WHICH)
	<COND (<==? .TBL ,UNFO-TBL> <SET WHICH ,UNFO-MESSAGE>)
	      (T <SET WHICH ,INCI-MESSAGE>)>
	<COND (<F? ,P-CONT> <RETURN <> .CWFI>)>
	<SET BUF <ZREST ,P-LEXV <* 2 ,P-CONT>>>
	<SET CNT <GETB ,P-LEXV ,P-LEXWORDS>>
	<SET OCNT .CNT>
	<SET TLEN <- <ZGET .TBL 0> .RST>>
	<SET TBL <ZREST .TBL <* <+ 1 .RST> 2>>>
	<SETG COMP-WORD-FATAL? <>>
	<COND
	 (<G=? .CNT .TLEN>
	  ; "Have to have enough words..."
	  <REPEAT (WRD)
	    <COND (<0? .CNT>
		   ;"Out of input words, so if not out of table words we lost."
		   <COND (<L=? .TLEN 0>
			  <SETG CURRENT-MESSAGE .WHICH>
			  <RETURN T .CWFI>)>
		   <RETURN <> .CWFI>)>
	    <COND (<F? <SET WRD <ZGET .BUF 0>>>
		   <UNKNOWN-WORD <+ ,P-CONT <* ,P-LEXELEN <- .OCNT .CNT>>>>
		   ; "Unknown word in buffer, punt it"
		   <SETG COMP-WORD-FATAL? T>
		   <RETURN <> .CWFI>)>
	    <COND (<==? .WRD ,W?QUOTE>
		   <SET CNT <- .CNT 1>>
		   <SET BUF <ZREST .BUF <* 2 ,P-LEXELEN>>>
		   <AGAIN>)
		  (<N==? .WRD <ZGET .TBL 0>>
		   <COND (<AND <L=? .CNT 2> <==? .WRD ,W?PERIOD>>
			  T)
			 (<OR <N==? .WRD ,W?THEN>
			      <N==? <ZGET .TBL 0> ,W?COMMA>>
			  <RETURN <> .CWFI>)>)>
	    <SET CNT <- .CNT 1>>
	    <SET TLEN <- .TLEN 1>>
	    <SET BUF <ZREST .BUF <* 2 ,P-LEXELEN>>>
	    <SET TBL <ZREST .TBL 2>>>)>>

 
"UNFORTUNATELY, THERE'S A RADIO CONNECTED TO MY BRAIN."

<DEFINE SAID-UNF-TO-SPY? ("OPT" (FORCE? <>))
  <COND (<OR <T? .FORCE?>
	     <AND <QUEUED? I-SPY> <L? <SPY-TIMER> 4>>>
	 <COND (<==? <USERPW> ,NO-PW-SAID>
		<USERPW ,USER-PW-SAID>
		<TELL CTHE ,SPY " consults some notes written on his shirt cuff and shows a look of understanding." CR>)
	       (T
		<SPY-CONFUSED
		 "I didn't think you were supposed to say that now">)>)>>

<DEFINE SPY-CONFUSED (STR)
  <TELL CTHE ,SPY " looks very confused and says, \"Oh dear, I do get these passwords confused. " .STR ".\"" CR>>

<DEFINE UNFORTUN-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<VERB? TELL>
		<COND (<COMP-WORDS-FROM-INBUF ,UNFO-TBL 2>
		       <COND (<SAID-UNF-TO-SPY?> T)
			     (T
			      <SAID-CRAZY>)>)
		      (<F? ,COMP-WORD-FATAL?>
		       <COND (<F? <BOGUS-PASSWORD?>>
			      <REFERRING>)>)>)
	       (T
		<REFERRING>)>
	 <PCLEAR>
	 ,FATAL-VALUE>

<VOC "CONNECTED" ADJ>
<VOC "RADIO" OBJECT>
<VOC "MY" ADJ>
<VOC "BRAIN" OBJECT>
<VOC "BBC" OBJECT>

;<OBJECT OZ
	(LOC OUTSIDE-FORT)
	(DESC "that")
	(FLAGS NODESC NOARTICLE)
	(SYNONYM BBC LONDON CONTROL)
	(ADJECTIVE CONTROLLING)
	(ACTION OZ-F)>

;<DEFINE OZ-F ()
	 <COND (<AND <VERB? TELL-ABOUT>
		     <PRSI? PRSO>
		     <EQUAL? ,WINNER ,INCIDENT>>
		<>)
	       (T
		<PCLEAR>
		<REFERRING>
		,FATAL-VALUE)>>

<VOC "THERE'S" <>>
<VOC "CONNECTED" ADJ>
<VOC "MY" ADJ>
<VOC "OUR" ADJ>
<VOC "CONTROLLING" ADJ>
<VOC "RADIO" OBJECT>
<VOC "CONTROLLING" OBJECT>
<VOC "LONDON" OBJECT>

;<OBJECT RADIO
	(LOC IN-FARM)
	(DESC "that")
	(FLAGS NODESC NOARTICLE TAKEABLE)
	(SYNONYM RADIO BRAIN)
	(ADJECTIVE CONNECTED MY)
	(ACTION SNUFF-F)>

;<DEFINE SNUFF-F ()
	 <COND (<AND <VERB? TELL-ABOUT>
		     <PRSI? PRSO>
		     <EQUAL? ,WINNER ,UNFORTUN>>
		<>)
	       (T
		<PCLEAR>
		<REFERRING>
		,FATAL-VALUE)>>

<OBJECT MACHGUN
	(LOC SPY)
	(DESC "machine gun")
	(FLAGS TRYTAKE NOALL)
	(SYNONYM GUN MACHINE)
	(ADJECTIVE MACHINE)
	(ACTION MACHGUN-F)>

<DEFINE MACHGUN-F ()
	 <COND (<THIS-PRSI?>
		<>)
	       (<VERB? EXAMINE>
		<TELL "It is probably unwise to examine a machine gun that is held by such a character." CR>
		T)
	       (T
		<>)>>

<OBJECT INTERCOM
	(LOC OUTSIDE-FORT)
	(DESC "intercom")
	(FLAGS VOWEL NODESC TRYTAKE NOALL LIVING PERSON)
	(SYNONYM INTERCOM SPEAKER LOUDSPEAKER VOICE SOUND BOX)
	(ADJECTIVE INTERCOM)
	(ACTION INTERCOM-F)>

<DEFINE INTERCOM-F ("OPTIONAL" (CONTEXT <>) "AUX" (IOK? T))
	 <COND (<OR <F? <QUEUED? I-INTERCOM>>
		    <T? ,END-GAME?>>
		<SET IOK? <>>)>
	 <COND (<==? .CONTEXT ,M-WINNER>
		<COND (<NOT .IOK?>
		       <TELL CTHE ,INTERCOM " seems to be switched off." CR>
		       T)
		      (<VERB? HELLO>
		       <SETG WINNER ,PLAYER>
		       <PERFORM ,V?HELLO ,INTERCOM>
		       T)
		      (T <>)>)
	       (<T? .CONTEXT> <>)
	       (<THIS-PRSI?>
		<COND (<VERB? SHOW GIVE>
		       <COND (.IOK?
			      <TELL "\"If I wanted to look at " A ,PRSO
				    ", I'd go out and get one,\" crackles "
				    THE ,INTERCOM ,PERIOD>)
			     (T
			      <TELL "There doesn't seem to be anyone there."
				    CR>)>)
		      (T <>)>)
	       (<MOVING?>
		<FIRMLY-ATTACHED ,PRSO ,BWGATE>
		T)
	       (<AND <VERB? LISTEN>
		     .IOK?>
		<I-INTERCOM <>>
		,FATAL-VALUE)
	       (<VERB? TELL>
		<COND (<AND .IOK? <PICK-MESSAGE 0>>
		       <COND (<==? ,CURRENT-MESSAGE ,INCI-MESSAGE>
			      <INCIDENT-OK>)
			     (T
			      <TELL
			       "\"Don't repeat what I say!\" says the voice.\""
			       CR>)>)
		      (<OR <NOT .IOK?> <F? ,COMP-WORD-FATAL?>>
		       <TELL "The intercom is ignoring you." CR>)>
		<PCLEAR>
		,FATAL-VALUE)
	       (<NOT .IOK?>
		<TELL "The intercom seems to be switched off." CR>)
	       (<VERB? HELLO>
		<TELL CTHEO " voice clears its throat. \"">
		<ITALICIZE "Ahem">
		<TELL ". " ,PSTRING "\"." CR>)
	       (T
		<>)>>

<OBJECT BWGATE
	(LOC LOCAL-GLOBALS)
	(DESC "gate")
	(FLAGS NODESC DOORLIKE OPENABLE LOCKED)
	(SYNONYM GATE GATEWAY FENCE WALL DOOR)
	(GENERIC GDOOR-F)
	(ACTION BWGATE-F)>

<DEFINE BWGATE-F ()
	 <COND (<THIS-PRSI?>
		<COND (<VERB? THROW-OVER>
		       <ZREMOVE ,PRSO>
		       <SETG P-IT-OBJECT ,NOT-HERE-OBJECT>
		       <TELL "You heave " THEO " over the top of the wall.
We assume it got eaten by a crocodile, but we can't be sure." CR>
		       T)
		      (<VERB? PUT PUT-BEHIND PUT-UNDER>
		       <TELL "Sorry, you can't do that." CR>)
		      (<VERB? PUT-ON>
		       <NO-GOOD-SURFACE>
		       T)
		      (T <>)>)
	       (<VERB? EXAMINE>
		<COND (<NOUN-USED? ,W?GATE>
		       <TELL "It's ">
		       <COND (<IS? ,PRSO ,OPENED>
			      <TELL "a formerly impenetrable, but now open, ">)
			     (T
			      <TELL "an impenetrable closed ">)>
		       <TELL D ,PRSO ,PERIOD>)
		      (T
		       <TELL "What you have here is your basic impenetrable fence.
There's lots of barbed wire, broken glass, bullet holes, and other indications
that you can't get through it." CR>)>)
	       (<ENTERING?>
		<COND (<NOUN-USED? ,W?FENCE ,W?WALL>
		       <TELL "You barely manage to untangle yourself from the
barbed wire before the bullets start flying, but you don't make it through."
			     CR>)
		      (<HERE? OUTSIDE-FORT>
		       <DO-WALK ,P?SOUTH>)
		      (T
		       <DO-WALK ,P?NORTH>)>
		T)
	       (<VERB? CLIMB-OVER>
		<TELL "The barbed wire wouldn't agree with your body." CR>)
	       (<VERB? KNOCK>
		<TELL "The noise you make isn't loud enough to penetrate the house." CR>)
	       (T
		<>)>>

<OBJECT PARAMAIL
	(LOC IN-FORT)
	(DESC "some mail")
	(FLAGS TAKEABLE NOARTICLE READABLE NODESC)
	(SYNONYM MAIL)
	(GENERIC GENERIC-MAIL)
	(MAIL-LETTER -1)
	(ACTION PARAMAIL-F)>

<DEFINE PARAMAIL-F ()
	<COND (<VERB? TAKE>
	       <COND (<AND <LOC ,THE-PARANOID>
			   <IN? ,PARAMAIL <LOC ,THE-PARANOID>>>
		      <TELL "As " THE ,THE-PARANOID " points his machine gun at you, you decide not to take it." CR>
		      <UPDATE-BP 5>)
		     (ELSE <>)>)
	      (<HANDLE-MAIL? ,PARAMAIL> T)
	      (ELSE <>)>>
	       

<OBJECT MAGAZINE
	(DESC "Popular Paranoia magazine")
	(FLAGS TAKEABLE READABLE SURFACE)
	(SIZE 3)
	(SYNONYM ZZZP MAGAZINE PERIODICAL PARANOIA BLURB MAG
	 	 MAIL STICKER ADDRESS)
	(ADJECTIVE POPULAR PARANOIA POSTAL SERVICE ORANGE)
	(MAIL-LETTER 0)
	(GENERIC GENERIC-MAIL)
	(ACTION MAGAZINE-F)>

<DEFINE MAGAZINE-F ()
	 <COND (<NOUN-USED? ,W?STICKER>
		<HANDLE-STICKER>)
	       (<THIS-PRSI?>
		<COND (<VERB? PUT-ON PUT EMPTY-INTO>
		       <WASTE-OF-TIME>
		       T)
		      (T <>)>)
	       (<VERB? EXAMINE LOOK-ON>
		<TELL "It's the latest issue of ">
		<ITALICIZE "Popular Paranoia">
		<TELL " magazine, addressed to ">
		<SAY-STREET-ADDRESS ,OUTSIDE-FORT>
		<TELL 
". A sweepstakes blurb on the cover says, \"You may already have won $1,000,000.00 in gold!!!\" ">
		<SAY-MAIL-LETTER ,PRSO>
		T)
	       (<VERB? OPEN READ>
		<TELL "The major article seems to be a debate about who can be trusted. Both authors agree that no
one who has anything whatsoever to do with computers can be trusted at
all, and most of them are evil little social inadequates who are trying to control us by wrecking our lives." CR>
		T)
	       (T
		<>)>>

<DEFINE I-SPY IS ("OPTIONAL" (CR T) "AUX" X STR STATE)
	 <SET X <SPY-TIMER>>
	 <SET X <- .X 1>>
	 <SPY-TIMER .X>
	 <SET STR ,SSTRING>
	 <SET STATE <USERPW>>
	 <COND (<EQUAL? .X 4>
		<RETURN <> .IS>)
	       (<T? .CR>
		<ZCRLF>)>
	 <COND (<EQUAL? .X 3>
		<SETG P-HIM-OBJECT ,SPY>
		<MOVE ,SPY ,HERE>
		<MAKE ,SPY ,SEEN>
		<TELL 
"A stranger bearing a really rather horrid resemblance to Woody Allen appears in the open doorway. He is carrying a
colossal armoury for one so runty, and his general twitchiness doesn't
help you feel any more secure. Guns, knives, hatchets and bombs dangle
from various straps, belts and D-loops. For some reason, he makes you
feel nervous. He peers around the room uncertainly, then turns to stare at you. \"Ahem,\" he says, shuffling his feet expectantly." CR>
		<RETURN T .IS>)
	       (<EQUAL? .X 2>
		<COND (<EQUAL? .STATE ,USER-PW-SAID>
		       <USERPW ,SPY-PW-SAID>
		       <TELL CTHE ,SPY
" looks you straight in the eye and says, \"" .STR ".\"" CR>
		       <MAKE ,INCIDENT ,TOUCHED>
		       <RETURN T .IS>)
		      (<EQUAL? .STATE ,SPY-PW-SAID>
		       <TELL CTHE ,SPY " starts fingering his machine gun">)
		      (ELSE
		       <TELL CTHE ,SPY " looks as if he is expecting you to say something." CR>)>)
	       (<AND <EQUAL? .X 1> <NOT <EQUAL? .STATE ,SPY-PW-SAID>>>
		<COND (<EQUAL? .STATE ,USER-PW-SAID>
		       <USERPW ,SPY-PW-SAID>
		       <TELL CTHE ,SPY
" seems a little puzzled but says, \"" .STR ".\"" CR>)
		      (ELSE
		       <TELL CTHE ,SPY " appears to be becoming impatient."
			     CR>)>
		<RETURN T .IS>)>
	 <SETG P-HIM-OBJECT ,NOT-HERE-OBJECT>
	 <ZREMOVE ,SPY>
	 <DEQUEUE I-SPY>
	 <TELL "Utterly nonplussed, " THE ,SPY
" glances at the number on the " D ,FARM-DOOR 
". \"Oh, dear,\" he giggles, blushing. \"Wrong address. Never mind.\"">
	 <COND (<EQUAL? .STATE ,SPY-PW-SAID>
		<TELL " But then he mutters, \"Can't trust anyone these days!\"|
|">)
	       (ELSE <TELL "|
|">)>
	<TELL "You watch as he ">
	<COND (<HERE? IN-FARM>
	       <UNMAKE ,FARM-DOOR ,OPENED>
	       <TELL "ducks out " THE ,FARM-DOOR
		     " and closes it behind him." CR>
	       <RETURN T .IS>)>
	<TELL "trots away down the street." CR>
	<RETURN T .IS>>

<MSETG SET-COM-TIMER 4>

<SETG SOMEBODYS-WATCHING? <>>

<OBJECT CAMERA
	(LOC LOCAL-GLOBALS)
	(SYNONYM CAMERA)
	(ADJECTIVE SPY HIDDEN WELL-HIDDEN)
	(DESC "camera")
	(ACTION CAMERA-F)>

<DEFINE CAMERA-F ()
  <COND (<OR <VERB? FIND EXAMINE LOOK-ON LOOK-INSIDE>
	     <TOUCHING?>
	     <MOVING?>
	     <VERB? WAVE-AT>>
	 <TELL "You can't. It's extremely, " ITAL "extremely"
	       " well-hidden." CR>)
	(T <>)>>

<DEFINE I-INTERCOM II ("OPTIONAL" (CR T) "AUX" X STR)
	 <COND (<F? ,SOMEBODYS-WATCHING?>
		<SETG SOMEBODYS-WATCHING? T>
		<COND (<T? .CR>
		       <ZCRLF>)>
		<TELL "The short hairs standing up on the back of your neck
tell you that either (a) a goose has just walked over your grave or (b)
some paranoid individual is spying on you through an extremely well-hidden
camera." CR>
		<RETURN T .II>)
	       (<IS? ,INCIDENT ,SEEN>
		<DEQUEUE I-INTERCOM>
		<RETURN <> .II>)>
	 <COND (<IS? ,INTERCOM ,TOUCHED>
		<COND (<T? .CR> <ZCRLF>)>
		<TELL "\"You again!\" crackles " THE ,INTERCOM
" angrily. \"Thought I told you to scram! No trespassing!\"" CR CR>
		<COM-OFF>
		<RETURN T .II>)>
	 <SET X <COM-TIMER <- <COM-TIMER> 1>>>
	 <SET STR ,PSTRING>
	 <COND (<T? <SOMETHING-SAID>>
		<SOMETHING-SAID <>>
		<RETURN T .II>)>
	 <COND (<T? .CR> <ZCRLF>)>
	 <COND (<EQUAL? .X 3>
		<COND (<IS? ,INTERCOM ,SEEN>
		       <TELL "The voice on " THE ,INTERCOM
			     " crackles to life again">)
		      (T
		       <MAKE ,INTERCOM ,SEEN>
		       <TELL "A gruff voice crackles to life on "
			     THE ,INTERCOM>
		       <MAKE ,FARM-DOOR ,OPENED>
		       <UNMAKE ,OUTSIDE-FARM ,TOUCHED>)>
		<TELL ". \"" .STR ".\"" CR>
		<RETURN T .II>)
	       (<EQUAL? .X 2>
		<TELL CTHE ,INTERCOM " voice clears its throat. \"">
		<ITALICIZE "Ahem">
		<TELL 
". " .STR ".\" After an expectant pause he adds, \"Well?\"" CR>
		<RETURN T .II>)
	       (<EQUAL? .X 1>
		<TELL CTHE ,INTERCOM " voice sighs angrily. \"Look, ">
		<GENDER-PRINT "mister" "lady">
		<TELL ", I ain't got all day. ">
		<ITALICIZE .STR>
		<TELL "! What d'ya say to that?\"" CR>
		<RETURN T .II>)>
	 <MAKE ,INTERCOM ,TOUCHED>
	 <TELL "Another angry sigh from the voice. \"All right, then scram! No trespassing!\"" CR CR>
	 <COM-OFF>
	 <RETURN T .II>> 
	 	 
<DEFINE COM-OFF ()
	 <COM-TIMER ,SET-COM-TIMER>
	 <DEQUEUE I-INTERCOM>
	 <TELL "You hear an electric ">
	 <ITALICIZE "snap">
	 <TELL " as " THE ,INTERCOM " is switched off." CR>>

<MSETG NUM-Q 15>

<MSETG NUM-QA 5>

<MSETG MIN-SCORE 5>

<MSETG MAX-SCORE 5>

<DEFINE PICK-ONE (TBL "AUX" (LEN <ZGET .TBL 0>))
	<ZGET .TBL <ZRANDOM .LEN>>>

<DEFINE CHECK-OZ-ROYALTY (OBJ "OPTIONAL" (RET <>) "AUX" STR)
	<COND (<AND ,CURRENT-OZ-VICTIM <N==? .OBJ ,CURRENT-OZ-VICTIM>> <>)
	      (<NOT <IS? .OBJ ,PERSON>> <>)
	      (<OR ,CURRENT-OZ-VICTIM
		   <PICK-MESSAGE 0>>
	       <SET STR <PICK-ONE ,OZ-ROYS>>
	       <COND (.RET .STR)
		     (ELSE <TELL CTHE .OBJ " says, \"" .STR "\"" CR>)>)
	      (ELSE <>)>>

