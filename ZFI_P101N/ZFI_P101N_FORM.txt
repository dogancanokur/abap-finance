*&---------------------------------------------------------------------* " formun bilgi baþlýðý
*&  Include           ZFICA_OGR_FATURALAMA_FORMS
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      FORM SEARCH HELP ST_NO
*&---------------------------------------------------------------------*
FORM GET_STUDENT_SEARCHHELP CHANGING S_ST .
  CALL FUNCTION 'F4IF_FIELD_VALUE_REQUEST'
    EXPORTING
      TABNAME           = 'PIQST00'
      FIELDNAME         = 'STUDENT12'
      SEARCHHELP        = 'HRPIQ00STUDENT'
      SHLPPARAM         = 'SHORT '
    TABLES
      RETURN_TAB        = GT_RETURN_TAB
    EXCEPTIONS
      FIELD_NOT_FOUND   = 1
      NO_HELP_FOR_FIELD = 2
      INCONSISTENT_HELP = 3
      NO_VALUES_FOUND   = 4
      OTHERS            = 5.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  S_ST = GT_RETURN_TAB-FIELDVAL.

ENDFORM.


*&---------------------------------------------------------------------*
*&      FORM CREATE LAYOUT
*&---------------------------------------------------------------------*
FORM CREATE_LAYOUT .                                                                   " create_layout formunu oluþtur
  GS_LAYOUT-ZEBRA = 'X'.                                                               " alv yi zebra haline getir
  GS_LAYOUT-COLWIDTH_OPTIMIZE = 'X'.                                                   " alv nin kolonlarýný otomatik ayarla (boyunu)
  GS_LAYOUT-BOX_FIELDNAME  = 'SEL'.                                                    " alv de seçim alaný oluþtur
  GS_LAYOUT-INFO_FIELDNAME = 'COLOR'.                                                  " alv renklendirmek için layoutta alan aç
*  gs_layout-sel_mode = 'A'.
ENDFORM.

*&---------------------------------------------------------------------*
*&      FORM SHOW ALV
*&---------------------------------------------------------------------*
FORM SHOW_ALV .                                                                        " show_alv formunu oluþtur
  DATA: LT_FIELDCAT      TYPE LVC_T_FCAT,
        ALV_EVENTS       TYPE SLIS_T_EVENT WITH HEADER LINE,
        LS_GRID_SETTINGS TYPE LVC_S_GLAY,
        GS_LAYOUT_LVC    TYPE LVC_S_LAYO.

  LS_GRID_SETTINGS-EDT_CLL_CB = 'X'.                                                   " bir tablo düzenlendikten sonra iç tabloyu senkronize eder ?

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'                                         " alv de kullanacaðýmýz fieldcataloc ile strmizi birleþtirir
    EXPORTING
      I_PROGRAM_NAME         = SY-REPID
      I_INTERNAL_TABNAME     = 'GT_DATA'                                               " alv de kullanýlacak int table
      I_INCLNAME             = SY-REPID
      I_STRUCTURE_NAME       = 'ZFI_OGRENCI_FATURALSON'                                " alv de kullanýlacak str
*     I_STRUCTURE_NAME       = 'ZCAS_OGRENCI_FATURALAMA'
    CHANGING
      CT_FIELDCAT            = GT_FC[]                                                 " alv de kullanýlacak fieldcat
    EXCEPTIONS
      INCONSISTENT_INTERFACE = 1
      PROGRAM_ERROR          = 2
      OTHERS                 = 3.
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID                                                                " hata durumunda basýlacak hatalar
            TYPE SY-MSGTY
            NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  LOOP AT GT_FC INTO GS_FC.                                                            " fieldcatalog u döndür
    CASE GS_FC-FIELDNAME.                                                              " eðer alan adý
      WHEN 'PERYR'      OR                                                             "  bu alanlar ise
*           'YOKSISKD' OR
           'STGRP'      OR
           'DERS_DURUM' OR
           'KAYIT_TIPI' OR
           'STGRPT'     OR
           'DOCNR'      OR
           'PERYR'      OR
           'O_SHORT'    OR
           'PERSL'      OR
*           'YOKSISKD' OR
           'TDONEM'     OR
           'PARTNER'.
        GS_FC-NO_OUT = 'X'.                               " alvde gösterme
      WHEN OTHERS.
    ENDCASE.

    IF GS_FC-FIELDNAME EQ 'SC_OBJID'.                      " alana verilecek isim
      GS_FC-SELTEXT_S = 'Program ID'.
      GS_FC-SELTEXT_M = 'Program ID'.
      GS_FC-SELTEXT_L = 'Program ID'.
      GS_FC-REPTEXT_DDIC = 'Program ID'.

    ELSEIF GS_FC-FIELDNAME EQ 'SC_SHORT'.
      GS_FC-SELTEXT_S = 'Program Kod'.                      " alana verilecek isim
      GS_FC-SELTEXT_M = 'Program Kod'.
      GS_FC-SELTEXT_L = 'Program Kod'.
      GS_FC-REPTEXT_DDIC = 'Program Kod'.

    ELSEIF GS_FC-FIELDNAME EQ 'LOG'.
      GS_FC-SELTEXT_S = 'Ýþlem Sonuç'.                      " alana verilecek isim
      GS_FC-SELTEXT_M = 'Ýþlem Sonuç'.
      GS_FC-SELTEXT_L = 'Ýþlem Sonuç'.
      GS_FC-REPTEXT_DDIC = 'Ýþlem Sonuç'.

    ELSEIF GS_FC-FIELDNAME EQ 'SC_TEXT'.
      GS_FC-SELTEXT_S = 'Program Tnm'.                      " alana verilecek isim
      GS_FC-SELTEXT_M = 'Program Tnm'.
      GS_FC-SELTEXT_L = 'Program Tnm'.
      GS_FC-REPTEXT_DDIC = 'Program Tnm'.

    ELSEIF GS_FC-FIELDNAME EQ 'BLM_TEXT'.
      GS_FC-SELTEXT_S = 'Bölüm Tnm'.                      " alana verilecek isim
      GS_FC-SELTEXT_M = 'Bölüm Tnm'.
      GS_FC-SELTEXT_L = 'Bölüm Tnm'.
      GS_FC-REPTEXT_DDIC = 'Bölüm Tnm'.

    ELSEIF GS_FC-FIELDNAME EQ 'O_OBJID'.
      GS_FC-SELTEXT_S = 'Fakülte ID'.                     " alana verilecek isim
      GS_FC-SELTEXT_M = 'Fakülte ID'.
      GS_FC-SELTEXT_L = 'Fakülte ID'.

    ELSEIF GS_FC-FIELDNAME EQ 'O_TEXT'.
      GS_FC-SELTEXT_S = 'Fakülte Tnm.'.                    " alana verilecek isim
      GS_FC-SELTEXT_M = 'Fakülte Tnm.'.
      GS_FC-SELTEXT_L = 'Fakülte Tnm.'.

    ELSEIF GS_FC-FIELDNAME EQ 'ERKENKYT'.
      GS_FC-SELTEXT_S = 'Erken Kyt/Normal Dönem'.          " alana verilecek isim
      GS_FC-SELTEXT_M = 'Erken Kyt/Normal Dönem'.
      GS_FC-SELTEXT_L = 'Erken Kyt/Normal Dönem'.
      GS_FC-REPTEXT_DDIC = GS_FC-SELTEXT_L.

    ELSEIF GS_FC-FIELDNAME EQ 'TAHTUTAR'.
      GS_FC-SELTEXT_S = 'Ücret Hspl. Tahsilat Tutarý  '.   " alana verilecek isim
      GS_FC-SELTEXT_M = 'Ücret Hspl. Tahsilat Tutarý  '.
      GS_FC-SELTEXT_L = 'Ücret Hspl. Tahsilat Tutarý  '.
      GS_FC-REPTEXT_DDIC = GS_FC-SELTEXT_L.

    ELSEIF GS_FC-FIELDNAME EQ 'TAHTUTAR2'.
      GS_FC-SELTEXT_S = 'Tahakkuk Tutarý '.                " alana verilecek isim
      GS_FC-SELTEXT_M = 'Tahakkuk Tutarý '.
      GS_FC-SELTEXT_L = 'Tahakkuk Tutarý '.
      GS_FC-REPTEXT_DDIC = GS_FC-SELTEXT_L.

    ELSEIF GS_FC-FIELDNAME EQ 'HESAP'.
      GS_FC-EDIT  = 'X'.                                   " editlenebilir alan

    ELSEIF GS_FC-FIELDNAME EQ 'SIRA_NO'.
      GS_FC-SELTEXT_S = 'Sýra No '.                        " alana verilecek isim
      GS_FC-SELTEXT_M = 'Sýra No '.
      GS_FC-SELTEXT_L = 'Sýra No '.
      GS_FC-REPTEXT_DDIC = GS_FC-SELTEXT_L.
      GS_FC-EDIT  = 'X'.

    ELSEIF GS_FC-FIELDNAME EQ 'PROGRAM_PBIRIM'.
      GS_FC-SELTEXT_S = 'Prog.Para Birimi'.                " alana verilecek isim
      GS_FC-SELTEXT_M = 'Prog.Para Birimi '.
      GS_FC-SELTEXT_L = 'Prog.Para Birimi'.
      GS_FC-REPTEXT_DDIC = GS_FC-SELTEXT_L.

    ELSEIF GS_FC-FIELDNAME EQ 'STFEECAT'.
      GS_FC-SELTEXT_S = 'Ücret Kategorisi'.                " alana verilecek isim
      GS_FC-SELTEXT_M = 'Ücret Kategorisi'.
      GS_FC-SELTEXT_L = 'Ücret Kategorisi'.
      GS_FC-REPTEXT_DDIC = GS_FC-SELTEXT_L.

    ELSEIF GS_FC-FIELDNAME EQ 'KDVSIZ'.
      GS_FC-CHECKBOX = 'X'.                                " bu alan checkbox ve editlenebilir alandýr
      GS_FC-EDIT = 'X'.
      GS_FC-SELTEXT_L =  'Kdvsiz'.

    ELSEIF GS_FC-FIELDNAME EQ 'FTRSIZ'.
      GS_FC-CHECKBOX = 'X'.                                " bu alan checkbox ve editlenebilir alandýr
      GS_FC-EDIT = 'X'.
      GS_FC-SELTEXT_L =  'Faturalanmayacak'.
*    ENDIF.

    ELSEIF GS_FC-FIELDNAME EQ 'TARIH'.
*      GS_FC-CHECKBOX = 'X'.                                " bu alan checkbox ve editlenebilir alandýr
*      GS_FC-EDIT = 'X'.
      GS_FC-SELTEXT_L =  'Fatura Tarihi'.
    ENDIF.

    MODIFY GT_FC FROM GS_FC.                               " gt_fc yi modife ediyoruz loopun içinde
  ENDLOOP.


  CALL FUNCTION 'LVC_TRANSFER_FROM_SLIS'
    EXPORTING
      IT_FIELDCAT_ALV = GT_FC[]
    IMPORTING
      ET_FIELDCAT_LVC = LT_FIELDCAT[]
    TABLES
      IT_DATA         = GT_DATA[].

  ALV_EVENTS-NAME    = SLIS_EV_DATA_CHANGED .
  ALV_EVENTS-FORM    = 'ALV_DATA_CHANGED'.
  APPEND ALV_EVENTS.


  GS_LAYOUT_LVC-CWIDTH_OPT = 'X'.                          " OPTÝMÝZE EDÝLÝCEK ALV KOLONLARI
  GS_LAYOUT_LVC-ZEBRA = 'X'.                               " ALV ZEBRA ÞEKLÝNDE
  GS_LAYOUT_LVC-BOX_FNAME = 'SEL'.
  GS_LAYOUT_LVC-INFO_FNAME = 'COLOR'.
  GS_LAYOUT_LVC-STYLEFNAME = 'FIELD_STYLE'.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
    EXPORTING
      I_CALLBACK_PF_STATUS_SET = 'FORM_MENU'
      I_CALLBACK_PROGRAM       = SY-REPID
      IS_LAYOUT_LVC            = GS_LAYOUT_LVC
      I_SAVE                   = 'A'
      I_CALLBACK_USER_COMMAND  = 'USER_COMMAND'
      I_GRID_SETTINGS          = LS_GRID_SETTINGS
      IT_FIELDCAT_LVC          = LT_FIELDCAT
      IT_EVENTS                = ALV_EVENTS[]
    TABLES
      T_OUTTAB                 = GT_DATA
    EXCEPTIONS
      PROGRAM_ERROR            = 1
      OTHERS                   = 2.
  IF SY-SUBRC <> 0.
  ENDIF.


ENDFORM.
*&=====================================================================*
*&----------- FORM_MENU
*&=====================================================================*
FORM FORM_MENU USING RT_EXTAB TYPE SLIS_T_EXTAB.
  SET PF-STATUS 'MENU'.                                                       " PF-STATUS Ü MENU OLARAK TANIMLIYORUZ
ENDFORM.

*&=====================================================================*
*&----------- USER_COMMAND
*&=====================================================================*
FORM USER_COMMAND USING R_UCOMM LIKE SY-UCOMM
                 RS_SELFIELD TYPE SLIS_SELFIELD.

  DATA :LV_REVDOCNO           TYPE FKKKO-OPBEL,
        LV_FM_NAME            TYPE RS38L_FNAM,
        LS_OUTPUT_OPTIONS     TYPE SSFCOMPOP,
        LS_JOB_OUTPUT_OPTIONS TYPE SSFCRESOP,
        LV_OBJID              TYPE HROBJID,
        LS_CMAC               TYPE CMACBPST,
        LV_DEGER              TYPE P DECIMALS 2 LENGTH 13,
        LV_TOTAL              TYPE BAPIDFKKOPK-AMOUNT,
        LV_AMOUNTBAPI         TYPE BAPIDFKKOPK-AMOUNT,
        LS_RETURN             TYPE  SSFCRESCL,
        STANDARDADDRESSNUMBER TYPE
                                BAPIBUS1006_ADDRESSES_INT-ADDRNUMBER,
        STANDARDADDRESSGUID   TYPE
                                BAPIBUS1006_ADDRESSES_INT-ADDRGUID,
        LV_ADRTYPE            TYPE BAPIBUS1006_ADDRESSUSAGE-ADDRESSTYPE,
        LT_ITEM               TYPE TABLE OF TY_DFKKOP,
        LS_ITEM               LIKE LINE OF LT_ITEM,
        LS_LOG                TYPE ZFI_OGRFAT_LOG,
        LS_STYLEROW           TYPE LVC_S_STYL,
        LS_STYLE              TYPE LVC_S_STYL,
        LT_STYLETAB           TYPE LVC_T_STYL,
        LT_LOG2               TYPE  TABLE OF ZFI_OGRFAT_LOG,
        LS_LOG2               LIKE LINE OF LT_LOG2.

  DATA: LV_AMOUNT     TYPE P DECIMALS 2,
        LV_FARK       TYPE BAPIDFKKOPK-AMOUNT,
        LV_ADD        TYPE BAPIDFKKOPK-AMOUNT,
        LV_FRAK       TYPE P DECIMALS 0,
        LV_KDVSZ      TYPE BAPIDFKKOPK-AMOUNT,
        LV_ROUNDED    TYPE P DECIMALS 2,
        LV_TAKSITDNM  TYPE ZCAT_YUS_FAT_LOG-TAKSIT_DONEM,
        LV_KALAN      TYPE ZCAT_YUS_FAT_LOG-TAKSIT_DONEM,
        LV_INDIRIM    TYPE ZCAD_TUTAR,
        LV_BAPIAMOUNT TYPE BAPIDFKKOPK-AMOUNT.
  DATA: LV_PRINT        TYPE CHAR01,
        LT_GLED         TYPE TABLE OF BAPIDFKKOPK,
        LS_GLED         LIKE LINE OF  LT_GLED,
        LT_PART         TYPE TABLE OF BAPIDFKKOP,
        LS_PART         TYPE          BAPIDFKKOP,
        LV_EGTMDONEM(9) TYPE C,
        LV_PERYR        TYPE PERSL_KK,
        LV_NEXTPERYR    TYPE PERSL_KK,
        LV_ANSWER,
        LV_VALUE        TYPE SPOP-VARVALUE1,
        LV_REVERSDATE   TYPE SY-DATUM.
*        lv_itemsum      TYPE p DECIMALS 4 LENGTH 13,
*        lv_headsum      TYPE p DECIMALS 4 LENGTH 13.

  CONCATENATE   '20' P_PERSL+0(2) INTO LV_PERYR.                           " YILI 2018 HALÝNE GETÝRÝYORUZ
  LV_NEXTPERYR = LV_PERYR + 1.                                             " BÝR SONRA OLAN SENEYÝ ALIYORUZ

  CONCATENATE LV_PERYR '-' LV_NEXTPERYR INTO LV_EGTMDONEM.                 " 2018-2019 HALÝNE GETÝRÝYORUZ


  CASE R_UCOMM.                                                            " EÐER ALV DE BASILAN TUÞ
    WHEN '&IC1'.                                                           " &IC1 ÝSE
      IF RS_SELFIELD-FIELDNAME = 'BELGE_NO'.                               " ALAN BELGE NO ÝSE
        READ TABLE GT_DATA INTO GS_DATA INDEX RS_SELFIELD-TABINDEX.        " GT_DATA DAN OKU
        IF SY-SUBRC EQ 0.
          IF RS_SELFIELD-FIELDNAME = 'BELGE_NO'.                           " BELGE NUMARASINI YAZ

            SET PARAMETER ID '80B' FIELD RS_SELFIELD-VALUE.
            CALL TRANSACTION 'FPE3' AND SKIP FIRST SCREEN .

          ENDIF.
        ENDIF.
      ENDIF.
    WHEN 'MHSB'.
      IF P_IPTAL NE 'X'.
        " EÐER MUHASEBELEÞTÝRME TUÞU ÝSE
*&=============== Muhasebeleþtir
        LV_PRINT = ''.
        LOOP AT GT_DATA INTO GS_DATA WHERE SEL IS NOT INITIAL                 " GT_DATA DA WHERE DE OLAN KRÝTERLERE GÖRE LOOP YAPIYORUZ
                                   AND SIRA_NO IS NOT INITIAL
                                   AND FTRSIZ NE 'X'.
          IF GS_DATA-BUCRET NE '0.00'.                                        " BUCRET 0 A EÞÝT DEÐÝLSE
            IF GS_DATA-YAZDIRILDI EQ 'X'.                                     " YAZDIRILMIÞ ÝSE
              IF GS_DATA-BELGE_NO IS INITIAL.                                 " BELGE NUMARASI YOKSA
*              PERFORM muhasebelestir  CHANGING gs_data.
                CLEAR:LT_PART[],LT_GLED[].
*&=====================================================================*
                PERFORM MUHASEBELESTIR TABLES LT_PART LT_GLED  USING LV_PRINT CHANGING GS_DATA . " MUHASEBELEÞTÝR FORMUNU ÇAÐIR
                IF GS_DATA-BELGE_NO IS NOT INITIAL.                            " gs_data da belge numarasý varsa
                  IF GS_DATA-FIELD_STYLE[] IS INITIAL.
                    LS_STYLEROW-FIELDNAME = 'FTRSIZ' .                         " faturasýz alanýný
                    LS_STYLEROW-STYLE = CL_GUI_ALV_GRID=>MC_STYLE_DISABLED.    "     giriþe kapalý hale getir
                    APPEND LS_STYLEROW  TO GS_DATA-FIELD_STYLE.                " deðiþikliði gs_datada field_style alanýna kaydet

                    LS_STYLEROW-FIELDNAME = 'HESAP' .                          " hesap alanýný
                    LS_STYLEROW-STYLE = CL_GUI_ALV_GRID=>MC_STYLE_DISABLED.    "     giriþe kapalý hale getir
                    APPEND LS_STYLEROW  TO GS_DATA-FIELD_STYLE.                " deðiþikliði gs_datada field_style alanýna kaydet

                    LS_STYLEROW-FIELDNAME = 'KDVSIZ' .                         " kdvsiz alanýný
                    LS_STYLEROW-STYLE = CL_GUI_ALV_GRID=>MC_STYLE_DISABLED.    "     giriþe kapalý hale getir
                    APPEND LS_STYLEROW  TO GS_DATA-FIELD_STYLE.                " deðiþikliði gs_datada field_style alanýna kaydet

                    LS_STYLEROW-FIELDNAME = 'SIRA_NO' .                        " sýra_no alanýný
                    LS_STYLEROW-STYLE = CL_GUI_ALV_GRID=>MC_STYLE_DISABLED.    "     giriþe kapalý hale getir
                    APPEND LS_STYLEROW  TO GS_DATA-FIELD_STYLE.                " deðiþikliði gs_datada field_style alanýna kaydet
                  ELSE.
                    CLEAR LS_STYLE.
                    LOOP AT GS_DATA-FIELD_STYLE INTO LS_STYLE.                 " GS_DATA-FIELD_STYLE I LOOPA SOK
                      LS_STYLE-STYLE = CL_GUI_ALV_GRID=>MC_STYLE_DISABLED.     "     giriþe kapalý hale getir
                      MODIFY GS_DATA-FIELD_STYLE FROM LS_STYLE.                " deðiþikliði gs_datada field_style alanýna kaydet
                    ENDLOOP.
                  ENDIF.
                ENDIF.
              ELSE.
                GS_DATA-COLOR = GC_COLOR_LIGHT_RED.                                                 " BAÞARISIZ OLURSA SATIRI KIRMIZI YAP
                GS_DATA-HATA   = 'Muhasebeleþmiþ kayýtlarda iþlem yapýlamaz!'.                      " HATA MESAJINI BAS
              ENDIF.
            ELSE.
              GS_DATA-COLOR = GC_COLOR_LIGHT_RED.                                                   " BAÞARISIZ OLURSA SATIRI KIRMIZI YAP
              GS_DATA-HATA   = 'Yazdýrma iþlemi yapýlmadan muhasebe iþlemi yapýlamaz!'.             " HATA MESAJINI BAS
            ENDIF.
          ELSE.
            GS_DATA-COLOR = GC_COLOR_LIGHT_RED.                                                     " BAÞARISIZ OLURSA SATIRI KIRMIZI YAP
            GS_DATA-HATA   = 'Muhasebeleþtirme iþlemi için tahakkuk tutarý alaný dolu olmalýdýr!'.  " HATA MESAJINI BAS
          ENDIF.
          MODIFY GT_DATA FROM GS_DATA.                                        " GT_DATA YI MODÝFE ET
        ENDLOOP.
        RS_SELFIELD-REFRESH = 'X'.                                            " LOOPTAN SONRA ALV YÝ REFRESHLE
        RS_SELFIELD-ROW_STABLE = 'X'.

      ENDIF.
    WHEN 'GUNCEL'.                                                          " GÜNCELLE ALANINA TIKLANMIÞ ÝSE
      IF P_IPTAL NE 'X'.

        LOOP AT GT_DATA INTO GS_DATA WHERE FTRSIZ NE 'X'                     " LOOPA WHERE DE ÝSTENENLERÝ DÖNDÜR
                                       AND BELGE_NO EQ SPACE.
          CLEAR LS_LOG.
          LS_LOG-BELGE_NO = GS_DATA-BELGE_NO.                                " BELGENO YU GÜNCELLE
          LS_LOG-OGRENCI = GS_DATA-STUDENT12.                                " ÖÐRENCÝ NOYU GÜNCELLE
          LS_LOG-PROGRAM_ID = GS_DATA-SC_OBJID.                              " PROGRAM ID YÝ GÜNCELLE
          LS_LOG-UCRET_DONEM = P_PERSL.                                      " DÖNEMÝ GÜNCELLE
          LS_LOG-TAKSIT_DONEM = P_TDONEM.                                    " TAKSÝT DÖNEMÝNÝ GÜNCELLE
          LS_LOG-SIRA_NO   = GS_DATA-SIRA_NO.                                " SIRANO YU GÜNCELLE
          LS_LOG-KULLANICI = SY-UNAME.                                       " ÝÞLEMÝ YAPAN KULLANICIYI GÜNCELLE
          LS_LOG-TARIH = SY-DATUM.                                           " TARÝHÝ GÜNCELLE
          LS_LOG-SAAT = SY-UZEIT.                                            " SAATÝ GÜNCELLE
          LS_LOG-YAZDIRILDI = GS_DATA-YAZDIRILDI.                            " YAZDIRILDI BÝLGÝSÝNÝ GÜNCELLE
          LS_LOG-HESAP = GS_DATA-HESAP.                                      " HESAP NUMARASNI GÜNCELLE
          LS_LOG-KDVSIZ = GS_DATA-KDVSIZ.                                    " KDVSÝZ BÝLGÝSÝNÝ GÜNCELLE
*&=====================================================================*
          LS_LOG-HESAP = GS_DATA-HESAP.                                      " HESAP NUMARASNI GÜNCELLE
*&=====================================================================*
          LS_LOG-PARA_BIRIMI = 'TRY'.                                        " PARA BÝRÝMÝNÝ TRY OLARAK GÜNCELLE
          MODIFY ZFI_OGRFAT_LOG FROM LS_LOG.                               " PROGRAMIN LOG TABLOSUNU GÜNCELLE
        ENDLOOP.
      ENDIF.
    WHEN '&NUMARA'.                                                        " NUMARA AL TUÞUNA BASILDIÐINDA
      IF P_IPTAL NE 'X'.
        PERFORM GET_NUMBERS.                                                 " NUMARA AL PERFORMUNU ÇALIÞTIR
        RS_SELFIELD-REFRESH = 'X'.                                           " ALV YÝ GÜNCELLE
        RS_SELFIELD-ROW_STABLE = 'X'.                                        " ?
      ENDIF.
    WHEN 'TERS'.                                                           " TERS KAYIT TUÞUNA BASILDIÐINDA

      DATA: LV_FIKEY        TYPE BAPIDFKKKO-FIKEY,
            LV_TOPLAMTAHSIL TYPE ZCAD_TUTAR,
            LV_TAHTUTAR2    TYPE ZCAD_TUTAR.

      CALL FUNCTION 'POPUP_TO_GET_ONE_VALUE'
        EXPORTING
          TEXTLINE1      = 'Ters Kayýt tarihini'
          TEXTLINE2      = 'giriniz.'
          TEXTLINE3      = '(Zorunlu alan)'
          TITEL          = 'Ters Kayýt Tarihi'
          VALUELENGTH    = '10'
        IMPORTING
          ANSWER         = LV_ANSWER
          VALUE1         = LV_VALUE
        EXCEPTIONS
          TITEL_TOO_LONG = 1
          OTHERS         = 2.
      IF LV_ANSWER EQ 'J'.
        IF  LV_VALUE IS INITIAL.
          MESSAGE 'Tarih gimediniz !' TYPE 'S' DISPLAY LIKE 'E'.
        ELSE.
*       lv_reversdate = lv_value.
          CLEAR LV_REVERSDATE.
          CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
            EXPORTING
              DATE_EXTERNAL            = LV_VALUE
*             ACCEPT_INITIAL_DATE      =
            IMPORTING
              DATE_INTERNAL            = LV_REVERSDATE
            EXCEPTIONS
              DATE_EXTERNAL_IS_INVALID = 1
              OTHERS                   = 2.
          IF SY-SUBRC <> 0.
* Implement suitable error handling here
            MESSAGE 'Tarih formatý hatalý !' TYPE 'S' DISPLAY LIKE 'E'.
          ELSE.
*        CLEAR lv_reversdate.
*        CONCATENATE lv_value+6(4) lv_value+4(2) lv_value+0(2)
*         INTO lv_reversdate.

            LOOP AT GT_DATA INTO GS_DATA WHERE SEL IS NOT INITIAL AND BELGE_NO IS NOT INITIAL
              AND FTRSIZ NE 'X' .
              IF GS_DATA-BELGE_NO IS NOT INITIAL.
                PERFORM GET_FIKEY CHANGING LV_FIKEY.
                CLEAR LV_REVDOCNO.
                CALL FUNCTION 'FKK_REVERSE_DOC'
                  EXPORTING
                    I_OPBEL       = GS_DATA-BELGE_NO
                    I_BLART       = 'TK'
                    I_AUGRD       = '05'
                    I_FIKEY       = LV_FIKEY
                    I_HERKF       = '02'
                    I_STODT       = LV_REVERSDATE
                  IMPORTING
                    E_OPBEL       = LV_REVDOCNO
                  EXCEPTIONS
                    CLEARED_ITEMS = 1
                    OTHERS        = 2.
                IF SY-SUBRC EQ 0.
* Implement suitable error handling here
                  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
                    EXPORTING
                      WAIT = 'X'.
                  GS_DATA-COLOR = GC_COLOR_LIGHT_GREEN.
                  GS_DATA-HATA   = 'Ters Kayýt Alýndý !'.
*            DELETE FROM ZFI_OGRFAT_LOG WHERE ogrenci = gs_data-student12
*                                   AND   program_id = gs_data-sc_objid
*                                   AND   ucret_donem  = p_persl
*                                   AND   taksit_donem = p_tdonem.

                  UPDATE ZFI_OGRFAT_LOG SET BELGE_NO   = ''
                                              TERS_KAYIT = 'X'
                                       WHERE  OGRENCI = GS_DATA-STUDENT12
                                       AND    PROGRAM_ID = GS_DATA-SC_OBJID
                                       AND    UCRET_DONEM = P_PERSL
                                       AND    TAKSIT_DONEM = P_TDONEM.

                  CLEAR :GS_DATA-BELGE_NO.
                ELSE.
                  GS_DATA-COLOR = GC_COLOR_LIGHT_RED.
                  GS_DATA-HATA   = 'Ters Kayýt Alýnamadý!'.

                ENDIF.

                IF GS_DATA-BELGE_NO IS  INITIAL.                                 " gs_data da belge numarasý varsa
                  IF GS_DATA-FIELD_STYLE[] IS INITIAL.
                    LS_STYLEROW-FIELDNAME = 'FTRSIZ' .                           " faturasýz alanýný
                    LS_STYLEROW-STYLE = CL_GUI_ALV_GRID=>MC_STYLE_ENABLED.       "     giriþe kapalý hale getir
                    APPEND LS_STYLEROW  TO GS_DATA-FIELD_STYLE.                  " deðiþikliði gs_datada field_style alanýna kaydet

                    LS_STYLEROW-FIELDNAME = 'HESAP' .                            " hesap alanýný
                    LS_STYLEROW-STYLE = CL_GUI_ALV_GRID=>MC_STYLE_ENABLED.       "     giriþe kapalý hale getir
                    APPEND LS_STYLEROW  TO GS_DATA-FIELD_STYLE.                  " deðiþikliði gs_datada field_style alanýna kaydet

                    LS_STYLEROW-FIELDNAME = 'KDVSIZ' .                           " kdvsiz alanýný
                    LS_STYLEROW-STYLE = CL_GUI_ALV_GRID=>MC_STYLE_ENABLED.       "     giriþe kapalý hale getir
                    APPEND LS_STYLEROW  TO GS_DATA-FIELD_STYLE.                  " deðiþikliði gs_datada field_style alanýna kaydet

                    LS_STYLEROW-FIELDNAME = 'SIRA_NO' .                          " sýra_no alanýný
                    LS_STYLEROW-STYLE = CL_GUI_ALV_GRID=>MC_STYLE_ENABLED.       "     giriþe kapalý hale getir
                    APPEND LS_STYLEROW  TO GS_DATA-FIELD_STYLE.                  " deðiþikliði gs_datada field_style alanýna kaydet
                  ELSE.
                    CLEAR LS_STYLE.
                    LOOP AT GS_DATA-FIELD_STYLE INTO LS_STYLE.                   " GS_DATA-FIELD_STYLE I LOOPA SOK
                      LS_STYLE-STYLE = CL_GUI_ALV_GRID=>MC_STYLE_ENABLED.        "     giriþe kapalý hale getir
                      MODIFY GS_DATA-FIELD_STYLE FROM LS_STYLE.                  " deðiþikliði gs_datada field_style alanýna kaydet
                    ENDLOOP.
                  ENDIF.
                ENDIF.
              ELSE.
                GS_DATA-COLOR = GC_COLOR_LIGHT_RED.                                     " HATA OLDUÐUNDAN KIRMIZI YAP SATIRI
                GS_DATA-HATA   = 'Belge muhasebeleþmediði için ters kayýt alýnamaz!'.   " HATA MESAJI BAS
              ENDIF.
              MODIFY GT_DATA FROM GS_DATA.                                        " GT_DATAYI MODÝFE ET
            ENDLOOP.
          ENDIF.
        ENDIF.
      ENDIF.
      RS_SELFIELD-REFRESH = 'X'.                                                  " ALVYÝ GÜNCELLE
      RS_SELFIELD-ROW_STABLE = 'X'.
**    W

    WHEN 'PRNT'.                                                                  " YAZDIRA BASILDIÐINDA

      IF P_IPTAL NE 'X'.
        CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'                                    " SMARTFORM MODÜLE ADINI AL
          EXPORTING
            FORMNAME           = 'ZCA_FATURA_LISANS_ONLISANS'                       " KULLANILACAK SMARTFORM ADI
          IMPORTING
            FM_NAME            = LV_FM_NAME
          EXCEPTIONS
            NO_FORM            = 1
            NO_FUNCTION_MODULE = 2
            OTHERS             = 3.

        CALL FUNCTION 'SSF_OPEN'                                                    " NE ÝLE YAZDIRILACAK ONUN ÝÇÝN
          EXPORTING
            USER_SETTINGS      = ' '
            OUTPUT_OPTIONS     = LS_OUTPUT_OPTIONS
          IMPORTING
            JOB_OUTPUT_OPTIONS = LS_JOB_OUTPUT_OPTIONS
          EXCEPTIONS
            FORMATTING_ERROR   = 1
            INTERNAL_ERROR     = 2
            SEND_ERROR         = 3
            USER_CANCELED      = 4
            OTHERS             = 5.

        LV_PRINT = 'X'.                                                             "LV_PRINT DEÐÝÞKENÝNE X AT
        LOOP AT GT_DATA INTO GS_DATA WHERE SEL IS NOT INITIAL                       " loopta istenen þartlarý where e yaz ara
                                       AND SIRA_NO IS NOT INITIAL
                                       AND FTRSIZ NE 'X' .

          CLEAR : WA_PRINT,IT_ADRES[],WA_ADRES, IT_ITEMS[],IT_PRINT[],
             LS_CMAC,LS_LOG,LV_INDIRIM,LV_BAPIAMOUNT,LV_TAKSITDNM,LV_AMOUNTBAPI,
             LV_DEGER,LV_FARK,LV_KDVSZ,LV_ROUNDED,LV_KALAN,LV_TAHTUTAR2.
          IF GS_DATA-STFEECAT NE 'YUUS'.                                            " öðrenci yuus ise
            LV_INDIRIM = GS_DATA-TAHTUTAR - GS_DATA-TAHTUTAR2.                      " ücret hesap tutarýndan tahakkuku çýkar
          ENDIF.
          WA_PRINT-ADI = GS_DATA-VORNA.                                             " smartformda kullanýlacak ad
          WA_PRINT-OGRENCINO = GS_DATA-STUDENT12.                                   " smartformda kullanýlacak öðrenci no
          WA_PRINT-SOYADI = GS_DATA-NACHN.                                          " smartformda kullanýlacak soyad
          WA_PRINT-PROGRAMKODU = GS_DATA-SC_OBJID.                                  " smartformda kullanýlacak program kodu
          WA_PRINT-KDVSIZ = GS_DATA-KDVSIZ.                                         " smartformda kullanýlacak kdvsiz
*         wa_print-progr = gs_data-sc_short.
          WA_PRINT-FAKULTEKODU = GS_DATA-O_OBJID.                                   " smartformda kullanýlacak fakülte kodu
          WA_PRINT-FAKULTEADI  = GS_DATA-O_TEXT.                                    " smartformda kullanýlacak fakülte adý
          WA_PRINT-FATURATARIH = P_DATUM.                                           " smartformda kullanýlacak fatura tarihi
          CONCATENATE LV_EGTMDONEM 'Dönemi' GS_DATA-BLM_TEXT INTO                   " eðitim dönemini yazýyoruz
                            WA_PRINT-BOLUMADI   SEPARATED BY SPACE.
          WA_PRINT-BELGENO = GS_DATA-BELGE_NO.                                      " belge numarasýný alýyoruz
          APPEND WA_PRINT TO IT_PRINT.                                              " work area yý internal table a atýyoruz
          CLEAR:WA_PRINT.
          CLEAR:LT_PART[],LT_GLED[].
          CLEAR:LS_PART,LS_GLED.
          PERFORM MUHASEBELESTIR TABLES LT_PART LT_GLED  USING LV_PRINT CHANGING GS_DATA .    " muhasebeleþtir formunu çaðýrýyoruz
          "TESTING
*          IF LV_FTRLNCK EQ '0.00'.
*            CONTINUE.
*          ENDIF.
*    6 = tip 1
*    7 = tip 2
          LOOP AT LT_GLED INTO LS_GLED.
            CLEAR WA_ITEMS.
            IF LS_GLED-G_L_ACCT+0(1) = '7'.
              WA_ITEMS-TIP = '2'.
            ELSEIF LS_GLED-G_L_ACCT+0(1) = '6'.
              WA_ITEMS-TIP = '1'.
            ENDIF.
            WA_ITEMS-ACIKLAMA =
           WA_ITEMS-TUTAR = LS_GLED-AMOUNT.
            APPEND WA_ITEMS TO IT_ITEMS.
*          lv_itemsum = lv_itemsum + ls_gled-amount.
          ENDLOOP.

          CLEAR : WA_ADRES,LS_CMAC.

          SELECT SINGLE * FROM CMACBPST
            INTO LS_CMAC WHERE STUDENT12 = GS_DATA-STUDENT12.

          CLEAR :STANDARDADDRESSNUMBER,STANDARDADDRESSGUID,LV_ADRTYPE.
          LV_ADRTYPE = '0002'.
          PERFORM GET_ADRESSES USING LS_CMAC-STOBJID LV_ADRTYPE
                                            CHANGING
                                            STANDARDADDRESSNUMBER
                                            STANDARDADDRESSGUID.
          IF STANDARDADDRESSNUMBER IS INITIAL.
            LV_ADRTYPE = 'XXDEFAULT'.
            PERFORM GET_ADRESSES USING LV_OBJID LV_ADRTYPE
                                           CHANGING
                                           STANDARDADDRESSNUMBER
                                           STANDARDADDRESSGUID.
            IF STANDARDADDRESSNUMBER IS NOT INITIAL.
              CLEAR WA_ADRES.
              WA_ADRES-ADDRESS_TYPE = LV_ADRTYPE.
              WA_ADRES-ADDRNUMBER   = STANDARDADDRESSNUMBER.
              WA_ADRES-FATURANO     = GS_DATA-SIRA_NO.
              SELECT SINGLE * FROM ADRC
                INTO CORRESPONDING FIELDS OF WA_ADRES
                 WHERE ADDRNUMBER = STANDARDADDRESSNUMBER.
              APPEND WA_ADRES TO IT_ADRES.
            ENDIF.
          ELSE.
            CLEAR WA_ADRES.
            WA_ADRES-ADDRESS_TYPE = LV_ADRTYPE.
            SELECT SINGLE REMARK FROM ADRCT INTO WA_ADRES-VERGIDAIRE
               WHERE ADDRNUMBER = STANDARDADDRESSNUMBER AND
                     LANGU = 'TR'.
            SELECT SINGLE * FROM ADRC
              INTO CORRESPONDING FIELDS OF WA_ADRES
               WHERE ADDRNUMBER = STANDARDADDRESSNUMBER.
            SELECT SINGLE ADEXT FROM BUT020 INTO WA_ADRES-VERGINO
               WHERE PARTNER  = LS_CMAC-PARTNER AND
                     ADDRNUMBER = STANDARDADDRESSNUMBER AND
                     ADDRESS_GUID = STANDARDADDRESSGUID.
            WA_ADRES-ADDRNUMBER   = STANDARDADDRESSNUMBER.
            WA_ADRES-FATURANO     = WA_PRINT-FATURANO.
            APPEND WA_ADRES TO IT_ADRES.
          ENDIF.

          PERFORM CALL_SMARTFORMS USING  LV_FM_NAME
                                         LS_OUTPUT_OPTIONS
                                         LS_JOB_OUTPUT_OPTIONS.
          IF GS_DATA-YAZDIRILDI NE 'X'.
            GS_DATA-YAZDIRILDI = 'X'.
            LS_LOG-BELGE_NO = GS_DATA-BELGE_NO.
            LS_LOG-OGRENCI = GS_DATA-STUDENT12.
            LS_LOG-PROGRAM_ID = GS_DATA-SC_OBJID.
            LS_LOG-UCRET_DONEM = P_PERSL.
            LS_LOG-TAKSIT_DONEM = P_TDONEM.
            LS_LOG-SIRA_NO   = GS_DATA-SIRA_NO.
            LS_LOG-KULLANICI = SY-UNAME.
            LS_LOG-TARIH = SY-DATUM.
            LS_LOG-SAAT = SY-UZEIT.
            LS_LOG-YAZDIRILDI = 'X'.
            LS_LOG-HESAP = GS_DATA-HESAP.
            LS_LOG-KDVSIZ = GS_DATA-KDVSIZ.
            MODIFY ZFI_OGRFAT_LOG FROM LS_LOG.
          ENDIF.
          MODIFY GT_DATA FROM GS_DATA.
        ENDLOOP.

        CALL FUNCTION 'SSF_CLOSE'
          IMPORTING
            JOB_OUTPUT_INFO  = LS_RETURN
          EXCEPTIONS
            FORMATTING_ERROR = 1
            INTERNAL_ERROR   = 2
            SEND_ERROR       = 3
            OTHERS           = 4.

        RS_SELFIELD-REFRESH = 'X'.
        RS_SELFIELD-ROW_STABLE = 'X'.
      ENDIF.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'CANCEL'.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
      LEAVE TO SCREEN 0.

  ENDCASE.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  MUHASEBELESTIR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GS_DATA  text
*      <--P_GS_DATA  text
*----------------------------------------------------------------------*
*FORM muhasebelestir  "USING pv_sira
*                     CHANGING ps_data LIKE gs_data.
FORM MUHASEBELESTIR TABLES LT_PART
                            LT_GLED  USING PRINT
                     CHANGING PS_DATA LIKE GS_DATA .


  DATA:  LS_HEADER    TYPE BAPIDFKKKO,
         LT_PARTPOS   TYPE TABLE OF BAPIDFKKOP
               INITIAL SIZE 1 WITH HEADER LINE,
         LT_GLEDPOS   TYPE TABLE OF BAPIDFKKOPK
               INITIAL SIZE 1 WITH HEADER LINE,
         LT_GLEDTEXT  TYPE TABLE OF BAPIDFKKOPKX
               INITIAL SIZE 1 WITH HEADER LINE,

         LV_FIKEY     TYPE FIKEY_KK,
         LV_ADSOYAD   TYPE OPTXT_KK,
         LV_DOCNO     TYPE OPBEL_KK,
         LV_DOC       TYPE OPBEL_KK,
         LV_GSBER     TYPE GSBER,
         LV_PRCTR     TYPE PRCTR,
         LV_GPART     TYPE GPART_KK,
         LV_HATA(250) TYPE C,
         LV_FTRTUTAR  TYPE P DECIMALS 2 LENGTH 16,
         LV_THKTUTAR  TYPE P DECIMALS 2 LENGTH 16,
         LV_OBJID     TYPE BAPISTUDENT_HEAD-OBJID,
         LV_ITEM      TYPE OPUPK_KK,
         LV_TUTAR     TYPE BAPIDFKKOPK-AMOUNT,
         LV_TOPLAM    TYPE P DECIMALS 2 LENGTH 13,
         LV_TOPLAM2   TYPE BAPIDFKKOPK-AMOUNT,
         LV_DEGER     TYPE P DECIMALS 2 LENGTH 13,
         LV_DEGER2    TYPE P DECIMALS 2 LENGTH 13,
         LV_DECIMAL   TYPE BAPIDFKKOPK-AMOUNT,
         LT_RETURN    TYPE TABLE OF BAPIRET2,
         LS_RETURN    TYPE BAPIRET2,
         LT_RETURN2   TYPE STANDARD TABLE OF BAPIRET2,
         LT_DFKKOP    TYPE TABLE OF TY_DFKKOP,
         LS_DFKKOP    LIKE LINE OF LT_DFKKOP,
         LS_DFKKOP2   LIKE LINE OF LT_DFKKOP,
         LS_LOG       TYPE ZFI_OGRFAT_LOG,
         LT_HESAP     TYPE TABLE OF ZCAT_FTRIND_HSP,
         LS_HESAP     LIKE LINE OF LT_HESAP,
         LT_LOG2      TYPE  TABLE OF ZFI_OGRFAT_LOG,
         LT_LOGTOPLAM TYPE TABLE OF ZFI_OGRFAT_LOG,
         LS_LOGTOPLAM LIKE LINE OF LT_LOGTOPLAM,
         LS_LOG2      LIKE LINE OF LT_LOG2,
         LV_FTRLNCK   TYPE ZCAD_TAHTUTAR2.


  DATA: LV_AMOUNT     TYPE P DECIMALS 2,
        LV_FARK       TYPE BAPIDFKKOPK-AMOUNT,
        LV_ADD        TYPE BAPIDFKKOPK-AMOUNT,
        LV_FRAK       TYPE P DECIMALS 0,
        LV_TAKSITDNM  TYPE ZCAT_YUS_FAT_LOG-TAKSIT_DONEM,
        LV_KALAN      TYPE ZCAT_YUS_FAT_LOG-TAKSIT_DONEM,
        LV_KDVSZ      TYPE BAPIDFKKOPK-AMOUNT,
        LV_ROUNDED    TYPE P DECIMALS 2,
        LV_INDIRIM    TYPE ZCAT_THSLT_HEAD-PROGRAM_TUTAR,
        LV_HKONT      TYPE HKONT_KK,
        LV_KDVSIZ     TYPE ZFI_OGRFAT_LOG-KDVSIZ,
        LV_PSNTKST    TYPE ZCAT_FTRIND_HSP-PSN_TKST,
        LV_TOPLAMFTR  TYPE ZFI_OGRFAT_LOG-TUTAR,
        LV_TOPLAMFTR2 TYPE ZFI_OGRFAT_LOG-TUTAR,
        LV_VIRMAN     TYPE P DECIMALS 2,
        LV_EF         TYPE P DECIMALS 2,
        LV_SUMBETRH   TYPE DFKKOPK-BETRH,
        LV_EKLENECEK  TYPE BAPIDFKKOPK-AMOUNT,
        LV_STNO2      TYPE GPART_KK.

  DATA: LV_STAMOUNT TYPE STRING,
        LV_CH1(10),
        LV_CH2(4).


  CLEAR: LT_PARTPOS, LT_GLEDPOS, LT_GLEDTEXT,
         LS_HEADER, LS_RETURN, LT_PARTPOS, LT_GLEDPOS, LT_GLEDTEXT,
         LV_DOCNO, LV_FIKEY, LV_GPART, LV_FARK,LV_ADD,LV_INDIRIM,LV_HKONT,LV_KDVSIZ,LV_KALAN.

  IF PRINT NE 'X'.
    PERFORM GET_FIKEY  CHANGING LV_FIKEY.
  ENDIF.


  LS_HEADER-APPL_AREA         = 'P'.
  LS_HEADER-DOC_TYPE          = 'EF'.
  LS_HEADER-DOC_SOURCE_KEY    = '01'.
  LS_HEADER-CURRENCY          = 'TRY'.
  LS_HEADER-DOC_DATE          = P_DATUM.
  LS_HEADER-POST_DATE         = P_DATUM.
  LS_HEADER-SINGLE_DOC        = 'X'.
  LS_HEADER-REF_DOC_NO        = GS_DATA-SIRA_NO.      "SIRANO  HEADER XBLNR ALANINA YAZ.
  LS_HEADER-FIKEY             = LV_FIKEY.

*  popup
*      OPBELÝN YANINA XBLNR gelecek.
  CLEAR :LV_GSBER.
  SELECT SINGLE GSBER FROM ZCA_WS_GSBER
       INTO  LV_GSBER
       WHERE FAKULTE = GS_DATA-O_SHORT2.

  SELECT * FROM ZCAT_FTRIND_HSP
    INTO TABLE LT_HESAP.

  LV_TAKSITDNM = P_TDONEM. " Taksit dönemi ekrandaki..


  IF LV_GSBER IS NOT INITIAL.

    IF GS_DATA-STGRP EQ '1000'.
      LV_PRCTR  = GC_1049999998.
    ELSE.
      LV_PRCTR  = GS_DATA-PRCTR.
    ENDIF.

    IF LV_PRCTR IS NOT INITIAL.
      CLEAR :LV_PSNTKST.
      CASE GS_DATA-PSN_TKST.
        WHEN 'T' .
          LV_PSNTKST = 'T'.
        WHEN 'P'.
          LV_PSNTKST = 'P'.

        WHEN OTHERS.
      ENDCASE.

      CLEAR LS_HESAP.
      READ TABLE LT_HESAP INTO LS_HESAP WITH KEY TUR   = GS_DATA-ERKENKYT
                                              PSN_TKST = LV_PSNTKST.
      IF SY-SUBRC EQ 0.
      ELSE.
      ENDIF.

      CLEAR LV_INDIRIM.

      IF GS_DATA-TAHTUTAR IS NOT INITIAL.
        LV_INDIRIM = ( GS_DATA-TAHTUTAR - GS_DATA-TAHTUTAR2 ) * ( GS_DATA-BUCRET / GS_DATA-TAHTUTAR ).
      ENDIF.

      CLEAR LV_TOPLAMFTR.

      LV_STNO2 = GS_DATA-STUDENT12.
      CONCATENATE '000' LV_STNO2 INTO LV_STNO2.

*      SELECT SUM( TUTAR )
*            FROM ZFI_OGRFAT_LOG
*            INTO LV_TOPLAMFTR
*            WHERE   OGRENCI EQ GS_DATA-STUDENT12
*                   AND  UCRET_DONEM EQ P_PERSL
*                   AND  TAKSIT_DONEM LT P_TDONEM
*                   AND  BELGE_NO NE SPACE.

      SELECT SUM( BETRW )
        FROM DFKKOP
        INTO LV_TOPLAMFTR
        WHERE PERSL EQ P_PERSL
          AND GPART EQ LV_STNO2
          AND AUGST NE '9'
          AND HVORG EQ 'EF00'
          AND TVORG EQ 'EF00'.

*      SELECT SUM( BETRW )                                         " manuel ef kaydý varmý ona bakýyoruz
*          FROM DFKKOP
*          INTO LV_EF
*          WHERE GPART EQ LV_STNO2
*            AND PERSL EQ P_PERSL
*            AND AUGST NE '9'
*            AND BLART EQ 'EF'
*            AND BETRH GT 0.
*
*      SELECT SUM( BETRW )                                         " manuel virman kaydý var mý ona bakýyoruz
*            FROM DFKKOP
*            INTO LV_VIRMAN
*            WHERE GPART EQ LV_STNO2
*              AND PERSL EQ P_PERSL
*              AND BLART EQ 'VR'
*              AND BETRH GT 0.

      CLEAR LV_FTRLNCK.                                            " lv_ftrlnck alanýný clearladýk
      IF GS_DATA-TAHTUTAR2 NE '0.00'.                              " tahtutar2 0 dan baþka biþi ise

*        IF LV_EF GT LV_TOPLAMFTR.                                  " ef toplam efden büyük ise
*          LV_FTRLNCK = GS_DATA-TAHTUTAR2 - LV_EF.                  " faturalancak tutardan efyi çýkarýyoruz
*        ELSE.
        LV_FTRLNCK = GS_DATA-TAHTUTAR2 - LV_TOPLAMFTR.           " küçük ise toplam faturayý çýkarýyoruz
*        ENDIF.

*        LV_FTRLNCK = LV_FTRLNCK - LV_VIRMAN.                       " virman ý ise faturalancaktan çýkarýyoruz

      ENDIF.

*        IF LV_FTRLNCK EQ '0.00'.
*
*          CONTINUE.
*
*        ENDIF.

      IF LV_FTRLNCK GT '0.00'.

        CLEAR LT_PARTPOS.
        LT_PARTPOS-ITEM             = '1'.
        LT_PARTPOS-LINE_ITEM        = 'X'.
        LT_PARTPOS-COMP_CODE        = '1000'.
        LT_PARTPOS-BUSPARTNER       = GS_DATA-STUDENT12.
        LT_PARTPOS-CONT_ACCT        = GS_DATA-STUDENT12.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            INPUT  = LT_PARTPOS-BUSPARTNER
          IMPORTING
            OUTPUT = LT_PARTPOS-BUSPARTNER.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            INPUT  = LT_PARTPOS-CONT_ACCT
          IMPORTING
            OUTPUT = LT_PARTPOS-CONT_ACCT.

        CLEAR LV_ADSOYAD.
        CONCATENATE  GS_DATA-VORNA GS_DATA-NACHN INTO
        LV_ADSOYAD SEPARATED BY SPACE.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
          EXPORTING
            INPUT  = GS_DATA-STUDENT12
          IMPORTING
            OUTPUT = LV_GPART.

        IF STRLEN( LV_GPART ) EQ '6'.
          LV_GPART = '0' && LV_GPART.
        ENDIF.

        LT_PARTPOS-TEXT             =  GS_DATA-STUDENT12 && '-' && LV_ADSOYAD.
        LT_PARTPOS-CONTRACT         = 'EGTM' && LV_GPART.
        LT_PARTPOS-CONTRACT2        =  GS_DATA-STUDENT12.
        LT_PARTPOS-APPL_AREA        = 'P'.
        LT_PARTPOS-MAIN_TRANS       = 'EF00'.
        LT_PARTPOS-SUB_TRANS        = 'EF00'.
        LT_PARTPOS-DOC_DATE         = P_DATUM.
        LT_PARTPOS-POST_DATE        = P_DATUM.
        LT_PARTPOS-NET_DATE         = P_DATUM.
        LT_PARTPOS-BUS_AREA         = LV_GSBER.
*&=============================== taksit miktarý
*        LV_KALAN = 3 - LV_TAKSITDNM.
        LV_KALAN = 11 - LV_TAKSITDNM.

        CLEAR LV_FTRTUTAR.

*        LV_FTRTUTAR                 = LV_FTRLNCK / 2 .
        LV_FTRTUTAR                 = LV_FTRLNCK / LV_KALAN .

        LT_PARTPOS-AMOUNT           =  LV_FTRTUTAR  .
        LT_PARTPOS-PERIOD_KEY       = P_PERSL.

        IF GS_DATA-KDVSIZ EQ ''.
          LT_PARTPOS-TAX_CODE         = 'A2'.
        ENDIF.

        LT_PARTPOS-BUS_AREA         = LV_GSBER.
        APPEND LT_PARTPOS.

      ENDIF.

      SELECT * FROM CMACDB_FEEFICA AS C
        INNER JOIN DFKKOPK AS D ON C~OPBEL =  D~OPBEL
        INTO CORRESPONDING FIELDS OF TABLE LT_DFKKOP
        WHERE C~DOCNR = GS_DATA-DOCNR.


      CLEAR LV_ITEM.
      CLEAR :LT_GLEDPOS[],LT_GLEDTEXT[].

      DATA: LV_KREDI TYPE BAPIDFKKOPK-AMOUNT.
      SORT LT_DFKKOP BY HKONT.
      LOOP AT LT_DFKKOP INTO LS_DFKKOP WHERE HKONT EQ '8400090012'.
        LV_KREDI = LV_KREDI + LS_DFKKOP-BETRH.
      ENDLOOP.
      DELETE LT_DFKKOP WHERE HKONT = '8400090012'.
      IF LV_KREDI NE '0.00'.
        READ TABLE LT_DFKKOP INTO LS_DFKKOP2 WITH KEY HKONT+0(2) = '80'.
        IF SY-SUBRC EQ 0.
          IF LS_DFKKOP2-BETRH LT '0.00'.
            LS_DFKKOP2-BETRH = LS_DFKKOP2-BETRH - LV_KREDI. "- iken + yapýldý
          ELSE.
            LS_DFKKOP2-BETRH = LS_DFKKOP2-BETRH + LV_KREDI.
          ENDIF.
          MODIFY LT_DFKKOP FROM LS_DFKKOP2  INDEX SY-TABIX.
        ENDIF.
      ENDIF.
      LOOP AT LT_DFKKOP INTO LS_DFKKOP .
        CLEAR LV_DEGER2.
        IF LS_DFKKOP-HKONT+0(2) = '80'.
          LS_DFKKOP-HKONT+0(1) = '6'.
          IF GS_DATA-HESAP IS NOT INITIAL.
            LS_DFKKOP-HKONT = GS_DATA-HESAP.
            LV_HKONT = GS_DATA-HESAP.
          ELSE.
            GS_DATA-HESAP = LS_DFKKOP-HKONT.
            LV_HKONT = GS_DATA-HESAP.
          ENDIF.
        ELSE.

          LS_DFKKOP-HKONT+0(1) = '7'.
        ENDIF.
        MODIFY LT_DFKKOP FROM LS_DFKKOP.


        CLEAR :LT_GLEDPOS,LT_GLEDTEXT.

        LT_GLEDPOS-LINE_ITEM        = 'X'.
        LT_GLEDPOS-COMP_CODE        = '1000'.
        LT_GLEDPOS-BUS_AREA         = LV_GSBER.
        LT_GLEDPOS-G_L_ACCT         = LS_DFKKOP-HKONT.
        LT_GLEDPOS-FIKEY            = LV_FIKEY .
        LT_GLEDPOS-PROFIT_CTR       = LV_PRCTR.

        IF LS_DFKKOP-HKONT+0(1) = '7'.
          LT_GLEDPOS-COSTCENTER      = LV_PRCTR.
        ENDIF.
        IF GS_DATA-KDVSIZ EQ ''.
          LT_GLEDPOS-TAX_CODE         = 'A2'.
        ENDIF.
        LT_GLEDPOS-FIKEY            = LV_FIKEY.


        IF LV_FTRTUTAR IS INITIAL.
*          LT_GLEDPOS-AMOUNT = LS_DFKKOP-BETRH / 2.
          LT_GLEDPOS-AMOUNT = LS_DFKKOP-BETRH / 10.                                       " 10 taksit oldðundan tutarý 10 a bölüyoruz
        ELSE.
          IF GS_DATA-KDVSIZ EQ ''.
            LT_GLEDPOS-AMOUNT           = ( LS_DFKKOP-BETRH * ( LV_FTRTUTAR / GS_DATA-TAHTUTAR  )  * 100 / 108 ). " kdv hesabý yaptýk ve çýkardýk

          ELSE.
            LT_GLEDPOS-AMOUNT           = ( LS_DFKKOP-BETRH * ( LV_FTRTUTAR / GS_DATA-TAHTUTAR  ) ). "
          ENDIF.
        ENDIF.


        LV_DEGER = LT_GLEDPOS-AMOUNT .
        LT_GLEDPOS-AMOUNT = LV_DEGER.

        IF LV_DEGER IS INITIAL.
          CONTINUE.
        ENDIF.

        ADD 1 TO LV_ITEM.
        LT_GLEDPOS-ITEM             = LV_ITEM.
        "küsürat düzenleme <-----
        LV_FARK = LV_FARK + LT_GLEDPOS-AMOUNT.
        APPEND LT_GLEDPOS.
        LT_GLEDTEXT-ITEM            = LV_ITEM.
        CONCATENATE GS_DATA-STUDENT12 LV_ADSOYAD  INTO
        LT_GLEDTEXT-ITEM_TEXT   SEPARATED BY SPACE.


*        IF gs_data-sc_objid EQ '50074579'.
*         lt_gledtext-alloc_nmbr      = '50074579'.
*        ELSE.
*        lt_gledtext-alloc_nmbr      = gs_data-student12.
        LT_GLEDTEXT-ALLOC_NMBR = GS_DATA-SC_OBJID .
*        ENDIF.
        APPEND LT_GLEDTEXT.

      ENDLOOP.

      IF LV_INDIRIM NE '0.00'.
        ADD 1 TO LV_ITEM.
        CLEAR :LT_GLEDPOS,LT_GLEDTEXT.
        LT_GLEDPOS-ITEM             = LV_ITEM.
        LT_GLEDPOS-LINE_ITEM        = 'X'.
        LT_GLEDPOS-COMP_CODE        = '1000'.
        LT_GLEDPOS-BUS_AREA         = LV_GSBER.
        IF LS_HESAP-HKONT IS NOT INITIAL.
          LT_GLEDPOS-G_L_ACCT         = LS_HESAP-HKONT.
        ENDIF.
        LT_GLEDPOS-FIKEY            = LV_FIKEY .
        LT_GLEDPOS-PROFIT_CTR       = LV_PRCTR.
        LT_GLEDPOS-COSTCENTER       = LV_PRCTR.
        IF GS_DATA-KDVSIZ EQ ''.
          LT_GLEDPOS-TAX_CODE         = 'A2'.
        ENDIF.
        LT_GLEDPOS-FIKEY            = LV_FIKEY.

        IF GS_DATA-KDVSIZ EQ ''.
          LT_GLEDPOS-AMOUNT           = ( LV_INDIRIM / ( 10 ) )  * 100 / 108 . " kdvsiz deðilse
          LV_EKLENECEK = LT_GLEDPOS-AMOUNT.
        ELSE.
          LT_GLEDPOS-AMOUNT           = ( LV_INDIRIM / ( 10 ) ) .
          LV_EKLENECEK = LT_GLEDPOS-AMOUNT.
          LV_DEGER2 = LV_EKLENECEK. "4 haneden 2 haneye yuvarlakama
          LV_EKLENECEK = LV_DEGER2. " yuvarladýktan sonra tekrar  eklenecek'e al.
        ENDIF.

        LV_DEGER = LT_GLEDPOS-AMOUNT .                        " 2 char lý deðiþkene atarak küsüratý düzenledik
        LT_GLEDPOS-AMOUNT = LV_DEGER.                         " geri attýk düzenlendi

        "küsürat düzenleme <-----
        LV_FARK = LV_FARK + LT_GLEDPOS-AMOUNT.                "
        APPEND LT_GLEDPOS.


        LT_GLEDTEXT-ITEM            = LV_ITEM.
*        lt_gledtext-item_text       = lv_adsoyad.
        CONCATENATE GS_DATA-STUDENT12 LV_ADSOYAD  INTO
        LT_GLEDTEXT-ITEM_TEXT   SEPARATED BY SPACE.
*        IF gs_data-sc_objid EQ '50074579'.
*         lt_gledtext-alloc_nmbr      = '50074579'.
*        ELSE.
*        lt_gledtext-alloc_nmbr      = gs_data-student12.
*        ENDIF.
        LT_GLEDTEXT-ALLOC_NMBR = GS_DATA-SC_OBJID .
        APPEND LT_GLEDTEXT.

        READ TABLE LT_GLEDPOS INDEX 1.
        IF SY-SUBRC EQ 0.
          LT_GLEDPOS-AMOUNT = LT_GLEDPOS-AMOUNT - LV_EKLENECEK.
          LV_FARK = LV_FARK  - LV_EKLENECEK.
          MODIFY LT_GLEDPOS INDEX 1.
        ENDIF.
      ENDIF.


*      IF gs_data-kdvsiz EQ ''.
*        CLEAR lv_add.
*        IF lv_fark IS NOT INITIAL.
*          READ TABLE lt_gledpos INDEX 1.
*          IF sy-subrc EQ 0.
*            CLEAR :lv_kdvsz,lv_rounded.
*            lv_kdvsz = lt_partpos-amount * 100 / 108.
*            lv_rounded  = lv_kdvsz.
*            IF lt_gledpos-amount < 0.
*              lv_add = lv_rounded -  ( lv_fark ) * -1.
*            ELSE.
*              lv_add = lv_rounded -  ( lv_fark ) .
*            ENDIF.
*            IF lv_add  LE '0.02'.
*              lt_gledpos-amount = lt_gledpos-amount - lv_add.
*              MODIFY lt_gledpos INDEX 1.
*            ENDIF.
*          ENDIF.
*        ENDIF.
*      ENDIF. XOBAS if else eklendi 23.12.2017

      CLEAR LV_ADD.
      IF LV_FARK IS NOT INITIAL.
        READ TABLE LT_GLEDPOS INDEX 1.
        IF SY-SUBRC EQ 0.
          CLEAR :LV_KDVSZ,LV_ROUNDED.
          IF GS_DATA-KDVSIZ EQ ''.
            LV_KDVSZ = LT_PARTPOS-AMOUNT * 100 / 108.
          ELSE.
            LV_KDVSZ = LT_PARTPOS-AMOUNT.
          ENDIF.
          LV_ROUNDED  = LV_KDVSZ.
          IF LT_GLEDPOS-AMOUNT < 0.
            LV_ADD = LV_ROUNDED -  ( LV_FARK ) * -1.
          ELSE.
            LV_ADD = LV_ROUNDED -  ( LV_FARK ) .
          ENDIF.
          IF LV_ADD  LE '0.02'.
            LT_GLEDPOS-AMOUNT = LT_GLEDPOS-AMOUNT - LV_ADD.
            MODIFY LT_GLEDPOS INDEX 1.
          ENDIF.
        ENDIF.
      ENDIF.

***********************************************************************************
      IF PRINT EQ 'X'.
        LT_GLED[] = LT_GLEDPOS[].
        LT_PART[] = LT_PARTPOS[].
        EXIT.

      ENDIF.
      CALL FUNCTION 'BAPI_CTRACDOCUMENT_CREATE'
        EXPORTING
          TESTRUN               = ''
          DOCUMENTHEADER        = LS_HEADER
          COMPLETEDOCUMENT      = 'X'
*         AGGREGATE_FOR_TAX_CALCULATION = 'X'
        IMPORTING
          DOCUMENTNUMBER        = LV_DOCNO
          RETURN                = LS_RETURN
        TABLES
          PARTNERPOSITIONS      = LT_PARTPOS
          GENLEDGERPOSITIONS    = LT_GLEDPOS
          GENLEDGERPOSITIONSEXT = LT_GLEDTEXT.

      IF LS_RETURN-TYPE CA 'EAX'.
        GS_DATA-COLOR = GC_COLOR_LIGHT_RED.
        LV_HATA = LS_RETURN-MESSAGE.
      ELSE.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            WAIT = 'X'.

        UPDATE ZFI_OGRFAT_LOG SET BELGE_NO = LV_DOCNO
                                    HESAP    = LV_HKONT
                                    KDVSIZ   = GS_DATA-KDVSIZ
                                    TUTAR    = LV_FTRTUTAR
                                    PARA_BIRIMI = 'TRY'
                                    TERS_KAYIT  = ''
                             WHERE  OGRENCI = GS_DATA-STUDENT12
                             AND    PROGRAM_ID = GS_DATA-SC_OBJID
                             AND    UCRET_DONEM = P_PERSL
                             AND    TAKSIT_DONEM = P_TDONEM.

        GS_DATA-COLOR = GC_COLOR_GREEN.                              " hesaplama ve iþlemler baþarýlý ise yeþil yaptýk satýrý
        GS_DATA-HATA = 'Belge oluþturuldu'.                          " bilgi mesajýný yazdýk
        GS_DATA-BELGE_NO = LV_DOCNO.                                 " oluþan döküman numarasýný aldýk ve yazdýrdýk
*          gs_data-sira_no = pv_sira.
      ENDIF.
*      ELSE.
*        lv_hata = 'Fatura Ýndirim Tablosunda hesap bulunamadý'.
*        gs_data-color = gc_color_light_red.
*      ENDIF.
    ELSE.
      LV_HATA = 'Kar Merkezi bulunamadý'.                            " kar merkezi hatasý olduðunda ekrana basýlacak
      GS_DATA-COLOR = GC_COLOR_LIGHT_RED.                            " satýr kýrmýzýya boyanacak

    ENDIF.
  ELSE.
    LV_HATA  = 'Fakülte Kodu Ýþ Alaný eþleþmesi bulunamadý'.        " iþ alaný hatasý olduðunda ekrana basýlacak
    GS_DATA-COLOR = GC_COLOR_LIGHT_RED.                             " satýr kýrmýzýya boyanacak
  ENDIF.

  IF GS_DATA-COLOR = GC_COLOR_LIGHT_RED.                            " satýr kýrmýzýya boyanacak
    GS_DATA-HATA   = LV_HATA.                                       " HATA MESAJI BASILCAK
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.

  SET PF-STATUS 'MENU2'.
  SET TITLEBAR 'TITLE2'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.

  DATA:  LV_SERISIRA(15)       TYPE C,
         V_SERI(3)             TYPE C,
         V_SIRA                TYPE NUMC10,
         LV_KDV                TYPE DMBTR,
         LV_ORAN               TYPE I,
         LV_SIRA               TYPE I,
         LV_TOPLAM             TYPE DMBTR,
         LV_FM_NAME            TYPE RS38L_FNAM,
         LV_OBJID              TYPE BAPISTUDENT_HEAD-OBJID,
         LS_RETURN             TYPE SSFCRESCL,
         STANDARDADDRESSNUMBER TYPE
BAPIBUS1006_ADDRESSES_INT-ADDRNUMBER,
         STANDARDADDRESSGUID   TYPE
                                 BAPIBUS1006_ADDRESSES_INT-ADDRGUID,
         LV_ADRTYPE            TYPE BAPIBUS1006_ADDRESSUSAGE-ADDRESSTYPE,
         LS_CMAC               TYPE          CMACBPST.

  DATA:  LS_OUTPUT_OPTIONS     TYPE SSFCOMPOP,
         LS_JOB_OUTPUT_OPTIONS TYPE SSFCRESOP.


  CASE SY-UCOMM.
    WHEN 'RW'.
      LEAVE TO SCREEN 0.
    WHEN 'MHSB'.
      IF P_IPTAL NE 'X'.
        CLEAR LV_SIRA.
        LOOP AT GT_DATA INTO GS_DATA WHERE SEL IS NOT INITIAL .
          IF GS_DATA-BELGE_NO IS INITIAL.
            CONDENSE P_SIRA.
            LV_SIRA = P_SIRA.
*          PERFORM muhasebelestir
**              USING lv_sira
*                    CHANGING gs_data.
            IF GS_DATA-BELGE_NO IS NOT INITIAL.
              ADD 1 TO P_SIRA.
            ENDIF.
          ELSE.
            GS_DATA-COLOR = GC_COLOR_LIGHT_RED.
            GS_DATA-HATA   = 'Muhasebeleþmiþ kayýtlarda iþlem yapýlamaz!'.
          ENDIF.
          MODIFY GT_DATA FROM GS_DATA.
        ENDLOOP.

        LEAVE TO SCREEN 0.

      ENDIF.
    WHEN 'PRNT'.

  ENDCASE.

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Form  CALL_SMARTFORMS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_FM_NAME  text
*      -->P_OUTPUT_OPTIONS  text
*      -->P_JOB_OUTPUT_OPTIONS  text
FORM CALL_SMARTFORMS USING FM_NAME                                     " SMARTFORM ÇAÐIRMA FORMU
                           OUTPUT TYPE  SSFCOMPOP
                           JOB_OUTPUT TYPE SSFCRESOP.
*-- CALL SMARTFORMS
*-
  DATA: GS_CONTROL_PARAM      TYPE SSFCTRLOP.
  DATA : W_CTRLOP    TYPE SSFCTRLOP  .
*  DATA : w_return TYPE ssfcrespd.

*  w_ctrlop-no_dialog = 'X'.
  W_CTRLOP-PREVIEW   = 'X'.
  W_CTRLOP-NO_OPEN   = 'X'.
  W_CTRLOP-NO_CLOSE  = 'X'.
  W_CTRLOP-GETOTF    = 'X'.

  CALL FUNCTION FM_NAME
    EXPORTING
      CONTROL_PARAMETERS = W_CTRLOP
      OUTPUT_OPTIONS     = OUTPUT
      USER_SETTINGS      = ' '
*     gv_kdv             = gv_kdv
*     gv_title           = gt_c-title
*     dekont_h           = gt_dekont
    IMPORTING
      JOB_OUTPUT_INFO    = LS_RETURN
      JOB_OUTPUT_OPTIONS = JOB_OUTPUT
    TABLES
      GT_HEAD            = IT_PRINT
      GT_ITEM            = IT_ITEMS
      GT_ADRES           = IT_ADRES
    EXCEPTIONS
      FORMATTING_ERROR   = 1
      INTERNAL_ERROR     = 2
      SEND_ERROR         = 3
      USER_CANCELED      = 4
      OTHERS             = 5.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Module  HELP_DATE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE HELP_DATE INPUT.
  DATA: LV_DATE TYPE WORKFLDS-GKDAY.
  CLEAR P_TARIH.
  CALL FUNCTION 'F4_DATE'
    EXPORTING
      DATE_FOR_FIRST_MONTH         = SY-DATUM
*     DISPLAY                      = ''
*     FACTORY_CALENDAR_ID          = ' '
*     GREGORIAN_CALENDAR_FLAG      = ' '
*     HOLIDAY_CALENDAR_ID          = ' '
*     PROGNAME_FOR_FIRST_MONTH     = ' '
*     DATE_POSITION                = ' '
    IMPORTING
      SELECT_DATE                  = LV_DATE
    EXCEPTIONS
      CALENDAR_BUFFER_NOT_LOADABLE = 1
      DATE_AFTER_RANGE             = 2
      DATE_BEFORE_RANGE            = 3
      DATE_INVALID                 = 4
      FACTORY_CALENDAR_NOT_FOUND   = 5
      HOLIDAY_CALENDAR_NOT_FOUND   = 6
      PARAMETER_CONFLICT           = 7
      OTHERS                       = 8.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.
  P_TARIH = LV_DATE.
ENDMODULE.

*&---------------------------------------------------------------------*
*&      Form  GET_FIKEY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_P_FIKEY  text
*----------------------------------------------------------------------*
FORM GET_FIKEY  CHANGING P_FIKEY.
  DATA: LV_FIKEY TYPE FIKEY_KK.

*  Bugün açýlmýþ key var mý?
  SELECT SINGLE FIKEY FROM DFKKSUMC INTO LV_FIKEY
    WHERE CPUDT = SY-DATUM
      AND ERNAM = SY-UNAME
      AND XCLOS NE 'X'
       AND FIKEY GE '1000000000' AND
           FIKEY LE '1999999999'.

  IF SY-SUBRC = 0.
*    Bugün açýlmýþ key varsa al
    P_FIKEY = LV_FIKEY.
  ELSE.
*    Yoksa yeni numara al ve key aç.
    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        NR_RANGE_NR = '01'
        OBJECT      = 'ZCA_FIKEY'
      IMPORTING
        NUMBER      = LV_FIKEY.
    CALL FUNCTION 'FKK_FIKEY_OPEN'
      EXPORTING
        I_FIKEY = LV_FIKEY.

    P_FIKEY = LV_FIKEY .
  ENDIF.
ENDFORM.
*&      Form  GET_ADRESSES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_OBJID  text
*      <--P_STANDARDADDRESSNUMBER  text
*      <--P_STANDARDADDRESSGUID  text
*----------------------------------------------------------------------*
FORM GET_ADRESSES  USING    P_OBJID P_ADRTYPE
                   CHANGING P_STANDARDADDRESSNUMBER
                            P_STANDARDADDRESSGUID.

  DATA: LT_RETURN   TYPE TABLE OF BAPIRET2.

  CALL FUNCTION 'BAPI_STUDENT_ADDRESSES_GET'
    EXPORTING
      PLANVERSION           = '01'
      OBJECTID              = P_OBJID
*     OPERATION             =
      ADDRESSTYPE           = P_ADRTYPE
      VALID_DATE            = SY-DATLO
    IMPORTING
      STANDARDADDRESSNUMBER = P_STANDARDADDRESSNUMBER
      STANDARDADDRESSGUID   = P_STANDARDADDRESSGUID
*     STANDARDADDRESSUSEINSTEAD       =
    TABLES
*     ADDRESSES             =
      RETURN                = LT_RETURN
*     ADDRESSES_ALL         =
    .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_NUMBERS
*&---------------------------------------------------------------------*
*       NUMARA ALMA FORMU
*----------------------------------------------------------------------*
FORM GET_NUMBERS.
  DATA: LV_ANS,
        LV_VALUE TYPE SPOP-VARVALUE1,
        LS_LOG   TYPE ZFI_OGRFAT_LOG.
  LOOP AT GT_DATA INTO GS_DATA WHERE  SEL = 'X' AND BELGE_NO IS NOT INITIAL " ÝSTENEN VERÝLERE GÖRE LOOP A SOKTUK
                               AND    FTRSIZ NE 'X'.
    EXIT.
  ENDLOOP.
  IF SY-SUBRC IS INITIAL.
    MESSAGE 'Muhasebeleþtirilmiþ kalemler üzerinde iþlem yapýlamaz'          " HATA MESAJINI GÖSTER
     TYPE 'S' DISPLAY LIKE 'E'.
  ELSE.
    CLEAR GS_DATA.
    READ TABLE GT_DATA INTO GS_DATA WITH KEY SEL = 'X'
                                       .
*                                            prnt = 'X'.

    IF SY-SUBRC IS INITIAL .

      CALL FUNCTION 'POPUP_TO_GET_ONE_VALUE'                                " AÇILIR POPUP TA SIRA NUMARASI ALIYORUZ
        EXPORTING
          TEXTLINE1      = 'Sýradaki Fatura'
          TEXTLINE2      = 'numarasýný giriniz'
          TEXTLINE3      = '(Zorunlu alan)'
          TITEL          = 'SAP Fatura No'
          VALUELENGTH    = '10'
        IMPORTING
          ANSWER         = LV_ANS
          VALUE1         = LV_VALUE
        EXCEPTIONS
          TITEL_TOO_LONG = 1
          OTHERS         = 2.
      IF SY-SUBRC <> 0.
      ENDIF.

      IF LV_ANS EQ 'J' AND LV_VALUE IS NOT INITIAL.
        LOOP AT GT_DATA INTO GS_DATA WHERE SEL IS NOT INITIAL AND FTRSIZ NE 'X' .
          GS_DATA-SIRA_NO = LV_VALUE.
          LV_VALUE = LV_VALUE + 1.
          CONDENSE LV_VALUE.
          IF GS_DATA-YAZDIRILDI NE 'X'.
            CLEAR LS_LOG.
            LS_LOG-YAZDIRILDI   = ''.
            LS_LOG-BELGE_NO     = GS_DATA-BELGE_NO.
            LS_LOG-OGRENCI      = GS_DATA-STUDENT12.
            LS_LOG-PROGRAM_ID   = GS_DATA-SC_OBJID.
            LS_LOG-UCRET_DONEM  = P_PERSL.
            LS_LOG-TAKSIT_DONEM = P_TDONEM.
            LS_LOG-SIRA_NO      = GS_DATA-SIRA_NO.
            LS_LOG-KULLANICI    = SY-UNAME.
            LS_LOG-TARIH        = SY-DATUM.
            LS_LOG-SAAT         = SY-UZEIT.
            LS_LOG-HESAP        = GS_DATA-HESAP.
            LS_LOG-KDVSIZ       = GS_DATA-KDVSIZ.
            MODIFY ZFI_OGRFAT_LOG FROM LS_LOG.
          ENDIF.
          MODIFY GT_DATA FROM GS_DATA TRANSPORTING SIRA_NO.
        ENDLOOP.
*

      ELSE.
        MESSAGE 'Sap fatura no deðeri girmediniz!' TYPE 'S' DISPLAY LIKE 'E'.
      ENDIF.

    ELSE.
      MESSAGE 'En az bir satýrý seçiniz!' TYPE 'S' DISPLAY LIKE 'E'.
    ENDIF.
  ENDIF.

ENDFORM.

FORM ALV_DATA_CHANGED  USING RR_DATA_CHANGED TYPE REF TO
                                          CL_ALV_CHANGED_DATA_PROTOCOL .

  DATA : LS_HEAD      LIKE LINE OF GT_DATA,
         LV_CHECK,
         LS_STABLE    TYPE LVC_S_STBL,
         LV_REFRESH,
         LS_NONFTR    TYPE ZCAT_NONFTR_OGR,
         LS_MOD_CELLS TYPE LVC_S_MODI,
         LS_LOG       TYPE ZFI_OGRFAT_LOG.

*  DATA: lv_mikt_o LIKE ls_ozet-miktr. "eski miktar
  IF GO_GRID IS NOT INITIAL.
    LS_STABLE-ROW = 'X'.
    CALL METHOD GO_GRID->REFRESH_TABLE_DISPLAY
      EXPORTING
        IS_STABLE = LS_STABLE.
  ENDIF.
  IF GO_GRID IS INITIAL .
    CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
      IMPORTING
        E_GRID = GO_GRID.
  ENDIF.

*  ELSE.
  LOOP AT RR_DATA_CHANGED->MT_GOOD_CELLS INTO LS_MOD_CELLS .
    CLEAR LS_NONFTR.
    READ TABLE GT_DATA INTO LS_HEAD INDEX LS_MOD_CELLS-ROW_ID.
    IF SY-SUBRC = 0.

      CASE LS_MOD_CELLS-FIELDNAME .
        WHEN  'FTRSIZ'.
          LS_HEAD-FTRSIZ = LS_MOD_CELLS-VALUE.
          MOVE-CORRESPONDING LS_HEAD TO LS_NONFTR.
          LS_NONFTR-PERSL = P_PERSL.
          LS_NONFTR-TDONEM = P_TDONEM.
          LS_NONFTR-FATURALANMAYACAK = LS_MOD_CELLS-VALUE.
          MODIFY ZCAT_NONFTR_OGR FROM LS_NONFTR.
        WHEN 'SIRA_NO'.

          IF GS_DATA-BELGE_NO EQ SPACE. "muhasebe iþlemi yoksa güncelle
*          gs_data-yazdirildi = 'X'.
            CLEAR LS_LOG.
            LS_LOG-BELGE_NO = GS_DATA-BELGE_NO.
            LS_LOG-OGRENCI = GS_DATA-STUDENT12.
            LS_LOG-PROGRAM_ID = GS_DATA-SC_OBJID.
            LS_LOG-UCRET_DONEM = P_PERSL.
            LS_LOG-TAKSIT_DONEM = P_TDONEM.
            LS_LOG-SIRA_NO   = GS_DATA-SIRA_NO.
            LS_LOG-KULLANICI = SY-UNAME.
            LS_LOG-TARIH = SY-DATUM.
            LS_LOG-SAAT = SY-UZEIT.
            LS_LOG-YAZDIRILDI = GS_DATA-YAZDIRILDI.
            LS_LOG-HESAP = GS_DATA-HESAP.
            LS_LOG-KDVSIZ = GS_DATA-KDVSIZ.
            LS_LOG-HESAP = GS_DATA-HESAP.
            LS_LOG-PARA_BIRIMI = 'TRY'.
            MODIFY ZFI_OGRFAT_LOG FROM LS_LOG.
          ENDIF.

      ENDCASE .

      MODIFY GT_DATA FROM LS_HEAD INDEX LS_MOD_CELLS-ROW_ID.
    ENDIF. "READ TABLE sy-subrc = 0.
  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_CONVERSION_RESULT
*&---------------------------------------------------------------------*
FORM GET_CONVERSION_RESULT  USING    P_TAHTUTAR P_BIRIM                 " PARAMETRELER ÝLE FORMU ÇAÐIR
                            CHANGING P_TUTAR.

  DATA: LV_AMOUNT TYPE P DECIMALS 2.                                    " 2 DECIMALLÝ LOCAL DEÐÝÞKEN TANIMLADIK

  CALL FUNCTION 'CONVERT_FOREIGN_TO_FOREIGN_CUR'                        " KUR DÖNÜÞÜMÜ FONKSÝYONU
    EXPORTING
      CLIENT           = SY-MANDT
      DATE             = SY-DATUM
      TYPE_OF_RATE     = 'F'
      FROM_AMOUNT      = P_TAHTUTAR
      FROM_CURRENCY    = P_BIRIM
      TO_CURRENCY      = 'TRY'
      LOCAL_CURRENCY   = 'TRY'
    IMPORTING
      TO_AMOUNT        = LV_AMOUNT
    EXCEPTIONS
      NO_RATE_FOUND    = 1
      OVERFLOW         = 2
      NO_FACTORS_FOUND = 3
      NO_SPREAD_FOUND  = 4
      DERIVED_2_TIMES  = 5
      OTHERS           = 6.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.
*                ls_item-thslttutar = ls_item-thslttutar - lv_amount.
  P_TUTAR =  LV_AMOUNT.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_ALV
*&---------------------------------------------------------------------*
FORM GET_ALV .                    " FORMUN ADI
  PERFORM CREATE_LAYOUT.          " CREATE LAYOUT FORMUNU ÇAÐIR
  PERFORM SHOW_ALV.               " SHOW ALV FORMUNU ÇAÐIR
ENDFORM.
