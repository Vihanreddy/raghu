*&---------------------------------------------------------------------*
*& Report  BC402_DYS_DYN_CALL
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zbc401_11_dyn_call MESSAGE-ID bc402.

TYPE-POOLS:
   abap.

DATA: gt_cust    TYPE ty_customers,
      gt_conn    TYPE ty_connections.

DATA: gv_methname TYPE string,
      gt_parmbind TYPE abap_parmbind_tab,
      gs_parmbind TYPE abap_parmbind.
DATA:
      gv_tabname TYPE string.
FIELD-SYMBOLS:
     <fs_table> TYPE ANY TABLE.



SELECTION-SCREEN COMMENT 1(80) text-sel.
PARAMETERS:
   pa_xconn  TYPE xfeld RADIOBUTTON GROUP tab DEFAULT 'X',
   pa_xcust  TYPE xfeld RADIOBUTTON GROUP tab .
PARAMETERS:
   pa_nol   TYPE i DEFAULT '100'.

START-OF-SELECTION.

* specific part
*----------------------------------------------------------------------*
  CASE 'X'.
    WHEN pa_xconn.

      SELECT * FROM spfli INTO TABLE gt_conn
               UP TO pa_nol ROWS.

      gv_methname = 'WRITE_CONNECTIONS'.

      gs_parmbind-name = 'IT_CONN'.
      GET REFERENCE OF gt_conn INTO gs_parmbind-value.
      INSERT gs_parmbind INTO TABLE gt_parmbind.

    WHEN pa_xcust.

      SELECT * FROM scustom INTO TABLE gt_cust
               UP TO pa_nol ROWS.

      gv_methname = 'WRITE_CUSTOMERS'.

      gs_parmbind-name = 'IT_CUST'.
      GET REFERENCE OF gt_cust INTO gs_parmbind-value.
      INSERT gs_parmbind INTO TABLE gt_parmbind.

  ENDCASE.

* dynamic part
*----------------------------------------------------------------------*

TRY.
      CALL METHOD cl_bc402_utilities=>(gv_methname)
        PARAMETER-TABLE
          gt_parmbind.

    CATCH cx_sy_dyn_call_error.
      MESSAGE e060.
  ENDTRY.
