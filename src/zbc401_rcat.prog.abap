*&---------------------------------------------------------------------*
*& Report ZBC401_RCAT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBC401_RCAT.
DATA:
  go_handle    TYPE REF TO   zcl_11_area,
  gt_flights   TYPE          bc402_t_sdynconn,

  gv_startdate TYPE sydatum,
  gv_enddate   TYPE sydatum,
  alv          TYPE REF TO cl_salv_table.


*----------------------------------------------------------------------*
PARAMETERS:
  pa_from TYPE spfli-cityfrom,
  pa_to   TYPE spfli-cityto.

SELECT-OPTIONS:
    so_date      FOR sy-datum NO-EXTENSION.

*----------------------------------------------------------------------*
AT SELECTION-SCREEN.

  READ TABLE so_date INDEX 1.
  IF so_date IS INITIAL.
    so_date-low = sy-datum.
    so_date-high = sy-datum + 365.
  ENDIF.
  gv_startdate = sy-datum.
  gv_enddate   = sy-datum + 365.

  IF so_date-low > sy-datum.
    gv_startdate = sy-datum.
  ENDIF.
  IF so_date-high < gv_enddate.
    gv_enddate = so_date-high.
  ENDIF.

*----------------------------------------------------------------------*
START-OF-SELECTION.

go_handle = zcl_11_area=>attach_for_read( ).

  go_handle->root->mo_catalog->get_flights(
    EXPORTING
      iv_cityfr = pa_from
      iv_cityto   = pa_to
      iv_earliest  = gv_startdate
      iv_latest    = gv_enddate
    IMPORTING
      et_flights   = gt_flights
         ).
  go_handle->detach( ).

  cl_salv_table=>factory( IMPORTING r_salv_table = alv
                          CHANGING t_table = gt_flights ).

  alv->display( ).
