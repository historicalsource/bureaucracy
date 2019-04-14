"CLOCKER for BUREAUCRACY: (C)1987 Infocom, Inc. All rights reserved."

<FILE-FLAGS MDL-ZIL?>

<USE "NEWSTRUC">

<SETG CLOCK-HAND <>>
;<SETG CLOCK-WAIT? <>>

<CONSTANT C-TABLE <ITABLE NONE 100>>
<GDECL (C-TABLE) TABLE>
<MSETG C-TABLELEN 100>
<SETG C-INTS 100>
<GDECL (C-INTS) FIX>

<MSETG C-INTLEN 4>	; "Length of an interrupt entry."
<MSETG C-RTN 0>	; "Offset of routine name."
<MSETG C-TICK 1>	; "Offset of count."
<MSETG H-HUNG 2>	; "For hunger stuff."
<DEFINE DEQUEUE (RTN)
	 <SET RTN <QUEUED? .RTN>>
	 <COND (<T? .RTN>
		<ZPUT .RTN ,C-RTN 0>)>>

<DEFINE QUEUED? QQ (RTN "AUX" C E)
	 <SET E <ZREST ,C-TABLE ,C-TABLELEN>>
	 <SET C <ZREST ,C-TABLE ,C-INTS>>
	 <REPEAT ()
		 <COND (<EQUAL? .C .E>
			<RETURN <> .QQ>)
		       (<EQUAL? <ZGET .C ,C-RTN> .RTN>
			<COND (<ZERO? <ZGET .C ,C-TICK>>
			       <RETURN <> .QQ>)
			      (T
			       <RETURN .C .QQ>)>)>
		 <SET C <ZREST .C ,C-INTLEN>>>>

"This version of QUEUE automatically enables as well."

<DEFINE QUEUE (RTN "OPTIONAL" (TICK:FIX -1) "AUX" C E (INT <>))
	 <SET E <ZREST ,C-TABLE ,C-TABLELEN>>
	 <SET C <ZREST ,C-TABLE ,C-INTS>>
	 <REPEAT ()
		 <COND (<EQUAL? .C .E>
			<COND (<T? .INT>
			       <SET C .INT>)
			      (T
			       <COND (<L? ,C-INTS ,C-INTLEN>
				      <TELL "[Too many interrupts!]" CR>)>
			       <SETG C-INTS <- ,C-INTS ,C-INTLEN>>
			       <SET INT <ZREST ,C-TABLE ,C-INTS>>)>
			<ZPUT .INT ,C-RTN .RTN>
			<RETURN>)
		       (<EQUAL? <ZGET .C ,C-RTN> .RTN>
			<SET INT .C>
			<RETURN>)
		       (<ZERO? <ZGET .C ,C-RTN>>
			<SET INT .C>)>
		 <SET C <ZREST .C ,C-INTLEN>>>
	 <COND (%<COND (<GASSIGNED? ZILCH>
			'<G? .INT ,CLOCK-HAND>)
		       (ELSE
			'<L=? <LENGTH .INT:<PRIMTYPE VECTOR>>
			      <LENGTH ,CLOCK-HAND:<PRIMTYPE VECTOR>>>)>
		<SET TICK <- <+ .TICK 3>>>)>
	 <ZPUT .INT ,C-TICK .TICK>
	 .INT>

<SETG HOURS 9>
<SETG MINUTES 0>
<CONSTANT DAY-TABLE
      <TABLE 6 "Mon" "Tues" "Wednes" "Thurs" "Fri" "Satur" "Sun">>
<GDECL (HOURS MINUTES) FIX (DAY-TABLE) TABLE>

<DEFINE CLOCKER CLOCKER ("AUX" E TICK:FIX RTN (FLG <>) (Q? <>) DAY:FIX)
	 <COND (<T? ,CLOCK-WAIT?>
	        <SETG CLOCK-WAIT? <>>
	        <RETURN <> .CLOCKER>)>
	 <SETG CLOCK-HAND <ZREST ,C-TABLE ,C-INTS>>
	 <SET E <ZREST ,C-TABLE ,C-TABLELEN>>
	 <REPEAT ()
		 <COND (<EQUAL? ,CLOCK-HAND .E>
		        <SETG MINUTES <+ ,MINUTES:FIX 1>>
			<COND (<G? ,MINUTES:FIX 59>
			       <SETG MINUTES 0>
			       <SETG HOURS <+ ,HOURS:FIX 1>>
			       <COND (<G? ,HOURS:FIX 23>
				      <SETG HOURS 0>
				      <SET DAY <ZGET ,DAY-TABLE 0>>
				      <SET DAY <+ .DAY 1>>
				      <COND (<G? .DAY 7>
					     <SET DAY 1>)>
				      <ZPUT ,DAY-TABLE 0 .DAY>)>)>
			<RETURN>)
		       (<T? <ZGET ,CLOCK-HAND ,C-RTN>>
			<SET TICK <ZGET ,CLOCK-HAND ,C-TICK>>
			<COND (<L? .TICK -1>
			       <SET TICK <- 0 .TICK>>
			       <ZPUT ,CLOCK-HAND ,C-TICK <- .TICK 3>>
			       <SET Q? ,CLOCK-HAND>)
			      (<T? .TICK>
			       <COND (<G? .TICK 0>
				      <SET TICK <- .TICK 1>>
				      <ZPUT ,CLOCK-HAND ,C-TICK .TICK>)>
			       <COND (<T? .TICK>
				      <SET Q? ,CLOCK-HAND>)>
			       <COND (<NOT <G? .TICK 0>>
				      <SET RTN
					   <ZGET ,CLOCK-HAND ,C-RTN>>
				      <COND (<ZERO? .TICK>
					     <ZPUT ,CLOCK-HAND ,C-RTN 0>)>
				      <COND (<ZAPPLY .RTN>
					     <SET FLG T>)>
				      <COND (<AND <ZERO? .Q?>
						<T? <ZGET ,CLOCK-HAND ,C-RTN>>>
					     <SET Q? T>)>)>)>)>
		 <SETG CLOCK-HAND <ZREST ,CLOCK-HAND ,C-INTLEN>>
		 <COND (<ZERO? .Q?>
			<SETG C-INTS <+ ,C-INTS ,C-INTLEN>>)>>
	 <RETURN .FLG .CLOCKER>>

; "This runs every turn..."
<MSETG DELAY-FACTOR 3>
<SETG BP-DELAY 2>

<DEFINE I-BLOOD-PRESSURE ("AUX" (SYSTOLIC:FIX <GET-SYSTOLIC>)
			  (DIASTOLIC:FIX <ANDB ,BP *377*>))
	<COND (<EQUAL? .SYSTOLIC 120>
	       <>)
	      (<L? <SETG BP-DELAY <- ,BP-DELAY:FIX 1>> 1>
	       <SETG BP-DELAY ,DELAY-FACTOR>
	       <COND (<G? .SYSTOLIC 120>
		      <UPDATE-BP -2 T T>)
		     (<L? .SYSTOLIC 120>
		      <UPDATE-BP 2 T T>)>)>>