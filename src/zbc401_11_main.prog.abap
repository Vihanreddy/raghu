*&---------------------------------------------------------------------*
*& Report ZBC401_11_MAIN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc401_11_main.
CLASS lcl_vehicle DEFINITION.
  PUBLIC SECTION.
    METHODS: set_make IMPORTING i_make TYPE string,
      set_model IMPORTING i_model TYPE string,
      display_attributes.
*    CLASS-METHODS: get_no_of_vehicles EXPORTING e_no_of_vehicles TYPE i.
    CLASS-METHODS: get_no_of_vehicles RETURNING VALUE(r_no_of_vehicles) TYPE i.
    DATA: make  TYPE string READ-ONLY, model TYPE string READ-ONLY.
  PRIVATE SECTION.
    CLASS-DATA: no_of_vehicles TYPE i.
ENDCLASS.

CLASS lcl_vehicle IMPLEMENTATION.
  METHOD set_make.
    make = i_make.
    ADD 1 TO no_of_vehicles.
  ENDMETHOD.

  METHOD set_model.
    model = i_model.
  ENDMETHOD.

  METHOD display_attributes.
    WRITE:/ 'This is a vehicle - ', make, model.
  ENDMETHOD.

  METHOD get_no_of_vehicles.
    r_no_of_vehicles = no_of_vehicles.
  ENDMETHOD.
ENDCLASS.

DATA: ref1    TYPE REF TO lcl_vehicle,
      ref_tab TYPE TABLE OF REF TO lcl_vehicle.
*      v_count TYPE i.

START-OF-SELECTION.

  CREATE OBJECT ref1.
*CALL METHOD ref1->SET_MAKE
*  EXPORTING i_make = 'Test'.

  ref1->set_make( 'BMW' ).
  ref1->set_model( 'i8').
  APPEND ref1 TO ref_tab.

  CREATE OBJECT ref1.
  ref1->set_make( EXPORTING i_make = 'Mercedes' ).
  ref1->set_model( 'SLS').
  APPEND ref1 TO ref_tab.

  CREATE OBJECT ref1.
  ref1->set_make( 'Ferrari' ).
  ref1->set_model( 'F430').
  APPEND ref1 TO ref_tab.

  LOOP AT ref_tab INTO ref1.
    ref1->display_attributes( ).
  ENDLOOP.

*  lcl_vehicle=>get_no_of_vehicles( IMPORTING e_no_of_vehicles = v_count ).
*  v_count = lcl_vehicle=>get_no_of_vehicles( ).
  WRITE:/ 'Total number of vehicles =', lcl_vehicle=>get_no_of_vehicles( ).
