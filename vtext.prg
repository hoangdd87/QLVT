FUNCTION VText
LPARAMETERS cText
PRIVATE nText, TCNV3, cVText, nExist, cText_i
TCVN3=[ Aaµ¸¹¶·¨»¾Æ¼½¢©ÇÊËÈÉBbCcDd§®Ee`ÐÑÎÏ£ª?OÖÓÔFfGgHhIi×U~ØÜKkJjLlMmNnOoßaäáâ¤«åèéæç¥¬êíîë´PpQqRrsTtUuïóôñ?¦­øoùö÷VvXxYyúu?ûü1234567890wWzZ!@#$%^&*()-_+={};:'",<>.?/\|`~]
nText=LEN(cText)
cVtext=[]
FOR i=1 TO nText
cText_i=SUBSTR(cText,i,1)
nExist=AT(cText_i,TCVN3)
IF nExist>0
cText_i=CHR(nExist+32)
ENDIF
cVtext=cVText+cText_i
ENDFOR
RETURN cVText
ENDFUNC 