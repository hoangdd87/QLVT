PARAMETERS pfontfilename,pfontname
ok=.T.
*!*	DIMENSION fontlist[4]
*!*	fontlist[1]=".vntime"
*!*	fontlist[2]=".vntimeH"
*!*	fontlist[3]="VnArial Small"
*!*	fontlist[4]="VnArial Small U"
*!*		
*!*	DIMENSION fontlistfile[4]
*!*	fontlistfile[1]="vntime.TTF"
*!*	fontlistfile[2]="VHTIME.TTF"
*!*	fontlistfile[3]="vnarials.TTF"
*!*	fontlistfile[4]="vharials.TTF"

*-- Code begins here
   CLEAR DLLS
   PRIVATE iRetVal, iLastError
   PRIVATE sFontDir, sSourceDir, sFontFileName, sFOTFile
   PRIVATE sWinDir, iBufLen
   iRetVal = 0
	
   ***** Code to customize with actual file names and locations.
   *-- .TTF file path.
   sSourceDir = "fonts\"

   *-- .TTF file name.
   sFontFileName = pfontfilename

   *-- Font description (as it will appear in Control Panel).
   sFontName = pfontname + " (TrueType)"
   ******************** End of code to customize *****

   DECLARE INTEGER CreateScalableFontResource IN win32api ;
     LONG fdwHidden, ;
     STRING lpszFontRes, ;
     STRING lpszFontFile, ;
     STRING lpszCurrentPath

   DECLARE INTEGER AddFontResource IN win32api ;
       STRING lpszFilename

   DECLARE INTEGER RemoveFontResource IN win32api ;
       STRING lpszFilename

   DECLARE LONG GetLastError IN win32api

   DECLARE INTEGER GetWindowsDirectory IN win32api STRING @lpszSysDir,;
     INTEGER iBufLen

   #DEFINE WM_FONTCHANGE   29 && 0x001D
   #DEFINE HWND_BROADCAST  65535 && 0xffff

   DECLARE LONG SendMessage IN win32api ;
       LONG hWnd, INTEGER Msg, LONG wParam, INTEGER lParam

   #DEFINE HKEY_LOCAL_MACHINE 2147483650   && (HKEY) 0x80000002
   #DEFINE SECURITY_ACCESS_MASK 983103     && SAM value KEY_ALL_ACCESS

   DECLARE RegCreateKeyEx IN ADVAPI32.DLL ;
      INTEGER, STRING, INTEGER, STRING, INTEGER, INTEGER, ;
           INTEGER, INTEGER @, INTEGER @

   DECLARE RegSetValueEx IN ADVAPI32.DLL;
           INTEGER, STRING, INTEGER, INTEGER, STRING, INTEGER

   DECLARE RegCloseKey IN ADVAPI32.DLL INTEGER

   *-- Fonts folder path.
   *-- Use the GetWindowsDirectory API function to determine
   *-- where the Fonts directory is located.
   sWinDir = SPACE(50)  && Allocate the buffer to hold the directory name.
   iBufLen = 50         && Pass the size of the buffer.
   iRetVal = GetWindowsDirectory(@sWinDir, iBufLen)

   *-- iRetVal holds the length of the returned string.
   *-- Since the string is null-terminated, we need to
   *-- snip the null off.
   sWinDir = SUBSTR(sWinDir, 1, iRetVal)
   sFontDir = sWinDir + "\FONTS\"

   *-- Get .FOT file name.
   sFOTFile  = sFontDir + LEFT(sFontFileName, ;
     LEN(sFontFileName) - 4) + ".FOT"

   *-- Copy to Fonts folder.
   IF !FILE(sFontDir+sFontFileName,1)
   	TRY 
   		COPY FILE (sSourceDir + sFontFileName) TO  (sFontDir + sFontFileName)
   	CATCH 
   		MESSAGEBOX(MESSAGE()+" Khong the copy duoc font "+sFontFileName)
   	ENDTRY 	
   ENDIF 
   *-- Create the font.
   iRetVal = ;
     CreateScalableFontResource(0, sFOTFile, sFontFileName, sFontDir)
   IF iRetVal = 0 THEN
       iLastError = GetLastError ()
       IF iLastError = 80
          MESSAGEBOX("Font file " + sFontDir + sFontFileName + ;
          "already exists.")
       ELSE
           MESSAGEBOX("Error " + STR (iLastError))
       ENDIF
      RETURN .F.
   ENDIF

   *-- Add the font to the system font table.
   iRetVal = AddFontResource (sFOTFile)
   IF iRetVal = 0 THEN
       iLastError = GetLastError ()
       IF iLastError = 87 THEN
           MESSAGEBOX("Incorrect Parameter")
       ELSE
           MESSAGEBOX("Error " + STR (iLastError))
       ENDIF
      RETURN .F.
   ENDIF

   *-- Make the font persistent across reboots.
   STORE 0 TO iResult, iDisplay
   iRetVal = RegCreateKeyEx(HKEY_LOCAL_MACHINE, ;
     "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts", 0, "REG_SZ", ;
     0, SECURITY_ACCESS_MASK, 0, @iResult, ;
     @iDisplay) && Returns .T. if successful

   *-- Uncomment the following lines to display information
   *!*   *-- about the results of the function call.
   *!*      WAIT WINDOW STR(iResult)   && Returns the key handle
   *!*      WAIT WINDOW STR(iDisplay)  && Returns one of 2 values:
   *!*                                 && REG_CREATE_NEW_KEY = 1
   *!*                                 && REG_OPENED_EXISTING_KEY = 2

   iRetVal = RegSetValueEx(iResult, sFontName, 0, 1, sFontFileName, 13)

   *-- Close the key.  Don't keep it open longer than necessary.
   iRetVal = RegCloseKey(iResult)

   *-- Notify all the other application a new font has been added.
   iRetVal = SendMessage (HWND_BROADCAST, WM_FONTCHANGE, 0, 0)
   IF iRetVal = 0 THEN
       iLastError = GetLastError ()
           MESSAGEBOX("Error " + STR (iLastError))
      RETURN .F.
   ENDIF

   ERASE (sFOTFile)
   RETURN .T.
   *-- Code ends here