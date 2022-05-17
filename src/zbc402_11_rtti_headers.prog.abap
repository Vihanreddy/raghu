*&---------------------------------------------------------------------*
*& Report  BC402_DYS_RTTI_HEADERS
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zbc402_11_rtti_headers MESSAGE-ID bc402.


DATA:
  gt_cust    TYPE ty_customers,
  gt_conn    TYPE ty_connections.

DATA:
  gv_tabname  TYPE string.

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

      gv_tabname = 'SPFLI'.

      ASSIGN gt_conn TO <fs_table>.

    WHEN pa_xcust.

      gv_tabname = 'SCUSTOM'.

      ASSIGN gt_cust TO <fs_table>.

  ENDCASE.

* dynamic part
*----------------------------------------------------------------------*

  TRY.
      SELECT * FROM (gv_tabname) INTO TABLE <fs_table>
               UP TO pa_nol ROWS.
    CATCH cx_sy_dynamic_osql_error.
      MESSAGE e061.
  ENDTRY.

      CALL METHOD cl_bc402_dys_rtti_headers=>write_headers
        EXPORTING
          iv_tabname     = gv_tabname
        EXCEPTIONS
          type_not_found = 1
          no_structure   = 2
          no_ddic_type   = 3.

      CASE sy-subrc.
        WHEN 1.
          MESSAGE e050 WITH gv_tabname.
        WHEN 2.
          MESSAGE e051 WITH gv_tabname.
        WHEN 3.
          MESSAGE e052 WITH gv_tabname.
      ENDCASE.

      cl_bc402_dys_gen_types=>write_any_table( <fs_table> ).
