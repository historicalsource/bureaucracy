"JET for
			       BUREAUCRACY
	(c) Copyright 1985 Infocom, Inc.  All Rights Reserved."

;"ON-FLIGHT = 1 -> HIJACKED
	      2 -> NO VISA
 	      3 -> PARACHUTE TEAM

 This GLOBAL is set up in AIRPORT, depending on your gate. The ON-FLIGHT will
 determine descriptions of almost everything, as well as what happens on the
 flight.
"

;"The generic airplane"

<GLOBAL A-INIT <>>

<ROOM A-ENTRANCE
      (LOC ROOMS)
      (DESC "Airplane Entrance")
      (EAST TO A-GALLEY)
      (FLAGS AIRPLANEBIT)
      (ACTION A-ENTRANCE-F)>

<ROUTINE A-ENTRANCE-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL "Default description of " D ,HERE "." CR>)
	       (<AND <EQUAL? .RARG ,M-ENTER> <NOT ,A-INIT>>
		<QUEUE I-TERMINAL 0>
		<SETG A-INIT T>
		<INIT-AIRPLANE>
		<RTRUE>)>>

<ROUTINE INIT-AIRPLANE ()
	 <RTRUE>>

<ROOM A-COCKPIT
      (LOC ROOMS)
      (DESC "Cockpit")
      (OUT TO A-GALLEY IF A-COCKPIT-DOOR IS OPEN)
      (SOUTH TO A-GALLEY IF A-COCKPIT-DOOR IS OPEN)
      (FLAGS AIRPLANEBIT)
      (GLOBAL A-COCKPIT-DOOR)
      (ACTION A-COCKPIT-F)>

<OBJECT A-COCKPIT-DOOR
	(LOC LOCAL-GLOBALS)
	(DESC "cockpit door")
	(SYNONYM DOOR)
	(ADJECTIVE COCKPIT)
	(FLAGS DOORBIT)>

<ROUTINE A-COCKPIT-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL "Default description of " D ,HERE "." CR>)>>

<ROOM A-GALLEY
      (LOC ROOMS)
      (DESC "Galley")
      (NORTH TO A-COCKPIT IF A-COCKPIT-DOOR IS OPEN)
      (SOUTH TO A-1)
      (WEST TO A-ENTRANCE)
      (GLOBAL A-COCKPIT-DOOR)
      (ACTION A-GALLEY-F)>

<ROUTINE A-GALLEY-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL "Default description of " D ,HERE "." CR>)>>

<ROOM A-1
      (LOC ROOMS)
      (DESC "Aisle 1")
      (EAST PER A-SEAT-EXIT)
      (WEST PER A-SEAT-EXIT)
      (NORTH TO A-GALLEY)
      (SOUTH TO A-2)
      (FLAGS AIRPLANEBIT)
      (AISLE 1)
      (ACTION A-AISLE-F)>

<ROUTINE A-AISLE-F (RARG "AUX" ST A (CNT 0) (NS 0))
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<SET A <GETP ,HERE ,P?AISLE>>
		<TELL
"You are ">
		<COND (,SEATED?
		       <TELL "in seat " N .A>
		       <PRINTC <+ 64 </ ,SEATED? 1000>>>)
		      (T
		       <TELL "standing in the middle of aisle " N .A>)>
		<TELL ". ">
		<SET ST <SEAT-INFO .A>>
		<REPEAT ()
			;"What about seat you're in?"
			<COND (<G? .CNT 4> <RETURN>)>
			<COND (<0? <GET .ST .CNT>>
			       <COND (<0? .NS>
				      <TELL "Seat ">)
				     (T
				      <TELL " and seat ">)>
			       <SET NS <+ .NS 1>>
			       <TELL N .A>
			       <PRINTC <+ 65 .CNT>>)>
			<SET CNT <+ .CNT 1>>>
		<COND (<0? .NS>
		       <TELL "All of the seats in this aisle are taken.">)
		      (<1? .NS>
		       <TELL " is the only unoccupied one here.">)
		      (T
		       <TELL " are unoccupied.">)>
		<COND (,SEATED?
		       <TELL " The seat pocket in front of you
contains the usual printed materials.">)>
		<CRLF>)>>

<ROUTINE SEAT-INFO (A)
	 <REST ,SEATING-TBL <* <- .A 1> 8>>>

<ROUTINE A-SEAT-EXIT ()
	 <TELL 
"If you want to sit down here, simply indicate the seat you're interested
in (e.g. 13B)." CR>
	 <RFALSE>>

<ROOM A-2
      (LOC ROOMS)
      (DESC "Aisle 2")
      (EAST PER A-SEAT-EXIT)
      (WEST PER A-SEAT-EXIT)
      (NORTH TO A-1)
      (SOUTH TO A-3)
      (FLAGS AIRPLANEBIT)
      (AISLE 2)
      (ACTION A-AISLE-F)>

<ROOM A-3
      (LOC ROOMS)
      (DESC "Aisle 3")
      (EAST PER A-SEAT-EXIT)
      (WEST PER A-SEAT-EXIT)
      (NORTH TO A-2)
      (SOUTH TO A-4)
      (FLAGS AIRPLANEBIT)
      (AISLE 3)
      (ACTION A-AISLE-F)>

<ROOM A-4
      (LOC ROOMS)
      (DESC "Aisle 4")
      (EAST PER A-SEAT-EXIT)
      (WEST PER A-SEAT-EXIT)
      (NORTH TO A-3)
      (SOUTH TO A-5)
      (FLAGS AIRPLANEBIT)
      (AISLE 4)
      (ACTION A-AISLE-F)>

<ROOM A-5
      (LOC ROOMS)
      (DESC "Aisle 5")
      (EAST PER A-SEAT-EXIT)
      (WEST PER A-SEAT-EXIT)
      (NORTH TO A-4)
      (SOUTH TO A-6)
      (FLAGS AIRPLANEBIT)
      (AISLE 5)
      (ACTION A-AISLE-F)>

<ROOM A-6
      (LOC ROOMS)
      (DESC "Aisle 6")
      (EAST PER A-SEAT-EXIT)
      (WEST PER A-SEAT-EXIT)
      (NORTH TO A-5)
      (SOUTH TO A-7)
      (FLAGS AIRPLANEBIT)
      (AISLE 6)
      (ACTION A-AISLE-F)>

<ROOM A-7
      (LOC ROOMS)
      (DESC "Aisle 7")
      (EAST PER A-SEAT-EXIT)
      (WEST PER A-SEAT-EXIT)
      (NORTH TO A-6)
      (SOUTH TO A-8)
      (FLAGS AIRPLANEBIT)
      (AISLE 7)
      (ACTION A-AISLE-F)>

<ROOM A-8
      (LOC ROOMS)
      (DESC "Aisle 8")
      (EAST PER A-SEAT-EXIT)
      (WEST PER A-SEAT-EXIT)
      (NORTH TO A-7)
      (SOUTH TO A-9)
      (FLAGS AIRPLANEBIT)
      (AISLE 8)
      (ACTION A-AISLE-F)>

<ROOM A-9
      (LOC ROOMS)
      (DESC "Aisle 9")
      (EAST PER A-SEAT-EXIT)
      (WEST PER A-SEAT-EXIT)
      (NORTH TO A-8)
      (SOUTH TO A-10)
      (FLAGS AIRPLANEBIT)
      (AISLE 9)
      (ACTION A-AISLE-F)>

<ROOM A-10
      (LOC ROOMS)
      (DESC "Aisle 10")
      (EAST PER A-SEAT-EXIT)
      (WEST PER A-SEAT-EXIT)
      (NORTH TO A-9)
      (SOUTH TO A-11)
      (FLAGS AIRPLANEBIT)
      (AISLE 10)
      (ACTION A-AISLE-F)>

<ROOM A-11
      (LOC ROOMS)
      (DESC "Aisle 11")
      (EAST PER A-SEAT-EXIT)
      (WEST PER A-SEAT-EXIT)
      (NORTH TO A-10)
      (SOUTH TO A-12)
      (FLAGS AIRPLANEBIT)
      (AISLE 11)
      (ACTION A-AISLE-F)>

<ROOM A-12
      (LOC ROOMS)
      (DESC "Aisle 12")
      (EAST PER A-SEAT-EXIT)
      (WEST PER A-SEAT-EXIT)
      (NORTH TO A-11)
      (SOUTH TO A-13)
      (FLAGS AIRPLANEBIT)
      (AISLE 12)
      (ACTION A-AISLE-F)>

<ROOM A-13
      (LOC ROOMS)
      (DESC "Aisle 13")
      (EAST PER A-SEAT-EXIT)
      (WEST PER A-SEAT-EXIT)
      (NORTH TO A-12)
      (SOUTH TO A-14)
      (FLAGS AIRPLANEBIT)
      (AISLE 13)
      (ACTION A-AISLE-F)>

<ROOM A-14
      (LOC ROOMS)
      (DESC "Aisle 14")
      (EAST PER A-SEAT-EXIT)
      (WEST PER A-SEAT-EXIT)
      (NORTH TO A-13)
      (SOUTH TO A-REAR)
      (FLAGS AIRPLANEBIT)
      (AISLE 14)
      (ACTION A-AISLE-F)>

<ROOM A-REAR
      (LOC ROOMS)
      (DESC "Airplane, near Tail")
      (EAST TO A-REAR-E)
      (WEST TO A-REAR-W)
      (NORTH TO A-14)
      (SOUTH TO A-LAVATORY IF A-LAVATORY-DOOR IS OPEN)
      (IN TO A-LAVATORY IF A-LAVATORY-DOOR IS OPEN)
      (FLAGS AIRPLANEBIT)
      (GLOBAL A-LAVATORY-DOOR)
      (ACTION A-REAR-F)>

<ROUTINE A-REAR-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL "Default description of " D ,HERE "." CR>)>>

<ROOM A-LAVATORY
      (LOC ROOMS)
      (DESC "Lavatory")
      (OUT TO A-REAR IF A-LAVATORY-DOOR IS OPEN)
      (NORTH TO A-REAR IF A-LAVATORY-DOOR IS OPEN)
      (FLAGS AIRPLANEBIT)
      (GLOBAL A-LAVATORY-DOOR)
      (ACTION A-LAVATORY-F)>

<ROUTINE A-LAVATORY-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL "Not described yet." CR>)>>

<OBJECT A-LAVATORY-DOOR
	(LOC LOCAL-GLOBALS)
	(DESC "lavatory door")
	(SYNONYM DOOR)
	(ADJECTIVE LAVATORY)
	(FLAGS DOORBIT)
	(ACTION A-LAVATORY-DOOR-F)>

<ROUTINE A-LAVATORY-DOOR-F ()
	 <TELL "Place holder." CR>> 

<ROOM A-REAR-E
      (LOC ROOMS)
      (DESC "East Emergency Exit")
      (WEST TO A-REAR)
      (OUT TO FREE-FALL IF A-EMERGENCY-DOOR IS OPEN)
      (FLAGS AIRPLANEBIT)
      (GLOBAL A-EMERGENCY-DOOR)
      (ACTION A-REAR-EW-F)>

<ROUTINE A-REAR-EW-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL "Default description of " D ,HERE "." CR>)>>

<ROOM A-REAR-W
      (LOC ROOMS)
      (DESC "West Emergency Exit")
      (EAST TO A-REAR)
      (OUT TO FREE-FALL IF A-EMERGENCY-DOOR IS OPEN)
      (FLAGS AIRPLANEBIT)
      (GLOBAL A-EMERGENCY-DOOR)
      (ACTION A-REAR-EW-F)>

<OBJECT A-EMERGENCY-DOOR
	(LOC LOCAL-GLOBALS)
	(DESC "emergency door")
	(SYNONYM DOOR)
	(ADJECTIVE EMERGENCY)
	(FLAGS DOORBIT)>

<OBJECT MOVIE
	(LOC GLOBAL-OBJECTS)
	(DESC "in-flight movie")
	(SYNONYM MOVIE FILM FLICK)
	(ADJECTIVE IN-FLIGHT)
	(ACTION MOVIE-F)>

<ROUTINE MOVIE-F ()
	 <COND (<NOT <FSET? ,HERE ,AIRPLANEBIT>>
		<TELL
"There's certainly no movie around here." CR>)
	       (<VERB? EXAMINE>
		<COND (<EQUAL? ,MOVIE-TIME 0>
		       <TELL
"There's no movie playing at this time." CR>)
		      (T
		       <TELL <GET <GET ,MOVIE-TBL ,ON-FLIGHT>
				  ,MOVIE-TIME> CR>
		       <COND (<EQUAL? ,MOVIE-TIME 5>
			      <SETG MOVIE-TIME -1>
			      <QUEUE I-MOVIE 0>
			      <TELL
"The in-flight movie ends, the lights come up, and the stewardess pulls
up the screen at the front of the plane." CR>
			      <START-AIRPLANE-FUN>)
			     (T
			      <V-WAIT 10 T>)>
		       <RTRUE>)>)>>

<ROUTINE START-AIRPLANE-FUN ()
	 <COND (<EQUAL? ,ON-FLIGHT 1>
		<START-HIJACK>)
	       (<EQUAL? ,ON-FLIGHT 2>
		<START-VISA>)
	       (T
		<START-JUMP>)>>

<ROUTINE START-JUMP () <RTRUE>>

<ROUTINE START-VISA ()
	 <ENABLE <QUEUE I-VISA-MESSAGE 3>>
	 <RTRUE>>

<ROUTINE I-VISA-MESSAGE ()
	 <TELL
"A message comes over the PA system in Zalagasan and then English: \"This
is your Captain speaking. We are making our initial descent into Bananareeve.
At this time, our cabin attendants will be passing out Immigration Forms which
must be completed prior to landing. Thank you for your cooperation and we hope
you have enjoyed your flight thus far.\"" CR>
	 <ENABLE <QUEUE I-VISA-1 3>>
	 <RTRUE>>

<ROUTINE I-VISA-1 ()
	 <TELL
"A stewardess approaches you and hands you a form." CR>
	 <MOVE ,IMMIGRATION-FORM ,WINNER>
	 <ENABLE <QUEUE I-VISA-2 10>>
	 <RTRUE>>

<ROUTINE I-VISA-2 ()
	 <TELL
"The stewardess returns and asks for your completed immigration form." CR>
	 <MOVE ,A-ATTENDANT ,HERE>
	 <ENABLE <QUEUE I-VISA-3 -1>>
	 <PUTP ,PROTAGONIST ,P?ACTION ,A-FORM-WAIT>
	 <RTRUE>>

<GLOBAL FORM-WAIT 0>

<GLOBAL VISA-WAIT 0>

<ROUTINE ASK-TO-LEAVE ()
	 <TELL CR
"\"I'm sorry, sir, but I'm going to have to ask you to leave.\" She
motions to the purser who motions you toward the back of the plane." CR>
	 <QUEUE I-VISA-3 0>
	 <PUTP ,PROTAGONIST ,P?ACTION ,WALK-THE-PLANK>
	 <ENABLE <QUEUE I-VISA-4 -1>>
	 <RTRUE>>

<ROUTINE I-VISA-4 ()
	 <COND (<EQUAL? ,HERE ,A-REAR-W ,A-REAR-E>
		<TELL CR
"The purser politely places a parachute on your back and, as he lifts
the large red handle on the emergency exit, those nice plastic oxygen
masks you've seen demonstrated hundreds of times come out. The captain
comes on the PA, explaining \"Ladies and Gentlemen, one of our passengers
is deplaining at this time, so we would suggest that you use the oxygen
masks until we can again close the rear door. Thank you.\"|
|
A rush of cold air fills the cabin as the door opens. As the purser
politely but firmly ejects you from the plane, he speaks: \"It has
been our pleasure serving you today, and if your future plans call for
air travel to Bananareeve, we hope you will again think of Air
Zalagasa.\" You start your fall into the African night...." CR CR>
		<PUTP ,PROTAGONIST ,P?ACTION 0>
		<GOTO ,A-MIDAIR>
		<QUEUE I-VISA 0>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROOM A-MIDAIR
      (LOC ROOMS)
      (DESC "Midair")
      (DOWN SORRY "Inevitable.")
      (ACTION A-MIDAIR-F)>

<OBJECT AIRPLANE-EXIT
	(LOC A-MIDAIR)
	(DESC "emergency exit")
	(SYNONYM EXIT DOOR WINDOW)
	(ADJECTIVE AIRPLANE EMERGENCY)
	(FLAGS NDESCBIT)
	(ACTION AIRPLANE-EXIT-F)>

<ROUTINE AIRPLANE-EXIT-F ()
	 <COND (,AT-AIRPLANE-DOOR?
		<COND (<VERB? OPEN UNLOCK>
		       <TELL
"There's no way to open it from this side when it's locked from the
inside." CR>)
		      (<VERB? KNOCK>
		       <TELL
"After a few moments violent knocking, the stewardess turns around, revealing
a strange, suspicious-looking man carrying a yellow walkie-talkie behind her.
She seems terribly pleased to be able to serve you yet again. She cheerfully
opens the door, inquires \"May I help you?\", and thoughtfully waves goodbye
as you once again plunge headlong into the night..." CR CR>
		       <SETG AT-AIRPLANE-DOOR? <>>
		       <SETG FLY-HACK? <>>
		       <V-LOOK>
		       <RTRUE>)
		      (<VERB? EXAMINE>
		       <TELL
"Your appreciation of doors is not exceptionally high at present, but you
judge it nonetheless to be quite a servicable one." CR>)>)
	       (,FLY-HACK?
		<TELL
"Unfortunately for you, you can't possibly get near it from here." CR>)
	       (T
		<TELL
"Sadly, you've left the airplane and it's various means of ingress and
egress thousands of feet behind." CR>)>> 

<GLOBAL MIDAIR-COUNT 0>

<GLOBAL FLY-HACK? <>>

<GLOBAL CHUTE-DEPLOYED? <>>

<GLOBAL AT-AIRPLANE-DOOR? <>>

<ROUTINE A-MIDAIR-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<COND (,AT-AIRPLANE-DOOR?
		       <TELL
"You now have a fine view through the window of the plane's emergency exit.
Inside, the passengers and crew seem to be doing very little of the sort
of freezing and suffocating that you are starting to become accustomed to.
The stewardess who was kind enough to help with your airborne departure is
standing with her back to the window." CR>)
		      (,FLY-HACK?
		       <TELL
"You are currently freezing to death from the -20 degree temperature,
suffocating from the rarified 30,000 ft air, and, if that wasn't bad
enough, you're trailing about fifteen feet behind the emergency exit of 
your flight to Bananareeve." CR>)
		      (,CHUTE-DEPLOYED?
		       <TELL
"You are falling serenely through the African night. It might be possible
to enjoy the scenery were it not for the total darkness which envelopes
you. You are suspended by a multi-colored parachute which is strapped
to your back." CR>)
		      (T
		       <TELL
"You are in free-fall somewhere above the African continent, presumably
near Bananareeve. It's pretty deserted on the ground, judging by the fact
that nothing is lighted. You are wearing a parachute on your back. A red
handle attached to a long cord hangs over your right shoulder." CR>)>)
	       (<EQUAL? .RARG ,M-BEG>
		<COND (,FLY-HACK?
		       <COND (<G? <SETG FLY-HACK? <+ ,FLY-HACK? 1>> 4>
			      <TELL
"Your body, in its final spasms, seems unable to decide upon whether your
cause of death will be the lack of air or the frosty temperature. It is
finally decided that a toss of a coin will decide (There is a great deal
of literary licence here. In fact, the decision was to poll a few hundred
thousand synapses at random.) The winner, though, is ">
			      <COND (<PROB 50> <TELL "suffocation">)
				    (T <TELL "freezing to death">)>
			      <JIGS-UP ".">
			      <RTRUE>)>)>
		<COND (<AND <EQUAL? ,MIDAIR-COUNT 0>
			    <VERB? WALK>
			    <EQUAL? ,PRSO ,P?UP>>
		       <TELL
"Of course, it's absurd to think you can fly, and maybe it's just the
effect of not much oxygen on not much grey matter, but you seem to have
broken your fall. This illusion is quickly broken as you notice that one
of the straps on the parachute is caught in the door of the airplane." CR>
		       <SETG FLY-HACK? 1>)
		      (<AND <VERB? WALK> <NOT <EQUAL? ,PRSO ,P?DOWN>>>
		       <TELL
"Your sense of direction never was very good, and the fact that you have
no visual references is not helping. You might as well get used to
\"down\"." CR>
		       <RTRUE>)>)
	       (<EQUAL? .RARG ,M-END>
		<COND (<NOT ,FLY-HACK?>
		       <SETG MIDAIR-COUNT <+ ,MIDAIR-COUNT 1>>)>
		<COND (<AND <EQUAL? ,MIDAIR-COUNT 1> <NOT ,FLY-HACK?>>
		       <SETG FLY-HACK? 1>
		       <TELL CR
"Just when you were getting used to the idea of falling to your death,
you find that one of the straps on your parachute is caught in the
emergency exit of the airplane." CR>)
		      (<G? ,MIDAIR-COUNT 5>
		       <COND (<NOT ,CHUTE-DEPLOYED?>
			      <JIGS-UP
"Your fall comes to a rather abrupt stop as your body makes contact with
terra firma. Although you're dead, it might interest you to know that you
landed in a tree filled with aye-ayes, which, had you managed to take
their picture, would have brought you fame and fortune.">)
			     (T
			      <TELL
"The ground becomes visible when you are about a few hundred feet up, so
you are able to watch as your chute grabs hold of a passing branch, sending
you into a near-perfect backflip. The end result is that you are now hanging
upside-down, some twenty-odd feet above the ground, suspended by what remains
of your parachute. Your philisophical side tells you \"It could be worse - it
could be raining.\", while your rational side tells you that, in fact, it is."
CR>
			      <GOTO ,IN-A-TREE>
			      <RTRUE>)>)
		      (<AND ,FLY-HACK? <G? ,FLY-HACK? 1>>
		       <TELL
"I don't mean to worry you, but do you realize that you are freezing to death
even as you suffocate?" CR>)
		      (,CHUTE-DEPLOYED?
		       <TELL
"You continue your leisurely descent, pleased that things seem to be getting
a bit under control." CR>)
		      (T
		       <TELL
"You continue your precipitous descent through the night sky." CR>)>)>> 
		       
<OBJECT PARACHUTE
	(LOC A-MIDAIR)
	(DESC "parachute")
	(SYNONYM STRAP PARACHUTE CHUTE)
	(ADJECTIVE MULTI-COLORED)
	(FLAGS CONTBIT TRANSBIT NDESCBIT)
	(ACTION PARACHUTE-F)>

<OBJECT RIP-CORD
	(LOC PARACHUTE)
	(DESC "red handle")
	(SYNONYM CORD HANDLE)
	(ADJECTIVE RIP RED)
	(FLAGS NDESCBIT)
	(ACTION RIP-CORD-F)>

<ROUTINE RIP-CORD-F ()
	 <COND (<VERB? MOVE>
		<COND (,CHUTE-DEPLOYED?
		       <TELL "Nothing happens this time." CR>)
		      (,FLY-HACK?
		       <JIGS-UP
"Things were bad enough with one of the parachute straps stuck in the
emergency exit. Pulling the cord, as you might have expected, has added
the complication of a deployed parachute as well. The various straps,
cords, and other parachute paraphenalia, each going its own way, sends
you flying in a number of unpleasant pieces.">)
		      (T
		       <SETG CHUTE-DEPLOYED? T>
		       <TELL
"Your luck seems to be changing. Instead of simply falling off in
your hand, the cord actually appears to have been attached to the
chute and pulling it has caused the chute to deploy. This results
in a greatly slowed rate of descent." CR>)>)
	       (<VERB? EXAMINE>
		<TELL
"It's just a red handle attached to a cord. All in all, it looks like the
sort of thing one pulls to cause a parachute to deploy." CR>)>>

<ROUTINE PARACHUTE-F ()
	 <COND (<AND <VERB? MOVE> ,FLY-HACK?>
		<TELL
"Using all the strength you can muster, you pull yourself toward the
emergency exit of the plane." CR CR>
		<SETG AT-AIRPLANE-DOOR? T>
		<V-LOOK>
		<RTRUE>)
	       (<VERB? EXAMINE>
		<COND (,FLY-HACK?
		       <TELL
"The chute is strapped to your back, which is good, and to the emergency
exit of the airplane, which is bad." CR>)
		      (,CHUTE-DEPLOYED?
		       <TELL
"Although you can tell it's above you somewhere, the thickness of the night
and clouds prevent you from seeing it." CR>)
		      (T
		       <TELL
"It's on your back, you know, so you can't tell much. A red handle attached
to a cord, though, flutters nearby." CR>)>)>>

<ROUTINE WALK-THE-PLANK ()
	 <COND (<VERB? WALK>
		<COND (<EQUAL? ,HERE ,A-REAR>
		       <COND (<EQUAL? ,PRSO ,P?WEST ,P?EAST>
			      <TELL
"The purser and stewardess follow you toward the emergency exit." CR>
			      <RFALSE>)
			     (T
			      <FORCE-WALK ,P?EAST "east">
			      <RFALSE>)>)
		      (<EQUAL? ,PRSO ,P?SOUTH>
		       <TELL
"The purser and stewardess follow closely as you walk rearward." CR>
		       <RFALSE>)
		      (T
		       <FORCE-WALK ,P?SOUTH "south">
		       <RFALSE>)>)
	       (T
		;"Will handle some more stuff here"
		<FORCE-WALK ,P?SOUTH "south">
		<PERFORM ,V?WALK ,PRSO>
		<RTRUE>)>>

<ROUTINE FORCE-WALK (DIR STR)
	 <SETG SEATED? <>>
	 <TELL
"The purser has a different idea, and pushes you toward the " .STR>
	 <SETG P-WALK-DIR .DIR>
	 <SETG PRSO .DIR>
	 <EOS>
	 <CRLF>>
			      
<ROUTINE I-VISA-3 ()
	 <COND (<G? <SETG FORM-WAIT <+ ,FORM-WAIT 1>> 5>		    
		<ASK-TO-LEAVE>)
	       (<AND <G? ,VISA-WAIT 0>
		     <G? <SETG VISA-WAIT <+ ,VISA-WAIT 1>> 5>>
		<ASK-TO-LEAVE>)
	       (<EQUAL? ,VISA-WAIT 0>
		<TELL CR <GET ,FORM-WAITS ,FORM-WAIT> CR>
		<COND (<G? ,FORM-WAIT 4>
		       <MOVE ,A-PURSER ,HERE>)>
		<RTRUE>)
	       (T
		<TELL CR <GET ,VISA-WAITS ,VISA-WAIT> CR>
		<COND (<G? ,VISA-WAIT 4>
		       <MOVE ,A-PURSER ,HERE>)>
		<RTRUE>)>>

<OBJECT A-ATTENDANT
	(DESC "stewardess")
	(LDESC
"A stewardess is here, waiting for you.")
	(SYNONYM STEWARDESS ATTENDANT)
	(ADJECTIVE CABIN)
	(FLAGS ACTORBIT)
	(ACTION A-ATTENDANT-F)>

<ROUTINE A-ATTENDANT-F ()
	 <COND (<NOT <RUNNING? I-VISA-3>>
		<COND (<AND <VERB? GIVE SHOW> <EQUAL? ,PRSO ,ME>>
		       <TELL "." CR>)
		      (<AND <VERB? GIVE SHOW> <EQUAL? ,PRSO ,A-ATTENDANT>>
		       <TELL
"The " D ,PRSO " isn't really interested in your " D ,PRSI "." CR>)>) 
	       (<AND <VERB? GIVE SHOW>
		     <EQUAL? ,PRSO ,IMMIGRATION-FORM>>
		<COND (,VISA-FILLED?
		       <TELL
"She looks carefully at your form, then returns it. \"I don't know
if this is some kind of joke, but that's not a valid visa number.
Now, please, just fill in the form.\"" CR>)
		      (,IMMIGRATION-FILLED?
		       <TELL
"She looks over the form and hands it back to you. \"You must have
forgotten to complete your visa number. I'll just wait here while
you fill it in." CR>)
		      (T
		       <TELL
"She sees that you haven't filled in the form and returns it to
you. \"I'll just wait here until you've completed the form.\"" CR>)>)
	       (<OR <AND <EQUAL? ,PRSO ,APOLOGY <VERB? MAKE-TO>>>
		    <VERB? APOLOGIZE>>
		<TELL
"She doesn't seem interested in any apologies or excuses." CR>)>>

<OBJECT GLOBAL-ATTENDANT
	(LOC GLOBAL-OBJECTS)
	(DESC "stewardess")
	(SYNONYM STEWARD STEWARDESS ATTENDANT)
	(ADJECTIVE CABIN)
	(ACTION GLOBAL-ATTENDANT-F)>

<ROUTINE MAKE-ATTENDANT-APPEAR ()
	 <MOVE ,A-ATTENDANT ,HERE>
	 <TELL
"Responding to your call, an attendant appears." CR>
	 <ENABLE <QUEUE I-ATTENDANT-LEAVES 3>>
	 <RTRUE>>

<ROUTINE I-ATTENDANT-LEAVES ()
	 <TELL
"\"I'm sorry, but I'll have to be leaving now." CR>
	 <REMOVE ,A-ATTENDANT>>

<ROUTINE GLOBAL-ATTENDANT-F ()
	 <COND (<FSET? ,HERE ,AIRPLANEBIT>
		<COND (<VERB? WAIT-FOR CALL>
		       <COND (<QUEUED? I-VISA-2>
			      <QUEUE I-VISA-2 2>
			      <TELL
"A stewardess, noticing your impatience, walks toward you." CR>)
			     (T
			      <MAKE-ATTENDANT-APPEAR>)>)>)
	       (<EQUAL? ,HERE ,A-MIDAIR>
		<COND (<VERB? WAVE-AT>
		       <PERFORM ,V?KNOCK ,AIRPLANE-EXIT>
		       <RTRUE>)
		      (<VERB? HELLO>
		       <TELL "Unlikely she can hear you." CR>)
		      (<VERB? WAIT-FOR>
		       <TELL "You'd die first." CR>)
		      (T
		       <TELL
"She's inside and you're outside, if you haven't noticed." CR>)>)
	       (T
		<TELL
"You can't see any stewardess here." CR>)>>

<OBJECT A-PURSER
	(DESC "purser")
	(LDESC
"The purser, a large, burly man, is here, waiting impatiently.")
	(SYNONYM PURSER)
	(ADJECTIVE BURLY)
	(FLAGS ACTORBIT)
	(ACTION A-PURSER-F)>

<GLOBAL FORM-WAITS <LTABLE
"\"It's very important, sir, that you return the form.\""
"\"Without the form, sir, I'm afraid that we will be unable to land.\""
"\"The authorities are very explicit about this, sir. No plane may land
in Zalagasa without the forms having been completed.\""
"\"There are no exceptions, sir.\" You notice that the stewardess makes
a head motion to someone you can't see."
"\"I'm afraid that I must ask for that form now, sir.\" A rather burly
gentleman, introduced as the purser, arrives at your side.">>

<GLOBAL VISA-WAITS <LTABLE
"\"I'm sorry, sir, but we do require your visa number.\""
"\"I'm sorry, sir, but we're not allowed to land until everyone submits
completed forms. Now please fill in your visa number.\""
"\"The authorities will not allow the plane to land without all forms
being filled out, and that includes your visa number.\""
"\"We're running out of time, sir.\" She motions to someone who you
can't see."
"\"I shall have to insist on your visa number NOW.\" A rather burly
gentleman, introduced as the purser, arrives at your side.">>

<ROUTINE A-FORM-WAIT ()
	 <COND (<VERB? WALK>
		<TELL
"The stewardess stands in your way. \"I'm sorry, sir, but I'll need that
form now.\"" CR>)>>

<OBJECT IMMIGRATION-FORM
	(DESC "immigration form")
	(SYNONYM FORM)
	(ADJECTIVE IMMIGRATION)
	(FLAGS READBIT TAKEBIT CONTBIT TRANSBIT)
	(ACTION IMMIGRATION-FORM-F)>

<OBJECT VISA-NUMBER
	(LOC IMMIGRATION-FORM)
	(DESC "visa number")
	(SYNONYM NUMBER)
	(ADJECTIVE VISA)
	(FLAGS NDESCBIT)
	(ACTION VISA-NUMBER-F)>

<ROUTINE VISA-NUMBER-F ()
	 <COND (<VERB? FILL-IN MAKE-UP>
		<COND (<EQUAL? ,VISA-WAIT 0>
		       <SETG VISA-WAIT 1>)>
		<COND (,VISA-FILLED?
		       <TELL
"You erase the visa number you had tried before and attempt a different
one." CR>)
		      (T
		       <SETG VISA-FILLED? T>
		       <TELL
"You make up some visa number or other and write it in the appropriate
space on the form." CR>)>)>>

<GLOBAL IMMIGRATION-FILLED? <>>
<GLOBAL VISA-FILLED? <>>

<ROUTINE IMMIGRATION-FORM-F ()
	 <COND (<VERB? EXAMINE READ>
		<TELL
"The form is a simple one, in which you are asked to supply your name,
passport number, visa number, and length of stay." CR>)
	       (<VERB? FILL-IN>
		<COND (,IMMIGRATION-FILLED?
		       <TELL
"You've already filled in the form (except for the visa number). If you
want to fill in the visa number, just say so." CR>)
		      (T
		       <SETG IMMIGRATION-FILLED? T>
		       <TELL
"You fill in the form, except, of course, for the visa number, which
you haven't got since your travel plans didn't call for a trip to
Bananareeve today." CR>)>)>>

<ROUTINE START-HIJACK ()
	 <TELL
"You are startled at a commotion behind you. You turn around to find
yourself looking down the barrel of a large revolver. Attached to the
revolver is the hand and arm of a man around whose waist are a string
of hand grenades and sticks of dynamite. \"You! Up!\" he shouts." CR>
	 <MOVE ,HIJACKER ,HERE>
	 <ENABLE <QUEUE I-HIJACK 2>>
	 <RTRUE>>

<ROUTINE I-HIJACK ()
	 <TELL CR
"The hijacker forces you to the cockpit of the plane." CR>>

<OBJECT HIJACKER
	(DESC "hijacker")
	(SYNONYM MAN HIJACKER)
	(FLAGS ACTORBIT TRANSBIT CONTBIT)
	(ACTION HIJACKER-F)>

<ROUTINE HIJACKER-F ()
	 <COND (<EQUAL? ,WINNER ,HIJACKER>
		<COND (<IN? ,GRENADE ,HERE>
		       <TELL
"\"Oh, leave me alone.\"" CR>)
		      (<EXPLODES?> <RTRUE>)
		      (T
		       <TELL
"\"Shut up or I'll blow your brains out.\"" CR>)>)
	       (<VERB? OPEN CLOSE LOOK-INSIDE>
		<TELL "Don't be silly." CR>)
	       (<VERB? EXAMINE>
		<TELL
"He is a man of medium height, with a few days growth of beard on his
chin. Around his waist are strapped a couple of hand grenades, a couple
of sticks of dynamite, and an antenna-bearning yellow device which would
appear to be a transmitter of some sort. He is holding a gun which is
aimed between your eyes." CR>)>>

<OBJECT GUN
	(LOC HIJACKER)
	(SYNONYM PISTOL GUN HANDGUN)
	(ADJECTIVE HAND)
	(FLAGS NDESCBIT)
	(ACTION GUN-F)>

<ROUTINE GUN-F ()
	 <COND (<VERB? TAKE PULL>
		<EXPLOSIVES-F>)
	       (<VERB? EXAMINE>
		<TELL
"You've never before witnessed the insides of the barrel of a gun, but
this is exactly the view you get looking at the gun." CR>)>>

<OBJECT EXPLOSIVES
	(LOC HIJACKER)
	(DESC "explosives")
	(SYNONYM GRENADE GRENADES STICKS DYNAMITE STICK)
	(FLAGS NDESCBIT)
	(ACTION EXPLOSIVES-F)>

<ROUTINE EXPLOSIVES-F ()
	 <COND (<VERB? TAKE PULL>
		<COND (<EXPLODES?>
		       <RTRUE>)
		      (T
		       <TELL 
"\"I'll kill you, I swear it, if you go near me!\"" CR>)>)
	       (<VERB? EXAMINE>
		<TELL
"These appear to be the real thing." CR>)>>

<GLOBAL BLOW-UP 0>

<ROUTINE EXPLODES? ()
	 <COND (<G? <SETG BLOW-UP <+ ,BLOW-UP 1>> 5>
		<TELL
"\"Ok, that's it!\" He raises the gun and pulls the trigger. Nothing happens.
\"Damned guns!\" he explains, as he pulls the trigger again. Nothing happens
again. \"Wouldn't surprise me if none of this stuff works.\" he spits. He
attemps to prove this by pulling the pin on one of his grenades. \"See ...
nothing. Damned grenade.\" He dejectedly tosses the grenade aside." CR>
		<MOVE ,GRENADE ,HERE>
		<ENABLE <QUEUE I-BLOW-UP 3>>)>>

<OBJECT GRENADE
	(DESC "grenade")
	(SYNONYM GRENADE)
	(ADJECTIVE HAND)
	(FLAGS TAKEBIT)
	(ACTION GRENADE-F)>

<ROUTINE GRENADE-F ()
	 <COND (<VERB? EXAMINE>
		<TELL
"It's an ordinary grenade, except that its pin has been pulled. Few people
experience this sight for more than a few moments." CR>)>> 

<ROUTINE I-BLOW-UP ()
	 <CRLF>
	 <JIGS-UP
"It will no doubt interest you to learn that the hijacker was wrong about
the grenade. It dutifully explodes, ending your rather unpleasant flight.">>  

<OBJECT WALKIE-TALKIE
	(LOC HIJACKER)
	(DESC "yellow device")
	(SYNONYM ANTENNA DEVICE WALKIE-TALKIE TALKIE TRANSMITTER)
	(ADJECTIVE YELLOW WALKIE)
	(FLAGS NDESCBIT)
	(ACTION WALKIE-TALKIE-F)>

<ROUTINE WALKIE-TALKIE-F ()
	 <COND (<VERB? TAKE PULL>
		<EXPLOSIVES-F>)
	       (<VERB? EXAMINE>
		<TELL
"You can't tell too much about it, though on inspection it's more clearly
a walkie-talkie of some sort." CR>)>>
	  

<GLOBAL MOVIE-TIME 0>

<GLOBAL T-MOVIE 1035>
<GLOBAL T-MEAL 795>

<ROUTINE I-MOVIE ()
	 <SETG MOVIE-TIME <+ ,MOVIE-TIME 1>>
	 <COND (<EQUAL? ,MOVIE-TIME 1>
		<TELL
"A flight attendant pulls down a screen in the front of the plane, the
lights are dimmed, and the in-flight movie starts." CR>
		<QUEUE I-MOVIE 10>
		<RTRUE>)
	       (<G? ,MOVIE-TIME 5>
		<TELL
"The movie ends, the lights go up, and the stewardess pulls the screen
back up." CR>
		<START-AIRPLANE-FUN>)
	       (T
		<QUEUE I-MOVIE 10>
		<RFALSE>)>>
	       	 
<GLOBAL MOVIE-TBL <LTABLE
;"Hijack"
<LTABLE
 "The movie is a new French comedy film, although you can't understand the
language very well. In the opening scene, the protagonist is packing his
bags."
 "In this scene, he is arriving at what must be his new house, on a street
very similar to your own. His place is deserted, except for some boxes which
are piled nearly to the ceiling. The audience laughs heartily as his best
things are crushed by the boxes."
 "In this scene, our hero is running from house to house on his street,
for all appearances trying to break into them, frantically looking for
something."
 "In this scene, our hero is rushing to the airport to catch his plane.
Naturally, everything at the airport is contradictory and confusing. He
does manage, however, to get on his flight."
 "In this scene, a disturbance or scuffle of some kind is happening in
the cabin. The film breaks here....">
;"Zalagasa"
<LTABLE 
 "Part I" 
 "Part II"
 "Part III"
 "Part IV"
 "Part V">
;"Parachute"
<LTABLE 
 "This film would appear to be a documentary of some kind and you notice that
all of the people around you are watching with the utmost interest. The only
recognizable thing on the screen are maps of unfamiliar terrain"
 "In this \"scene\", various types of weather patterns are described. Many
clouds are displayed along with a variety of frontal weather."
 "Now, the scene jumps to a gymnasium of some sort, in which people are
jumping from a height of about ten feet to the ground. They would seem to
be practicing something."
 "Here the film begins to get some tension, as a demonstration is made of
how a parachute is folded and how it is deployed."
 "A moment of levity, as a few examples are displayed of people jumping
from planes and getting themselves into trouble. The silliest of these
involves a novice getting stuck upside down in a tree. It is greeted with
howls of laughter from the otherwise-quiet audience.">>>
	
<ROUTINE V-$VISA ()
	 <START-VISA>
	 <TELL "[Visa problem starts.]" CR>>

<ROUTINE V-$MOVIE ()
	 <ENABLE <QUEUE I-MOVIE 2>>
	 <TELL "[Enjoy the movie!]" CR>>

<ROUTINE V-$AIRPLANE ()
	 <COND (<NOT <EQUAL? ,PRSO ,INTNUM>>
		<TELL "[Illegal $AIRPLANE]" CR>)
	       (<AND <G? ,P-NUMBER 0> <L? ,P-NUMBER 4>>
		<SETG ON-FLIGHT ,P-NUMBER>
		<SETG CURRENT-TIME 735>
		<GOTO ,A-1>
		<TELL "[On airplane #" N ,ON-FLIGHT "]" CR>)>>

;"Things to ask for, in general, and global type things."

<OBJECT GLOBAL-DINNER
	(LOC GLOBAL-OBJECTS)
	(DESC "meal")
	(SYNONYM DINNER LUNCH BREAKFAST SNACK FOOD)
	(ADJECTIVE SOME)
	(ACTION GLOBAL-DINNER-F)>

<OBJECT GLOBAL-DRINK
	(LOC GLOBAL-OBJECTS)
	(DESC "drink")
	(SYNONYM DRINK)
	(ACTION GLOBAL-DRINK-F)>

<OBJECT GLOBAL-BLANKET
	(LOC GLOBAL-OBJECTS)
	(DESC "blanket")
	(SYNONYM BLANKET)
	(ACTION GLOBAL-BLANKET-F)>

<OBJECT GLOBAL-PILLOW
	(LOC GLOBAL-OBJECTS)
	(DESC "pillow")
	(SYNONYM PILLOW)
	(ACTION GLOBAL-PILLOW-F)>

<OBJECT GLOBAL-WINDOW
	(LOC GLOBAL-OBJECTS)
	(DESC "window")
	(SYNONYM PILLOW)
	(ACTION GLOBAL-WINDOW-F)>

<ROUTINE GLOBAL-WINDOW-F ()
	 <COND (<FSET? ,HERE ,AIRPLANEBIT>
		<COND (<EQUAL? ,HERE ,A-LAVATORY ,A-REAR ,A-GALLEY>
		       <TELL
"There's no window you can see through from here." CR>)
		      (<G? ,PRESENT-TIME 950>
		       <TELL
"You can see a beautiful blue sky, with white puffy clouds below." CR>)
		      (T
		       <TELL
"It's dark outside the airplane, so you can't see much." CR>)>)
	       (T
		<TELL "You can't see any window here." CR>)>>

<OBJECT GLOBAL-AIRPLANE
	(LOC GLOBAL-OBJECTS)
	(DESC "airplane")
	(SYNONYM AIRPLANE PLANE JET AIRCRAFT)
	(FLAGS VOWELBIT)
	(ACTION GLOBAL-AIRPLANE-F)>

 ;"Seating, etc."

<GLOBAL SEATING-TBL <TABLE
1 0 1 0
1 1 1 0
1 1 1 1
0 1 0 1
1 1 0 1
1 1 1 1
1 1 1 1
1 0 1 1 
0 1 0 1
1 1 1 1 
1 0 1 0
1 1 1 1
1 1 0 1
1 1 1 1>>

<OBJECT GLOBAL-SEAT
	(LOC GLOBAL-OBJECTS)
	(DESC "seat")
	(SYNONYM SEAT SEATS CHAIR CHAIRS)
	(ACTION GLOBAL-SEAT-F)>

<ROUTINE GLOBAL-SEAT-F ("AUX" A S)
	 <COND (<NOT <FSET? ,HERE ,AIRPLANEBIT>>
		<TELL
"You can't see any seat here." CR>)
	       (<VERB? WALK-TO>
		<TELL
"It shouldn't be so hard for you to get to any seat, since there are
only 14 rows and they are conveniently numbered in order." CR>)
	       (<VERB? EXAMINE LOOK-INSIDE>
		<SET S </ ,P-NUMBER 1000>>
		<SET A <MOD ,P-NUMBER 1000>>
		<COND (<NOT <GETP ,HERE ,P?AISLE>>
		       <TELL
"You can't see that seat from here." CR>)
		      (<NOT <EQUAL? <GETP ,HERE ,P?AISLE> .A>>
		       <COND (,SEATED?
			      <TELL
"It's hard tell, since you're seated." CR>)
			     (T
			      <TELL
"You can't tell much, but there ">
			      <COND (<0? <FIND-SEAT .A .S>>
				     <TELL "doesn't seem">)
				    (T
				     <TELL "seems">)>
			      <TELL " to be somebody sitting in it." CR>)>)>)
	       (<VERB? SIT BOARD CLIMB-ON>
		<COND (<OR <L? ,P-NUMBER 0> <NOT <FSET? ,HERE ,AIRPLANEBIT>>>
		       <TELL
"What on earth are you talking about?" CR>)
		      (,SEATED?
		       <TELL
"You are already seated, if you remember." CR>)
		      (T
		       <SET S </ ,P-NUMBER 1000>>
		       <SET A <MOD ,P-NUMBER 1000>>
		       <COND (<OR <0? .A> <G? .A 14>>
			      <TELL
"There's no such aisle number on this plane." CR>)
			     (<G? .S 4>
			      <TELL
"There's no such seating location on this plane; all of the seats are
labelled A, B, C, or D." CR>)
			     (<NOT <GETP ,HERE ,P?AISLE>>
			      <TELL
"You're not in a seating area." CR>)
			     (<NOT <EQUAL? <GETP ,HERE ,P?AISLE> .A>>
			      <TELL
"You're in the wrong aisle, I'm afraid." CR>)
			     (<0? <FIND-SEAT .A .S>>
			      <TELL
"You make your way to seat " N .A>
			      <PRINTC <+ .S 64>>
			      <TELL " and sit down." CR>
			      <SETG SEATED? ,P-NUMBER>)
			     (T
			      <TELL
"There's somebody sitting in that seat already." CR>)>)>)>>

<ROUTINE UNSEAT-CHECK ()
	 <SETG SEATED? <>>
	 <COND (<OR <NOT <IN? ,SAFETY-CARD ,SEAT-POCKET>>
		    <NOT <IN? ,BARF-BAG ,SEAT-POCKET>>
		    <NOT <IN? ,AIRLINE-MAGAZINE ,SEAT-POCKET>>>
		<MOVE ,SAFETY-CARD ,SEAT-POCKET>
		<MOVE ,BARF-BAG ,SEAT-POCKET>
		<MOVE ,AIRLINE-MAGAZINE ,SEAT-POCKET>
		<FCLEAR ,BARF-BAG ,OPENBIT>
		<TELL
"You remember before you get up to replace everything you took from
the seat pocket." CR CR>)>>

<GLOBAL SEATED? <>>

<ROUTINE FIND-SEAT ("OPTIONAL" (A <>) (S <>))
	 <COND (<NOT .A> <SET A <MOD ,SEATED? 1000>>)>
	 <COND (<NOT .S> <SET S </ ,SEATED? 1000>>)>
	 <GET ,SEATING-TBL <+ <* <- .A 1> 4> <- .S 1>>>>

<OBJECT SEAT-POCKET
	(LOC GLOBAL-OBJECTS)
	(DESC "seat pocket")
	(SYNONYM POCKET)
	(ADJECTIVE SEAT)
	(FLAGS CONTBIT OPENBIT)
	(CAPACITY 15)
	(ACTION SEAT-POCKET-F)>

<ROUTINE SEAT-POCKET-F ()
	 <COND (<NOT <FSET? ,HERE ,AIRPLANEBIT>>
		<TELL
"What seat pocket?" CR>)
	       (<NOT ,SEATED?>
		<TELL
"You can't get at any seat pocket unless you're seated." CR>)
	       (<VERB? OPEN CLOSE>
		<TELL "It's a pocket, not a box." CR>)
	       (<AND <VERB? PUT>
		     <EQUAL? ,PRSI ,SEAT-POCKET>
		     <OR <NOT <FSET? ,PRSO ,TAKEBIT>>
			 <NOT <FSET? ,PRSO ,READBIT>>>>
		<TELL
"You can't put that into the seat pocket." CR>)
	       (T
		<RFALSE>)>>

<OBJECT AIRLINE-MAGAZINE
	(LOC SEAT-POCKET)
	(DESC "airline magazine")
	(SYNONYM MAGAZINE AIRLINE)
	(FLAGS VOWELBIT TAKEBIT READBIT)
	(SIZE 4)
	(ACTION AIRLINE-MAGAZINE-F)>

<ROUTINE AIRLINE-MAGAZINE-F ()
	 <COND (<VERB? EXAMINE READ>
		<COND (<EQUAL? ,ON-FLIGHT 1>
		       <TELL
"This is an issue of Air Gaul Express, the official airline magazine
of Air Gaul. Among the articles of interest here are..." CR>)
		      (<EQUAL? ,ON-FLIGHT 2>
		       <TELL
"This is an issue of Zalagasan Odyssey, the official airline magazine of
Air Zalagasa. There are a few articles listed here, including..." CR>)
		      (T
		       <TELL
"This is an issue of Charter Holidays, the official airline magazine
of World Charters. Among the items which catch your eye are..." CR>)>)>>

<OBJECT SAFETY-CARD
	(LOC SEAT-POCKET)
	(DESC "safety card")
	(SYNONYM CARD)
	(ADJECTIVE SAFETY)
	(FLAGS TAKEBIT READBIT)
	(SIZE 3)
	(ACTION SAFETY-CARD-F)>

<ROUTINE SAFETY-CARD-F ()
	 <COND (<VERB? READ EXAMINE>
		<TELL
"This is the safety card for your aircraft, an Aerocom IF-47, your
56-passenger transatlantic airliner. It's like most you've seen before,
and includes helpful information about the emergency use of oxygen and
life rafts, and contains a diagram highlighting the emergency exits located
on both sides of the aircraft at the tail end." CR>)>>

<OBJECT BARF-BAG
	(LOC SEAT-POCKET)
	(DESC "discomfort bag")
	(SYNONYM BAG)
	(ADJECTIVE DISCOMFORT BARF)
	(FLAGS READBIT TAKEBIT CONTBIT)
	(SIZE 8)
	(CAPACITY 8)
	(ACTION BARF-BAG-F)>

<GLOBAL MEAL-EATEN? <>>

<ROUTINE BARF-BAG-F ()
	 <COND (<VERB? READ EXAMINE>
		<TELL
"The bag, cheerfully labelled \"Convenience Bag\", is a rather simple white
bag which is considerably more capable of holding an airline meal than your
stomach is." CR>)
	       (<AND <VERB? PUT> <EQUAL? ,PRSI ,BARF-BAG>>
		<COND (<FIRST? ,PRSI>
		       <TELL
"It's already got something inside." CR>)
		      (<FSET? ,PRSO ,FOODBIT>
		       <TELL
"Just as well; it'll probably end up there anyway." CR>
		       <MOVE ,PRSO ,PRSI>
		       <RTRUE>)
		      (<L? <GETP ,PRSO ,P?SIZE> 8>
		       <TELL
"It's not meant for that sort of thing, but ok..." CR>
		       <MOVE ,PRSO ,PRSI>
		       <RTRUE>)
		      (T
		       <TELL
"It won't fit." CR>)>)>>
	
<ROUTINE AIRPLANE-SLEEP ()
	 <COND (<QUEUED? I-MEAL>
		<QUEUE I-MEAL 2>
		<TELL
"You sleep for a while but then you are startled awake..." CR CR>
		<SETG CURRENT-TIME ,T-MEAL>
		<RTRUE>)
	       (<AND <QUEUED? I-MOVIE> <EQUAL? ,MOVIE-TIME 0>>
		<QUEUE I-MOVIE 2>
		<TELL
"You sleep for a while but then you are startled awake..." CR CR>
		<SETG CURRENT-TIME ,T-MOVIE>
		<RTRUE>)
	       (<AND <QUEUED? I-MOVIE> <G? ,MOVIE-TIME 0>>
		<SETG MOVIE-TIME 5>
		<QUEUE I-MOVIE 2>
		<TELL
"You sleep for a while but then you are startled awake..." CR CR>
		<SETG CURRENT-TIME <+ ,T-MOVIE 60>>
		<RTRUE>)>>

<ROUTINE I-MEAL ()
	 <TELL
"This will be the meal episode..." CR>>

<OBJECT KNIFE
	(LOC MEAL-PLATTER)
	(DESC "knife")
	(SYNONYM KNIFE)
	(FLAGS TAKEBIT)>

<OBJECT FORK
	(LOC MEAL-PLATTER)
	(DESC "fork")
	(SYNONYM FORK)
	(FLAGS TAKEBIT)>

<OBJECT SPOON
	(LOC MEAL-PLATTER)
	(DESC "spoon")
	(SYNONYM SPOON)
	(FLAGS TAKEBIT)>

<OBJECT MEAL-PLATTER
	(DESC "tray")
	(SYNONYM PLATTER TRAY)
	(FLAGS TAKEBIT)>

