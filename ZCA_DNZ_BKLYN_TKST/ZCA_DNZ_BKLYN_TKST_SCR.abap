*&---------------------------------------------------------------------*
*&  Include           ZCA_DNZ_BKLYN_TKST_SCR
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
SELECT-OPTIONS:
  s_ogrno FOR gs_dnz-ogrno,
  s_tcno  FOR gs_dnz-tc_id,
  s_donem FOR zcat_thslt_head-donem,
  s_kyttp FOR gs_dnz-kayit_tipi,
  s_kyttr FOR gs_dnz-kayit_tarihi,
  s_kip   FOR cmacdb_feehd-feecalcmode.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-002.
SELECT-OPTIONS: S_TKST FOR GS_DNZ-TAKSIT_TARIHI.
PARAMETERS:
  p_tksdrm type ZCAD_TAKSIT2,
  p_kyttrh TYPE zcat_thslt_head-kayittrh.

SELECTION-SCREEN END OF BLOCK b2.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_ogrno-low.
  PERFORM get_student_searchhelp.
