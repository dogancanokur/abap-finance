

FORM get_student_searchhelp.

  CALL FUNCTION 'F4IF_FIELD_VALUE_REQUEST'
    EXPORTING
      tabname           = 'PIQST00'
      fieldname         = 'STUDENT12'
      searchhelp        = 'HRPIQ00STUDENT'
      shlpparam         = 'SHORT '
    TABLES
      return_tab        = gt_return_tab
    EXCEPTIONS
      field_not_found   = 1
      no_help_for_field = 2
      inconsistent_help = 3
      no_values_found   = 4
      OTHERS            = 5.

  s_ogrno-low = gt_return_tab-fieldval.
ENDFORM.

**********************************************************************

FORM get_data.
  DATA: lt_1702 TYPE TABLE OF hrp1702,
        ls_1702 TYPE hrp1702.

  DATA: lv_vorna TYPE hrp1702-vorna,
        lv_nachn TYPE hrp1702-nachn.

  IF s_ogrno[] IS NOT INITIAL.
    SELECT
      h~objid
      h~prdni
      FROM hrp1702 AS h
      INNER JOIN cmacbpst AS c
      ON h~objid EQ c~stobjid
      INTO CORRESPONDING FIELDS OF TABLE lt_1702
      WHERE c~student12 IN s_ogrno
        AND h~plvar EQ '01'
        AND h~otype EQ 'ST'
        AND h~begda LE sy-datum
        AND h~endda GE sy-datum.

    LOOP AT lt_1702 INTO ls_1702.
      s_tcno-low    = ls_1702-prdni.
      s_tcno-sign   = 'I'.
      s_tcno-option = 'EQ'.
      COLLECT s_tcno.
    ENDLOOP.
  ENDIF.
IF P_TKSDRM IS NOT INITIAL.

  SELECT * FROM zcat_dnz_srg_lg2
    INTO CORRESPONDING FIELDS OF TABLE gt_dnz
    WHERE tc_id        IN s_tcno
      AND sezon        IN s_donem
      AND kayit_tipi   IN s_kyttp
      AND kayit_tarihi IN s_kyttr
      AND kip          IN s_kip
      AND TAKSIT_DURUMU EQ P_TKSDRM
      AND TAKSIT_TARIHI IN S_TKST.


ELSE.

  SELECT * FROM zcat_dnz_srg_lg2
    INTO CORRESPONDING FIELDS OF TABLE gt_dnz
    WHERE tc_id        IN s_tcno
      AND sezon        IN s_donem
      AND kayit_tipi   IN s_kyttp
      AND kayit_tarihi IN s_kyttr
      AND kip          IN s_kip
      AND TAKSIT_TARIHI IN S_TKST.

ENDIF.


   LOOP AT gt_dnz INTO gs_dnz.

    IF gs_dnz-kayit_tipi EQ '2' AND gs_dnz-docno EQ space.
      DELETE gt_dnz.
      DELETE gt_dnz WHERE tc_id  EQ gs_dnz-tc_id
                      AND program_id  EQ gs_dnz-program_id
                      AND kayit_tipi EQ '3'.
      CONTINUE.
    ENDIF.
    SELECT SINGLE
      c~student12
      FROM hrp1702 AS h
      INNER JOIN cmacbpst AS c
      ON h~objid EQ c~stobjid
      INTO gs_dnz-ogrno
      WHERE h~prdni EQ gs_dnz-tc_id
        AND h~plvar EQ '01'
        AND h~otype EQ 'ST'
        AND h~begda LE sy-datum
        AND h~endda GE sy-datum.

    CLEAR: lv_vorna, lv_nachn.
    SELECT SINGLE vorna nachn
      FROM hrp1702 AS a
      INNER JOIN cmacbpst AS b ON a~objid = b~stobjid
      INTO ( lv_vorna, lv_nachn )
      WHERE a~plvar EQ '01'
      AND   a~otype EQ 'ST'
      AND   b~student12 EQ gs_dnz-ogrno
      AND   a~begda LE sy-datum
      AND   a~endda GE sy-datum.

    CONCATENATE lv_vorna lv_nachn INTO gs_dnz-adsoyad SEPARATED BY space.

    MODIFY gt_dnz FROM gs_dnz.
  ENDLOOP.
ENDFORM.

**********************************************************************

FORM set_data.
  PERFORM create_layout.
  PERFORM set_events.
  PERFORM create_fcat.
  "ALV input özelliðini deðiþtir
  PERFORM change_input_value.
  PERFORM display_alv.
ENDFORM.

**********************************************************************

FORM create_layout.
  gs_layo-sel_mode   = 'D'.
  gs_layo-zebra      = 'X'.
  gs_layo-col_opt    = 'X'.
  gs_layo-box_fname  = 'CELL'.
  gs_layo-stylefname = 'STYLE'.
ENDFORM.

**********************************************************************

FORM create_fcat.

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = 'ZCAS_DNZ_KAYIT_GUNCELLEME'
    CHANGING
      ct_fieldcat            = gt_fcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

  DELETE gt_fcat WHERE fieldname EQ 'CELL'.

  LOOP AT gt_fcat INTO gs_fcat.
    CASE gs_fcat-fieldname.
      WHEN 'TAKSIT_TARIHI'
        OR 'SGTXT'
        OR 'THSLTTUR'
        OR 'THSLTHESAP'.
        gs_fcat-edit = 'X'.
      WHEN 'PROGRAM_ID'.
        gs_fcat-edit = 'X'.
        gs_fcat-ref_field = 'PROGRAM_ID'.
        gs_fcat-f4availabl = 'X'.
      WHEN 'URUN_ADI'.
        gs_fcat-scrtext_s = 'Ürün Adý'.
        gs_fcat-scrtext_l = 'Ürün Adý'.
        gs_fcat-scrtext_m = 'Ürün Adý'.
        gs_fcat-reptext   = 'Ürün Adý'.
        gs_fcat-coltext   = 'Ürün Adý'.
        gs_fcat-outputlen = '50'.
      WHEN 'ACIKLAMA'.
        gs_fcat-scrtext_s = 'Açýklama'.
        gs_fcat-scrtext_l = 'Açýklama'.
        gs_fcat-scrtext_m = 'Açýklama'.
        gs_fcat-reptext   = 'Açýklama'.
        gs_fcat-coltext   = 'Açýklama'.
        gs_fcat-outputlen = '50'.
      WHEN 'HAVALE'.
        gs_fcat-scrtext_s = 'Havale'.
        gs_fcat-scrtext_l = 'Havale'.
        gs_fcat-scrtext_m = 'Havale'.
        gs_fcat-reptext   = 'Havale'.
        gs_fcat-coltext   = 'Havale'.
      WHEN 'ADSOYAD'.
        gs_fcat-scrtext_s = 'Ad Soyad'.
        gs_fcat-scrtext_l = 'Ad Soyad'.
        gs_fcat-scrtext_m = 'Ad Soyad'.
        gs_fcat-reptext   = 'Ad Soyad'.
        gs_fcat-coltext   = 'Ad Soyad'.
        gs_fcat-outputlen = '50'.
      WHEN 'ERROR'.
        gs_fcat-outputlen = '50'.
      WHEN OTHERS.
    ENDCASE.

    MODIFY gt_fcat FROM gs_fcat.
  ENDLOOP.
ENDFORM.

**********************************************************************

FORM display_alv.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
    EXPORTING
      i_grid_settings          = gs_grid_setting
      it_events                = gt_event
      i_callback_program       = sy-repid
      i_save                   = 'A'
      is_layout_lvc            = gs_layo
      it_fieldcat_lvc          = gt_fcat
      i_callback_pf_status_set = 'GUI'
      i_callback_user_command  = 'COMM'
    TABLES
      t_outtab                 = gt_dnz
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
ENDFORM.

**********************************************************************

FORM gui USING rt_extab TYPE slis_t_extab.
  SET PF-STATUS 'MENU'.
ENDFORM.

**********************************************************************

FORM comm USING r_ucomm LIKE sy-ucomm rs_selfield TYPE slis_selfield.

  DATA: ls_stable TYPE lvc_s_stbl.

  IF go_grid IS INITIAL .
    CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
      IMPORTING
        e_grid = go_grid.
  ENDIF.

  CALL METHOD go_grid->check_changed_data.

  CASE r_ucomm.
    WHEN 'KYDT'.
      PERFORM save.
    WHEN 'MHSB'.
      PERFORM muhasebelestir.
      PERFORM change_input_value.
    WHEN 'GTERS'.
      PERFORM ters_kayit.
      PERFORM change_input_value.
    WHEN 'PRNT'.
      PERFORM yazdir.
    WHEN '&F03' OR '&F15' OR '&F12'.
      LEAVE PROGRAM.
  ENDCASE.

  IF go_grid IS NOT INITIAL.
    ls_stable = 'XX'.

    CALL METHOD go_grid->refresh_table_display
      EXPORTING
        is_stable = ls_stable.
  ENDIF.

  rs_selfield-refresh = 'X'.
ENDFORM.

**********************************************************************

FORM save.
  DATA: ls_dnz TYPE zcat_dnz_srg_lg2.

  LOOP AT gt_dnz INTO gs_dnz WHERE cell EQ 'X'.
    CLEAR ls_dnz.
    MOVE-CORRESPONDING gs_dnz TO ls_dnz.
    MODIFY zcat_dnz_srg_lg2 FROM ls_dnz.
  ENDLOOP.
ENDFORM.

**********************************************************************

FORM muhasebelestir.
  DATA: ls_header TYPE bapidfkkko,
        lv_opbel  TYPE bapidfkkko-doc_no,
        lv_order  TYPE zcad_thslt,
        lv_fikey  TYPE fikey_kk,
        ls_return TYPE bapiret2,
        lv_gsber  TYPE zca_ws_gsber-gsber.

  DATA: lt_partpos  TYPE TABLE OF bapidfkkop   WITH HEADER LINE,
        lt_gledpos  TYPE TABLE OF bapidfkkopk  WITH HEADER LINE,
        lt_gledtext TYPE TABLE OF bapidfkkopkx WITH HEADER LINE.

  LOOP AT gt_dnz INTO gs_dnz WHERE cell EQ 'X'.
    CHECK : gs_dnz-docno IS INITIAL.

    CLEAR: ls_header, lv_opbel, ls_return,
      lv_fikey, lv_gsber, lv_order,
      lt_partpos[], lt_partpos,
      lt_gledpos[], lt_gledpos,
      lt_gledtext[], lt_gledtext.

    PERFORM get_fikey CHANGING lv_fikey.

    ls_header-appl_area         = 'P'.
    ls_header-doc_type          = 'ET'.
    ls_header-doc_source_key    = '01'.
    ls_header-currency          = gs_dnz-para_birimi.
    ls_header-doc_date          = p_kyttrh.
    ls_header-post_date         = p_kyttrh.
    ls_header-single_doc        = 'X'.
    ls_header-ref_doc_no        = '1000'.
    ls_header-fikey             = lv_fikey.

***

    lt_partpos-item             = '1'.
    lt_partpos-line_item        = 'X'.
    lt_partpos-comp_code        = '1000'.
    lt_partpos-buspartner       = gs_dnz-ogrno.
    lt_partpos-cont_acct        = gs_dnz-ogrno.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = lt_partpos-buspartner
      IMPORTING
        output = lt_partpos-buspartner.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = lt_partpos-cont_acct
      IMPORTING
        output = lt_partpos-cont_acct.

*    lt_partpos-text             = gs_dnz-ogrno && '-'
*                               && gs_dnz-adsoyad.
    lt_partpos-text             = gs_dnz-sgtxt.
    lt_partpos-contract         = 'EGTM' && gs_dnz-ogrno.
    lt_partpos-appl_area        = 'P'.
    lt_partpos-main_trans       = 'ET00'.
    lt_partpos-sub_trans        = 'DBKT'.
    lt_partpos-doc_date         = p_kyttrh.
    lt_partpos-post_date        = p_kyttrh.
    lt_partpos-net_date         = gs_dnz-taksit_tarihi.
    lt_partpos-amount           = - gs_dnz-taksit_miktari.
    lt_partpos-period_key       = gs_dnz-sezon.

    SELECT SINGLE gsber FROM
      zca_ws_gsber
      INTO lv_gsber
      WHERE fakulte EQ gs_dnz-urun_kodu+0(2).

    lt_partpos-bus_area         = lv_gsber.
    APPEND lt_partpos.

***

    lt_gledpos-item             = '1'.
    lt_gledpos-line_item        = 'X'.
    lt_gledpos-comp_code        = '1000'.
    lt_gledpos-g_l_acct         = gs_dnz-thslthesap.
    lt_gledpos-amount           = gs_dnz-taksit_miktari.
    lt_gledpos-fikey            = lv_fikey.
    APPEND  lt_gledpos.

***

    lt_gledtext-item            = '1'.
*    lt_gledtext-item_text       = gs_dnz-ogrno && '-'
*                               && gs_dnz-adsoyad.
    lt_gledtext-item_text       = gs_dnz-sgtxt.
    lt_gledtext-alloc_nmbr      = gs_dnz-ogrno.
    APPEND lt_gledtext.

    CALL FUNCTION 'BAPI_CTRACDOCUMENT_CREATE'
      EXPORTING
        testrun               = 'X'
        documentheader        = ls_header
        completedocument      = 'X'
      IMPORTING
        documentnumber        = lv_opbel
        return                = ls_return
      TABLES
        partnerpositions      = lt_partpos
        genledgerpositions    = lt_gledpos
        genledgerpositionsext = lt_gledtext.

    IF ls_return-type CA 'EAX'.
      gs_dnz-error = ls_return-message.
    ELSE.
      PERFORM get_number USING gs_dnz-sezon
                               gs_dnz-thslttur
                               sy-datum
                      CHANGING lv_order.

      ls_header-ref_doc_no = lv_order.

      IF lv_order IS INITIAL.
        gs_dnz-error = 'Tahsilat Makbuz numarasý alýnamadý!'.
      ELSE.
        CALL FUNCTION 'BAPI_CTRACDOCUMENT_CREATE'
          EXPORTING
            testrun               = ''
            documentheader        = ls_header
            completedocument      = 'X'
          IMPORTING
            documentnumber        = lv_opbel
            return                = ls_return
          TABLES
            partnerpositions      = lt_partpos
            genledgerpositions    = lt_gledpos
            genledgerpositionsext = lt_gledtext.

        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = 'X'.

        gs_dnz-kayit_tarihi = sy-datum.
        gs_dnz-docno = lv_opbel.
        gs_dnz-makbuz = lv_order.
        gs_dnz-havale = 'X'.

        UPDATE zcat_dnz_srg_lg2 SET docno  = lv_opbel
                                    makbuz = lv_order
                                    taksit_durumu = 'OD'
                                    havale = 'X'
                                    kayit_tarihi = sy-datum
                                    sgtxt        = gs_dnz-sgtxt
                                    thslttur     = gs_dnz-thslttur
                                    thslthesap   = gs_dnz-thslthesap
          WHERE taksit_id EQ gs_dnz-taksit_id.

        gs_dnz-error = 'Muhasebeleþtirme yapýldý.'.
      ENDIF.
    ENDIF.

    MODIFY gt_dnz FROM gs_dnz.
  ENDLOOP.
ENDFORM.

**********************************************************************

FORM get_fikey CHANGING p_fikey.

  DATA: lv_fikey TYPE fikey_kk.

*  Bugün açýlmýþ key var mý?
  SELECT SINGLE fikey FROM dfkksumc INTO lv_fikey
   WHERE cpudt = sy-datum
     AND ernam = sy-uname
     AND xclos NE 'X'
     AND fikey GE '1000000000' AND
         fikey LE '1999999999'.

  IF sy-subrc = 0.
*    Bugün açýlmýþ key varsa al
    p_fikey = lv_fikey.
  ELSE.
*    Yoksa yeni numara al ve key aç.
    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr = '01'
        object      = 'ZCA_FIKEY'
      IMPORTING
        number      = lv_fikey.
    CALL FUNCTION 'FKK_FIKEY_OPEN'
      EXPORTING
        i_fikey = lv_fikey.

    p_fikey = lv_fikey .
  ENDIF.
ENDFORM.

**********************************************************************

FORM get_number USING p_persl p_tur p_trh CHANGING p_order.
  DATA: lv_thltno TYPE zcad_thslt.

  CALL FUNCTION 'ZCA_TAHSILAT_NO'
    EXPORTING
      i_tur   = p_tur
      i_tarih = p_trh
    IMPORTING
      e_thslt = lv_thltno.

  p_order = lv_thltno.

ENDFORM.

**********************************************************************

FORM ters_kayit.
  DATA: lv_fikey  TYPE fikey_kk.

  LOOP AT gt_dnz INTO gs_dnz WHERE cell EQ 'X'.
    CHECK : gs_dnz-docno IS NOT INITIAL.
    IF gs_dnz-docno IS INITIAL.
      gs_dnz-error = 'Ters kayýt iþlemi sadece mu' &&
                     'hasebeleþmiþ kayýtlar için yapýlabilir!'.
    ELSE.
      CLEAR lv_fikey.
      PERFORM get_fikey CHANGING lv_fikey.
      CALL FUNCTION 'FKK_REVERSE_DOC'
        EXPORTING
          i_opbel       = gs_dnz-docno
          i_blart       = 'TK'
          i_augrd       = '05'
          i_fikey       = lv_fikey
          i_herkf       = '02'
        EXCEPTIONS
          cleared_items = 1
          OTHERS        = 2.
      IF sy-subrc EQ 0.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = 'X'.

        UPDATE zcat_dnz_srg_lg2 SET docno  = ''
                                    makbuz = ''
                                    havale = ''
                                    taksit_durumu = 'BE'
                                    kayit_tarihi = ''
                                    sgtxt        = ''
                                    thslttur     = ''
                                    thslthesap   = ''
          WHERE taksit_id EQ gs_dnz-taksit_id.

        CLEAR: gs_dnz-docno.

        gs_dnz-error        = 'Ters kayýt alýndý!'.
        gs_dnz-docno        = ''.
        gs_dnz-makbuz       = ''.
        gs_dnz-havale       = ''.
        gs_dnz-kayit_tarihi  = ''.
        gs_dnz-sgtxt        = ''.
        gs_dnz-thslttur     = ''.
        gs_dnz-thslthesap     = ''.
      ELSE.
        gs_dnz-error  = 'Ters kayýt alýnamadý!'.
      ENDIF.
    ENDIF.

    MODIFY gt_dnz FROM gs_dnz.
  ENDLOOP.
ENDFORM.

**********************************************************************

FORM yazdir.
  DATA: lv_aciklama TYPE zcad_aciklama,
        lv_name     TYPE zcad_name,
        lv_tc       TYPE piq_prdni,
        lv_thslt    TYPE zcad_name,
        lv_fname    TYPE rs38l_fnam.

  DATA: lv_tvorg LIKE zca_ws_odemetur-sub_trans,
        lt_tvorg TYPE TABLE OF zca_ws_odemetur,
        ls_tvorg TYPE zca_ws_odemetur.

  DATA: ls_output_options     TYPE ssfcompop,
        ls_job_output_options TYPE ssfcresop,
        ls_ctrlop             TYPE ssfctrlop,
        ls_job_output         TYPE ssfcresop,
        ls_outinfo            TYPE ssfcrescl,
        ls_return_info        TYPE ssfcrescl.

  DATA: lt_cek         TYPE zcay_thslt_cek,
        lt_senet       TYPE zcay_thslt_senet,
        lt_nakit       TYPE zcay_thslt_nakit,
        ls_nakit       LIKE LINE OF lt_nakit,
        lt_kredi       TYPE zcay_thslt_kredi,
        ls_kredi       LIKE LINE OF lt_kredi,
        lt_vade        TYPE zcay_thslt_vade,
        lt_mail        TYPE zcay_thslt_mail,
        lt_odeme       TYPE zcay_thslt_odeme,
        lt_odeme_print TYPE TABLE OF zcat_thslt_odeme.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = 'ZCA_OGR_VADE_MAKBUZ'
    IMPORTING
      fm_name            = lv_fname
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.

  LOOP AT gt_dnz INTO gs_dnz WHERE cell EQ 'X'.
    IF gs_dnz-thslttur EQ '1'.
      IF gs_dnz-docno IS INITIAL.
        gs_dnz-error = 'Muhasebeleþtirme yapýlmadan mak' &&
                       'buz çýktýsý alýnamaz!'.
      ELSE.
        CLEAR: lv_aciklama, lv_name, lv_tc, lv_thslt.

        lv_aciklama = gs_dnz-sgtxt.
        lv_name     = gs_dnz-adsoyad.
        lv_tc       = gs_dnz-tc_id.

        CALL FUNCTION 'SSF_OPEN'
          EXPORTING
            user_settings      = ' '
            output_options     = ls_output_options
          IMPORTING
            job_output_options = ls_job_output_options
          EXCEPTIONS
            formatting_error   = 1
            internal_error     = 2
            send_error         = 3
            user_canceled      = 4
            OTHERS             = 5.

        ls_ctrlop-preview   = 'X'.
        ls_ctrlop-no_open   = 'X'.
        ls_ctrlop-no_close  = 'X'.
        ls_ctrlop-getotf    = 'X'.

        CLEAR: lt_tvorg, ls_tvorg, lv_tvorg.
        SELECT * FROM zca_ws_odemetur INTO TABLE lt_tvorg
          WHERE hesap EQ gs_dnz-thslthesap.

        DELETE lt_tvorg WHERE sub_trans+1(1) EQ 'S'.
        READ TABLE lt_tvorg INTO ls_tvorg INDEX 1.
        IF sy-subrc EQ 0.
          lv_tvorg = ls_tvorg-sub_trans.
        ENDIF.

        ls_kredi-thsltno  = gs_dnz-makbuz.
        ls_kredi-itemno   = '10'.
        ls_kredi-tutar    = gs_dnz-taksit_miktari.
        ls_kredi-pbirim   = gs_dnz-para_birimi.
        ls_kredi-tvorg    = lv_tvorg.

        APPEND ls_kredi TO lt_kredi.

        CALL FUNCTION lv_fname
          EXPORTING
            control_parameters = ls_ctrlop
            output_options     = ls_output_options
            gv_tarih           = gs_dnz-taksit_tarihi
            gv_tahsilat        = gs_dnz-makbuz
            gv_ogrno           = gs_dnz-ogrno
            gv_name            = lv_name
            gv_tc              = lv_tc
            gv_donem           = gs_dnz-sezon
            gv_aciklama        = lv_aciklama
          IMPORTING
            job_output_info    = ls_return_info
            job_output_options = ls_job_output_options
          TABLES
            gt_nakit           = lt_nakit
            gt_senet           = lt_senet
            gt_cek             = lt_cek
            gt_mail            = lt_mail
            gt_vade            = lt_vade
            gt_kredi           = lt_kredi
            gt_odeme           = lt_odeme_print
          EXCEPTIONS
            formatting_error   = 1
            internal_error     = 2
            send_error         = 3
            user_canceled      = 4
            OTHERS             = 5.
        IF sy-subrc <> 0.
        ENDIF.

        CALL FUNCTION 'SSF_CLOSE'
          IMPORTING
            job_output_info  = ls_outinfo
          EXCEPTIONS
            formatting_error = 1
            internal_error   = 2
            send_error       = 3
            OTHERS           = 4.
      ENDIF.
    ELSE.
      gs_dnz-error = 'Yalnýzca KK biçiminde mak' &&
                     'buz çýktýsý alýnabilir!'.
    ENDIF.

    MODIFY gt_dnz FROM gs_dnz.
  ENDLOOP.
ENDFORM.


**>> Begin of Insert   xozturkb  14.08.2018 11:23:07
"ProgramId Deðiþmesi Durumunda Textleri Deðiþmesi

*&---------------------------------------------------------------------*
*&      Form  SET_EVENTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_events .

*  *>> Begin of Insert   xozturkb  14.08.2018 11:24:10
  "DATA_CHANGED Eventi Ýle Program_id deðiþimi yakalandý

  CLEAR :gs_event,gt_event.
  gs_event-name = 'DATA_CHANGED'.
  gs_event-form = 'DATA_CHANGED'.
  APPEND gs_event TO gt_event.

  gs_grid_setting-edt_cll_cb = abap_true.


*  *>> End of Insert    xozturkb
ENDFORM.

FORM data_changed
     USING lrc_i_dc TYPE REF TO cl_alv_changed_data_protocol.

  TYPES : BEGIN OF lty_hrp1000,
            objid TYPE hrobjid,
            short TYPE short_d,
            stext TYPE stext,
          END OF   lty_hrp1000.
  DATA : ls_hrp1000 TYPE lty_hrp1000.
  DATA : lt_mod_cells TYPE TABLE OF lvc_s_modi,
         ls_mod_cells TYPE          lvc_s_modi.

  CLEAR : lt_mod_cells,ls_mod_cells.
  "Deðiþiklik Yapýlan Satýrý oku

  lt_mod_cells = lrc_i_dc->mt_mod_cells.
  READ TABLE lt_mod_cells INTO ls_mod_cells INDEX 1.
  "Fieldname ve Value Deðeri Check Et

  CHECK : ls_mod_cells-fieldname EQ 'PROGRAM_ID'.
  CHECK : ls_mod_cells-value IS NOT INITIAL.


  "Objid ye ait textleri oku
  SELECT SINGLE objid
                short
                stext
    FROM hrp1000
    INTO ls_hrp1000
    WHERE     plvar EQ  '01'
      AND    otype  EQ  'SC'
      AND    istat  EQ  '1'
      AND    langu  EQ  'T'
      AND    objid  EQ ls_mod_cells-value.
  CHECK sy-subrc EQ 0.
*
*** This is how you modify a value in ALV GRID if needed
*** I_ROW_ID    = ALV GRID Indexi
*** I_TABIX     = LIT_ALV_NEW Indexi
*** I_FIELDNAME = Deðiþtirilecek Fieldname
*** I_VALUE     = Deðer

  lrc_i_dc->modify_cell( i_row_id    = ls_mod_cells-row_id
                         i_tabix     = ls_mod_cells-tabix
                         i_fieldname = 'URUN_KODU'
                         i_value     = ls_hrp1000-short ).

  lrc_i_dc->modify_cell( i_row_id  = ls_mod_cells-row_id
                       i_tabix     = ls_mod_cells-tabix
                       i_fieldname = 'URUN_ADI'
                       i_value     = ls_hrp1000-stext ).
ENDFORM.


**>> End of Insert    xozturkb
*&---------------------------------------------------------------------*
*&      Form  CHANGE_INPUT_VALUE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM change_input_value .

  "Satýr Bazýnda Input Açýp Kapatma
  LOOP AT gt_dnz INTO gs_dnz.
    CLEAR : gs_edit,gs_dnz-style.
    IF gs_dnz-docno IS INITIAL.
      gs_edit-style = cl_gui_alv_grid=>mc_style_enabled.
    ELSE.
      gs_edit-style = cl_gui_alv_grid=>mc_style_disabled.
    ENDIF.

    gs_edit-fieldname = 'TAKSIT_TARIHI'.
    gs_edit-style2 = space.
    gs_edit-style3 = space.
    gs_edit-style4 = space.
    gs_edit-maxlen = 8.
    INSERT gs_edit INTO TABLE gt_edit.
    gs_edit-fieldname = 'SGTXT'.
    gs_edit-style2 = space.
    gs_edit-style3 = space.
    gs_edit-style4 = space.
    gs_edit-maxlen = 50.
    INSERT gs_edit INTO TABLE gt_edit.
    gs_edit-fieldname = 'THSLTTUR'.
    gs_edit-style2 = space.
    gs_edit-style3 = space.
    gs_edit-style4 = space.
    gs_edit-maxlen = 1.
    INSERT gs_edit INTO TABLE gt_edit.
    gs_edit-fieldname = 'THSLTHESAP'.
    gs_edit-style2 = space.
    gs_edit-style3 = space.
    gs_edit-style4 = space.
    gs_edit-maxlen = 10.
*    INSERT gs_edit INTO TABLE gt_edit.
*    gs_edit-fieldname = 'PROGRAM_ID'.
*    gs_edit-style2 = space.
*    gs_edit-style3 = space.
*    gs_edit-style4 = space.
*    gs_edit-maxlen = 8.
    INSERT gs_edit INTO TABLE gt_edit.
    INSERT LINES OF gt_edit INTO TABLE gs_dnz-style.

    MODIFY gt_dnz INDEX sy-tabix FROM gs_dnz  TRANSPORTING
                                      style .
    CLEAR gt_edit.

  ENDLOOP.


ENDFORM.
