*&---------------------------------------------------------------------*
*& Report ZCA_DNZ_BKLYN_TKST
*&---------------------------------------------------------------------*

*----------------------------------------------------------------------*
* Tan�m :
*----------------------------------------------------------------------*
* Geli�tirme Dan��man�  :	A.Do�ancan Okur
* Uygulama Dan��man�    :
* Geli�tirme No         :
* Tarih                 : 20.11.2018 11:42:45
*----------------------------------------------------------------------*

REPORT ZCA_DNZ_BKLYN_TKST.

INCLUDE ZCA_DNZ_BKLYN_TKST_DATA.
INCLUDE ZCA_DNZ_BKLYN_TKST_SCR.
*INCLUDE ZCA_DNZ_BKLYN_TKST_PBO_PAI.
INCLUDE ZCA_DNZ_BKLYN_TKST_FORM.

START-OF-SELECTION.
  PERFORM get_data.

END-OF-SELECTION.
  IF gt_dnz IS NOT INITIAL.
    PERFORM set_data.
  ELSE.
    MESSAGE 'Se�im kriterlerine uygun veri bulunamad�!'
      TYPE 'S' DISPLAY LIKE 'E'.
  ENDIF.
