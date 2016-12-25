FUNCTION __checkphieuvalidation	
	olddatass=SET("Datasession") 
	SET DATASESSION TO 1
	IF !USED("khoaso")
		USE data\khoaso IN 0
		
	ENDIF 

	
	IF EMPTY(khoaso.ngayksht) &&Chua nhap ngay khoa so do vay luon luon sua doi thoai mai
	SET DATASESSION TO (olddatass)
	RETURN .T. &&Validate
	ENDIF 

	IF phieu.ngaylap>khoaso.ngayksht && Ngaylap o phieu lon hon ngay khoa so hien tai duoc phep cap nhap
	SET DATASESSION TO (olddatass)
	RETURN .T.
	ENDIF 
	
 	MESSAGEBOX("Da khoa so, ban khong the thuc hien thao tac nay") 
	SET DATASESSION TO (olddatass)	
	RETURN .F.
ENDFUNC	

