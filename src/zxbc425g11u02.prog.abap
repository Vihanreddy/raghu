*&---------------------------------------------------------------------*
*&  Include           ZXBC425G11U02
*&---------------------------------------------------------------------*
SUBMIT SAPBC425_BOOKINGS_11
 WITH so_car = flight-carrid
 WITH so_con = flight-connid
 WITH so_fld = flight-fldate
 AND RETURN.
