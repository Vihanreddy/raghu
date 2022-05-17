*&---------------------------------------------------------------------*
*&  Include           ZBC401_11_VECHILES
*&---------------------------------------------------------------------*
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
