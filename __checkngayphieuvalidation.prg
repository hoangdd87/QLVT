PARAMETERS mngayphieu &&kiem tra vao ngay mngayphieu da bi khoa so chua?

IF !USED("khoaso")
	USE data\khoaso IN 0
ENDIF 

GO TOP IN khoaso
IF EMPTY(khoaso.ngayksht) &&Chua nhap ngay khoa so do vay luon luon sua doi thoai mai
RETURN .T. &&Validate
ENDIF 

IF mngayphieu>khoaso.ngayksht && mngayphieu khong thuoc pham vi bi khoa so
	RETURN .T.
ENDIF 

 	
RETURN .F.


