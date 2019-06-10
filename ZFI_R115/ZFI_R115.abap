*&--------------------------------------------------------------------&
*& Report ZFI_R115                                                    &
*&--------------------------------------------------------------------&
*& Taným                 : YÜKSEK LÝSANS TAHSÝLAT RAPORU              &
*&--------------------------------------------------------------------&
*& Tarih                 : 24.05.2019 11:45:31                        &
*&--------------------------------------------------------------------&

REPORT ZFI_R115.

INCLUDE ZFI_R115_DATA.
INCLUDE ZFI_R115_SCR.
INCLUDE ZFI_R115_FORM.
INCLUDE ZFI_R115_HESAPLAMALAR.

START-OF-SELECTION.

  PERFORM GET_DATA.

END-OF-SELECTION.

  PERFORM GET_ALV.
