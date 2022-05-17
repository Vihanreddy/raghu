*&---------------------------------------------------------------------*
*& Report  SAPBC401_SPC_S2                                             *
*&---------------------------------------------------------------------*
*&       lcl_airplane_factory as a factory class for airplanes
*&       lcl_passenger_plane and lcl_cargo_plane with CREATE PRIVATE                        *
*&       grant friendship to lcl_airplane_factory
*&---------------------------------------------------------------------*
REPORT  zbc401_11_spc1.

TYPE-POOLS icon.

INCLUDE ZBC401_11_SPL1_AGENCY.
*INCLUDE bc401_spc_s2_agency.
INCLUDE ZBC401_11_SPL1_CARRIER.
*INCLUDE bc401_spc_s2_carrier.
INCLUDE ZBC401_11_SPL1_RENTAL.
*INCLUDE bc401_spc_s2_rental.

DATA:
  go_agency    TYPE REF TO lcl_travel_agency,
  go_hotel     TYPE REF TO cl_hotel2,
  go_vehicle   TYPE REF TO lcl_vehicle,
  go_truck     TYPE REF TO lcl_truck,
  go_bus       TYPE REF TO lcl_bus,
  go_rental    TYPE REF TO lcl_rental,
*  go_passenger TYPE REF TO lcl_passenger_plane,
*  go_cargo     TYPE REF TO lcl_cargo_plane,
  go_carrier   TYPE REF TO lcl_carrier.


START-OF-SELECTION.
*******************

******* create travel_agency **********************************
*  CREATE OBJECT go_agency
*    EXPORTING
*      iv_name = 'Travel&Smile Travel'.
  go_agency = lcl_travel_agency=>get_instance( ).

******* create hotel ******************************************
  CREATE OBJECT go_hotel
    EXPORTING
      iv_name = 'Sleep Well Hotel'
      iv_beds = 345.

******* create rental *****************************************
  CREATE OBJECT go_rental
    EXPORTING
      iv_name = 'Happy Car Rental'.

******* create truck ******************************************
  CREATE OBJECT go_truck
    EXPORTING
      iv_make  = 'MAN'
      iv_cargo = 45.

******* create truck ******************************************
  CREATE OBJECT go_bus
    EXPORTING
      iv_make       = 'Mercedes'
      iv_passengers = 80.

******* create truck ******************************************
  CREATE OBJECT go_truck
    EXPORTING
      iv_make  = 'VOLVO'
      iv_cargo = 48.

***** Create Carrier ******************************************
  CREATE OBJECT go_carrier
    EXPORTING
      iv_name = 'Smile&Fly-Travel'.

***** Passenger Plane *****************************************
  lcl_airplane_factory=>create_airplane(
    EXPORTING
      iv_name         = 'LH BERLIN'
      iv_planetype    = '747-400'
      iv_seats        = 345
    EXCEPTIONS
      wrong_planetype         = 1
      wrong_param_combination = 2 ).
  IF sy-subrc = 1.
    WRITE:
     / icon_failure AS ICON,
       'Wrong plane type'.
  ENDIF.

***** cargo Plane *********************************************
  lcl_airplane_factory=>create_airplane(
     EXPORTING
       iv_name         = 'US Hercules'
       iv_planetype    = '747-200F'
       iv_cargo        = 533
     EXCEPTIONS
       wrong_planetype         = 1
       wrong_param_combination = 2 ).

  IF sy-subrc = 1.
    WRITE:
     / icon_failure AS ICON,
       'Wrong plane type'.
  ENDIF.

******* show attributes of all partners of travel_agency ******
  go_agency->display_attributes( ).
