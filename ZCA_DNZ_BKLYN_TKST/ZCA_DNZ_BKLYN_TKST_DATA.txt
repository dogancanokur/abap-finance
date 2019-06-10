*&---------------------------------------------------------------------*
*&  Include           ZCA_DNZ_BKLYN_TKST_DATA
*&---------------------------------------------------------------------*


TABLES:  zcat_thslt_head, cmacdb_feehd.

DATA gt_return_tab TYPE STANDARD TABLE OF ddshretval WITH HEADER LINE.

DATA: gt_dnz TYPE TABLE OF zcas_dnz_kayit_guncelleme,
      gs_dnz TYPE zcas_dnz_kayit_guncelleme.

DATA: gt_fcat TYPE lvc_t_fcat,
      gs_fcat TYPE lvc_s_fcat,
      gs_layo TYPE lvc_s_layo,
      go_grid TYPE REF TO cl_gui_alv_grid.

**>> Begin of Insert   xozturkb  14.08.2018 13:43:29

DATA : gt_event        TYPE TABLE OF slis_alv_event,
       gs_event        TYPE          slis_alv_event,
       gs_grid_setting TYPE   lvc_s_glay.
DATA: gs_edit TYPE lvc_s_styl,
      gt_edit TYPE lvc_t_styl.
**>> End of Insert    xozturkb
