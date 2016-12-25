PROCEDURE newinstallfonts
SET PROCEDURE TO progs\installsysfont
DIMENSION fontlist[4]
fontlist[1]=".vntime"
fontlist[2]=".vntimeH"
fontlist[3]="VnArial Small"
fontlist[4]="VnArial Small U"
	
DIMENSION fontlistfile[4]
fontlistfile[1]="vntime.TTF"
fontlistfile[2]="VHTIME.TTF"
fontlistfile[3]="vnarials.TTF"
fontlistfile[4]="vharials.TTF"	
 
success=.T. 
FOR i=1 TO 4
	
	TRY 
		IF !AFONT(arr2,fontlist[i])
			ok=installsysfont(fontlistfile[i],fontlist[i])
			IF !ok 
				success=.F.
			ENDIF 
		ENDIF 
	CATCH 
		MESSAGEBOX(MESSAGE()+MESSAGEBOX(" -- Loi khi cai font ",fontlist[i]))
	ENDTRY 	   
ENDFOR

IF !success
	FOR i=1 TO 4 
		IF !AFONT(arr2,fontlist[i])
			TRY 
				InstallSystemFont(fontlistfile[i])		
			CATCH 
			ENDTRY 
		ENDIF
	ENDFOR 	 
ENDIF 

IF success  
	MESSAGEBOX("Cai font thanh cong. Hay khoi dong lai may de hoan tat qua trinh cai dat")
ELSE 
	MESSAGEBOX("Cai font khong thanh cong. Ban hay cai cac font con thieu thu cong de chuong trinh hoat dong tot",16)
ENDIF 
     
ENDPROC

PROCEDURE InstallSystemFont()
   LPARAMETERS lcFontLocFile
   LOCAL lnNumFontsAdded

   DECLARE INTEGER AddFontResource IN GDI32.DLL ;
      STRING @ lpszFileName
   DECLARE INTEGER SendMessage IN USER32.DLL ;
      INTEGER hWnd, ;
      INTEGER Msg, ;
      INTEGER wParameter, ;
      INTEGER lParameter
   #DEFINE HWND_BROADCAST 0xFFFF
   #DEFINE WM_FONTCHANGE  0x001D

   lnNumFontsAdded=AddFontResource(lcFontLocFile)
   IF lnNumFontsAdded > 0
      *\\Font added sucessfully, send notification to Windows so apps get updated
      =SendMessage(HWND_BROADCAST,WM_FONTCHANGE,0,0)
      RETURN .T.
      ELSE
      *\\Unable to add font
      RETURN .F.
   ENDIF   
ENDPROC

PROCEDURE installfonts
	DIMENSION fontlistfile[4]
	fontlistfile[1]="fonts\vntime.TTF"
	fontlistfile[2]="fonts\VHTIME.TTF"
	fontlistfile[3]="fonts\vnarials.TTF"
	fontlistfile[4]="fonts\vharials.TTF"
	FOR i=1 TO 4 
		TRY 
			llSucess = InstallSystemFont(fontlistfile[i])
			IF !llSucess
				MESSAGEBOX("loi khi cai font "+fontlistfile[i])
				merror=.T.
			ENDIF 
			
		CATCH 
			MESSAGEBOX("Loi khi cai font:"+MESSAGE())
		ENDTRY 
	ENDFOR 
	MESSAGEBOX("Da cai font xong, hay khoi dong lai may de hoan tat")
ENDPROC 

FUNCTION enoughfont()
	DIMENSION fontlist[4]
	fontlist[1]=".vntime"
	fontlist[2]=".vntimeH"
	fontlist[3]="VnArial Small"
	fontlist[4]="VnArial Small U"
	ok=.T.
	FOR i=1 TO 4
		IF !AFONT(arr,fontlist[i])
			MESSAGEBOX("Chua co font: "+fontlist[i])
			ok=.F.
			EXIT
		ENDIF 
	ENDFOR 
	RETURN ok
ENDFUNC