"MAZE-PROG for BUREAUCRACY: Copyright (C)1987 Infocom, Inc.
 All rights reserved."

<FILE-FLAGS MDL-ZIL?>

<INCLUDE "FORMDEFS" "COMPUTERDEFS">

<MSETG MAX-CHARS <* ,COMPUTER-HEIGHT ,COMPUTER-WIDTH>>
<MSETG MAX-CHARS/4 </ ,MAX-CHARS 4>>
<MSETG MAX-CHARS/16 </ ,MAX-CHARS 16>>
<MSETG QSIZE </ ,MAX-CHARS 4>>
<MSETG COMPUTER-HEIGHT/2 </ ,COMPUTER-HEIGHT 2>>
<MSETG COMPUTER-WIDTH/2 </ ,COMPUTER-WIDTH 2>>

<SETG20 TST
	<IVECTOR ,COMPUTER-WIDTH '<ISTRING ,COMPUTER-HEIGHT <ASCII 32>>>>

<DEFINE20 LD-FILE (FILE
		     "AUX" (CH <OPEN "READ" .FILE>) N:FIX
			   (TS <STACK <ISTRING ,COMPUTER-WIDTH>>)
			   (COLS:VECTOR ,TST) (CS <1 .COLS>))
	<COND (.CH
	       <SET N <MIN ,MAX-CHARS <FILE-LENGTH .CH>>>
	       <REPEAT (RD)
	         <COND (<0? <SET RD <READSTRING .TS .CH " ">>>
			<RETURN>)>
		 <COND (<==? .RD <+ <LENGTH .CS> 1>>
			<SUBSTRUC .TS 0 <- .RD 1> .CS>
			<SET COLS <REST .COLS>>
			<SET CS <1 .COLS>>)
		       (<G? .RD <LENGTH .CS>>
			<SET COLS <REST .COLS>>
			<SET CS <1 .COLS>>
			<SUBSTRUC .TS 0 .RD .CS>
			<SET CS <REST .CS .RD>>)
		       (T
			<SUBSTRUC .TS 0 .RD .CS>
			<SET CS <REST .CS .RD>>)>>
	       <CLOSE .CH>)
	      (ELSE .CH)>>

<DEFINE20 TABLEIZE ( )
	  <MAPF ,TABLE
	    <FUNCTION (ST:STRING "AUX" (FIRST? T))
	      <MAPF ,TABLE
	        <FUNCTION (CHR:CHARACTER "AUX" NEW)
		  <SET NEW <TRANS .CHR>>
		  <COND (.FIRST?
			 <SET FIRST? <>>
			 <MAPRET '(BYTE) <CHTYPE .NEW FIX>>)
			(T
			 <CHTYPE .NEW FIX>)>>
		.ST>>
	    ,TST>>

" 0 ==> space, 1...26 ==> A...Z, 27...53 ==> a...z,
  54 ==> .
  55 ==> ,
  56 ==> ;
  57...63 ==> 0...6
"

<DEFINE20 TRANS (CHAR)
	  <SET CHAR <CHTYPE .CHAR FIX>>
	  <COND (<==? .CHAR 32> 0)
		(<AND <G=? .CHAR <ASCII !\A>>
		      <L=? .CHAR <ASCII !\Z>>>
		 <- .CHAR <ASCII !\A> -1>)
		(<AND <G=? .CHAR <ASCII !\a>>
		      <L=? .CHAR <ASCII !\z>>>
		 <- .CHAR <ASCII !\a> -27>)
		(<AND <G=? .CHAR <ASCII !\0>>
		      <L=? .CHAR <ASCII !\6>>>
		 <- .CHAR <ASCII !\0> -57>)
		(<==? .CHAR <ASCII !\.>> 54)
		(<==? .CHAR <ASCII !\,>> 55)
		(<==? .CHAR <ASCII !\;>> 56)>>
		
<LD-FILE "SS:<BUREAUCRACY>TEXT.FILE">

<CONSTANT PROG-TABLE <TABLEIZE>>

<MSETG QLEFT 0>
<MSETG QRIGHT 1>
<MSETG QTOP 2>
<MSETG QBOT 3>
			  
<CONSTANT PUNCT-TABLE
	  <TABLE (PURE BYTE)
		 %<ASCII !\.> %<ASCII !\,> %<ASCII !\;>>>

<DEFINE PROG-FIRST (A B C)
	<DO-PROG 0 *100*>>

<DEFINE PROG-SECOND (A B C)
	<DO-PROG 1 *200*>>

<DEFINE PROG-THIRD (A B C)
	<DO-PROG 2 *300*>>

<DEFINE PROG-FOURTH (A B C)
	<DO-PROG 3 *300*>>

<CONSTANT QTOPS
	  <PTABLE (BYTE) 0 0 </ ,COMPUTER-HEIGHT 2> </ ,COMPUTER-HEIGHT 2>>>
<CONSTANT QLEFTS
	  <PTABLE (BYTE) </ ,COMPUTER-WIDTH 2> 0 0 </ ,COMPUTER-WIDTH 2>>>

<ROUTINE-FLAGS CLEAN-STACK?>
<DEFINE DO-PROG DP (NQN "OPT" (MB 0) "AUX" NBCHRS NGCHRS (QN .NQN))
	<COND (<G=? .NQN 0>
	       <CLEAR-QUADRANT .QN>)
	      (T
	       <SET QN 0>)>
	; "Clear written bits for appropriate quadrants"
	<REPEAT ((N <- 4 .QN>) RT TOP (CQ 3))
	  <COND (<==? .CQ 0>
		 <SET RT <ZREST ,PROG-TABLE ,COMPUTER-WIDTH>>
		 <SET TOP 0>)
		(<==? .CQ 1>
		 <SET RT ,PROG-TABLE>
		 <SET TOP 0>)
		(<==? .CQ 2>
		 <SET RT ,PROG-TABLE>
		 <SET TOP </ ,COMPUTER-HEIGHT 2>>)
		(T
		 <SET RT <REST ,PROG-TABLE ,COMPUTER-WIDTH>>
		 <SET TOP </ ,COMPUTER-HEIGHT 2>>)>
	  <PUTB ,LAST-USED <* .CQ 2> 255>
	  <PUTB ,LAST-USED <+ <* .CQ 2> 1> 255>
	  <REPEAT (I (CT 0) TBL)
		  <SET TBL <ZREST <ZGET .RT .CT> .TOP>>
		  <SET I 0>
		  <REPEAT ()
			  <PUTB .TBL .I <ANDB <GETB .TBL .I> *77*>>
			  <COND (<G=? <SET I <+ .I 1>> </ ,COMPUTER-HEIGHT 2>>
				 <RETURN>)>>
		  <COND (<G=? <SET CT <+ .CT 1>> </ ,COMPUTER-WIDTH 2>>
			 <RETURN>)>>
	  <SET CQ <- .CQ 1>>
	  <COND (<L=? <SET N <- .N 1>> 0> <RETURN>)>>
	<COND (<L? .NQN 0> <RETURN T .DP>)>
	<SET NBCHRS <* </ ,MAX-CHARS 4> <+ .QN 1>>>
	<SET NGCHRS <* </ ,MAX-CHARS 16> <+ <* .QN 2> 1>>>
	<SET NBCHRS <- .NBCHRS .NGCHRS>>
	; "e.g., q0 makes 1/4 screen's worth of chars; 1/4 of those
	   (1/16 of total) will be good;
	   q1 is 1/2 & 3/16;
	   q2 is 3/4 & 5/16;
	   q3 is 1 and 7/16.  q0 good chars are confined to q0; q1 to
	   q0&q1, etc.  Further, a bad char may not overwrite an existing
	   good char, but q0 clears all good bits; q1 all but q0; q2 all
	   but q0 & q1; etc"
	<REPEAT ()
		<COND (<NOT <L? <SET NBCHRS <- .NBCHRS 1>> 0>>
		       <GEN-BAD-CHAR .QN .MB>)>
		<COND (<NOT <L? <SET NGCHRS <- .NGCHRS 1>> 0>>
		       <GEN-GOOD-CHAR .QN .MB>)>
		<COND (<AND <L=? .NGCHRS 0>
			    <L=? .NBCHRS 0>>
		       <RETURN>)>>
	<>>

<DEFINE GEN-BAD-CHAR (QN:FIX MB "AUX" BQ X Y)
  <SET BQ <ZRANDOM 3>>
  <COND (<==? .BQ .QN>
	 <SET BQ 0>)>
  <SET X <ZRANDOM </ ,COMPUTER-WIDTH 2>>>
  <SET X <+ <SET X <- .X 1>> <GETB ,QLEFTS .BQ>>>
  <SET Y <ZRANDOM </ ,COMPUTER-HEIGHT 2>>>
  <SET Y <+ <SET Y <- .Y 1>> <GETB ,QTOPS .BQ>>>
  <COND (<TEST-CHAR .X .Y .MB <>>
	 <FORCE-CHAR <GEN-CHAR .X .Y> .X .Y>)>>

<DEFINE TEST-CHAR (X Y BIT "OPT" (SET? T) "AUX" TBL CHR NB)
  <SET TBL <ZGET ,PROG-TABLE .X>>
  <SET NB <ANDB <SET CHR <GETB .TBL .Y>> *300*>>
  <COND (<AND <T? .NB>
	      <L=? .NB .BIT>>
	 ; "Q2 can write on stuff dumped by the Q3 and Q4 progs, but
	    not Q1 or Q2..."
	 <>)
	(.SET?
	 <PUTB .TBL .Y <ORB .CHR *100*>>
	 <INVERT-CHAR .CHR>)
	(T T)>>

<CONSTANT LAST-USED <TABLE (BYTE) 0 0 0 0 0 0 0 0>>

<ROUTINE-FLAGS CLEAN-STACK?>
<DEFINE GEN-GOOD-CHAR (QN:FIX MB:FIX "AUX" GQ X Y (QCT 0))
  <SET GQ <- <SET GQ <ZRANDOM <+ <* .QN 2> 1>>> 1>>
  <COND (<G=? .GQ .QN> <SET GQ .QN>)>
  <SET X <ZRANDOM </ ,COMPUTER-WIDTH 2>>>
  <SET X <- .X 1>>
  <SET Y <- <SET Y <ZRANDOM </ ,COMPUTER-HEIGHT 2>>> 1>>
  <PROG (CL CT RX RY GQ*2)
    <SET CL <GETB ,QLEFTS .GQ>>
    <SET CT <GETB ,QTOPS .GQ>>
    <SET RX <+ .CL .X>>
    <SET RY <+ .CT .Y>>
    <REPEAT (CHR (DUMP? <>))
        <COND (<G? .QCT 5> <RETURN>)
	      (<NOT <SET CHR <TEST-CHAR .RX .RY .MB>>>
	       <COND (<NOT .DUMP?>
		      <SET DUMP? T>
		      ; "Start at virtual top left (this is actual char
		         addr last written in this mode, so OK to add
			 1 below"
		      <COND (<==? <SET X
				       <GETB ,LAST-USED <SET GQ*2 <* .GQ 2>>>>
				  255>
			     <SET X -1>)>
		      <COND (<==? <SET Y <GETB ,LAST-USED <+ .GQ*2 1>>>
				  255>
			     <SET Y 0>)>
		      <COND (<G=? .Y </ ,COMPUTER-HEIGHT 2>>
			     <SET X </ ,COMPUTER-WIDTH 2>>)>
		      <SET RX <+ .CL .X>>
		      <SET RY <+ .CT .Y>>)>
	       <PROG ()
	         <COND (<G? .QCT 5> <RETURN>)
		       (<G=? <SET X <+ .X 1>> </ ,COMPUTER-WIDTH 2>>
		        ; "End of line, so go to next"
		        <COND (<G=? <SET Y <+ .Y 1>> </ ,COMPUTER-HEIGHT 2>>
			       ; "End of quadrant, so go to next"
			       <PUTB ,LAST-USED .GQ*2 .X>
			       <PUTB ,LAST-USED <+ .GQ*2 1> .Y>
			       <SET QCT <+ .QCT 1>>
			       <COND (<G? <SET GQ <+ .GQ 1>> .QN>
				      <SET GQ 0>)>
			       <SET CL <GETB ,QLEFTS .GQ>>
			       <SET CT <GETB ,QTOPS .GQ>>
			       <SET GQ*2 <* .GQ 2>>
			       ; "255 means never touched, so make sure we
				  get 0"
			       <COND (<==? <SET X <GETB ,LAST-USED .GQ*2>>
					   255>
				      <SET X -1>)>
			       <COND (<==? <SET Y
						<GETB ,LAST-USED <+ .GQ*2 1>>>
					   255>
				      <SET Y 0>)
				     (<G=? .Y </ ,COMPUTER-HEIGHT 2>>
				      <SET X </ ,COMPUTER-WIDTH 2>>)>
			       <SET RY <+ .Y .CT>>
			       <AGAIN>)
			      (T
			       <SET X 0>)>
		      <SET RY <+ .CT .Y>>)>>
	       <SET RX <+ .X .CL>>)
	      (T
	       <FORCE-CHAR .CHR .RX .RY>
	       <COND (.DUMP?
		      <PUTB ,LAST-USED .GQ*2 .X>
		      <PUTB ,LAST-USED <+ .GQ*2 1> .Y>)>
	       <RETURN>)>>>>

<MSETG NCHARS 64>

<CONSTANT FUNNY-FIELDS <ITABLE ,COMPUTER-HEIGHT 0>>

<DEFINE GEN-CHAR (H:FIX V:FIX "AUX" (FF ,FUNNY-FIELDS) (CHR -1) TF
		  (V1 <+ .V 1>) SW)
	<COND (<0? <MOD .V 2>>
	       <COND (<F? <SET TF <ZGET .FF .V>>>
		      <SET TF <ZREST <PICK-ONE ,LICENSE-FORM>
				     <- ,FIELD-DATA-OFFSET 1>>>
		      <COND (<L=? <+ .H <GETB .TF 0>> ,COMPUTER-WIDTH>
			     <ZPUT .FF .V .TF>
			     <ZPUT .FF .V1 .H>)
			    (T
			     <SET TF <>>)>)>
	       <COND (<AND .TF
			   <G=? .H <SET SW <ZGET .FF .V1>>>>
		      <SET CHR
			   <GETB .TF <+ 1 <MOD <- .H .SW> <GETB .TF 0>>>>>)>)>
	<COND (<==? .CHR -1>
	       <INVERT-CHAR <- <ZRANDOM ,NCHARS> 1>>)
	      (T
	       <CHTYPE .CHR FIX>)>>

<DEFINE INVERT-CHAR (N)
  <SET N <ANDB .N *77*>>
  <COND (<==? .N 0> <SET N 32>)
	(<L? .N 27> <SET N <+ .N %<- <ASCII !\A> 1>>>)
	(<L? .N 54> <SET N <+ .N %<- <ASCII !\a> 27>>>)
	(<G=? .N 57> <SET N <+ .N %<- <ASCII !\0> 57>>>)
	(ELSE <SET N <GETB ,PUNCT-TABLE <- .N 54>>>)>
  .N>

<DEFINE20 TCOMP ()
  <MOVE ,COMPUTER ,PLAYER>
  <MOVE ,RANDOM-CARTRIDGE ,PLAYER>
  <PERFORM ,V?PUT ,RANDOM-CARTRIDGE ,COMPUTER>>
