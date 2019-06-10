*&---------------------------------------------------------------------*
*& Report ZFI_P101N
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* Taným : LÝSANS ÖNLÝSANS FATURA PROGRAMI
*----------------------------------------------------------------------*
* Geliþtirme Danýþmaný  :	A.Doðancan Okur
* Tarih                 : 05.03.2019 08:52:57
*----------------------------------------------------------------------*

REPORT ZFI_P101N.

INCLUDE ZFI_P101N_DATA.
INCLUDE ZFI_P101N_SCR.
INCLUDE ZFI_P101N_FORM.
INCLUDE ZFI_P101N_STDN.

START-OF-SELECTION.

  GV_PERID = P_PERSL+3(1).                       " PARAMETREDE ALDIÐIMIZ YIL DÖNEMÝN DÖNEMÝNÝ KAYDETTÝK

  CONCATENATE '20' P_PERSL+0(2) INTO GV_PERYR.   " 18-1 DE OLAN 18 Ý 2018 E DÖNÜÞTÜRDÜK

  CONCATENATE '00' P_PERSL+3(1) INTO GV_PERID.   " 18-1 DE OLAN 1 Ý 001 E DÖNÜÞTÜRDÜK

  IF GV_PERID EQ '001' OR GV_PERID EQ '002'.

    IF P_TDONEM BETWEEN '1' AND '10'.            " TAKSÝT DÖNEMÝ 1 ÝLE 10 ARASINDA ÝSE ÇALIÞTIR

      PERFORM GET_DATA.

    ELSE.

      MESSAGE 'Tarih aralýðýný 1-10 arasýnda giriniz.' TYPE 'I'.

      LEAVE LIST-PROCESSING.

    ENDIF.

  ELSE.

    MESSAGE 'Dönemi 1 veya 2 olarak giriniz. ( Örn: XX-1 yada XX-2 )' TYPE 'I'.

    LEAVE LIST-PROCESSING.

  ENDIF.

*END-OF-SELECTION.

  PERFORM GET_ALV.
