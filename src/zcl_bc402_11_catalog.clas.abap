class ZCL_BC402_11_CATALOG definition
  public
  final
  create public
  shared memory enabled .

public section.

  data GT_CATALOG type BC402_T_SDYNCONN .

  methods FILL_CATALOG
    importing
      !IT_CATALOG type BC402_T_SDYNCONN .
  methods GET_FLIGHTS
    importing
      !IV_CITYFR type S_FROM_CIT
      !IV_CITYTO type S_TO_CITY
      !IV_EARLIEST type S_DATE
      !IV_LATEST type S_DATE
    exporting
      !ET_FLIGHTS type BC402_T_SDYNCONN .
protected section.
private section.
ENDCLASS.



CLASS ZCL_BC402_11_CATALOG IMPLEMENTATION.


  method FILL_CATALOG.
  gt_catalog = it_catalog.
  endmethod.


  method GET_FLIGHTS.
    DATA: wa LIKE LINE OF et_flights.

    LOOP AT gt_catalog INTO wa
                         WHERE cityfrom = iv_cityfr AND cityto = iv_cityto
                         AND fldate >= iv_earliest AND fldate <= iv_latest.

      APPEND wa TO et_flights.
    ENDLOOP.
  endmethod.
ENDCLASS.
