*&---------------------------------------------------------------------*
*& Report ZBC402_11_DNY_SQL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBC402_11_DNY_SQL  MESSAGE-ID bc402.

TYPE-POOLS:
   abap.

DATA:
  gt_cust TYPE ty_customers,
  gt_conn TYPE ty_connections.


DATA:
  gv_tabname  TYPE string.

FIELD-SYMBOLS:
  <fs_table> TYPE ANY TABLE.

SELECTION-SCREEN COMMENT 1(80) TEXT-sel.
PARAMETERS:
  pa_xconn TYPE xfeld RADIOBUTTON GROUP tab DEFAULT 'X',
  pa_xcust TYPE xfeld RADIOBUTTON GROUP tab.
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
  zcl_00_headers=>write_headers( gv_tabname ).
  zcl_00_types=>write_any_table( it_table = <fs_table> ).
