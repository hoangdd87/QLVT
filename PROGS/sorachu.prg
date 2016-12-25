PARAMETERS so
DIMENSION a(9),c(4),tc(4)
a(1)=' mét '
a(2)=' hai '
a(3)=' ba '
a(4)=' bèn '
a(5)=' n¨m '
a(6)=' s¸u '
a(7)=' b¶y '
a(8)=' t¸m '
a(9)=' chÝm '
tc(1)=' '
tc(2)=' ngµn, '
tc(3)=' triÖu, '
tc(4)=' tØ, '
c=0
so1=so
sc=1
DO WHILE so1>0
	c(sc)=MOD(so1,1000)
	so1=INT(so1/1000)
	sc=sc+1
ENDDO
x=''
FOR i=sc-1 TO 1 STEP -1
	so1=c(i)
	IF so1>0
		tram=INT(so1/100)
		chuc=INT((so1-tram*100)/10)
		dvi=MOD(so1,10)
		IF tram>0
			x=x+a(tram)+'tr¨m' 	
		ENDIF 
		DO CASE 
			CASE chuc>1
				x=x+a(chuc)+'m­¬i'
			CASE chuc=1
				x=x+' m­êi '
			CASE chuc=0 AND so1>100 AND dvi<>0
				x=x+' linh '
		ENDCASE
		DO CASE 
			CASE dvi<>5 AND dvi<>0
				x=x+a(dvi)
			CASE dvi=5 AND chuc<>0
				x=x+' lam '
			CASE dvi=5 AND chuc=0
				x=x+' nam '
		ENDCASE
		x=x+tc(i)
	ENDIF
ENDFOR
RETURN x  	 	 				 					