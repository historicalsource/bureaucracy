<ZSECTION "JETDEFS">

<FILE-FLAGS MDL-ZIL?>

<USE "NEWSTRUC">
<INCLUDE "FORMDEFS">

<MSETG AISLE-COUNT 9>
<MSETG INITIAL-ROW 3>

<MSETG FOOD-SCENE 1>
<MSETG VISA-SCENE 2>
<MSETG HIJACK-SCENE 3>
<MSETG SCENE-COUNT 3>

<DEFINE-GLOBALS PLANE-TABLE
		(SITTING? BYTE <>)
		(PHONES-PLUGGED-IN? BYTE <>)
		(CURRENT-STAR BYTE 0)
		(CURRENT-DESC BYTE 0)
		(CURRENT-WEAPON BYTE 0)
		(LOSER-CANT-LEAVE-SEAT? BYTE <>)
		(PURSER-HERE? BYTE <>)
		(PHONE-MUSIC:FIX BYTE 0)	; "Headphone stuff"
		(PHONE-TIMER:FIX BYTE 0)	; "Random"
		(LAST-ROW:FIX BYTE 0)	; "Previous row occupied"
		(LAST-SEAT:FIX BYTE 0)	; "Previous seat"
		(NEW-ROW:FIX BYTE 0)
		(NEW-SEAT:FIX BYTE 0)
		(RETURN-TO-SEAT-WAIT:FIX BYTE 0)
		(SCENE-NUMBER:FIX BYTE 0); "1, 2, or 3; one is added each time"
		(CURRENT-SCENE:FIX BYTE 0)	; "1, 2, or 3"
		(DREAMING? BYTE T)		; "false for last scene"
		; "Variables for meal script"
		(MEAL-SCRIPT:FIX BYTE 0)
		(MEAL-COUNTER:FIX BYTE 0)
		(SINK-CLEANED? BYTE <>)
		(TEETH-BRUSHED? BYTE <>)
		; "Variables for visa script"
		(VISA-SCRIPT:FIX BYTE 11)	; "Number of incidents"
		(FORM-FILLED-OUT? BYTE <>) ; "Loser actually filled out form"
		(ATTENDANT-COMPLAINTS BYTE 0)
		(GOT-VISA-NUMBER? BYTE <>); "Got visa number from someone else"
		(VISA-SLEEPING? BYTE 0)
		(GRANDMA-HAPPY? BYTE <>)
		(SMOKER-IRATE? BYTE <>)
		(BUSINESS-IRATE? BYTE <>)
		(FALL-SCRIPT:FIX BYTE 5)
		(FORM-SEEN? BYTE <>)
		(CURRENT-NEIGHBOR BYTE 0)
		(BUSINESS-ROW BYTE 0)
		(BUSINESS-SEAT BYTE 0)
		(BROUGHT-COMPUTER? BYTE <>)
		(GOT-RECIPE? BYTE <>)
		(FLIGHT-ATTENDANT-HE/SHE:STRING "She")
		(FLIGHT-ATTENDANT-HIM/HER:STRING "her")
		(THROWN-OFF-ONCE? BYTE <>)
		(FIRST-SCENE? BYTE T)>

<CONSTANT ALL-SCENES
	  <TABLE (BYTE) ,FOOD-SCENE ,VISA-SCENE ,HIJACK-SCENE>>

<CONSTANT MOVIE-STARS
	  <PLTABLE "Rambo"
		   "Rocky"
		   "Sylvester Stallone"
		   "someone looking like Sylvester Stallone, but with a German accent,"
		   "Arnold Schwarzenegger"
		   "James Bond"
		   "Sigourney Weaver"
		   "a woman with a strange resemblance to Sylvester Stallone"
		   "Charles Bronson"
		   "Chuck Norris">>

<CONSTANT MOVIE-WEAPONS
	  <PLTABLE "several karate moves"
		   "a Bowie knife"
		   "a Sherman tank"
		   "an AK-47 assault rifle, a rocket launcher and several hand grenades"
		   "a wide assortment of shoulder-launched cruise missiles"
		   "the help of a shoe-mounted switchblade"
		   "a flamethrower, a grenade launcher and a pulse rifle"
		   "a concealed bazooka"
		   "no help from Washington">>

<CONSTANT MOVIE-DESCS
	  <PLTABLE "solves the Energy Crisis by attacking every Middle Eastern oil field"
		   "ends the Depression by attacking Wall Street"
		   "ends the Civil War by attacking Richmond"
		   "ends illiteracy by attacking the evil textbook publishers"
		   "restores the balance of payments by attacking Germany, Japan, South Korea and Canada"
		   "restores the balance of payments by attacking the Heineken brewery"
		   "saves an uninhabited planet by blowing away the alien invaders"
		   "saves embassy hostages from terrorists"
		   "wipes out crime in America by killing jaywalkers and litterbugs">>

<BUILD-FORM IMMIGRATION-FORM
	    (IMM-LAST-NAME "Last name:" 21 "Chomper" IF-LAST-NAME)
	    (IMM-FIRST-NAME "First name:" 25 "Random" IF-FIRST-NAME)
	    (IMM-MIDDLE-INITIAL "Middle initial:" 1 "Q" IF-MIDDLE-INITIAL)
	    (IMM-COUNTRY "Home planet:" 10 "Earth")
	    (IMM-MAIDEN "Mother's maiden name:" 10 "Frobber")
	    (IMM-DATE "Date of last Chinese meal:" 10 "9/20/86" IF-DATE)
	    (IMM-RING "Ring size:" 4 "4" IF-DATE)
	    (IMM-AGE "Age of first-born ancestor:" 4)
	    (IMM-VISA "Visa number:" 10 "69105" IF-VISA)
	    (IMM-RAND1 "Stars in universe:" 3 "0" IF-STARS)
	    (IMM-RAND2 "Reason for leaving:" 10 "FF" IF-REASON)>

<DEFMAC ROW-SEATS ("OPT" 'NEW)
  <COND (<NOT <ASSIGNED? NEW>>
	 <FORM ANDB <FORM ZGET ',AISLE-STATE ',CURRENT-ROW>
	       ,ALL-SEATS>)
	(T
	 <FORM ZPUT ',AISLE-STATE ',CURRENT-ROW
	       <FORM ORB .NEW <FORM ANDB <ZGET ',AISLE-STATE ',CURRENT-ROW>
				    <XORB ,ALL-SEATS -1>>>>)>>

; "State of seating is low four bits; starboard passenger, if any, is next
   four; port passenger is next four. Three remaining bits below the sign
   bit can be used for flags."

<MSETG SEAT-A 1>
<MSETG SEAT-B 2>
<MSETG SEAT-C 4>
<MSETG SEAT-D 8>
<MSETG ALL-SEATS <ORB ,SEAT-A ,SEAT-B ,SEAT-C ,SEAT-D>>


<MSETG STARBOARD-DIVISOR 16>
<MSETG PORT-DIVISOR 256>

<MSETG ROW-SEEN-BIT 4096>

<ENDSECTION>
