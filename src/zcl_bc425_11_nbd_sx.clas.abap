class ZCL_BC425_11_NBD_SX definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_BC425_11_SX_BADI .
protected section.
private section.
ENDCLASS.



CLASS ZCL_BC425_11_NBD_SX IMPLEMENTATION.


  method IF_EX_BC425_11_SX_BADI~PUT_DATA.
    CALL FUNCTION 'Z_BC425_PUT_DATA_11'
 EXPORTING
 IM_SCARR = im_wa_scarr.
  endmethod.
ENDCLASS.
