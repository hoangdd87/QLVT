**Main procedure
CLOSE DATABASES ALL 
CLOSE TABLES all

SET PROCEDURE TO progs\installfont
IF !enoughfont()
	ok=MESSAGEBOX("Ban chua cai dat du font de hien thi, Ban co muon chuong trinh cai dat them khong?",4+32)
	IF ok=6
		DO newinstallfonts
		
	ENDIF 
ENDIF 

DO FORM forms\login
READ EVENTS
 

