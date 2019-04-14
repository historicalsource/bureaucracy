
"PLACES for BUREAUCRACY: Copyright 1987 Infocom, Inc. All rights reserved."

<FILE-FLAGS MDL-ZIL?>

;<SETG END-GAME? <>>

"*** YOUR HOUSE ***"

<VOC "ZZSTREET" NOUN>

<DEFINE PARSE-RANDOM-LOC (ADJ NAM STUFF "AUX" OBJ)
  <COND (<AND <==? .ADJ ,W?INTNUM>
	      <==? .NAM ,W?ZZSTREET>>
	 <SET OBJ <FIRST? ,ROOMS>>
	 <REPEAT ()
	   <COND (<==? ,P-NUMBER <GETP .OBJ ,P?STADDR>>
		  <RETURN>)>
	   <COND (<NOT <SET OBJ <NEXT? .OBJ>>> <RETURN>)>>
	 <COND (<NOT .OBJ>
		<TELL "[" N ,P-NUMBER
		      " " <SHOW-FIELD ,STREET-NAME> " isn't a valid address.]"
		      CR>)>
	 .OBJ)
	(<THIS-IT? ,YOUR-HOUSE>
	 ,YOUR-HOUSE)
	(<AND <==? .NAM ,W?ROOM>
	      <OR <F? .ADJ>
		  <==? .ADJ ,W?THIS>>>
	 <COND (<IS? ,HERE ,INDOORS> ,HERE)
	       (T
		<TELL "You aren't in a room." CR>
		,FATAL-VALUE)>)
	(T
	 <SET OBJ <FIRST? ,ROOMS>>
	 <REPEAT (TBL)
	   <COND (<AND <SET TBL <GETPT .OBJ ,P?SYNONYM>>
		       <INTBL? .NAM .TBL </ <PTSIZE .TBL> 2>>
		       <OR <NOT .ADJ>
			   <AND <SET TBL <GETPT .OBJ ,P?ADJECTIVE>>
				<INTBL? .ADJ .TBL
				   </ <PTSIZE .TBL> 2>>>>>
		  <RETURN>)>
	   <COND (<NOT <SET OBJ <NEXT? .OBJ>>> <RETURN>)>>
	 .OBJ)>>

<CONSTANT PARSE-RANDOM-LOC-VEC <PTABLE PARSE-RANDOM-LOC 0>>

<OBJECT FROOM
	(LOC ROOMS)
	(DESC "front room")
	(SYNONYM ROOM PARLOR)
	(ADJECTIVE LIVING OTHER FRONT)
	(FLAGS IN-TOWN NO-NERD LIGHTED LOCATION INDOORS)
	(THINGS PARSE-RANDOM-LOC-VEC)
	(EXIT-TO OUTSIDE-HOUSE)
	(ENTER-FROM <PTABLE P?WEST OUTSIDE-HOUSE>)
	(EAST TO OUTSIDE-HOUSE)
	(OUT TO OUTSIDE-HOUSE)
	(IN PER INTO-HOUSE)
	(WEST PER INTO-HOUSE)
	(GLOBAL FROOM-DOOR YOUR-WINDOWS DOORBELL BROOM YOUR-HOUSE FROOM)
	(GENERIC GENERIC-ROOM-F)
	(ACTION FROOM-F)>

<DEFINE GENERIC-ROOM-F (TBL "AUX" (LEN <ZGET .TBL 0>))
  <SET TBL <ZREST .TBL 2>>
  <COND (<INTBL? ,HERE .TBL .LEN>
	 ,HERE)
	(T <>)>>

<DEFINE INTO-HOUSE ()
	 <COND (<IN? ,DMAN ,FROOM>
		<TELL CTHE ,DMAN " clears his throat, and you hesitate." CR>
		<>)
	       (T
		,BROOM)>>	       

<DEFINE FROOM-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<COND (,END-GAME?
		       <TELL ,THIS-IS "the front room of your new house.
While you were absent, the removals firm delivered all your belongings
and installed them exactly where you had specified. The carpets have been
laid, the curtains hang luxuriously in the windows, your books have been
arranged in order and the record player is playing your favourite album">)
		      (T
		       <TELL ,THIS-IS "the living room of "
		             D ,YOUR-HOUSE 
", a pretty nice room, actually. At least, it will be when all your stuff has arrived as the removals company said they would have done yesterday and now say they will do while you're on vacation. At the moment, however, it's a bit dull. Plain white, no carpets, no curtains, no furniture. A room to go bughouse in, really. Another room is visible to the west, and a">
		       <OPEN-CLOSED ,FROOM-DOOR>
		       <TELL " leads outside">)>
		<TELL ,PERIOD>
		T)
	       (<==? .CONTEXT ,M-EXIT>
		<COND (<EQUAL? ,P-WALK-DIR ,P?IN ,P?WEST>
		       <>)
		      (<NOT <IS? ,FROOM-DOOR ,OPENED>>
		       <ITS-CLOSED ,FROOM-DOOR>
		       T)
		      (<IN? ,DMAN ,FROOM>
		       <TELL CTHE ,DMAN " is standing in the way." CR>
		       <I-DMAN>
		       T)
		      (T <>)>)
	       (<T? .CONTEXT> <>)
	       (<AND <HERE? FROOM>
		     <ADJ-USED? ,W?OTHER>>
		<COND (<THIS-PRSO?> <PERFORM ,PRSA ,BROOM ,PRSI>)
		      (T <PERFORM ,PRSA ,PRSO ,BROOM>)>)
	       (<HANDLE-ROOM? ,FROOM ,P?EAST> T)
	       (T
		<>)>>

<OBJECT BROOM
	(LOC ROOMS)
	(DESC "back room")
	(SYNONYM ROOM)
	(ADJECTIVE BACK OTHER)
	(FLAGS IN-TOWN NO-NERD LIGHTED LOCATION INDOORS)
	(EXIT-TO FROOM)
	(ENTER-FROM <PTABLE P?WEST FROOM>)
	(EAST TO FROOM)
	(OUT TO FROOM)
	(GLOBAL FROOM-DOOR YOUR-WINDOWS DOORBELL FROOM YOUR-HOUSE BROOM)
	(GENERIC GENERIC-ROOM-F)
	(ACTION BROOM-F)>

<DEFINE BROOM-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<COND (,END-GAME?
		       <TELL "You're in the back room of " D ,YOUR-HOUSE
			     ". Pausing briefly to note how accurately this
jolly nice room reflects your new status, you sensibly ">
		       <COND (<NOT <META-IN? ,END-MAIL ,PLAYER>>
			      <TELL "wonder why you haven't read your mail
yet." CR>)
			     (T
			      <TELL "read your mail.">
			      <PERFORM ,V?READ ,END-MAIL>)>)
		      (T
		       <TELL "You're in the back room of "
			     D , YOUR-HOUSE
", another nice room, at present suitable for lining with latex padding and bouncing off the walls, but likely to be pretty impressive and upwardly mobile once the removals men have sorted out their little problem. The exit leads east to the living room." CR>)>
		T)
	       (<==? .CONTEXT ,M-EXIT>
		<COND (<IS? ,MACHINE ,SEEN>
		       <TELL "You'd better hang up the phone first." CR>
		       T)
		      (T <>)>)
	       (<T? .CONTEXT> <>)
	       (<AND <HERE? BROOM>
		     <ADJ-USED? ,W?OTHER>>
		<COND (<THIS-PRSO?> <PERFORM ,PRSA ,FROOM ,PRSI>)
		      (T <PERFORM ,PRSA ,PRSO ,FROOM>)>)
	       (<HANDLE-ROOM? ,BROOM ,P?WEST> T)
	       (T
		<>)>>

<OBJECT OUTSIDE-HOUSE
	(LOC ROOMS)
	(DESC "Street")
	(THINGS PARSE-RANDOM-LOC-VEC)
	(SDESC SAY-STREET-ADDRESS)
	(FLAGS IN-TOWN LIGHTED LOCATION NOARTICLE)
	(NORTH TO ST-B)
	(EAST TO IN-ALLEY)
	(WEST TO FROOM IF FROOM-DOOR IS OPEN)
	(IN PER ENTER-FROM-OUTSIDE)
	(SOUTH TO OUTSIDE-MANSION)
	(GLOBAL FROOM-DOOR YOUR-WINDOWS STREETNUMBERS GSTREET
	 	CAB CAB-DRIVER YOUR-HOUSE)
	(STADDR 69)
	(LDESC "You're standing on a well-kept sidewalk to the east of your new house. The street bears north and south. There's an overgrown alleyway to the east.")
	(ACTION OUTSIDE-HOUSE-F)>

<DEFINE OUTSIDE-HOUSE-F ("OPT" (CONTEXT <>))
  <COND (<==? .CONTEXT ,M-EXIT>
	 <COND (<AND <==? ,GOTO-LOC ,FROOM>
		     <MORE-MESSAGES?>>
		<SETUP-NEXT-MESSAGES>
		<TELL "You hear the tail end of a message on your answering machine" ,PCR>)>
	 <>)
	(T <>)>>

"*** DOWNTOWN ***"

<OBJECT ST-A
	(LOC ROOMS)
	(DESC "Downtown")
	(SDESC SAY-STREET-ADDRESS)
	(THINGS PARSE-RANDOM-LOC-VEC)
	(FLAGS IN-TOWN LIGHTED LOCATION NOARTICLE)
	(IN PER WHICH-WAY-IN)
	(SEE-N BANK)
	(SEE-E THALL)
	(SEE-W AGENCY)
	(NORTH PER TO-BANK)
	(EAST TO THALL)
	(SOUTH TO ST-B)
	(WEST PER ENTER-AGENCY)
	(GLOBAL CAB CAB-DRIVER STREETNUMBERS GSTREET THALL BANK AGENCY)
	(STADDR 67)
	(LDESC "This is the commercial district. You see a rather shabby brownstone tenement (obviously once a grand family house) to the east, and a travel agency (which is trying to look like a bank) to the west. The Fillmore Fiduciary Trust Bank (which is trying to look like a travel agency) lies to the north. The street continues south.")>

<DEFINE FROB-IS-CLOSED (STR)
  <TELL "The " .STR " is closed." CR>
  <>>

<DEFINE ENTER-AGENCY ()
	 <COND (<T? ,END-GAME?>
		<FROB-IS-CLOSED "travel agency">)
	       (T
		<THIS-IS-IT ,AGENT>
		<TELL "You step into the travel agency" ,PCR>
		,AGENCY)>>

<OBJECT ST-B
	(LOC ROOMS)
	(DESC "Downtown")
	(SDESC SAY-STREET-ADDRESS)
	(THINGS PARSE-RANDOM-LOC-VEC)
	(FLAGS IN-TOWN LIGHTED LOCATION NOARTICLE)
	(NORTH TO ST-A)
	(SEE-E DINER)
	(SEE-W BSTORE)
	(SEE-S OUTSIDE-HOUSE)
	(EAST PER ENTER-DINER)
	(WEST PER ENTER-SHOP)
	(SOUTH TO OUTSIDE-HOUSE)
	(IN PER WHICH-WAY-IN)
	(GLOBAL STREETNUMBERS GSTREET CAB CAB-DRIVER DINER BSTORE)
	(STADDR 68)
	(LDESC "You see a rather run-down restaurant to the east, and one of those bookstores which looks as if it wouldn't have anything you want to buy to the west. The street continues north and south.")>

<DEFINE ENTER-SHOP ()
	 <COND (<T? ,END-GAME?>
		<FROB-IS-CLOSED "bookstore">)
	       (T
		<TELL "You step into the bookstore" ,PCR>
		,BSTORE)>>

<DEFINE ENTER-DINER ()
	 <COND (<T? ,END-GAME?>
		<FROB-IS-CLOSED "restaurant">)
	       (<IN? ,BAG ,PLAYER>
		<TELL "In many ways, bringing the llama food with you is a wise move. However, due to strict public health laws (enacted for your safety and convenience), this restaurant doesn't permit customers to bring in competing varieties of food. Better leave it outside" ,PERIOD>
		<>)
	       (T
		<TELL "You step into the dingy restaurant" ,PCR>
		,DINER)>>

<DEFINE SAY-STREET-ADDRESS ("OPTIONAL" (X <>) "AUX" Y)
	 <COND (<T? .X>
		<SET Y <GETP .X ,P?STADDR>>)
	       (<AND %<COND (<GASSIGNED? ZILCH> '<T? ,PRSO>)
			    (T '<TYPE? ,PRSO OBJECT>)>
		     <T? <SET Y <GETP ,PRSO ,P?STADDR>>>>
		T)
	       (T
		<SET Y <GETP ,HERE ,P?STADDR>>)>
	 <TELL N .Y " ">
	 <SHOW-FIELD ,STREET-NAME>
	 T>

<OBJECT IN-ALLEY
	(LOC ROOMS)
	(DESC "alley")
	(FLAGS IN-TOWN LIGHTED LOCATION VOWEL)
	(THINGS PARSE-RANDOM-LOC-VEC)
	(SYNONYM ALLEY ALLEYWAY)
	(EXIT-TO OUTSIDE-HOUSE)
	(ENTER-FROM <PTABLE P?EAST OUTSIDE-HOUSE>)
	(NORTH TO DINER IF KITCHEN-DOOR IS OPEN)
	(EAST SORRY "The fence blocks your path.")
	(IN TO DINER IF KITCHEN-DOOR IS OPEN)
	(SOUTH PER IN-ALLEY-S)
	(WEST TO OUTSIDE-HOUSE)
	(GLOBAL KITCHEN-DOOR FENCE)
	(ACTION IN-ALLEY-F)>

<DEFINE IN-ALLEY-S ()
	 <TELL "You squeeze yourself through the gap" ,PCR>
	 ,BEHIND-MANSION>

<DEFINE IN-ALLEY-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL ,THIS-IS "an overgrown, grassy alley, surrounded by a tall creosoted fence. A">
		<OPEN-CLOSED ,KITCHEN-DOOR>
		<TELL " leads north; there's a gap in the fence to the south. The exit leads west." CR>
		T)
	       (<EQUAL? .CONTEXT ,M-ENTERED>
		<COND (<IS? ,KITCHEN-DOOR ,OPENED>
		       <SETG P-IT-OBJECT ,KITCHEN-DOOR>
		       <UNMAKE ,KITCHEN-DOOR ,OPENED>
		       <TELL CR "Somebody slams " THE ,KITCHEN-DOOR
			     " shut." CR>
		       T)
		      (T
		       <>)>)
	       (<T? .CONTEXT> <>)
	       (<AND <HERE? OUTSIDE-HOUSE>
		     <VERB? LOOK>>
		<TELL "It looks like an ordinary overgrown grassy alley from here. Probably looks like that from anywhere, in fact." CR>)
	       (<HERE? IN-ALLEY>
		<HERE-F>)
	       (<ENTERING?>
		<COND (<HERE? OUTSIDE-HOUSE>
		       <DO-WALK ,P?EAST>
		       T)
		      (<HERE? DINER>
		       <DO-WALK ,P?SOUTH>
		       T)
		      (<HERE? BEHIND-MANSION>
		       <DO-WALK ,P?NORTH>
		       T)
		      (T <>)>)
	       (T <>)>>
		     
<OBJECT AGENCY
	(LOC ROOMS)
	(DESC "travel agency")
	(SYNONYM AGENCY BUILDING)
	(ADJECTIVE TRAVEL)
	(FLAGS IN-TOWN NO-NERD LIGHTED LOCATION INDOORS)
	(THINGS PARSE-RANDOM-LOC-VEC)
	(ENTER-FROM <PTABLE P?WEST ST-A>)
	(EXIT-TO ST-A)
	(OUT TO ST-A)
	(EAST TO ST-A)
	(IN SORRY "You're already inside as far as you can go.")
	(LDESC "You're in a travel agency which is trying to look like a bank. The exit is to the east.")
	(ACTION AGENCY-F)>

<DEFINE AGENCY-F ("OPT" (CONTEXT <>))
  <COND (<T? .CONTEXT> <>)
	(<HERE? AGENCY>
	 <HERE-F>)
	(<AND <ENTERING?>
	      <HERE? ST-A>>
	 <DO-WALK ,P?WEST>)
	(T <>)>>

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
		<CANT-SEE-ANY-STR "any">
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
	(ADJECTIVE MY YOUR)
	(ACTION VISA-F)>

<DEFINE VISA-F ()
	 <COND (<THIS-PRSI?>
		<COND (<PUTTING?>
		       <WASTE-OF-TIME>
		       T)
		      (T
		       <>)>)
	       (<VERB? EXAMINE LOOK-ON LOOK-INSIDE READ OPEN>
		<TELL "You flip open " Q ,PRSO ", ">
		<TELL  
"glance to make sure your French visa is still readable, shudder at the picture, wonder if you " ITAL "really" " look like a dead llama, and close the book." CR>
		T)
	       (<VERB? CLOSE>
		<ALREADY-CLOSED>
		T)
	       (T
		<>)>>

<OBJECT BSTORE
	(LOC ROOMS)
	(DESC "bookshop")
	(SYNONYM BOOKSTORE STORE BOOKSHOP SHOP BUILDING)
	(ADJECTIVE BOOK)
	(FLAGS IN-TOWN NO-NERD LIGHTED LOCATION INDOORS)
	(THINGS PARSE-RANDOM-LOC-VEC)
	(ENTER-FROM <PTABLE P?WEST ST-B>)
	(EXIT-TO ST-B)
	(OUT TO ST-B)
	(EAST TO ST-B)
	(ACTION BSTORE-F)>

<DEFINE BSTORE-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL ,THIS-IS
"a not-very-nice bookstore which sells \"packages\" and \"products\" rather than books. Shelves groan with " D ,BESTSELLERS 
" and bargain " D ,CUTOUTS ". The exit is to the east." CR>
		T)
	       (<EQUAL? .CONTEXT ,M-ENTERED>
	        <SETG P-HIM-OBJECT ,CLERK>
		<SETG P-THEM-OBJECT ,SOFTWARE>
		<MAKE ,CLERK ,TOUCHED>
		<QUEUE I-CLERK>
		<TELL CR CTHE ,CLERK>
		<COND (<IS? ,CLERK ,SEEN>
		       <TELL " recognises you, and scowls impatiently." CR>
		       T)
		      (T
		       <TELL " nods a greeting, and looks you up and down."
			     CR>)>
		T)
	       (<EQUAL? .CONTEXT ,M-EXIT>
		<DEQUEUE I-CLERK>
		<COND (<QUEUED? ,I-CLERK-TRADE>
		       <DEQUEUE ,I-CLERK-TRADE>)>
		<COND (<IS? ,CLERK ,SEEN>
		       <TELL CTHE ,CLERK " scowls again">)
		      (T
		       <MAKE ,CLERK ,SEEN>
		       <TELL "\"Have a nice day,\" calls " THE ,CLERK>)>
		<TELL " as you leave" ,PCR>
		<>)
	       (<AND <==? .CONTEXT ,M-BEG>
		     <OR <EQUAL? ,P-PRSA-WORD ,W?STEAL>
			 <AND <VERB? TAKE> <PRSO? REGISTER>>>>
		<TELL "The City Legal Department employs 176 qualified lawyers, most of whom are hoping that you will steal the bookstore's property so that they can bring long, involved and pompous cases against you and send you to gaol. Their mothers all boast about them, oddly enough." CR>
		T) 
	       (<T? .CONTEXT> <>)
	       (<HERE? BSTORE>
		<HERE-F>)
	       (<AND <ENTERING?>
		     <HERE? ST-B>>
		<DO-WALK ,P?WEST>
		T)
	       (T
		<>)>>

<OBJECT DINER
	(LOC ROOMS)
	(DESC "restaurant")
	(SYNONYM RESTAURANT DINER MILLIE\'S)
	(ADJECTIVE MILLIE\'S)
	(FLAGS IN-TOWN NO-NERD LIGHTED LOCATION INDOORS)
	(THINGS PARSE-RANDOM-LOC-VEC)
	(ODOR BURGER)
	(GLOBAL FOOD KITCHEN-DOOR)
	(EXIT-TO ST-B)
	(ENTER-FROM <PTABLE P?EAST ST-B>)
	(WEST TO ST-B)
	(OUT TO ST-B)
	(SOUTH PER LEAVE-BY-BACK-DOOR)
	(ACTION DINER-F)>

;<SETG MEAL-STATE 0>
<MSETG MS-ORDERED-FROM-WAITRESS 1>
<MSETG MS-ORDERED-FROM-WAITER 2>
<MSETG MS-RECEIVED-FOOD 3>
<MSETG MS-PAID-FOR-FOOD 4>

<DEFINE LEAVE-BY-BACK-DOOR ()
  <COND (<IS? ,KITCHEN-DOOR ,OPENED>
	 ,IN-ALLEY)
	(T
	 <TELL "The door is closed" ,PERIOD>
	 <COND (<AND <G=? ,MEAL-STATE ,MS-ORDERED-FROM-WAITER>
		     <L? ,MEAL-STATE ,MS-PAID-FOR-FOOD>>
		<I-WAITER-ARRIVES T>)>
	 <>)>>

<DEFINE DINER-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL 
"You're in a fast-food restaurant. This is merely a bureaucratic convention, since the food is not really fast. Nor is it really food. There's an exit out to the street, and a somewhat grubby ">
		<COND (<IS? ,KITCHEN-DOOR ,OPENED>
		       <TELL "(but open) ">)>
		<TELL "door to the south." CR>
		T)
	       (<==? .CONTEXT ,M-EXIT>
		<COND (<EQUAL? ,P-WALK-DIR ,P?SOUTH>
		       <TELL "You slither out the back way, wondering why you never see any live dogs hanging around this restaurant" ,PCR>
		       <>)
		      (<AND <G? ,MEAL-STATE ,MS-ORDERED-FROM-WAITRESS>
			    <N==? ,MEAL-STATE ,MS-PAID-FOR-FOOD>>
		       <DEQUEUE I-WAITER-ARRIVES>
		       <I-WAITER-ARRIVES T>
		       T)
		      (ELSE
		       <TELL "You push your way out of the restaurant" ,PCR>
		       <>)>)
	       (<EQUAL? .CONTEXT ,M-ENTERING>
		<COND (<==? ,MEAL-STATE ,MS-PAID-FOR-FOOD>
		       <>)
		      (<==? ,MEAL-STATE ,MS-RECEIVED-FOOD>
		       ;"Re-entering after having eaten without paying."
		       <QUEUE-WAITER>
		       <>)
		      (<==? ,MEAL-STATE ,MS-ORDERED-FROM-WAITRESS>
		       <QUEUE-WAITER>
		       <>)
		      (T
		       <QUEUE-WAITRESS>
		       <COND (<IS? ,KITCHEN-DOOR ,OPENED>
			      <UNMAKE ,KITCHEN-DOOR ,OPENED>
			      <TELL CR "You hear a door slam shut in the back" 
				    ,PCR>)>
		       <>)>)
	       (<==? .CONTEXT ,M-BEG>
		<COND (<VERB? SIT>
		       <TELL "You're not unnaturally assuming that all
restaurants have places to sit. This one doesn't. But don't worry about
it, you won't want to linger over your meal." CR>
		       T)>)
	       (<T? .CONTEXT> <>)
	       (<HERE? DINER>
		<HERE-F>)
	       (<ENTERING?>
		<COND (<HERE? ST-B>
		       <DO-WALK ,P?EAST>
		       T)
		      (<HERE? IN-ALLEY>
		       <DO-WALK ,P?NORTH>
		       T)
		      (T <>)>)
	       (T
		<>)>>

<OBJECT FOOD
	(LOC LOCAL-GLOBALS)
	(DESC "your meal")
	(FLAGS NODESC NOARTICLE)
	(SYNONYM FOOD HAMBURGER BURGER SANDWICH MEAL FRIES
	 DRINK BEER WINE SODA)
	(ACTION FOOD-F)>

<DEFINE FOOD-F ()
  <COND (<VERB? WAIT-FOR>
	 <TELL "A marvellous idea. And, of course, it's exactly what they ">
	 <ITALICIZE "want">
	 <TELL " you to do." CR>
	 T)
	(<VERB? REQUEST EAT BUY>
	 <COND (<==? ,MEAL-STATE ,MS-ORDERED-FROM-WAITER>
		<COND (<VERB? REQUEST>
		       <TELL "You already did. Or are you trying to play ">
		       <ITALICIZE "Amnesia">
		       <TELL "?" CR>)
		      (ELSE
		       <TELL ,CANT "eat it until you've got it." CR>)>)
	       (<G=? ,MEAL-STATE ,MS-RECEIVED-FOOD>
		<TELL "You've already got whatever you're going to get."
		      CR>)
	       (T
		<TELL
		 "You'll just have to wait for someone to take your order."
		 CR>)>
	 T)
	(<G=? ,MEAL-STATE ,MS-RECEIVED-FOOD>
	 <TELL "We'll admit that you didn't get everything you ordered, but
at least the service was prompt." CR>)
	(ELSE
	 <TELL "What food? Come on, ">
	 <ITALICIZE "what">
	 <TELL " food? We've just about had enough of this. We're up to ">
	 <ITALICIZE "here">
	 <TELL " with it. Most people would have finished by now, but you? Oh, good grief." CR>
	 T)>>

<DEFINE QUEUE-WAITER ()
	 <COND (<AND <G=? ,MEAL-STATE ,MS-ORDERED-FROM-WAITRESS>
		     <L? ,MEAL-STATE ,MS-PAID-FOR-FOOD>>
		<SETG P-HIM-OBJECT ,NOT-HERE-OBJECT>
		<COND (<QUEUED? I-WAITER-ARRIVES>
		       <DEQUEUE I-WAITER-ARRIVES>)>
		<QUEUE I-WAITER-ARRIVES 2>)>
	 <>>

<DEFINE QUEUE-WAITRESS ()
	 <SETG P-HER-OBJECT ,NOT-HERE-OBJECT>
	 <QUEUE I-WAITRESS-ARRIVES 2>
	 <>>

<OBJECT KITCHEN-DOOR
	(LOC LOCAL-GLOBALS)
	(DESC "back door")
	(FLAGS NODESC DOORLIKE OPENABLE)
	(SYNONYM DOOR DOORWAY)
	(ADJECTIVE CLOSED SHUT BACK)
	(ACTION KITCHEN-DOOR-F)>

<DEFINE KITCHEN-DOOR-F ()
	 <COND (<THIS-PRSI?>
		<>)
	       (<AND <VERB? EXAMINE LOOK-ON>
		     <HERE? IN-ALLEY>>
		<EXAMINE-KITCHEN-DOOR>
		T)
	       (<AND <VERB? OPEN>
		     <NOT <IS? ,PRSO ,OPENED>>
		     <HERE? IN-ALLEY>>
		<EXAMINE-KITCHEN-DOOR>
		T)
	       (<ENTERING?>
		<COND (<HERE? DINER>
		       <DO-WALK ,P?SOUTH>)
		      (T
		       <DO-WALK ,P?NORTH>)>
		T)
	       (T
		<>)>>

<DEFINE EXAMINE-KITCHEN-DOOR ()
	 <TELL "The">
	 <OPEN-CLOSED <> <>>
	 <TELL " has no handle on this side." CR>>

"*** FARM ***"

<OBJECT OUTSIDE-FARM
	(LOC ROOMS)
	(DESC "Street")
	(SDESC SAY-STREET-ADDRESS)
	(THINGS PARSE-RANDOM-LOC-VEC)
	(FLAGS IN-TOWN LIGHTED LOCATION NOARTICLE)
	(NORTH PER OUTSIDE-FARM-N)
	(WEST TO IN-FARM IF FARM-DOOR IS OPEN)
	(EAST SORRY "You have no objection to having your path blocked by such nice trees. You also have no choice.")
	(IN TO IN-FARM IF FARM-DOOR IS OPEN)
	(SOUTH PER OUTSIDE-FARM-S)
	(GLOBAL FARM-DOOR STREETNUMBERS GSTREET CAB CAB-DRIVER IN-FARM)
	(STADDR 71)
	(ACTION OUTSIDE-FARM-F)>

<DEFINE OUTSIDE-FARM-S ()
	 <COND (<SPY-STILL-HERE?>
		<>)
	       (T
		,OUTSIDE-FORT)>>

<DEFINE OUTSIDE-FARM-N ()
	 <COND (<SPY-STILL-HERE?>
		<>)
	       (T
		,OUTSIDE-MANSION)>>

<DEFINE SPY-STILL-HERE? ()
	 <COND (<IN? ,SPY ,HERE>
		<TELL "You hesitate when " THE ,SPY
		      " clears his throat." CR>
		<I-SPY>
		T)
	       (T
		<>)>>

<DEFINE OUTSIDE-FARM-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL "A modest, ochre-and-aubergine striped llama-farm farmhouse stands to the west, its "
		      D ,FARM-DOOR>
		<COND (<IS? ,FARM-DOOR ,OPENED>
		       <TELL " wide open">)
		      (ELSE
		       <TELL " closed">)>
		<TELL ". The street continues north and south" ,PERIOD>
		T)
	       (<EQUAL? .CONTEXT ,M-ENTERED>
		<COND (<IN? ,SPY ,OUTSIDE-FARM>
		       <SETG P-HIM-OBJECT ,SPY>)
		      (<IN? ,SPY ,IN-FARM>
		       <MOVE ,SPY ,OUTSIDE-FARM>
		       <SETG P-HIM-OBJECT ,SPY>
		       <TELL CR CTHE ,SPY
			     " follows you out of the farmhouse." CR>
		       T)
		      (T
		       <>)>)
	       (T
		<>)>>

<OBJECT IN-FARM
	(LOC ROOMS)
	(DESC "farmhouse")
	(SYNONYM FARM FARMHOUSE HOUSE)
	(ADJECTIVE FARM)
	(FLAGS IN-TOWN NO-NERD LIGHTED LOCATION INDOORS)
	(EXIT-TO OUTSIDE-FARM)
	(ENTER-FROM <PTABLE P?WEST OUTSIDE-FARM>)
	(EAST TO OUTSIDE-FARM)
	(OUT TO OUTSIDE-FARM)
	(IN SORRY "You're already inside as far as you can go.")
	(GLOBAL FARM-DOOR)
	(ACTION IN-FARM-F)>

<DEFINE NOISE-AT-DOOR ()
	 <TELL "A sound at the door makes you hesitate." CR>
	 T>

<DEFINE IN-FARM-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL 
"You're in the ochre-and-aubergine llama-farm farmhouse. The place has obviously been ransacked. The exit is to the east." CR>
		T)
	       (<EQUAL? .CONTEXT ,M-ENTERED>
		<COND (<T? ,END-GAME?> <>)
		      (<NOT <IS? ,SPY ,SEEN>>
		       <QUEUE I-SPY>
		       <>)
		      (<IN? ,SPY ,OUTSIDE-FARM>
		       <MOVE ,SPY ,IN-FARM>
		       <SETG P-HIM-OBJECT ,SPY>
		       <TELL CR CTHE ,SPY " follows you inside." CR>
		       T)
		      (T
		       <>)>)
	       (<==? .CONTEXT ,M-EXIT>
		<COND (<NOT <IS? ,FARM-DOOR ,OPENED>>
		       <ITS-CLOSED ,FARM-DOOR>
		       T)
		      (<NOT <IS? ,SPY ,SEEN>>
		       <NOISE-AT-DOOR>
		       T)
		      (<IN? ,SPY ,IN-FARM>
		       <TELL "You push past " THE ,SPY ,PCR>
		       <>)
		      (T <>)>)
	       (<T? .CONTEXT> <>)
	       (<HERE? IN-FARM>
		<HERE-F>)
	       (<AND <ENTERING?>
		     <HERE? OUTSIDE-FARM>>
		<DO-WALK ,P?WEST>)
	       (<VERB? EXAMINE LOOK-ON>
		<COND (<HERE? IN-FARM>
		       <PERFORM ,V?LOOK>)
		      (T
		       <HERE? OUTSIDE-FARM>
		       <TELL "It's just a normal, puce 'n' tangerine striped
suburban llama-farmer's house. Its " D ,FARM-DOOR " is ">
		       <COND (<IS? ,FARM-DOOR ,OPENED>
			      <TELL "open">)
			     (T
			      <TELL "closed">)>
		       <TELL ,PERIOD>)>)
	       (T
		<>)>>

"*** MANSION ***"

<OBJECT OUTSIDE-MANSION
	(LOC ROOMS)
	(DESC "Street")
	(THINGS PARSE-RANDOM-LOC-VEC)
	(SYNONYM MANSION HOUSE HOME BUILDING NOARTICLE)
	(ADJECTIVE DILAPIDATED OLD)
	(SDESC SAY-STREET-ADDRESS)
	(FLAGS IN-TOWN LIGHTED LOCATION NOARTICLE)
	(NORTH TO OUTSIDE-HOUSE)
	(SEE-E OUTSIDE-MANSION)
	(SEE-S OUTSIDE-FARM)
	(SEE-N OUTSIDE-HOUSE)
	(WEST SORRY "Trees block your path.")
	(SOUTH TO OUTSIDE-FARM)
	(EAST PER ENTER-MANSION)
	(IN PER ENTER-MANSION)
	(GLOBAL MANSION-DOOR STREETNUMBERS GSTREET RADIO CAB CAB-DRIVER)
	(HEAR RADIO)
	(STADDR 70)
	(ACTION OUTSIDE-MANSION-F)>

<DEFINE ENTER-MANSION ()
	 <COND (<IS? ,MANSION-DOOR ,OPENED>
		<THIS-IS-IT ,MATRON>
		<TELL CTHE ,MATRON " is standing in your way." CR>)
	       (T
		<ITS-CLOSED ,MANSION-DOOR>)>
	 <>>

<DEFINE OUTSIDE-MANSION-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL 
"You're standing west of a mansion; its rather ornate door is ">
		<COND (<IS? ,MANSION-DOOR ,OPENED>
		       <TELL "open">)
		      (T
		       <TELL "closed">)>
		<TELL ". The road continues north and south." CR>
		<MENTION-RECORDING>
		T)
	       (<EQUAL? .CONTEXT ,M-ENTERED>
		<QUEUE I-RADIO>
		<COND (<IN? ,MATRON ,OUTSIDE-MANSION>
		       <THIS-IS-IT ,MATRON>)>
		T)
	       (<T? .CONTEXT> <>)
	       (<THIS-PRSI?> <>)
	       (<ENTERING?>
		<COND (<HERE? BEHIND-MANSION IN-PORCH>
		       <DO-WALK ,P?WEST> T)
		      (<HERE? OUTSIDE-MANSION>
		       <DO-WALK ,P?EAST> T)
		      (<HERE? TROPHY-ROOM>
		       <ALREADY-IN> T)
		      (T <>)>)
	       (<EXITING?>
		<COND (<HERE? IN-PORCH>
		       <DO-WALK ,P?EAST>)
		      (<HERE? TROPHY-ROOM>
		       <DO-WALK ,P?NORTH ,P?EAST>)
		      (T <NOT-IN>)>
		T)
	       (<HERE? IN-PORCH TROPHY-ROOM>
		<HERE-F>)
	       (T
		<>)>>

<DEFINE MENTION-RECORDING ("AUX" (X <>))
	 <CRLF>
	 <COND (<PROB 50>
		<SET X T>
		<TELL "A recording of ">)
	       (T
		<TELL "You can hear ">)>
	 <SAY-MUZAK>
	 <TUNE-MENTIONED? T>
	 <COND (<T? .X>
		<TELL " is">)>
	 <TELL " playing in the mansion." CR>
	 T>

<OBJECT FENCE
	(LOC LOCAL-GLOBALS)
	(DESC "fence")
	(ACTION FENCE-F)
	(SYNONYM FENCE GAP)
	(ADJECTIVE TALL)
	(FLAGS NODESC)>

<DEFINE FENCE-F ()
  <COND (<THIS-PRSI?> <>)
	(<VERB? EXAMINE>
	 <TELL "It's just your average unclimbable fence. There does seem to
be a body-sized gap in it." CR>)
	(<VERB? ENTER THROUGH>
	 <COND (<HERE? BEHIND-MANSION>
		<DO-WALK ,P?NORTH>)
	       (<HERE? IN-ALLEY>
		<DO-WALK ,P?SOUTH>)>)
	(<VERB? CLIMB-OVER CLIMB-UP>
	 <TELL ,CANT "climb the fence." CR>)
	(T <>)>>

<OBJECT BEHIND-MANSION
	(LOC ROOMS)
	(DESC "behind mansion")
	(FLAGS IN-TOWN NO-NERD LIGHTED LOCATION)
	(THINGS PARSE-RANDOM-LOC-VEC)
	(EXIT-TO IN-ALLEY)
	(NORTH PER BEHIND-MANSION-N)
	(EAST SORRY "The fence blocks your path.")
	(IN TO IN-PORCH IF PORCH-DOOR IS OPEN)
	(SOUTH SORRY "The fence blocks your path.")
	(WEST TO IN-PORCH IF PORCH-DOOR IS OPEN)
	(GLOBAL PORCH-DOOR FENCE RADIO)
	(HEAR RADIO)
	(ACTION BEHIND-MANSION-F)>

<DEFINE BEHIND-MANSION-N ()
	 <TELL "You squeeze through the gap" ,PCR>
	 ,IN-ALLEY>

<DEFINE BEHIND-MANSION-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL "You're in the back garden of a mansion. You can enter the house through a door to the west, and there's a gap in the fence to the north." CR>
		<MENTION-RECORDING>
		T)
	       (<EQUAL? .CONTEXT ,M-ENTERED>
		<QUEUE I-RADIO>
		T)
	       (T
		<>)>>

<OBJECT IN-PORCH
	(LOC ROOMS)
	(DESC "porch")
	(FLAGS IN-TOWN NO-NERD LIGHTED LOCATION INDOORS)
	(SYNONYM PORCH)
	(THINGS PARSE-RANDOM-LOC-VEC)
	(EXIT-TO BEHIND-MANSION)
	(ENTER-FROM <PTABLE P?WEST BEHIND-MANSION>)
	(OUT TO BEHIND-MANSION IF PORCH-DOOR IS OPEN)
	(EAST TO BEHIND-MANSION IF PORCH-DOOR IS OPEN)
	(IN TO TROPHY-ROOM)
	(SOUTH TO TROPHY-ROOM)
	(GLOBAL PORCH-DOOR PMATRON RADIO)
	(HEAR RADIO)
	(ACTION IN-PORCH-F)>

<DEFINE IN-PORCH-F ("OPTIONAL" (CONTEXT <>) "AUX" (SOMETHING <>))
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL "Welcome to the porch. It is a porch. Doors from this porch lead south and east. The overall effect is rather porchy." CR>
		<MENTION-RECORDING>
		T)
	       (<EQUAL? .CONTEXT ,M-ENTERED>
		<SETG P-HIM-OBJECT ,MACAW>
		<>)
	       (<==? .CONTEXT ,M-ENTERING>
		<COND (<ZERO? <ZGET ,MACAW-TABLE ,MACAW-POLITICS>>
		       <COND (<PROB 50>
			      <ZPUT ,MACAW-TABLE ,MACAW-POLITICS ,MACAW-RIGHT>
			      <ZPUT <GETPT ,PAINTING ,P?SYNONYM>
				    0 ,W?GORBACHEV>)
			     (ELSE
			      <ZPUT <GETPT ,PAINTING ,P?SYNONYM> 0 ,W?REAGAN>
			      <ZPUT ,MACAW-TABLE ,MACAW-POLITICS
				    ,MACAW-LEFT>)>)>)
	       (<EQUAL? .CONTEXT ,M-EXIT>
		<UNMAKE ,MACAW ,SEEN>
		<>)
	       (<==? .CONTEXT ,M-BEG>
		<COND (<AND <VERB? EXAMINE LOOK-ON SEARCH>
			    <PRSO? GROUND>>
		       <COND (<T? <FIND-NEXT ,HERE T
					     ,GROUND-PRINT-CONTENTS-TEST>>
			      <SET SOMETHING T>
			      <TELL ,YOU-SEE>
			      <PRINT-CONTENTS ,HERE
					      ,GROUND-PRINT-CONTENTS-TEST>
			      <TELL " on the " D ,GROUND ".">)>
		       <COND (<FIRST? ,UNDER-PERCH>
			      <COND (.SOMETHING
				     <TELL " You also see ">)
				    (T
				     <TELL ,YOU-SEE>)>
			      <SET SOMETHING T>
			      <PRINT-CONTENTS ,UNDER-PERCH>
			      <TELL " under " THE ,PERCH ".">)>
		       <ZCRLF>)>)
	       (<T? .CONTEXT> <>)
	       (<HERE? IN-PORCH>
		<HERE-F>)
	       (<ENTERING?>
		<COND (<HERE? BEHIND-MANSION>
		       <DO-WALK ,P?WEST> T)
		      (<HERE? TROPHY-ROOM>
		       <DO-WALK ,P?EAST> T)
		      (T <>)>)
	       (T
		<>)>>

<OBJECT TROPHY-ROOM
	(LOC ROOMS)
	(DESC "trophy room")
	(THINGS PARSE-RANDOM-LOC-VEC)
	(EXIT-TO IN-PORCH)
	(ENTER-FROM <PTABLE P?SOUTH IN-PORCH>)
	(SYNONYM ROOM)
	(ADJECTIVE TROPHY)
	(FLAGS IN-TOWN NO-NERD LIGHTED LOCATION INDOORS)
	(OUT TO IN-PORCH)
	(NORTH TO IN-PORCH)
	(WEST SORRY "Come off it. Just look at that elephant gun. (By the way, what would an elephant be doing with a gun?)")
	(IN PER WHICH-WAY-IN)
	(GLOBAL MHALL PMATRON RADIO MANSION-DOOR)
	(HEAR RADIO)
	(ACTION TROPHY-ROOM-F)>

<DEFINE TROPHY-ROOM-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL ,THIS-IS
"the trophy room. You'd expect to see defunct lions, or at least school
debating awards, but don't. The reason why is a technical secret. Exits lead north and west." CR>
		<MENTION-RECORDING>
		T)
	       (<EQUAL? .CONTEXT ,M-ENTERED>
		<COND (<NOT <IN? ,MATRON ,TROPHY-ROOM>>
		       <THIS-IS-IT ,PMATRON>
		       <>)
		      (T
		       <THIS-IS-IT ,MATRON>
		       <COND (<NOT <IS? ,MATRON ,ANSWERING-DOOR>>
			      <QUEUE I-ROBBERS 2>
			      <TELL CR
				    "As you walk into the room " THE ,MATRON
				    " peers balefully in your direction and raises "
				    THE ,EGUN ". \"Robbers!\"" CR>
			      T)
			     (T
			      <>)>)>)
	       (<T? .CONTEXT> <>)
	       (<HERE? TROPHY-ROOM>
		<HERE-F>)
	       (<ENTERING?>
		<COND (<HERE? IN-PORCH>
		       <DO-WALK ,P?SOUTH> T)
		      (T <>)>)
	       (T
		<>)>>

"*** TENEMENT ***"

<OBJECT THALL
	(LOC ROOMS)
	(DESC "hallway")
	(THINGS PARSE-RANDOM-LOC-VEC)
	(EXIT-TO ST-A)
	(FLAGS IN-TOWN NO-NERD LIGHTED LOCATION INDOORS)
	(UP PER THALL-U)
	(OUT TO ST-A)
	(WEST TO ST-A)
	(SOUTH TO IN-FLAT IF FLAT-DOOR IS OPEN)
	(IN TO IN-FLAT IF FLAT-DOOR IS OPEN)
	(GLOBAL TEN-STAIR FLAT-DOOR FLAT)
	(SYNONYM HALLWAY HALL CORRIDOR TENEMENT BUILDING TENEMENTS)
	(ACTION THALL-F)>

<DEFINE THALL-F ("OPT" CONTEXT)
  <COND (<==? .CONTEXT ,M-LOOK>
	 <TELL "You're in a dark, dank, drab hallway. Grey, greasy stone stairs lead up, and an exit (the door long ago ripped off by drunken opera critics) leads west. There's a">
	 <OPEN-CLOSED ,FLAT-DOOR>
	 <TELL " in the south wall." CR>)
	(<T? .CONTEXT> <>)
	(<HERE? IN-FLAT THALL>
	 <HERE-F>)
	(<ENTERING?>
	 <COND (<HERE? ST-A> <DO-WALK ,P?EAST> T)
	       (<HERE? IN-FLAT THALL>
		<ALREADY-THERE>)
	       (T <>)>)
	(T
	 <HERE-F>)>>

<DEFINE THALL-U ()
	 <TELL "About halfway up, you encounter a wall, blank but for
a sign: \"Property of Random Q. Hacker. Keep out. This means you!\" Taking
our word for its impenetrability, you utter a disgruntled cry of \"Foo!\" and return to the hallway." CR>
	 <>>

<OBJECT IN-FLAT
	(LOC ROOMS)
	(DESC "flat")
	(FLAGS IN-TOWN NO-NERD LIGHTED LOCATION INDOORS)
	(THINGS PARSE-RANDOM-LOC-VEC)
	(EXIT-TO THALL)
	(OUT TO THALL IF FLAT-DOOR IS OPEN)
	(NORTH TO THALL IF FLAT-DOOR IS OPEN)
	(IN SORRY "You're already in as far as you want to go, and as far as we'll let you.")
	(GLOBAL FLAT FLAT-DOOR THALL)
	(ACTION IN-FLAT-F)>

<DEFINE IN-FLAT-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL "You're in a dingy flat which smells of old tea bags. A blistered green door leads north." CR>
		T)
	       (<EQUAL? .CONTEXT ,M-ENTERED>
		<COND (<NOT <IN? ,MOUSY ,IN-FLAT>>
		       <>)
		      (T
		       <SETG MOUSY-SCRIPT ,RESET-MOUSY-SCRIPT>
		       <QUEUE I-MOUSY>
		       <TELL CR "The little man glances up as you enter. \"">
		       <COND (<IS? ,MOUSY ,TOUCHED>
			      <TELL "You again. What is it now">)
			     (T
			      <TELL "Hi, ">
			      <GENDER-PRINT "mister" "lady">
			      <TELL ". Can I help you">)>
		       <TELL "?\" he asks in a preoccupied tone." CR>
		       T)>)
	       (<EQUAL? .CONTEXT ,M-EXIT>
		<COND (<IN? ,MOUSY ,IN-FLAT>
		       <LEAVE-MOUSY>
		       <TELL 
"\"Pip-pip,\" murmurs the man as you leave" ,PCR>
		       <>)
		      (T
		       <>)>)
	       (T
		<>)>>

"*** DEATH ***"

<OBJECT DEATH
	(LOC ROOMS)
	(DESC "Death")
	(FLAGS NO-NERD LIGHTED LOCATION)
	(LDESC "You are dead.")>

<DEFINE POLICE ()
	 <TELL CR CR 
"After one of those really deeply awkward social encounters, you are hauled off to a nearby gaol where you beat yourself up in remorse, knee yourself in the groin and viciously assault a lot of policemen's feet with your nose.">
	 <JIGS-UP>
	 T>

<DEFINE JIGS-UP ("OPT" (END? <>) "AUX" WORD)
	 <COND (<F? .END?>
		<SETG BP 0>
		<SETG HERE ,DEATH>
		<MOVE ,PLAYER ,HERE>
		; "this is here to make C64 interpreter happy"
		<TELL CR CR>
		<DISPLAY-PLACE>
		<DISPLAY-BP>
		<SETG WINNER ,PLAYER>
		<V-LOOK>
		<ZCRLF>)>
	 <V-SCORE>
	 <TELL CR 
"Do you want to RESTORE a previously saved position, RESTART from the beginning, or QUIT?" CR CR>
	 <REPEAT ()
		 <TELL "[Type RESTORE, RESTART or QUIT.] >">
		 <PUTB ,YES-LEXV 0 4>
		 <READ ,YES-INBUF ,YES-LEXV>
	         <SET WORD <ZGET ,YES-LEXV ,P-LEXSTART>>
		 <COND (<ZERO? <GETB ,YES-LEXV ,P-LEXWORDS>>
			T)
		       (<EQUAL? .WORD ,W?RESTORE>
		        <V-RESTORE>)
		       (<EQUAL? .WORD ,W?RESTART>
			<RESTART>
		        <FAILED "RESTART">)
		       (<EQUAL? .WORD ,W?QUIT ,W?Q>
			<CRLF>
			<QUIT>)>>
	 T>

