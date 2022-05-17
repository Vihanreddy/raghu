class ZCL_BC425_11_NBD_MX definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_BC425_11_MX_BADI .
protected section.
private section.
ENDCLASS.



CLASS ZCL_BC425_11_NBD_MX IMPLEMENTATION.


  method IF_EX_BC425_11_MX_BADI~SHOW_ADDITIONAL_CUSTOMER_DATA.
    SUBMIT BC425_CUSTOMER_BOOKINGS
WITH customid = im_customid
AND RETURN.
  endmethod.
ENDCLASS.
