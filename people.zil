
"PEOPLE for BUREAUCRACY: Copyright 1987 Infocom, Inc. All rights reserved."

<FILE-FLAGS MDL-ZIL?>

<INCLUDE "OLD-PARSERDEFS" "XXJETDEFS">

<MSETG BURGER-TYPE 0>

<OBJECT LLAMA
	(LOC LLAMA-PEN)
	(DESC "llama")
	(FLAGS LIVING PERSON FEMALE NODESC)
	(SYNONYM LLAMA BEAST ANIMAL)
	(ACTION LLAMA-F)>

"TOUCHED = eating."

<DEFINE CANT-TALK-TO-LLAMAS ()
  <TELL "Since you spend most of your life talking to programmers, talking to llamas may not seem strange to you. To the rest of us, it is deeply weird." CR>>

<DEFINE LLAMA-F ("OPTIONAL" (CONTEXT <>) STR)
	 <SETG P-IT-OBJECT ,LLAMA>
	 <MAKE ,LLAMA ,SEEN>
	 <COND (<==? .CONTEXT ,M-WINNER>
		<TELL CTHE ,LLAMA " emits a hoarse bleat like a wet oboe
, but has no idea what you mean." CR>
		,FATAL-VALUE)
	       (<T? .CONTEXT> <>)
	       (<VERB? EXAMINE>
		<TELL "You see nothing unusual about the llama. Except, of course, that it's there. That ">
		<ITALICIZE "is">
		<TELL " slightly unusual, admittedly. But apart from the fact that it's there, you see nothing unusual about it. Nothing at all. It's just a llama." CR>)
	       (<VERB? ASK-ABOUT ASK-FOR>
		<CANT-TALK-TO-LLAMAS>
		T)
	       (<VERB? TELL>
		<SET STR <CHECK-OZ-ROYALTY ,LLAMA T>>
		<COND (.STR
		       <TELL "It seems to you that the llama, in a voice curiously like a wet oboe, says \"" .STR "\" You begin to seriously doubt your sanity." CR>)
		      (ELSE
		       <CANT-TALK-TO-LLAMAS>)>
		<PCLEAR>
		,FATAL-VALUE)
	       (<VERB? SHOW>
		<COND (<PRSO? BAG TREATS>
		       <TELL CTHEI " is deeply excited and also deeply hostile, a state of affairs all too familiar to you." CR>)
		      (ELSE
		       <>)>)
	       (<TOUCHING?>
		<LLAMA-LICKS-YOU>
		T)
	       (ELSE <>)>>

"*** CLERK ***"

<OBJECT CLERK
	(LOC BSTORE)
	(DESC "clerk")
	(FLAGS LIVING PERSON)
	(SYNONYM CLERK SALESCLERK SALESMAN MAN GUY FELLOW)
	(ADJECTIVE SALES)
	(DESCFCN CLERK-F)
	(CONTFCN CLERK-F)
	(ACTION CLERK-F)>

"TOUCHED = just referenced, SEEN = you've left store once."

<DEFINE CLERK-F CF ("OPTIONAL" (CONTEXT <>))
	 <MAKE ,CLERK ,TOUCHED>
	 <COND (<EQUAL? .CONTEXT ,M-OBJDESC>
		<TELL 
"A sales clerk is standing by a computerised cash register">
		<COND (<FIRST? ,CLERK>
		       <TELL ", holding ">
		       <PRINT-CONTENTS ,CLERK>)>
		<TELL
". The wall behind him offers a selection of computer software.">
		T)
	       (<EQUAL? .CONTEXT ,M-CONT>
		<COND (<TOUCHING?>
		       <MAKE ,CLERK ,TOUCHED>
		       <TELL CTHE ,CLERK
" draws away from you. \"Not so fast!\" he snaps." CR>
		       T)
		      (T
		       <>)>)
	       (<EQUAL? .CONTEXT ,M-WINNER>
		<COND (<VERB? TAKE> <GIVE-TO-CLERK T>)
		      (<VERB? EXAMINE LOOK-ON> <GIVE-TO-CLERK <>>)
		      (<VERB? WHAT>
		       <ASK-CLERK-ABOUT ,PRSO>)
		      (<PRSO? ME>
		       <COND (<VERB? TELL-ABOUT>
			      <ASK-CLERK-ABOUT ,PRSI>)
			     (<VERB? SSHOW>
			      <CLERK-SHOWS-YOU ,PRSI>)
			     (<VERB? SGIVE SSELL>
			      <ASK-CLERK-FOR ,PRSI>)
			     (T
			      <IGNORES ,CLERK>)>)
		      (<PRSI? ME>
		       <COND (<VERB? SHOW>
			      <CLERK-SHOWS-YOU ,PRSO>)
			     (<VERB? GIVE SELL>
			      <ASK-CLERK-FOR ,PRSO>)
			     (<VERB? HELLO>
			      <RETURN <> .CF>)
			     (T
			      <IGNORES ,CLERK>)>)
		      (<VERB? HELLO>
		       <TELL CTHE ,CLERK " nods hello again." CR>
		       T)
		      (<VERB? STINGLAI>
		       <RETURN <> .CF>)
		      (T
		       <IGNORES ,CLERK>)>
		,FATAL-VALUE)
	       (<T? .CONTEXT>
		<>)
	       (<THIS-PRSI?>
		<COND (<VERB? GIVE>
		       <GIVE-TO-CLERK T>)
		      (<VERB? SHOW>
		       <GIVE-TO-CLERK <>>)
		      (T
		       <>)>)
	       (<VERB? TELL>
		<>)
	       (<VERB? ASK-ABOUT>
		<ASK-CLERK-ABOUT ,PRSI>)
	       (<VERB? ASK-FOR>
		<ASK-CLERK-FOR ,PRSI>)
	       (<VERB? EXAMINE>
		<TELL "Beneath the jersey-knit polyester leisurewear, you detect a hint of nerdliness">
		<COND (<FIRST? ,PRSO>
		       <TELL ". He is holding ">
		       <PRINT-CONTENTS ,PRSO>)>
		<ZPRINT ,PERIOD>		       
		T)
	       (T
		<>)>>

<SETG TURNED-DOWN-CLERK? <>>

<DEFINE GIVE-TO-CLERK (GIVE-OR-SHOW "AUX" (OBJ ,PRSO))
	<COND (<==? .OBJ ,LEAFLET>
	       <TELL CTHE ,CLERK " glances at " THEO ". \"That's not in stock
yet. Come back next week.\"" CR>)
	      (<NOT <IS? ,SOFTWARE ,TOUCHED>>
	       <COND (<==? .OBJ ,ADVENTURE>
		      <COND (.GIVE-OR-SHOW
			     <TELL CTHE ,CLERK
				   " takes " THE ,ADVENTURE
				   ", looks at it lovingly and gives it back to you. ">)
			    (ELSE
			     <TELL CTHE ,CLERK " looks lovingly at "
				   THE ,ADVENTURE ". ">)>
		      <MAKE ,SOFTWARE ,TOUCHED>
		      <SEEN-SOFTWARE? <>>)
		     (<IS? .OBJ ,PROGRAM>
		      <TELL CTHE ,CLERK>
		      <COND (.GIVE-OR-SHOW <TELL " refuses your offer.">)
			    (ELSE <TELL " seems uninterested.">)>
		      <TELL " \"Typical of the junk on the market,\" he sneers."
			    CR>
		      T)
		     (.GIVE-OR-SHOW
		      <TELL CTHE ,CLERK " refuses your offer." CR>)
		     (T
		      <TELL CTHE ,CLERK " doesn't seem interested." CR>)>)
	      (ELSE
	       <COND (<==? .OBJ ,ADVENTURE>
		      <COND (.GIVE-OR-SHOW
			     <TELL CTHE ,CLERK
				   " takes " THE ,ADVENTURE
				   " from you. ">)
			    (ELSE
			     <TELL CTHE ,CLERK " yanks " THE ,ADVENTURE
				   " out of your hands. ">)>
		      <MAKE ,SOFTWARE ,SEEN>
		      <MOVE .OBJ ,CLERK>
		      <MOVE ,RECIPE ,PLAYER>
		      <GOT-RECIPE? T>
		      <DEQUEUE I-CLERK-TRADE>
		      <MAKE ,RECIPE ,SEEN>
		      <COND (<IS? ,SOFTWARE ,SEEN>
			     <TELL "\"I ">
			     <ITALICIZE "knew">
			     <COND (,TURNED-DOWN-CLERK?
				    <TELL " you'd change your mind. I can
always tell">)
				   (T
				    <TELL
				     " you were into that stuff">)>
			     <TELL ",\" he chortles. ">)>
		      <TELL "He tosses you " THE ,RECIPE
			    ". \"Here, have fun.\"" CR>
		      <UPDATE-SCORE 1>
		      T)
		     (<IS? .OBJ ,PROGRAM>
		      <TELL CTHE ,CLERK
			    " glances at " THE .OBJ
			    ". \"I already have that one.\""
			    CR>
		      T)
		     (<EQUAL? .OBJ ,BEEZER ,EXCESS>
		      <TELL
		       "\"Are you crazy? This cart is hot!\""
		       CR>)
		     (<==? .OBJ ,CHECK>
		      <TELL "\"I can't do anything with that!\"" CR>)
		     (ELSE
		      <TELL CTHE ,CLERK " refuses your offer." CR>)>)>>

<DEFINE CLERK-SHOWS-YOU (OBJ)
	 <COND (<EQUAL? .OBJ ,ME ,CLERK>
		<PUZZLED ,CLERK>
		T)
	       (<IN? .OBJ ,CLERK>
		<TELL "\"Here. Take a look,\" he replies." CR>
		T)
	       (T
		<TELL CTHE ,CLERK " waves at " THE .OBJ
		      ". \"Feel free to look ">
		<COND (<IS? .OBJ ,PLURAL>
		       <TELL "them">)
		      (T
		       <TELL "it">)>
		<TELL " over yourself.\"" CR>
		T)>>
	       
<DEFINE ASK-CLERK-FOR (OBJ)
	 <COND (<EQUAL? .OBJ ,ME ,CLERK>
		<PUZZLED ,CLERK>)
	       (<IN? .OBJ ,CLERK>
		<TELL CTHE ,CLERK " grins slyly at your demand." CR>)
	       (<EQUAL? .OBJ ,CUTOUTS ,BESTSELLERS ,SOFTWARE>
		<TELL "\"I'll sell you anything you want.\"" CR>)
	       (T
		<TELL CTHE ,CLERK " snorts. \"I can't ">
		<COND (<VERB? ASK-FOR>
		       <TELL "give">)
		      (T
		       <ZPRINTB ,P-PRSA-WORD>)>
		<TELL " you that!\"" CR>)>
	 T>	 

<CONSTANT CLERK-SUBJECTS
	<PLTABLE
	 <PTABLE BSTORE "The manager's bughouse, the women are dogs, the men are hogs and the customers are half-baked. Other than that, it's a great place.">
	 <PTABLE CUTOUTS "That stuff? Cheap at half the price.">
	 <PTABLE BESTSELLERS "Do you know how much money those guys make? Disgusting.">
	 <PTABLE REGISTER "Fouled up beyond all recognition.">
	 <PTABLE CLERK "Started last week. Seems like a year.">
	 <PTABLE WRISTWATCH "I had one like yours, but a llama ate it.">
	 <PTABLE ECLIPSE "Pretty tame stuff, though it might impress someone who'd never seen a computer.">
	 <PTABLE ADVENTURE "'Dork I'? One of the classics!">
	 <PTABLE COMPUTER "It's got what I like in a computer: it's named after a berry. That's what I look for. A really purple berry, too. Great.">
	 <PTABLE QUEEN-MUM "I...I don't know whom you're talking about.">
	 <PTABLE NERD "That pallid little creep? There's something weird about him. He should be locked away.">>>

<DEFINE ASK-CLERK-ABOUT (OBJ)
	 <COND (<EQUAL? .OBJ ,SOFTWARE>
		<SEEN-SOFTWARE? <>> ; "No CR.")
	       (<AND <EQUAL? .OBJ ,RECIPE>
		     <VISIBLE? .OBJ>>		     
		<DESCRIBE-RECIPE>
		<COND (<G? ,CLERK-SCRIPT 1>
		       <SETG CLERK-SCRIPT 1>)>)
	       (T
		<ASK-CHAR-ABOUT ,CLERK .OBJ ,CLERK-SUBJECTS ,CLERK-TOLD>)>
	 T>

"*** WAITRESS ***"

<OBJECT WAITRESS
	(DESC "waitress")
	(FLAGS LIVING PERSON FEMALE)
	(SYNONYM WAITRESS WAITPERSON LADY WOMAN)
	(ADJECTIVE HARRIED)
	(DESCFCN WAITRESS-F)
	(ACTION WAITRESS-F)>

"SEEN = seen once."
	 
<DEFINE WAITRESS-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-OBJDESC>
		<SETG P-HER-OBJECT ,WAITRESS>
		<COND (<HERE? DINER>
		       <TELL "A harried-looking " D ,WAITRESS 
			     " is here to take your order.">
		       T)
		      (T
		       <ZREMOVE ,WAITRESS>
		       <TELL CTHE ,WAITRESS " you met in " THE ,DINER
" is standing nearby. Beside her is a mysterious-looking man in Deep Thought Corporation coveralls, whispering into a walkie-talkie that's ">
		       <SHOW-FIELD ,LEAST-FAVORITE-COLOR>
		       <TELL " in colour.|
|
The two freeze at the sight of you. \"It's ">
		       <GENDER-PRINT "him" "her">
		       <TELL "!\" hisses " THE ,WAITRESS 
". Before you can speak or move, they slink around a corner and disappear.">
		       T)>)
	       (<AND <EQUAL? .CONTEXT ,M-WINNER> <NOT <HERE? IN-COMPLEX>>>
		<IGNORES ,WAITRESS>
		,FATAL-VALUE)
	       (<T? .CONTEXT>
		<>)
	       ;(<THIS-PRSI?>
		<>)
	       (<VERB? TELL>
		<>)
	       (T
		<>)>>

"*** WAITER ***"

<OBJECT WAITER
	(DESC "waiter")
	(FLAGS LIVING PERSON)
	(SYNONYM WAITER WAITPERSON MAN GUY FELLOW)
	(ADJECTIVE SURLY)
	(DESCFCN WAITER-F)
	(ACTION WAITER-F)>
	 
<DEFINE WAITER-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-OBJDESC>
		<TELL "A surly and colossally muscular waiter, like the sort of person who kicks entire " ITAL "beaches" " in people's faces, is here">
		<TELL " to take your ">
		<COND (<==? ,MEAL-STATE ,MS-RECEIVED-FOOD>
		       <TELL "money.">)
		      (T
		       <TELL "order.">)>)
	       (<EQUAL? .CONTEXT ,M-WINNER>
		<COND (<HERE? IN-COMPLEX> <>)
		      (<VERB? STINGLAI> <>)
		      (ELSE
		       <IGNORES ,WAITER>
		       ,FATAL-VALUE)>)
	       (<VERB? TELL>
		<>)
	       (<VERB? GIVE SHOW>
		<COND (<==? ,PRSO ,BURGER>
		       <PERFORM ,V?RETURN ,PRSO>)
		      (<L? ,MEAL-STATE ,MS-ORDERED-FROM-WAITER>
		       <COND (<OR <EQUAL? ,PRSO ,BEEZER ,EXCESS ,MONEY>
				  <==? ,PRSO ,CHECK>>
			      <TELL CTHE ,WAITER
				    " says, \"Order first, pay later. Are you stupid or something?\"" CR>)
			     (ELSE
			      <>)>)
		      (<EQUAL? ,PRSO ,BEEZER>
		       <TELL CTHE ,WAITER " goes away for a little while. When he returns, he informs you that Beezer Inc. list you as over your credit limit. He awaits your next move with a smug expression on his hateful \"face\"." CR>)
		      (<==? ,PRSO ,EXCESS>
		       <TELL CTHE ,WAITER " looks at your US Excess card and throws it in your face: \"This is worthless; it's expired, and anyway I wouldn't accept it. I don't like the stupid yak hologram.\"" CR>)
		      (<==? ,PRSO ,CHECK>
		       <TELL CTHE ,WAITER " looks at you in disgust. \"We don't
take checks here. Especially not checks like ">
		       <ITALICIZE "that">
		       <TELL "\"." CR>
		       T)
		      (<EQUAL? ,PRSO ,MONEY>
		       <COND (<NOT ,P-DOLLAR-FLAG>
			      <SPECIFY-AN-AMOUNT>
			      <ZCRLF>
			      <SETG P-NUMBER 0>
			      <RTRUE>)
			     (<L? ,CASH 450>
			      <COND (<G=? ,P-NUMBER 450>
				     <TELL ,DONT "have that much!">)
				    (ELSE
				     <TELL "He won't accept less than $4.50!">)>
			      <SETG P-NUMBER 0>)
			     (<L? ,P-NUMBER 450>
			      <TELL CTHE ,WAITER " snaps, \"Look, I don't have all day; just pay the tab!\"">
			      <SETG P-NUMBER 0>)
			     (<==? ,P-NUMBER 450>
			      <TELL CTHE ,WAITER " seems quite displeased but takes your money anyway;">)
			     (<L? ,P-NUMBER 480>
		     	      <TELL CTHE ,WAITER " says, \"Keep your lousy tip, cheapskate,\" then">
			      <SETG P-NUMBER 450>)
			     (T
			      <TELL CTHE ,WAITER " grimaces. His lips writhe, his eyes bulge, and his \"face\" goes red with an almost superhuman effort. Finally, with a noise like a llama giving birth to a particularly large baby llama, he thanks you for your generosity and">
			      <COND (<N==? <ZGET ,MEAL ,BURGER-TYPE>
					   ,W?SPECIAL>
				     <TELL " recommends the \"special\" if you're ever there again, which you hope you're not">)
				    (ELSE
				     <TELL " compliments you on your choice of food">)>
			      <TELL ". Exhausted by his efforts,">)>
		       <REDUCE-CASH>
		       <COND (<N==? ,P-NUMBER 0>
			      <TELL " he leaves." CR>
			      <SETG MEAL-STATE ,MS-PAID-FOR-FOOD>
			      <ZREMOVE ,WAITER>
			      <DEQUEUE I-WAITER-ARRIVES>)
			     (T
			      <TELL ,PERIOD>)>
		       T)>)
	       (<VERB? ASK-FOR>
		<TELL CTHEO " shrugs. The muscles in his shoulders heave like a nest of slugs writhing in a sack. \"What you see is what you get.\"" CR>
		T)
	       (<HURTING?>
		<TELL "Oh no. Oh boy, no. Definitely not. You want to mess with
this guy, you're on your own. Count us out altogether." CR>)
	       (T
		<>)>>

"*** AGENT ***"

<OBJECT AGENT
	(LOC AGENCY)
	(DESC "travel agent")
	(FLAGS LIVING FEMALE PERSON NODESC)
	(SYNONYM AGENT WOMAN LADY)
	(ADJECTIVE TRAVEL)
	(CONTFCN AGENT-F)
	(ACTION AGENT-F)>

<CONSTANT AGENT-SUBJECTS
	<PLTABLE
	 <PTABLE AGENCY "Terrible. People coming in and out all the time, wanting to go places. I don't know why they can't just stay at home.">
	 <PTABLE AGENT "What's a nice girl like me doing in a place like this?">
	 <PTABLE WRISTWATCH "I knew a guy called Prosser who had one just like it.">
	 <PTABLE NERD "That unsavory little dink? Ask him what he knows about the optometrists.">
	 <PTABLE CALIFORNIA "Hey! Right! Cut-offs! Pink tofu, excuse me? Catching some rays! Steve Jobs! Right? Right! God's own country, you know? Right!">
	 <PTABLE OPTOMETRISTS "Oh, only 279 optometrists from Ohio who got routed to San Diego via Tibet, that's all. I know who I blame... that nerd, that's who.">
	 <PTABLE QUEEN-MUM "Who? You mean that sweet little old lady? What would I know about her?">>>

<OBJECT CALIFORNIA
	(LOC GLOBAL-OBJECTS)
	(FLAGS NOARTICLE)
	(SYNONYM CALIFORNIA)
	(DESC "California")>

<OBJECT OPTOMETRISTS
	(LOC GLOBAL-OBJECTS)
	(SYNONYM OPTOMETRISTS)
	(FLAGS PLURAL VOWEL)
	(DESC "optometrists")>

<DEFINE AGENT-F AGENT ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-CONT>
		<COND (<TOUCHING?>
		       <INVADING-SPACE>
		       T)
		      (T
		       <>)>)
	       (<EQUAL? .CONTEXT ,M-WINNER>
		<COND (<VERB? EXAMINE READ LOOK-ON>
		       <SHOW-AGENT-PRSO>)
		      (<VERB? TAKE>
		       <GIVE-AGENT-PRSO>)
		      (<VERB? WHAT>
		       <ASK-AGENT-ABOUT ,PRSO>)
		      (<PRSO? ME>
		       <COND (<VERB? TELL-ABOUT TELL-TIME>
			      <ASK-AGENT-ABOUT ,PRSI>)
			     (<VERB? SSHOW>
			      <AGENT-SHOWS-YOU ,PRSI>)
			     (<VERB? SGIVE SSELL>
			      <ASK-AGENT-FOR ,PRSI>)
			     (T
			      <IGNORES ,AGENT>)>)
		      (<PRSI? ME>
		       <COND (<VERB? SHOW>
			      <AGENT-SHOWS-YOU ,PRSO>)
			     (<VERB? GIVE SELL>
			      <ASK-AGENT-FOR ,PRSO>)
			     (T
			      <IGNORES ,AGENT>)>)
		      (<VERB? HELLO>
		       <TELL CTHE ,AGENT " nods, a bit sullenly." CR>)
		      (<AND <VERB? WHAT>
			    <PRSO? WRISTWATCH>
			    <PRSO-NOUN-USED? ,W?TIME>>
		       <ASK-CHAR-ABOUT ,AGENT
				       ,PRSO ,AGENT-SUBJECTS ,AGENT-TOLD
				       ASK-AGENT-ABOUT-RANDOM>)
		      (<VERB? STINGLAI>
		       <RETURN <> .AGENT>)
		      (T
		       <IGNORES ,AGENT>)>
		,FATAL-VALUE)
	       (<T? .CONTEXT>
		<>)
	       (<THIS-PRSI?>
		<COND (<VERB? GIVE>
		       <GIVE-AGENT-PRSO>
		       T)
		      (<VERB? SHOW>
		       <SHOW-AGENT-PRSO>
		       T)
		      (T
		       <>)>)
	       (<VERB? TELL>
		<>)
	       (<VERB? ASK-ABOUT>
		<ASK-AGENT-ABOUT ,PRSI>
		T)
	       (<VERB? ASK-FOR>
		<ASK-AGENT-FOR ,PRSI>
		T)
	       (<VERB? EXAMINE>
		<TELL "In a good light, with a following wind, she could look almost like a bank teller">
		<COND (<FIRST? ,PRSO>
		       <TELL ". She is holding ">
		       <PRINT-CONTENTS ,PRSO>)>
		<ZPRINT ,PERIOD>		       
		T)
	       (<TOUCHING?>
		<INVADING-SPACE>)
	       (T
		<>)>>
		
<DEFINE INVADING-SPACE ()
  <TELL "\"You're invading my personal space!\" shrieks "
	THE ,AGENT ", rearing back from you like an offended snake. She is probably from California." CR>
  T>

<DEFINE GIVE-AGENT-PRSO ()
	 <TELL CTHE ,AGENT>
	 <COND (<PRSO? VISA>
		<TELL " takes " THEO
		      ", glances at it and hands it back. \"">
		<HIDEOUS-VISA>
		T)
	       (<PRSO? LETTER>
		<MOVE ,LETTER ,AGENT>
		<MOVE ,TICKET ,AGENCY-DESK>
		<UNMAKE ,TICKET ,NODESC>
		<SETG P-IT-OBJECT ,TICKET>
		<TELL 
" takes the letter, glances at it, shrugs and tosses a ticket on the desk. \"There you go, right?\" she yawns. \"Like, uh, it's been real.\"" CR>
		<UPDATE-SCORE 1>
		T)
	       (T
		<TELL " glances at " THEO
" and shakes her head. \"I don't want that.\"" CR>
		T)>>

<DEFINE SHOW-AGENT-PRSO ()
	 <TELL CTHE ,AGENT " glances at " THEO ". \"">
	 <COND (<PRSO? VISA>
		<HIDEOUS-VISA>)
	       (<PRSO? LETTER>
		<TELL
		 "Like, you'll have to give me that to get your ticket, okay?\"" CR>)
	       (T
		<TELL "Oh man, uh, wow; you must be so proud.\"" CR>)>
	 T>	 

<DEFINE HIDEOUS-VISA ()
	 <TELL "Visa's fine, but, hey, what kind of ">
	 <ITALICIZE "happened">
	 <TELL " to your ">
	 <ITALICIZE "face">
	 <GENDER-PRINT ", buster" ", honey">
	 <TELL "?\"" CR>>

<DEFINE AGENT-SHOWS-YOU (OBJ)
	 <COND (<EQUAL? .OBJ ,ME ,AGENT>
		<PUZZLED ,AGENT>)
	       (<IN? .OBJ ,AGENT>
		<TELL "\"Look for yourself,\" she replies." CR>)
	       (T
		<TELL CTHE ,AGENT " shrugs. \"Look at ">
		<COND (<IS? .OBJ ,PLURAL>
		       <TELL "them">)
		      (T
		       <TELL "it">)>
		<TELL " yourself.\"" CR>)>
	 T>
	       
<DEFINE ASK-AGENT-FOR (OBJ)
	 <COND (<EQUAL? .OBJ ,ME ,AGENT>
		<PUZZLED ,AGENT>)
	       (<IN? .OBJ ,AGENT>
		<TELL CTHE ,AGENT " pulls " THE .OBJ " out of your reach." CR>)
	       (<==? .OBJ ,VISA>
		<TELL "\"I'm not authorized to issue visas and passports.\""
		      CR>)
	       (T
		<TELL CTHE ,AGENT " snorts, \"I can't ">
		<COND (<VERB? ASK-FOR>
		       <TELL "give">)
		      (T
		       <ZPRINTB ,P-PRSA-WORD>)>
		<TELL " you that!\"" CR>)>
	 T>	 

<DEFINE ASK-AGENT-ABOUT (OBJ)
	 <COND (<EQUAL? .OBJ ,REQUIREMENTS>
		<TELL "\"Hey, what do I know about visa requirements? People like put up these signs, they don't tell me anything, right? Some dumb regulation, I guess.\"" CR>)
	       (<EQUAL? .OBJ ,TICKET>
		<TELL "\"">
		<COND (<IS? ,TICKET ,NODESC>
		       <TELL "Got lots of tickets.\"" CR>)
		      (T
		       <TELL "Everything's right on the ticket.\"" CR>)>)
	       (T
		<ASK-CHAR-ABOUT ,AGENT .OBJ ,AGENT-SUBJECTS ,AGENT-TOLD
				ASK-AGENT-ABOUT-RANDOM>)>
	 T>
		
<DEFINE ASK-AGENT-ABOUT-RANDOM (CHAR OBJ)
  <TELL CTHE .CHAR " says, \""
	CTHE .OBJ "? Oh yes, " THE .OBJ "! Um... I can't tell you anything
about that.\"" CR>>

"*** MATRON ***"

<OBJECT MATRON
	(LOC TROPHY-ROOM)
	(DESC "matron")
	(FLAGS LIVING PERSON FEMALE)
	(SYNONYM MATRON WOMAN LADY)
	(ADJECTIVE OLD AGED DEAF)
	(CONTFCN MATRON-F)
	(DESCFCN MATRON-F)
	(ACTION MATRON-F)>

<BIT-SYNONYM SEEN ANSWERING-DOOR>

<DEFINE MATRON-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-OBJDESC>
		<TELL ;"A nightmarishly hideous old bimbo is "
		      "A dowdy matron is ">
		<COND (<IS? ,MATRON ,ANSWERING-DOOR>
		       <TELL "standing in the open doorway, holding "
			     A ,TRUMPET " and " A ,EGUN ".">
		       <COND (<HERE? TROPHY-ROOM>
			      <TELL 
" Luckily, she's facing away from you at the moment.">)>
		       T)
		      (T
		       <TELL "sitting beside the radio. Her ">
		       <COND (<QUEUED? ,I-ROBBERS>
			      <TELL D ,EGUN " is trained on your face.">)
			     (T
			      <TELL D ,TRUMPET 
" is pressed directly against the radio's speaker. She has " A ,EGUN " on her lap.">)>)>
		T)
	       (<EQUAL? .CONTEXT ,M-CONT>
		<COND (<TOUCHING?>
		       <COND (<F? <QUEUED? I-ROBBERS>>
			      <TELL CTHE ,MATRON " screams. \"Robbers!\" She
turns to face you, and raises " THE ,EGUN ,PERIOD>)>
		       <I-ROBBERS>
		       T)
		      (T
		       <>)>)
	       (<EQUAL? .CONTEXT ,M-WINNER>
		<TELL CTHE ,MATRON " is too deaf to hear anything you say, and too bigoted to understand it even if she could, which she can't." CR>
		,FATAL-VALUE)
	       (<T? .CONTEXT>
		<>)
	       (<VERB? SHOW ASK-ABOUT GIVE>
		<TELL CTHE ,MATRON " ignores your action." CR>)
	       (<THIS-PRSI?>
		<>)
	       (<VERB? TELL>
		<>)
	       (T
		<>)>>

<OBJECT PMATRON
	(LOC LOCAL-GLOBALS)
	(DESC "matron")
	(FLAGS NODESC PERSON LIVING FEMALE)
	(SYNONYM MATRON WOMAN LADY)
	(ADJECTIVE OLD AGED)
	(ACTION PMATRON-F)>

<DEFINE PMATRON-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<TOUCHING?>
		<CANT-FROM-HERE>
		T)
	       (<SEEING?>
		<CANT-SEE-MUCH>
		T)
	       (<THIS-PRSI?>
		<>)
	       (<VERB? TELL>
		<TELL CTHEO 
" doesn't respond. She probably can't hear you from where you're standing. Or possibly doesn't want to. Or maybe doesn't give a toss either way. You know how it is with dowdy old matrons. You do now, anyway." CR>
		T)
	       (T
		<>)>>

"*** MACAW ***"

<OBJECT MACAW
	(LOC PERCH)
	(DESC "macaw")
	(FLAGS TRYTAKE NOALL LIVING PERSON)
	(SYNONYM MACAW BIRD MERLIN)
	(ACTION MACAW-F)>

<DEFINE MACAW-RIGHT? ()
  <COND (<==? <ZGET ,MACAW-TABLE ,MACAW-POLITICS> ,MACAW-RIGHT> T)
	(T <>)>>

<DEFINE MACAW-F ("OPTIONAL" (CONTEXT <>))
	 <MAKE ,MACAW ,SEEN>
	 <COND (<EQUAL? .CONTEXT ,M-WINNER>
		<COND (<VERB? HELLO>
		       <TELL CTHE ,MACAW " squawks, \"Rats! A ">
		       <COND (<MACAW-RIGHT?>
			      <TELL "commie">)
			     (ELSE
			      <TELL "fascist">)>
		       <TELL "!\"" CR>)
		      (ELSE
		       <TELL CTHE ,MACAW " is not the sort of pointless bird that sits on a perch eating a squid-bone and singing occasionally. It eats whole squid. Live. And it doesn't sing. It snarls. In short, this bird does not take orders from anyone.
Especially a crypto-">
		       <COND (<MACAW-RIGHT?> <TELL "commie">)
			     (T <TELL "fascist">)>
		       <TELL " like you." CR>)>
		,FATAL-VALUE)
	       (<THIS-PRSI?>
		<COND (<VERB? PUT-UNDER>
		       <PERFORM ,PRSA ,PRSO ,PERCH>
		       T)
		      (<AND <VERB? GIVE> <NOT <PRSO? PAINTING>>>
		       <MAKE ,PRSI ,SEEN>
		       <TELL CTHEI>
		       <COND (<G? <GETP ,PRSO ,P?SIZE> 3>
			      <TELL " couldn't possibly take such ">
			      <COND (<NOT <IS? ,PRSO ,PLURAL>>
				     <TELL "a ">)>
			      <TELL "large " D ,PRSO ", even if it wanted ">
			      <COND (<IS? ,PRSO ,PLURAL>
				     <TELL "them">)
				    (T
				     <TELL "one">)>
			      <TELL ", which it doesn't." CR>
			      T)
			     (T
			      <MOVE ,PRSO ,HERE>
			      <TELL " snatches " THEO " and tosses ">
			      <COND (<IS? ,PRSO ,PLURAL>
				     <TELL "them">)
				    (T
				     <TELL "it">)>
			      <TELL " to the floor" ,PERIOD>
			      T)>)
		      (<AND <VERB? SHOW GIVE> <PRSO? PAINTING>>
		       <MAKE ,PRSI ,SEEN>
		       <COND (<IS? ,PRSO ,SHITTY>
			      <TELL CTHEI " is so unutterably bored by the remnants of the painting that it briefly contemplates singing a little song about how bored the remnants of the painting make it, and how much it would 
prefer the real thing. Recalling that (as a general rule) Tough Birds Don't Sing, it simply snarls instead." CR>)
			     (T
			      <TELL CTHEI " is clearly deeply moved by the sight of " THEO ", and starts shrieking a vigorous and relentless R&B number about the joys of political extremism. At the same time it launches into an energetic roach-stomping flamenco dance which miraculously generates enough aerodynamic lift to catapult it (somewhat asymmetrically) into the air, where it rips up ">
			      <COND (<MACAW-RIGHT?>
				     <TELL "Gorbachev">)
				    (T
				     <TELL "Reagan">)>
			      <TELL "'s face (which, to be honest, makes little real difference).|
|
Exhausted but happy, it sinks back to its perch, croons repulsively the first verse of a ballad about pecking the eyes out of oppressors of the ">
			      <COND (<MACAW-RIGHT?>
				     <TELL "Russian">)
				    (T
				     <TELL "American">)>

				<TELL " people, and falls into a satisfied coma." CR>
			      <MAKE ,PRSI ,SHITTY>
			      <MAKE ,PRSO ,SHITTY>)>
		       T)
		      (<VERB? SHOW>
		       <MAKE ,PRSI ,SEEN>
		       <TELL CTHEI " glances at " THEO
" and flirts with the notion of singing an eight-bar blues about being really not terribly interested in " THEO " which it remembers learning years ago as an egg." CR>
		       T)
		      (T
		       <>)>)
	       (<VERB? EXAMINE>
		<COND (<IS? ,MACAW ,SHITTY>
		       <TELL CTHE ,MACAW " stares blankly past you, wondering ">
			     <COND (<MACAW-RIGHT?>
				    <TELL "why there are no right-wing protest songs">)
				   (T
				    <TELL "what John Lennon was protesting about in \"Imagine\", and why">)>
			     <TELL ,PERIOD>)
		      (T
		       <TELL CTHE ,MACAW " stares back at you, then bellows, \"Nuke the whales! Nuke the whales!\"" CR>)>
		T)
	       (<VERB? WATCH>
		<I-MACAW <>>
		T)
	       (<VERB? LISTEN>
		<TELL CTHE ,MACAW
		      PNEXT <ZGET ,MACAW-TABLE ,MACAW-SOUNDS> ,PERIOD>
		T)
	       (<VERB? TELL>
		<>)
	       (<HURTING?>
		<TELL "Yes, well, let's try to be non-judgemental about this. On the one hand, hurting " THEO " would be really rewarding, but on the other hand Infocom retain a team of killer lawyers with pointed heads and squinty eyes who would take great pleasure in suing you till your pips squeaked for damaging their property." CR>
		T)
	       (<TOUCHING?>
		<TELL "Birds carry some pretty horrible diseases. This one carries some ">
		<ITALICIZE "really">
		<TELL " horrible ones. You decide you would rather be a ">
		<GENDER-PRINT "living, breathing nerd"
			      "victim of gender discrimination">
		<TELL " than a specimen in a bottle, and decide against it."
		      CR>)
	       (T
		<>)>>

"*** PHILATELIST ***"

<OBJECT MOUSY
	(LOC IN-FLAT)
	(DESC "mousy man")
	(FLAGS LIVING PERSON)
	(SYNONYM MAN GUY FELLOW MISTER COLLECTOR PHILATELIST)
	(ADJECTIVE MOUSY LITTLE)
	(DESCFCN MOUSY-F)
	(CONTFCN MOUSY-F)
	(ACTION MOUSY-F)>

<DEFINE MOUSY-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-CONT>
		<COND (<TOUCHING?>
		       <MAKE ,MOUSY ,SEEN>
		       <TELL 
"\"Don't touch!\" scolds the mousy man, twitching away from you." CR>
		       T)
		      (T
		       <>)>)
	       (T
		<MAKE ,MOUSY ,SEEN>
		<COND (<EQUAL? .CONTEXT ,M-OBJDESC>
		       <TELL 
		"A mousy little wimp of a fellow is sitting at a table, snipping envelopes into tiny pieces, burrowing through the shredded paper, tittering mousily and grabbing at the stamps with his mousy little hands. The floor is littered with snipped-up paper.">
		       T)
		      (<EQUAL? .CONTEXT ,M-WINNER>
		       <COND (<THIS-PRSI?>
			      T)
			     (<VERB? TAKE>
			      <COND (<PRSO? LEAFLET>
				     <MOUSY-GETS-LEAFLET>
				     T)>)
			     (<VERB? EXAMINE LOOK-ON READ>
			      <COND (<PRSO? LEAFLET>
				     <MOUSY-GETS-LEAFLET T>
				     ,FATAL-VALUE)>)
			     (<VERB? STINGLAI> <>)
			     (T
			      <TELL CTHE ,MOUSY
				    " sniggers mousily, but doesn't otherwise respond."
				    CR>
			      ,FATAL-VALUE)>)
		      (<T? .CONTEXT>
		       <>)
		      (<THIS-PRSI?>
		       <COND (<VERB? GIVE THROW>
			      <COND (<PRSO? LEAFLET>
				     <MOUSY-GETS-LEAFLET>)
				    (T
				     <MOUSY-GLANCES>
				     <TELL ". \"No, thanks,\" he squeaks, \"You keep it.\""
					   CR>)>
			      T)
			     (<VERB? SHOW>
			      <COND (<PRSO? LEAFLET>
				     <MOUSY-GETS-LEAFLET T>)
				    (T
				     <MOUSY-GLANCES>
				     <TELL ", but shows little interest." CR>)>
			      T)
			     (T
			      <>)>)
		      (<VERB? TELL>
		       <>)
		      (<VERB? ASK-ABOUT>
		       <TELL CTHEO " snickers distractedly, but is too preoccupied with his stamps to really pay attention." CR>)
		      (T
		       <>)>)>>

<DEFINE MOUSY-GLANCES ()
	 <MAKE ,MOUSY ,SEEN>
	 <TELL CTHE ,MOUSY " glances at " THEO>>

<DEFINE MOUSY-GETS-LEAFLET ("OPTIONAL" (SEE <>))
	 <LEAVE-MOUSY>
	 <ZREMOVE ,MOUSY>
	 <ZREMOVE ,LEAFLET>
	 <SETG P-IT-OBJECT ,NOT-HERE-OBJECT>
	 <TELL CTHE ,MOUSY "'s little black button eyes grow wide when he sees "
	       THE ,LEAFLET>
	 <UNMAKE ,MOUSYMAIL ,SEEN>
	 <PUTP ,MOUSYMAIL ,P?DESCFCN 0>
	 <COND (<IN? ,MOUSYMAIL ,MOUSY>
		<MOVE ,MOUSYMAIL ,IN-FLAT>
		<TELL "; the mail slips from his grasp">)>
	 <TELL ". \"I don't believe it,\" he whispers, ">
	 <COND (<T? .SEE>
		<TELL "snatching it away to fondle ">)
	       (T
		<TELL "fondling ">)>
	 <TELL "the stamp. \"The Zalagasa 42 Ai-Ai. First and rarest in the ">
	 <ITALICIZE "Almost Unbelievably Rare Little, Um, Well, Sort of Monkey-Type Animals of the Southern Hemisphere">
	 <TELL " Series!\"|
|
Whooping with glee, the little fellow skitters up and down and performs a series of handstands and cartwheels around his little apartment. Then he opens his pants, stuffs the precious leaflet into his underwear (of which the less said, the better), pulls on a coat and dashes out the door. \"Ai-Ai! The Ai-Ai!\" he shrieks all the way down the street." CR>
	 T>

"*** LLAMA MAN ***"

<OBJECT DMAN
	(DESC "delivery man")
	(FLAGS LIVING PERSON SEEN)
	(SYNONYM MAN GUY FELLOW)
	(ADJECTIVE DELIVERY YOUNG)
	(DESCFCN DMAN-F)
	(CONTFCN DMAN-F)
	(ACTION DMAN-F)>

<DEFINE DMAN-F DM ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-OBJDESC>
		<TELL "An offensively bright and cheery young " Q ,DMAN ", obviously one of those rats who gets up every morning feeling cheerful and loves his work, stands in the doorway">
		<COND (<FIRST? ,DMAN>
		       <TELL ", holding ">
		       <PRINT-CONTENTS ,DMAN>)>
		<TELL ".">
		T)
	       (<EQUAL? .CONTEXT ,M-CONT>
		<COND (<TOUCHING?>
		       <TELL "\"Don't touch the llama merchandise">
		       <LADY-OR-MISTER>
		       <TELL ",\" scolds " THE ,DMAN
			     ", backing away from you." CR>
		       T)
		      (T
		       <>)>)
	       (<EQUAL? .CONTEXT ,M-WINNER>
		<COND (<VERB? TAKE>
		       <GIVE-TO-DMAN>)
		      (<VERB? EXAMINE LOOK-ON READ>
		       <SHOW-TO-DMAN>)
		      (<OR <VERB? WHAT>
			   <AND <VERB? TELL-ABOUT>
				<PRSO? ME>>>
		       <BAD-DMAN-Q>)
		      (<VERB? STINGLAI> <RETURN <> .DM>)
		      (T
		       <IGNORES ,DMAN>)>
		,FATAL-VALUE)
	       (<T? .CONTEXT>
		<>)
	       (<VERB? EXAMINE>
		<TELL "He's wearing, with obvious and inexplicable pride, a mulberry-coloured uniform marked CHOWMAIL OVERNITE">
		<COND (<FIRST? ,PRSO>
		       <TELL ", and is holding ">
		       <PRINT-CONTENTS ,PRSO>)>
		<ZPRINT ,PERIOD>
		T)
	       (<THIS-PRSI?>
		<COND (<VERB? GIVE>
		       <GIVE-TO-DMAN>
		       T)
		      (<VERB? SHOW>
		       <SHOW-TO-DMAN>
		       T)
		      (T
		       <>)>)
	       (<VERB? TELL>
		<>)
	       (<VERB? ASK-ABOUT>
		<BAD-DMAN-Q>
		T)
	       (T
		<>)>>

<DEFINE DMAN-LEAVES ()
	 <ZREMOVE ,DMAN>
	 <SETG P-HIM-OBJECT ,NOT-HERE-OBJECT>
	 <DEQUEUE I-DMAN>
	 <UNMAKE ,FROOM-DOOR ,OPENED>
	 T>

<DEFINE SHOW-TO-DMAN ("OPTIONAL" (OBJ <>))
	 <MAKE ,DMAN ,SEEN>
	 <COND (<ZERO? .OBJ>
		<SET OBJ ,PRSO>)>
	 <TELL CTHE ,DMAN " glances at " THE .OBJ ". \"">
	 <COND (<IS? .OBJ ,DMAN-TOLD>
		<TELL "I already told you">
		<LADY-OR-MISTER>
		<TELL ". ">)>
	 <TELL "I'm ">
	 <COND (<NOT <EQUAL? .OBJ ,BEEZER ,EXCESS>>
		<MAKE .OBJ ,DMAN-TOLD>
		<TELL "not ">)>
	 <TELL "authorized by Head Office to accept that as payment.\"" CR>
	 T>

<DEFINE GIVE-TO-DMAN ("OPTIONAL" (OBJ <>))
	 <MAKE ,DMAN ,SEEN>
	 <COND (<ZERO? .OBJ>
		<SET OBJ ,PRSO>)>
	 <TELL CTHE ,DMAN>	 
	 <COND (<EQUAL? .OBJ ,BEEZER>
		<DMAN-LEAVES>
		<MOVE ,BAG ,FROOM>
		<TELL
" makes an imprint of your Beezer card with his portable Imprint-O-Mat, gets you to sign a ridiculous form (which you notice in passing contains a larger number than there are things in the known Universe) and hands the card back to you.|
|
\"Thank you,\" he says, depositing the bag at your feet. \"If ever your future pet-feeding plans call for llama food, I hope you'll think of Chowmail. Have a nice day!\"|
|
The man closes " THE ,FROOM-DOOR ". You can hear him whistling a cheery llama-food delivery tune as he walks away." CR>
		T)
	       (<EQUAL? .OBJ ,EXCESS>
		<TELL 
" glances at your US Excess card and shakes his head. \"Sorry,\" he says, handing the card back to you. \"This expired last month. Hey!\" he says, with the air of someone who has just thought of a new philosophical explanation of life, suffering and why there's never enough Chinese ravioli for everyone at dinner to have a second one each, \"You know what you should do? You should get your bank to send you another one.\"|
|
Incredibly, you resist the urge to kill the worthless cake-brain on the spot." CR>
		T)
	       (T
		<TELL " glances at " THE .OBJ ", but refuses to take it. \"">
		<COND (<IS? .OBJ ,DMAN-TOLD>
		       <TELL "I already told you">
		       <LADY-OR-MISTER>
		       <TELL ". ">)>
		<MAKE .OBJ ,DMAN-TOLD>
		<TELL "I'm not authorized to accept " 
		      A .OBJ " as payment. Only Beezer or US Excess.\"" CR>
		T)>>

<DEFINE BAD-DMAN-Q ()
	 <MAKE ,DMAN ,SEEN>
	 <TELL "\"I'm sorry,\" says " THE ,DMAN
", \"but I'm not authorized to answer that question.\"" CR>>

<DEFINE DMAN-APPEARS ()
	 <MAKE ,FROOM-DOOR ,OPENED>
	 <MAKE ,FROOM-DOOR ,TOUCHED>
	 <MOVE ,DMAN ,FROOM>
	 <SETG P-HIM-OBJECT ,DMAN>
	 <SETG P-IT-OBJECT ,BAG>
	 <DEQUEUE I-DOORBELL>
	 <QUEUE I-DMAN>
	 <TELL "You open " THE ,FROOM-DOOR ,PCR
"\"Hi,\" says the annoyingly bright young man in the doorway. \"Chowmail Overnite. Are you ">
	 <MR-OR-MISS>
	 <SHOW-FIELD ,LAST-NAME>
	 <TELL ", of ">
	 <SAY-STREET-ADDRESS ,OUTSIDE-FARM>
	 <TELL "?\" He holds up a large burlap bag. \"Here's your order of "
	       Q ,TREATS "!\"" CR>
	 T>

<SETG DOORBELL-RINGS 10>		;"Turns to ring door bell for."

<DEFINE I-DOORBELL ("OPTIONAL" (CR T) "AUX" (RING T))
	 <SETG DOORBELL-RINGS <- ,DOORBELL-RINGS 1>>
	 <COND (<L=? ,DOORBELL-RINGS 0>
		<DEQUEUE I-DOORBELL>
		<MAKE ,FROOM-DOOR ,TOUCHED>
		<SET RING <>>)>
	 <COND (<NOT <HERE? FROOM BROOM>>
		<>)
	       (T
		<COND (<T? .CR>
		       <ZCRLF>)>
		<COND (.RING <TELL CTHE ,DOORBELL " is ringing." CR>)
		      (ELSE <TELL CTHE ,DOORBELL " stops ringing." CR>)>
		T)>>

"*** NERD ***"

<MSETG INIT-NERD-SCRIPT 3>
<GLOBAL NERD-SCRIPT 0>
<CONSTANT NERD-ARRIVALS
	  <TABLE (LENGTH PATTERN (BYTE [REST WORD]))
		 #BYTE 0
		  "The snivelling, ratty and ineffectual nerd stumbles into view again"
		  "You hear a hatefully familiar whine close at hand"
		  "The ghastly nerd reappears at your side, peering myopically through his filthy Coke-bottle spectacles">>

<MSETG NOBJ-SDESC 0>
<MSETG NOBJ-LDESC 1>
<MSETG NOBJ-ADJS 2>
<MSETG NOBJ-SYNS 3>

<CONSTANT NERD-OBJECTS
	  <PLTABLE
	   <PTABLE "universal accessory"
		   "This amazing accessory is complete with an incredibly intricate Japanese multifunction plug and fully-shielded coaxial cable regulated by miracle microchip technology, designed to plug into the back of anything and look complicated. It is to computers what the paperweight is to aerodynamics."
			  <PLTABLE <VOC "ACCESSORY" ADJ><VOC "UNIVERSAL" ADJ>
				   <VOC "AMAZING" ADJ>>
			  <PLTABLE <VOC "ACCESSORY" OBJECT>
				   <VOC "PLUG" OBJECT><VOC "CABLE" OBJECT>>>
		  <PTABLE "Boysenberry XiGT6HP Special"
			  "The product of years of research by tiny dedicated craftsmen in expensive West Coast chambray workshirts, the XiGT6HP Special offers full digital pay-as-you-load \"top-end\" hyphenation combined with a unique beat-as-you-sweep action for perfectly browned vegetables and reliable color-fast, full-nine-pound boil-wash 'n' rinse cycles with \"No-Urk\" data security."
			  <PLTABLE <VOC "SPECIAL" ADJ>
				   <VOC "XI" ADJ>
				   <VOC "XIGT6HP" ADJ>
				   <VOC "GT6" ADJ>
				   <VOC "HP" ADJ>>
			  <PLTABLE <VOC "XIGT6HP" OBJECT>
				   <VOC "XI" OBJECT>
			           <VOC "GT6" OBJECT> <VOC "HP" OBJECT>
				   <VOC "SPECIAL" OBJECT>>>
		  <PTABLE "set of rare hackers' log-file disks"
			  "These disks contain hundreds of incredibly rare telephone numbers, passwords, user accounts and encryption routines for getting into other people's computers and fouling them up. They really hate it, but I don't mind telling you -- after all, you're one of us."
			  <PLTABLE <VOC "HACKERS'" ADJ> <VOC "HACKER'S" ADJ>
				   <VOC "LOG" ADJ> <VOC "RARE" ADJ>
				   <VOC "LOG-FILE" ADJ> <VOC "FILE" ADJ>>
			  <PLTABLE <VOC "SET" OBJECT> <VOC "DISK" OBJECT>
				   <VOC "DISKS" OBJECT>>>
		  <PTABLE "dictionary-indexing protocol"
			  "Say goodbye to ugly dictionary misery with this unique and classified, billion-dollar Department of Defense protocol for speedy compilation of dictionary indices. Indexes Chambers, Webster's, Oxford English and all other major dictionaries. No more \"Where's-that-word\" frustration! Just run the indexer and -- Hey presto! -- word's found!"
			  <PLTABLE <VOC "DICTIONARY" ADJ> <VOC "INDEXING" ADJ>
				   <VOC "PROTOCOL" ADJ>>
			  <PLTABLE <VOC "PROTOCOL" OBJECT>
				   <VOC "PROTOCOLS" OBJECT>
				   <VOC "SET" OBJECT>>>
		  <PTABLE "Little Computer Animals program"
			  "You've heard of Little Computer People. Now you can have Little Computer Animals. Just load up the disk and -- Poof! -- every morning there's the hell of a mess all round your computer -- bits of straw, half-chewed food, bones, feathers and all the romance of the animal kingdom. Little Computer Animals will even shriek inexplicably in the middle of the night. Guaranteed to make your dull old computer not only lovable but even more time-consuming."
			  <PLTABLE <VOC "LITTLE" ADJ> <VOC "COMPUTER" ADJ>
				   <VOC "ANIMALS" ADJ>>
			  <PLTABLE <VOC "ANIMALS" OBJECT>
				   <VOC "PROGRAM" OBJECT>>>
		  <PTABLE "decision-support system for executives"
			  "A vital tool for the career executive. A random decision-tree advises when to buy, sell, agree, stymie, sabotage, crawl, cover your back etc., totally without reference to reality. A must for the busy manager. Complete with appalling Harvard MBA-style meaningless jargon."
			  <PLTABLE <VOC "EXECUTIVE" ADJ> <VOC "DECISION" ADJ>
				   <VOC "SUPPORT" ADJ>>
			  <PLTABLE <VOC "SYSTEM" OBJECT>>>
		  <PTABLE "real Star Trek phaser"
			  "The first rule of defense is attack. With the Star Trek phaser you can defend yourself by vapourising people before they've even noticed you're there, let alone thought about attacking you. Works just like the real thing."
			  <PLTABLE <VOC "STAR" ADJ> <VOC "TREK" ADJ>>
			  <PLTABLE <VOC "PHASER" OBJECT>
				   <VOC "GUN" OBJECT>>>
		  <PTABLE "digital tooth meter"
			  "Intellectuals, nerds and geniuses can't be expected to keep track of everything. How often have you been walking down the street thinking about tensor calculus when Bang! over you go? Now miracle microtechnology has the answer. Just clip the tooth meter to your lip and it keeps a running total of your tooth-count in nonvolatile RAM. So next time you bite the sidewalk, Bing! the tooth meter will instantly give you a \"read-out\" of how many teeth you have lost. Also works for spectacle lenses."
			  <PLTABLE <VOC "DIGITAL" ADJ>
				   <VOC "TOOTH" ADJ><VOC "TEETH" ADJ>>
			  <PLTABLE <VOC "METER" OBJECT>>>>>

<SETG NERD-OBJECT-DATA <>>

<OBJECT NERD-OBJECT
	(FLAGS NODESC)
	(ADJECTIVE ZZZP ZZZP ZZZP ZZZP ZZZP ZZZP ZZZP)
	(SYNONYM ZZZP ZZZP ZZZP ZZZP ZZZP)
	(SDESC SDESC-NERD-OBJECT)
	(ACTION NERD-OBJECT-F)>

<DEFINE SDESC-NERD-OBJECT ()
  <TELL <ZGET ,NERD-OBJECT-DATA ,NOBJ-SDESC>>>

<DEFINE NERD-OBJECT-F ("OPT" (CONTEXT <>))
  <COND (<==? .CONTEXT ,M-OBJDESC>
	 <TELL <ZGET ,NERD-OBJECT-DATA ,NOBJ-LDESC>>)
	(<T? .CONTEXT>
	 <>)
	(<VERB? EXAMINE>
	 <TELL <ZGET ,NERD-OBJECT-DATA ,NOBJ-LDESC> CR>)
	(T <>)>>

<DEFINE SETUP-NERD-OBJECT ("AUX" V1 V2 L1 L2)
  <SET V1 <GETPT ,NERD-OBJECT ,P?ADJECTIVE>>
  <SET L1 </ <PTSIZE .V1> 2>>
  <SET V2 <GETPT ,NERD-OBJECT ,P?SYNONYM>>
  <SET L2 </ <PTSIZE .V2> 2>>
  <MUNG-WVEC .V1 .L1 <ZGET ,NERD-OBJECT-DATA ,NOBJ-ADJS>>
  <MUNG-WVEC .V2 .L2 <ZGET ,NERD-OBJECT-DATA ,NOBJ-SYNS>>>

<DEFINE MUNG-WVEC (WVEC WLEN:FIX LT "AUX" (LLEN <ZGET .LT 0>)
		   (OFFS 1))
  <REPEAT ()
    <ZPUT .WVEC <- .OFFS 1> <ZGET .LT .OFFS>>
    <SET WLEN <- .WLEN 1>>
    <COND (<G? <SET OFFS <+ .OFFS 1>> .LLEN>
	   <RETURN>)>>
  <COND (<G? .WLEN 0>
	 <REPEAT ()
	   <ZPUT .WVEC <- .OFFS 1> ,W?ZZZP>
	   <SET OFFS <+ .OFFS 1>>
	   <COND (<L? <SET WLEN <- .WLEN 1>> 1>
		  <RETURN>)>>)>>

<DEFINE SAY-NERD-MONEY ("OPT" (AMT -1) (AST 0))
  <COND (<L=? .AMT 0> <SET AMT <+ ,CASH 100>>)>
  <COND (<G? .AMT 0> <SET AMT </ .AMT 100>>)
	(<L=? <SET AMT </ <+ .AMT 100> 100>> 0>
	 <SET AMT 26>)>
  <COND (<==? .AMT 1>
	 <COND (<==? .AST 1>
		<TELL "A ">)
	       (<==? .AST 0>
		<TELL "a ">)>
	 <TELL "buck">)
	(T
	 <TELL N .AMT " bucks">)>>

<DEFINE I-NERD NERD ("AUX" X:FIX)
	 <COND (<IS? ,HERE ,NO-NERD>
		<RETURN <> .NERD>)
	       (<IN? ,NERD ,HERE>
		<COND (<IS? ,NERD ,TOUCHED>
		       <UNMAKE ,NERD ,TOUCHED>
		       <RETURN <> .NERD>)>
		<SET X <SETG NERD-SCRIPT <- ,NERD-SCRIPT 1>>>
		<ZCRLF>
		<COND (<EQUAL? .X 2>
		       <TELL CTHE ,NERD
" waves " THE ,NERD-OBJECT " impatiently. \"C'mon">
		       <LADY-OR-MISTER>
		       <TELL ". ">
		       <SAY-NERD-MONEY -1 1>
		       <TELL "! A bargain!\"">
		       <ZCRLF>
		       <RETURN T .NERD>)
		      (<EQUAL? .X 1>
		       <TELL "\"No money, no " D ,NERD-OBJECT
			     ",\" whines the nerd." CR>
		       <RETURN T .NERD>)>
		<ZREMOVE ,NERD>
		<ZREMOVE <FIRST? ,NERD>>
		<SETG P-HIM-OBJECT ,NOT-HERE-OBJECT>
		<SETG P-IT-OBJECT ,NOT-HERE-OBJECT>
		<SETG NERD-SCRIPT ,INIT-NERD-SCRIPT>
		<TELL CTHE ,NERD
" stumbles out of sight with " THE ,NERD-OBJECT
". \"I'll be back,\" he threatens." CR>
		<RETURN T .NERD>)
	       (<PROB 94>
		<RETURN <> .NERD>)>
	 <COND (<HERE? ,DUCT ,TOWER-DUCT>
		<TELL CR "A nerdy-looking young man slides by you at a high rate of speed. As he passes, he shakes something under your nose, and you hear him shout something about how you can have it for only ">
		<SAY-NERD-MONEY>
		<TELL ". He disappears down the duct." CR>
		<RETURN T .NERD>)>
	 <MOVE ,NERD ,HERE>
	 <SETG NERD-SCRIPT ,INIT-NERD-SCRIPT>
	 <THIS-IS-IT ,NERD>
	 <UNMAKE ,NERD ,TOUCHED>
	 <ZCRLF>
	 <MOVE ,NERD-OBJECT ,NERD>
	 <SETG NERD-OBJECT-DATA <PICK-ONE ,NERD-OBJECTS>>
	 <SETUP-NERD-OBJECT>
	 <COND (<NOT <IS? ,NERD ,SEEN>>
		<MAKE ,NERD ,SEEN>
		<TELL 
"A nerdy-looking young man you've never seen before stumbles into view. \"Are you ">
		<PRINT-NAME>
		<TELL ", of ">
		<SHOW-FIELD ,STREET-NUMBER>
		<TELL " ">
		<SHOW-FIELD ,STREET-NAME>
		<TELL ", ">
		<SHOW-FIELD ,CITY-NAME>
		<TELL ", formerly of 5 Hippo Vista, Rhinoceros, New
Jersey?\" he asks in an obnoxiously whiny voice. \"I have something I know
you'll want. It's a " D ,NERD-OBJECT "! Only ">
		<SAY-NERD-MONEY>
		<TELL "!\"" CR>
		<RETURN T .NERD>)>
	 <TELL PNEXT ,NERD-ARRIVALS
	       ". \"There you are!\" he whines. ">
	 <TELL "\"I've got something I know you'll want. "
	       CA ,NERD-OBJECT "! Only ">
	 <SAY-NERD-MONEY>
	 <TELL "!\"" CR>
	 <THIS-IS-IT ,NERD-OBJECT>
	 <RETURN T .NERD>>

<OBJECT NERD
	(DESC "nerd")
	(FLAGS PERSON LIVING)
	(SYNONYM NERD GUY FELLOW MAN)
	(ADJECTIVE NERDY NERDY-LOOKING YOUNG)
	(CONTFCN NERD-F)
	(DESCFCN NERD-F)
	(ACTION NERD-F)>

<DEFINE NERD-F NERD ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-OBJDESC>
		<TELL "A terrible nerd is waving "
		      A ,NERD-OBJECT " at you.">
		T)
	       (<EQUAL? .CONTEXT ,M-CONT>
		<COND (<TOUCHING?>
		       <MAKE ,NERD ,TOUCHED>
		       <TELL "\"Nope! Nope! ">
		       <SAY-NERD-MONEY <> 1>
		       <TELL " first!\" whines "
			     THE ,NERD ,PERIOD>
		       T)
		      (T
		       <>)>)
	       (<AND <EQUAL? .CONTEXT ,M-WINNER> <NOT <HERE? IN-COMPLEX>>>
		<MAKE ,NERD ,TOUCHED>
		<COND (<VERB? EXAMINE TAKE>
		       <SHOW-TO-NERD>
		       <RETURN ,FATAL-VALUE .NERD>)
		      (<VERB? STINGLAI>
		       <RETURN <> .NERD>)
		      (<VERB? WHAT>
		       <ASK-NERD-ABOUT ,PRSO>
		       <RETURN ,FATAL-VALUE .NERD>)
		      (<PRSO? ME>
		       <COND (<VERB? TELL-ABOUT>
			      <ASK-NERD-ABOUT>
			      <RETURN ,FATAL-VALUE .NERD>)
			     (<VERB? SSHOW SGIVE SSELL>
			      <ASK-NERD-FOR>
			      <RETURN ,FATAL-VALUE .NERD>)>)
		      (<PRSI? ME>
		       <COND (<VERB? SHOW>
			      <ASK-NERD-ABOUT ,PRSO>
			      <RETURN ,FATAL-VALUE .NERD>)
			     (<VERB? GIVE SELL>
			      <ASK-NERD-FOR ,PRSO>
			      <RETURN ,FATAL-VALUE .NERD>)>)>
		<TELL CTHE ,WINNER
" shakes his obnoxious little head. \"">
		<SAY-NERD-MONEY <> 1>
		<TELL " first,\" he whines." CR>
		,FATAL-VALUE)
	       (<T? .CONTEXT>
		<>)
	       (<THIS-PRSI?>
		<COND (<VERB? GIVE SHOW>
		       <SHOW-TO-NERD>
		       T)
		      (T
		       <>)>)
	       (<VERB? EXAMINE>
		<MAKE ,NERD ,TOUCHED>
		<TELL "We do " ITAL "not" " believe you've never seen a nerd
before. You probably hang out with them all the time. This one is just like
those ones.|
|
At the moment, he's waving " A ,NERD-OBJECT
		      " in your face in a thoroughly obnoxious manner." CR>)
	       (<VERB? WATCH>
		<MAKE ,NERD ,TOUCHED>
		<TELL CTHEO
" waves " A ,NERD-OBJECT " in your face in a thoroughly obnoxious manner." CR>
		T)
	       (<VERB? TELL>
		<>)
	       (<VERB? ASK-ABOUT>
		<ASK-NERD-ABOUT>
		T)
	       (<VERB? ASK-FOR>
		<ASK-NERD-FOR>
		T)
	       (<VERB? HELLO GOODBYE WAVE-AT BOW THANK TELL QUESTION REPLY>
		<MAKE ,NERD ,TOUCHED>
		<TELL CTHEO " rudely ignores you. \"">
		<SAY-NERD-MONEY <> 1>
		<TELL "!\" he sings." CR>
		T)
	       (T
		<>)>>

<DEFINE ASK-NERD-ABOUT ("OPTIONAL" (OBJ <>))
	 <COND (<ZERO? .OBJ>
		<SET OBJ ,PRSI>)>
	 <MAKE ,NERD ,TOUCHED>
	 <COND (<EQUAL? .OBJ ,NERD-OBJECT>
		<YOURS-FOR-25>)
	       (<==? .OBJ ,OPTOMETRISTS>
		<TELL "\"Huh? Oh, them!\" He smirks briefly. \"I don't know
what you're talking about.\"" CR>)
	       (<==? .OBJ ,CALIFORNIA>
		<TELL "\"Bletcho. Pink tofu. Steve Jobs. Nobody ever wrote
a good program in California.\"" CR>)
	       (T
		<TELL "\"Talk is cheap,\" whines " THE ,NERD
		      ". \"What about my ">
		<SAY-NERD-MONEY -1 2>
		<TELL "?\"" CR>)>
	 T>

<DEFINE YOURS-FOR-25 ()
	 <TELL "\"It's yours for ">
	 <SAY-NERD-MONEY>
	 <TELL ",\" teases " THE ,NERD ,PERIOD>>

<DEFINE ASK-NERD-FOR ("OPTIONAL" (OBJ <>))
	 <COND (<ZERO? .OBJ>
		<SET OBJ ,PRSI>)>
	 <MAKE ,NERD ,TOUCHED>
	 <COND (<EQUAL? .OBJ ,NERD-OBJECT>
		<YOURS-FOR-25>)
	       (T
		<TELL "\"I don't have " A .OBJ ",\" whines " THE ,NERD
		      ". \"But I ">
		<ITALICIZE "do">
		<TELL " have " A ,NERD-OBJECT
		      "! Gimme ">
		<SAY-NERD-MONEY>
		<TELL ", and it's yours.\"" CR>)>
	 T>

<DEFINE SHOW-TO-NERD ("OPTIONAL" (OBJ <>))
	 <COND (<NOT <T? .OBJ>> <SET OBJ ,PRSO>)>
	 <MAKE ,NERD ,TOUCHED>
	 <COND (<EQUAL? .OBJ ,MONEY>
		<COND (<G? ,P-NUMBER ,CASH>
		       <TELL "\"This isn't ">
		       <SAY-NERD-MONEY ,P-NUMBER>
		       <TELL "!\" He hands it back." CR>
		       T)
		      (T
		       <YOURS-FOR-25>)>)
	       (T
		<TELL CTHE ,NERD " glances at " THE .OBJ
		      ". \"I don't want ">
		<ITALICIZE "that">
		<TELL ",\" he whines. \"I want ">
		<SAY-NERD-MONEY>
		<TELL "!\"" CR>)>
	 T>

