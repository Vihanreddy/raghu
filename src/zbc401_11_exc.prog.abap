*&---------------------------------------------------------------------*
*& Report  SAPBC401_GCL_S2                                             *
*&---------------------------------------------------------------------*
*&       Replace local interface with global inteface                  *
*&       Fully intergrate global class for hotels                     *
*&---------------------------------------------------------------------*
REPORT  ZBC41_11_EXC.

TYPE-POOLS icon.

INCLUDE ZBC401_11_EXC_AGENCY.
*INCLUDE bc401_gcl_s2_agency.
INCLUDE ZBC401_11_EXC_CARRIER.
*INCLUDE bc401_gcl_s2_carrier.
INCLUDE ZBC401_11_EXC_RENTAL.
*INCLUDE bc401_gcl_s2_rental.

DATA:
  go_hotel     TYPE REF TO cl_hotel2,
  go_vehicle   TYPE REF TO lcl_vehicle,
  go_truck     TYPE REF TO lcl_truck,
  go_bus       TYPE REF TO lcl_bus,
  go_rental    TYPE REF TO lcl_rental,
  go_passenger TYPE REF TO lcl_passenger_plane,
  go_cargo     TYPE REF TO lcl_cargo_plane,
  go_carrier   TYPE REF TO lcl_carrier,
  go_agency    TYPE REF TO lcl_travel_agency,
  go_exc       TYPE REF TO zcx_00_invalid_planetype.


START-OF-SELECTION.
*******************

******* create travel_agency **********************************
  CREATE OBJECT go_agency
    EXPORTING
      iv_name = 'Travel&Smile Travel'.

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

  TRY.
***** Passenger Plane *****************************************
      CREATE OBJECT go_passenger
        EXPORTING
          iv_name      = 'LH BERLIN'
          iv_planetype = '747-400'
          iv_seats     = 345.
    CATCH zcx_00_invalid_planetype INTO go_exc.
      WRITE:/ go_exc->get_text( ) color col_negative.
  ENDTRY.

***** cargo Plane *********************************************
  TRY.
      CREATE OBJECT go_cargo
        EXPORTING
          iv_name      = 'US Hercules'
          iv_planetype = '747-20F'
          iv_cargo     = 533.

    CATCH zcx_00_invalid_planetype INTO go_exc.
      WRITE:/ go_exc->get_text( ) color COL_NEGATIVE.
  ENDTRY.

******* show attributes of all partners of travel_agency ******
  go_agency->display_attributes( ).
