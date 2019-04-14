"THINGS for BUREAUCRACY: Copyright 1987 Infocom, Inc. All rights reserved."

<FILE-FLAGS MDL-ZIL?>

<INCLUDE "OLD-PARSERDEFS">
<INCLUDE "XXJETDEFS">
<INCLUDE "FORMDEFS">
<INCLUDE "BANKDEFS">

<OBJECT QUEEN-MUM
	(LOC GLOBAL-OBJECTS)
	(DESC "Queen Mum")
	(FLAGS NOARTICLE NODESC)
	(SYNONYM MUM)
	(ADJECTIVE QUEEN)>

<OBJECT FROOM-DOOR
	(LOC LOCAL-GLOBALS)
	(DESC "front door")
	(FLAGS NODESC DOORLIKE OPENABLE)
	(SYNONYM DOOR DOORWAY)
	(ADJECTIVE CLOSED SHUT FRONT)
	(GENERIC GDOOR-F)
	(ACTION FROOM-DOOR-F)>

"TOUCHED = DMAN seen or left."

<DEFINE FROOM-DOOR-F FDF ()
	 <COND (<THIS-PRSI?>
		<RETURN <> .FDF>)>
	 <COND (<AND <==? ,HERE ,BROOM>
		     <NOT <VERB? EXAMINE>>>
		<GOTO ,FROOM>)>
	 <COND (<==? ,HERE ,BROOM>
		<CANT-SEE-ANY ,FROOM-DOOR>
		<RETURN ,FATAL-VALUE .FDF>)>
	 <COND (<VERB? REPLY>
		<COND (<NOT <IS? ,PRSO ,TOUCHED>>
		       <COND (<N==? ,HERE ,FROOM>
			      <TELL "You're outside the house." CR>
			      <RETURN T .FDF>)
			     (T
			      <DMAN-APPEARS>)>)
		      (T
		       <TELL "You are having a hallucination. Nobody's trying to get in." CR>)>
		T)
	       (<VERB? WALK-TO>
		<PERFORM ,V?REPLY ,PRSO>)
	       (<AND <VERB? OPEN>
		     <NOT <IS? ,PRSO ,OPENED>>
		     <NOT <IS? ,PRSO ,TOUCHED>>>
		<DMAN-APPEARS>
		T)
	       (<VERB? CLOSE>
		<COND (<QUEUED? I-DMAN>
		       <DMAN-LEAVES>
		       <TELL "You slam " THE ,FROOM-DOOR " in " THE ,DMAN "'s face. You can hear him muttering a traditional llama-food delivery man's curse upon you, your family and your llamas as he walks away." CR>)
		      (ELSE
		       <>)>)
	       (<ENTERING?>
		<COND (<HERE? FROOM>
		       <DO-WALK ,P?EAST>)
		      (T
		       <DO-WALK ,P?WEST>)>
		T)
	       (<VERB? LOCK>
		<TELL "As you may have noticed, you don't have keys. You ">
		<ITALICIZE "should">
		<TELL " have keys, but they don't appear to have been delivered. Better leave it unlocked." CR>
		T)
	       (T
		<>)>>

<OBJECT DOORBELL
	(LOC LOCAL-GLOBALS)
	(DESC "doorbell")
	(FLAGS NODESC)
	(SYNONYM DOORBELL BELL)
	(ADJECTIVE DOOR)
	(ACTION DOORBELL-F)>

<DEFINE DOORBELL-F ("AUX" X)
	 <COND (<VERB? REPLY>
		<COND (<NOT <IS? ,FROOM-DOOR ,TOUCHED>>
		       <COND (<HERE? FROOM>
			      <SET X <PERFORM ,V?OPEN ,FROOM-DOOR>>)
			     (T
			      <CANT-FROM-HERE>)>)
		      (T
		       <TELL CTHEO " isn't ringing anymore." CR>)>
		T)
	       (<AND <VERB? LISTEN>
		     <NOT <IS? ,PRSO ,TOUCHED>>>
		<I-DOORBELL <>>
		,FATAL-VALUE)
	       (<OR <SEEING?>
		    <TOUCHING?>>
		<TELL ,CANT "find " THEO ". It's really amazingly
cleverly concealed. Really ">
		<ITALICIZE "incredibly">
		<TELL " cleverly concealed." CR>
		,FATAL-VALUE)
	       (<VERB? RING>
		<CANT-FROM-HERE>
		T)
	       (T
		<>)>>

<OBJECT GSTREET
	(LOC LOCAL-GLOBALS)
	(DESC "street")
	(FLAGS NODESC)
	(SYNONYM STREET ROAD)
	(ACTION HERE-F)>

<OBJECT WRISTWATCH
	(LOC PLAYER)
	(DESC "digital wristwatch")
	(FLAGS TAKEABLE CLOTHING WORN)
	(SYNONYM WRISTWATCH WATCH CLOCK TIME)
	(ADJECTIVE WRIST MY DIGITAL)
	(SIZE 1)
	(GENERIC 0)
	(ACTION WRISTWATCH-F)>

<DEFINE WRISTWATCH-F ()
	 <COND (<THIS-PRSI?>
		<COND (<PUTTING?>
		       <PRSO-SLIDES-OFF-PRSI>
		       T)
		      (T
		       <>)>)
	       (<VERB? READ LOOK-ON EXAMINE USE>
		<V-TIME>
		T)
	       (<VERB? OPEN OPEN-WITH ADJUST>
		<FORGOT-HOW>
		T)
	       (<VERB? TURN-TO>
		<COND (<PRSI? INTNUM INTDIR>
		       <FORGOT-HOW>
		       T)
		      (T
		       <IMPOSSIBLE>)>
		T)
	       (<VERB? CLOSE>
		<ITS-ALREADY "closed">
		T)
	       (T
		<>)>>
		     		       
<DEFINE FORGOT-HOW ()
	 <TELL "You never bothered to read the instructions about how to work your " D ,PRSO
	       " and so you don't know how to work it." CR>>

<OBJECT YOUR-HOUSE
	(LOC GLOBAL-OBJECTS)
	(DESC "your new house")
	(FLAGS NODESC NOARTICLE PLACE)
	(SYNONYM HOUSE HOME)
	(ADJECTIVE MY MINE YOUR NEW BIG)
	(GENERIC GENERIC-YOUR-HOUSES-F)
	(ACTION YOUR-HOUSE-F)>

<DEFINE YOUR-HOUSE-F ()
	 <COND (<HERE? FROOM BROOM>
		<COND (<HERE-F>
		       T)
		      (T
		       <>)>)
	       (<ENTERING?>
		<COND (<HERE? OUTSIDE-HOUSE>
		       <DO-WALK ,P?WEST>)
		      (<IS? ,HERE ,IN-TOWN>
		       <PERFORM-WALK-TO ,FROOM>)
		      (T
		       <V-WALK-AROUND>)>
		T)
	       (<NOT <HERE? OUTSIDE-HOUSE>>
		<CANT-FROM-HERE>
		T)
	       (T
		<>)>>

<DEFINE GENERIC-YOUR-HOUSES-F (TBL)
	 ,YOUR-HOUSE>

<OBJECT OLD-HOUSE
	(LOC GLOBAL-OBJECTS)
	(DESC "your old house")
	(FLAGS NODESC NOARTICLE PLACE)
	(SYNONYM HOUSE HOME)
	(ADJECTIVE MY MINE YOUR OLD PREVIOUS)
	(GENERIC GENERIC-YOUR-HOUSES-F)
	(ACTION OLD-HOUSE-F)>		

<DEFINE OLD-HOUSE-F ()
	 <COND (<ENTERING?>
		<TELL "No chance. The new owner's lawyers would sue your eyes out if you did any such thing." CR>
		T)
	       (T
		<>)>>

<OBJECT YOUR-WINDOWS
	(LOC LOCAL-GLOBALS)
	(DESC "window")
	(FLAGS NODESC)
	(SYNONYM WINDOW WINDOWS PANE)
	(ADJECTIVE WINDOW)
	(ACTION YOUR-WINDOWS-F)>

<DEFINE YOUR-WINDOWS-F ()
	 <COND (<THIS-PRSI?>
		<COND (<VERB? THROW>
		       <WASTE-OF-TIME>
		       T)
		      (T
		       <>)>)
	       (<VERB? LOOK-INSIDE LOOK-OUTSIDE LOOK-BEHIND>
		<CANT-SEE-MUCH>
		T)
	       (<VERB? OPEN OPEN-WITH>
		<TELL "No dice. " CTHEO
		      " is too stiff. Shouldn't be, but it is."CR>
		T)
	       (<VERB? CLOSE>
		<TELL "It isn't open." CR>
		T)
	       (<HURTING?>
		<WASTE-OF-TIME>
		T)
	       (<OR <EXITING?>
		    <ENTERING?>>
		<TELL CTHEO " is closed, and it is against the local ordinances to break it."
		      CR>)
	       (T
		<>)>>

<DEFINE HANDLE-ROOM? (R D)
	 <COND (<THIS-PRSI?>
		<>)
	       (<HERE? .R>
		<COND (<HERE-F>
		       T)
		      (T
		       <>)>)
	       (<VERB? WALK-TO> <>)
	       (<ENTERING?>
		<DO-WALK .D>
		T)
	       (T
		<>)>>

<OBJECT LANDF-DOOR
	(LOC LOCAL-GLOBALS)
	(DESC "office doorway")
	(FLAGS NODESC VOWEL)
	(SYNONYM DOOR DOORWAY)
	(ADJECTIVE OFFICE)
	(ACTION LANDF-DOOR-F)>

<DEFINE LANDF-DOOR-F ()
	 <COND (<THIS-PRSI?>
		<>)
	       (<ENTERING?>
		<COND (<HERE? AIRPORT-ENTRANCE>
		       <DO-WALK ,P?SOUTH>)
		      (T
		       <DO-WALK ,P?NORTH>)>
		T)
	       (T
		<>)>>

<OBJECT BTABLE
	(LOC BROOM)
	(DESC "table")
	(FLAGS NOALL TRYTAKE SURFACE)
	(CAPACITY 50)
	(SYNONYM TABLE)
	(ACTION BTABLE-F)>

<DEFINE BTABLE-F ()
	 <COND (<THIS-PRSI?>
		<>)
	       (<MOVING?>
		<TELL CTHEO " is too big." CR>
		T)
	       (T
		<>)>>

<OBJECT WALLET
	(LOC POCKET)
	(DESC "wallet")
	(FLAGS TAKEABLE CONTAINER OPENABLE SEARCH-ME OPENED)
	(SYNONYM WALLET BILLFOLD)
	(ADJECTIVE CLOSED SHUT MY TACKY FLAKY)
	(CAPACITY 1)
	(ACTION WALLET-F)
	(CONTFCN IN-WALLET)>

<DEFINE IN-WALLET ("OPT" CONTEXT)
  <COND (<==? .CONTEXT ,M-CONT>
	 <COND (<NOT <IN? ,WALLET ,PLAYER>>
		<SAY-TAKING ,WALLET <>>
		<MOVE ,WALLET ,PLAYER>
		<MAKE ,WALLET ,OPENED>)>)>
  <>>

<DEFINE WALLET-F ()
	 <COND (<THIS-PRSI?>
		<>)
	       (<VERB? EXAMINE LOOK-ON>
		<TELL
"This deeply tacky wallet was sent to you free by the US Excess Credit Card Corporation to tell you how much a person like you needed a US Excess card, what with your busy thrusting lifestyle in today's fast-moving, computerised, jet-setting world. Needless to say, you already had a US Excess card which they were trying to take away from you for not paying your account, which, equally needless to say, you had paid weeks ago.|
|
At the moment, " THEO " is ">
		<COND (<IS? ,PRSO ,OPENED>
		       <TELL "open." CR>)
		      (T
		       <TELL "closed." CR>)>
		T)
	       (T
		<>)>>

<OBJECT BEEZER
	(LOC WALLET)
	(DESC "Beezer card")
	(FLAGS READABLE TAKEABLE)
	(SIZE 0)
	(SYNONYM CARD BEEZER CARDS)
	(ADJECTIVE BEEZER CREDIT PLASTIC YOUR MY)
	(GENERIC GENERIC-CARD-F)
	(ACTION BEEZER-F)>

<DEFINE GENERIC-CARD-F (TBL "AUX" LEN (I 0) (VAL <>))
	 <SET LEN <ZGET .TBL 0>>
	 <SET TBL <ZREST .TBL 2>>
	 <COND (<INTBL? ,P-IT-OBJECT .TBL .LEN>
		,P-IT-OBJECT)
	       (ELSE
		; "If the player is carrying only one card, pick that;
		   otherwise, give up."
		<REPEAT (CD)
			<SET CD <ZGET .TBL .I>>
			<COND (<IN? .CD ,PLAYER>
			       <COND (.VAL
				      <SET VAL <>>
				      <RETURN>)>
			       <SET VAL .CD>)>
			<COND (<G=? <SET I <+ .I 1>> .LEN>
			       <RETURN>)>>
		.VAL)>>

<DEFINE BEEZER-F ()
	 <COND (<THIS-PRSI?>
		<>)
	       (<VERB? EXAMINE LOOK-ON READ>
		<TELL
"It's just your ordinary, run-of-the-mill, plastic, embossed, hypnotic, lethal, devil-may-care " D ,PRSO
		      ,PERIOD>
		T)
	       (T
		<>)>>	       

<OBJECT EXCESS
	(LOC WALLET)
	(DESC "US Excess card")
	(FLAGS READABLE TAKEABLE)
	(SIZE 0)
	(SYNONYM CARD CARDS EXCESS HOLOGRAM YAK)
	(ADJECTIVE US EXCESS CREDIT PLASTIC YAK YOUR MY)
	(GENERIC GENERIC-CARD-F)
	(ACTION EXCESS-F)>

<DEFINE EXCESS-F EXCESS ()
	 <COND (<THIS-PRSI?>
		<RETURN <> .EXCESS>)
	       (<OR <NOUN-USED? ,W?HOLOGRAM ,W?YAK>
		    <ADJ-USED? ,W?YAK>>
		<COND (<OR <MOVING?>
			   <VERB? LOOK-UNDER LOOK-BEHIND>>
		       <TELL 
"Sorry. The yak hologram is permanently embossed onto the card, using the latest yak hologram embossing technology." CR>
		       <RETURN T .EXCESS>)
		      (<VERB? EXAMINE LOOK-ON READ>
		       <TELL "Looking at the benighted creature, you can tell why it's called a yak." CR>
		       <RETURN T .EXCESS>)>)>
	 <COND (<VERB? EXAMINE LOOK-ON READ>
		<TELL 
"It is a high-status Iridium US Excess card. When you produce it in expensive restaurants, ">
		<GENDER-PRINT "beautiful women" "handsome men">
		<TELL " realise that you are the sort of person who would like to have more money than brains. The card is embossed with your name, an improbably long number and a hologram of a yak. It expired last month." CR>
	        <UPDATE-BP 5>
		T)
	       (T
		<>)>>
		 

<OBJECT LETTER
	(LOC BTABLE)
	(DESC "letter")
	(FLAGS TAKEABLE READABLE)
	(SIZE 1)
	(SYNONYM LETTER PAPER PIECE)
	(ACTION LETTER-F)>

<DEFINE LETTER-F ()
         <COND (<THIS-PRSI?>
		<COND (<PUTTING?>
		       <WASTE-OF-TIME>
		       T)
		      (T
		       <>)>)
	       (<VERB? EXAMINE LOOK-ON READ>
		<LOOK-IN-PACKAGE>
		T)
	       (<VERB? RIP>
		<WASTE-OF-TIME>
		T)
	       (T
		<>)>>

<OBJECT COMPUTER
	(LOC BTABLE)
	(DESC "your Boysenberry computer")
	(FLAGS TAKEABLE NOARTICLE CONTAINER OPENED)
	(SIZE 5)
	(CAPACITY 0)
	(GENERIC JACK-GENERIC)
	(SYNONYM COMPUTER BOYSENBERRY SLOT SCREEN KEYBOARD JACK)
	(ADJECTIVE BOYSENBERRY MY MODULAR LAPTOP)
	(ACTION COMPUTER-F)>

<DEFINE COMPUTER-F ("AUX" X)
	 <COND (<NOUN-USED? ,W?SCREEN> <SCREEN-F>)
	       (<NOUN-USED? ,W?KEYBOARD> <KEYBOARD-F>)
	       (<AND <VERB? PLUG>
		     <THIS-PRSO?>
		     <F? ,PRSI>
		     <IN? ,MPLUG ,HERE>>
		<PERFORM ,V?PLUG ,MPLUG ,COMPUTER>)
	       (<OR <NOUN-USED? ,W?JACK>
		    <AND <VERB? PUT PLUG>
			 <PRSO? MPLUG>>>
		<JACK-F>)
	       (ELSE
		<COND (<THIS-PRSI?>
		       <COND (<VERB? PUT PLUG>
			      <COND (<NOT <IS? ,PRSO ,PROGRAM>>
				     <TELL 
				      "That would immediately void your Boysenberry warranty which, given the reliability of your miracle computer, you are unwilling to do." CR>)
				    (T
				     <SET X <FIRST? ,PRSI>>
				     <REPEAT ()
					     <COND (<ZERO? .X>
						    <MOVE ,PRSO ,PRSI>
						    <TELL CTHEO " slips into "
							  D ,PRSI
							  " with a thrilling little ">
						    <ITALICIZE "click...">
						    <ZCRLF>
						    <RUN-PROGRAM ,PRSO>
						    <RETURN>)
						   (<IS? .X ,PROGRAM>
						    <YOUD-HAVE-TO "take out"
								  .X>
						    <RETURN>)
						   (ELSE
						    <SET X <NEXT? .X>>)>>
				     T)>)
			     (T
			      <>)>)
		      (<VERB? LAMP-ON>
		       <COND (<SET X <FIRST? ,PRSO>>
			      <TELL "With a thrilling little ">
			      <ITALICIZE "click">
			      <TELL ", " D ,PRSO " comes back to life." CR>
			      <RUN-PROGRAM .X>
			      T)
			     (T
			      <TELL "Don't power up " D ,PRSO " unless it has some software to run." CR>)>)
		      (<VERB? LAMP-OFF>
		       <TELL "It's not on. Or possibly it's off. Hard to tell which." CR>)
		      (<VERB? EXAMINE>
		       <COND (<NOT <IS? ,PRSO ,SEEN>>
			      <MAKE ,PRSO ,SEEN>
			      <SETG DO-WINDOW ,BOYSENBERRY-WINDOW>)>
		       <TELL
		        ,THIS-IS "the remarkable Boysenberry laptop computer, made by a subsidiary of your old employers, the Deep Thought Corporation of America. There are no operating controls of any sort, not even an on/off switch. All you see are a tiny screen, a keyboard, a modular jack and a slot for program cartridges." CR>
		       T)
		      (T
		       <>)>)>>

<CONSTANT BOYSENBERRY-WINDOW
	  <PLTABLE 31
		  "The word \"Boysenberry,\" and  "
		  "the symbol of a partially    "
		  "digested purple berry, are   "
		  "trademarks of the Boysenberry"
		  "Business Engines Corporation.">>

<DEFINE SCREEN-F ()
	<COND (<THIS-PRSI?>
	       <COND (<VERB? PUT>
		      <COND (<IS? ,PRSO ,PROGRAM>
			     <TELL
			      "You really are computer illiterate, aren't you?" CR>)
			    (ELSE
			     <TELL "It might break." CR>)>)
		     (ELSE <>)>)
	      (<MOVING?>
	       <TELL "It is attached to " D ,COMPUTER ,PERIOD>)
	      (<VERB? LAMP-ON LAMP-OFF>
	       <TELL "Unlike more primitive machines, " D ,COMPUTER
		     " doesn't have an on-off switch for the screen." CR>)
	      (<VERB? EXAMINE LOOK-ON>
	       <TELL "The screen of " D ,COMPUTER " is blank" ,PERIOD>)
	      (ELSE <>)>>

<DEFINE KEYBOARD-F ()
	<COND (<THIS-PRSI?>
	       <COND (<VERB? PUT>
		      <COND (<IS? ,PRSO ,PROGRAM>
			     <TELL
			      "Welcome to the computer illiterates' club." CR>)
			    (ELSE
			     <TELL "It might break." CR>)>)
		     (ELSE <>)>)
	      (<MOVING?>
	       <TELL "It is attached to " D ,COMPUTER ,PERIOD>)
	      (<VERB? LAMP-ON LAMP-OFF>
	       <TELL "Please refer to " D ,COMPUTER ,PERIOD>)
	      (<VERB? EXAMINE LOOK-ON>
	       <TELL "It's just a keyboard. What did you expect? Dancing girls?" CR>)
	      (<VERB? TYPE USE>
	       <TELL "Oh, for heaven's sake. Would " ITAL "you"
		     " respond without a program running? Given, that is, that you were either a computer or an MIT graduate?" CR>)
	      (ELSE <>)>>

<DEFINE JACK-F ()
	<COND (<THIS-PRSI?>
	       <COND (<VERB? PUT PLUG>
		      <COND (<PRSO? MPLUG>
			     <TELL "With an irritating little ">
			     <ITALICIZE "click">
			     <TELL " (it used to be thrilling, but, quite
frankly, you have really had enough of the damned Boysenberry by now) your
portable computer lurches into action." CR>
			     <RUN-TELE-COMM>
			     <TELL CR CTHE ,MPLUG
				   " is automatically ejected from
the jack like a little rat from a tiny drainpipe." CR>
			     T)
			    (<IS? ,PRSO ,PROGRAM>
			     <TELL
			      "Oh, " ITAL "stop" " it. Don't be " ITAL "stupid" ". This is a " ITAL "computer" ,PERIOD>
			     T)
			    (ELSE
			     <TELL "It might break. In fact, it definitely "
				   ITAL "would"
				   " break. And no good bleating about product liability, either." CR>
			     T)>)
		     (ELSE <>)>)
	      (<MOVING?>
	       <TELL "It is attached to " D ,COMPUTER ,PERIOD>)
	      (<VERB? LAMP-ON LAMP-OFF>
	       <TELL "Please refer to " D ,COMPUTER ,PERIOD>)
	      (<VERB? EXAMINE LOOK-ON>
	       <TELL "It is modular, and it is a jack. Hence the name \"modular jack.\"" CR>)
	      (ELSE <>)>>

<OBJECT MPLUG
	(DESC "modular plug")
	(SYNONYM PLUG)
	(ADJECTIVE MODULAR)
	(GENERIC GEN-SAW-F)
	(ACTION MPLUG-F)>

<DEFINE MPLUG-F ("AUX" X)
	<COND (<AND <THIS-PRSO?>
		    <VERB? UNPLUG>
		    <OR <ZERO? ,PRSI> <PRSI? COMPUTER>>>
	       <TELL "It's not plugged in." CR>
	       T)
	      (<AND <OR <THIS-PRSO?>
			<AND <THIS-PRSI?>
			     <==? ,PRSO ,PRSI>>>
		    <VERB? PLUG>>
	       <COND (<AND <F? ,PRSI>
			   <META-IN? ,COMPUTER ,HERE>>
		      <PERFORM ,V?PLUG ,MPLUG ,COMPUTER>)>)
	      (<AND <THIS-PRSI?>
		    <VERB? PLUG>>
	       <PERFORM ,V?PLUG ,PRSI ,PRSO>)
	      (ELSE <>)>> 

<DEFINE RUN-PROGRAM (WHICH)
  <COND (<==? .WHICH ,RANDOM-CARTRIDGE>
	 <START-COMPUTER
	  ,RANDOM-CARTRIDGE-TABLE>)
	(<==? .WHICH ,ECLIPSE>
	 <WRITE-TABLE-TO-COMPUTER
	  ,ECLIPSE-TABLE>
	 <MAKE .WHICH ,TOUCHED>)
	(<==? .WHICH ,RECIPE>
	 <WRITE-TABLE-TO-COMPUTER
	  ,RECIPE-TABLE>)
	(ELSE
	 <WRITE-TABLE-TO-COMPUTER
	  ,ADVENTURE-TABLE>)>
  <NATIVES-REACT .WHICH>>

;<PLTABLE "AGNOSTIC TROLLS PRESENT \"WESTMINSTER\""
	   <>	; "CAN'T BE EMPTY STRING BECAUSE ZILCH LOSES..."
		   "On Westminster Bridge"
		   ">L "
		   "You are dead."
		   ">*@$%#%$@+~!!"
		   "Whoopsie. Context parser snafu."
		   "Sorry, girls.">
<CONSTANT ADVENTURE-TABLE
	  <PLTABLE "BBE ADVENTURES PRESENT \"DORK I\""
		   <>	; "CAN'T BE EMPTY STRING BECAUSE ZILCH LOSES..."
		   "West of House"
		   "You are standing in an open field "
		   "west of a white house, with a"
		   "boarded front door."
		   "There is a mailbox here."
		   "INTERNAL ERROR 69105.....">>

<CONSTANT ECLIPSE-TABLE
	  <PLTABLE "Boysenberry Eclipse Predictor V6.9"
		   <>
		   "Nearest eclipse:  Yesterday"
		   "Totality at:  12:37PM"
		   "Prime viewing location:  Zalagasa"
		   <>
		   "Next eclipse:  2/7/98">>

<CONSTANT RECIPE-TABLE
	  <PLTABLE "Midnight Recipe Projekt"
		   <>
		   "RAGOUT \"REINE DE L'AFRIQUE\""
		   <>
		   "Take one medium llama, peeled, 8"
		   "pecks garlic, 15 bushels STALE celery,"
		   "2 pounds shallots, 10 bushels carrots,"
		   "onions, turnips, snails, worms, lard,"
		   "helium, nematodes, gristle and earth"
		   "to taste. Boil llama till bored, add"
		   "other stuff and stir until congealed."
		   "Decorate with greenish milk curds."
		   "Serves one small aeroplane.">>

<OBJECT ECLIPSE
	(LOC ROMCASE)
	(DESC "eclipse predicting cartridge")
	(FLAGS TAKEABLE PROGRAM VOWEL)
	(SIZE 2)
	(SYNONYM CARTRIDGE CART CARTS ROM PROGRAM SOFTWARE PREDICTOR)
	(ADJECTIVE ECLIPSE PREDICTION PREDICTOR PROGRAM ROM SOFTWARE)
	(GENERIC GENERIC-SOFTWARE-F)
	(ACTION ECLIPSE-F)>

<DEFINE ECLIPSE-F ()
	 <COND (<HANDLE-ROM?>
		T)
	       (T
		<>)>>	 

<OBJECT RECIPE
	(DESC "recipe cartridge")
	(FLAGS TAKEABLE PROGRAM)
	(SIZE 2)
	(SYNONYM CARTRIDGE CART CARTS ROM PROGRAM SOFTWARE)
	(ADJECTIVE RECIPE PROGRAM ROM SOFTWARE RECIPES)
	(GENERIC GENERIC-SOFTWARE-F)
	(ACTION RECIPE-F)>

<DEFINE RECIPE-F ()
	 <COND (<THIS-PRSI?>
		<COND (<VERB? TRADE-FOR>
		       <COND (<NOT <IN? ,PRSI ,CLERK>>
			      <>)
			     (T
			      <MAKE ,CLERK ,TOUCHED>
			      <COND (<PRSO? ADVENTURE>
				     <ZREMOVE ,PRSO>
				     <MOVE ,PRSI ,PLAYER>
				     <GOT-RECIPE? T>
				     <DEQUEUE I-CLERK-TRADE>
				     <MAKE ,PRSI ,SEEN>
				     <TELL CTHE ,CLERK " accepts " THEO
					   " and tosses you " THEI
					   ". \"Good deal.\"" CR>
				     <UPDATE-SCORE 1>)
				    (<IS? ,PRSO ,PROGRAM>
				     <TELL CTHE ,CLERK
					" glances at " THEO
					". \"I already have that one.\""
					CR>)
				    (<PRSO? BEEZER EXCESS>
				     <TELL
				      "\"Are you crazy? This cart is hot!\""
				      CR>)
				    (T
				     <TELL CTHE ,CLERK
					   " doesn't seem interested in "
					   THEO ,PERIOD>)>
			      T)>)
		      (T
		       <>)>)
	       (<VERB? READ>
		<READ-RECIPE>
		T)
	       (<VERB? BUY BUY-FROM>
		<TELL CTHEO " isn't for sale." CR>)
	       (<VERB? EXAMINE LOOK-ON>
		<TELL 
"This cart doesn't look at all like the authorised Boysenberry carts you've bought before. Its plastic case is poorly molded, and lacks the familiar logo of a partially digested purple berry" ,PCR>
		<READ-RECIPE>
		T)
	       (<HANDLE-ROM?>
		T)
	       (T
		<>)>>

<DEFINE READ-RECIPE ()
	 <MAKE ,RECIPE ,SEEN>
	 <TELL 
"From the single word printed on the cheap white label, you deduce that this is a recipe program. That is because the word on the label is \"RECIPE\"." CR>
	 T>

<OBJECT ADVENTURE
	(LOC ROMCASE)
	(DESC "adventure game cartridge")
	(FLAGS TAKEABLE PROGRAM VOWEL)
	(SIZE 2)
	(SYNONYM ADVENTURE GAME CARTRIDGE CART CARTS PROGRAM ROM SOFTWARE)
	(ADJECTIVE ADVENTURE GAME PROGRAM ROM SOFTWARE)
	(GENERIC GENERIC-SOFTWARE-F)
	(ACTION ADVENTURE-F)>

<DEFINE ADVENTURE-F ()
	 <COND (<HANDLE-ROM?>
		T)
	       (T
		<>)>>

<DEFINE HANDLE-ROM? ()
	 <COND (<VERB? EXAMINE LOOK-ON READ>
		<TELL "It's " A ,PRSO " for " D ,COMPUTER ,PERIOD>
		T)
	       (T
		<>)>>

<DEFINE CHECK-TAKE-FROM CTF (TBL LEN "AUX" PI PIL (BEST? <>))
  <COND (<AND <VERB? TAKE>
	      <==? ,P-PHR 0>
	      <T? <ZGET ,P-ITBL ,P-NC2>>>
	 <SET PI <ZREST ,P-PRSI 2>>
	 <SET PIL <ZGET ,P-PRSI 0>>
	 <REPEAT (OBJ)
	   <COND (<INTBL? <LOC <SET OBJ <ZGET .TBL <SET LEN <- .LEN 1>>>>>
			  .PI .PIL>
		  <COND (.BEST? <RETURN <> .CTF>)>
		  <SET BEST? .OBJ>)>
	   <COND (<L=? .LEN 0> <RETURN>)>>
	 .BEST?)
	(T <>)>>

<DEFINE GENERIC-SOFTWARE-F (TBL "AUX" LEN (BEST? <>))
	 <SET LEN <ZGET .TBL 0>>
	 <SET TBL <ZREST .TBL 2>>
	 <COND (<SET BEST? <CHECK-TAKE-FROM .TBL .LEN>> .BEST?)
	       (<INTBL? ,P-IT-OBJECT .TBL .LEN>
		,P-IT-OBJECT)
	       (<INTBL? ,P-THEM-OBJECT .TBL .LEN>
		,P-THEM-OBJECT)
	       (<AND <NOUN-USED? ,W?SOFTWARE>
		     <INTBL? ,SOFTWARE .TBL .LEN>>
		,SOFTWARE)
	       (T
		; "Default to what I'm carrying, preferably in my hand"
		<SET LEN <- .LEN 1>>
		<REPEAT (OBJ)
		  <COND (<IN? <SET OBJ <ZGET .TBL .LEN>> ,PLAYER>
			 <COND (<OR <NOT .BEST?>
				    <NOT <IN? .BEST? ,PLAYER>>>
				<SET BEST? .OBJ>)
			       (T
				<SET BEST? <>>
				<RETURN>)>)
			(<AND <T? <LOC .OBJ>>
			      <IN? <LOC .OBJ> ,PLAYER>>
			 <COND (<NOT .BEST?>
				<SET BEST? .OBJ>)
			       (<NOT <IN? .BEST? ,PLAYER>>
				<SET BEST? <>>)>)>
		  <COND (<L? <SET LEN <- .LEN 1>> 0> <RETURN>)>>
		.BEST?)>>

<OBJECT ROMCASE
	(LOC BTABLE)
	(DESC "small case")
	(FLAGS TAKEABLE CONTAINER OPENABLE)
	(CAPACITY 10)
	(SIZE 12)
        (SYNONYM CASE)
	(ADJECTIVE CLOSED SHUT SMALL)>

<OBJECT PEN-MAILBOX
	(LOC OUTSIDE-FARM)
	(DESC "mailbox")
	(FLAGS NODESC CONTAINER OPENABLE)
	(SYNONYM MAILBOX BOX)
	(ADJECTIVE CLOSED SHUT)
	(CAPACITY 20)
	(ACTION PEN-MAILBOX-F)>

<DEFINE PEN-MAILBOX-F MAIL ()
	 <COND (<THIS-PRSI?>
		<COND (<VERB? PUT PUT-BEHIND EMPTY-INTO>
		       <COND (<NOT <IS? ,PRSI ,OPENED>>
			      <ITS-CLOSED ,PRSI>)
			     (<G? <GETP ,PRSO ,P?SIZE> 10>
			      <TELL CTHEO " won't fit in " THEI ,PERIOD>)
			     (<PRSO? TREATS>
			      <TELL "It's pretty obvious that you are a beginner at llama-feeding and do not know the ropes. You have two choices; one, you can go to the bookshop and buy a copy of "
				    ITAL "Why Feed Your Llama The Easy Way?"
				    " by Pablo \"Che\" Vicuna; and, two, you can just shove the whole ruddy thing through the mailbox and into the trough. You choose the latter method." CR>
			      <MOVE ,BAG ,TROUGH>
			      <LLAMA-EATS-FOOD T>)
			     (T
			      <MOVE ,PRSO ,TROUGH>
			      <COND (<PRSO? BAG>
				     <LLAMA-EATS-FOOD>)
				    (T
				     <TELL CTHEO " slides out the back of "
					   THEI
					   " and lands in " THE ,TROUGH
					   ,PCR CTHE ,LLAMA
					   " sniffs at " THEO
					   " suspiciously, snorts and ignores it."
					   CR>)>)>
		       T)
		      (T
		       <>)>)
	       (<VERB? EXAMINE>
		<TELL "The">
		<OPEN-CLOSED <> <>>
		<TELL " is attached to the front of " THE ,LLAMA-PEN>
		<COND (<IS? ,PRSO ,OPENED>
		       <TELL ". ">
		       <LOOK-IN-PENBOX>)
		      (T
		       <ZPRINT ,PERIOD>)>
		T)
	       (<VERB? REACH-IN>
		<COND (<NOT <IS? ,PRSO ,OPENED>>
		       <TELL CTHEO " is closed." CR>)
		      (<NOT <IS? ,LLAMA ,TOUCHED>>
		       <LLAMA-LICKS-YOU>
		       T)
		      (T
		       <TELL "Fortunately, " THE ,LLAMA
			     " is so awfully excited by her snack that you can stick "
			     D ,HANDS " in " THE ,TROUGH
			     " unscathed. Upon arrival, " D ,HANDS
			     " senses the presence of ">
		       <PRINT-CONTENTS ,TROUGH>
		       <TELL ,PERIOD>)>) 
	       (<AND <VERB? LOOK-INSIDE SEARCH>
		     <IS? ,PRSO ,OPENED>>
		<LOOK-IN-PENBOX>
	        T)
	       (T
		<>)>>

<DEFINE LLAMA-EATS-FOOD EAT ("OPT" (ALREADY-THERE? <>))
	 <MAKE ,LLAMA ,SEEN>
	 <COND
	  (<F? .ALREADY-THERE?>
	   <COND (<IN? ,TREATS ,BAG>
		  <TELL
		   "It's pretty obvious that there's not much anyone can tell "
		   ITAL "you"
		   " about llama-feeding. With deft and practised llama-feeding movements (where did you pick them up, by the way?) you ease the bag">)
		 (T
		  <TELL "You drop the bag">)>
	   <TELL 
" into the mailbox, where it immediately slides out the back and lands in the trough with a characteristic and not unpleasant llama-food-landing-in-a-trough noise. The noise is particularly not-unpleasant to the llama, who">)
	  (T
	   <TELL CR CTHE ,LLAMA>)>
	 <TELL " sniffs at the ">
	 <COND (<IS? ,BAG ,OPENED>
		<TELL "open bag">
		<COND (<IN? ,TREATS ,BAG>
		       <MAKE ,LLAMA ,TOUCHED>
		       <TELL 
", emits a hateful little bleat of delight, and begins to chomp on the llama treats inside." CR>
		       <RETURN T .EAT>)>)
	       (T
		<TELL "closed bag">)>
	 <TELL " with such heart-breaking longing that if ">
	 <ITALICIZE "Bureaucracy">
	 <TELL " allowed you to kiss the llama, you would kiss the llama. But it doesn't. If you had ever kissed a llama, you would understand why." CR>
	 <UPDATE-BP 5>
	 T>

<DEFINE LOOK-IN-PENBOX ()
	 <TELL "Peering inside, you notice that the back of "
	       THEO " opens directly into " THE ,LLAMA "'s "
	       Q ,TROUGH ". Strangely enough, this doesn't strike you as remotely peculiar." CR>>

<OBJECT BAG
	(LOC DMAN)
	(DESC "bag of llama treats")
	(FLAGS TAKEABLE CONTAINER OPENABLE)
	(SYNONYM BAG FEED FOOD SACK TREATS TREAT SUPERSACK ORDER)
	(ADJECTIVE CLOSED SHUT LLAMA BURLAP)
	(GENERIC GENERIC-FOOD-F)
	(SIZE 9)
	(ACTION BAG-F)>

<DEFINE BAG-F ()
	 <COND (<THIS-PRSI?>
		<COND (<VERB? PUT EMPTY-INTO>
		       <TELL "There's no room in the bag for anything." CR>
		       T)
		      (T
		       <>)>)
	       (<VERB? EXAMINE LOOK-ON READ>
		<TELL "It's a">
		<COND (<IS? ,PRSO ,OPENED>
		       <TELL "n open">)
		      (T
		       <TELL " closed">)>
		<TELL 
" bag of " Q ,TREATS " (with New! Improved! Spillproof SuperSack(TM)!)." CR>
		T)
	       (<VERB? BUY>
		<COND (<IN? ,DMAN ,HERE>
		       <COND (<T? ,PRSI>
			      <PERFORM ,V?GIVE ,PRSI ,DMAN>
			      T)
			     (ELSE <>)>)
		      (ELSE
		       <TELL "You already bought it." CR>
		       T)>)
	       (<VERB? POUR EMPTY-INTO EMPTY>
		<TELL 
"The Llamex(R) Spillproof SuperSack(TM) prevents this." CR>
		T)
	       (<AND <VERB? LOOK-INSIDE SEARCH>
		     <IS? ,PRSO ,OPENED>
		     <IN? ,TREATS ,PRSO>>
		<TELL "Aside from " Q ,TREATS ", you see ">
		<PRINT-CONTENTS ,PRSO>
		<TELL " in the bag." CR>
		T)
	       (<VERB? REACH-IN>
		<COND (<NOT <IS? ,BAG ,OPENED>>
		       <ITS-CLOSED>)
		      (T
		       <FEEL-FEED>)>
		T)
	       (<VERB? OPEN>
		<COND (<IS? ,BAG ,OPENED>
		       <TELL CTHEO " is already opened." CR>)
		      (T
		       <TELL "You open " THEO>
		       <COND (<IN? ,TREATS ,BAG>
			      <TELL ". The bag is full of " D ,TREATS>)
			     (ELSE
			      <TELL ". The bag is empty">)>
		       <TELL ,PERIOD>
		       <MAKE ,BAG ,OPENED>
		       <COND (<IN? ,BAG ,TROUGH>
			      <LLAMA-EATS-FOOD T>)>)>
		T)
	       (<VERB? CLOSE>
		<TELL "Knowing the appetites of llamas, the Llamex(R) people
thoughtfully made it impossible to close " THEO ,PERIOD>
		T)
	       (<VERB? SMELL>
		<PERFORM ,V?SMELL ,TREATS>
		T)
	       (<VERB? TAKE>
		<COND (<ITAKE>
		       <TELL "Taken." CR>
		       <UNMAKE ,LLAMA ,TOUCHED>)>
		T)
	       (T
		<>)>>

<OBJECT TREATS
	(LOC BAG)
	(DESC "Llamex(R) brand High-Fibre Llama Treats")
	(FLAGS TRYTAKE NOALL PLURAL NODESC)
	(SYNONYM TREATS TREAT FOOD FEED)
	(ADJECTIVE LLAMEX LLAMEX\(R\) BRAND HIGH\-FIB LLAMA)
	(GENERIC GENERIC-FOOD-F)
	(ACTION TREATS-F)>

<DEFINE TREATS-F ()
	 <COND (<THIS-PRSI?>
		<>)
	       (<VERB? EMPTY>
		<TELL "If you think you're making that sort of mess in "
		      ITAL "this"
		      " game, you've got another think coming." CR>
		T)
	       (<VERB? TAKE>
		<TELL "Llama treats fall between your fingers. Hah! That fixed
your hash, didn't it?" CR>
		T)
	       (<VERB? DRINK>
		<IMPOSSIBLE>
		T)
	       (<VERB? EAT TASTE>
		<EAT-LLAMA-TREATS>
		T)
	       (<VERB? SMELL>
		<TELL "There is something wrong with your nose: it is not a llama's nose. If it were a llama's nose, the treats would smell pretty, er, groovy. (Sorry; that's how llamas like, er, relate to the world. They are very sixties animals, basically. Right on, ">
		<GENDER-PRINT "man" "sister">
		<TELL ".)" CR>
		T)
	       (<VERB? REACH-IN TOUCH>
		<FEEL-FEED>
		T)
	       (<VERB? BUY>
		<COND (<NOT <IN? ,DMAN ,HERE>>
		       <TELL "You already bought " THEO ,PERIOD>)
		      (<T? ,PRSI>
		       <PERFORM ,V?PAY ,DMAN ,PRSI>)
		      (T
		       <TELL "Federal regulations require that you specify what
you want to buy "
			     THEO " with." CR>)>)
	       (T
		<>)>>		       

<DEFINE FEEL-FEED ()
	 <SETG P-THEM-OBJECT ,TREATS>
	 <TELL "The treats would taste wonderful, if you were a llama, and if you were eating them instead of feeling them." CR>
	 T>

<OBJECT LLAMA-PEN
	(LOC OUTSIDE-FARM)
	(DESC "pen")
	(FLAGS PLACE CONTAINER OPENABLE TRANSPARENT)
	(SYNONYM PEN CAGE)
	(CAPACITY 100)
	(DESCFCN LLAMA-PEN-F)
	(CONTFCN LLAMA-PEN-F)
	(ACTION LLAMA-PEN-F)>

<DEFINE LLAMA-PEN-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-OBJDESC>
		<TELL CA ,LLAMA " is ">
		<COND (<IS? ,LLAMA ,TOUCHED>
		       <TELL "chomping happily on her treats in">)
		      (T
		       <TELL "watching you from">)>
		<TELL " a pen at the side of the road. A mailbox is attached to the front of the pen.">
		T)
	       (<EQUAL? .CONTEXT ,M-CONT>
		<COND (<TOUCHING?>
		       <COND (<IS? ,PEN-MAILBOX ,OPENED>
			      <>)
			     (T
			      <CANT-REACH-THRU-FENCE>
			      T)>)
		      (T
		       <>)>)
	       (<T? .CONTEXT>
		<>)
	       (<THIS-PRSI?>
		<COND (<PUTTING?>
		       <MOVE ,PRSO ,LLAMA-PEN>
		       <TELL CTHEO " falls into the pen." CR>
		       T)
		      (T
		       <>)>)
	       (<HANDLE-PEN?>
		T)
	       (T
		<>)>>

<DEFINE HANDLE-PEN? ()
	 <COND (<VERB? LOOK-INSIDE SEARCH>
		<TELL "Aside from the llama, you see ">
		<PRINT-CONTENTS ,LLAMA-PEN>
		<TELL " in the pen." CR>
		T)
	       (<VERB? OPEN>
		<TELL CTHEO " is firmly locked." CR>
		T)
	       (<VERB? OPEN-WITH UNLOCK>
		<TELL CTHEI " doesn't fit the lock." CR>
		T)
	       (<VERB? CLOSE>
		<ALREADY-CLOSED>
		T)
	       (<ENTERING?>
		<ITS-CLOSED>
		T)
	       (<VERB? CLIMB-ON CLIMB-OVER LEAP SIT LIE-DOWN STAND-ON CLIMB-UP>
		<SETG P-IT-OBJECT ,LFENCE>
		<TELL "Clause 19(B) Paragraph A(1(B(ii(a(v))))) of your health insurance specifically excludes llama-wounds from coverage. Wisely, you stay on this side of the fence." CR>
		T)
	       (<VERB? REACH-IN EMPTY>
		<CANT-REACH-THRU-FENCE>
		T)
	       (<AND <VERB? EXAMINE>
		     <NOUN-USED? ,W?LOCK>>
		<TELL "It's just your average unopenable lock." CR>)
	       (T
		<>)>>

<DEFINE CANT-REACH-THRU-FENCE ()
	 <TELL ,CANT "reach through the fence." CR>>

<OBJECT LFENCE
	(LOC OUTSIDE-FARM)
	(DESC "fence")
	(FLAGS NODESC)
	(SYNONYM FENCE LOCK)
	(ACTION LFENCE-F)>

<DEFINE LFENCE-F ()
	 <COND (<THIS-PRSI?>
		<COND (<VERB? THROW-OVER>
		       <MOVE ,PRSO ,LLAMA-PEN>
		       <TELL CTHEO
" sails over " THEI " and lands in the pen." CR>
		       T)
		      (<VERB? PUT-UNDER PUT-BEHIND>
		       <COND (<G? <GETP ,PRSO ,P?SIZE> 1>
			      <TELL CTHEO " won't fit." CR>)
			     (T
			      <MOVE ,PRSO ,LLAMA-PEN>
			      <TELL "You coax " THEO " into the pen." CR>)>
		       T)
		      (T
		       <>)>)
	       (<HANDLE-PEN?>
		T)
	       (T
		<>)>>

<OBJECT MAILBOX
	(LOC OUTSIDE-HOUSE)
	(DESC "mailbox")
	(FLAGS CONTAINER OPENABLE)
	(CAPACITY 5)
	(SYNONYM MAILBOX BOX)
	(ADJECTIVE CLOSED SHUT MAIL MY YOUR)
        (ACTION MAILBOX-F)>

<DEFINE MAILBOX-F ()
  <COND (<VERB? OPEN>
	 <COND (<IS? ,PRSO ,OPENED>
		<>)
	       (<AND <IN? ,LEAFLET ,PRSO>
		     <NOT <IS? ,LEAFLET ,TOUCHED>>>
		<MAKE ,LEAFLET ,TOUCHED>
		<MAKE ,PRSO ,OPENED>
		<TELL "Yes, there is some mail in the mailbox. No, it is not
the cheque from Happitec which you were expecting. It's a leaflet, and it's
addressed to ">
		<SAY-STREET-ADDRESS ,ST-B>
		<TELL ". There's obviously something wrong with the city
mail delivery system (installed at great expense by the Deep Thought
Corporation last year)." CR>)
	       (T <>)>)>>

<OBJECT STAMPS
	(LOC IN-FLAT)
	(DESC "stamps")
	(FLAGS READABLE PLURAL NODESC)
	(SYNONYM STAMPS COLLECTION)
	(ADJECTIVE STAMP POSTAGE)
	(ACTION STAMPS-F)>

<DEFINE STAMPS-F ()
  <COND (<VERB? TAKE>
	 <TELL "Ordinance 2(7i) of the City regulations forbids stealing other people's mail without good cause. Schedule D(6)(a/17) of your health insurance denies cover for diseases caused by messing about with things that other people have licked. For these good reasons, you leave it alone." CR>)
	(<VERB? EXAMINE READ>
	 <TELL "There are stamps here from all over the world, offering an amazing opportunity for a stamp-collector. You are not a stamp collector. They offer you no opportunities at all. None." CR>)>>

<OBJECT LEAFLET
	(LOC MAILBOX)
	(DESC "leaflet")
	(FLAGS READABLE TAKEABLE)
	(SIZE 1)
	(SYNONYM MAIL LEAFLET PAPER PIECE AD ADVERTISEMENT
	 	 STAMP AI\-AI MONKEY APE ADDRESS NAME INTNUM)
	(ADJECTIVE JUNK AI\-AI MONKEY APE POSTAGE ZALAGASA)
	(MATCH-NUMBER 42)
	(ACTION LEAFLET-F)
	(GENERIC GENERIC-ADDRESS)>

<DEFINE GENERIC-ADDRESS (TBL "AUX" (LEN <ZGET .TBL 0>))
  <COND (<AND <INTBL? ,ABOOK <ZREST .TBL 2> .LEN>
	      <INTBL? ,LEAFLET <ZREST .TBL 2> .LEN>>
	 ,LEAFLET)
	(T <GENERIC-MAIL .TBL>)>>

<DEFINE GENERIC-MAIL (TBL "AUX" (LEN <ZGET .TBL 0>))
  <SET TBL <ZREST .TBL 2>>
  <COND (<INTBL? ,P-IT-OBJECT .TBL .LEN>
	 ,P-IT-OBJECT)
	(ELSE
	 <COND (<INTBL? ,PARAMAIL .TBL .LEN>
		,PARAMAIL)
	       (<INTBL? ,MOUSYMAIL .TBL .LEN>
		,MOUSYMAIL)
	       (<INTBL? ,LLAMA-MAIL .TBL .LEN>
		,LLAMA-MAIL)
	       (<INTBL? ,SHITMAIL .TBL .LEN>
		,SHITMAIL)>)>>

<DEFINE LEAFLET-F LEAFLET ()
	 <COND (<AND <THIS-PRSO?>
		     <VERB? TAKE>>
		<ZPUT <GETPT ,PRSO ,P?SYNONYM> 0 ,W?ZZZP>)>
	 <COND (<OR <NOUN-USED? ,W?STAMPS ,W?STAMP ,W?AI\-AI>
		    <NOUN-USED? ,W?MONKEY ,W?APE ,W?INTNUM>
		    <ADJ-USED? ,W?AI\-AI ,W?MONKEY ,W?APE>
		    <ADJ-USED? ,W?POSTAGE>>
		<COND (<THIS-PRSI?>
		       <COND (<PUTTING?>
			      <IMPOSSIBLE>
			      <RETURN T .LEAFLET>)>
		       <RETURN <> .LEAFLET>)
		      (<VERB? EXAMINE READ LOOK-ON>
		       <TELL "The stamp on " THEO
" is worth 42 Zalagasan Wossnames (the Zalagasans were too idle to think of a name for their currency) and shows an extremely bad picture of an Ai-Ai. The Ai-Ai is of course a terribly, terribly rare sort of lemur which is a rare sort of monkey so altogether pretty rare, so rare that nobody has ever seen one, which is why the picture is such a blurred and rotten likeness. Actually, come to think of it, since nobody has ever seen the real thing, the picture might in fact be a really sharp, accurate likeness of a blurred and rotten animal." CR>
		       <RETURN T .LEAFLET>)
		      (<MOVING?>
		       <TELL "What's the stuff? Glue; that's it. Yes. Amazing. The stamp is actually glued to "
			     THEO ,PERIOD>
		       <RETURN T .LEAFLET>)>)
	       (<NOUN-USED? ,W?ADDRESS ,W?NAME>
		<COND (<THIS-PRSI?>
		       <COND (<PUTTING?>
			      <IMPOSSIBLE>
			      <RETURN T .LEAFLET>)>
		       <RETURN <> .LEAFLET>)
		      (<MOVING?>
		       <TELL ,CANT "move the address on " THEO ,PERIOD>
		       <RETURN T .LEAFLET>)
		      (<VERB? EXAMINE READ LOOK-ON>
		       <TELL CTHEO " is addressed to ">
		       <SAY-STREET-ADDRESS ,ST-B>
		       <TELL ,PERIOD>
		       <RETURN T .LEAFLET>)>)>
	 <COND (<THIS-PRSI?>
		<>)
	       (<VERB? READ EXAMINE LOOK-ON>
		<TELL CTHEO
" is an irritatingly enthusiastic mail-shot for some computer game.
\"Now available for your Boysenberry!\" it says, pointing out that
(a) the game comes in a blue box; (b) if you had a Daktari S/M you
could have truly amazing graphics; and (c) if you had a Cormorant Honcho
you could have utterly incredible sound. Since the Boysenberry has neither
sound nor graphics, you wonder what on earth the marketing manager was
thinking of. The mail-shot is addressed to ">
		<SAY-STREET-ADDRESS ,ST-B>
		<TELL ". The sender used a postage stamp." CR>
		T)
	       (T
		<>)>>

<OBJECT DOWNTOWN
	(LOC GLOBAL-OBJECTS)
	(DESC "downtown")
	(FLAGS NODESC PLACE)
	(SYNONYM DOWNTOWN TOWN)
	(ACTION DOWNTOWN-F)>

<DEFINE DOWNTOWN-F ()
	 <COND (<HERE? ST-A ST-B BSTORE DINER AGENCY
		       IN-ALLEY>
		<COND (<HERE-F>
		       T)
		      (T
		       <>)>)
	       (<ENTERING?>
		<V-WALK-AROUND>
		T)
	       (T
		<>)>>

<OBJECT SHELVES
	(LOC BSTORE)
	(DESC "shelves")
	(FLAGS NODESC SURFACE PLURAL)
	(SYNONYM SHELVES SHELVING SHELF)
	(ACTION SHELVES-F)>

<DEFINE SHELVES-F ()
	 <COND (<THIS-PRSI?>
		<COND (<PUTTING?>
		       <SHELVES-FULL>
		       T)
		      (T
		       <>)>)
	       (<VERB? EXAMINE LOOK-ON SEARCH>
		<TELL CTHEO " are groaning with " D ,BESTSELLERS 
		      " and " D ,CUTOUTS ,PERIOD>
		T)
	       (<VERB? STAND-ON SIT LIE-DOWN CLIMB-ON CLIMB-OVER
		       CLIMB-UP>
		<SHELVES-FULL>
		T)
	       (T
		<>)>>

<DEFINE SHELVES-FULL ()
	 <TELL CTHE ,SHELVES 
" groan even louder. You abandon the attempt." CR>>

<OBJECT BESTSELLERS
	(LOC SHELVES)
	(DESC "best sellers")
	(FLAGS TRYTAKE READABLE PLURAL NOALL)
	(SYNONYM BESTSELLER SELLERS SELLER BOOKS BOOK TITLE TITLES)
	(ADJECTIVE BEST BESTSELLER)
	(ACTION BESTSELLERS-F)>

<DEFINE BESTSELLERS-F ()
	 <COND (<THIS-PRSI?>
		<COND (<PUTTING?>
		       <WASTE-OF-TIME>
		       T)
		      (T
		       <>)>)
	       (<VERB? EXAMINE LOOK-ON>
		<TELL "Prominent among " THEO " is ">
		<DIRK>
		<ZPRINT ,PERIOD>
		T)
	       (<VERB? READ>
		<READ-DIRK "thumb through">
		T)
	       (<VERB? TAKE>
		<READ-DIRK "pick up">
		T)
	       (T
		<>)>>
	       
<OBJECT CUTOUTS
	(LOC SHELVES)
	(DESC "remainders")
	(FLAGS TRYTAKE NOALL PLURAL)
	(SYNONYM CUTOUTS CUTOUT BOOK BOOKS TITLE TITLES REMAINDER)
	(ADJECTIVE CUTOUTS CUTOUT REMAINDER BARGAIN CHEAP)
	(ACTION CUTOUTS-F)>
	
<DEFINE CUTOUTS-F ()
	 <COND (<THIS-PRSI?>
		<COND (<PUTTING?>
		       <WASTE-OF-TIME>
		       T)
		      (T
		       <>)>)
	       (<VERB? EXAMINE LOOK-ON>
		<TELL "Prominent among " THEO " is ">
		<FISH>
		<ZPRINT ,PERIOD>
		T)
	       (<VERB? READ>
		<READ-FISH "thumb through">
		T)
	       (<VERB? TAKE>
		<READ-FISH "pick up">
		T)
	       (T
		<>)>>

<DEFINE READ-DIRK (STR)
	 <TELL "You " .STR " a copy of ">
	 <DIRK>
	 <DROLL>>
	 
<DEFINE DIRK ()
	 <ITALICIZE "Dirk Gently's Holistic Detective Agency">
	 <ROMP>
	 T>

<DEFINE READ-FISH (STR)
	 <TELL "You " .STR " a copy of ">
	 <FISH>
	 <DROLL>
	 T>
	 
<DEFINE FISH ()
	 <ITALICIZE "So Long, And Thanks for All the Fish">
	 <ROMP>
	 T>

<DEFINE ROMP ()
	 <TELL " (\"a zany new romp by the author of ">
	 <ITALICIZE "The Hitchhiker's Guide to the Galaxy">
	 <TELL "\")">
	 T>
		
<DEFINE DROLL ()
	 <TELL 
", chuckle at the droll British wit, and put it down reluctantly, vowing to buy copies for " D ,ME " and all your friends as soon as you finish ">
	 <ITALICIZE "Bureaucracy">
	 <ZPRINT ,PERIOD>
	 T>

<OBJECT SOFTWARE
	(LOC BSTORE)
	(DESC "stock of software")
	(FLAGS NODESC TRYTAKE NOALL)
	(SYNONYM STOCK SOFTWARE CARTRIDGE)
	(ADJECTIVE SOFTWARE COMPUTER BOYSENBERRY)
	(GENERIC GENERIC-SOFTWARE-F)
	(ACTION SOFTWARE-F)>

"TOUCHED = seen once, SEEN = seen twice."

<DEFINE SOFTWARE-F ()
	 <COND (<THIS-PRSI?>
		<>)
	       (<VERB? BUY>
		<TELL "In case you didn't notice, this is unimpressive
software that you've seen before. It's just there to suggest that maybe
something besides books is available here. In any event, you can't buy
it, and if you could, it wouldn't run." CR>)
	       (<VERB? EXAMINE LOOK-ON READ>
		<TELL
"Not much of a selection, really. A couple of last year's Boysenberry hits; you've seen them all before." CR>
		<SEEN-SOFTWARE?>
		T)
	       (<TOUCHING?>
		<TELL CTHEO " is out of reach, behind " THE ,REGISTER ,PERIOD>
		<SEEN-SOFTWARE?>
		T)
	       (T
		<>)>>
	       
<DEFINE SEEN-SOFTWARE? ("OPTIONAL" (CR T))
	 <MAKE ,CLERK ,TOUCHED>
	 <COND (<T? .CR>
		<ZCRLF>)>
	 <TELL CTHE ,CLERK>
	 <COND (<NOT <IS? ,SOFTWARE ,TOUCHED>>
		<MAKE ,SOFTWARE ,TOUCHED>
		<TELL 
" notes your interest with a dopey grin. \"Great selection, huh? All the latest hits,\" he remarks." CR>
		T)
	       (<NOT <IS? ,SOFTWARE ,SEEN>>
		<MAKE ,SOFTWARE ,SEEN>
		<TELL
" glances furtively around the shop, then gives you a sly look. \"You look like a fellow hacker,\" he half-whispers. \"Bet you'd be interested in some, shall we say, ">
		<ITALICIZE "special">
		<TELL " carts I keep on the side. Wanna see 'em?\"" CR>
		<COND (<SAID-YES? "\"Never mind that,\" hisses the clerk. \"Do you wanna see these carts or not? Just say yes or no.\"">
		       <SETG TURNED-DOWN-CLERK? <>>
		       <QUEUE I-CLERK-TRADE>
		       <TELL CTHE ,CLERK
" pulls a software cartridge out from under the counter." CR>
		       <THIS-IS-IT ,RECIPE>
		       <MOVE ,RECIPE ,CLERK>)
		      (T
		       <SETG TURNED-DOWN-CLERK? T>
		       <TELL CTHE ,CLERK " sighs. \"Okay. Never mind.\"" CR>)>
		T)
	       (T
		<TELL 
" notes your persistent interest with barely concealed boredom." CR>
		T)>>

<OBJECT REGISTER
	(LOC BSTORE)
	(DESC "cash register")
	(FLAGS NODESC TRYTAKE NOALL CONTAINER OPENABLE)
	(SYNONYM REGISTER DRAWER)
	(ADJECTIVE CASH)
	(ACTION REGISTER-F)>

<DEFINE REGISTER-F ()
	 <COND (<THIS-PRSI?>
		<>)
	       (<VERB? OPEN OPEN-WITH>
		<CANT-FROM-HERE>
		T)
	       (<VERB? LOOK-BEHIND>
		<TELL ,YOU-SEE THE ,SOFTWARE " behind " THE ,REGISTER
		      ,PERIOD>
		T)
	       (<VERB? WALK-AROUND>
		<TELL "The store management does not permit customers behind "
		      THE ,REGISTER>
		T)
	       (T
		<>)>>

<OBJECT BURGER
	(DESC "hamburger")
	(FLAGS TAKEABLE)
	(SYNONYM HAMBURGER BURGER FOOD SANDWICH MEAL)
	(GENERIC GENERIC-FOOD-F)
	(ADJECTIVE SMALL)
	(SIZE 3)
        (ACTION BURGER-F)>

<DEFINE GENERIC-FOOD-F (TBL "AUX" (LEN <ZGET .TBL 0>))
	<SET TBL <ZREST .TBL 2>>
	; "Prefer real food over llama food, but treats over the
	   bag (subsumes generic-treats-f)"
	<COND (<INTBL? ,BURGER .TBL .LEN>
	       ,BURGER)
	      (<INTBL? ,AIRLINE-MEAL .TBL .LEN>
	       ,AIRLINE-MEAL)
	      (<INTBL? ,TREATS .TBL .LEN>
	       ,TREATS)
	      (T <>)>>

<DEFINE BURGER-F ()
  <COND (<AND <THIS-PRSO?>
	      <VERB? EAT>>
	 <ZREMOVE ,BURGER>
	 <TELL <ZGET <ZGET ,HUNGER-MSGS ,H-EAT>
				     </ ,HUNGER 40>>
	       CR>
	 <SETG HUNGER 0>
	 <DEQUEUE I-HUNGER>
	 <UPDATE-SCORE 1>
	 T)
	(<VERB? SMELL>
	 <TELL "Oh, come on. You know exactly what a hamburger smells like. It smells like fried meat" ,PCR "Since this thing smells like the inside of a dog's ear, you could be in trouble." CR>)
	(<VERB? RETURN>
	 <TELL "You have spoilt your food by looking at it and the restaurant is unable to take it back. This is for your comfort and safety. Also, the Pope is Jewish and California is an island off the coast of Wisconsin." CR>)
	(<VERB? EXAMINE>
	 <TELL "What you have here is just a standard, smells-like-a-dog's-ear burger, with nothing on it. It seems to be ">
	 <COND (<==? <ZGET ,MEAL ,BURGER-TYPE> ,W?WELL-DONE>
		<TELL "raw">)
	       (T
		<TELL "well-done">)>
	 <TELL ,PERIOD>)
	(<VERB? REQUEST>
	 <TELL "There's nothing wrong with what you've already got. Well, actually, there is one hell of a lot wrong with what you've got, but you're not getting anything else." CR>)>>

<OBJECT DTABLE
	(LOC DINER)
	(DESC "table")
	(FLAGS NODESC SURFACE)
	(CAPACITY 10)
	(SYNONYM TABLE)>

<OBJECT AGENCY-DESK
	(LOC AGENCY)
	(DESC "desk")
	(FLAGS SURFACE)
	(CAPACITY 10)
	(ADJECTIVE HER)
	(SYNONYM DESK)
	(DESCFCN AGENCY-DESK-F)
	(ACTION AGENCY-DESK-F)>

<DEFINE AGENCY-DESK-F ("OPT" (CONTEXT <>))
  <COND (<==? .CONTEXT ,M-OBJDESC>
	 <TELL CA ,AGENT " is sitting behind the desk, waiting for customers to explain exactly where they want to go and how they want to get there so that she can get a large commission for misunderstanding everything and sending them to Djakarta.">
	 <COND (<IN? ,TICKET ,AGENCY-DESK>
		<TELL " There's " A ,TICKET " on the desk.">)>)
	(<VERB? LOOK-BEHIND LOOK-UNDER>
	 <TELL CTHE ,AGENT " is sitting behind " THEO ,PERIOD>)
	(<VERB? WALK-AROUND OPEN LOOK-INSIDE THROUGH PUT PUT-ON>
	 <INVADING-SPACE>)
	(<VERB? EXAMINE>
	 <TELL "Why? It's not a television. It's a perfectly ordinary desk, just like the sort thousands of people go quietly mad behind every day." CR>)
	(T <>)>>

<OBJECT TICKET
	(DESC "airline ticket")
	(FLAGS NODESC TAKEABLE READABLE VOWEL)
	(SIZE 1)
	(SYNONYM TICKET PAPER)
	(ADJECTIVE AIRLINE ROUND\-TRIP)
	(ACTION TICKET-F)>

"NODESC = not yet seen."

<DEFINE TICKET-F ()
	 <COND (<THIS-PRSI?>
		<COND (<VERB? PUT-ON>
		       <WASTE-OF-TIME>
		       T)
		      (T
		       <>)>)
	       (<VERB? EXAMINE LOOK-ON READ>
		<TELL
"It's a round-trip ticket to Paris on Omnia Gallia flight 105, departing ">
		<SHOW-FIELD ,CITY-NAME>
		<TELL " Airport at four o'clock this afternoon." CR>
		T)
	       (T
		<>)>>

<OBJECT TROUGH
	(LOC LLAMA-PEN)
	(DESC "trough")
	(FLAGS CONTAINER OPENED SEARCH-ME TRYTAKE)
	(SYNONYM TROUGH)
	(ADJECTIVE FEEDING LLAMA\'S)
	(CAPACITY 30)
	(CONTFCN TROUGH-F)
        (ACTION TROUGH-F)>

<DEFINE TROUGH-F ("OPTIONAL" (CONTEXT <>) "AUX" X)
	 <COND (<EQUAL? .CONTEXT ,M-CONT>
		<COND (<TOUCHING?>
		       <COND (<THIS-PRSO?>
			      <SET X ,PRSO>)
			     (T
			      <SET X ,PRSI>)>
		       <COND (<NOT <IS? ,PEN-MAILBOX ,OPENED>>
			      <CANT-REACH-TROUGH T>
			      T)
			     (<AND <EQUAL? .X ,BAG>
				   <IN? ,TREATS ,BAG>>
			      <COND (<IS? ,BAG ,OPENED>
				     <TELL "As you try to take the treats " THE
					   ,LLAMA>)
				    (ELSE
				     <TELL 
				      "You manage to reach the bag just before " THE ,LLAMA>)>
			      <LICKS-YOU>
			      <ZCRLF>
			      <COND (<IS? ,BAG ,OPENED>
				     T)
				    (ELSE
				     <ZCRLF>
				     <>)>)
			     (<IS? ,LLAMA ,TOUCHED>
			      <COND (<OR <NOT <VERB? OPEN>>
					 <NOT ,PRSO>
					 <F? <GETP ,PRSO ,P?MAIL-LETTER>>>
				     <TELL "The llama is sufficiently distracted to keep her tongue to herself when you reach through the mailbox" ,PCR>)>
			      <>)
			     (T
			      <LLAMA-LICKS-YOU>
			      T)>)
		      (T
		       <>)>)
	       (<THIS-PRSI?>
		<COND (<VERB? PUT EMPTY-INTO THROW>
		       <COND (<NOT <IS? ,PEN-MAILBOX ,OPENED>>
			      <CANT-REACH-TROUGH>)
			     (T
			      <SET X <PERFORM ,V?PUT ,PRSO ,PEN-MAILBOX>>)>
		       T)
		      (<VERB? PUT-BEHIND PUT-UNDER>
		       <CANT-FROM-HERE>
		       T)
		      (T
		       <>)>)
	       (T
		<>)>>
 
<DEFINE CANT-REACH-TROUGH ("OPTIONAL" (X <>))
	 <TELL "At the moment, there's no way to reach ">
	 <COND (<T? .X>
		<TELL "into ">)>
	 <TELL THE ,TROUGH ". It's inside " THE ,LLAMA-PEN ,PERIOD>>

<DEFINE LLAMA-LICKS-YOU ()
  <TELL CTHE ,LLAMA>
  <LICKS-YOU>
  <TELL " You quickly pull " Q ,HANDS " out of " THE ,PEN-MAILBOX ,PERIOD>
  <SETG P-MULT? <>>
  <UPDATE-BP 5>>

<DEFINE LICKS-YOU ()
	 <MAKE ,LLAMA ,SEEN>
	 <TELL
" licks you. You are horribly aware that the llama's tongue is directly connected to the llama's insides.">
	 T>

<OBJECT FARM-DOOR
	(LOC LOCAL-GLOBALS)
	(DESC "front door")
	(FLAGS NODESC DOORLIKE OPENABLE)
	(SYNONYM DOOR DOORWAY)
	(ADJECTIVE FRONT FARM FARMHOUSE)
	(GENERIC GDOOR-F)
	(ACTION FARM-DOOR-F)>

<DEFINE FARM-DOOR-F ()
	 <COND (<THIS-PRSI?>
		<>)
	       (<VERB? EXAMINE LOOK-INSIDE>
		<COND (<NOUN-USED? W?HOUSE W?FARMHOUSE>
		       <COND (<HERE? IN-FARM>
			      <PERFORM ,V?LOOK>)
			     (T
			      <TELL "It's just a normal, puce 'n' tangerine striped suburban llama-farmer's house. Its "
				    D ,FARM-DOOR " is "
				    <COND (<IS? ,FARM-DOOR ,OPENED>
					   "open")
					  (T
					   "closed")>
				    ,PERIOD>)>)>)
	       (<AND <VERB? OPEN> <NOT <IS? ,INTERCOM ,SEEN>>>
		<TELL CTHE ,PRSO
		      " won't budge no matter how hard you try." CR>
		T)
	       (<AND <VERB? CLOSE>
		     <HERE? IN-FARM>
		     <IS? ,PRSO ,OPENED>>
		<COND (<NOT <IS? ,SPY ,SEEN>>
		       <NOISE-AT-DOOR>
		       T)
		      (<IN? ,SPY ,HERE>
		       <TELL CTHE ,SPY " is blocking " THEO ,PERIOD>
		       T)
		      (T
		       <>)>)	
	       (<ENTERING?>
		<COND (<HERE? IN-FARM>
		       <DO-WALK ,P?EAST>)
		      (T
		       <DO-WALK ,P?WEST>)>
		T)
	       (T
		<>)>>



<OBJECT FARM-NOTICE
	(LOC OUTSIDE-FARM)
	(DESC "notice")
	(FLAGS TRYTAKE NOALL READABLE)
	(SYNONYM NOTICE SIGN WORDS)
	(ACTION FARM-NOTICE-F)>

<DEFINE FARM-NOTICE-F ()
	 <COND (<THIS-PRSI?>
		<>)
	       (<VERB? READ EXAMINE LOOK-ON>
		<TELL CTHEO " says,|
|
\"Dear Newspaper Boy,|
|
Please do not leave any papers for the next three weeks. I am away on vacation and do not want papers piling up on my doorstep where thieves can see them.|
|
Have a nice day!\"" CR CR "A tangerine Cougar has just driven past. It was full of burglars, laughing and taking notes." CR>
		T)
	       (T
		<>)>>

<OBJECT PAPERS
	(LOC OUTSIDE-FARM)
	(DESC "pile of newspapers")
	(FLAGS NODESC TRYTAKE NOALL READABLE SURFACE)
	(CAPACITY 20)
	(SYNONYM PILE STACK BUNCH NEWSPAPERS PAPERS PAPER)
	(ADJECTIVE OLD SOGGY)
	(ACTION PAPERS-F)>

<DEFINE PAPERS-F ()
	 <COND (<THIS-PRSI?>
		<COND (<PUTTING?>
		       <WASTE-OF-TIME>
		       T)
		      (T
		       <>)>)
	       (<VERB? TAKE>
		<TELL CTHEO 
" is only a joke. " ,DONT "have to pick them up." CR>
		T)
	       (T
		<>)>>

<OBJECT MHALL
	(LOC LOCAL-GLOBALS)
	(DESC "corridor")
	(FLAGS NODESC)
	(SYNONYM CORRIDOR HALL HALLWAY)
	(ADJECTIVE LONG DARK)
	(ACTION MHALL-F)>

<DEFINE MHALL-F ()
	 <COND (<AND <HERE? OUTSIDE-HOUSE>
		     <NOT <IS? ,MANSION-DOOR ,OPENED>>>
		<CANT-SEE-ANY>
		,FATAL-VALUE)
	       (<THIS-PRSI?>
		<>)
	       (<ENTERING?>
		<COND (<HERE? OUTSIDE-MANSION>
		       <DO-WALK ,P?EAST>)
		      (T
		       <DO-WALK ,P?WEST>)>
		T)
	       (T
		<>)>>

<OBJECT PORCH-DOOR
	(LOC LOCAL-GLOBALS)
	(DESC "screen door")
	(FLAGS NODESC DOORLIKE OPENABLE)
	(SYNONYM DOOR DOORWAY)
	(ADJECTIVE CLOSED SHUT SCREEN)
	(ACTION PORCH-DOOR-F)>

<DEFINE PORCH-DOOR-F ()
	 <COND (<THIS-PRSI?>
		<>)
	       (<VERB? OPEN UNLOCK>
		<COND (<T? ,END-GAME?>
		       <TELL CTHEO " is closed and locked." CR>
		       T)
		      (T <>)>)
	       (<ENTERING?>
		<COND (<HERE? IN-PORCH>
		       <DO-WALK ,P?EAST>)
		      (T
		       <DO-WALK ,P?WEST>)>
		T)
	       (T
		<>)>>

<OBJECT MANSION-DOOR
	(LOC LOCAL-GLOBALS)
	(DESC "front door")
	(FLAGS NODESC DOORLIKE OPENABLE LOCKED)
	(SYNONYM DOOR DOORWAY)
	(ADJECTIVE CLOSED SHUT FRONT ORNATE)
	(GENERIC GDOOR-F)
	(ACTION MANSION-DOOR-F)>

<DEFINE MANSION-DOOR-F ()
	 <COND (<THIS-PRSI?>
		<>)
	       (<AND <VERB? OPEN UNLOCK OPEN-WITH>
		     <NOT <IS? ,PRSO ,OPENED>>
		     <NOT <IS? ,PRSO ,LOCKED>>>
		<COND (<HERE? TROPHY-ROOM>
		       <TELL "The elaborate combination of locks, chains and bars on the door makes opening it impossible for amateurs." CR>)
		      (T
		       <TELL "It's practically impossible to find the doorknob. In fact, it's " ITAL "completely" "impossible, because there isn't one." CR>)>
		T)
	       (<ENTERING?>
		<COND (<HERE? OUTSIDE-MANSION>
		       <DO-WALK ,P?EAST>)
		      (T
		       <DO-WALK ,P?WEST>)>
		T)
	       (<AND <VERB? CLOSE> <IS? ,PRSO ,OPENED>>
		<TELL "Do you normally slam the door in your hostess's face? What would Miss Manners say? Miss Manners would push your teeth down your throat and tread on your head." CR>
		T)
	       (<VERB? EXAMINE LOOK-ON>
		<COND (<HERE? TROPHY-ROOM>
		       <TELL "The door is uninteresting except for the elaborate combination of locks, chains and bars on it." CR>)
		      (ELSE
		       <TELL "It's a fairly dull door with a fairly interesting doorbell." CR>)>
		T)
	       (<VERB? KNOCK>
		<TELL "There's no answer, but then the door's pretty thick. You have something in common with the door. Perhaps you should try the doorbell." CR>)
	       (T
		<>)>>

<OBJECT RADIO
	(LOC LOCAL-GLOBALS)
	(DESC "radio")
	(FLAGS TRYTAKE NOALL MUSICAL)
	(SYNONYM RADIO MUSIC SOUND RECORDING)
	(ADJECTIVE OLD OLD\-FASHIONED)
	(ACTION RADIO-F)>

<DEFINE RADIO-F ()
	 <COND (<THIS-PRSI?>
		<>)
	       (<VERB? EXAMINE>
		<COND (<AND <NOUN-USED? ,W?RADIO>
			    <HERE? TROPHY-ROOM>>
		       <TELL
			"It's one of those old-fashioned radios that looks like a small Bakelite model of a Post-Modernist office block with the volume turned up."
			CR>)
		      (T
		       <CANT-SEE-ANY-STR "that">)>)
	       (<VERB? LISTEN>
		<TELL CTHEO " is playing ">
		<SAY-MUZAK>
		<ZPRINT ,PERIOD>
		<TUNE-MENTIONED? T>
		T)
	       (T
		<>)>>

<OBJECT MANSION-BELL
	(LOC OUTSIDE-MANSION)
	(DESC "doorbell")
	(FLAGS NODESC)
	(SYNONYM DOORBELL BELL)
	(ADJECTIVE DOOR)
	(ACTION MANSION-BELL-F)>

"TOUCHED = rung, woman coming."

<DEFINE MANSION-BELL-F ()
	 <COND (<THIS-PRSI?>
		<>)
	       (<VERB? RING PUSH TOUCH>
		<TELL "When you push " THEO
" you hear an earsplitting clatter of bells, buzzers and gongs that shakes the mansion to its foundation." CR>
		<COND (<T? ,END-GAME?> T)
		      (T
		       <ZCRLF>
		       <COND
			(<IN? ,MATRON ,HERE>
			 <TELL "\"Stop that!\" cries " THE ,MATRON
			       ". \"I've already answered the door!\"" CR>
			 T)
			(<IS? ,PRSO ,TOUCHED>
			 <TELL 
			  "\"Patience, Cecil! Patience!\" scolds the voice beyond " 
			  THE ,MANSION-DOOR ,PERIOD>
			 <QUEUE I-MATRON-ANSWERS>
			 <SETG MMOVES 6> 
			 T)
			(T
			 <MAKE ,PRSO ,TOUCHED>
			 <QUEUE I-MATRON-ANSWERS>
			 <TELL 
"Nothing happens for a moment. Then an old woman's voice, deep within the mansion, cries \"Coming, Cecil!\"|
|
You hear footsteps behind " THE ,MANSION-DOOR ,PERIOD>
			 T)>)>)
	       (T
		<>)>>

<OBJECT TRUMPET
	(LOC MATRON)
	(DESC "ear trumpet")
	(FLAGS VOWEL TRYTAKE NOALL NODESC)
	(SYNONYM TRUMPET AID)
	(ADJECTIVE EAR HEARING)
	(ACTION TRUMPET-F)>

<DEFINE TRUMPET-F ()
	 <COND (<VERB? EXAMINE>
		<TELL CTHE ,MATRON " holds it tightly against her ear." CR>
		T)
	       (<VERB? LOOK-INSIDE SEARCH>
		<CANT-SEE-MUCH>
		T)
	       (T
		<>)>>

<OBJECT EGUN
	(LOC MATRON)
	(DESC "elephant gun")
	(FLAGS TRYTAKE NOALL VOWEL NODESC)
	(SYNONYM GUN WEAPON RIFLE)
	(ADJECTIVE ELEPHANT)
	(ACTION EGUN-F)>

<DEFINE EGUN-F ()
	 <COND (<VERB? EXAMINE>
		<TELL CTHEO " is rather formidable." CR>
		T)
	       (T
		<>)>>

<OBJECT FLAT-DOOR
	(LOC LOCAL-GLOBALS)
	(DESC "door")
	(FLAGS NODESC DOORLIKE LOCKED OPENABLE)
	(SYNONYM DOOR DOORWAY)
	(ADJECTIVE CLOSED SHUT LOCKED)
	(ACTION FLAT-DOOR-F)>

<DEFINE FLAT-DOOR-F ("AUX" TBL)
	 <COND (<THIS-PRSI?>
		<>)
	       (<ENTERING?>
		<COND (<HERE? THALL>
		       <DO-WALK ,P?EAST>)
		      (T
		       <DO-WALK ,P?WEST>)>
		T)
	       (<VERB? KNOCK>
		<COND (<NOT <IN? ,MOUSY ,IN-FLAT>>
		       <TELL "There is no reply." CR>)
		      (<OR <IS? ,PRSO ,OPENED>
			   <HERE? IN-FLAT>>
		       <MAKE ,MOUSY ,SEEN>
		       <TELL CTHE ,MOUSY " looks at you strangely." CR>
		       T)
		      (<IS? ,PRSO ,LOCKED>
		       <UNMAKE ,PRSO ,LOCKED>
		       <MAKE ,PRSO ,OPENED>
		       <SET TBL <GETPT ,PRSO ,P?ADJECTIVE>>
		       <ZPUT .TBL 0 ,W?OPENED>
		       <ZPUT .TBL 1 ,W?OPEN>
		       <ZPUT .TBL 2 ,W?UNLOCKED>
		       <TELL 
"Somebody unlocks the door from the inside. \"Come in, come in,\" says an impatient voice, and the door opens a little." CR>
		       T)
		      (T
		       <TELL "\"It's not locked!\" calls a voice inside." CR>
		       T)>)
	       (T
		<>)>>
		
<OBJECT TEN-STAIR 
	(LOC LOCAL-GLOBALS)
	(DESC "stairway")
	(FLAGS NODESC)
	(SYNONYM STAIRWAY STAIRS STAIR)
	(ACTION TEN-STAIR-F)>

<DEFINE PUT-ON-STAIRS? ()
	 <COND (<VERB? PUT PUT-ON EMPTY-INTO>
		<TELL 
"You'd probably trip on " THEO " if you did that." CR>
		T)
	       (T
		<>)>>

<DEFINE TEN-STAIR-F ()
	 <COND (<THIS-PRSI?>
		<COND (<PUT-ON-STAIRS?>
		       T)
		      (T
		       <>)>)
	       (<VERB? CLIMB-DOWN STAND-UNDER>
		<ALREADY-AT-BOTTOM>
		T)
	       (<VERB? CLIMB-UP CLIMB-ON CLIMB-OVER>
		<DO-WALK ,P?UP>
		T)
	       (<VERB? WALK-TO FOLLOW USE>
		<COND (<HERE? THALL>
		       <DO-WALK ,P?UP>)
		      (T
		       <V-WALK-AROUND>)>
		T)
	       (<VERB? EXAMINE LOOK-ON>
		<TELL CTHEO " leads up." CR>
		T)
	       (<VERB? LOOK-UP>
		<CANT-SEE-MUCH>
		T)
	       (<VERB? LOOK-DOWN>
		<ALREADY-AT-BOTTOM>
		T)
	       (T
		<>)>>

<OBJECT FLAT
	(LOC LOCAL-GLOBALS)
	(DESC "flat")
	(FLAGS NODESC PLACE)
	(SYNONYM FLAT APARTMENT HOME)
	(ACTION FLAT-F)>

<DEFINE FLAT-F ()
	 <COND (<HERE? IN-FLAT>
		<COND (<HERE-F>
		       T)
		      (T
		       <>)>)
	       (<ENTERING?>
		<DO-WALK ,P?EAST>
		T)
	       (T
		<>)>>

<OBJECT PAINTING
	(LOC TROPHY-ROOM)
	(SDESC DESCRIBE-PAINTING)
	(FLAGS TAKEABLE READABLE SURFACE)
	(SIZE 11)
	(CAPACITY 10)
	(SYNONYM ZZZP PORTRAIT PAINTING PICTURE)
	(ADJECTIVE LARGE DAMAGED)
	(DESCFCN PAINTING-F)
	(ACTION PAINTING-F)>

<VOC "REAGAN" OBJECT>
<VOC "GORBACHEV" OBJECT>

<DEFINE DESCRIBE-PAINTING ("OPT" (SHORT? <>))
	 <COND (<F? .SHORT?>
		<COND (<IS? ,PAINTING ,SHITTY>
		       <TELL "damaged ">)>
		<TELL "painting of ">)>
	 <COND (<MACAW-RIGHT?>
		<TELL "Mikhail S. Gorbachev">)
	       (ELSE
		<TELL "Ronald W. Reagan">)>
	 T>

" TOUCHED ==> not hanging on wall."

<DEFINE PAINTING-F PAINTING("OPTIONAL" (CONTEXT <>) "AUX" X)
	 <COND (<EQUAL? .CONTEXT ,M-OBJDESC>
		<COND (<IS? ,PAINTING ,TOUCHED>
		       <TELL CA ,PAINTING " is here.">)
		      (ELSE
		       <TELL 
		        CA ,PAINTING " is hanging on the wall.">)>
		<RETURN T .PAINTING>)
	       (<T? .CONTEXT>
		<RETURN <> .PAINTING>)
	       (<THIS-PRSI?>
		<COND (<AND <VERB? PUT-ON EMPTY-INTO>
			    <IN? ,PRSI ,PLAYER>>
		       <PRSO-SLIDES-OFF-PRSI>
		       <RETURN T .PAINTING>)
		      (<VERB? PUT-UNDER PUT-BEHIND>
		       <WASTE-OF-TIME>
		       <RETURN T .PAINTING>)
		      (T
		       <RETURN <> .PAINTING>)>)
	       (<ADJ-USED? ,W?DAMAGED>
		<COND (<NOT <IS? ,PAINTING ,SHITTY>>
		       <REFERRING>
		       <RETURN ,FATAL-VALUE .PAINTING>)>)>
         <SET X <FIRST? ,PAINTING>>
	 <COND (<VERB? REPAIR>
		<COND (<IS? ,PAINTING ,SHITTY>
		       <TELL "Unless you're a licensed painting repair">
		       <GENDER-PRINT <> "wo">
		       <TELL "man, you'd better leave well enough alone."
			     CR>
		       T)
		      (T
		       <TELL "The painting may not look that great, but you
probably can't improve it." CR>)>)
	       (<VERB? TAKE>
		<COND (<T? .X>
		       <TELL "You'd better take ">
		       <COND (<NEXT? .X>
			      <TELL "those things">)
			     (T
			      <TELL THE .X>)>
		       <TELL " off " THEO " first." CR>
		       T)
		      (<IN? ,PAINTING ,TROPHY-ROOM>
		       <MAKE ,PAINTING ,TOUCHED>
		       <>)
		      (T <>)>)		       
	       (<VERB? UNFOLD OPEN>
		<TELL "It's already as open as it's every going to get." CR>
		T)
	       (<VERB? EXAMINE READ>
		<DESCRIBE-PAINTING T>
		<TELL " stares back at you with cool authority">
		<COND (<IS? ,PRSO ,SHITTY>
		       <TELL ", despite the holes the macaw has ripped in his face">)>
		<COND (<T? .X>
		       <TELL ". There's also ">
		       <PRINT-CONTENTS ,PRSO>
		       <TELL " on " THEO>)>
		<ZPRINT ,PERIOD>
		T)
	       (<VERB? LOOK-ON>
		<TELL "Aside from ">
		<COND (<MACAW-RIGHT?>
		       <TELL "Gorbachev's">)
		      (ELSE
		       <TELL "Reagan's">)>
		<COND (<IS? ,PRSO ,SHITTY>
		       <TELL "damaged ">)>
		<TELL "likeness, you see ">
		<PRINT-CONTENTS ,PRSO>
		<TELL " on " THEO ,PERIOD>
		T)
	       (<VERB? RIP KICK MUNG KISS ;RAPE HIT>
		<TELL "Unfortunately, you are less adept at this sort of thing than your would-be victim. You realise very quickly that you are going to end up as low-grade airline food if you persist, so you stop persisting." CR>
		T)
	       (T <>)>>

<OBJECT PERCH
	(LOC IN-PORCH)
	(DESC "perch")
	(FLAGS TRYTAKE NOALL SURFACE)
	(CAPACITY 0)
	(SYNONYM PERCH)
	(ADJECTIVE BIRD\'S MACAW\'S)
	(DESCFCN PERCH-F)
	(ACTION PERCH-F)>

<DEFINE PERCH-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-OBJDESC>
		<MAKE ,MACAW ,SEEN>
		<TELL "A macaw with a missing ">
		<COND (<MACAW-RIGHT?>
		       <TELL "left">)
		      (ELSE
		       <TELL "right">)>
		<TELL " wing is watching you from a perch in " THE ,CORNER>
		<COND (<FIRST? ,UNDER-PERCH>
		       <TELL ". Under " THE ,PERCH " you see ">
		       <PRINT-CONTENTS ,UNDER-PERCH>)>
		<TELL ".">
		T)
	       (<T? .CONTEXT>
		<>)
	       (<THIS-PRSI?>
		<COND (<VERB? PUT-ON>
		       <TELL CTHE ,MACAW " nearly
takes your hand off with its sharp beak. You give up." CR>
		       T)
		      (<VERB? PUT-UNDER>
		       <COND (<IS? ,MACAW ,SHITTY>
			      <TELL CTHE ,MACAW " suddenly wakes up. ">
			      <UNMAKE ,MACAW ,SHITTY>)>
		       <TELL "You might have thought that " THE ,MACAW
			     " couldn't
move very fast, considering that it has only one wing; you would have been
wrong. The damned thing has the speed, grace and tolerance of a shoal of
pirhana fish, and after nearly losing your hand you side-step to safety. ">
		       <COND (<IS? ,SHITMAIL ,SHITTY>
			      <REMOVE ,SHITMAIL>
			      <TELL "It then gobbles up the shreds of mail,">)
			     (<IS? ,SHITMAIL ,SEEN>
			      <TELL "To relieve its frustration, the macaw
shreds the mail under the perch, then resumes its perch,">
			      <MAKE ,SHITMAIL ,SHITTY>)
			     (T
			      <MAKE ,SHITMAIL ,SEEN>
			      <TELL CTHE ,MACAW>)>
		       <TELL " fixes you with its livid, gin-sodden little eye, and bellows, \"Change your address! Change your address!\"" CR>
		       T)
		      (<VERB? PUT-BEHIND>
		       <TELL "There's no room behind " THEI
" for anything. Plenty of room underneath, though." CR>
		       T)
		      (T
		       <>)>)
	       (<VERB? LOOK-UNDER>
		<TELL ,YOU-SEE>
		<PRINT-CONTENTS ,UNDER-PERCH>
		<TELL " under " THEO ,PERIOD>
		T)
	       (<VERB? EXAMINE LOOK-ON>
		<TELL "A bellicose and physically challenged macaw is sitting on " THEO>
		<COND (<AND <VERB? EXAMINE>
			    <FIRST? ,UNDER-PERCH>>
		       <TELL ". Underneath it, you see ">
		       <PRINT-CONTENTS ,UNDER-PERCH>)>
		<ZPRINT ,PERIOD>
		T)
	       (<MOVING?>
		<FIRMLY-ATTACHED ,PRSO <> "the floor">
		T)
	       (T
		<>)>>

<OBJECT UNDER-PERCH
	(LOC IN-PORCH)
	(DESC "floor")
	(FLAGS NODESC SURFACE)
	(SYNONYM ZZZP)
	(ADJECTIVE ZZZP ZZZP ZZZP ZZZP)
	(CONTFCN UNDER-PERCH-F)
	(CAPACITY 20)>

<DEFINE UNDER-PERCH-F PERCH ("OPTIONAL" (CONTEXT <>) "AUX" X Y)
	 <COND (<EQUAL? .CONTEXT ,M-CONT>
		<COND (<THIS-PRSI?>
		       <SET X ,PRSI>
		       <SET Y ,PRSO>)
		      (T
		       <SET X ,PRSO>
		       <SET Y ,PRSI>)>
		<COND (<VERB? EXAMINE> <RETURN <> .PERCH>)
		      (<EQUAL? .X ,PAINTING>)
		      (<NOT <TOUCHING?>>
		       <RETURN <> .PERCH>)>
		<COND (<AND <VERB? OPEN>
			    ,PRSO
			    <T? <GETP ,PRSO ,P?MAIL-LETTER>>>
		       <RETURN <> .PERCH>)>
		<COND (<IS? ,MACAW ,SHITTY>
		       <TELL CTHE ,MACAW ", apparently exhausted by the
ferocity of its attack on the painting, doesn't seem to notice you" ,PCR>
		       <RETURN <> .PERCH>)>
		<TELL "As you reach towards ">
		<COND (<==? .X ,SHITMAIL>
		       <TELL "the mail">)
		      (T
		       <TELL THE .X>)>
		<TELL ", " THE ,MACAW " yells obscenely and drives you
back." CR>)
	       (T
		<>)>>

<OBJECT MACHINE
	(LOC BROOM)
	(DESC "combination telephone/answering machine")
	(FLAGS TAKEABLE SURFACE)
	(CAPACITY 0)
	(SIZE 11)
	(SYNONYM TELEPHONE PHONE MACHINE)
	(ADJECTIVE TELEPHONE PHONE-ANSWERING ANSWERING COMBINATION)
        (ACTION MACHINE-F)>

<OBJECT PLAYBACK-BUTTON
	(LOC MACHINE)
	(DESC "messages button")
	(FLAGS NODESC)
	(SYNONYM BUTTON MESSAGES MESSAGE)
	(ADJECTIVE PLAYBACK MESSAGES MESSAGE)
	(ACTION PB-BUTTON-F)>

<SETG PHONE-MSGS <LTABLE 0
			 "Jones here. I'm the new tenant of your old house. There's a whole bunch of mail been arriving here for you. Urgent stuff from the Fillmore Fiduciary Trust. You know what I thought? I thought 'Do the right thing, Jones. Forward the guy's mail.' Then I found out about the termites. Then I found out about the nightly roach-dance. So I thought 'Rats.' I've returned your mail to your bank. Sort it out yourself."
			 0
			 0
			 "Hi there! Mr Barty Slartfast? Boysenberry Users' Group here. Just a reminder about our next meeting. We've got this insanely great adventure in, it comes in this blue box and, well, you're an income tax inspector and you're on this, uh, bridge, and, um... well, tell you about it at the meeting tomorrow evening at... hello? Hello?"
			 "You have won $25,000! Oops, you're not home, are you? Oh well, too bad. I'll call the alternate winner."
			 0
			 0
			 "Look, just because I'm paranoid doesn't mean they aren't out to get me.">>

<DEFINE MORE-MESSAGES? ()
  <COND (<AND <==? <ZGET ,PHONE-MSGS 0> 0>
	      <G? <ZGET ,OTHER-PHONE-MSGS 0> 0>>
	 T)
	(T <>)>>

<DEFINE SETUP-NEXT-MESSAGES ("AUX" N)
  <SETG PHONE-MSGS <ZGET ,OTHER-PHONE-MSGS
			 <SET N <ZGET ,OTHER-PHONE-MSGS 0>>>>
  <ZPUT ,OTHER-PHONE-MSGS 0 <SET N <- .N 1>>>>

<CONSTANT OTHER-PHONE-MSGS
	  <LTABLE
	   <LTABLE 0
		   -1
		   GIRLFRIEND-MESSAGE
		   "I think you ought to know that I'm falling in love with your answering machine. It's the only thing that'll talk to me these days.">
	   <LTABLE -1
		   OLD-GIRLFRIEND-MESSAGE
		   0>
	   <LTABLE "This is Fillmore Fiduciary. We haven't received your change-of-address form yet, so we can't send your bank statement. We thought you'd like to know that you're overdrawn."
		   0>>>

<DEFINE GIRLFRIEND-MESSAGE ()
  <TELL ,THIS-IS "your ">
  <ITALICIZE "former">
  <TELL " friend ">
  <SHOW-FIELD ,FRIEND>
  <TELL ". My new ">
  <GENDER-PRINT "boy" "girl">
  <TELL "friend and I are off to Paris for some R&R. Don't try to get us to bail you out when you land in the slammer there.">>

<DEFINE OLD-GIRLFRIEND-MESSAGE ()
  <TELL "Hi, it's ">
  <SHOW-FIELD ,LAST-FRIEND>
  <TELL ". ">
  <GENDER-PRINT "Trent" "Tiffany">
  <TELL " and I are getting married, and you're invited if you promise to stay sober. And none of that terrible stuff with reptiles, either. And Mother says 'Please do not bring the skunk.'">>

<DEFINE PB-BUTTON-F ("AUX" (NUM <ZGET ,PHONE-MSGS 0>) (I 1) TMP)
	<COND (<VERB? PUSH LISTEN>
	       <COND (<IS? ,MACHINE ,SEEN>
		      <TELL "You have to hang up the phone first!" CR>)
		     (<==? .NUM 0> <TELL "You have no messages." CR>)
		     (ELSE
		      <REPEAT ()
			      <COND (<G? .I .NUM> <RETURN>)
				    (ELSE
				     <ZCRLF>
				     <ZBUFOUT <>>
				     <TELL "--- Type any character for next msg ---">
				     <ZBUFOUT T>
				     <INPUT 1>
				     <ZCRLF>)>
			      <SET TMP <ZGET ,PHONE-MSGS .I>>
			      <COND (<==? .TMP 0>
				     <TELL "You hear "> 
				     <ITALICIZE "click">
				     <TELL " followed by a dialling tone." CR>
				     <UPDATE-BP 1>
				     <DISPLAY-BP>)
				    (ELSE
				     <TELL "The machine says: \"">
				     <COND (<==? .TMP -1>
					    <ZAPPLY
					     <ZGET ,PHONE-MSGS
						   <SET I <+ .I 1>>>>)
					   (T
					    <TELL .TMP>)>
				     <TELL "\"" CR>)>
			      <SET I <+ .I 1>>>
		      <ZPUT ,PHONE-MSGS 0 0>)>
	       T)
	      (<VERB? TAKE>
	       <TELL "Try as you might, you can't break it off." CR>)>>

"SEEN = in use (phone)."

<DEFINE MACHINE-F ()
	<COND (<VERB? EXAMINE LOOK-ON>
	       <TELL "There are certain answering machines which exert a malign
influence. They attract rude and inexplicable messages. They intimidate at
least 30 per cent of callers, so that half the time you get just an
irritating \"click\" and your blood pressure goes up. This is one of those
machines. It has a button marked " ITAL "Playback messages" ,PERIOD>
	       T)
	      (<VERB? LAMP-ON PLAY>
	       <PERFORM ,V?PUSH ,PLAYBACK-BUTTON>)
	      (<VERB? TAKE UNPLUG>
	       <TELL "You probably should leave the machine where it is, in case you get an important message." CR>
	       T)
	      (ELSE <>)>>

<DEFINE CALLING-HOME? HOME? ("AUX" (FLD <ZREST <ZGET ,LICENSE-FORM
					       <+ ,PHONE-NUMBER 1>>
					 <- ,FIELD-DATA-OFFSET 1>>)
		       MAX:FIX NLEN:FIX (IB ,P-INBUF) TF TNLEN)
  <COND (<G? <SET NLEN <GETB .FLD 0>>
	     <SET MAX <GETB .IB 1>>>
	 <>)
	(T
	 <SET TF .FLD>
	 <SET TNLEN .NLEN>
	 <SET IB <ZREST .IB 2>>
	 <PROG (SIB SMAX)
	   ; "First find the first character of the number in the inbuf"
	   <REPEAT ((1ST? <CHTYPE <GETB .FLD 1> FIX>))
	     <COND (<L? .MAX <- .NLEN 2>>
		    ; "Not enough chars to match, so really lose"
		    <RETURN <> .HOME?>)
		   (<N==? .1ST? <CHTYPE <GETB .IB 0> FIX>>
		    <SET IB <ZREST .IB>>
		    <COND (<L? <SET MAX <- .MAX 1>> 1>
			   ; "Ran out of chars altogether"
			   <RETURN <> .HOME?>)>)
		   (T
		    <RETURN>)>>
	   ; "Point to rest of number in inbuf"
	   <SET IB <ZREST .IB 1>>
	   ; "Save it in case we come back"
	   <SET SIB .IB>
	   <SET MAX <- .MAX 1>>
	   <SET SMAX .MAX>
	   ; "Point to rest of number in field"
	   <SET FLD <ZREST .FLD 2>>
	   <REPEAT (C1 C2)
	     <COND (<N==? <SET C1 <CHTYPE <GETB .IB 0> FIX>>
			  <SET C2 <CHTYPE <GETB .FLD 0> FIX>>>
		    ; "Bytes don't match"
		    <COND (<AND <CHECK-NUMBER .C1>
				<CHECK-NUMBER .C2>>
			   ; "they're both numbers, so this can't be it"
			   <RETURN>)>
		    <COND (<CHECK-NUMBER .C1>
			   ; "Number in first"
			   <COND (<EQUAL? .C2 %<ASCII !\ > %<ASCII !\->>
				  ; "Space or - in second, so dump it and
				     try again"
				  <SET FLD <ZREST .FLD 1>>
				  <COND (<L? <SET NLEN <- .NLEN 1>> 1>
					 ; "Oops, ran out of characters"
					 <RETURN>)>
				  <AGAIN>)
				 (T
				  ; "Not a match"
				  <RETURN>)>)
			  (<CHECK-NUMBER .C2>
			   ; "Number in second"
			   <COND (<EQUAL? .C1 %<ASCII !\ > %<ASCII !\->>
				  ; "Space or - in first, so dump that"
				  <SET IB <ZREST .IB 1>>
				  <COND (<L? <SET MAX <- .MAX 1>>
					     1>
					 ; "Unless we ran out, in which
					    case we're really done"
					 <RETURN <> .HOME?>)>
				  <AGAIN>)>)>)>
	     ; "Eat characters from both, since they're both still happy"
	     <SET MAX <- .MAX 1>>
	     <SET NLEN <- .NLEN 1>>
	     ; "If we're out of characters from the form, we won"
	     <COND (<L? .NLEN 1> <RETURN T .HOME?>)>
	     ; "If we're out of characters from the inbuf, we lost"
	     <COND (<L? .MAX 1> <RETURN <> .HOME?>)>
	     <SET IB <ZREST .IB 1>>
	     <SET FLD <ZREST .FLD 1>>>
	   ; "This didn't match, so back up to one past the match of the
	      first character in the number and try again."
	   <SET FLD .TF>
	   <SET NLEN .TNLEN>
	   <SET IB .SIB>
	   <SET MAX .SMAX>
	   <AGAIN>>)>>

<OBJECT ABOOK
	(LOC BTABLE)
	(DESC "address book")
	(FLAGS VOWEL TAKEABLE READABLE CONTAINER OPENABLE)
	(SIZE 5)
	(SYNONYM BOOK ADDRESSES ADDRESS)
	(ADJECTIVE CLOSED SHUT ADDRESS LOOSELEAF LOOSE-LEAF)
	(GENERIC GENERIC-ADDRESS)
	(ACTION ABOOK-F)>

<DEFINE ABOOK-F ()
	 <COND (<THIS-PRSI?>
		<COND (<VERB? PUT PUT-ON EMPTY-INTO>
		       <PRSO-SLIDES-OFF-PRSI>
		       T)
		      (<VERB? PUT-UNDER>
		       <WASTE-OF-TIME>
		       T)
		      (T
		       <>)>)
	       (<VERB? EXAMINE LOOK-INSIDE SEARCH READ>
		<COND (<VERB? READ LOOK-INSIDE SEARCH>
		       <MAKE ,PRSO ,OPENED>
		       <TELL "On opening " THEO ", you find that in">)
		      (T
		       <TELL ,THIS-IS "a">
		       <COND (<IS? ,PRSO ,OPENED>
			      <TELL "n open">)
			     (T
			      <TELL " closed">)>
		       <TELL " loose-leaf " Q ,PRSO ". In">)>
		<TELL " common with many loose-leaf " Q ,PRSO
"s, most of the pages are loose and have fallen out. There are only two or three left. Most of these are stuck together with jam, chewing gum or an unpleasant combination of both." CR>
		<COND (<VERB? READ>
		       <ZCRLF>
		       <SETG P-SPECIAL-ORPHAN " do you want to read,">
		       <FAKE-VERB/NOUN ,W?READ <> <> ,W?PAGE>
		       <SETG P-SPECIAL-ORPHAN <>>
		       ,FATAL-VALUE)
		      (T T)>)
	       (<AND <VERB? OPEN>
		     <NOT <IS? ,PRSO ,OPENED>>>
		<MAKE ,PRSO ,OPENED>
		<TELL "You flip open " THEO ,PERIOD>
		T)
	       (<AND <VERB? CLOSE>
		     <IS? ,PRSO ,OPENED>>
		<UNMAKE ,PRSO ,OPENED>
		<TELL "You snap " THEO " shut." CR>
		T)
	       (T
		<>)>>

<OBJECT PAGE-3
	(LOC ABOOK)
	(DESC "last page")
	(FLAGS NODESC TRYTAKE NOALL READABLE)
	(SYNONYM PAGE LEAF PAGES THREE)
	(ADJECTIVE LAST FINAL THIRD PAGE)
	(GENERIC GENERIC-PAGE-F)
	(ACTION PAGE-3-F)>

<DEFINE PAGE-3-F ("AUX" N)
	 <COND (<THIS-PRSI?>
		<>)
	       (<HANDLE-PAGES?>
		T)
	       (<VERB? EXAMINE READ LOOK-ON>
		<COND (<NOT <IS? ,PRSO ,SEEN>>
		       <MAKE ,PRSO ,SEEN>
		       <SET N <ZRANDOM 9997>>
		       <ZPUT ,PHONE-NUMBERS ,WORK-NUMBER <SET N <+ .N 1>>>
		       <SET N <ZRANDOM 9997>>
		       <ZPUT ,PHONE-NUMBERS ,CAB-NUMBER <SET N <+ .N 1>>>)>
		<TELL "Only two entries are legible on this page." CR>
		<HLIGHT ,H-BOLD>
		<TELL CR "Mr Ollie Fassbaum, Manager|
The Happitec Corporation|
17 Okapi Plaza" CR>
		<SHOW-FIELD ,CITY-NAME>
		<TELL ", ">
		<SHOW-FIELD ,STATE-NAME>
		<TELL " ">
		<SHOW-FIELD ,ZIP-CODE>
		<SAY-NUMBER ,WORK-NUMBER-X>
		<TELL CR "and" CR>
		<HLIGHT ,H-BOLD>
		<TELL CR "Getlost Airport Cab">
		<SAY-NUMBER ,CAB-NUMBER-X>		
		T)
	       (T
		<>)>>

<OBJECT PAGE-2
	(LOC ABOOK)
	(DESC "middle page")
	(FLAGS NODESC TRYTAKE NOALL READABLE)
	(SYNONYM PAGE LEAF PAGES TWO)
	(ADJECTIVE MIDDLE SECOND PAGE)
	(GENERIC GENERIC-PAGE-F)
	(ACTION PAGE-2-F)>

<DEFINE PAGE-2-F ("AUX" N)
	 <COND (<THIS-PRSI?>
		<>)
	       (<HANDLE-PAGES?>
		T)
	       (<VERB? EXAMINE READ LOOK-ON>
		<COND (<NOT <IS? ,PRSO ,SEEN>>
		       <MAKE ,PRSO ,SEEN>
		       <SET N <ZRANDOM 9997>>
		       <ZPUT ,PHONE-NUMBERS ,OBANK-NUMBER <SET N <+ .N 1>>>
		       <SET N <ZRANDOM 9997>>
		       <ZPUT ,PHONE-NUMBERS ,BANK-NUMBER <SET N <+ .N 1>>>
		       <SET N <ZRANDOM 9997>>
		       <ZPUT ,PHONE-NUMBERS ,OLD-FRIEND <SET N <+ .N 1>>>
		       <SET N <ZRANDOM 9997>>
		       <ZPUT ,PHONE-NUMBERS ,NEW-FRIEND <SET N <+ .N 1>>>)>
		<TELL "This page offers some personal numbers and two of your bank's addresses" ,PCR>
		<HLIGHT ,H-BOLD>
		<SHOW-FIELD ,LAST-FRIEND>
		<SAY-NUMBER ,OLD-FRIEND-X>
		<HLIGHT ,H-BOLD>
		<ZCRLF>
		<SHOW-FIELD ,FRIEND>
		<SAY-NUMBER ,NEW-FRIEND-X>
		<SAY-BANK>
		<TELL "14 West Wildebeest Street|
Rhinoceros, NJ 81818">
		<SAY-NUMBER ,OBANK-NUMBER-X>
		<TELL CR "and" CR>
		<SAY-BANK>
		<TELL N <- <GETP ,ST-A ,P?STADDR> 1> " ">
		<SHOW-FIELD ,STREET-NAME>
		<ZCRLF>
		<SHOW-FIELD ,CITY-NAME>
		<TELL ", ">
		<SHOW-FIELD ,STATE-NAME>
		<TELL " ">
		<SHOW-FIELD ,ZIP-CODE>
		<SAY-NUMBER ,BANK-NUMBER-X>		      
		T)
	       (T
		<>)>>

<DEFINE SAY-BANK ()
	 <HLIGHT ,H-BOLD>
	 <TELL CR "Fillmore Fiduciary Trust" CR>
	 T>

<OBJECT PAGE-1
	(LOC ABOOK)
	(DESC "first page")
	(FLAGS NODESC TRYTAKE NOALL READABLE)
	(SYNONYM PAGE LEAF PAGES ONE)
	(ADJECTIVE FIRST FRONT PAGE)
	(GENERIC GENERIC-PAGE-F)
	(ACTION PAGE-1-F)>

<SETG NERD-HACKED-ABOOK? <>>

<DEFINE PAGE-1-F ("AUX" N X BOT TOP)
	 <COND (<THIS-PRSI?>
		<>)
	       (<HANDLE-PAGES?>
		T)
	       (<VERB? EXAMINE READ LOOK-ON>
		<COND (<NOT <IS? ,PRSO ,SEEN>>
		       <MAKE ,PRSO ,SEEN>
		       <SET N <ZRANDOM 9997>>
		       <ZPUT ,PHONE-NUMBERS ,OHOME-NUMBER 
			    <SET N <+ .N 1>>>)>
		<TELL "This page is labelled NAME AND ADDRESS OF OWNER. ">
		<COND (<T? ,NERD-HACKED-ABOOK?>
		       <TELL "You see" CR CR>
		       <HLIGHT ,H-BOLD>
		       <TELL "RANDOM Q HACKER" CR "5 RAINBOW TURTLE Vista">)
		      (T
		       <TELL " In your own handwriting you see">
		       <BOLD-NAME>
		       <TELL "5 Hippo Vista">)>
		<ZCRLF>
		<TELL "Rhinoceros, NJ 81818">
		<SAY-NUMBER ,OHOME-NUMBER-X>
		<TELL CR 
		      "which has been crossed out (aren't you glad you moved?).
Under that you">
		<COND (<T? ,NERD-HACKED-ABOOK?> <TELL " see">)
		      (T <TELL "'ve written">)>
		<BOLD-NAME>
		<SHOW-FIELD ,STREET-NUMBER>
		<TELL " ">
		<SHOW-FIELD ,STREET-NAME>
		<ZCRLF>
		<SHOW-FIELD ,CITY-NAME>
		<TELL ", ">
		<SHOW-FIELD ,STATE-NAME>
		<TELL " ">
		<SHOW-FIELD ,ZIP-CODE>
		<ZCRLF>
		<SHOW-FIELD ,PHONE-NUMBER>
		<HLIGHT ,H-NORMAL>
		<TELL CR CR
"There's also a notice on this page which says, \"If lost, please return this address book to the owner at the above address. $25 reward.\"" CR>
		T)
	       (T
		<>)>>

<DEFINE BOLD-NAME ()
	 <ZCRLF>
	 <HLIGHT ,H-BOLD>
	 <ZCRLF>
	 <PRINT-FULL-NAME>
	 <ZCRLF>
	 T>

<DEFINE SAY-NUMBER (X)
	 <TELL CR N <ZGET ,PHONE-NUMBERS .X> "-">
	 <SET X <+ .X 1>>
	 <SET X <ZGET ,PHONE-NUMBERS .X>>
	 <COND (<L? .X 10>
		<TELL "000">)
	       (<L? .X 100>
		<TELL "00">)
	       (<L? .X 1000>
		<TELL "0">)>
	 <TELL N .X CR>
	 <HLIGHT ,H-NORMAL>
	 T>

<DEFINE GENERIC-PAGE-F (TBL "AUX" LEN)
	 <SET LEN <ZGET .TBL 0>>
	 <COND (<INTBL? ,P-IT-OBJECT <ZREST .TBL 2> .LEN>
		,P-IT-OBJECT)
	       (T
		<>)>>

<DEFINE HANDLE-PAGES? ()
	 <COND (<MOVING?>
		<TELL "Better not. The pages in the " Q ,ABOOK
		      " are quite fragile." CR>
		T)
	       (T
		<>)>>

<MSETG OHOME-NUMBER-X 0>
<MSETG OHOME-NUMBER 1>
<MSETG WORK-NUMBER-X 2>
<MSETG WORK-NUMBER 3>
<MSETG CAB-NUMBER-X 4>
<MSETG CAB-NUMBER 5>
<MSETG OBANK-NUMBER-X 6>
<MSETG OBANK-NUMBER 7>
<MSETG BANK-NUMBER-X 8>
<MSETG BANK-NUMBER 9>
<MSETG OLD-FRIEND-X 10>
<MSETG OLD-FRIEND 11>
<MSETG NEW-FRIEND-X 12>
<MSETG NEW-FRIEND 13>

<OBJECT GBANK
	(LOC GLOBAL-OBJECTS)
	(DESC "bank")
	(FLAGS NODESC PLACE)
	(SYNONYM BANK TRUST)
	(ADJECTIVE FILLMORE FIDUCIARY TRUST)
	(ACTION GBANK-F)>

<DEFINE GBANK-F ()
	 <COND (<THIS-PRSI?>
		<>)
	       (<OR <VERB? PHONE>
		    <AND <VERB? SAY>
			 <EQUAL? ,P-PRSA-WORD ,W?CALL>>>
		<TELL "You'll need a ">
		<COND (<NOT <VISIBLE? ,MACHINE>>
		       <TELL "telephone and a ">)>
		<TELL "phone number to do that." CR>
		T)
	       (<VERB? WALK-TO>
		<PERFORM ,V?WALK-TO ,BANK>)
	       (<HERE? BANK ST-A>
		<PERFORM ,PRSA ,BANK>)
	       (<SEEING?>
		<CANT-SEE-ANY>
		,FATAL-VALUE)
	       (<TOUCHING?>
		<CANT-FROM-HERE>
		T)
	       (T
		<>)>>

<DEFINE CALL-BANK ("OPTIONAL" (L <>))
	 <MAKE ,MACHINE ,SEEN>
	 <UNMAKE ,BANKSOUND ,NODESC>
	 <TELL "After a few seconds you're connected. A woman says, \"Good ">
	 <COND (<G? ,HOURS 17>
		<TELL "evening">)
	       (<G? ,HOURS 11>
		<TELL "afternoon">)
	       (T
		<TELL "morning">)>
	 <TELL 
", and thank you for calling the Fillmore Fiduciary Trust Bank, ">
	 <COND (<ZERO? .L>
		<TELL "Rhinoceros">)
	       (T
		<SHOW-FIELD ,CITY-NAME>)>
	 <TELL " Branch. ">
	 <COND (<G? ,HOURS 15>
		<TELL
"Our office is open from 10:00 am to 4:00 pm Monday through Friday, except on holidays. This is a recording. Have a nice day.\"|
|
You hear a dialling tone." CR>)
	       (T
		<UNMAKE ,BANKSOUND ,INVISIBLE>
		<QUEUE I-BANK>
		<TELL "Please hold.\"" CR>
		<SETUP-BANKMUSIC>)>
	 <UPDATE-BP 3>
	 T>

<OBJECT CABSOUND
	(LOC BROOM)
	(DESC "that")
	(SDESC SAY-CABSOUND)
	(FLAGS NODESC NOARTICLE INVISIBLE)
	(GENERIC GENERIC-SOUND)
	(SYNONYM ZZZP ZZZP ZZZP ZZZP ZZZP)
	(ACTION CABSOUND-F)>

<BIT-SYNONYM NOARTICLE OFFLINE>

"OFFLINE = company not on line, LIVING/PERSON = man talking."

<DEFINE SAY-CABSOUND ()
	 <COND (<IS? ,CABSOUND ,LIVING>
		<TELL "voice">)
	       (<NOT <IS? ,CABSOUND ,OFFLINE>>
		<TELL "music">)
	       (T
		<TELL "that">)>
	 T>

<DEFINE CABSOUND-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<IS? ,CABSOUND ,NOARTICLE>
		<REFERRING>
		,FATAL-VALUE)
	       (<EQUAL? .CONTEXT ,M-WINNER>
		<COND (<IS? ,CABSOUND ,LIVING>
		       <TELL 
"The voice mutters something indelicate." CR>
		       ,FATAL-VALUE)
		      (T
		       <TELL "There's nobody on the line at the moment." CR>
		       T)>)
	       (T
		<>)>>

<DEFINE SETUP-CABMAN ("AUX" TBL)
	 <UNMAKE ,CABSOUND ,NOARTICLE>
	 <UNMAKE ,CABSOUND ,INVISIBLE>
	 <UNMAKE ,CAB ,INVISIBLE>
	 <UNMAKE ,CAB-DRIVER ,INVISIBLE>
	 <MAKE ,CABSOUND ,LIVING>
	 <MAKE ,CABSOUND ,PERSON>
	 <SET TBL <GETPT ,CABSOUND ,P?SYNONYM>>
	 <ZPUT .TBL 0 ,W?VOICE>
	 <ZPUT .TBL 1 ,W?MAN>
	 <ZPUT .TBL 2 ,W?GUY>
	 <ZPUT .TBL 3 ,W?FELLOW>
	 <ZPUT .TBL 4 ,W?SOUND>
	 T>

<DEFINE SETUP-CABMUSIC ("AUX" TBL)
	 <SETG HOLD-TURNS 0>
	 <UNMAKE ,CABSOUND ,INVISIBLE>
	 <UNMAKE ,CABSOUND ,NOARTICLE>
	 <UNMAKE ,CABSOUND ,LIVING>
	 <UNMAKE ,CABSOUND ,PERSON>
	 <SET TBL <GETPT ,CABSOUND ,P?SYNONYM>>
	 <ZPUT .TBL 0 ,W?MUSIC>
	 <ZPUT .TBL 1 ,W?MUZAK>
	 <ZPUT .TBL 4 ,W?SOUND>
	 <ZPUT .TBL 2 ,W?ZZZP>
	 <ZPUT .TBL 3 ,W?ZZZP>
	 T>

<DEFINE CABSOUND-OFF ("AUX" (CNT 4) TBL)
	 <MAKE ,CABSOUND ,INVISIBLE>
	 <UNMAKE ,CABSOUND ,LIVING>
	 <UNMAKE ,CABSOUND ,PERSON>
	 <MAKE ,CABSOUND ,OFFLINE>
	 <SET TBL <GETPT ,CABSOUND ,P?SYNONYM>>
	 <REPEAT ()
		 <ZPUT .TBL .CNT ,W?ZZZP>
		 <COND (<L? <SET CNT <- .CNT 1>> 0>
			<RETURN>)>>
	 <DEQUEUE I-CAB-MUSIC>
	 T>

<MSETG CAB-INIT 0>		;"Cab isn't doing anything"
<MSETG CAB-SENT 1>		;"Cab is on its way"
<MSETG CAB-HERE 2>		;"Cab is at your house"
<MSETG CAB-RETURNED 3>		;"Cab left because you weren't around"
<MSETG CAB-INHABITED 4>		;"You are in the cab"
<MSETG CAB-JUST-AT-AIRPORT 5>	;"Cab at airport"
<MSETG CAB-NEEDS-ID 6>		;"Cab driver needs ID"
<MSETG CAB-HAS-COLLECTED 7>	;"Cab driver has been payed"
<MSETG CAB-EXIT-ATTEMPT 8>	;"You have attempted to leave the cab
				  without paying"
<MSETG CAB-WAITING-FOR-YOUR-EXIT 9>
				;"You are hanging around in the cab"
<MSETG CAB-DRIVER-PISSED 10>	;"You've overstayed your welcome"
<MSETG CAB-AT-AIRPORT 11>	;"Driver has asked for money."
<MSETG MAX-CABLEN 18>

<DEFINE-GLOBALS CABTABLE
		(CABNUM <TABLE 0 0 0 0 0 0 0 0 0 0>)
		(CABNAME <TABLE 0 0 0 0 0 0 0 0 0 0>)
		(CABADDR <TABLE 0 0 0 0 0 0 0 0 0 0>)
		(CABMUSIC:FIX BYTE 0)
		(STNUM-VALUE:FIX 0)
		(CABTIMES:FIX BYTE 0)
		(CABTURNS:FIX BYTE 0)
		(CABSTATE:FIX BYTE ,CAB-INIT)
		(CABPREVNAME <TABLE 0 0 0 0 0 0 0 0 0 0>)
		(CAB-DONT:FIX BYTE 0)>

; "Should be in PLACES..."
<DEFINE ENTER-FROM-OUTSIDE ()
  <COND (<==? <CABSTATE> ,CAB-HERE>
	 <PERFORM ,V?ENTER ,CAB>
	 <>)
	(<IS? ,FROOM-DOOR ,OPENED>
	 ,FROOM)
	(T
	 <TELL "The front door is closed." CR>
	 <>)>>

<DEFINE PRINT-CABFIELD (TBL "AUX" (PTR 1) LEN (FIRST T) CHR)
	 <SET LEN <GETB .TBL 0>>
	 <REPEAT ()
		 <SET CHR <GETB .TBL .PTR>>
		 <COND (.FIRST
			<COND (<AND <G=? .CHR %<ASCII !\a>>
				    <L=? .CHR %<ASCII !\z>>>
			      <SET CHR <- .CHR 32>>)>
			<SET FIRST <>>)
		       (<==? .CHR 32> <SET FIRST T>)>
		 <PRINTC .CHR>
		 <COND (<G? <SET PTR <+ .PTR 1>> .LEN>
			<RETURN>)>>
	 T>

<CONSTANT CAB-EXCUSES <PTABLE "bankers are lousy tippers"
			      "the diner is such a dive"
			      0
			      "that old lady keeps shooting at our drivers"
			      "every time we give the llama a ride, we have to fumigate our taxi"
			      "the resident of that house is absolutely mad">>

<DEFINE CALL-CAB CC ("AUX" (X <>) WORD PTR TBL LEN (STREET-OK T)
			   (CS <CABSTATE>) (CD <CAB-DONT>) (TAKE-INFO T)
			   (CT <CABTIMES>))
	 <COND (<QUEUED? I-NO-CAB> <DEQUEUE I-NO-CAB>)>
	 <CAB-DONT <>>
	 <MAKE ,MACHINE ,SEEN>
	 <SETUP-CABMAN>
	 <TELL 
"After a few rings a man answers. \"Getlost Airport Cab. Last name of passenger please.\"" CR>
	 <SET WORD <GET-CABWORD <CABNAME>>>
	 <COND (<NOT <IS? ,MACHINE ,SEEN>> <RETURN T .CC>)>
	 <COND (<T? ,END-GAME?>
		<SET CT 0>)>
	 <COND (<N==? .CT 0>
		<COND (<NEQ-TBL <CABNAME>
				<CABPREVNAME>>
		       <TELL "\"You sound a lot like ">
		       <MR-OR-MISS>
		       <PRINT-CABFIELD <CABPREVNAME>>
		       <TELL ". Are you some kind of prankster?\"" CR>
		       <COND (<QUEUED? I-CAB> <DEQUEUE I-CAB>)>)
		      (<OR <==? .CS ,CAB-RETURNED> <T? .CD>>
		       <TELL "\"Gee">
		       <LADY-OR-MISTER>
		       <TELL ", we sent a cab to "
			     N <STNUM-VALUE> " ">
		       <PRINT-CABFIELD <CABADDR>>
		       <TELL " and the driver couldn't find you. Is that address correct?\"" CR>
		       <UPDATE-BP 5>
		       <REPEAT ()
			       <SET WORD <GET-CABWORD>>
			       <COND (<NOT <IS? ,MACHINE ,SEEN>>
				      <RETURN T .CC>)>
			       <COND (<YES-USED? .WORD>
				      <TELL "\"Ok">
				      <LADY-OR-MISTER>
				      <TELL " we'll send another one.\" He hangs up." CR>
				      <CABTIMES <+ .CT 1>>
				      <COND (<SEND-CAB?>
					     <CABSTATE ,CAB-SENT> 
					     <CABTURNS <+ <ZRANDOM 3> 2>>
					     <QUEUE I-CAB>)
					    (ELSE
					     <CABSTATE ,CAB-INIT>
					     <QUEUE I-NO-CAB <+ <ZRANDOM 5>
								5>>)>
				      <SET TAKE-INFO <>>
				      <UNMAKE ,MACHINE ,SEEN>
				      <RETURN>)
				     (<NO-USED? .WORD>
				      <RETURN>)
				     (ELSE
				      <TELL "\"C'mon">
				      <LADY-OR-MISTER>
				      <TELL ", yes or no. \"">)>>)
		      (ELSE
		       <TELL "\"Gee">
		       <LADY-OR-MISTER>
		       <TELL ", your cab should be on its way. You better go outside and wait for it.\" He hangs up." CR>
		       <UPDATE-BP 5>
		       <UNMAKE ,MACHINE ,SEEN>
		       <SET TAKE-INFO <>>
		       <COND (<N==? <CABSTATE> ,CAB-SENT>
			      <CABTIMES <SET CT <+ .CT 1>>>
			      <COND (<SEND-CAB?>
				     <CABSTATE ,CAB-SENT> 
				     <CABTURNS <+ <ZRANDOM 3> 2>>
				     <QUEUE I-CAB>)
				    (ELSE
				     <QUEUE I-NO-CAB <+ <RANDOM 5> 5>>)>)>)>)>
	 <COPY-TBL <CABNAME> <CABPREVNAME>>
	 <COND (.TAKE-INFO
		<TELL "\"Ok">
		<LADY-OR-MISTER>
		<TELL ", where do you wanna go?\"" CR>
		<SET WORD <GET-CABWORD <> <>>>
		<COND (<NOT <IS? ,MACHINE ,SEEN>> <RETURN T .CC>)>
		<COND (<EQUAL? .WORD ,W?AIRPORT>
		       <TELL "\"Great">
		       <LADY-OR-MISTER>
		       <TELL ". The airport's our specialty">)
		      (T
		       <TELL "\"Hmm. ">
		       <REPEAT ()
			       <TELL "Is that on the way to the airport?\"" CR>
			       <SET WORD <GET-CABWORD>>
			       <COND (<NOT <IS? ,MACHINE ,SEEN>>
				      <RETURN T .CC>)>
			       <COND (<OR <YES-USED? .WORD>
					  <NO-USED? .WORD>>
				      <RETURN>)>
			       <TELL "\"C'mon">
			       <LADY-OR-MISTER>
			       <TELL ", yes or no. ">>
		       <TELL "The man sounds a bit doubtful. He says, \"See, the airport's our specialty. ">
		       <COND (<YES-USED? .WORD>
			      <TELL "We might have to wait until some other passenger from your street wants to go to the airport.">)
			     (T
			      <TELL "We like to go to the airport if at all possible.">)>
		       <TELL " Well, look, I'll see what we can do">)>
		<TELL ". What's the name of your street?\"" CR>
		<SET WORD <GET-CABWORD <CABADDR> <>>>
		<COND (<NOT <IS? ,MACHINE ,SEEN>> <RETURN T .CC>)>
		<COND (<NEQ-TBL <CABADDR>
				<ZREST <ZGET ,LICENSE-FORM <+ ,STREET-NAME 1>>
				       <- ,FIELD-DATA-OFFSET 1>>
				T>
		       <CAB-DONT T>
		       <TELL "\"I'm not sure if I've heard of that street. We'll give it a try though.\"" CR>
		       <SET STREET-OK <>>)>
		<TELL "\"Street number?\"" CR>
		<SET TBL <CABNUM>>
		<REPEAT ()
		 <SET WORD <GET-CABWORD .TBL <>>>
		 <COND (<NOT <IS? ,MACHINE ,SEEN>> <RETURN T .CC>)>
		 <SET LEN <GETB .TBL 0>>
		 <COND (<G? .LEN 4>
			<TOO-LONG>
			<AGAIN>)>
		 <SET PTR 1>
		 <SET WORD 0>
		 <REPEAT ()
			 <SET X <GETB .TBL .PTR>>
			 <COND (<AND <G? .X %<- <ASCII !\0> 1>>
				     <L? .X %<+ <ASCII !\9> 1>>>
				<SET WORD <+ <* .WORD 10>
					     <- .X %<ASCII !\0>>>>
				<COND (<G? <SET PTR <+ .PTR 1>> .LEN>
				       <SET X <>>
				       <RETURN>)>)
			       (T
				<SET X T>
				<TELL "\"C'mon">
				<LADY-OR-MISTER>
				<TELL ". Just gimme a number.\"" CR>
				<RETURN>)>>
		 <COND (<ZERO? .X>
			<SET X <GETP ,OUTSIDE-HOUSE ,P?STADDR>>
			<COND (<AND <T? .STREET-OK> <N==? .WORD .X>>
			       <SET WORD <- .WORD .X -2>>
			       <COND (<AND <G=? .WORD 0> <L=? .WORD 5>>
				      <TELL "\"We refuse to send a cab there because ">
				      <TELL <ZGET ,CAB-EXCUSES .WORD>>)
				     (ELSE
				      <TELL "\"I know for a fact that number doesn't exist">)>
			       <TELL ". Now try again.\"" CR>)
			      (ELSE
			       <RETURN>)>)>>
		<COND (<NOT .STREET-OK>
		       <CAB-DONT T>)>
		<STNUM-VALUE <TEXT-TO-VALUE <CABNUM>>>
		<TELL "\"Okay. Lemme put you on hold for a minute while I see what we got in your area.\"" CR CR>
		<SETUP-CABMUSIC>
		<QUEUE I-CAB-MUSIC>
		<ITALICIZE "Click">
		<TELL "!" CR>
		<UPDATE-BP 1>)>
	 T>

<DEFINE NEQ-TBL (TBL1 TBL2 "OPT" (STREET <>)
		 "AUX" (L1 <GETB .TBL1 0>) (L2 <GETB .TBL2 0>) (RES T) (CNT 1))
	<COND (<OR .STREET <==? .L1 .L2>>
	       <REPEAT ()
		       <COND (<AND <==? .L1 0> <==? .L2 0>>
			      <SET RES <>>
			      <RETURN>)
			     (<==? .L1 0>
			      <COND (<==? <GETB .TBL2 .CNT> 32>
				     <SET RES <>>)>
			      <RETURN>)
			     (<==? .L2 0>
			      <COND (<==? <GETB .TBL1 .CNT> 32>
				     <SET RES <>>)>
			      <RETURN>)>
		       <COND (<N==? <UPPERC <GETB .TBL1 .CNT>>
				    <UPPERC <GETB .TBL2 .CNT>>>
			      <RETURN>)>
		       <SET CNT <+ .CNT 1>>
		       <SET L1 <- .L1 1>>
		       <SET L2 <- .L2 1>>>)>
	.RES>

<DEFINE UPPERC (CHR)
  <SET CHR <CHTYPE .CHR FIX>>
  <COND (<AND <G=? .CHR %<ASCII !\a>>
	      <L=? .CHR %<ASCII !\z>>>
	 <SET CHR <+ .CHR %<- %<ASCII !\A> %<ASCII !\a>>>>)>
  .CHR>

<DEFINE COPY-TBL (FROM TO "AUX" (LEN <GETB .FROM 0>))
	<PUTB .TO 0 .LEN>
	<REPEAT ()
		<COND (<==? .LEN 0> <RETURN>)>
		<PUTB .TO .LEN <GETB .FROM .LEN>>
		<SET LEN <- .LEN 1>>>>

<DEFINE MR-OR-MISS () <GENDER-PRINT "Mr " "Ms ">>

<DEFINE LADY-OR-MISTER ()
	 <TELL ", ">
	 <GENDER-PRINT "buddy" "lady">
	 T>
	 
<DEFINE TOO-LONG ()
	 <TELL "\"That's kinda long">
	 <LADY-OR-MISTER>
	 <TELL ". Shorten it up for me.\"" CR>>

<DEFINE GET-CABWORD GCW ("OPTIONAL" (TBL <>) (ALPHA T) (OTBL <>)
		         "AUX" (OFFS 0) (DPTR 1) SPTR WORD LEN X LEXW
			       (WORD2 <>))
	 <REPEAT ()
		 <TELL CR ">>">
		 <ZREAD ,P-INBUF ,P-LEXV>
		 <SET LEXW <GETB ,P-LEXV ,P-LEXWORDS>>
		 <SET LEN <ZREST ,P-LEXV <* .LEXW 4>>>
		 <SET LEN <- <+ <GETB .LEN 1> <GETB .LEN 0>>
			     <GETB ,P-LEXV 5>>>
		 <COND (<AND <T? .TBL>
			     <G? .LEN ,MAX-CABLEN>>
			<TOO-LONG>
			<AGAIN>)>
		 ;<COND (<T? .ALPHA>
			<SET SPTR <GETB ,P-LEXV 5>>
			<REPEAT ()
				<SET X <GETB ,P-INBUF .SPTR>>
				<COND (<AND <G? .X %<- <ASCII !\a> 1>>
					    <L? .X %<+ <ASCII !\z> 1>>>
				       <SET SPTR <+ .SPTR 1>>
				       <COND (<G? <SET DPTR <+ .DPTR 1>>
						  .LEN>
					      <RETURN>)>)
				      (T
				       <TELL "\"C'mon">
				       <LADY-OR-MISTER>
				       <TELL ". Just gimme a word.\"" CR>
				       <SET ALPHA <>>
				       <RETURN>)>>
			<COND (<ZERO? .ALPHA>
			       <AGAIN>)>)>
		 <REPEAT ()
			 <SET WORD <ZGET ,P-LEXV <+ ,P-LEXSTART .OFFS>>>
			 <COND (<G? .LEXW 1>
				<SET WORD2
				     <ZGET ,P-LEXV
					   <+ ,P-LEXSTART ,P-LEXELEN .OFFS>>>)
			       (ELSE <RETURN>)>
			 <COND (<AND <T? .WORD>
				     <WT? .WORD ,PS?BUZZ-WORD>>
				<SET LEXW <- .LEXW 1>>
				<SET OFFS <+ .OFFS ,P-LEXELEN>>)
			       (ELSE <RETURN>)>>
		 <COND (<N==? .LEXW 0>
			<COND (<AND <G? .LEXW 1>
				    <==? .WORD ,W?HANG>
				    <==? .WORD2 ,W?UP>
				    <IS? ,MACHINE ,SEEN>>
			       <SETG PRSO ,MACHINE>
			       <V-HANGUP>
			       <RETURN <> .GCW>)
			      (<EQUAL? .WORD ,W?QUIT ,W?Q>
			       <V-QUIT>)
			      (<EQUAL? .WORD ,W?RESTART>
			       <V-RESTART>)
			      (<EQUAL? .WORD ,W?RESTORE>
			       <V-RESTORE>)
			      (<EQUAL? .WORD ,W?SAVE>
			       <V-SAVE>)
			      (T
			       <RETURN>)>)>
		 <TELL "\"Eh? Didn't get that.\"" CR>>
	 <COND (<T? .TBL>
		<SET DPTR 1>
		<SET SPTR <GETB ,P-LEXV 5>>
		<REPEAT ()
			<SET X <GETB ,P-INBUF .SPTR>>
			;<COND (<AND <G? .X %<- <ASCII !\A> 1>>
				     <L? .X %<+ <ASCII !\Z> 1>>>
			        <SET X <+ .X 32>>)>             
			<PUTB .TBL .DPTR .X>
			<SET SPTR <+ .SPTR 1>>
			<COND (<G? <SET DPTR <+ .DPTR 1>> .LEN>
			       <PUTB .TBL 0 .LEN>
			       <RETURN>)>>)>
	 <COND (.OTBL
		<SET LEN <ZGET .OTBL 0>>
		<SET DPTR 1>
		<SET SPTR .LEXW>
		<REPEAT ()
			<COND (<OR <L? <SET SPTR <- .SPTR 1>> 0>
				   <G? .DPTR 3>>
			       <RETURN .LEXW .GCW>)>
			%<COND (<GASSIGNED? ZILCH>
				'<SET WORD <ZGET ,P-LEXV
						 <+ ,P-LEXSTART
						    <SET OFFS <+ .OFFS 1>>>>>)
			       (ELSE
				'<SET WORD
				      <ORB <LSH <GETB ,P-LEXV
						      <* <+ ,P-LEXSTART .OFFS
							    1> 2>> 8>
					   <GETB ,P-LEXV
						 <+ <* <+ ,P-LEXSTART .OFFS
							  1> 2> 1>>>>)>
			<COND (<NOT <EQUAL? .WORD ,W?SAY ,W?QUOTE>>
			       ; "Don't put say and quotes in table..."
			       <ZPUT .OTBL .DPTR .WORD>
			       <SET DPTR <+ .DPTR 1>>)>
			%<COND (<GASSIGNED? ZILCH>
				'<SET OFFS <+ .OFFS 1>>)
			       (T
				'<SET OFFS <+ .OFFS ,P-LEXELEN>>)>>)
	       (ELSE
		<COND (<AND <F? .ALPHA> <F? .TBL> <F? .WORD>>
		       <SET WORD <STR2NUM <* .OFFS 2>>>)>
		<COND (<AND <F? .ALPHA> <F? .WORD>>
		       .WORD2)
		      (T .WORD)>)>>

<DEFINE STR2NUM (WNUM:FIX "AUX" LEN DPTR SPTR WORD X) 
	<SET LEN <GETB ,P-LEXV <+ .WNUM 4>>>
	<SET SPTR <GETB ,P-LEXV <+ .WNUM 5>>>
	<SET DPTR 1>
	<SET WORD 0>
	<REPEAT ()
		<SET X <GETB ,P-INBUF .SPTR>>
		<COND (<AND <G? .X %<- <ASCII !\0> 1>>
			    <L? .X %<+ <ASCII !\9> 1>>>
		       <SET WORD <+ <* .WORD 10> .X %<- <ASCII !\0>>>>
		       <SET SPTR <+ .SPTR 1>>
		       <COND (<G? <SET DPTR <+ .DPTR 1>> .LEN>
			      <RETURN>)>)
		      (ELSE
		       <SET WORD <>>
		       <RETURN>)>>
	.WORD>

<DEFINE SEND-CAB? ("AUX" (CT <CABTIMES>))
  <COND (<T? ,END-GAME?> <>)
	(<T? <CAB-DONT>> <>)
	(<G? .CT 2> T)
	(<==? .CT 1> <PROB 80>)
	(<PROB 50> T)
	(T <>)>>

;<SETG HOLD-TURNS 0>

; "SETG HOLD-TURNS to 0 when put on hold, call this with max # of turns
   allowed to hold each time decide whether to stay on hold or not..."
<DEFINE KEEP-HOLDING? (MAX:FIX)
  <COND (<G? <SETG HOLD-TURNS <+ ,HOLD-TURNS 1>> .MAX>
	 ; "If have held too many turns, stop..."
	 <>)
	(<OR <==? ,HOLD-TURNS 1>
	     <PROB 60>>
	 ; "Continue holding if first time..."
	 T)
	(T <>)>>

<DEFINE I-CAB-MUSIC ("OPTIONAL" (CR T) "AUX" (CT <CABTIMES>))
  <COND (<NOT <VISIBLE? ,MACHINE>>
	 <>)
	(T
	 <COND (<T? .CR>
		<ZCRLF>)>
	 <NEXT-TOON>
	 <COND (<KEEP-HOLDING? 7>
		<TELL "The cab company plays you ">
		<SAY-MUZAK>
		<ZPRINT ,PERIOD>
		T)
	       (T
		<CABSOUND-OFF>
		<TELL "A man's voice interrupts ">
		<SAY-MUZAK>
		<TELL ". \"Okay, ">
		<MR-OR-MISS>
		<PRINT-CABFIELD <CABNAME>>
		<TELL ". We'll send a cab over to " N
		      <STNUM-VALUE>
		      " ">
		<PRINT-CABFIELD <CABADDR>>
		<TELL " right away. Thanks for calling Getlost.\"|
|
He hangs up." CR>
		<UNMAKE ,MACHINE ,SEEN>
		<CABTIMES <SET CT <+ .CT 1>>>
		<COND (<SEND-CAB?>
		       <CABSTATE ,CAB-SENT>
		       <CABTURNS <+ <ZRANDOM 3> 2>> 
		       <QUEUE I-CAB>)
		      (ELSE
		       <QUEUE I-NO-CAB <+ <ZRANDOM 5> 5>>)>)>)>>

<OBJECT STREETNUMBERS
	(LOC LOCAL-GLOBALS)
	(DESC "number")
	(FLAGS NODESC)
	(SYNONYM NUMBER ADDRESS)
	(ADJECTIVE STREET)
	(ACTION STREETNUMBERS-F)>

<DEFINE STREETNUMBERS-F ()
	 <COND (<THIS-PRSI?>
		<>)
	       (<VERB? EXAMINE READ>
		<TELL "You're outside ">
		<SAY-STREET-ADDRESS>
		<ZPRINT ,PERIOD>
		T)
	       (T
		<>)>>

<OBJECT STAMP-TABLE
	(LOC IN-FLAT)
	(DESC "table")
	(FLAGS NODESC SURFACE)
	(CAPACITY 20)
	(SYNONYM TABLE)>

<OBJECT MOUSYMAIL
	(LOC IN-FLAT)
	(DESC "some mail")
	(FLAGS TAKEABLE READABLE NOARTICLE)
	(SYNONYM ADDRESS MAIL PIECE)
	(GENERIC GENERIC-MAIL)
	(MAIL-LETTER -2)
	(DESCFCN MOUSYMAIL-F)
	(ACTION MOUSYMAIL-F)>

<DEFINE MOUSYMAIL-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-OBJDESC>
		<TELL 
"A piece of mail, as yet undamaged by the collector, lies at your feet
 .">
		T)
	       (<T? .CONTEXT>
		<>)
	       (<MOVING?>
		<COND (<NOT <IN? ,MOUSY ,IN-FLAT>>
		       <>)
		      (<IS? ,MOUSYMAIL ,SEEN>
		       <TELL "\"I said don't touch!\" screams "
			     THE ,MOUSY ,PERIOD>
		       T)
		      (T
		       <MAKE ,MOUSYMAIL ,SEEN>
		       <MAKE ,MOUSY ,SEEN>
		       <TELL 
			"\"Don't touch!\" scolds " THE ,MOUSY 
			", nudging the mail out of your reach. \"Haven't looked at that one yet.\""
			CR>
		       <UPDATE-BP 5>
		       T)>)
	       (<HANDLE-MAIL? ,MOUSYMAIL> T)
	       (T
		<>)>>

<OBJECT LLAMA-MAIL
	(LOC TROUGH)
	(DESC "some mail")
	(FLAGS TAKEABLE NOARTICLE READABLE)
	(GENERIC GENERIC-MAIL)
	(SYNONYM MAIL)
	(MAIL-LETTER -4)
	(ACTION LLAMA-MAIL-F)>

<DEFINE LLAMA-MAIL-F ()
	 <COND (<VERB? EXAMINE>
		<TELL "Mostly junk, of course, which thanks to the Deep
Thought Corporation mail delivery system has been delivered to the wrong
address. You do see one piece that looks interesting, but can't quite make
out what it is." CR>)
	       (<HANDLE-MAIL? ,LLAMA-MAIL>
		T)
	       (T
		<>)>>

<OBJECT SHITMAIL
	(LOC UNDER-PERCH)
	(DESC "some mail")
	(SDESC SDESC-SHITMAIL)
	(FLAGS TAKEABLE READABLE NOARTICLE)
	(SYNONYM MAIL)
	(ADJECTIVE SHREDDED)
	(GENERIC GENERIC-MAIL)
	(MAIL-LETTER -3)
	(ACTION SHITMAIL-F)>

<DEFINE SDESC-SHITMAIL ()
  <TELL "some ">
  <COND (<IS? ,SHITMAIL ,SHITTY>
	 <TELL "shredded ">)>
  <TELL "mail">>

<DEFINE SHITMAIL-F MAIL ()
	 <COND (<AND <ADJ-USED? ,W?SHREDDED>
		     <F? <IS? ,SHITMAIL ,SHITTY>>>
		<REFERRING>
		<RETURN ,FATAL-VALUE .MAIL>)
	       (<AND <THIS-PRSO?>
		     <VERB? COVER>
		     <IN? ,PRSO ,UNDER-PERCH>>
		<PERFORM ,V?PUT-UNDER ,PRSI ,PERCH>)
	       (<AND <THIS-PRSI?>
		     <PUTTING?>
		     <IN? ,PRSI ,UNDER-PERCH>>
		<PERFORM ,V?PUT-UNDER ,PRSO ,PERCH>)
	       (<VERB? TAKE>
		<COND (<IS? ,SHITMAIL ,SHITTY>
		       <TELL "You start to pick up " THE ,SHITMAIL
", but realise that you're picking up tiny shreds of paper. Since you haven't
unpacked your Scotch tape yet, you decide to abandon the effort." CR>
		       T)>)
	       (<HANDLE-MAIL? ,SHITMAIL>
		T)
	       (T
		<>)>>

<DEFINE HANDLE-MAIL? (X)
	 <COND (<VERB? EXAMINE READ LOOK-ON>
		<COND (<NOT <IN? .X ,PLAYER>>
		       <TELL "You'll have to pick it up first." CR>
		       T)
		      (ELSE
		       <TELL "BUG ENCOUNTERED." CR>
		       T)>)
	       (T
		<>)>>

<OBJECT FLYER
	(DESC "flyer")
	(FLAGS TAKEABLE READABLE SURFACE)
	(SIZE 2)
	(MAIL-LETTER 0)
	(GENERIC GENERIC-MAIL)
	(ADJECTIVE POSTAL SERVICE ORANGE)
	(SYNONYM ZZZP FLYER STICKER MAIL ADDRESS)
	(ACTION FLYER-F)>

<DEFINE FLYER-F ()
	 <COND (<NOUN-USED? ,W?STICKER>
		<HANDLE-STICKER>)
	       (<THIS-PRSI?>
		<COND (<VERB? PUT-ON PUT EMPTY-INTO>
		       <WASTE-OF-TIME>
		       T)
		      (T <>)>)
	       (<VERB? EXAMINE LOOK-ON READ>
		<TELL ,THIS-IS
"a sweepstakes flyer (\"You may already have won $1,000,000.00!!!\"), addressed to ">
		<SAY-STREET-ADDRESS ,OUTSIDE-FARM>
		<TELL ". ">
		<SAY-MAIL-LETTER ,PRSO>
		T)
	       (T
		<>)>>

<OBJECT COUPON
	(DESC "coupon booklet")
	(FLAGS TAKEABLE READABLE SURFACE )
	(SYNONYM ZZZP BOOKLET BOOK COUPONS STICKER MAIL)
	(ADJECTIVE COUPON POSTAL SERVICE ORANGE)
	(SIZE 3)
	(MAIL-LETTER 0)
	(GENERIC GENERIC-MAIL)
	(ACTION COUPON-F)>

<DEFINE COUPON-F ()
	 <COND (<NOUN-USED? ,W?STICKER>
		<HANDLE-STICKER>)
	       (<THIS-PRSI?>
		<COND (<VERB? PUT-ON PUT EMPTY-INTO>
		       <WASTE-OF-TIME>
		       T)
		      (T <>)>)
	       (<VERB? EXAMINE LOOK-ON READ LOOK-INSIDE>
		<TELL 
"It's a coupon booklet (\"Worth Over $10.00!\") for a supermarket so far away it would cost you $20.00 to get there, addressed to ">
		<SAY-STREET-ADDRESS ,OUTSIDE-MANSION>
		<TELL ". ">
		<SAY-MAIL-LETTER ,PRSO>
		T)
	       (<VERB? OPEN>
		<TELL "You open " THEO
", flip through a few coupons, yawn, and close it again." CR>
		T)
	       (T
		<>)>>

<OBJECT ENVELOPE
	(DESC "envelope")
	(FLAGS VOWEL TAKEABLE READABLE CONTAINER OPENABLE SURFACE)
	(CAPACITY 2)
	(SIZE 3)
	(ADJECTIVE POSTAL SERVICE ORANGE)
	(SYNONYM ZZZP ENVELOPE STICKER ADDRESS MAIL)
	(MAIL-LETTER 0)
	(GENERIC GENERIC-MAIL)
	(CONTFCN ENVELOPE-F)
	(DESCFCN ENVELOPE-F)
	(ACTION ENVELOPE-F)>  

<DEFINE ENVELOPE-F ("OPT" (CONTEXT <>))
	 <COND (<==? .CONTEXT ,M-CONT>
		<COND (<NOT <IS? ,ENVELOPE ,OPENED>>
		       <COND (<OR <IN? ,PRSO ,ENVELOPE>
				  <AND ,PRSI
				       <IN? ,PRSI ,ENVELOPE>>>
			      <TELL "You can't reach into the envelope. It's
closed." CR>
			      ,FATAL-VALUE)
			     (T <>)>)>)
	       (<==? .CONTEXT ,M-OBJDESC>
		<TELL "There's an envelope here">
		<COND (<AND <FIRST? ,ENVELOPE>
			    <IS? ,ENVELOPE ,OPENED>>
		       <TELL ". Inside it, you see ">
		       <PRINT-CONTENTS ,ENVELOPE>)>
		<TELL ".">)
	       (<==? .CONTEXT ,M-SHORT-OBJDESC>
		<TELL A ,ENVELOPE>
		<COND (<AND <FIRST? ,ENVELOPE>
			    <IS? ,ENVELOPE ,OPENED>>
		       <TELL " containing ">
		       <PRINT-CONTENTS ,ENVELOPE>)>
		T)
	       (<T? .CONTEXT> <>)
	       (<NOUN-USED? ,W?STICKER>
		<HANDLE-STICKER>)
	       (<THIS-PRSI?>
		<COND (<VERB? PUT-ON>
		       <WASTE-OF-TIME>
		       T)
		      (T
		       <>)>)
	       (<VERB? EXAMINE LOOK-ON READ>
		<TELL "The">
		<OPEN-CLOSED <> <>>
		<TELL " is addressed to ">
		<PRINT-NAME>
		<TELL ", ">
		<SAY-STREET-ADDRESS ,OUTSIDE-HOUSE>
		<TELL ". ">
		<SAY-MAIL-LETTER ,PRSO>
		T)
	       (<VERB? OPEN>
		<COND (<NOT <IS? ,CHECK ,TOUCHED>>
		       <MOVE ,US-TEXT ,ENVELOPE>
		       <MOVE ,CHECK ,ENVELOPE>
		       <MAKE ,CHECK ,TOUCHED>)>
		<>)
	       (T
		<>)>>

<OBJECT US-TEXT
	(DESC "memo")
	(FLAGS TAKEABLE READABLE)
	(SIZE 1)
	(SYNONYM MEMO PAPER)
	(ADJECTIVE US EXCESS)
	(ACTION US-TEXT-F)>

<DEFINE US-TEXT-F ()
  <COND (<VERB? READ EXAMINE>
	 <TELL "It's a memo from US Excess Travel Services" ,PCR>
	 <TELL "Dear ">
	 <PRINT-NAME>
	 <TELL ":" CR "Your account is overdue by $75. You have ignored our many previous attempts to collect this money. We have taken appropriate action (see enclosure)." CR CR "Yours truly," CR "L. C. J. Tester, Credit Manager" CR>
	 T)>>

<DEFINE HANDLE-STICKER ("AUX" LET)
  <COND (<THIS-PRSO?>
	 <SET LET <GETP ,PRSO ,P?MAIL-LETTER>>
	 <COND (<AND <VERB? DUMB-EXAMINE>
		     <NOUN-USED? ,W?E>>
		<SETG P-DIRECTION ,P?EAST>
		<PERFORM ,PRSA ,INTDIR>)
	       (<VERB? EXAMINE READ>
		<TELL "It's just an orange sticker, with a">
		<COND (<==? .LET 4> <TELL "n">)>
		<TELL " " CHAR <+ .LET %<- <ASCII !\B> 1>>
		      " printed on it." CR>)
	       (<VERB? TAKE TAKE-OFF TAKE-WITH>
		<TELL
		 "The sticker seems to be rather firmly attached to the piece of mail."
		 CR>)
	       (<HURTING?>
		<TELL "There wouldn't be any point in damaging such a harmless
little sticker." CR>)>)>>

<DEFINE SAY-MAIL-LETTER (OBJ "AUX" (N <GETP .OBJ ,P?MAIL-LETTER>))
  <TELL "There's also one of those cute little orange Postal Service stickers,
with a">
  <COND (<==? .N 4> <TELL "n">)>
  <TELL " " CHAR <+ .N %<- <ASCII !\B> 1>> " printed on it." CR>>

<OBJECT CHECK
	(DESC "cheque" ;"check")
	(FLAGS TAKEABLE)
	(SIZE 1)
	(SYNONYM CHECK CHEQUE PLUSSIGN - SIGN)
	(ADJECTIVE INTNUM PLUS MINUS)
	(ACTION CHECK-F)>

<MSETG CHECK-AMOUNT 7500>

<DEFINE CHECK-F ()
	<COND (<AND <THIS-PRSO?>
		    <VERB? TAKE PUT PUT-ON GIVE>>
	       <>)
	      (<NOUN-USED? ,W?CHECK ,W?CHEQUE>
	       <COND (<THIS-PRSO?>
		      <COND (<VERB? READ EXAMINE>
			     <TELL ,THIS-IS "a cheque drawn on the Fillmore Fiduciary Trust, in the amount of -$75.00 (yes, that is a minus sign). It's made out to ">
			     <PRINT-NAME>
			     <TELL ,PERIOD>
			     T)
			    (<VERB? CASH>
			     <COND (<N==? ,HERE ,BANK>
				    <TELL "It's probably best to try that in the bank." CR>
				    T)
				   (<==? <ZABS <TELLER-CHECK-CASH>>
					 <TELLER-NUMBER>>
				    <TELLER-CURRENT-SCRIPT
				     ,CASH-CHECK-SCRIPT>
				    <PERFORM ,V?SHOW ,CHECK ,TELLER>
				    T)
				   (T
				    <TELL "You should probably use the cheque-cashing window for cashing cheques." CR>)>)
			    (<VERB? FILL-IN ERASE> <CHECK-MUNG>)
			    (T <>)>)
		     (T <>)>)
	      (<OR <AND <NOUN-USED? ,W?SIGN>
			<ADJ-USED? ,W?PLUS ,W?MINUS>>
		   <NOUN-USED? ,W?PLUSSIGN ,W?->>
	       <COND (<THIS-PRSO?>
		      <COND (<OR <ADJ-USED? ,W?MINUS> <NOUN-USED? ,W?->>
			     <COND (<OR <MOVING?> <VERB? ERASE CROSS>>
				    <CHECK-MUNG>)
				   (<VERB? EXAMINE>
				    <TELL "It's just an ordinary minus sign."
					  CR> T)>)
			    (ELSE
			     <TELL "There's no plus sign here." CR>
			     T)>)
		     (ELSE <>)>)
	      (ELSE
	       <TELL "You don't know what you are talking about." CR> T)>>

<DEFINE CHECK-MUNG ()
	<TELL "Trying to change a cheque is illegal and besides, it won't do any good." CR>>

<OBJECT MONEY
	(SDESC MONEY-D)
	(FLAGS TAKEABLE NOARTICLE)
	(SIZE 1)
	(SYNONYM MONEY CHANGE DOLLARS DOLLAR BUCK BUCKS CASH CENTS CENT)
	(ADJECTIVE INTNUM MONEY)
	(ACTION MONEY-F)>

<DEFINE MONEY-D ("OPTIONAL" (Y <>)
		 "AUX" X:FIX DOLL:FIX CENT:FIX)
	<COND (.Y <SET X .Y>)
	      (<AND <T? ,P-DOLLAR-FLAG>
		    <G? ,P-NUMBER 0>
		    ,PERFORMING?>
	       <SET X ,P-NUMBER>)
	      (ELSE <SET X ,CASH>)>
	<SET DOLL </ .X 100>>
	<SET CENT <MOD .X 100>>
	<COND (<==? .DOLL 0>
	       <COND (<==? .CENT 0>)
		     (<==? .CENT 1> <TELL "one cent">)
		     (ELSE
		      <TELL N .CENT " cents">)>)
	      (<AND <==? .DOLL 1> <==? .CENT 0>>
	       <TELL "one dollar">)
	      (ELSE
	       <TELL "$" N .DOLL ".">
	       <COND (<==? .CENT 0> <TELL "00">)
		     (<L? .CENT 10> <TELL "0" N .CENT>)
		     (ELSE <TELL N .CENT>)>)>
	T>

;<SETG CASH 7500>

<DEFINE REDUCE-CASH ("OPT" (NUM <>))
  <COND (<F? .NUM> <SET NUM ,P-NUMBER>)>
  <SETG CASH <- ,CASH .NUM>>
  <COND (<L=? ,CASH 0>
	 <REMOVE ,MONEY>)>>

<DEFINE MONEY-F ()
	 <COND (<THIS-PRSI?>
		<COND (<PUTTING?>
		       <WASTE-OF-TIME>
		       T)
		      (T <>)>)
	       (<AND <VERB? BUY>
		     <==? ,P-PRSA-WORD ,W?WITHDRAW>
		     <HERE? BANK>>
		<PERFORM ,V?ASK-FOR ,TELLER ,MONEY>)
	       (<AND <VERB? PUT>
		     <PRSI? POCKET WALLET>>
		<COND (<AND ,P-DOLLAR-FLAG
			    <N==? ,CASH ,P-NUMBER>>
		       <TELL "In this game, you have to put all your eggs in one basket!" CR>)
		      (ELSE
		       <>)>)
	       (<AND <VERB? DROP> <HERE? BANK>>
		<COND (<NOT ,P-DOLLAR-FLAG> <SETG P-NUMBER ,CASH>)>
		<COND (<G? ,P-NUMBER ,CASH>
		       <TELL ,DONT "have that much." CR>)
		      (ELSE
		       <TELL "You drop ">
		       <MONEY-D ,P-NUMBER>
		       <TELL " which is never seen again." CR>
		       <REDUCE-CASH>)>
		T)
	       (<OR <VERB? DROP> <PUTTING?>>
		<TELL "Maybe you ought to hold on to your money." CR>
		T)
	       (<VERB? EXAMINE COUNT>
		<TELL "You count ">
		<MONEY-D ,CASH>
		<TELL ,PERIOD>
		T)
	       (T
		<>)>>

<OBJECT BOSS-CHECK
	(SDESC SDESC-BOSS-CHECK)
	(ACTION BOSS-CHECK-F)
	(DESCFCN BOSS-CHECK-F)
	(ADJECTIVE ZZZP ZZZP ZZZP ZZZP ZZZP ZZZP ZZZP)
	(SYNONYM ZZZP)>

<CONSTANT BOSS-CHECK-WORDS
  <PTABLE
   ; "Check in flat--shredded check"
   <PTABLE <PLTABLE <VOC "SHREDDED" ADJ> <VOC "CHOPPED" ADJ>
		    <VOC "CUT-UP" ADJ> <VOC "MONEY" ADJ>>
	   <PLTABLE <VOC "ORDER" OBJECT>>>
   ; "check in trough--check covered with llama slime"
   <PTABLE <PLTABLE <VOC "SLIMY" ADJ> <VOC "SOGGY" ADJ> <VOC "SLOBBERY" ADJ>
		    <VOC "WET" ADJ> <VOC "COVERED" ADJ>
		    <VOC "SLIME-COVERED" ADJ> <VOC "MONEY" ADJ>>
	   <PLTABLE <VOC "ORDER" OBJECT>>>
   ; "check in porch--check covered with macaw dung"
   <PTABLE <PLTABLE <VOC "SHREDDED" ADJ> <VOC "TORN" ADJ> <VOC "RIPPED" ADJ>
		    <VOC "MONEY" ADJ>>
	   <PLTABLE <VOC "ORDER" OBJECT>>>
   ; "check in fort--soaked check"
   <PTABLE <PLTABLE <VOC "SOAKED" ADJ> <VOC "WET" ADJ> <VOC "SOGGY" ADJ>
		    <VOC "MONEY">>
	   <PLTABLE <VOC "ORDER" OBJECT>>>>>

<DEFINE SETUP-CHECK (L "AUX" (A <GETPT ,BOSS-CHECK ,P?ADJECTIVE>)
		     (S <GETPT ,BOSS-CHECK ,P?SYNONYM>)
		     (TBL ,BOSS-CHECK-WORDS))
  <MOVE ,BOSS-CHECK .L>
  <COND (<==? ,HERE ,IN-FLAT>
	 <SET TBL <ZGET ,BOSS-CHECK-WORDS 0>>)
	(<==? ,HERE ,OUTSIDE-FARM>
	 <SET TBL <ZGET ,BOSS-CHECK-WORDS 1>>)
	(<==? ,HERE ,IN-PORCH>
	 <SET TBL <ZGET ,BOSS-CHECK-WORDS 2>>)
	(T
	 <SET TBL <ZGET ,BOSS-CHECK-WORDS 3>>)>
  <MUNG-WVEC .A </ <PTSIZE .A> 2> <ZGET .TBL 0>>
  <MUNG-WVEC .S </ <PTSIZE .S> 2> <ZGET .TBL 1>>>

<DEFINE SDESC-BOSS-CHECK ()
  <COND ;(<==? .L ,IN-PORCH>
	 <TELL "money order covered with macaw dung">)
	(<HERE? ,IN-FLAT ,IN-PORCH>
	 <TELL "shredded money order">)
	(<HERE? ,OUTSIDE-FARM>
	 <TELL "money order covered with llama slime">)
	(<HERE? ,IN-FORT>
	 <TELL "soggy former money order">)>>

<DEFINE BOSS-CHECK-F ("OPT" (CONTEXT <>) "AUX" (L <META-LOC ,BOSS-CHECK>))
  <COND (<==? .CONTEXT ,M-OBJDESC>
	 <TELL "The ">
	 <COND (<==? .L ,OUTSIDE-FARM>
		<TELL "slobbery">)
	       (<EQUAL? .L ,IN-FLAT ,IN-PORCH>
		<TELL "shredded">)
	       (T
		<TELL "soggy">)>
	 <TELL " remnant of a money order that may have been made out to you is here.">
	 T)
	(<T? .CONTEXT> <>)
	(<VERB? EXAMINE LOOK-ON>
	 <TELL "From what you can see, it's a money order from Happitec. ">
	 <COND (<==? .L ,OUTSIDE-FARM>
		<TELL "The amount, payee, and signature are all unintelligible due to the llama's overactive salivary glands. It certainly couldn't be cashed">)
	       (<==? .L ,IN-PORCH>
		<TELL "The macaw apparently doesn't like Happitec much either,
because the money order has been reduced to tiny scraps of paper">)
	       (<==? .L ,IN-FLAT>
		<TELL "Apparently " THE ,MOUSY " got a trifle over-eager when he encountered the envelope that your money order came in, and reduced both the envelope and its contents to shreds">)
	       (T
		<TELL "After a long bath, to ensure that it wasn't a letter bomb, there's not much useful information left on it">)>
	 <TELL ,PERIOD>
	 T)
	(<VERB? CLEAN REPAIR>
	 <TELL "There's really no point; the money order is beyond human help. You'll have to find some other source of cash." CR>)
	(<VERB? TAKE TOUCH>
	 <COND (<EQUAL? .L ,OUTSIDE-FARM>
		<TELL "The llama's saliva has done strange things to it; neither you nor any bank would really want to have anything to do with it." CR>)
	       (<==? .L ,IN-FLAT ,IN-PORCH>
		<TELL "There are too many shreds of the money order lying around for you ever to be able to find all of them. You'd best give up on it." CR>)
	       (T
		<TELL "It's practically a blank piece of paper at this point. You probably shouldn't waste your time on it." CR>)>)
	(T <>)>>

<MSETG ARRIVED 1>
<MSETG WAITING 2>
<MSETG LEAVING 3>
<MSETG WANDERING 4>

<DEFINE I-NO-CAB ()
	<COND (<IN? ,PLAYER ,OUTSIDE-HOUSE>
	       <TELL CR
		     "It occurs to you that maybe that cab you called isn't coming after all. Perhaps you should call the company again." CR>
	       T)
	      (ELSE <>)>>

<DEFINE I-CAB I-CAB ("AUX" (CS <CABSTATE>)
		     (TURNS <CABTURNS>))
	 <COND (<==? .CS ,CAB-SENT>
		<COND (<==? .TURNS 0>
		       <CABSTATE ,CAB-HERE>
		       <CABTURNS
			     <+ <ZRANDOM 3> 1>>
		       <CAB-SEEN? ,ARRIVED>)
		      (ELSE
		       <COND (<==? .TURNS 1>
			      <CABTURNS 0>
			      <CAB-SEEN? ,WANDERING>)
			     (ELSE
			      <CABTURNS <SET TURNS <- .TURNS 1>>>
			      <>)>)>)
	       (<EQUAL? .CS ,CAB-HERE ,CAB-NEEDS-ID>
		<COND (<==? .TURNS 0>
		       <UNMAKE ,CAB-DRIVER ,SEEN>
		       <CABSTATE ,CAB-RETURNED>
		       <DEQUEUE I-CAB>
		       <CAB-SEEN? ,LEAVING>)
		      (<==? .CS ,CAB-NEEDS-ID>
		       <COND (<IS? ,HERE ,INDOORS>
			      <RETURN <> .I-CAB>)
			     (<L? .TURNS 2>
			      <TELL
			       CR
			       "The cab driver is looking impatient." CR>)>
		       <CABTURNS <SET TURNS <- .TURNS 1>>>
		       T)
		      (ELSE
		       <CABTURNS <SET TURNS <- .TURNS 1>>>
		       <CAB-SEEN? ,WAITING>)>)
	       (<==? .CS ,CAB-INHABITED>
		<COND (<==? .TURNS 0>
		       <TELL CR
"The cab driver drives on. He shows you pictures of his kids and mentions that they like the airport a lot also. He says that he has a lot of regular customers who regularly go to the airport. \"I had John Travolta in the cab once,\" he says. \"Wanted to go to some club, wouldn't go to the airport. And where is he now? See that movie \"Perfect\"? Terrible. Should have gone to the airport.\" And so on." CR>
		       <CABSTATE ,CAB-JUST-AT-AIRPORT>
		       T)
		      (ELSE
		       <CABTURNS 0>
		       <>)>)
	       (<EQUAL? .CS ,CAB-JUST-AT-AIRPORT ,CAB-AT-AIRPORT>
		<TELL CR
		       "You arrive at the airport. The cab driver says, \"That'll be $17.50, ">
		<GENDER-PRINT "buddy" "lady">
		<TELL ".\"" CR>
		<DEQUEUE I-CAB>
		T)
	       (ELSE <>)>>

<DEFINE SAY-CAB-LOC ()
  <COND (<==? ,HERE ,FROOM>
	 <TELL "outside the front door.">)
	(<==? ,HERE ,OUTSIDE-HOUSE>
	 <TELL "in front of you.">)
	(ELSE
	 <TELL "outside your house.">)>
  <ZCRLF>>

<DEFINE CAB-SEEN? (STATE)
	<COND (<OR <AND <==? ,HERE ,FROOM> <IS? ,FROOM-DOOR ,OPENED>>
		   <EQUAL? ,HERE ,OUTSIDE-HOUSE ,ST-B ,ST-A ,OUTSIDE-MANSION
			   ,OUTSIDE-FARM ,OUTSIDE-FORT>>
	       <ZCRLF>
	       <COND (<==? .STATE ,ARRIVED>
		      <COND (<IS? ,CAB ,SEEN>
			     <TELL "The cab pulls up ">)
			    (ELSE
			     <TELL "A Getlost cab pulls up ">
			     <MAKE ,CAB ,SEEN>)>
		      <SAY-CAB-LOC>)
		     (<==? .STATE ,WAITING>
		      <MAKE ,CAB ,SEEN>
		      <TELL "The cab is waiting ">
		      <SAY-CAB-LOC>)
		     (<==? .STATE ,WANDERING>
		      <TELL ,YOU-SEE "a Getlost cab wandering up and down the street looking at all the house numbers." CR>
		      <MAKE ,CAB ,SEEN>)
		     (ELSE
		      <COND (<IS? ,CAB ,SEEN>
			     <TELL
			      "The cabbie guns his engine as he pulls away ">)
			    (ELSE
			     <TELL
			      "You hear an engine roaring, and see a cab pulling away ">)>
		      <UNMAKE ,CAB ,SEEN>
		      <COND (<==? ,HERE ,FROOM> <TELL "outside.">)
			    (<==? ,HERE ,OUTSIDE-HOUSE> <TELL "from here.">)
			    (ELSE <TELL "outside your house.">)>
		      <ZCRLF>
		      <UPDATE-BP 5>)>
	       T)
	      (ELSE <>)>>

<OBJECT CAB
	(LOC GLOBAL-OBJECTS)
	(DESC "cab")
	(FLAGS INVISIBLE)
	(SYNONYM CAB DOOR TAXI)
	(ADJECTIVE GETLOST TAXI CAB)
	(GENERIC GDOOR-F)
	(ACTION CAB-F)>

<DEFINE GDOOR-F (TBL "AUX" LEN)
	<SET LEN <ZGET .TBL 0>>
	<SET TBL <ZREST .TBL 2>>
	<COND (<INTBL? ,P-IT-OBJECT .TBL .LEN>
	       ,P-IT-OBJECT)
	      (<==? .LEN 2>
	       <COND (<==? <ZGET .TBL 1> ,CAB> <ZGET .TBL 0>)
		     (<==? <ZGET .TBL 0> ,CAB> <ZGET .TBL 1>)>)>>

<DEFINE CAB-AND-DRIVER-AVAILABLE ()
	<COND (<HERE? CAB-ROOM> T)
	      (<AND <HERE? OUTSIDE-HOUSE>
		    <EQUAL? <CABSTATE>
			    ,CAB-HERE ,CAB-NEEDS-ID>>
	       T)
	      ;(<IS? ,CAB ,SEEN> T)
	      (ELSE <>)>>

<DEFINE CAB-F ("AUX" (CS <CABSTATE>) (TURNS <CABTURNS>))
	 <COND (<AND <OR <EQUAL? .CS ,CAB-HERE ,CAB-NEEDS-ID>
			 <HERE? CAB-ROOM>>
		     <OR <EXITING?>
			 <VERB? ENTER OPEN WALK-TO KNOCK LOOK-INSIDE>>>
		<COND
		 (<HERE? CAB-ROOM>
		  <COND (<OR <EXITING?> <VERB? OPEN>>
			 <DO-WALK ,P?OUT>)
			(<VERB? LOOK-INSIDE>
			 <PERFORM ,V?LOOK>)
			(T
			 <YOURE-ALREADY "in it">)>
		  T)
		 (<HERE? OUTSIDE-HOUSE>
		  <COND (<VERB? LOOK-INSIDE>
			 <TELL "It's just an ordinary cab." CR>
			 T)
		        (<NOT <FSET? ,CAB-DRIVER ,SEEN>>
			 <PERFORM ,V?TELL ,CAB-DRIVER>
			 T)
			(T
			 <TELL 
			  "\"You're gonna have to show some ID first.\""
			  CR>)>)
		 (T
		  <TELL "The Passengers' Teleportation Device hasn't been
approved for use yet, so you'll have to go to where the cab is first." CR>)>)
	       (<VERB? WAIT-FOR WAVE-AT>
		<COND (<HERE? CAB-ROOM>
		       <YOURE-ALREADY "in it">)
		      (<==? .CS ,CAB-HERE>
		       <ITS-ALREADY "here">)
		      (<EQUAL? .CS ,CAB-SENT>
		       <COND (<VERB? WAVE-AT>
			      <COND (<L=? .TURNS 1>
				     <TELL CTHE ,CAB
					   " pays no attention to you."
					   CR>)
				    (ELSE
				     <TELL "There's no cab here." CR>)>)
			     (ELSE
			      <V-WAIT <+ <CABTURNS> 1>>)>)
		      (<OR <==? .CS ,CAB-INIT> <CAB-DONT>>
		       <V-WAIT 10>
		       <COND (<NOT ,CLOCK-WAIT?>
			      <COND (<VERB? WAVE-AT>
				     <TELL "There's no cab here." CR>)
				    (T
				     <TELL
				      "Perhaps you should call the cab again."
				      CR>)>)>)
		      (ELSE
		       <>)>)
	       (<AND <VERB? EXAMINE LOOK-INSIDE>
		     <OR <AND <==? .CS ,CAB-SENT> <L=? .TURNS 1>>
			 <EQUAL? .CS ,CAB-HERE ,CAB-NEEDS-ID>>>
		<TELL "It's just an ordinary cab." CR>)
	       (<CAB-AND-DRIVER-AVAILABLE> <>)
	       (<AND <L=? .TURNS 1>
		     <HERE? OUTSIDE-HOUSE>
		     <==? .CS ,CAB-SENT>
		     <VERB? ENTER OPEN WALK-TO KNOCK LOOK-INSIDE>>
		<TELL "The Passengers' Teleportation Device hasn't been
approved for use yet, so you'll have to go to where the cab is first." CR>
		T)
	       (ELSE
		<TELL ,YOU-SEE "no cab here." CR>
		T)>>

<DEFINE CAB-DRIVER-ARREST ("AUX" VAL)
	<TELL CTHE ,CAB-DRIVER
	      " swears at you and starts yelling for a cop. ">
	<COND (<PROB 90>
	       <TELL
		"Not finding a cop, he drives you back to your house out of spite." CR>
	       <UPDATE-BP 5>
	       <SET VAL <EXIT-CAB T>>
	       .VAL)
	      (ELSE
	       <TELL "A policeman shows up and carts you off to gaol. Unfortunately, you are thrown in a holding cell with a mass murderer. He doesn't like you because you remind him of his ">
	       <GENDER-PRINT "father" "mother">
	       <TELL ". He naturally kills you.">
	       <JIGS-UP>
	       ,HERE)>>

<OBJECT CAB-DRIVER
	(LOC LOCAL-GLOBALS)
	(DESC "cab driver")
	(SYNONYM DRIVER CABBIE MAN) 
	(ADJECTIVE CAB TAXI)
	(FLAGS LIVING PERSON NDESCBIT SELLERBIT INVISIBLE)
	(ACTION CAB-DRIVER-F)>

<DEFINE CAB-DRIVER-F ("AUX" (CS <CABSTATE>))
	 <COND (<AND <OR <VERB? TELL ASK-ABOUT>
			 <EQUAL? ,CAB-DRIVER ,WINNER>>
		     <==? .CS ,CAB-HERE>
		     <NOT <FSET? ,CAB-DRIVER ,SEEN>>>
		<FSET ,CAB-DRIVER ,SEEN>
		<TELL
		 "The driver says, \"Are you the one who called for a cab?\""
		 CR>
		<PCLEAR>
		<COND (<SAID-YES? "\"Yes or no for chrissake!\"">
		       <TELL "\"Let's see some ID then.\"" CR>
		       <CABSTATE ,CAB-NEEDS-ID>
		       <CABTURNS 3>)
		      (T
		       <FCLEAR ,CAB-DRIVER ,SEEN>
		       <CAB-LEAVES>)>
		<COND (<AND <VERB? TELL ASK-ABOUT>
			    <PRSO? CAB-DRIVER>>
		       <SETG P-CONT <>>)>
		T)
	       (<CAB-AND-DRIVER-AVAILABLE>
		<COND (<VERB? TELL ASK-ABOUT>
		       <TELL "\"Haven't got time to gab.\"" CR>
		       <PCLEAR>
		       ,FATAL-VALUE)
		      (<VERB? GIVE SHOW PAY>
		       <COND (<AND <EQUAL? ,PRSO ,EXCESS ,BEEZER ,VISA>
				   <NOT <VERB? PAY>>
				   <==? .CS ,CAB-NEEDS-ID>>
			      <COND (<NEQ-TBL <CABNAME>
					      <ZREST <ZGET ,LICENSE-FORM
							   <+ ,LAST-NAME 1>>
						     <- ,FIELD-DATA-OFFSET 1>>>
				     <TELL "The driver examines ">
				     <COND (<==? ,PRSO ,VISA> <TELL THEO>)
					   (ELSE <TELL "your " D ,PRSO>)>
				     <TELL ". He says, \"I'm looking for ">
				     <MR-OR-MISS>
				     <PRINT-CABFIELD <CABNAME>>
				     <TELL ", not you.\"" CR>)
				    (ELSE
				     <TELL 
				      "The cab door pops open and you climb in. The cab driver says, \"You going to the airport, ">
				     <GENDER-PRINT "buddy" "lady">
				     <TELL "?\"" CR>
				     <COND (<SAID-YES? "\"I haven't got all day. Are you going to the airport?\" grumbles the cab driver.">
					    <TELL "\"Good. I like the airport,\"">)
					   (T
					    <TELL "\"Well that's where I'm going,\"">)>
				     <CABSTATE ,CAB-INHABITED>
				     <CABTURNS 1>
				     ;<MOVE ,CAB-DRIVER ,CAB-ROOM>
				     <MOVE ,CAB ,CAB-ROOM>
				     <MAKE ,CAB ,NODESC>
				     <MOVE ,PLAYER ,CAB-ROOM>
				     <SETG HERE ,CAB-ROOM>
				     <TELL
" says the cab driver, and sets off. He drives through the town and takes
the main highway out to the airport, humming \"Leaving on a Jet Plane\" by
Peter, Paul and Mary happily to himself" ,PCR>
				     <V-LOOK>)>
			      T)
			     (<==? .CS ,CAB-NEEDS-ID>
			      <TELL "\"You're not who I'm looking for.\" ">
			      <CAB-LEAVES>)
			     (<AND <EQUAL? ,PRSO ,BEEZER ,EXCESS ,CHECK>
				   <AIRPORT? .CS>>
			      <TELL "He takes only cash." CR>)
			     (<AND <AIRPORT? .CS>
				   <EQUAL? ,PRSO ,MONEY>>
			      <COND (<NOT ,P-DOLLAR-FLAG>
				     <SPECIFY-AN-AMOUNT>
				     <SETG P-NUMBER 0>)
				    (<L? ,CASH 1750>
				     <COND (<G=? ,P-NUMBER 1750>
					    <TELL ,DONT "have that much!">)
					   (ELSE
					    <TELL "He won't accept less than the fare!">)>
				     <SETG P-NUMBER 0>)
				    (<L? ,P-NUMBER 1750>
				     <TELL 
				      "He shakes the balance out of you. And leaves.">
				     <SETG P-NUMBER 1750>)
				    (<==? ,P-NUMBER 1750>
				     <TELL
				      "With a bitter sneer the cab driver spins his wheels in a puddle and drives off, drenching you with dirty water.">)
				    (<G? ,P-NUMBER ,CASH>
				     <TELL
				      "The driver takes all of your money, ">
				     <COND (<L? ,CASH 1951>
					    <TELL "even though he seems to
think it smells like a week-old fish carcass. You're still wondering how he
could possibly know " ITAL "that" " about your mother when he drives off.">)
					   (T
					    <TELL "and says you can owe him
the balance.">)>)
				    (<L? ,P-NUMBER 1951>
				     <TELL
				      "The driver looks at the money as if it were a week-old dead fish. He mentions something about your mother that you don't see how he could possibly know and drives off huffily.">)
				    (T
				     <TELL
				      "The driver thanks you profusely, points out some of the unique architectural features of the airport and hopes that your career, whatever it is, goes better than John Travolta's has of late. He drives off.">)>
			      <ZCRLF>
			      <REDUCE-CASH>
			      <COND (<N==? ,P-NUMBER 0>
				     <GOTO <EXIT-CAB>>)>
			      T)>)>)
	       (ELSE
		<TELL "There is no cab driver here." CR>
		<PCLEAR>
		,FATAL-VALUE)>>

<ROOM CAB-ROOM
      (LOC ROOMS)
      (DESC "In the Cab")
      (FLAGS NO-NERD LIGHTED LOCATION INDOORS)
      (GLOBAL CAB-DRIVER CAB)
      (SYNONYM SEAT)
      (ADJECTIVE BACK)
      (OUT PER CAB-EXIT-F)
      (ACTION CAB-ROOM-F)>

<OBJECT CAB-NOTICE
	(LOC CAB-ROOM)
	(DESC "cab notice")
	(FLAGS NODESC)
	(SYNONYM NOTICE SIGN)
	(ADJECTIVE CAB)
	(ACTION CNOTICE-F)>

<CONSTANT CAB-NOTICE-TXT
	  <PLTABLE 33
		  "WARNING! Please leave personal "
		  "items in this taxi (we need the"
		  "extra revenue).                "
		  "                               "
		  "NOTICE: Passengers NOT going   "
		  "to the airport will be charged "
		  "an extra 50 cents.             "
		  "                               "
		  "           Getlost Airport Taxi">>

<DEFINE CNOTICE-F ()
	<COND (<VERB? READ EXAMINE LOOK-ON>
	       <TELL "You read the notice." CR>
	       <SETG DO-WINDOW ,CAB-NOTICE-TXT>
	       T)
	      (ELSE <>)>> 

<DEFINE CAB-ROOM-F ("OPTIONAL" (RARG <>) "AUX" (CS <CABSTATE>) VAL)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL "You're in the back seat of a Getlost cab." CR>)
	       (<==? .RARG ,M-BEG>
		<COND (<AND <NOT <GAME-VERB?>>
			    <==? .CS ,CAB-JUST-AT-AIRPORT>>
		       <CABSTATE ,CAB-AT-AIRPORT>)>
		<COND (<AND <VERB? EXAMINE LOOK-ON> <PRSO? CAB>>
		       <TELL "It's just an ordinary back seat of a cab. There is a cab notice here." CR>)
		      (<VERB? WAIT>
		       <COND (<EQUAL? .CS ,CAB-AT-AIRPORT ,CAB-EXIT-ATTEMPT>
			      <TELL "The driver asks you not to hang around in his cab." CR>
			      <CABSTATE ,CAB-WAITING-FOR-YOUR-EXIT>
			      T)
			     (<==? .CS ,CAB-WAITING-FOR-YOUR-EXIT>
			      <TELL "The driver tells you to pay him and leave or he'll call a cop." CR>
			      <CABSTATE ,CAB-DRIVER-PISSED>
			      T)
			     (<==? .CS ,CAB-DRIVER-PISSED>
			      <GOTO <CAB-DRIVER-ARREST> T T>
			      T)>)
		      (ELSE <>)>)
	       (<T? .RARG> <>)
	       (<VERB? EXAMINE LOOK-INSIDE LOOK-ON>
		<PERFORM ,V?LOOK>)
	       (<AND <THIS-PRSI?> <VERB? PUT PUT-ON>>
		<PERFORM ,V?DROP ,PRSO>)
	       (ELSE <>)>>

<DEFINE CAB-EXIT-F ("AUX" (CS <CABSTATE>))
	<COND (<OR <==? .CS ,CAB-INHABITED> <QUEUED? I-CAB>>
	       <TELL "The cab is still moving, so you decide to stay."
		     CR>
	       <>)
	      (<EQUAL? .CS ,CAB-JUST-AT-AIRPORT
		       ,CAB-AT-AIRPORT
		       ,CAB-WAITING-FOR-YOUR-EXIT>
	       <TELL "The cab driver won't let you leave until you pay."
		     CR>
	       <CABSTATE ,CAB-EXIT-ATTEMPT>
	       <>)
	      (<EQUAL? .CS ,CAB-EXIT-ATTEMPT  ,CAB-DRIVER-PISSED>
	       <CAB-DRIVER-ARREST>)>>

<DEFINE AIRPORT? (CS)
	<EQUAL? .CS
		,CAB-JUST-AT-AIRPORT
		,CAB-AT-AIRPORT
		,CAB-EXIT-ATTEMPT
		,CAB-WAITING-FOR-YOUR-EXIT
		,CAB-DRIVER-PISSED>>

<DEFINE CAB-LEAVES ()
	<CABSTATE ,CAB-RETURNED>
	<UNMAKE ,CAB-DRIVER ,SEEN>
	<DEQUEUE I-CAB>
	<TELL "The cab driver guns the engine and takes off." CR>
	<UPDATE-BP 5>>

<DEFINE EXIT-CAB ("OPTIONAL" (HOME? <>))
	<CABSTATE ,CAB-INIT>
	<CABTIMES 0>
	<DEQUEUE I-CAB>
	;<ZREMOVE ,CAB>
	;<ZREMOVE ,CAB-ROOM>
	<UNMAKE ,CAB ,SEEN>
	<UNMAKE ,CAB-DRIVER ,SEEN>
	<MAKE ,CAB ,INVISIBLE>
	<MAKE ,CAB-DRIVER ,INVISIBLE>
	<COND (.HOME?
	       <TELL CR
		     "The cabbie throws you out of the cab, swears eternal vengeance on you and all your descendants, and roars off, leaving you face down in the gutter" ,PERIOD>
	       ,OUTSIDE-HOUSE)
	      (ELSE
	       <ZCRLF>
	       <VISIT-AIRPORT T>)>>
