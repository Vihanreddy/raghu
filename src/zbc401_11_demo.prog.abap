*&---------------------------------------------------------------------*
*& Report ZBC401_11_DEMO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBC401_11_DEMO.
CLASS lcl_vehicle DEFINITION ABSTRACT.
  PUBLIC SECTION.
    METHODS: constructor IMPORTING i_make  TYPE string
                                   i_model TYPE string,
      display_attributes ABSTRACT.
    CLASS-METHODS: get_no_of_vehicles RETURNING VALUE(r_no_of_vehicles) TYPE i.
    DATA: make  TYPE string READ-ONLY, model TYPE string READ-ONLY.
  PRIVATE SECTION.
    CLASS-DATA: no_of_vehicles TYPE i.
ENDCLASS.

CLASS lcl_vehicle IMPLEMENTATION.
  METHOD constructor.
    make = i_make.
    model = i_model.
    ADD 1 TO no_of_vehicles.
  ENDMETHOD.

  METHOD get_no_of_vehicles.
    r_no_of_vehicles = no_of_vehicles.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_car DEFINITION INHERITING FROM lcl_vehicle.
  PUBLIC SECTION.
    METHODS: constructor IMPORTING i_make  TYPE string
                                   i_model TYPE string
                                   i_color TYPE string,
      display_attributes REDEFINITION.
  PRIVATE SECTION.
    DATA: color TYPE string.
ENDCLASS.

CLASS lcl_car IMPLEMENTATION.
  METHOD constructor.
    super->constructor( EXPORTING i_make = i_make
                                  i_model = i_model ).
    color = i_color.
  ENDMETHOD.
  METHOD display_attributes.
*    super->display_attributes( ).
    WRITE:/ 'This is a car - ', make, model, color.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_truck DEFINITION INHERITING FROM lcl_vehicle.
  PUBLIC SECTION.
    METHODS: constructor IMPORTING i_make  TYPE string
                                   i_model TYPE string
                                   i_load  TYPE i,
      display_attributes REDEFINITION,
      get_load RETURNING VALUE(r_load) TYPE i.
  PRIVATE SECTION.
    DATA: load TYPE i.
ENDCLASS.

CLASS lcl_truck IMPLEMENTATION.
  METHOD constructor.
    super->constructor( EXPORTING i_make = i_make
                                  i_model = i_model ).
    load = i_load.
  ENDMETHOD.
  METHOD display_attributes.
*    super->display_attributes( ).
    WRITE:/ 'This is a truck - ', make, model, load.
  ENDMETHOD.
  METHOD get_load.
    r_load = load.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_bus DEFINITION INHERITING FROM lcl_vehicle.
  PUBLIC SECTION.
    METHODS: constructor IMPORTING i_make  TYPE string
                                   i_model TYPE string
                                   i_seats TYPE i,
      display_attributes REDEFINITION.
  PRIVATE SECTION.
    DATA: seats TYPE i.
ENDCLASS.

CLASS lcl_bus IMPLEMENTATION.
  METHOD constructor.
    super->constructor( EXPORTING i_make = i_make
                                  i_model = i_model ).
    seats = i_seats.
  ENDMETHOD.
  METHOD display_attributes.
*    super->display_attributes( ).
    WRITE:/ 'This is a bus - ', make, model, seats.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_rental DEFINITION.
  PUBLIC SECTION.
    METHODS: constructor IMPORTING i_name TYPE string,
      display_attributes,
      add_vehicle IMPORTING i_vehicle TYPE REF TO lcl_vehicle,
      get_load RETURNING VALUE(r_load) TYPE i.

  PRIVATE SECTION.
    DATA: name  TYPE string,
          fleet TYPE TABLE OF REF TO lcl_vehicle.
ENDCLASS.

CLASS lcl_rental IMPLEMENTATION.
  METHOD constructor.
    name = i_name.
  ENDMETHOD.

  METHOD add_vehicle.
    APPEND i_vehicle TO fleet.
  ENDMETHOD.

  METHOD display_attributes.
    DATA: r_veh TYPE REF TO lcl_vehicle.
    WRITE:/ name, icon_car AS ICON , ' Car Rental Agency' COLOR COL_POSITIVE.
    LOOP AT fleet INTO r_veh.
      r_veh->display_attributes( ). "Polymorphic
    ENDLOOP.
  ENDMETHOD.

  METHOD get_load.
    DATA: r_veh   TYPE REF TO lcl_vehicle,
          r_truck TYPE REF TO lcl_truck.
    LOOP AT fleet INTO r_veh.
      TRY.
          r_truck ?= r_veh. "Possible?
          r_load = r_load + r_truck->get_load( ). "Polymorphic
        CATCH cx_sy_move_cast_error.
      ENDTRY.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.

DATA: r_car    TYPE REF TO lcl_car,
      r_truck  TYPE REF TO lcl_truck,
      r_bus    TYPE REF TO lcl_bus,
      r_rental TYPE REF TO lcl_rental.

START-OF-SELECTION.
  CREATE OBJECT r_rental EXPORTING i_name = 'Hertz'.


  r_rental->add_vehicle( NEW lcl_car( i_make = 'BMW' i_model ='i8' i_color = 'Blue' ) ).

  CREATE OBJECT r_car EXPORTING i_make = 'Mercedes' i_model ='SLS' i_color = 'Red'.
  r_rental->add_vehicle( r_car ).
  CREATE OBJECT r_car EXPORTING i_make = 'Lamborghini' i_model ='Aventador' i_color = 'Yellow'.
  r_rental->add_vehicle( r_car ).

  CREATE OBJECT r_truck EXPORTING i_make = 'Tata' i_model ='T1980' i_load = 1000000.
  r_rental->add_vehicle( r_truck ).
  CREATE OBJECT r_truck EXPORTING i_make = 'Leyland' i_model ='AL900' i_load = 900000.
  r_rental->add_vehicle( r_truck ).


  CREATE OBJECT r_bus EXPORTING i_make = 'Mercedes' i_model ='M1000' i_seats = 50.
  r_rental->add_vehicle( r_bus ).
  CREATE OBJECT r_bus EXPORTING i_make = 'Volvo' i_model ='V7900' i_seats = 40.
  r_rental->add_vehicle( r_bus ).


  r_rental->display_attributes( ).

  WRITE:/ 'The total load carrying capacity of the fleet is -', r_rental->get_load( ).
*  lcl_vehicle=>get_no_of_vehicles( IMPORTING e_no_of_vehicles = v_count ).
*  v_count = lcl_vehicle=>get_no_of_vehicles( ).
  WRITE:/ 'Total number of vehicles =', lcl_vehicle=>get_no_of_vehicles( ).
