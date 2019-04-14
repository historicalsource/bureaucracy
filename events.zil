"EVENTS for BUREAUCRACY: (C)1987 Infocom, Inc. All rights reserved."

<FILE-FLAGS MDL-ZIL?>

<INCLUDE "OLD-PARSERDEFS">

<DEFINE-GLOBALS MUZAK-TABLE
	   (TUNE-TIMER:FIX BYTE 0)
	   (TUNE-SELECTOR:FIX BYTE 0)
	   (TUNE-MENTIONED? BYTE 0)>

<CONSTANT BAD-TUNES <PLTABLE
		     "Tie a Yellow Ribbon 'Round the Old Oak Tree"
		     "Afternoon Delight"
		     "Torn Between Two Lovers"
		     "Boogie Oogie Oogie"
		     "Delta Dawn"
		     "I Write the Songs"
		     "Surfin' USA"
		     "Leader of the Pack"
		     "My Way">>

<CONSTANT TOONS <PLTABLE
		     "performed on common household appliances"
		     "performed by a world-famous kazoo soloist"
		     "with a disco beat"
		     "backed by a bassoon-and-triangle duet"
		     "with the lyrics mercifully mixed out"
		     "backed by an angelic chorus"
		     "with 101 strings"
		     "backed by too many clarinets"
		     "performed by 101 guitars"
		     "performed a capella by Tony Orlando and Dawn">>

<MSETG NUMBER-OF-TUNES 26>

<DEFINE NEXT-TOON ("AUX" (X <TUNE-SELECTOR>))
  <COND (<G? <SET X <+ .X 1>> ,NUMBER-OF-TUNES>
	 <SET X 0>)>
  <TUNE-SELECTOR .X>
  <TUNE-MENTIONED? <>>
  .X>

<DEFINE I-TUNE-TIMER ITT ("AUX" X Y)
	 <SET X <TUNE-TIMER>>
	 <COND (<G? <SET X <+ .X 1>> 10>
		<SET X 0>
		<NEXT-TOON>)>
	 <TUNE-TIMER .X>
	 <RETURN <> .ITT>>

<DEFINE I-RADIO IR ("OPTIONAL" (CR T))
	 <COND (<NOT <HERE? BEHIND-MANSION IN-PORCH TROPHY-ROOM
			    OUTSIDE-MANSION>>
		<RETURN <> .IR>)
	       (<AND <F? <TUNE-MENTIONED?>>
		     <ZERO? <TUNE-TIMER>>>
		<COND (<T? .CR>
		       <ZCRLF>)>
		<TELL CTHE ,RADIO>
		<COND (<HERE? BEHIND-MANSION OUTSIDE-MANSION>
		       <TELL " in the mansion">)
		      (<HERE? IN-PORCH>
		       <TELL " in the next room">)>
		<TELL " begins to play ">
		<SAY-MUZAK>
		<ZPRINT ,PERIOD>
		<RETURN T .IR>)>
	 <RETURN <> .IR>>

<DEFINE I-CLERK IC ("OPTIONAL" (CR T))
	 <COND (<IS? ,CLERK ,TOUCHED>
		<UNMAKE ,CLERK ,TOUCHED>
		<RETURN <> .IC>)
	       (<PROB 50>
		<RETURN <> .IC>)
	       (<T? .CR>
		<ZCRLF>)>
	 <TELL CTHE ,CLERK PNEXT ,CLERK-DOINGS ,PERIOD>
	 <RETURN T .IC>>

<CONSTANT CLERK-DOINGS
	<TABLE (LENGTH PATTERN (BYTE [REST WORD]))
	       #BYTE 0
		" is eyeing you carefully"
		" adjusts the software on the wall"
		" watches every move you make"
		" fiddles with the software"
		" looks at you expectantly"
		" rereads all the price tags on the software">>
<GDECL (CLERK-DOINGS) TABLE>

<SETG CLERK-SCRIPT 4>
<GDECL (CLERK-SCRIPT) FIX>

<DEFINE I-CLERK-TRADE ICT ("OPTIONAL" (CR T) "AUX" (X <>))
	 <MAKE ,CLERK ,TOUCHED>
	 <SETG P-IT-OBJECT ,RECIPE>
	 <COND (<T? .CR>
		<ZCRLF>)>
	 <COND (<AND <IN? ,RECIPE ,CLERK>
		     <NOT <IS? ,RECIPE ,SEEN>>>
		<COND (<PROB 50>
		       <SET X T>
		       <TELL CTHE ,CLERK
			     " holds up the cart for you to see. ">)>
		<TELL "\"">
		<COND (<PROB 33>
		       <TELL "It's not against the law to look">)
		      (<PROB 50>
		       <TELL ,DONT "have to touch it. Just take a look">)
		      (T
		       <TELL "They won't arrest you just for looking">)>
		<TELL " at it">
		<COND (<PROB 50>
		       <TELL ", you know">)>
		<COND (<T? .X>
		       <TELL ".\"" CR>
		       <RETURN T .ICT>)>
		<TELL ",\" says the clerk">
		<COND (<PROB 50>
		       <TELL ", holding up the cart for you to see">)>
		<ZPRINT ,PERIOD>
		<RETURN T .ICT>)>
	 <SETG CLERK-SCRIPT <- ,CLERK-SCRIPT 1>>
	 <COND (<EQUAL? ,CLERK-SCRIPT 3>
		<MOVE ,RECIPE ,CLERK>
		<THIS-IS-IT ,RECIPE>
		<TELL "\"Take a look at ">
		<HLIGHT ,H-ITALIC>
		<TELL "this">
		<HLIGHT ,H-NORMAL>
		<TELL "!\" he chortles, holding it up for you to see." CR>
		<RETURN T .ICT>)
	       (<EQUAL? ,CLERK-SCRIPT 2>
		<DESCRIBE-RECIPE>
		<RETURN T .ICT>)
	       (<EQUAL? ,CLERK-SCRIPT 1>
		<TELL CTHE ,CLERK " fawns over " THE ,RECIPE 
". \"Been looking for a good game,\" he remarks">
		<COND (<NOT <VISIBLE? ,ADVENTURE>>
		       <TELL ,PERIOD>
		       <RETURN T .ICT>)>
		<TELL ", eyeing your " D ,ADVENTURE ,PERIOD> 
		<RETURN T .ICT>)>
	 <DEQUEUE I-CLERK-TRADE>
	 <SETG CLERK-SCRIPT 4>
	 <TELL "\"Oh, well,\" shrugs " THE ,CLERK
" as he toys with the cart. \"If you ever want a good trade, you know where to find me.\"" CR>
	 <RETURN T .ICT>>

<DEFINE DESCRIBE-RECIPE ()
	 <TELL
"\"Pre-release copy. Custom chips, probably one of a kind.\"">
	 <COND (<IN? ,RECIPE ,CLERK>
		<TELL 
" He tosses the cart from hand to hand. \"I'm not into cooking, though. Eat out all the time. Wouldn't mind trading this for something.\"">)>
	 <ZCRLF>>

<DEFINE I-WAITRESS-ARRIVES IWA ()
	 <COND (<HERE? DINER>
		<MOVE ,WAITRESS ,HERE>
		<SETG P-HER-OBJECT ,WAITRESS>
		<TELL CR "A harried-looking waitress appears at your side. \"May I take your order now, ">
		<SIR-OR-MAAM>
		<TELL "?\"" CR>
		<COND (<SAID-YES? "The waitress sighs. \"Do you want me to take your order now or not? Just answer yes or no.\"">
		       <GET-ORDER ,WAITRESS>
		       <SETG MEAL-STATE ,MS-ORDERED-FROM-WAITRESS>
		       <MAKE ,WAITRESS ,SEEN>
		       <MOVE ,WAITRESS ,IN-ALLEY>
		       <MAKE ,KITCHEN-DOOR ,OPENED>
		       <TELL CTHE ,WAITRESS " races away. A few moments later,
she returns. \"Our computer crashed, and we lost your order. It's time for my
break, so someone else will have to take your order.\" She walks away." CR>
		       ;<TELL CTHE ,WAITRESS " looks at her watch. \"Oops, time for my break. Someone else will have to take your order.\" She walks away." CR>
		       <QUEUE I-WAITER-ARRIVES 2>		       
		       <RETURN T .IWA>)>
		<QUEUE-WAITRESS>
		<TELL CTHE ,WAITRESS
" sighs loudly. \"I'll come back in a minute,\" she warns." CR>
		<ZREMOVE ,WAITRESS>
		<RETURN T .IWA>)>
	 <RETURN <> .IWA>>
			 
<DEFINE I-WAITER-ARRIVES IWA ("OPT" (CHOMP? <>) "AUX" WORD (ALREADY-HERE? <>))
	 <COND (<HERE? DINER>
		<COND (<IN? ,WAITER ,HERE>
		       <SET ALREADY-HERE? T>)>
		<MOVE ,WAITER ,HERE>
		<THIS-IS-IT ,WAITER>
		<COND (<==? ,MEAL-STATE ,MS-ORDERED-FROM-WAITER>
		       <MOVE ,BURGER ,DTABLE>
		       <THIS-IS-IT ,BURGER>
		       <SETG MEAL-STATE ,MS-RECEIVED-FOOD>
		       <COND (<F? .CHOMP?>
			      <ZCRLF>)>
		       <TELL CTHE ,WAITER " reappears. ">
		       <COND (.CHOMP?
			      <TELL "\"Don't leave yet, here's y">)
			     (ELSE
			      <TELL "\"Y">)>
		       <TELL "our burger, ">
		       <SIR-OR-MAAM>
		       <TELL 
",\" he announces, dropping it on the table before you and racing off before you can complain about its size." CR>
		       <REMOVE ,WAITER>
		       <QUEUE-WAITER>
		       <RETURN T .IWA>)
		      (<OR .CHOMP?
			   <==? ,MEAL-STATE ,MS-RECEIVED-FOOD>>
		       ; "Burger been delivered, not paid for"
		       <COND (<F? .CHOMP?>
			      <ZCRLF>)>
		       <TELL CTHE ,WAITER>
		       <COND (.ALREADY-HERE?
			      <TELL " clears his throat.">)
			     (T
			      <TELL " reappears.">)>
		       <TELL " \"That will be $4.50, ">
		       <SIR-OR-MAAM>
		       <TELL ",\" he says." CR>
		       <RETURN T .IWA>)>
		<TELL CR
"A surly-looking waiter with huge bunched muscles like the sort of people who kick whole " ITAL "beaches" " in people's faces appears at your side. \"Are you ready to order now?\"" CR>
		<REPEAT ()
			<SET WORD <GET-WORD>>
			<COND (<YES-USED? .WORD>
			       <REPEAT ()
				       <SETG MEAL-STATE
					     ,MS-ORDERED-FROM-WAITER>
				       <GET-ORDER ,WAITER>
				       <TELL
"The waiter squints at his pad with tiny simian eyes, breathing hard with the intellectual effort of it all. \"Let's see if I got that right. You want ">
				       <REPEAT-ORDER>
				       <TELL ". Is that right?\"" CR>
				       <REPEAT ()
					       <SET WORD <GET-WORD>>
					       <COND (<YES-USED? .WORD>
						      <TELL CTHE ,WAITER
 " nods. \"That'll be a few minutes,\" he says as he races away." CR>
		       				      <QUEUE-WAITER>
						      <REMOVE ,WAITER>
						      <RETURN T .IWA>)
						     (<NO-USED? .WORD>
						      <TELL
"The waiter sighs and rips off a sheet from his pad with a hand like a whole hairy ham" ,PCR>
						      <RETURN>)
						     (T
						      <TELL
"The waiter glares at you through malevolent pink eyes. \"Look, is the order right or isn't it? Just say yes or no.\"" CR>)>>>)
			      (<NO-USED? .WORD>
			       <RETURN>)>
			<TELL "The waiter gives you an I'm-about-to-rip-your-leg-off look. \"Do you want to order now or not? Yes or no!\"" CR>>
		<TELL
"\"I'll be back,\" warns the waiter, racing off." CR>
		<QUEUE-WAITER>
		<REMOVE ,WAITER>		
		<RETURN T .IWA>)>
	 <RETURN T .IWA>>

<VOC "RAW" ADJ> <VOC "RARE" ADJ> <VOC "MEDIUM" ADJ> <VOC "WELL" ADJ>
<VOC "WELL-DONE" ADJ> <VOC "SPECIAL" ADJ>
<VOC "FRIES" NOUN>
<VOC "CHEDDAR" ADJ> <VOC "SALAD" NOUN>
<VOC "BLUE" ADJ> <VOC "CHEESE" NOUN> <VOC "ISLAND" NOUN> 
<VOC "VINAIGRETTE" ADJ>
<VOC "DIET" ADJ> <VOC "REGULAR" ADJ> <VOC "BAKED" ADJ> <VOC "POTATO" NOUN>
<VOC "BEER" NOUN> <VOC "WINE" NOUN> <VOC "SODA" NOUN> <VOC "JUICE" NOUN>
<VOC "DARK" ADJ> <VOC "LIGHT" ADJ> <VOC "ALE" NOUN> <VOC "DRAUGHT" ADJ>
<VOC "RED" ADJ> <VOC "WHITE" ADJ> <VOC "SWEET" ADJ> <VOC "DRY" ADJ>
<VOC "APPLE" ADJ> <VOC "ORANGE" ADJ> <VOC "LEMON" ADJ> <VOC "LIME" ADJ>
<VOC "LEMON-LIME" ADJ> <VOC "DISTILLED" ADJ> <VOC "MINERAL" ADJ>
<VOC "WITHOUT" PREP> <VOC "COLA" NOUN> <VOC "GRAPEFRUIT" ADJ>
<VOC "MANGO" ADJ>

<MSETG BURGER-TYPE 0>
<MSETG BBSAUCE? 1>
<MSETG CHEESE-TYPE 2>
<MSETG BACON? 3>
<MSETG MUSHROOMS? 4>
<MSETG SALAD? 5>
<MSETG DRESSING-TYPE 6>
<MSETG DRESSING-WEIGHT 7>
<MSETG POTATO-TYPE 8>
<MSETG BUTTER? 9>
<MSETG CREAM? 10>
<MSETG YOGHURT? 11>
<MSETG PARSLEY? 12>
<MSETG CHIVES? 13>
<MSETG FRIES? 14>
<MSETG KETCHUP? 15>
<MSETG DRINK? 16>
<MSETG DRINK-TYPE 17>
<MSETG JUICE-TYPE 18>
<MSETG BEER-TYPE 19>
<MSETG WINE-COLOR 20>
<MSETG WINE-TYPE 21>
<MSETG WINE-COUNTRY 22>
<MSETG SODA 23>
<MSETG SODA-TYPE 24>
<MSETG CAFFEINE? 25>
<MSETG WATER? 26>

<DEFINE GET-YES/NO Y/N (PROMPT OFFS COOPSTR "AUX" WORD)
  <ZPRINT .PROMPT>
  <ZCRLF>
  <REPEAT ()
	  <SET WORD <GET-WORD>>
	  <COND (<YES-USED? .WORD>
		 <COND (<G=? .OFFS:FIX 0>
			<ZPUT ,MEAL .OFFS T>)>
		 <RETURN T .Y/N>)
		(<NO-USED? .WORD>
		 <RETURN <> .Y/N>)>
	  <COOPERATE>
	  <ZPRINT .COOPSTR>
	  <ZCRLF>>>

<DEFINE GET-1-OF-N GET (PROMPT TABLE OFFSET:FIX COOPSTR "AUX" WORD
			N:FIX TTBL LONG?)
  <SET N <ZGET .TABLE 0>>
  <SET N <- .N 1>>
  <SET LONG? <ZGET .TABLE 1>>
  <SET TABLE <ZREST .TABLE 4>>
  <ZPRINT .PROMPT>
  <ZCRLF>
  <REPEAT ()
    <SET WORD <GET-WORD>>
    <COND (<F? .WORD>)
	  (.LONG?
	   <REPEAT ((OFFS:FIX 0) VAL)
	     <SET TTBL <ZGET .TABLE .OFFS>>
	     <COND (<INTBL? .WORD <ZREST .TTBL 2> <ZGET .TTBL 0>>
		    <SET VAL <ZGET .TTBL 1>>
		    <COND (<G=? .OFFSET 0>
			   <ZPUT ,MEAL .OFFSET .VAL>)>
		    <RETURN .VAL .GET>)>
	     <COND (<G=? <SET OFFS <+ .OFFS 1>> .N>
		    <RETURN>)>>)
	  (<INTBL? .WORD .TABLE .N>
	   <COND (<G=? .OFFSET 0>
		  <ZPUT ,MEAL .OFFSET .WORD>)>
	   <RETURN .WORD .GET>)>
      <COOPERATE>
      <ZPRINT .COOPSTR>
      <ZCRLF>>>

<VOC "SPECIAL">

<DEFINE GET-ORDER G-O (WHO "AUX" (D <>) (CNT 0) WORD)
	 <REPEAT ()
		 <ZPUT ,MEAL .CNT 0>
		 <COND (<G? <SET CNT <+ .CNT 1>> ,WATER?>
			<RETURN>)>>
	 <TELL CTHE .WHO " sighs too loudly. \"All right, ">
	 <SIR-OR-MAAM>
	 <SET WORD <GET-1-OF-N
		    ", how would you like your burger done? Raw? Rare? Medium? Well-done?\""
		    ,BURGER-TYPE-TABLE
		    ,BURGER-TYPE
		    "Raw, rare, medium, or well-done?\"">>
	 <COND (<==? .WORD ,W?SPECIAL> <RETURN T .G-O>)>
	 <GET-YES/NO "\"Bar-b-que sauce on that?\"" ,BBSAUCE?
		     "Bar-b-que sauce. Yes or no?\"">
         <TELL "\"Very well, ">
	 <SIR-OR-MAAM>
	 <COND (<GET-YES/NO ". Melted cheese?\"" -1
			    "Melted cheese. No? Yes?\"">
		; "Wants cheese"
		<TELL "\"">
		<GET-1-OF-N "Swiss, American, or Cheddar?\""
			    ,CHEESE-TYPE-TABLE
			    ,CHEESE-TYPE
			    "Swiss, American, or Cheddar?\"">)>
	 <GET-YES/NO "\"How about bacon?\"" ,BACON?
		     "Yes or no on the bacon?\"">
	 <GET-YES/NO "\"Mushrooms?\"" ,MUSHROOMS?
		     "A yes or a no on the mushrooms?\"">
	 <TELL 
"\"Great. Now, you've your choice of french fries, baked potato or salad with that. Which will it be, ">
	 <SIR-OR-MAAM>
	 <SET WORD <GET-1-OF-N "?\""
			       ,FRIES-ETC-TABLE
			       -1
			       "Fries? Potato? Or salad?\"">>
	 <COND (<EQUAL? .WORD ,W?SALAD>
		<ZPUT ,MEAL ,SALAD? T>
		<COND
		 (<GET-YES/NO
		   "\"Salad, right. Would you like dressing on that?\""
		   -1
		   "Salad dressing. Yes? No?\"">
		  <TELL "\"">
		  <GET-1-OF-N
"French, Italian, blue cheese, Thousand Island or vinaigrette?\""
			,DRESSING-TYPE-TABLE
			,DRESSING-TYPE
"French, Italian, blue cheese, Thousand Island or vinaigrette?\"">
		  <GET-1-OF-N "\"Diet dressing, or regular?\""
			      ,DRESSING-WEIGHT-TABLE
			      ,DRESSING-WEIGHT
			      "Regular or diet?\"">)>)
	       (<EQUAL? .WORD ,W?POTATO>
		<TELL "\"">
		<GET-1-OF-N "Large or small potato?\""
			    ,POTATO-TYPE-TABLE
			    ,POTATO-TYPE
			    "Large or small potato?\"">
		<GET-YES/NO "\"Butter on that?\""
			    ,BUTTER?
			    "Butter on potato; yes or no?\"">
		<GET-YES/NO "\"Sour cream?\""
			    ,CREAM?
			    "Yes for sour cream, no for none.\"">
		<GET-YES/NO "\"How about yoghurt on that potato?\""
			    ,YOGHURT?
			    "Yes or no, yoghurt?\"">
		<GET-YES/NO "\"Shall I sprinkle that with parsley?\""
			    ,PARSLEY?
			    "Parsley? No? Yes?\"">
		<GET-YES/NO "\"A bit of chive, perhaps?\""
			    ,CHIVES?
			    "Just yes or no for the chive.\"">)
	       (<EQUAL? .WORD ,W?FRIES>
		<ZPUT ,MEAL ,FRIES? T>
		<GET-YES/NO "\"Ketchup with the fries?\""
			    ,KETCHUP?
			    "Ketchup. No? Yes?\"">)>
	 <TELL "\"Right. Now, ">
	 <SIR-OR-MAAM>
	 <SET D
	      <GET-YES/NO ", would you care for a drink?\"" 
		     ,DRINK?
		     "Was that yes or no for the drink?\"">>
	 <TELL "\"Is there any particular kind of drink you want ">
	 <COND (<ZERO? .D>
		<TELL "not ">)>
	 <SET WORD
	  <GET-1-OF-N "to have? We've got beer, wine, soda or juice.\""
		      ,DRINK-TYPE-TABLE
		      ,DRINK-TYPE
		      "Beer, wine, soda, or juice?\"">>
	 <COND (<EQUAL? .WORD ,W?JUICE>
		<TELL "\"">
		<GET-1-OF-N "Orange? Apple? Grapefruit? Mango?\""
			    ,JUICE-TYPE-TABLE
			    ,JUICE-TYPE
			    "Orange? Apple? Grapefruit? Mango?\"">)
	       (<EQUAL? .WORD ,W?BEER>
		<TELL "\"">
		<GET-1-OF-N "Dark, light, ale or draught?\""
			    ,BEER-TYPE-TABLE
			    ,BEER-TYPE
			    "Dark, light, ale or draught?\"">)
	       (<EQUAL? .WORD ,W?WINE>
		<TELL "\"" >
		<GET-1-OF-N "Red or white?\""
			    ,WINE-COLOR-TABLE
			    ,WINE-COLOR
			    "Red or white?\"">
		<TELL "\"">
		<GET-1-OF-N "Dry or sweet?\""
			    ,WINE-TYPE-TABLE
			    ,WINE-TYPE
			    "Dry or sweet?\"">
		<TELL "\"">
		<GET-1-OF-N "French, German or Californian?\""
			    ,WINE-COUNTRY-TABLE
			    ,WINE-COUNTRY
			    "French, German or Californian?\"">)
	       (<EQUAL? .WORD ,W?SODA>
		<TELL "\"" >
		<GET-1-OF-N "Cola, orange or lemon-lime?\""
			    ,SODA-TABLE
			    ,SODA
			    "Cola, orange or lemon-lime?\"">
		<TELL "\"">
		<GET-1-OF-N "Diet or regular?\""
			    ,SODA-TYPE-TABLE
			    ,SODA-TYPE
			    "Diet or regular?\"">
		<GET-1-OF-N "\"With or without caffeine?\""
			    ,CAFFEINE-TABLE
			    ,CAFFEINE?
			    "Caffeine. With or without?\"">)>	      
	 <COND (<GET-YES/NO "\"A glass of water on the side?\"" -1
			    "Water, yes or no?\"">
		<TELL "\"">
		<GET-1-OF-N "Regular, distilled or mineral?\""
			    ,WATER-TABLE
			    ,WATER?
			    "Regular, distilled or mineral?\"">)>>

<CONSTANT BURGER-TYPE-TABLE
	  <PLTABLE T
		   <PLTABLE <VOC "RAW">>
		   <PLTABLE <VOC "RARE">>
		   <PLTABLE <VOC "MEDIUM">>
		   <PLTABLE <VOC "WELL-DONE"> <VOC "WELL">>
		   <PLTABLE <VOC "SPECIAL">>>>

<CONSTANT CHEESE-TYPE-TABLE
	  <PLTABLE <> <VOC "SWISS"> <VOC "AMERICAN">
		   <VOC "CHEDDAR">>>

<CONSTANT FRIES-ETC-TABLE
	  <PLTABLE T
		   <PLTABLE <VOC "SALAD">>
		   <PLTABLE <VOC "POTATO">
			    <VOC "BAKED">>
		   <PLTABLE <VOC "FRIES">
			    <VOC "FRENCH">>>>

<CONSTANT DRESSING-TYPE-TABLE
	  <PLTABLE T
		   <PLTABLE <VOC "FRENCH">>
		   <PLTABLE <VOC "ITALIAN">>
		   <PLTABLE <VOC "VINAIGRETTE">>
		   <PLTABLE <VOC "BLUE">
			    <VOC "CHEESE">>
		   <PLTABLE <VOC "ISLAND">
			    <VOC "THOUSAND">>>>

<CONSTANT DRESSING-WEIGHT-TABLE
	  <PLTABLE <> <VOC "DIET"> <VOC "REGULAR">>>

<CONSTANT POTATO-TYPE-TABLE
	  <PLTABLE T
		   <PLTABLE <VOC "LARGE"> <VOC "BIG">
			    <VOC "L">>
		   <PLTABLE <VOC "SMALL"> <VOC "TINY">
			    <VOC "S">>>>

<CONSTANT DRINK-TYPE-TABLE
	  <PLTABLE <>
		   <VOC "JUICE"> <VOC "BEER">
		   <VOC "WINE"> <VOC "SODA">>>

<CONSTANT JUICE-TYPE-TABLE
	  <PLTABLE <>
		   <VOC "ORANGE"> <VOC "APPLE">
		   <VOC "GRAPEFRUIT"> <VOC "MANGO">>>

<CONSTANT BEER-TYPE-TABLE
	  <PLTABLE <>
		   <VOC "DARK"> <VOC "LIGHT">
		   <VOC "ALE"> <VOC "DRAUGHT">>>

<CONSTANT WINE-COLOR-TABLE
	  <PLTABLE <>
		   <VOC "RED"> <VOC "WHITE">>>

<CONSTANT WINE-TYPE-TABLE
	  <PLTABLE <>
		   <VOC "DRY"> <VOC "SWEET">>>

<CONSTANT WINE-COUNTRY-TABLE
	  <PLTABLE T
		   <PLTABLE <VOC "FRENCH">>
		   <PLTABLE <VOC "GERMAN">>
		   <PLTABLE <VOC "CALIFORNIA">
			    <VOC "AMERICAN">>>>

<CONSTANT SODA-TABLE
	  <PLTABLE T
		   <PLTABLE <VOC "COLA">>
		   <PLTABLE <VOC "ORANGE">>
		   <PLTABLE <VOC "LEMON-LIME">
			    <VOC "LIME">
			    <VOC "LEMON">>>>

<CONSTANT SODA-TYPE-TABLE
	  <PLTABLE <>
		   <VOC "DIET"> <VOC "REGULAR">>>

<CONSTANT CAFFEINE-TABLE
	  <PLTABLE <>
		   <VOC "WITH"> <VOC "WITHOUT">>>

<CONSTANT WATER-TABLE
	  <PLTABLE <>
		   <VOC "REGULAR"> <VOC "MINERAL">
		   <VOC "DISTILLED">>>

;<SETG MEAL
      <ITABLE 27 0>>
;<GDECL (MEAL) TABLE>
		
<DEFINE GET-WORD ("AUX" WORD)
	 <REPEAT (N)
		 <TELL CR ">>">
		 <ZREAD ,P-INBUF ,P-LEXV>
		 <SET N <GETB ,P-LEXV ,P-LEXWORDS>>
		 <COND (<AND <WT? <SET WORD <ZGET ,P-LEXV ,P-LEXSTART>>
				  ,PS?BUZZ-WORD>
			     <G=? .N 2>>
			<SET WORD <ZGET ,P-LEXV <+ ,P-LEXSTART ,P-LEXELEN>>>)>
		 <COND (<G? .N 0>
			<COND (<EQUAL? .WORD ,W?QUIT ,W?Q>
			       <V-QUIT>)
			      (<EQUAL? .WORD ,W?RESTART>
			       <V-RESTART>)
			      (<EQUAL? .WORD ,W?RESTORE>
			       <V-RESTORE>)
			      (<EQUAL? .WORD ,W?SAVE>
			       <V-SAVE>)
			      (T
			       <RETURN>)>)>
		 <TELL "\"Pardon me, ">
		 <SIR-OR-MAAM>
		 <TELL "?\"" CR>>
	 .WORD>

<MSETG OPTION-TYPE 0>
<MSETG OPTION-OFFSET 1>
<MSETG OPTION-STRING 2>
<MSETG OPTION-LEN 3>
<MSETG OT-YES/NO 0>
<MSETG OT-WORD-STRING 1>
<MSETG OT-STRING 2>

<CONSTANT BURGER-OPTIONS <PLTABLE ,OT-WORD-STRING ,CHEESE-TYPE " cheese"
				  ,OT-YES/NO ,BBSAUCE? "bar-b-que sauce"
				  ,OT-YES/NO ,BACON? "bacon"
				  ,OT-YES/NO ,MUSHROOMS? "mushrooms">>

<CONSTANT BAKED-POTATO-OPTIONS
	  <PLTABLE ,OT-YES/NO ,BUTTER? "butter"
		   ,OT-YES/NO ,CREAM? "sour cream"
		   ,OT-YES/NO ,YOGHURT? "yoghurt"
		   ,OT-YES/NO ,PARSLEY? "a dash of parsley"
		   ,OT-YES/NO ,CHIVES? "a sprinkle of chives">>

<DEFINE PRINT-WITH (OPTIONS NONE "AUX" (CT:FIX 0) (OFFS:FIX 1)
		    (LEN:FIX <ZGET .OPTIONS 0>))
  <REPEAT ()
    <COND (<T? <ZGET ,MEAL <ZGET .OPTIONS <+ .OFFS ,OPTION-OFFSET>>>>
	   <SET CT <+ .CT 1>>)>
    <COND (<G? <SET OFFS <+ .OFFS ,OPTION-LEN>> .LEN>
	   <RETURN>)>>
  <COND (<0? .CT>
	 <TELL .NONE>)
	(T
	 <SET OPTIONS <ZREST .OPTIONS 2>>
	 <REPEAT (VAL TYPE)
	   <COND (<T? <SET VAL <ZGET ,MEAL <ZGET .OPTIONS ,OPTION-OFFSET>>>>
		  <COND (<==? <SET TYPE <ZGET .OPTIONS ,OPTION-TYPE>>
			      ,OT-YES/NO>
			 <ZPRINT <ZGET .OPTIONS ,OPTION-STRING>>)
			(<==? .TYPE ,OT-WORD-STRING>
			 <MEAL-PRINT-WORD .VAL>
			 <ZPRINT <ZGET .OPTIONS ,OPTION-STRING>>)
			(<==? .TYPE ,OT-STRING>
			 <ZPRINT <ZGET .OPTIONS ,OPTION-STRING>>)>
		  <COND (<==? <SET CT <- .CT 1>> 1>
			 <TELL " and ">)
			(<0? .CT> <RETURN>)
			(T <TELL ", ">)>)>
	   <SET OPTIONS <ZREST .OPTIONS <* ,OPTION-LEN 2>>>>)>>

<DEFINE MEAL-PRINT-WORD (X)
  <COND (<INTBL? .X <ZREST ,CAPS 2> <ZGET ,CAPS 0>>
	 <IN-CAPS .X>)
	(T
	 <TELL WORD .X>)>>

<DEFINE REPEAT-ORDER R-O ("AUX" (CNT:FIX 0) A B C D E)
	 <COND (<==? <SET A <ZGET ,MEAL ,BURGER-TYPE>> ,W?SPECIAL>
		<TELL "the special">
		<RETURN T .R-O>)>
	 <TELL "a ">
	 <MEAL-PRINT-WORD .A>
	 <TELL " burger with ">
	 <PRINT-WITH ,BURGER-OPTIONS "nothing on it">
	 <TELL ", ">
	 <COND (<T? <SET A <ZGET ,MEAL ,POTATO-TYPE>>>
		<TELL "a ">
		<DO-PRINT-WORD .A>
		<TELL " baked potato with ">
		<PRINT-WITH ,BAKED-POTATO-OPTIONS "nothing on it">)
	       (<T? <ZGET ,MEAL ,SALAD?>>
		<TELL "a salad with ">
		<SET A <ZGET ,MEAL ,DRESSING-TYPE>>
		<COND (<ZERO? .A>
		       <TELL "no">)
		      (T
		       <DO-PRINT-WORD <ZGET ,MEAL ,DRESSING-WEIGHT>>
		       <TELL " ">
		       <COND (<EQUAL? .A ,W?FRENCH ,W?ITALIAN>
			      <IN-CAPS .A>)
			     (<EQUAL? .A ,W?BLUE>
			      <TELL "blue cheese">)
			     (<EQUAL? .A ,W?ISLAND>
			      <TELL "Thousand Island">)
			     (T
			      <DO-PRINT-WORD .A>)>)>
		<TELL " dressing">)
	       (<T? <ZGET ,MEAL ,FRIES?>>
		<TELL "an order of fries">
		<COND (<T? <ZGET ,MEAL ,KETCHUP?>>
		       <TELL " with ketchup">)>)>
	 <TELL ", and ">
	 <SET E <ZGET ,MEAL ,DRINK?>>
	 <COND (<ZERO? .E>
		<TELL "no ">)>
	 <SET A <ZGET ,MEAL ,DRINK-TYPE>>
	 <COND (<==? .A ,W?BEER>
		<SET A <ZGET ,MEAL ,BEER-TYPE>>
		<COND (<==? .A ,W?ALE>
		       <COND (<T? .E>
			      <TELL "an ">)>
		       <DO-PRINT-WORD .A>)
		      (T
		       <DO-PRINT-WORD .A>
		       <TELL " beer">)>)
	       (<==? .A ,W?WINE>
		<DO-PRINT-WORD <ZGET ,MEAL ,WINE-COLOR>>
		<TELL ", ">
		<DO-PRINT-WORD <ZGET ,MEAL ,WINE-TYPE>>
		<TELL " ">
		<COND (<==? <ZGET ,MEAL ,WINE-COUNTRY> ,W?CALIFORNIA>
		       <TELL "Californian">)
		      (T
		       <IN-CAPS <ZGET ,MEAL ,WINE-COUNTRY>>)>
		<TELL " wine">)
	       (<==? .A ,W?SODA>
		<DO-PRINT-WORD <ZGET ,MEAL ,SODA-TYPE>>
		<TELL " ">
		<COND (<==? <ZGET ,MEAL ,CAFFEINE?> ,W?WITHOUT>
		       <TELL "caffeine-free ">)>
		<DO-PRINT-WORD <ZGET ,MEAL ,SODA>>
		<COND (<N==? <ZGET ,MEAL ,SODA> ,W?COLA>
		       <TELL " soda">)>)
	       (T
		<DO-PRINT-WORD <ZGET ,MEAL ,JUICE-TYPE>>
		<TELL " juice">)>
	 <SET A <ZGET ,MEAL ,WATER?>>
	 <COND (<T? .A>
		<TELL ", with a glass of ">
		<COND (<NOT <EQUAL? .A ,W?REGULAR>>
		       <DO-PRINT-WORD .A>
		       <PRINTC 32>)>
		<TELL "water on the side">)>>		       
	 
"Expects a W?XXX."

<DEFINE START-CAPS ()
	<DIROUT ,D-SCREEN-OFF>
	<DIROUT ,D-TABLE-ON ,SL-TABLE>>

<DEFINE END-CAPS EC ("OPT" (ALLWORDS? <>) "AUX" (CNT:FIX 2) LEN:FIX X)
	<DIROUT ,D-TABLE-OFF>
	<DIROUT ,D-SCREEN-ON>
	<SET LEN <ZGET ,SL-TABLE 0>>
	<SET LEN <+ .LEN 1>>
	<ZPUT ,SL-TABLE 0 0>
	<COND (<1? .LEN> <RETURN T .EC>)>
	<REPEAT ((LC %<ASCII !\ >))
		<SET X <GETB ,SL-TABLE .CNT>>
		<COND (<AND <G=? .X %<ASCII !\a>>
			    <L=? .X %<ASCII !\z>>>
		       <COND (<OR <==? .CNT 2>
				  <AND <T? .ALLWORDS?>
				       <==? .LC %<ASCII !\ >>>>
			      <SET X <- .X:FIX 32>>)>)>
		<PRINTC .X>
		<SET LC .X>
		<COND (<G? <SET CNT <+ .CNT 1>> .LEN>
		       <RETURN>)>>>

<DEFINE IN-CAPS (X)
	 <START-CAPS>
	 <TELL WORD .X>
	 <END-CAPS>>

<DEFINE SIR-OR-MAAM ()
	 <COND (<ZERO? ,SEX>
		<TELL "sir">)
	       (T
		<TELL "ma'am">)>>

<DEFINE COOPERATE ()
	 <TELL "\"" PNEXT ,COOPS ", ">
	 <SIR-OR-MAAM>
	 <TELL ". ">>

<CONSTANT COOPS
      <TABLE (LENGTH PATTERN (BYTE [REST WORD]))
	     #BYTE 0 "Please cooperate" "Don't confuse me" "Come now">>		

<DEFINE SAY-MUZAK ("OPT" (X -1))
	 <COND (<==? .X -1>
		<SET X <TUNE-SELECTOR>>)>
	 <COND (<ZERO? .X>
		<TELL "\"The Girl From Ipanema,\" with lots of strings">)
	       (<EQUAL? .X 1>
		<TELL "the theme from ">
		<ITALICIZE "Shaft">)
	       (<EQUAL? .X 3>
		<TELL "something icky by John Denver">)
	       (<EQUAL? .X 4>
		<TELL "an especially easy-listening version of \"Do You Know the Way to San Jose?\" without any of the twiddly bits">)
	       (<EQUAL? .X 6>
		<TELL "something by Andrew Lloyd Webber that's a bit like something else you can't remember">)
	       (<EQUAL? .X 7>
		<TELL "an instrumental version of \"Yesterday,\" which should help Paul McCartney pay for ">
		<ITALICIZE "Give My Regards to Broad Street">)
	       (<EQUAL? .X 9>
		<TELL "the theme from ">
		<ITALICIZE "Un Homme et Une Femme">)
	       (<==? .X 10>
		<TELL
		 "\"Blowin' in the Wind,\" performed by an all-string orchestra">)
	       (<==? .X 13>
		<TELL "\"You Are So Beautiful,\" murdered by Lionel Richie">)
	       (<==? .X 15>
		<TELL
		 "\"(I Can't Get No) Satisfaction,\" crooned by Barry Manilow">)
	       (<==? .X 16>
		<TELL "\"I Write the Songs,\" crooned by Mick Jagger">)
	       (<==? .X 18>
		<TELL "Herb Alpert and the Tijuana Brass doing a Sex Pistols medley">)
	       (<==? .X 20>
		<TELL "the theme song to \"Mister Ed,\" hummed backwards by Billy Graham">)
	       (T
		<TELL "\"" PONE ,BAD-TUNES
		      ",\" " PONE ,TOONS>)>>

<SETG MMOVES 8>

<GDECL (MMOVES) FIX>

<DEFINE I-MATRON-ANSWERS IMA ("OPTIONAL" (CR T) 
			   "AUX" (TR <>) (ST <>) (EITHER <>))
	 <COND (<HERE? TROPHY-ROOM>
		<SET TR T>
		<SET EITHER T>)
	       (<HERE? OUTSIDE-MANSION>
		<SET ST T>
		<SET EITHER T>)>
	 <SETG MMOVES <- ,MMOVES:FIX 1>>
	 <COND (<EQUAL? ,MMOVES 7>
		<MAKE ,MATRON ,ANSWERING-DOOR>
		<RETURN <> .IMA>)
	       (<EQUAL? ,MMOVES 6>
		<UNMAKE ,MANSION-DOOR ,LOCKED>
		<COND (<T? .EITHER>
		       <COND (<T? .CR>
			      <ZCRLF>)>
		       <COND (<T? .ST>
			      <TELL "You hear somebody ">)
			     (T
			      <TELL CTHE ,MATRON " is ">)>
		       <TELL "unlocking " THE ,MANSION-DOOR ,PERIOD>
		       <RETURN T .IMA>)>
		<RETURN <> .IMA>)
	       (<EQUAL? ,MMOVES 5>
		<MAKE ,MANSION-DOOR ,OPENED>
		<MOVE ,MATRON ,OUTSIDE-MANSION>
		<COND (<T? .ST>
		       <COND (<T? .CR>
			      <ZCRLF>)>
		       <THIS-IS-IT ,PMATRON>
		       <TELL CTHE ,MANSION-DOOR
" creaks open, and an old matron appears at the threshold." CR>
		       <RETURN T .IMA>)
		      (<T? .TR>
		       <COND (<T? .CR>
			      <ZCRLF>)>
		       <THIS-IS-IT ,PMATRON>
		       <TELL CTHE ,MATRON " opens " THE ,MANSION-DOOR
" and steps out onto the threshold." CR>
		       <RETURN T .IMA>)>
		<RETURN <> .IMA>)
	       (<EQUAL? ,MMOVES 4>
		<COND (<T? .EITHER>
		       <COND (<T? .CR>
			      <ZCRLF>)>
		       <COND (<T? .ST>
			      <TELL CTHE ,MATRON
" pauses at the threshold and looks around suspiciously." CR>
			      <RETURN T .IMA>)>
		       <TELL "You hear " THE ,MATRON
			     " muttering something just outside." CR>
		       <RETURN T .IMA>)>
		<RETURN <> .IMA>)
	       (<EQUAL? ,MMOVES 3>
		<UNMAKE ,MANSION-DOOR ,OPENED>
		<MOVE ,MATRON ,TROPHY-ROOM>
		<COND (<T? .EITHER>
		       <COND (<T? .CR>
			      <ZCRLF>)>
		       <SETG P-HER-OBJECT <COND (<T? .ST> ,NOT-HERE-OBJECT)
						(T ,MATRON)>>
		       <TELL CTHE ,MATRON
" steps back into the mansion and swings " THE ,MANSION-DOOR " shut." CR>
		       <RETURN T .IMA>)>
		<RETURN <> .IMA>)
	       (<EQUAL? ,MMOVES 2>
		<MAKE ,MANSION-DOOR ,LOCKED>
		<COND (<T? .EITHER>
		      <COND (<T? .CR>
			     <ZCRLF>)>
		      <COND (<T? .TR>
			     <TELL CTHE ,MATRON " is beginning to lock ">)
			    (T
			     <TELL "You hear somebody locking ">)>
		      <TELL THE ,MANSION-DOOR ,PERIOD>
		      <RETURN T .IMA>)>
		<RETURN <> .IMA>)
	       (<AND <EQUAL? ,MMOVES 1>
		     <T? .EITHER>>
		<COND (<T? .CR>
		       <ZCRLF>)>
		<TELL "You hear the final clicks of "
		      THE ,MANSION-DOOR " being locked." CR>
		<RETURN T .IMA>)
	       (<ZERO? ,MMOVES>
		<SETG MMOVES 8>
		<UNMAKE ,MANSION-BELL ,TOUCHED>
		<DEQUEUE I-MATRON-ANSWERS>
		<UNMAKE ,MATRON ,ANSWERING-DOOR>
		<COND (<T? .ST>
		       <COND (<T? .CR>
			      <ZCRLF>)>
		       <TELL
			"You hear footsteps fade off into the mansion." CR>
		       <RETURN T .IMA>)
		      (<T? .TR>
		       <COND (<T? .CR>
			      <ZCRLF>)>
		       <TELL CTHE ,MATRON " turns away from "
THE ,MANSION-DOOR ", squints in your " D ,INTDIR
" and instantly raises " THE ,EGUN ". \"Robbers!\"" CR>
		       <QUEUE I-ROBBERS 1>
		       <RETURN T .IMA>)
		      (<HERE? IN-PORCH>
		       <COND (<T? .CR>
			      <ZCRLF>)>
		       <TELL 
"You hear someone humming to the music in the adjacent room." CR>
		       <RETURN T .IMA>)>
		<RETURN <> .IMA>)>
	 <RETURN <> .IMA>>
		     
<DEFINE I-ROBBERS IR ("OPTIONAL" (CR T))
	 <COND (<HERE? TROPHY-ROOM>
		<COND (<T? .CR>
		       <ZCRLF>)>
		<TELL "You assume one of three things must be true: " THE ,MATRON " is too old to actually shoot you with " THE ,EGUN ", you are fast enough to get out of her way in time or this is all a bad dream. However, the bullet you receive right between the eyes convinces you that you were unfortunately wrong on all three counts.">
		<JIGS-UP>
		<RETURN T .IR>)
	       (T
		<RETURN <> .IR>)>>
		
<MSETG MACAW-POLITICS 0>
<MSETG MACAW-SQUEAKS 1>
<MSETG MACAW-FEEBLE 2>
<MSETG MACAW-SOUNDS 3>
<MSETG MACAW-ACTIONS 4>
<MSETG MACAW-BITES 5>
<MSETG MACAW-SLOGANS 5>
<MSETG MACAW-RIGHT-SLOGANS 6>
<MSETG MACAW-LEFT-SLOGANS 7>

<MSETG MACAW-LEFT 1>
<MSETG MACAW-RIGHT 2>

<CONSTANT MACAW-TABLE
	<TABLE <>
	       <TABLE (LENGTH PATTERN (BYTE [REST WORD]))
		      #BYTE 0
		       " groans defiance at you"
		       " lets off an obscene squeak"
		       " whispers at the top of its voice">
	       <TABLE (LENGTH PATTERN (BYTE [REST WORD]))
		      #BYTE 0
		       " looks at you with one half-closed eye"
		       " thinks about scratching its wing, then thinks better of it"
		       " wobbles back and forth on its perch">
	       <TABLE (LENGTH PATTERN (BYTE [REST WORD]))
		      #BYTE 0
		       " roars defiance at you"
		       " lets off an obscene whistle"
		       " screeches at the top of its voice">
	       <TABLE (LENGTH PATTERN (BYTE [REST WORD]))
		      #BYTE 0
		       " looks at you with one eye, then the other"
		       " scratches its wing"
		       " thinks about scratching a wing, then realises that the one it was thinking about is missing"
		       "'s malignant beady eyes are staring around, looking
for some hate-object to get over-excited about"
		       " paces back and forth on its perch"
		       " flutters excitedly">
	       <TABLE (LENGTH PATTERN (BYTE [REST WORD]))
		      #BYTE 0
		       " crushes your finger in a vise-like beak-grip"
		       " lunges at your fingers"
		       " tears savagely at your hand"
		       " strikes a jack-hammer blow at you">
	       <TABLE (LENGTH PATTERN (BYTE [REST WORD]))
		      #BYTE 0
		       "Death to the running dogs of imperialism"
		       "Power to the downtrodden masses"
		       "Workers of the world unite"
		       "Russia got Reagan's brain! Russia got Reagan's brain"
		       "Kill the pinko fascist commie Christian Democrats"
		       "The old lady is a Tory">
	       <TABLE (LENGTH PATTERN (BYTE [REST WORD]))
		      #BYTE 0
		       "Death to the communist dogs"
		       "Let's lob one into the men's room of the Kremlin"
		       "Today the Falklands, tomorrow the rest of the empire"
		       "Kill the fascist pinko neo-Nazi red Social Democrats"
		       "The old lady is a liberal">>>

<DEFINE I-MACAW IM ("OPTIONAL" (CR T) "AUX" (E 0))
	 <COND (<NOT <HERE? IN-PORCH>>
		<RETURN <> .IM>)
	       (<ZERO? .CR>
		T)
	       (<IS? ,MACAW ,SEEN>
		<UNMAKE ,MACAW ,SEEN>
		<RETURN <> .IM>)
	       (<T? .CR>
		<ZCRLF>)>
	 <MAKE ,MACAW ,SEEN>
	 <TELL CTHE ,MACAW>
	 <COND (<PROB 40>
		<SET E <+ .E 1>>)>
	 <TELL PNEXT
	       <COND (<IS? ,MACAW ,SHITTY>
		      <ZGET ,MACAW-TABLE <+ .E ,MACAW-SQUEAKS>>)
		     (T
		      <ZGET ,MACAW-TABLE <+ .E ,MACAW-SOUNDS>>)>>
	 <COND (<==? .E 0>
		<TELL ". \"">
		<TELL PNEXT <ZGET ,MACAW-TABLE
				  <+ <ZGET ,MACAW-TABLE ,MACAW-POLITICS>
				     ,MACAW-SLOGANS>>>
		<COND (<IS? ,MACAW ,SHITTY>
		       <TELL ".\"" CR>)
		      (T
		       <TELL "!\"" CR>)>)
	       (ELSE <TELL ,PERIOD>)>
	 T>

<MSETG RESET-MOUSY-SCRIPT 4>
<SETG MOUSY-SCRIPT 4>
<GDECL (MOUSY-SCRIPT) FIX>

<DEFINE I-MOUSY IM ("OPTIONAL" (CR T))
	 <COND (<IS? ,MOUSY ,SEEN>
		<UNMAKE ,MOUSY ,SEEN>
		<RETURN <> .IM>)>
	 <SETG MOUSY-SCRIPT <- ,MOUSY-SCRIPT:FIX 1>>
	 <COND (<T? .CR>
		<ZCRLF>)>
	 <COND (<EQUAL? ,MOUSY-SCRIPT 3>
		<TELL "\"As you can see, I'm ">
		<COND (<IS? ,MOUSY ,TOUCHED>
		       <TELL "still ">)>
		<TELL "very busy,\" remarks the mousy man">
		<COND (<IS? ,MOUSY ,TOUCHED>
		       <TELL " with a trace of annoyance." CR>
		       <RETURN T .IM>)>
		<TELL 
", gesturing at the pile of stamp albums. \"I have to cut all the stamps and permits off today's mail, and I still haven't finished yesterday's!\"" CR>
		<RETURN T .IM>)
	       (<EQUAL? ,MOUSY-SCRIPT 2>
		<COND (<VISIBLE? ,LEAFLET>
		       <MOVE ,MOUSYMAIL ,MOUSY>
		       <TELL 
"\"There!\" cries the mousy man with a triumphant ">
		       <SAY-SNIP>
		       <TELL
". \"That's yesterday's, all done!\" He picks up the uncut envelope on the floor and turns it this way and that">)
		      (T
		       <TELL 
"The mousy man turns an envelope over in his hand before snipping it to ribbons">)>
		<TELL 
". \"Drat,\" he mutters with a wistful sigh. \"" PNEXT ,MOUSY-WISHES
		 "...\"" CR>
		<RETURN T .IM>)
	       (<EQUAL? ,MOUSY-SCRIPT 1>
		<TELL "With a deft ">
		<SAY-SNIP>
		<TELL ", the mousy man cuts ">
		<COND (<IN? ,MOUSYMAIL ,MOUSY>
		       <ZREMOVE ,MOUSYMAIL>
		       <SETG P-IT-OBJECT ,NOT-HERE-OBJECT>
		       <TELL 
"the final envelope into ribbons. \"Postal Permit #3220,\" he sighs. \"Maybe I can trade it at the convention.\"" CR>
		       <RETURN T .IM>)>
		<TELL "another envelope into ">
		<COND (<IS? ,MOUSY ,TOUCHED>
		       <TELL 
"pieces. \"I really don't have time to chat,\" he remarks icily." CR>
		       <RETURN T .IM>)>
		<TELL "confetti. \""
PNEXT ,MOUSY-WISHES "...\" he sighs, half to himself." CR>
		<RETURN T .IM>)>
	 <TELL "The mousy man rises from his chair. \"I'm terribly sorry">
	 <COND (<IS? ,MOUSY ,TOUCHED>
		<TELL " again">)>
	 <TELL ",\" he says as he ">
	 <COND (<NOT <IS? ,FLAT-DOOR ,OPENED>>
		<TELL "opens the door and ">)>
	 <TELL "coaxes you back outside">
	 <COND (<IS? ,MOUSY ,TOUCHED>
		<TELL ,PCR>)
	       (T
		<TELL 
", \"but I haven't time to chat. Come back some other time.\"" CR CR>)>
	 <LEAVE-MOUSY>
	 <MAKE ,FLAT-DOOR ,OPENED>
	 <GOTO ,THALL>
	 <UNMAKE ,FLAT-DOOR ,OPENED>
	 <MAKE ,FLAT-DOOR ,LOCKED>
	 <REMOVE ,MOUSY>
	 <SETG P-IT-OBJECT ,FLAT-DOOR>
	 <ZCRLF>
	 <ITALICIZE "Bang">
	 <TELL "! " CTHE ,FLAT-DOOR " slams shut in your face." CR>
	 <RETURN T .IM>> 
		
<DEFINE LEAVE-MOUSY ()
	 <MAKE ,MOUSY ,TOUCHED>
	 <DEQUEUE I-MOUSY>
	 <SETG P-HIM-OBJECT ,NOT-HERE-OBJECT>
	 T>

<DEFINE SAY-SNIP ()
	 <HLIGHT ,H-ITALIC>
	 <TELL "snip">
	 <HLIGHT ,H-NORMAL>>

<CONSTANT MOUSY-WISHES
	<TABLE (LENGTH PATTERN (BYTE [REST WORD]))
	       #BYTE 0
	 "No Zalagasa 42 on this one, either. Someday, someday"
	 "Where are you, my little Ai-Ai? I know you're out there, somewhere"
	 "Still no Zalagasan Ai-Ai. I know I'll find one someday, but"
	 "My collection, almost complete! Just one Zalagasan 42 Ai-Ai">>

<SETG DSCRIPT 6>
<GDECL (DSCRIPT) FIX>

<DEFINE I-DMAN ID ("OPTIONAL" (CR T))
	 <COND (<IS? ,DMAN ,SEEN>
		<UNMAKE ,DMAN ,SEEN>
		<RETURN <> .ID>)
	       (<T? .CR>
		<ZCRLF>)>
	 <SETG DSCRIPT <- ,DSCRIPT:FIX 1>>
	 <COND (<EQUAL? ,DSCRIPT 5>
		<TELL 
"\"I'm authorized to accept both Beezer and US Excess,\" " 
		      THE ,DMAN " remarks hopefully." CR>
		<RETURN T .ID>)
	       (<EQUAL? ,DSCRIPT 4>
		<TELL CTHE ,DMAN " glances around the room. \"Just moved in, eh?\" he comments. \"Nice place.\"" CR>
		<RETURN T .ID>)
	       (<EQUAL? ,DSCRIPT 3>
		<TELL "\"The authorized charge is $41.75,\" " THE ,DMAN
		      " reminds you. \"Beezer or US Excess.\"" CR>
		<RETURN T .ID>)
	       (<EQUAL? ,DSCRIPT 2>
		<TELL CTHE ,DMAN 
" hums the TV jingles for Beezer and US Excess." CR>
		<RETURN T .ID>)
	       (<EQUAL? ,DSCRIPT 1>
		<TELL CTHE ,DMAN 
		      " clears his throat impatiently. \"Look">
		<LADY-OR-MISTER>
		<TELL 
", you don't have to accept this delivery if you don't want it.\"" CR>
		<RETURN T .ID>)>
	 <DMAN-LEAVES>
	 <TELL CTHE ,DMAN
" shrugs. \"All right, then, never mind. Good day.\"|
|
He shuts " THE ,FROOM-DOOR " as he leaves." CR>
	 <RETURN T .ID>>

<MSETG LLAMA-TIMER 0>
<MSETG LLAMA-CUTES 1>
<MSETG LLAMA-EATS 2>
<CONSTANT LLAMA-TABLE
	<TABLE 0
	       <TABLE (LENGTH PATTERN (BYTE [REST WORD]))
		      #BYTE 0 " blinks at you stupidly"
		         " emits a hoarse bleat"
			 " is pretending not to watch you"
			 " shakes itself and bleats">
	       <TABLE (LENGTH PATTERN (BYTE [REST WORD]))
		      #BYTE 0 " chomps eagerly on"
		         " pauses to bleat, then turns back to"
			 " is still eating">>>
			 			 
<DEFINE I-LLAMA IL ("OPTIONAL" (CR T) "AUX" (E <>) X:FIX)
	 <COND (<IS? ,LLAMA ,TOUCHED>
	        <SET E T>
		<SET X <ZGET ,LLAMA-TABLE ,LLAMA-TIMER>>
	 	<SET X <- .X 1>>
	 	<ZPUT ,LLAMA-TABLE ,LLAMA-TIMER .X>)>
	 <COND (<HERE? IN-FARM OUTSIDE-MANSION OUTSIDE-FORT>
		<COND (<T? .E>
		       <RETURN <> .IL>)
		      (<IS? ,LLAMA ,SEEN>
		       <UNMAKE ,LLAMA ,SEEN>
		       <RETURN <> .IL>)
		      (<PROB 80>
		       <RETURN <> .IL>)
		      (<T? .CR>
		       <ZCRLF>)>
		<MAKE ,LLAMA ,SEEN>
		<TELL
		 "You hear a sound like a wet oboe. Something is bleating ">
		<COND (<HERE? IN-FARM>
		       <TELL "outside." CR>
		       <RETURN T .IL>)>
		<TELL "to the ">
		<COND (<HERE? OUTSIDE-MANSION>
		       <TELL "south." CR>
		       <RETURN T .IL>)>
		<TELL "north." CR>
		<RETURN T .IL>)
	       (<NOT <HERE? OUTSIDE-FARM>>
		<RETURN <> .IL>)
	       (<ZERO? .E>
	        <COND (<IS? ,LLAMA ,SEEN>
		       <UNMAKE ,LLAMA ,SEEN>
		       <RETURN <> .IL>)
		      (<PROB 50>
		       <RETURN <> .IL>)
		      (<T? .CR>
		       <ZCRLF>)>
		<MAKE ,LLAMA ,SEEN>
		<TELL CTHE ,LLAMA 
		      PNEXT <ZGET ,LLAMA-TABLE ,LLAMA-CUTES> ,PERIOD>
		<RETURN T .IL>)
	       (<ZERO? .X>
		<UNMAKE ,LLAMA ,TOUCHED>
		<ZPUT ,LLAMA-TABLE ,LLAMA-TIMER 6>
		<MAKE ,LLAMA ,SEEN>
		<ZREMOVE ,TREATS>
		<COND (<T? .CR>
		       <ZCRLF>)>
		<TELL CTHE ,LLAMA
" finishes off " THE ,BAG " with a horrid little tuba-bleat of contentment." CR>
		<RETURN T .IL>)
	       (<IS? ,LLAMA ,SEEN>
		<UNMAKE ,LLAMA ,SEEN>
		<RETURN <> .IL>)
	       (<PROB 50>
		<RETURN <> .IL>)
	       (<T? .CR>
		<ZCRLF>)>
	 <MAKE ,LLAMA ,SEEN>
	 <TELL CTHE ,LLAMA PNEXT <ZGET ,LLAMA-TABLE ,LLAMA-EATS>
	       " the llama treats." CR>
	 T>
