"MAZE-PROG for BUREAUCRACY: Copyright (C)1987 Infocom, Inc.
 All rights reserved."

<FILE-FLAGS MDL-ZIL?>

<INCLUDE "FORMDEFS" "COMPUTERDEFS">

<MSETG MAX-CHARS <* ,COMPUTER-HEIGHT ,COMPUTER-WIDTH>>
<MSETG QSIZE </ ,MAX-CHARS 4>>

<SETG20 TST
        <IVECTOR ,COMPUTER-WIDTH '<ISTRING ,COMPUTER-HEIGHT <ASCII 32>>>>

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

<SETG20 INDEX-UV <IUVECTOR ,MAX-CHARS 0>>
<GDECL (INDEX-UV) UVECTOR>
<GDECL (TST) <VECTOR [REST STRING]>>

<DEFINE20 TABLEIZE ("AUX" (UV:UVECTOR ,INDEX-UV) (I:FIX 0) (J:FIX 0))
	  <MAPR <>
		<FUNCTION (X "AUX" TMP)
		     <SET TMP
			  <ORB!-  <LSH .I 12>
			          <LSH .J 6>
			          <TRANS <NTH!- <NTH!- ,TST <+ .J 1>>
						<+ .I 1>>>>>
		     <COND (<G=? <SET J <+ .J 1>> ,COMPUTER-WIDTH>
			    <SET I <+ .I 1>>
			    <SET J 0>)>
		     <PUT!- .X 1 .TMP>>
		.UV>
	  .UV>

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

<SETG PROG-TABLE <TABLE !<TABLEIZE>>>

<DEFINE RANDOMIZE ("AUX" (Z ,MAX-CHARS) T1 T2 T3)
	<REPEAT ()
		<COND (<L=? <SET Z <- .Z 1>> 0> <RETURN>)>
		<SET T1 <ZRANDOM ,MAX-CHARS>>
		<SET T1 <- .T1 1>>
		<SET T2 <ZRANDOM ,MAX-CHARS>>
		<SET T2 <- .T2 1>>
		<SET T3 <ZGET ,PROG-TABLE .T1>>
		<ZPUT ,PROG-TABLE .T1 <ZGET ,PROG-TABLE .T2>>
		<ZPUT ,PROG-TABLE .T2 .T3>>>

<MSETG QLEFT 0>
<MSETG QRIGHT 1>
<MSETG QTOP 2>
<MSETG QBOT 3>
			  
<CONSTANT QUADS <PTABLE <TABLE (PURE BYTE) 19 37 0 7>
		       <TABLE (PURE BYTE) 0 18 0 7>
		       <TABLE (PURE BYTE) 0 18 8 15>
		       <TABLE (PURE BYTE) 19 37 8 15>>>

<CONSTANT PUNCT-TABLE
	  <TABLE (PURE BYTE)
		 %<ASCII !\.> %<ASCII !\,> %<ASCII !\;>>>

<ROUTINE-FLAGS CLEAN-STACK?>
<DEFINE PROG-FIRST (A B C "AUX" (SZ ,QSIZE) N:FIX H:FIX V:FIX (I:FIX 0))
	<CLEAR-QUADRANT 0>
	<REPEAT ()
		<COND (<L? <SET SZ <- .SZ 1>> 0> <RETURN>)>
		<SET N <ZGET ,PROG-TABLE .I>>
		<SET I <+ .I 1>>
		<SET H <ANDB </ <ANDB .N *7777*> 64> *77*>>
		<SET V <ANDB </ <ANDB </ .N 2> *77777*> 2048> *17*>>
		<COND (<IN-QUAD 0 .H .V>
		       <SET N <INVERT-CHAR .N>>)
		      (ELSE
		       <SET N <GEN-CHAR .H .V>>)>
		<FORCE-CHAR .N .H .V>>
	<>>

<ROUTINE-FLAGS CLEAN-STACK?>
<DEFINE PROG-SECOND (A B C "AUX" (SZ <* ,QSIZE 2>) N:FIX H:FIX V:FIX (I:FIX 0))
	<CLEAR-QUADRANT 1>
	<REPEAT ()
		<COND (<L? <SET SZ <- .SZ 1>> 0> <RETURN>)>
		<SET N <ZGET ,PROG-TABLE .I>>
		<SET I <+ .I 1>>
		<SET H <ANDB </ <ANDB .N *7777*> 64> *77*>>
		<SET V <ANDB </ <ANDB </ .N 2> *77777*> 2048> *17*>>
		<COND (<L? .V </ ,COMPUTER-HEIGHT 2>>
		       ; "Just checking for top half of screen"
		       ;<OR <IN-QUAD 0 .H .V> <IN-QUAD 1 .H .V>>
		       <COND (<OR <L? .SZ ,QSIZE>
				  ; "Know top half, so just check for left"
				  <L? .H </ ,COMPUTER-WIDTH 2>>
				  ;<IN-QUAD 1 .H .V>>
			      <SET N <INVERT-CHAR .N>>)
			     (ELSE <SET N 0>)>)
		      (ELSE
		       <SET N <GEN-CHAR .H .V>>)>
		<COND (<N==? .N 0> <FORCE-CHAR .N .H .V>)>>
	<>>

<ROUTINE-FLAGS CLEAN-STACK?>
<DEFINE PROG-THIRD (A B C "AUX" (SZ <* ,QSIZE 3>) N:FIX H:FIX V:FIX (I:FIX 0))
	<CLEAR-QUADRANT 2>
	<REPEAT ()
		<COND (<L? <SET SZ <- .SZ 1>> 0> <RETURN>)>
		<SET N <ZGET ,PROG-TABLE .I>>
		<SET I <+ .I 1>>
		; "this tries to win with 16-bit arithmetic"
		<SET H <ANDB </ <ANDB .N *7777*> 64> *77*>>
		<SET V <ANDB </ <ANDB </ .N 2> *77777*> 2048> *17*>>
		<COND (<NOT <IN-QUAD 3 .H .V>>
		       ;<OR <IN-QUAD 0 .H .V> <IN-QUAD 1 .H .V>
			   <IN-QUAD 2 .H .V>>
		       <COND (<OR <L? .SZ ,QSIZE>
				  ; "If in bottom half, must be quad 2"
				  <G=? .V </ ,COMPUTER-HEIGHT 2>>
				  ;<IN-QUAD 2 .H .V>>
			      <SET N <INVERT-CHAR .N>>)
			     (ELSE <SET N 0>)>)
		      (ELSE
		       <SET N <GEN-CHAR .H .V>>)>
		<COND (<N==? .N 0> <FORCE-CHAR .N .H .V>)>>
	<>>

<ROUTINE-FLAGS CLEAN-STACK?>
<DEFINE PROG-FOURTH (A B C "AUX" (SZ ,MAX-CHARS) N:FIX H:FIX V:FIX (I:FIX 0))
	<CLEAR-QUADRANT 3>
	<REPEAT ()
		<COND (<L? <SET SZ <- .SZ 1>> 0> <RETURN>)>
		<SET N <ZGET ,PROG-TABLE .I>>
		<SET I <+ .I 1>>
		<SET H <ANDB </ <ANDB .N *7777*> 64> *77*>>
		<SET V <ANDB </ <ANDB </ .N 2> *77777*> 2048> *17*>>
		<COND (<OR <L? .SZ ,QSIZE> <IN-QUAD 3 .H .V>>
		       <SET N <INVERT-CHAR .N>>
		       <FORCE-CHAR .N .H .V>)>>
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

<DEFINE IN-QUAD (I:FIX H:FIX V:FIX
		  "AUX" (Q <ZGET ,QUADS .I>)
			(QL:FIX <GETB .Q ,QLEFT>)
		        (QR:FIX <GETB .Q ,QRIGHT>)
			(QT:FIX <GETB .Q ,QTOP>)
		        (QB:FIX <GETB .Q ,QBOT>))
	<COND (<AND <G=? .H .QL> <L=? .H .QR>
		    <G=? .V .QT> <L=? .V .QB>>
	       T)
	      (ELSE <>)>>
