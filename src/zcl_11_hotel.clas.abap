class ZCL_11_HOTEL definition
  public
  final
  create public .

public section.

  methods DISPLAY_ATTRIBUTES .
  class-methods DISPLAY_N_O_HOTELS .
protected section.
private section.

  constants C_POS_1 type I value 30 ##NO_TEXT.
  data MV_NAME type STRING .
  data MV_BEDS type I .
  class-data GV_N_O_HOTEL type I .

  methods CONSTRUCTOR
    importing
      !IV_NAME type STRING
      !IV_BEDS type I .
ENDCLASS.



CLASS ZCL_11_HOTEL IMPLEMENTATION.


  method CONSTRUCTOR.
    mv_name = iv_name.
 mv_beds = iv_beds.
 ADD 1 TO gv_n_o_hotels.
ENDMETHOD.


  method DISPLAY_ATTRIBUTES.
    WRITE:/ 'WELOCOME TO THE HOSTEL-', AT C_POS_I MV_NAME,
                                     /,AT C_POS_I MV_BEDS.
  endmethod.


  method DISPLAY_N_O_HOTELS._
    WRITE:/ 'THE NUMBER OF HOTELS -',gv_n_o_hotels.
  endmethod.
ENDCLASS.
