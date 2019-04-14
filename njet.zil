"NJET for BUREAUCRACY: Copyright 1987 Infocom, Inc. All rights reserved."

<FILE-FLAGS MDL-ZIL?>

<OBJECT PLANE
	(LOC GLOBAL-OBJECTS)
	(DESC "airplane")
	(FLAGS NODESC VOWEL PLACE)
	(SYNONYM PLANE AIRPLANE JET AIRCRAFT)
	(ACTION PLANE-F)>

<DEFINE PLANE-F ()
	 <COND (<NOT <HERE? IN-PLANE>>
		<CANT-FROM-HERE>
		T)
	       (<HERE-F>
		T)
	       (T
		<>)>>

<OBJECT SEATBELT
	(DESC "seat belt")
	(FLAGS CLOTHING WORN)
	(SYNONYM BELT SEATBELT BUCKLE)
	(ADJECTIVE SEAT MY)
	(ACTION SEATBELT-F)>

<DEFINE SEATBELT-F ()
	 <COND (<THIS-PRSI?>
		<>)
	       (<VERB? EXAMINE>
		<TELL "Don't worry. Your " Q ,PRSO 
		      " is securely fastened." CR>
		T)
	       (<VERB? UNTIE OPEN TAKE-OFF>
		<COND (<IS? ,BELTLIGHT ,LIGHTED>
		       <TELL 
"Better not. The FASTEN SEAT BELT sign is still lit." CR>)
		      (T
		       <MAKE ,BELTLIGHT ,LIGHTED>
		       <UNMAKE ,BELTLIGHT ,NODESC>
		       <QUEUE I-BELTLIGHT>
		       <TELL "As you start to open your " Q ,PRSO ", ">
		       <COND (<IS? ,BELTLIGHT ,SEEN>
			      <TELL "the">)
			     (T
			      <TELL "a">)>
		       <TELL " FASTEN SEAT BELT sign blinks on ">
		       <COND (<IS? ,BELTLIGHT ,SEEN>
			      <TELL "again. You grudgingly ">)
			     (T
			      <MAKE ,BELTLIGHT ,SEEN>
			      <TELL "overhead. You decide to ">)>
		       <TELL "comply." CR>)>
		T)
	       (<VERB? TIE CLOSE WEAR>
		<TELL "Your " Q ,PRSO " is already fastened." CR>
		T)
	       (<OR <VERB? DROP>
		    <PUTTING?>>
		<YOUD-HAVE-TO "take off" ,PRSO>
		T)
	       (<VERB? TAKE TAKE-WITH>
		<TELL "You're wearing it already." CR>
		T)
	       (T
		<>)>>

<OBJECT BELTLIGHT
	(LOC IN-PLANE)
	(DESC "sign")
	(FLAGS NODESC READABLE)
	(SYNONYM SIGN NOTICE)
	(ADJECTIVE FASTEN SEAT BELT)
	(DESCFCN BELTLIGHT-F)
	(ACTION BELTLIGHT-F)>

<DEFINE BELTLIGHT-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-OBJDESC>
		<TELL "A sign overhead says FASTEN SEAT BELT.">
		T)
	       (<T? .CONTEXT>
		<>)
	       (<TOUCHING?>
		<CANT-FROM-HERE>
		T)
	       (<THIS-PRSI?>
		<>)
	       (<VERB? EXAMINE READ LOOK-ON>
		<TELL CTHEO " overhead ">
		<COND (<IS? ,PRSO ,LIGHTED>
		       <TELL "says FASTEN SEAT BELT." CR>)
		      (T
		       <TELL "is dark at the moment." CR>)>
		T)
	       (T
		<>)>>

<OBJECT UNDER-SEAT
	(LOC IN-PLANE)
	(DESC "floor")
	(FLAGS NODESC SURFACE)
	(SYNONYM FLOOR)
	(CAPACITY 6)
	(ACTION UNDER-SEAT-F)>

<DEFINE UNDER-SEAT-F ()
	 <COND (<THIS-PRSI?>
		<COND (<VERB? PUT PUT-UNDER PUT-BEHIND>
		       <IMPOSSIBLE>
		       T)
		      (T
		       <>)>)
	       (<OR <ENTERING?>
		    <VERB? STAND-ON SIT LIE-DOWN>>
		<DO-WALK ,P?OUT>
		T)
	       (<EXITING?>
		<NOT-ON>
		T)
	       (T
		<>)>>		

<OBJECT SEAT
	(LOC IN-PLANE)
	(DESC "your seat")
	(FLAGS NODESC NOARTICLE SURFACE)
	(SYNONYM SEAT CHAIR)
	(ADJECTIVE MY YOUR)
	(GENERIC GENERIC-SEAT-F)
	(ACTION SEAT-F)>

<DEFINE SEAT-F ("AUX" X)
	 <COND (<THIS-PRSI?>
		<COND (<VERB? PUT EMPTY-INTO>
		       <COND (<AND <PRSO? PHONES>
				   <VERB? PUT>>
			      <PLUG-IN-PHONES>)
			     (T
			      <TELL "[in " THE ,SEAT-POCKET ,BRACKET>
			      <SET X <PERFORM ,PRSA ,PRSO ,SEAT-POCKET>>)>
		       T)
		      (<VERB? PLUG UNPLUG REPLUG>
		       <TELL "[" THE ,RECEPTACLE ,BRACKET>
		       <SET X <PERFORM ,PRSA ,PRSO ,RECEPTACLE>>
		       T)
		      (<VERB? PUT-ON PUT-BEHIND>
		       <DO-WALK ,P?OUT>
		       T)
		      (<VERB? PUT-UNDER>
		       <COND (<G? <WEIGHT ,UNDER-SEAT> 6>
			      <TELL 
"There's no more room under " Q ,PRSI ,PERIOD>)
			     (T
			      <TELL "You put " THEO
				    " under " Q ,SEAT ,PERIOD>)>
		       T)
		      (T <>)>)
	       (<VERB? EXAMINE LOOK-ON SEARCH>
		<TELL
"The seat in which you're sitting has a storage pocket and a receptacle for headphones." CR>
		T)
	       (<VERB? LOOK-INSIDE SEARCH>
		<SET X <PERFORM ,V?LOOK-INSIDE ,SEAT-POCKET>>
		T)
	       (<VERB? LOOK-UNDER>
		<TELL ,YOU-SEE>
		<PRINT-CONTENTS ,UNDER-SEAT>
		<TELL " under your seat." CR>
		T)
	       (<VERB? EXIT LEAVE CLIMB-UP STAND-ON LEAP ESCAPE>
		<DO-WALK ,P?OUT>
		T)
	       (<OR <VERB? SIT>
		    <ENTERING?>>
		<ALREADY-IN>
		T)
	       (<VERB? LIE-DOWN>
		<TELL "It's impossible to get comfortable." CR>
		T)
	       (T
		<>)>>
		      		       
<DEFINE GENERIC-SEAT-F (TBL)
	 <COND (<EQUAL? ,P-IT-OBJECT ,SEAT ,SEAT-POCKET>
		<RETURN ,P-IT-OBJECT>)
	       (<NOUN-USED? ,W?POCKET>
		<RETURN ,SEAT-POCKET>)>
	 ,SEAT>

<OBJECT SEAT-POCKET
	(LOC IN-PLANE)
	(DESC "seat pocket")
	(FLAGS NODESC CONTAINER OPENABLE OPENED)
	(SYNONYM POCKET SEAT)
	(ADJECTIVE SEAT)
	(CAPACITY 10)
	(GENERIC GENERIC-SEAT-F)
	(ACTION SEAT-POCKET-F)>

<DEFINE SEAT-POCKET-F ()
	 <COND (<THIS-PRSI?>
		<>)
	       (<VERB? CLOSE>
		<TELL ,CANT "close " THEO ,PERIOD>
		T)
	       (T
		<>)>>

<OBJECT BARF-BAG
	(LOC SEAT-POCKET)
	(DESC "discomfort bag")
	(FLAGS TAKEABLE CONTAINER OPENABLE READABLE)
	(SYNONYM BAG)
	(ADJECTIVE DISCOMFORT BARF VOMIT)
	(SIZE 2)
	(CAPACITY 2)
	(ACTION BARF-BAG-F)>
		
<DEFINE BARF-BAG-F ()
	 <COND (<THIS-PRSI?>
		<>)
	       (<VERB? EXAMINE READ LOOK-ON>
		<TELL
"The bag, cheerfully labelled \"Convenience Bag,\" is a rather simple white affair which is considerably more capable of holding an airline meal than your stomach is." CR>
		T)
	       (T
		<>)>>

<OBJECT PHONES
	(LOC SEAT-POCKET)
	(DESC "pair of headphones")
	(FLAGS TAKEABLE CLOTHING)
	(SYNONYM HEADPHONE PAIR SET EARPHONE EARPHONES PHONES)
	(ADJECTIVE HEAD EAR)
	(SIZE 3)
	(ACTION PHONES-F)>

<BIT-SYNONYM SEEN PLUGGED-IN>

<DEFINE PHONES-F ()
	 <COND (<THIS-PRSI?>
		<>)
	       (<OR <VERB? DROP>
		    <PUTTING?>>
		<COND (<IS? ,PRSO ,PLUGGED-IN>
		       <UNMAKE ,PRSO ,PLUGGED-IN>
		       <TELL "[unplugging " THEO " first" ,BRACKET>)>
		<>)
	       (<VERB? EXAMINE LOOK-ON>
		<TELL "It's an ordinary set of airline headphones, ">
		<COND (<IS? ,PRSO ,PLUGGED-IN>
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
		       <ZPUT ,PLANE-TABLE ,PHONE-TIMER 0>
		       <TELL "You put on " THEO>
		       <COND (<IS? ,PRSO ,PLUGGED-IN>
			      <TELL ", and hear ">
			      <SAY-MUZAK <ZGET ,PLANE-TABLE ,PHONE-MUSIC>>)>
		       <TELL ,PERIOD>
		       T)>)
	       (<VERB? UNPLUG>
		<UNPLUG-PHONES>
		T)
	       (<VERB? PLUG REPLUG>
		<PLUG-IN-PHONES>
		T)
	       (T
		<>)>>

<DEFINE UNPLUG-PHONES ()
	 <COND (<NOT <IS? ,PHONES ,PLUGGED-IN>>
		<TELL "The headphones aren't plugged in." CR>)
	       (T
		<UNMAKE ,PHONES ,PLUGGED-IN>
		<TELL "You unplug the headphones." CR>)>
	 T>

<DEFINE PLUG-IN-PHONES ()
	 <COND (<IS? ,PHONES ,PLUGGED-IN>
		<TELL "The headphones are already plugged in." CR>
		T)
	       (<NOT <IN? ,PHONES ,PLAYER>>
		<TELL
"You'd find that a lot easier to do if you were holding the headphones." CR>
		T)
	       (T
		<MAKE ,PHONES ,PLUGGED-IN>
		<TELL "You plug in the " Q ,PHONES>
		<COND (<NOT <IS? ,RECEPTACLE ,SEEN>>
		       <TELL " again">)>
		<TELL ,PERIOD>
		<MAKE ,RECEPTACLE ,SEEN>
		T)>>

<OBJECT PLANE-MAGAZINE
	(LOC SEAT-POCKET)
	(DESC "airline magazine")
	(FLAGS VOWEL TAKEABLE READABLE)
	(SYNONYM MAGAZINE ODYSSEY)
	(ADJECTIVE AIRLINE AIRPLANE ZALAGASAN ODYSSEY)
	(SIZE 3)
	(ACTION PLANE-MAGAZINE-F)>

<DEFINE PLANE-MAGAZINE-F ()
	 <COND (<THIS-PRSI?>
		<COND (<PUTTING?>
		       <WASTE-OF-TIME>
		       T)
		      (T
		       <>)>)
	       (<VERB? READ EXAMINE LOOK-INSIDE LOOK-ON>
		<TELL "This is the latest issue of ">
		<ITALICIZE "Zalagasan Odyssey">
		<TELL ", the official magazine of Air Zalagasa." CR>
		T)
	       (<VERB? OPEN>
		<TELL 
"You open " THEO ", browse for a moment, and close it again." CR>
		T)
	       (<VERB? CLOSE>
		<ITS-ALREADY "closed">
		T)
	       (T
		<>)>>

<OBJECT CARD
	(LOC SEAT-POCKET)
	(DESC "safety card")
	(FLAGS TAKEABLE READABLE)
	(SIZE 2)
	(SYNONYM CARD)
	(ADJECTIVE SAFETY)
	(ACTION CARD-F)>

<DEFINE CARD-F ()
	 <COND (<THIS-PRSI?>
		<COND (<PUTTING?>
		       <WASTE-OF-TIME>
		       T)
		      (T
		       <>)>)
	       (<VERB? EXAMINE READ LOOK-ON>
		<TELL
"This is the safety card for your aircraft, an Aerocom IF-47." CR>
		T)
	       (T
		<>)>>

<OBJECT RECEPTACLE
	(LOC IN-PLANE)
	(DESC "headphone receptacle")
	(FLAGS NODESC CONTAINER OPENED OPENABLE)
	(SYNONYM RECEPTABLE OUTLET JACK)
	(ADJECTIVE HEADPHONE EARPHONE PHONE)
	(CAPACITY 0)
	(ACTION RECEPTACLE-F)>

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
		<COND (<IS? ,PHONES ,PLUGGED-IN>
		       <TELL CTHE ,PHONES 
" is plugged in to the receptacle." CR>)
		      (T
		       <TELL "The receptacle is labeled HEADPHONES." CR>)>
		T)
	       (T <>)>>

<OBJECT IFORM
	(DESC "immigration form")
	(FLAGS VOWEL TAKEABLE READABLE)
	(SYNONYM FORM PAPER)
	(ADJECTIVE IMMIGRATION)
	(SIZE 2)
	(ACTION IFORM-F)>

<BIT-SYNONYM SEEN FILLED-IN>

<DEFINE IFORM-F ("AUX" (V <>) X)
	 <COND (<IS? ,VNUMBER ,FILLED-IN>
		<SET V T>)>
	 <COND (<THIS-PRSI?>
		<COND (<AND <VERB? TAKE>
			    <PRSO? VNUMBER>>
		       <SET X <PERFORM ,V?ERASE ,VNUMBER>>
		       T)
		      (<PUTTING?>
		       <WASTE-OF-TIME>
		       T)
		      (T
		       <>)>)
	       (<VERB? EXAMINE READ LOOK-ON>
		<TELL CTHEO>
		<COND (<IS? ,PRSO ,FILLED-IN>
		       <TELL " has been completed with ">)
		      (T
		       <TELL " has blank spaces for">)>
		<TELL 
" your name, address and other data concerning your nationality and reason(s), if any, for visiting Zalagasa. A prominent space is set aside for your visa number">
		<COND (<T? .V>
		       <TELL 
", which you have dutifully (if somewhat randomly) filled in">)>
		<PRINT ,PERIOD>
		T)
	       (<VERB? FILL-IN>
		<COND (<IS? ,PRSO ,FILLED-IN>
		       <TELL "You've already filled in " THEO >
		       <COND (<T? .V>
			      <TELL " completely." CR>)
			     (T
			      <TELL ", except for " THE ,VNUMBER ,PERIOD>)>
		       T)
		      (T
		       <MAKE ,PRSO ,FILLED-IN>
		       <TELL "You dutifully fill out the ">
		       <COND (<T? .V>
			      <TELL "remaining ">)>
		       <TELL "spaces on " THEO>
		       <COND (<ZERO? .V>
			      <TELL ", leaving only " THE ,VNUMBER " blank">)>
		       <PRINT ,PERIOD>
		       T)>)
	       (<VERB? ERASE>
		<COND (<NOT <IS? ,PRSO ,FILLED-IN>>
		       <TELL CTHEO " isn't filled in." CR>)
		      (T
		       <UNMAKE ,PRSO ,FILLED-IN>
		       <TELL "You erase " THEO ,PERIOD>)>
		T)
	       (T
		<>)>>
	       
<OBJECT VNUMBER
	(LOC IFORM)
	(DESC "visa number")
	(FLAGS NODESC)
	(SYNONYM NUMBER)
	(ADJECTIVE VISA)
	(ACTION VNUMBER-F)>

<DEFINE VNUMBER-F ()
	 <COND (<THIS-PRSI?>
		<COND (<PUTTING?>
		       <IMPOSSIBLE>
		       T)
		      (T
		       <>)>)
	       (<MOVING?>
		<IMPOSSIBLE>
		T)
	       (<VERB? EXAMINE LOOK-ON READ>
		<COND (<IS? ,PRSO ,FILLED-IN>
		       <TELL "You've filled in " THEO
			     " with a random number." CR>)
		      (T
		       <TELL "That space is still blank." CR>)>
		T)
	       (<VERB? FILL-IN>
		<COND (<IS? ,PRSO ,FILLED-IN>
		       <TELL "You rub out the old " Q ,PRSO
", and replace it with another equally random value." CR>)
		      (T
		       <MAKE ,PRSO ,FILLED-IN>
		       <TELL
			"You fill in " THEO
			" with an official-looking but utterly random number."
			CR>)>
		T)
	       (<VERB? ERASE>
		<COND (<NOT <IS? ,PRSO ,FILLED-IN>>
		       <TELL CTHEO " isn't filled in." CR>)
		      (T
		       <UNMAKE ,PRSO ,FILLED-IN>
		       <TELL "You erase " THEO ,PERIOD>)>)
	       (T
		<>)>>

<OBJECT CHUTE
	(DESC "parachute")
	(FLAGS TAKEABLE WORN CLOTHING SURFACE)
	(SYNONYM CHUTE PARACHUTE STRAP STRAPS)
	(ADJECTIVE CHUTE PARACHUTE)
	(SIZE 10)
	(ACTION CHUTE-F)>

<DEFINE CHUTE-F CHUTE ()
	 <COND (<NOUN-USED? ,W?STRAP ,W?STRAPS>
		<COND (<THIS-PRSI?>
		       T)
		      (<VERB? EXAMINE LOOK-ON>
		       <TELL CTHEO "'s straps are ">
		       <COND (<HERE? OUTSIDE-PLANE>
			      <TELL "caught in the plane's "
				    Q ,HATCH ,PERIOD>
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
		<COND (<HERE? OUTSIDE-PLANE>
		       <TELL CTHEO
" is strapped to your back, which is good, and caught in " THE ,HATCH
" of the plane, which is bad." CR>
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
		<PRINT ,PERIOD>
		T)
	       (<VERB? LOOK-ON READ>
		<TELL "The words HAVE A NICE DAY are silkscreened on " THEO
		      ,PERIOD>
		T)
	       (<VERB? TAKE-OFF DROP>
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
		       <ITS-ALREADY "closed">)>
		T)
	       (T <>)>>

<DEFINE LOOSEN-CHUTE ()
	 <TELL ", and immediately plummet ">
	 <COND (<HERE? OUTSIDE-PLANE>
		<TELL "away from the plane." CR>
		<TO-IN-AIR>)
	       (T
		<TELL "towards the ground below." CR>
		<COND (<HERE? IN-AIR>
		       <HIT-GROUND>)
		      (T
		       <SETG HERE ,IN-POT>
		       <MOVE ,PLAYER ,HERE>
		       <CRLF>
		       <ITALICIZE "Splash">
		       <TELL "!" CR CR>
		       <V-LOOK>)>)>
	 T>

<DEFINE OPEN-CHUTE CHUTE ()
	 <COND (<CHUTE-OPEN?>
		<TELL
"You yank on " THE ,RIPCORD " again, but as " THE ,CHUTE
" is already deployed, nothing happens." CR>
		<RETURN T .CHUTE>)
	       (<HERE? OUTSIDE-PLANE>
		<TELL
"Things were bad enough with your " Q ,CHUTE " straps caught in " THE ,HATCH
". Pulling " THE ,RIPCORD ", as you might well have expected, has added the complication of a deployed " Q ,CHUTE " as well. The various straps, cords and other " Q ,CHUTE " paraphenalia, each going its own merry way, sends you flying in a number of very unpleasant pieces.">
		<JIGS-UP>
		<RETURN T .CHUTE>)>
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
	 <COND (<THIS-PRSI?>
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

<OBJECT PENCIL
	(DESC "pencil")
	(FLAGS TAKEABLE)
	(SIZE 2)
	(SYNONYM PENCIL ERASER)
	(ADJECTIVE PENCIL)
	(ACTION PENCIL-F)>

<DEFINE PENCIL-F ()
	 <COND (<THIS-PRSI?>
		<>)
	       (<VERB? FILL-IN>
		<TELL "You'd need another pencil." CR>
		T)
	       (<VERB? ERASE>
		<TELL "You'd need another eraser." CR>
		T)
	       (<VERB? EXAMINE LOOK-ON>
		<TELL 
"It's a standard pencil, equipped with an equally standard eraser." CR>
		T)
	       (T
		<>)>>

<OBJECT HATCH
	(LOC OUTSIDE-PLANE)
	(DESC "emergency exit")
	(FLAGS NODESC VOWEL)
	(SYNONYM EXIT HATCH HATCHWAY DOOR)
	(ADJECTIVE EMERGENCY PLANE\'S)
	(ACTION HATCH-F)>

<DEFINE HATCH-F ()
	 <COND (<THIS-PRSI?>
		<>)
	       (<VERB? EXAMINE>
		<TELL CTHEO " is closed." CR>
		T)
	       (<VERB? OPEN UNLOCK>
		<TELL "There's no way to open " THEO
" from the outside when it's locked from the inside." CR>
		T)
	       (<VERB? CLOSE LOCK>
		<ITS-ALREADY "closed">
		T)
	       (<VERB? KNOCK>
		<TELL
"After a few moments of violent knocking, " THE ,STEWARDESS
" turns around. She seems terribly pleased to be able to serve you yet again. She cheerfully opens the hatch, inquires \"May I help you?\" and thoughtfully waves goodbye as you plummet headlong into the night." CR>
		<TO-IN-AIR>
		T)
	       (<VERB? LOOK-INSIDE LOOK-BEHIND WATCH>
		<LOOK-IN-HATCH>
		T)
	       (<VERB? ENTER THROUGH>
		<ITS-CLOSED>
		T)
	       (<EXITING?>
		<TELL "You've already done that." CR>
		T)
	       (T
		<>)>>

<DEFINE TO-IN-AIR ()
	 <DEQUEUE I-OUTSIDE-PLANE>
	 <SETG FALL-SCRIPT 3>
	 <QUEUE I-FALLING>
	 <SETG HERE ,IN-AIR>
	 <MOVE ,PLAYER ,HERE>
	 <CRLF>
	 <V-LOOK>
	 T>
				    
<DEFINE HIT-GROUND ()
	 <TELL
"Your fall comes to a rather abrupt end as your body hits the ground with a sickening thud.">
	 <JIGS-UP>
	 T>


"*** AIRPLANE ***"

<OBJECT IN-PLANE
	(LOC ROOMS)
	(DESC "Airplane Seat")
	(FLAGS NO-NERD LIGHTED LOCATION)
	(HEAR PLANE)
	(NORTH SORRY "A seat blocks your path.")
	(WEST SORRY "A seat blocks your path.")
	(SOUTH SORRY "A seat blocks your path.")
	(EAST SORRY "You'd have to unbuckle your seat belt first.")
	(OUT SORRY "You'd have to unbuckle your seat belt first.")
	(UP SORRY "You'd have to unbuckle your seat belt first.")
	(IN SORRY "You're already in your seat.")
	(DOWN SORRY "You're already in your seat.")
	(GLOBAL PLANE)
	(ACTION IN-PLANE-F)>

<DEFINE IN-PLANE-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL "You're seated in an airplane">
		<COND (<FIRST? ,UNDER-SEAT>
		       <TELL ". Under " Q ,SEAT " you see ">
		       <PRINT-CONTENTS ,UNDER-SEAT>)>
		<PRINT ,PERIOD>
		T)
	       (T
		<>)>>	

<OBJECT OUTSIDE-PLANE
	(LOC ROOMS)
	(DESC "Outside Plane")
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
	(ACTION OUTSIDE-PLANE-F)>

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
". The plane's " Q ,HATCH " is a few feet away">)>
		<PRINT ,PERIOD>
		T)
	       (T
		<>)>>

<OBJECT IN-AIR
	(LOC ROOMS)
	(DESC "Falling")
	(SDESC DESCRIBE-IN-AIR)
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

<DEFINE DESCRIBE-IN-AIR ()
	 <TELL "Falling">
	 T>

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

<OBJECT IN-TREE
	(LOC ROOMS)
	(DESC "Tree")
	(FLAGS SPECIAL-DROP NO-NERD LIGHTED LOCATION)
	(ACTION IN-TREE-F)>

<DEFINE IN-TREE-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL "You're hanging upside down in a tree." CR>
		T)
	       (T
		<>)>>

<OBJECT IN-POT
	(LOC ROOMS)
	(DESC "Cooking Pot")
	(FLAGS NO-NERD LIGHTED LOCATION)
	(ACTION IN-POT-F)>

<DEFINE IN-POT-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL "You're in a cooking pot, surrounded by cannibals." CR>
		T)
	       (T
		<>)>>


"*** STEWARDESS ***"

<OBJECT STEWARDESS
	(DESC "stewardess")
	(FLAGS LIVING PERSON FEMALE)
	(SYNONYM STEWARDESS LADY WOMAN ATTENDANT)
	(ADJECTIVE FLIGHT)
	(DESCFCN STEWARDESS-F)
	(ACTION STEWARDESS-F)>

<BIT-SYNONYM SEEN GIVEN-FORM>

<DEFINE STEWARDESS-F STEW ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-OBJDESC>
		<TELL "A " Q ,STEWARDESS " is waiting for your "
		      Q ,IFORM ".">
		T)
	       (<EQUAL? .CONTEXT ,M-WINNER>
		<COND (<VERB? TAKE EXAMINE READ>
		       <SHOW-TO-STEWARDESS>
		       <RETURN ,FATAL-VALUE .STEW>)
		      (<PRSO? ME>
		       <COND (<VERB? TELL-ABOUT SSHOW>
			      <ASK-STEWARDESS-ABOUT>
			      <RETURN ,FATAL-VALUE .STEW>)
			     (<VERB? SGIVE SSELL>
			      <ASK-STEWARDESS-FOR>
			      <RETURN ,FATAL-VALUE .STEW>)>)
		      (<PRSI? ME>
		       <COND (<VERB? SHOW>
			      <ASK-STEWARDESS-ABOUT ,PRSO>
			      <RETURN ,FATAL-VALUE .STEW>)
			     (<VERB? GIVE SELL>
			      <ASK-STEWARDESS-FOR ,PRSO>
			      <RETURN ,FATAL-VALUE .STEW>)>)>
		<IGNORES ,WINNER>
		,FATAL-VALUE)
	       (<T? .CONTEXT>
		<>)
	       (<THIS-PRSI?>
		<COND (<VERB? GIVE SHOW>
		       <SHOW-TO-STEWARDESS>
		       T)
		      (T
		       <>)>)
	       (<VERB? TELL>
		<>)
	       (<VERB? EXAMINE>
		<TELL CTHEO " is watching you with polite impatience." CR>
		T)
	       (<VERB? ASK-ABOUT>
		<ASK-STEWARDESS-ABOUT>
		T)
	       (<VERB? ASK-FOR>
		<ASK-STEWARDESS-FOR>
		T)
	       (T
		<>)>>

<DEFINE SHOW-TO-STEWARDESS ("OPTIONAL" (OBJ <>))
	 <COND (<ZERO? .OBJ>
		<SET OBJ ,PRSO>)>
	 <COND (<EQUAL? .OBJ ,PENCIL>
		<NEED-PENCIL>
		T)
	       (<EQUAL? .OBJ ,IFORM>
		<TELL CTHE ,STEWARDESS " glances at the form ">
		<COND (<IS? ,STEWARDESS ,GIVEN-FORM>
		       <TELL "again ">)>
		<TELL "and hands it back to you. \"">
		<COND (<NOT <IS? .OBJ ,FILLED-IN>>
		       <COND (<IS? ,STEWARDESS ,GIVEN-FORM>
			      <TELL "Still not right. I'll keep waiting ">)
			     (T
			      <TELL "I'll just wait here ">)>
		       <MAKE ,STEWARDESS ,GIVEN-FORM>
		       <TELL
"until you've completed the form,\" she tells you." CR>
		       T)
		      (<NOT <IS? ,VNUMBER ,FILLED-IN>>
		       <TELL "You ">
		       <COND (<IS? ,STEWARDESS ,GIVEN-FORM>
			      <TELL "still haven't completed ">)
			     (T
			      <TELL "must have forgotten to complete ">)>
		       <MAKE ,STEWARDESS ,GIVEN-FORM>
		       <TELL "your " Q ,VNUMBER 
",\" she says. \"I'll wait here until you've filled it in.\"" CR>
		       T)
		      (T
		       <TELL "That's ">
		       <COND (<IS? ,STEWARDESS ,GIVEN-FORM>
			      <TELL "still ">)
			     (T
			      <TELL "obviously ">)>
		       <TELL "not a valid " Q ,VNUMBER ", ">
		       <SIR-OR-MAAM>
		       <TELL ",\" she says. \"I'll ">
		       <COND (<IS? ,STEWARDESS ,GIVEN-FORM>
			      <TELL "keep waiting ">)
			     (T
			      <TELL "wait here ">)>
		       <MAKE ,STEWARDESS ,GIVEN-FORM>
		       <TELL "until you fill in the correct number.\"" CR>)>)
	       (T
		<TELL CTHE ,STEWARDESS " shows little interest in "
		      THE .OBJ ,PERIOD>)>
	 T>

<DEFINE NEED-PENCIL ()
	 <TELL
"\"You'll need that to fill in " THE ,IFORM ".\"" CR>>

<DEFINE ASK-STEWARDESS-ABOUT ("OPTIONAL" (OBJ <>))
	 <COND (<ZERO? .OBJ>
		<SET OBJ ,PRSI>)>
	 <COND (<EQUAL? .OBJ ,PENCIL>
		<NEED-PENCIL>)
	       (<EQUAL? .OBJ ,IFORM ,VNUMBER>
		<TELL
"\"Yes, " THE .OBJ ". Please fill it out completely,\" she prompts." CR>)
	       (T
		<TELL "\"I'm not authorized to talk about " THE .OBJ
		      ",\" admits " THE ,STEWARDESS ,PERIOD>)>
	 T>
	 
<DEFINE ASK-STEWARDESS-FOR ("OPTIONAL" (OBJ <>))
	 <COND (<ZERO? .OBJ>
		<SET OBJ ,PRSI>)>
	 <COND (<IN? .OBJ ,PLAYER>
		<TELL
"\"The one you have will do just fine.\"" CR>)
	       (T
		<TELL "\"I'm afraid I don't have " A .OBJ
		      ",\" replies " THE ,STEWARDESS ,PERIOD>)>
	 T>

"*** PURSER ***"

<OBJECT PURSER
	(DESC "purser")
	(FLAGS LIVING PERSON)
	(SYNONYM PURSER MAN GUY FELLOW)
	(ADJECTIVE BURLY)
	(DESCFCN PURSER-F)
	(ACTION PURSER-F)>

<DEFINE PURSER-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-OBJDESC>
		<TELL CTHE ,PURSER " is standing over you.">
		T)
	       (<T? .CONTEXT>
		<>)
	       (<THIS-PRSI?>
		<COND (<VERB? GIVE SHOW>
		       <TELL CTHEI " doesn't seem interested in "
			     THEO ,PERIOD>
		       T)
		      (T
		       <>)>)
	       (<VERB? TELL ASK-ABOUT ASK-FOR YELL QUESTION REPLY
		       WAVE-AT BOW REFUSE THANK HELLO GOODBYE>
		<TELL CTHE ,WINNER " grunts in reponse." CR>
		<I-PLANE>
		,FATAL-VALUE)
	       (<VERB? EXAMINE>
		<TELL CTHE ,PURSER " is rather burly-looking." CR>
		T)
	       (T
		<>)>>
