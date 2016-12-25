PROCEDURE getdata
**Ham lay ten vat tu tu ma vat tu
FUNCTION getTenvt()
	Parameter _mavt
	IF !USED("dmvt")
		USE data\dmvt IN 0
	ENDIF 
	SELECT dmvt
	_recno=IIF(EOF(),0,RECNO())
	_tenvt=LOOKUP(tenvt,_mavt,mavt)
	IF _recno>0 
		GO _recno
	ENDIF 	
	RETURN _tenvt

ENDFUNC 

**Ham lay ra so phieu moi voi lp la PN hay PX
FUNCTION getNewSophieu()
	PARAMETERS _lp

	IF !USED("phieu")
		use data\phieu in 0 SHARED
	ENDIF 
	SET TALK OFF
	old_alias=ALIAS()
	SELECT phieu	
	_recno=IIF(BOF("phieu") or EOF("phieu"),0,RECNO("phieu"))
	COUNT FOR lp==_lp TO cphieu
	newnophieu=ALLTRIM(STR(cphieu+1))
	IF _recno>0
		
		GO _recno IN phieu
	ENDIF 
	IF !EMPTY(old_alias)
		SELECT &old_alias
	ENDIF 	
	RETURN _lp+REPLICATE("0",LEN(phieu.sophieu)-LEN(_lp)-LEN(newnophieu))+newnophieu  

**Ham lay khoi luong du ban dau cua mot ma vat tu
FUNCTION getDubdkl()
	LPARAMETERS pmavt, pmakho
	IF TYPE("pmakho")!="C"
		pmakho=""
	ENDIF 
	IF !USED("dubd")
		USE dubd IN 0
	ENDIF 
	SELECT dubd	
	recno_dubd=IIF(EOF() or BOF(),0,RECNO())

	SET TALK OFF 
	SUM kl FOR pmavt==mavt AND (EMPTY(pmakho) OR (makho==pmakho))TO kq
	
	IF recno_dubd>0
		GO recno_dubd
	ENDIF 
	
	RETURN kq
ENDFUNC 

**Ham lay thanh tien du ban dau cua mot ma vat tu
FUNCTION getDubdtt()
	LPARAMETERS pmavt,pmakho
	IF TYPE("pmakho")!="C"
		pmakho=""
	ENDIF 
	IF !USED("dubd")
		USE dubd IN 0
	ENDIF 
	
	SELECT dubd	
	recno_dubd=IIF(EOF() or BOF(),0,RECNO())

	SET TALK OFF 
	SUM kl*dg FOR pmavt==mavt AND (EMPTY(pmakho) OR makho==pmakho) TO kq
	
	IF recno_dubd>0
		GO recno_dubd
	ENDIF 
	
	RETURN kq
ENDFUNC 

**Ham lay tong nhap, xuat trong ky cua mot vat tu
FUNCTION gettongkl()
	LPARAMETERS pmavt,ngay1,ngay2,plp,pmakho
	IF TYPE("pmakho")!="C"
		pmakho=""
	ENDIF 
	IF !USED("phieu")
		USE data\phieu IN 0
	ENDIF 
		IF !USED("dongphieu")
		USE data\dongphieu IN 0
	ENDIF 
	recno_phieu=IIF(EOF("phieu") or BOF("phieu"),0,RECNO("phieu"))
	recno_dongphieu=IIF(EOF("dongphieu") or BOF("dongphieu"),0,RECNO("dongphieu"))
	SET TALK OFF 
	
	SELECT SUM(Dongphieu.kl);
	FROM  qlvt!phieu ;
    	INNER JOIN qlvt!dongphieu ;
   	ON  Phieu.idphieu == Dongphieu.idphieu;
   	WHERE phieu.lp==plp AND dongphieu.mavt = pmavt AND phieu.ngaylap>=ngay1 AND phieu.ngaylap<=ngay2 AND (EMPTY(pmakho) OR phieu.makho==pmakho);
 	GROUP BY Dongphieu.mavt; 
 	INTO ARRAY  kq
	
	IF recno_phieu>0
		GO recno_phieu IN phieu
	ENDIF 
	IF recno_dongphieu>0
		GO recno_dongphieu IN dongphieu
	ENDIF 
	IF TYPE("kq")!="N"
		kq=0
	ENDIF 
	RETURN kq
ENDFUNC 

**Ham lay tong thanh tien nhap, xuat trong ky cua mot vat tu
FUNCTION gettongtt()
	LPARAMETERS pmavt,ngay1,ngay2,plp,pmakho,pmakho
	IF !USED("phieu")
		USE data\phieu IN 0
	ENDIF 
		IF !USED("dongphieu")
		USE data\dongphieu IN 0
	ENDIF 
	recno_phieu=IIF(EOF("phieu") or BOF("phieu"),0,RECNO("phieu"))
	recno_dongphieu=IIF(EOF("dongphieu") or BOF("dongphieu"),0,RECNO("dongphieu"))
	SET TALK OFF 
	
	SELECT SUM(Dongphieu.kl*dongphieu.dg);
	FROM  qlvt!phieu ;
    	INNER JOIN qlvt!dongphieu ;
   	ON  Phieu.idphieu == Dongphieu.idphieu;
   	WHERE phieu.lp==plp AND dongphieu.mavt = pmavt AND phieu.ngaylap>=ngay1 AND phieu.ngaylap<=ngay2 AND (EMPTY(pmakho) OR phieu.makho==pmakho) ;
 	GROUP BY Dongphieu.mavt; 
 	INTO ARRAY  kq 

	IF recno_phieu>0
		GO recno_phieu IN phieu
	ENDIF 
	IF recno_dongphieu>0
		GO recno_dongphieu IN dongphieu
	ENDIF 
 	IF TYPE("kq")!="N"
		kq=0
 	ENDIF 
	RETURN kq
ENDFUNC 

*!*	**Ham lay khoi luong du ban dau cua mot ma vat tu
*!*	FUNCTION getDubdkl()
*!*		LPARAMETERS pmavt,pmakho
*!*		IF TYPE("pmakho")!="C"
*!*			pmakho=""
*!*		ENDIF 
*!*		IF !USED("dubd")
*!*			USE data\dubd IN 0
*!*		ENDIF 
*!*		SELECT dubd	
*!*		recno_dubd=IIF(EOF() or BOF(),0,RECNO())

*!*		SET TALK OFF 
*!*		SUM kl FOR mavt==pmavt TO kq
*!*		
*!*		IF recno_dubd>0
*!*			GO recno_dubd
*!*		ENDIF 
*!*		
*!*		RETURN kq
*!*	ENDFUNC 

*!*	**Ham lay thanh tien du ban dau cua mot ma vat tu
*!*	FUNCTION getDubdtt()
*!*		LPARAMETERS pmavt
*!*		
*!*		IF !USED("dubd")
*!*			USE data\dubd IN 0
*!*		ENDIF 
*!*		
*!*		SELECT dubd	
*!*		recno_dubd=IIF(EOF() or BOF(),0,RECNO())

*!*		SET TALK OFF 
*!*		SUM kl*dg FOR pmavt==mavt TO kq
*!*		
*!*		IF recno_dubd>0
*!*			GO recno_dubd
*!*		ENDIF 
*!*		
*!*		RETURN kq
*!*	ENDFUNC 

*!*	***************************************************
*!*	**Ham lay khoi luong du ban dau cua mot ma vat tu theo tung kho
*!*	FUNCTION getDubdkl()
*!*		LPARAMETERS pmavt,pmakho
*!*		IF !USED("dubd")
*!*			USE data\dubd IN 0
*!*		ENDIF 
*!*		SELECT dubd	
*!*		recno_dubd=IIF(EOF() or BOF(),0,RECNO())

*!*		SET TALK OFF 
*!*		SUM kl FOR mavt==pmavt AND (EMPTY(pmakho) OR makho==pmakho)TO kq
*!*		
*!*		IF recno_dubd>0
*!*			GO recno_dubd
*!*		ENDIF 
*!*		
*!*		RETURN kq
*!*	ENDFUNC 
*!*	***************************************************
*!*	**Ham lay thanh tien du ban dau cua mot ma vat tu theo tung kho
*!*	FUNCTION getDubdttkho()
*!*		LPARAMETERS pmavt,pmakho
*!*		
*!*		IF !USED("dubd")
*!*			USE data\dubd IN 0
*!*		ENDIF 
*!*		
*!*		SELECT dubd	
*!*		recno_dubd=IIF(EOF() or BOF(),0,RECNO())

*!*		SET TALK OFF 
*!*		SUM kl*dg FOR pmavt==mavt AND (EMPTY(pmakho) OR makho==pmakho) TO kq
*!*		
*!*		IF recno_dubd>0
*!*			GO recno_dubd
*!*		ENDIF 
*!*		
*!*		RETURN kq
*!*	ENDFUNC 

**Ham lay khoi luong du dau ky cua mot ma vat tu
FUNCTION getDudkkl(pmavt,ngay)
	
	old_alias=ALIAS()
	dudk=getdubdkl(pmavt)
	nhaptk=gettongkl(pmavt,DATE(1000,1,1),ngay-1,"PN")
	xuattk=gettongkl(pmavt,DATE(1000,1,1),ngay-1,"PX")
	kq=dudk+nhaptk-xuattk
	IF !EMPTY(old_alias)
		SELECT &old_alias
	ENDIF 
	RETURN kq
ENDFUNC 

**Ham lay thanh tien du dau ky cua mot ma vat tu
FUNCTION getDudktt(pmavt,ngay)
	old_alias=ALIAS()
	dudk=getdubdtt(pmavt)
	
	
	nhaptk=gettongtt(pmavt,DATE(1000,1,1),ngay-1,"PN")
	
	xuattk=gettongtt(pmavt,DATE(1000,1,1),ngay-1,"PX")
	
	kq=dudk+nhaptk-xuattk
	IF !EMPTY(old_alias)
		SELECT &old_alias
	ENDIF 
	RETURN kq
ENDFUNC 

**Ham lay khoi luong cuoi ky cua mot vat tu
FUNCTION getDuckkl(pmavt,ngay)
	old_alias=ALIAS()
	kq=getDudkkl(pmavt,ngay+1)
	IF !EMPTY(old_alias)
		SELECT &old_alias
	ENDIF 
	RETURN kq
	
ENDFUNC 

**Ham lay thanh tien du dau ky cua mot ma vat tu
FUNCTION getDucktt(pmavt,ngay)
	old_alias=ALIAS()
	kq=getDudktt(pmavt,ngay+1)

	IF !EMPTY(old_alias)
		SELECT &old_alias
	ENDIF 
	RETURN kq
ENDFUNC 
ENDPROC 

