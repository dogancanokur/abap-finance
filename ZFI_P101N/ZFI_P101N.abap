*&---------------------------------------------------------------------*
*& Report ZFI_P101N
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* Tan�m : L�SANS �NL�SANS FATURA PROGRAMI
*----------------------------------------------------------------------*
* Geli�tirme Dan��man�  :	A.Do�ancan Okur
* Tarih                 : 05.03.2019 08:52:57
*----------------------------------------------------------------------*

REPORT ZFI_P101N.

INCLUDE ZFI_P101N_DATA.
INCLUDE ZFI_P101N_SCR.
INCLUDE ZFI_P101N_FORM.
INCLUDE ZFI_P101N_STDN.

START-OF-SELECTION.

  GV_PERID = P_PERSL+3(1).                       " PARAMETREDE ALDI�IMIZ YIL D�NEM�N D�NEM�N� KAYDETT�K

  CONCATENATE '20' P_PERSL+0(2) INTO GV_PERYR.   " 18-1 DE OLAN 18 � 2018 E D�N��T�RD�K

  CONCATENATE '00' P_PERSL+3(1) INTO GV_PERID.   " 18-1 DE OLAN 1 � 001 E D�N��T�RD�K

  IF GV_PERID EQ '001' OR GV_PERID EQ '002'.

    IF P_TDONEM BETWEEN '1' AND '10'.            " TAKS�T D�NEM� 1 �LE 10 ARASINDA �SE �ALI�TIR

      PERFORM GET_DATA.

    ELSE.

      MESSAGE 'Tarih aral���n� 1-10 aras�nda giriniz.' TYPE 'I'.

      LEAVE LIST-PROCESSING.

    ENDIF.

  ELSE.

    MESSAGE 'D�nemi 1 veya 2 olarak giriniz. ( �rn: XX-1 yada XX-2 )' TYPE 'I'.

    LEAVE LIST-PROCESSING.

  ENDIF.

*END-OF-SELECTION.

  PERFORM GET_ALV.
