"MAZE-PROG for BUREAUCRACY: Copyright (C)1987 Infocom, Inc.
 All rights reserved."

<FILE-FLAGS MDL-ZIL?>

<INCLUDE "FORMDEFS" "COMPUTERDEFS">

<MSETG MAX-CHARS <* ,COMPUTER-HEIGHT ,COMPUTER-WIDTH>>
<MSETG QSIZE </ ,MAX-CHARS 4>>
<MSETG COMPUTER-WIDTH*2 <* ,COMPUTER-WIDTH 2>>
<MSETG COMPUTER-HEIGHT/2 </ ,COMPUTER-HEIGHT 2>>
<MSETG COMPUTER-HEIGHT/2-1 <- </ ,COMPUTER-HEIGHT 2> 1>>
<MSETG COMPUTER-WIDTH/2 </ ,COMPUTER-WIDTH 2>>
<MSETG COMPUTER-WIDTH/2-1 <- </ ,COMPUTER-WIDTH 2> 1>>
<MSETG COMPUTER-WIDTH*3/2 </ <* ,COMPUTER-WIDTH 3> 2>>
<MSETG Q1-GOOD-CHARS </ ,QSIZE 4>>
<MSETG Q2-GOOD-CHARS </ <* ,QSIZE 3> 4>>
<MSETG Q3-GOOD-CHARS </ <* ,QSIZE 5> 4>>
<MSETG Q4-GOOD-CHARS </ <* ,QSIZE 7> 4>>

<SETG20 TST
        <IVECTOR ,COMPUTER-WIDTH '<ISTRING ,COMPUTER-HEIGHT <ASCII 32>>>>

<SETG20 TST2
	<IVECTOR ,COMPUTER-WIDTH*2 '<IUVECTOR ,COMPUTER-HEIGHT/2 32>>>

<SETG20 INPUT-STR <ISTRING ,MAX-CHARS>>

<DEFINE20 LD-FILE (FILE
		     "AUX" (CH <OPEN "READ" .FILE>) N:FIX)
	<COND (.CH
	       <SET N <MIN ,MAX-CHARS <FILE-LENGTH .CH>>>
	       <READSTRING ,INPUT-STR .CH .N>
	       <CLOSE .CH>
	       <FILL ,INPUT-STR ,TST>)
	      (ELSE .CH)>>

<DEFINE20 FILL (STR TBL
	      "AUX" (I 0) (LEN <LENGTH .STR>))
	<MAPF <>
	      <FUNCTION (S "AUX" (J 0) K)
		   <REPEAT ()
			   <SET K .J>
			   <COND (<MAPF <>
					<FUNCTION (CHR)
					     <SET K <+ .K 1>>
					     <COND (<==? .CHR <ASCII 32>>
						    <MAPLEAVE T>)>
					     <COND (<G? .K ,COMPUTER-HEIGHT>
						    <MAPLEAVE <>>)>
					     T>
					<REST!- .STR .I>>
				  <SUBSTRUC .STR .I
					    <- .K .J 1>
					    <REST!- .S .J>>
				  <SET I <+ .I <- .K .J>>>
				  <SET J .K>
				  ;<MAPR <>
					<FUNCTION (S1 S2)
					     <PUT!- .S1 1 <1 .S2>>
					     <SET I <+ .I 1>>
					     <COND (<==? <SET J <+ .J 1>> .K>
						    <MAPLEAVE>)>>
					<REST!- .S .J> <REST!- .STR .I>>)
				 (ELSE <RETURN>)>>>
	      .TBL>>

<GDECL (TST) <VECTOR [REST STRING]>>
<GDECL (TST2) <VECTOR [REST UVECTOR]>>

<DEFINE20 TABLEIZE ("AUX" (I:FIX 0) (J:FIX 0) (K:FIX 0))
	  <REPEAT ()
		  <COND (<G=? .I ,COMPUTER-HEIGHT> <RETURN!->)>
		  <PUT!- <NTH!- ,TST2 
			        <COND (<G=? .I ,COMPUTER-HEIGHT/2>
				       <+ .J ,COMPUTER-WIDTH 1>)
				      (ELSE
				       <+ .J 1>)>>
		       <COND (<G=? .I ,COMPUTER-HEIGHT/2>
			      <- .I ,COMPUTER-HEIGHT/2 -1>)
			     (ELSE
			      <+ .I 1>)>
		       <TRANS <NTH!- <NTH!- ,TST <+ .J 1>> <+ .I 1>>>>
		  <COND (<G=? <SET J <+ .J 1>> ,COMPUTER-WIDTH>
			 <SET I <+ .I 1>>
			 <SET J 0>)>>
	  ,TST2>

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

<SETG PROG-TABLE <TABLE !<MAPF ,VECTOR
			       <FUNCTION (STR)
				    <TABLE (BYTE) !.STR>>
			       <TABLEIZE>>>>

<MSETG QLEFT 0>
<MSETG QRIGHT 1>
<MSETG QTOP 2>
<MSETG QBOT 3>
			  
;<CONSTANT QUADS <PTABLE <TABLE (PURE BYTE) 19 37 0 7>
		       <TABLE (PURE BYTE) 0 18 0 7>
		       <TABLE (PURE BYTE) 0 18 8 15>
		       <TABLE (PURE BYTE) 19 37 8 15>>>

<CONSTANT PUNCT-TABLE
	  <TABLE (PURE BYTE)
		 %<ASCII !\.> %<ASCII !\,> %<ASCII !\;>>>

<DEFINE PROG-FIRST (A B C)
	<DO-PROG 1 ,Q1-GOOD-CHARS 1 3 ,COMPUTER-WIDTH/2 0 *100*>>

<DEFINE PROG-SECOND (A B C)
	<DO-PROG 0 ,Q2-GOOD-CHARS 3 5 ,COMPUTER-WIDTH ,COMPUTER-WIDTH/2 *200*>>

<DEFINE PROG-THIRD (A B C)
	<DO-PROG 2 ,Q3-GOOD-CHARS 5 7 ,COMPUTER-WIDTH*3/2 ,COMPUTER-WIDTH
		 *300*>>

<DEFINE PROG-FOURTH (A B C)
	<DO-PROG 3 ,Q4-GOOD-CHARS ,Q4-GOOD-CHARS 0 ,COMPUTER-WIDTH*2
		 ,COMPUTER-WIDTH*3/2 *300*>>

<ROUTINE-FLAGS CLEAN-STACK?>
<DEFINE DO-PROG (QN SZ GOOD BAD RANGE START MASK "AUX" TBL GC WRAP)
	<CLEAR-QUADRANT .QN>
	<REPEAT ()
		<SET TBL <ZGET ,PROG-TABLE .START>>
		<SET I 0>
		<REPEAT ()
			<PUTB .TBL .I <ANDB <GETB .TBL .I> *77*>>
			<COND (<G=? <SET I <+ .I 1>> ,COMPUTER-HEIGHT/2>
			       <RETURN>)>>
		<COND (<G=? <SET START <+ .START 1>> .RANGE> <RETURN>)>>
	<SET GC .GOOD>
	<REPEAT ()
		<COND (<L? <SET SZ <- .SZ 1>> 0> <RETURN>)>
		<SET I <- <ZRANDOM .RANGE> 1>>
		<SET TBL <ZGET ,PROG-TABLE .I>>
		<SET H <- <ZRANDOM ,COMPUTER-HEIGHT/2> 1>>
		<SET WRAP .H>
		<REPEAT ()
			<SET CHR <GETB .TBL .H>>
			<COND (<AND <L=? <ANDB .CHR *300*> .MASK>
				    <G? .CHR 63>>
			       <SET H <+ .H 1>>
			       <COND (<==? .H ,COMPUTER-HEIGHT/2>
				      <SET H 0>)>
			       <COND (<==? .H .WRAP>
				      <SET I <+ .I 1>>
				      <COND (<==? .I .RANGE> <SET I 0>)>
				      <SET TBL <ZGET ,PROG-TABLE .I>>)>)
			      (ELSE
			       <SET CHR <ANDB .CHR *77*>>
			       <PUTB .TBL .H <ORB .CHR .MASK>>
			       <RETURN>)>>
		<SET CHR <INVERT-CHAR .CHR>>
		<COND (<G=? .I ,COMPUTER-WIDTH>
		       <FORCE-CHAR .CHR <- .I ,COMPUTER-WIDTH>
				   <+ .H ,COMPUTER-HEIGHT/2>>)
		      (ELSE
		       <FORCE-CHAR .CHR .I .H>)>
		<COND (<L=? <SET GC <- .GC 1>> 0>
		       <SET GC .BAD>
		       <REPEAT ()
			       <COND (<L? <SET GC <- .GC 1>> 0>
				      <RETURN>)>
			       <COND (<==? .QN 1>
				      <SET I <- <ZRANDOM ,COMPUTER-WIDTH> 1>>
				      <COND (<L? .I ,COMPUTER-WIDTH/2>
					     <SET H
						  <+ <ZRANDOM
						      ,COMPUTER-HEIGHT/2>
						     ,COMPUTER-HEIGHT/2-1>>)
					    (ELSE
					     <SET H
						  <- <ZRANDOM ,COMPUTER-HEIGHT>
						     1>>)>)
				     (<==? .QN 0>
				      <SET I <- <ZRANDOM ,COMPUTER-WIDTH> 1>>
				      <SET H <+ <ZRANDOM ,COMPUTER-HEIGHT/2>
						,COMPUTER-HEIGHT/2-1>>)
				     (ELSE
				      <SET I <+ <ZRANDOM ,COMPUTER-WIDTH/2>
						,COMPUTER-WIDTH/2-1>>
				      <SET H <+ <ZRANDOM ,COMPUTER-HEIGHT/2>
						,COMPUTER-HEIGHT/2-1>>)>
			       <COND (<==? <SET GC <- .GC 1>> 0>
				      <RETURN>)>
			       <SET CHR <GEN-CHAR .I .H>>
			       <FORCE-CHAR .CHR .I .H>>
		       <SET GC .GOOD>)>>
	<>>

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

;<DEFINE IN-QUAD (I:FIX H:FIX V:FIX
		  "AUX" (Q <ZGET ,QUADS .I>)
			(QL:FIX <GETB .Q ,QLEFT>)
		        (QR:FIX <GETB .Q ,QRIGHT>)
			(QT:FIX <GETB .Q ,QTOP>)
		        (QB:FIX <GETB .Q ,QBOT>))
	<COND (<AND <G=? .H .QL> <L=? .H .QR>
		    <G=? .V .QT> <L=? .V .QB>>
	       T)
	      (ELSE <>)>>
