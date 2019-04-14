"ZALAGASA for BUREAUCRACY. Copyright 1987 Infocom, Inc. All rights reserved."

<FILE-FLAGS MDL-ZIL?>

<INCLUDE "COMPUTERDEFS">

<OBJECT IN-TREE
	(LOC ROOMS)
	(DESC "hanging from a tree")
	(LDESC "You are hanging upside down by your parachute from the branches of a tree.")
	(FLAGS LIGHTED LOCATION NO-NERD SPECIAL-DROP)
	(SYNONYM BRANCHES TREE)
	(NORTH SORRY "Such directions are useless here.")
	(EAST SORRY "Such directions are useless here.")
	(SOUTH SORRY "Such directions are useless here.")
	(WEST SORRY "Such directions are useless here.")
	(DOWN SORRY "You are attached.")
	(UP SORRY "Wishful thinking.")
	(OUT SORRY "You're already outside.")
	(IN SORRY "Wishful thinking.")
	(BELOW IN-POT)
	(GLOBAL IN-POT)
	(ACTION IN-TREE-F)>

<DEFINE IN-TREE-F ("OPT" (CONTEXT <>))
  <COND (<T? .CONTEXT> <>)
	(<NOT <HERE? IN-TREE IN-POT>>
	 <TELL "There isn't anything useful you can do that way." CR>)
	(<VERB? EXAMINE LOOK-ON LOOK-INSIDE>
	 <TELL "It's the ordinary sort of jungle tree; one would normally
expect it to be occupied by various exotic fruits and animals. Instead, it
seems to have a ">
	 <COND (<HERE? IN-TREE>
		<TELL "not terribly cheerful Happitec executive-designate">)
	       (T
		<TELL "chewed-up Chowmail OverNite parachute">)>
	 <TELL " in its branches." CR>)>>

<DEFINE NATIVES-EAT-YOU ()
  <TELL "Just as you're getting accustomed to your new surroundings and reflecting that at least you are out of the clutches of bureaucratic foul-ups, a phalanx of drunken journalists in Banana Republic safari clothes appears, accompanied by an enormous number of happy, smiling, cannibal natives. In the instant
before the natives invite you for dinner,
you spot someone in the back of the crowd staring intently at what looks like
a Boysenberry computer.">
  <JIGS-UP>
  T>

<OBJECT IN-POT
	(LOC ROOMS)
	(DESC "cooking pot")
	(FLAGS LIGHTED LOCATION NO-NERD)
	(SYNONYM POT)
	(ADJECTIVE COOKING)
	(NORTH PER EXIT-POT)
	(EAST PER EXIT-POT)
	(SOUTH PER EXIT-POT)
	(WEST PER EXIT-POT)
	(DOWN SORRY "Not unless you want to go from the pan to the fire!")
	(SEE-ALL NATIVES)
	(UP SORRY "Wishful thinking.")
	(OUT PER EXIT-POT)
	(GLOBAL NATIVES IN-POT)
	(IN SORRY "You are in deep enough.")
	(ACTION POT-F)>

" TOUCHED ==> Natives are amused with recipe cartridge"

<DEFINE EXIT-POT ()
	<COND (<IS? ,NATIVES ,TOUCHED>
	       <TELL "You get out of the pot while the Zalagasans are busy cataloguing their missionary and explorer recipe for the upcoming " ITAL "National Geographic" " article. Stumbling along, you fall into a hole, and end up in a grubby antechamber underground" ,PCR>
	       ,IN-CLEARING)
	      (ELSE
	       <TELL "You are prevented from leaving by the Zalagasans." CR>
	       <>)>>

<DEFINE POT-F ("OPT" (CONTEXT <>) "AUX" RM)
	<COND (<==? .CONTEXT ,M-LOOK>
	       <TELL "You are in " A ,IN-POT " beneath the tree from which you were previously hanging. The force of your impact seems to have emptied the pot. ">
	       <COND (<IS? ,NATIVES ,TOUCHED>
		      <TELL "The tribe have retreated to their computer to try out your pirated recipe program.">)
		     (T
		      <TELL "There is a tribe of Zalagasans dancing around the pot, chanting \"Z-BUG! Z-BUG!\"">)>
	       <ZCRLF>)
	      (<T? .CONTEXT> <>)
	      (<VERB? LOOK-INSIDE>
	       <TELL "It's just an ordinary cooking pot." CR>)
	      (<VERB? EXAMINE LOOK-ON>
	       <COND (<HERE? IN-TREE>
		      <TELL "Below, you see what looks like a large pot." CR>)
		     (T
		      <TELL
		       "It's an ordinary looking cannibal's cooking pot. You can see them any day of the week in Islington, with cheeseplants in."

		       CR>)>)
	      (<VERB? EXIT>
	       <COND (<SET RM <EXIT-POT>>
		      <GOTO .RM>)
		     (T T)>)
	      (<VERB? ENTER>
	       <COND (<HERE? IN-TREE>
		      <TELL "You're still attached to your parachute, so you can't go anywhere." CR>)
		     (<HERE? IN-POT>
		      <ALREADY-THERE>)
		     (T <>)>)
	      (ELSE <>)>>

<OBJECT NATIVES
	(LOC LOCAL-GLOBALS)
	(DESC "Zalagasans")
	(LDESC "A tribe of Zalagasan natives.")
	(FLAGS PLURAL PERSON)
	(SYNONYM NATIVES NATIVE ZALAGASAN TRIBE)
	(ADJECTIVE ZALAGASAN)
	(ACTION ZALAG-F)>

<DEFINE ZALAG-F ZALAG ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-WINNER>
		<COND (<VERB? STINGLAI> <RETURN <> .ZALAG>)
		      (<PRSO? ME>
		       <COND (<VERB? TELL-ABOUT>
			      <ASK-NATIVES-ABOUT ,PRSI>)
			     (<VERB? SSHOW SGIVE SSELL>
			      <NATIVES-SHOW-YOU ,PRSI>)
			     (T
			      <IGNORES ,NATIVES>)>)
		      (<PRSI? ME>
		       <COND (<VERB? SHOW>
			      <NATIVES-SHOW-YOU ,PRSO>)
			     (<VERB? GIVE SELL>
			      <ASK-NATIVES-FOR ,PRSO>)
			     (T
			      <IGNORES ,NATIVES>)>)
		      (T
		       <IGNORES ,NATIVES>)>
		,FATAL-VALUE)
	       (<T? .CONTEXT>
		<>)
	       (<THIS-PRSI?>
		<COND (<VERB? GIVE>
		       <COND (<PRSO? RECIPE>
			      <TELL "The Zalagasans aren't sure about the cartridge. Perhaps they'd like a demo." CR>)
			     (T
			      <TELL "It isn't likely that the Zalagasans would accept your offer." CR>)>)
		      (<VERB? SHOW>
		       <COND (<IS? ,PRSO ,PROGRAM>
			      <TELL "The Zalagasans might be more impressed by this nondescript chunk of plastic if they saw what it could do." CR>)
			     (<PRSO? AIRLINE-MAGAZINE>
			      <TELL "The Zalagasans stare in awe at the representation of someone they have only heard mentioned around the campfire. Finally one of them shouts, \"She's just a legend!\" They all start chanting that for a while, until they're all convinced, then return to chanting \"Z-BUG! Z-BUG!\"" CR>)>)
		      (T <>)>)
	       (<VERB? TELL>
		<>)
	       (<VERB? ASK-ABOUT>
		<ASK-NATIVES-ABOUT ,PRSI>)
	       (<VERB? ASK-FOR>
		<ASK-NATIVES-FOR ,PRSI>
		T)
	       (<VERB? EXAMINE>
		<TELL "They look like extras from a \"Tarzan\" movie." CR>
		T)
	       (T
		<>)>>

<DEFINE NATIVES-REACT (OBJ)
	<COND (<HERE? IN-POT>
	       <COND
		(<IS? ,NATIVES ,TOUCHED>)
		(T
		 <ZCRLF>
		 <COND
		     (<==? .OBJ ,ECLIPSE>
		      <TELL "For some reason the Zalagasans seemed completely unimpressed with your eclipse prediction. They mention that yesterday's eclipse was quite beautiful and that every member of the tribe belongs to the Zalagasa Boysenberry Users' Group (Z-BUG). It is obvious that the Zalagasans will not be fooled by the old eclipse prediction trick." CR>)
		     (<==? .OBJ ,RECIPE>
		      <TELL "The entire tribe go into an ecstatic frenzy. They grab the cartridge from your computer and run off to try it out on their Boysenberry. One kindly soul, remorseful at taking your cartridge without compensation, gives you another one. \"Maybe you'll like this.\" He also hands you an address book. \"If you see that nerdly fellow, give him this. He dropped it here just now.\"" CR>
		      <ZREMOVE .OBJ>
		      <SETG NERD-HACKED-ABOOK? T>
		      <MOVE ,ABOOK ,PLAYER>
		      <MOVE ,RANDOM-CARTRIDGE ,PLAYER>
		      <THIS-IS-IT ,ABOOK>
		      <UPDATE-SCORE 1>
		      <MAKE ,NATIVES ,TOUCHED>
		      <MAKE ,NATIVES ,INVISIBLE>
		      T)
		     (<==? .OBJ ,ADVENTURE>
		      <TELL "The Zalagasans seem completely uninterested in your adventure game. You may recall that this adventure received a devastating review in \"The Zalagasan PC Magazine\"." CR>)>)>)>>

<DEFINE NATIVES-SHOW-YOU (OBJ)
	 <COND (<EQUAL? .OBJ ,ME ,NATIVES>
		<PUZZLED ,NATIVES>
		T)
	       (<IN? .OBJ ,NATIVES>
		<TELL "\"Here. Take a look,\" they reply." CR>
		T)
	       (T
		<TELL "They don't have " A .OBJ "." CR>
		T)>>

<DEFINE ASK-NATIVES-FOR (OBJ)
	<COND (<EQUAL? .OBJ ,ME ,NATIVES>
	       <PUZZLED ,NATIVES>)
	      (T
	       <TELL CTHE ,NATIVES " chant \"We can't ">
	       <COND (<VERB? ASK-FOR>
		      <TELL "give">)
		     (T
		      <ZPRINTB ,P-PRSA-WORD>)>
	       <TELL " you that!\"" CR>)>
	 T>

<DEFINE ASK-NATIVES-ABOUT (OBJ)
	<COND (<EQUAL? .OBJ ,IN-POT ,NATIVES>
	       <TELL "One of the Zalagasans says, \"We aren't actually cannibals. Our society is in fact quite technologically advanced. We have been trying to get " ITAL "The National Geographic" " to do an article about us to help us increase tourism. Unfortunately, technologically advanced Zalagasans aren't very interesting. Twentieth century cannibalism is still a fairly hot item, though, so we've been cooking missionaries, explorers and mercenaries to impress " ITAL "The National Geographic" ".\"" CR>
	       T)
	      (<==? .OBJ ,ME>
	       <TELL CTHE ,NATIVES " note that you are far from well done." CR>
	       T)
	      (<==? .OBJ ,NERD>
	       <TELL CTHE ,NATIVES " collectively shrug. \"He seems to hang
around here a lot,\" one of them says." CR>)
	      (<==? .OBJ ,COMPUTER>
	       <TELL CTHE ,NATIVES " shrug it off; they're apparently quite used to it." CR>)
	      (ELSE
	       <TELL CTHE ,NATIVES " ignore you." CR>)>>



<OBJECT IN-CLEARING
	(LOC ROOMS)
	(DESC "grubby antechamber")
	(FLAGS LIGHTED LOCATION INDOORS)
	(WEST TO CARD-ROOM IF ODD-GATE IS OPEN)
	(IN TO CARD-ROOM IF ODD-GATE IS OPEN)
	(EAST TO MAZE-ROOM)
	(ACTION IN-CLEARING-F)>

<DEFINE IN-CLEARING-F ("OPT" (CONTEXT <>))
  <COND (<==? .CONTEXT ,M-LOOK>
	 <TELL "You're in a foul, unkempt antechamber which smells strongly of old socks.
There's a">
	 <OPEN-CLOSED ,ODD-GATE>
	 <TELL " in the west wall, and an exit to the east. It's not at
all clear how you managed to end up here; there's no trace of whatever
entrance you used." CR>)
	(T <>)>>

<SETG ODD-GATE-SOLVED? <>>

<OBJECT ODD-GATE-SIGN
	(LOC ODD-GATE)
	(FLAGS NODESC READABLE)
	(DESC "sign")
	(SYNONYM SIGN)
	(ACTION ODD-GATE-SIGN-F)>

<DEFINE ODD-GATE-SIGN-F ()
  <COND (<THIS-PRSO?>
	 <COND (<MOVING?>
		<TELL CTHEO " is irrevocably attached to the door." CR>)
	       (<VERB? EXAMINE LOOK-ON READ>
		<TELL CTHEO " contains the rather arcane text:|
010|
100|
001|
111|
and nothing else. You wonder why it doesn't just say Locker 2417." CR>)>)>>

<OBJECT ODD-GATE
	(LOC IN-CLEARING)
	(DESC "locker door")
	(FLAGS NODESC DOORLIKE OPENABLE VOWEL SURFACE LOCKED)
	(SYNONYM DOOR)
	(ADJECTIVE CLOSED SHUT ODD CURIOUS ODD-LOOKING LOCKER)
	(ACTION ODD-GATE-F)>

<DEFINE SAY-HANDLE-STATE (HANDLE)
  <TELL CTHE .HANDLE " is pointing ">
  <COND (<F? <GETB ,HANDLE-STATE <GETP .HANDLE ,P?HANDLE-NUMBER>>>
	 <TELL "up">)
	(T
	 <TELL "down">)>
  <TELL ".">>

<DEFINE ODD-GATE-F ("OPT" (CONTEXT <>))
  <COND (<==? .CONTEXT ,M-OBJDESC>
	 <COND (<HERE? CARD-ROOM>
		<TELL "This side of the locker door is completely featureless.">)
	       (T
		<TELL
		 "There are three handles on the door, arranged in a row. ">
		<SAY-HANDLE-STATE ,LEFT-HANDLE>
		<TELL " ">
		<SAY-HANDLE-STATE ,MIDDLE-HANDLE>
		<TELL " ">
		<SAY-HANDLE-STATE ,RIGHT-HANDLE>
		<TELL " There's also a sign attached to the door.">)>)
	(<T? .CONTEXT> <>)
	(<THIS-PRSO?>
	 <COND (<VERB? OPEN>
		<COND (<HERE? CARD-ROOM> <>)
		      (<NOT <IS? ,ODD-GATE ,LOCKED>>
		       <MAKE ,PRSO ,OPENED>
		       <TELL CTHEO " swings open." CR>
		       <COND (<F? ,ODD-GATE-SOLVED?> <UPDATE-SCORE 1 <>>)>
		       <SETG ODD-GATE-SOLVED? ,HERE>
		       T)>)
	       (<VERB? CLOSE>
		<UNMAKE ,ODD-GATE ,OPENED>
		<MAKE ,ODD-GATE ,LOCKED>
		<TELL CTHEO " swings shut, making no sound until you hear it
latching.">
		<COND (<NOT <HERE? CARD-ROOM>>
		       <TELL " The handles swing back to their original positions." CR>
		       <RESET-GATE-STATE>)
		      (T
		       <TELL " After an extended search, you discover that there's no way out of this room, and die of ennui.">
		       <JIGS-UP>)>)
	       (<VERB? EXAMINE>
		<TELL "The door is ">
		<COND (<IS? ,ODD-GATE ,OPENED>
		       <TELL "open">)
		      (T
		       <TELL "closed">)>
		<TELL ". ">
		<ODD-GATE-F ,M-OBJDESC>
		<ZCRLF>)
	       (<VERB? TAKE>
		<TELL "It seems to be firmly attached to something, and is in
any case quite heavy." CR>)
	       (<ENTERING?>
		<COND (<HERE? CARD-ROOM>
		       <DO-WALK ,P?OUT>)
		      (T
		       <DO-WALK ,P?WEST>)>
		T)
	       (<HURTING?>
		<TELL CTHEO " was apparently designed to withstand far stronger
attackers than you." CR>)>)
	(T <>)>>

<OBJECT LEFT-HANDLE
	(DESC "left handle")
	(LOC ODD-GATE)
	(FLAGS NODESC TRYTAKE)
	(SYNONYM HANDLE KNOB ARM HANDLES)
	(ADJECTIVE LEFT FIRST)
	(GENERIC GENERIC-HANDLE-F)
	(HANDLE-NUMBER 0)
	(ACTION HANDLE-F)>

<OBJECT MIDDLE-HANDLE
	(DESC "middle handle")
	(LOC ODD-GATE)
	(FLAGS NODESC TRYTAKE)
	(SYNONYM HANDLE KNOB ARM HANDLES)
	(ADJECTIVE MIDDLE SECOND CENTER CENTRE)
	(GENERIC GENERIC-HANDLE-F)
	(HANDLE-NUMBER 1)
	(ACTION HANDLE-F)>

<OBJECT RIGHT-HANDLE
	(DESC "right handle")
	(LOC ODD-GATE)
	(FLAGS NODESC TRYTAKE)
	(SYNONYM HANDLE KNOB ARM HANDLES)
	(ADJECTIVE RIGHT THIRD LAST)
	(GENERIC GENERIC-HANDLE-F)
	(HANDLE-NUMBER 2)
	(ACTION HANDLE-F)>

<CONSTANT ALL-HANDLES <PTABLE LEFT-HANDLE MIDDLE-HANDLE RIGHT-HANDLE>>

<MSETG HANDLE-COUNT 3>

<CONSTANT HANDLE-STATE <TABLE (BYTE) 0 1 0>>
<SETG HANDLE-TURNS 0>

<DEFINE SWITCH-STATE (HANDLE "AUX" (N <GETP .HANDLE ,P?HANDLE-NUMBER>)
		      (VAL 0))
  <COND (<F? <GETB ,HANDLE-STATE .N>>
	 <SET VAL 1>)>
  <PUTB ,HANDLE-STATE .N .VAL>
  <TELL CTHE .HANDLE " is now pointing ">
  <COND (<F? .VAL> <TELL "up">)
	(T <TELL "down">)>
  <TELL ,PERIOD>>

<DEFINE CHECK-MOVE CHECK (H1 H2 "AUX" (HS ,HANDLE-STATE) TMP)
  <COND (<L? ,HANDLE-TURNS 0>
	 ; "Losing"
	 <COND (<AND <F? <GETB .HS 0>>
		     <T? <GETB .HS 1>>
		     <F? <GETB .HS 0>>>
		; "Back in initial state"
		<SETG HANDLE-TURNS 0>
		T)
	       (T <>)>)
	(T
	 <COND (<L? <GETP .H2 ,P?HANDLE-NUMBER>
		    <GETP .H1 ,P?HANDLE-NUMBER>>
		<SET TMP .H1>
		<SET H1 .H2>
		<SET H2 .TMP>)>
	 <SETG HANDLE-TURNS <+ ,HANDLE-TURNS 1>>
	 <COND (<==? ,HANDLE-TURNS 1>
		<COND (<AND <==? .H1 ,LEFT-HANDLE>
			    <==? .H2 ,MIDDLE-HANDLE>>
		       T)
		      (<AND <==? .H1 ,MIDDLE-HANDLE>
			    <==? .H2 ,RIGHT-HANDLE>>
		       T)
		      (T <>)>)
	       (<==? ,HANDLE-TURNS 2>
		<COND (<AND <==? .H1 ,LEFT-HANDLE>
			    <==? .H2 ,RIGHT-HANDLE>>
		       T)
		      (T <>)>)
	       (<==? ,HANDLE-TURNS 3>
		<COND (<AND <T? <GETB .HS 0>>
			    <T? <GETB .HS 1>>
			    <T? <GETB .HS 2>>>
		       T)
		      (T <>)>)>)>>

<DEFINE GENERIC-HANDLE-F (TBL)
  <COND (<NOUN-USED? ,W?HANDLES>
	 <COND (<==? <ZGET .TBL 0> ,HANDLE-COUNT>
		,LEFT-HANDLE)
	       (T <>)>)
	(<INTBL? ,P-IT-OBJECT ,ALL-HANDLES ,HANDLE-COUNT>
	 ,P-IT-OBJECT)
	(T <>)>>

<DEFINE HANDLE-F HANDLE ("AUX" H1 H2)
  <COND (<AND <F? ,OBJECTS-GROUPED>
	      <F? ,P-MULT?>
	      <THIS-PRSO?>
	      <NOUN-USED? ,W?HANDLES>>
	 ; "TURN HANDLES BECOMES TURN ALL HANDLES"
	 <ZPUT ,P-PRSO 0 3>
	 <ZPUT ,P-PRSO 1 ,LEFT-HANDLE>
	 <ZPUT ,P-PRSO 2 ,MIDDLE-HANDLE>
	 <ZPUT ,P-PRSO 3 ,RIGHT-HANDLE>
	 <SETG OBJECTS-GROUPED T>)>
  <COND (<VERB? REFUSE>
	 <TELL "Make it easy on yourself, and just 'turn left handle' or
whatever." CR>)
	(<VERB? TURN MOVE>
	 <COND (<T? ,OBJECTS-GROUPED>
		; "TURNING ONE OR TWO HANDLES"
		<COND (<==? <ZGET ,P-PRSO 0> 2>
		       <SWITCH-STATE <SET H1 <ZGET ,P-PRSO 1>>>
		       <SWITCH-STATE <SET H2 <ZGET ,P-PRSO 2>>>
		       <COND (<F? <CHECK-MOVE .H1 .H2>>
			      <SETG HANDLE-TURNS -1>
			      <TELL "Although the handles turn, you don't hear anything." CR>)
			     (<==? ,HANDLE-TURNS 3>
			      <UNMAKE ,ODD-GATE ,LOCKED>
			      <TELL "You hear a sharp click, as if something
inside the door had moved." CR>)
			     (T
			      <TELL "You hear a click inside the door." CR>)>
		       <RETURN T .HANDLE>)
		      (<==? <ZGET ,P-PRSO 0> 3>
		       <TELL "You'll have to file Form 897/3/A, Application for
Attachment of Third Arm, before you can do that." CR>
		       <RETURN T .HANDLE>)>)>
	 <TELL "All of the handles wiggle a little, but none of them turns."
	       CR>
	 T)
	(<VERB? PULL PUSH>
	 <TELL "These handles seem more as if they're meant to be turned." CR>)
	(<VERB? TAKE>
	 <TELL "All the handles are firmly attached." CR>)
	(<AND <T? ,OBJECTS-GROUPED>
	      <THIS-PRSO?>>
	 ; "ALL PREVIOUS RESPONSES PLAUSIBLE FOR MORE THAN ONE; NOW
	    CAUSE DEFAULTS TO BE APPLIED TO EACH IN TURN"
	 <MAIN-LOOP T>
	 T)
	(<VERB? EXAMINE>
	 <SAY-HANDLE-STATE ,PRSO>
	 <ZCRLF>)>>

<DEFINE RESET-GATE-STATE ()
  <SETG HANDLE-TURNS 0>
  <PUTB ,HANDLE-STATE 0 0>
  <PUTB ,HANDLE-STATE 1 1>
  <PUTB ,HANDLE-STATE 2 0>>



<OBJECT CARD-ROOM
	(LOC ROOMS)
	(DESC "locker")
	(FLAGS LIGHTED LOCATION INDOORS)
	(EAST PER EXIT-CARD-ROOM)
	(OUT PER EXIT-CARD-ROOM)
	(GLOBAL ODD-GATE)
	(ACTION CARD-ROOM-F)>

<DEFINE EXIT-CARD-ROOM ()
  <COND (<IS? ,ODD-GATE ,OPENED>
	 ,ODD-GATE-SOLVED?)
	(T
	 <TELL CTHE ,ODD-GATE " is closed." CR>
	 <>)>>

<DEFINE CARD-ROOM-F ("OPT" (CONTEXT <>))
  <COND (<==? .CONTEXT ,M-LOOK>
	 <TELL "You're in a large locker. The exit is a">
	 <OPEN-CLOSED ,ODD-GATE>
	 <TELL " to the east." CR>)
	(<==? .CONTEXT ,M-ENTERING>
	 <MAKE ,LEFT-HANDLE ,INVISIBLE>
	 <MAKE ,RIGHT-HANDLE ,INVISIBLE>
	 <MAKE ,MIDDLE-HANDLE ,INVISIBLE>
	 <>)
	(<==? .CONTEXT ,M-EXIT>
	 <UNMAKE ,LEFT-HANDLE ,INVISIBLE>
	 <UNMAKE ,MIDDLE-HANDLE ,INVISIBLE>
	 <UNMAKE ,RIGHT-HANDLE ,INVISIBLE>
	 <>)
	(T <>)>>

<OBJECT KEY
	(LOC CARD-ROOM)
	(DESC "magnetic key-card")
	(FLAGS TAKEABLE READABLE)
	(SYNONYM CARD KEY KEYCARD KEY-CARD)
	(ADJECTIVE MAGNETIC PLASTIC KEY)
	(FDESC "There's a magnetic key-card on the floor.")
	(SIZE 1)
	(ACTION KEY-F)>

<DEFINE KEY-F ()
  <COND (<VERB? EXAMINE READ>
	 <TELL "It's a standard sort of plastic key-card with a magnetic stripe. It's embossed with the letters \"R.Q.H.\""
	       CR>)>>

<OBJECT RANDOM-CARTRIDGE
	(DESC "unlabelled cartridge")
	(FLAGS TAKEABLE PROGRAM VOWEL)
	(SIZE 2)
	(GENERIC GENERIC-SOFTWARE-F)
	(LDESC "This cartridge has obviously seen considerable use. Whatever
label it had on it is long gone and hard to find.")
	(SYNONYM CARTRIDGE CART CARTS ROM PROGRAM SOFTWARE)
	(ADJECTIVE UNLABELLED UNLABELED PROGRAM ROM SOFTWARE UNLABELED)
	(ACTION RANDOM-CARTRIDGE-F)>

<DEFINE RANDOM-CARTRIDGE-F ()
  <COND (<THIS-PRSO?>
	 <HANDLE-ROM?>)
	(T <>)>>

<CONSTANT A-DIR <DIR-ENTRY PROG-SECOND "PRINTB" <> IMPURE>>
<CONSTANT B-DIR <DIR-ENTRY PROG-FOURTH "PRINTC" <> IMPURE>>
<CONSTANT C-DIR <DIR-ENTRY PROG-FIRST "PRINTD" <> IMPURE>>
<CONSTANT D-DIR <DIR-ENTRY PROG-THIRD "PRINTE" <> IMPURE>>

<CONSTANT PRINTR-TABLE <PTABLE A-DIR B-DIR C-DIR D-DIR>>
<CONSTANT RPRINTR-TABLE <PTABLE PROG-FIRST PROG-SECOND PROG-THIRD PROG-FOURTH>>

<CONSTANT RANDOM-CARTRIDGE-TABLE
	  <PLTABLE HELP-DIR QUIT-DIR DIR-DIR CLEAR-DIR HACK-DIR
		   A-DIR B-DIR C-DIR D-DIR>>
