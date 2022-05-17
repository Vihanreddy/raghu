*&---------------------------------------------------------------------*
*&  Include           BC401_INT_S2_CARRIER
*&---------------------------------------------------------------------*
*------------------------------------------------------------------*
*       CLASS lcl_airplane DEFINITION                              *
*------------------------------------------------------------------*
CLASS lcl_airplane DEFINITION.

  PUBLIC SECTION.

    METHODS:
     constructor
        IMPORTING
          iv_name      TYPE string
          iv_planetype TYPE saplane-planetype
        EXCEPTIONS
          wrong_planetype,

       display_attributes.

    CLASS-METHODS:
      class_constructor,
      display_n_o_airplanes,
      get_n_o_airplanes
        RETURNING value(rv_count) TYPE i.

  PROTECTED SECTION.

    CONSTANTS:
      c_pos_1 TYPE i VALUE 30.

  PRIVATE SECTION.

    TYPES:
      ty_planetypes TYPE STANDARD TABLE OF saplane
                         WITH NON-UNIQUE KEY planetype.

    DATA:
      mv_name      TYPE string,
      mv_planetype TYPE saplane-planetype,
      mv_weight    TYPE saplane-weight,
      mv_tankcap   TYPE saplane-tankcap.

    CLASS-DATA:
      gv_n_o_airplanes TYPE i,
      gt_planetypes    TYPE ty_planetypes.

    CLASS-METHODS:
      get_technical_attributes
        IMPORTING
          iv_type     TYPE saplane-planetype
        EXPORTING
          ev_weight   TYPE saplane-weight
          ev_tankcap  TYPE saplane-tankcap
        EXCEPTIONS
          wrong_planetype.

ENDCLASS.                    "lcl_airplane DEFINITION

*------------------------------------------------------------------*
*       CLASS lcl_airplane IMPLEMENTATION                          *
*------------------------------------------------------------------*
CLASS lcl_airplane IMPLEMENTATION.

  METHOD class_constructor.
    SELECT * FROM saplane INTO TABLE gt_planetypes.
  ENDMETHOD.                    "class_constructor

  METHOD constructor.

    mv_name      = iv_name.
    mv_planetype = iv_planetype.

    get_technical_attributes(
      EXPORTING
          iv_type = iv_planetype
      IMPORTING
          ev_weight  = mv_weight
          ev_tankcap = mv_tankcap
       EXCEPTIONS
          wrong_planetype = 1 ).

    IF sy-subrc <> 0.
      RAISE wrong_planetype.
    ELSE.
      gv_n_o_airplanes = gv_n_o_airplanes + 1.
    ENDIF.

  ENDMETHOD.                    "constructor

  METHOD display_attributes.

    WRITE:
      / icon_ws_plane AS ICON,
      / 'Name of Airplane'(001) , AT c_pos_1 mv_name,
      / 'Type of Airplane:'(002), AT c_pos_1 mv_planetype,
      / 'Weight:'(003),           AT c_pos_1 mv_weight LEFT-JUSTIFIED,
      / 'Tank capacity:'(004),    AT c_pos_1 mv_tankcap LEFT-JUSTIFIED.

  ENDMETHOD.                    "display_attributes

  METHOD display_n_o_airplanes.
    SKIP.
    WRITE:
     / 'Number of airplanes:'(ca1),
       AT c_pos_1 gv_n_o_airplanes LEFT-JUSTIFIED.
  ENDMETHOD.                    "display_n_o_airplanes

  METHOD get_n_o_airplanes.
    rv_count = gv_n_o_airplanes.
  ENDMETHOD.                    "get_n_o_airplanes

  METHOD get_technical_attributes.
    DATA: ls_planetype TYPE saplane.

    READ TABLE gt_planetypes INTO ls_planetype
                             WITH TABLE KEY planetype = iv_type
                             TRANSPORTING weight tankcap.
    IF sy-subrc = 0.
      ev_weight  = ls_planetype-weight.
      ev_tankcap = ls_planetype-tankcap.
    ELSE.
      RAISE wrong_planetype.
    ENDIF.
  ENDMETHOD.                    "get_technical_attributes

ENDCLASS.                    "lcl_airplane IMPLEMENTATION

*---------------------------------------------------------------------*
*       CLASS lcl_cargo_plane DEFINITION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcl_cargo_plane DEFINITION INHERITING FROM lcl_airplane.

  PUBLIC SECTION.

    METHODS:
      constructor
        IMPORTING
          iv_name      TYPE string
          iv_planetype TYPE saplane-planetype
          iv_cargo     TYPE s_plan_car
        EXCEPTIONS
          wrong_planetype,

      display_attributes REDEFINITION.

  PRIVATE SECTION.

    DATA:
      mv_cargo TYPE s_plan_car.

ENDCLASS.                    "lcl_cargo_plane DEFINITION

*---------------------------------------------------------------------*
*       CLASS lcl_cargo_plane IMPLEMENTATION
*---------------------------------------------------------------------*
CLASS lcl_cargo_plane IMPLEMENTATION.

  METHOD constructor.
    super->constructor(
      EXPORTING
        iv_name      = iv_name
        iv_planetype = iv_planetype
      EXCEPTIONS
        wrong_planetype = 1 ).
    IF sy-subrc <> 0.
      RAISE wrong_planetype.
    ENDIF.
    mv_cargo = iv_cargo.
  ENDMETHOD.                    "constructor


  METHOD display_attributes.
    super->display_attributes( ).
    WRITE:
      / 'Max Cargo:'(005), AT c_pos_1 mv_cargo LEFT-JUSTIFIED.
    ULINE.
  ENDMETHOD.                    "display_attributes

ENDCLASS.                    "lcl_cargo_plane IMPLEMENTATION

*---------------------------------------------------------------------*
*       CLASS lcl_passenger_plane DEFINITION
*---------------------------------------------------------------------*
CLASS lcl_passenger_plane DEFINITION INHERITING FROM lcl_airplane.

  PUBLIC SECTION.

    METHODS:
      constructor
        IMPORTING
          iv_name      TYPE string
          iv_planetype TYPE saplane-planetype
          iv_seats     TYPE s_seatsmax
         EXCEPTIONS
           wrong_planetype,

     display_attributes REDEFINITION.

  PRIVATE SECTION.

    DATA:
      mv_seats TYPE s_seatsmax.
ENDCLASS.                    "lcl_passenger_plane DEFINITION

*---------------------------------------------------------------------*
*       CLASS lcl_passenger_plane IMPLEMENTATION
*---------------------------------------------------------------------*
CLASS lcl_passenger_plane IMPLEMENTATION.

  METHOD constructor.
    super->constructor(
      EXPORTING
        iv_name      = iv_name
        iv_planetype = iv_planetype
      EXCEPTIONS
        wrong_planetype = 1 ).
    IF sy-subrc <> 0.
      RAISE wrong_planetype.
    ENDIF.
    mv_seats = iv_seats.
  ENDMETHOD.                    "constructor

  METHOD display_attributes.
    super->display_attributes( ).
    WRITE:
      / 'Max Seats:'(006), AT c_pos_1 mv_seats LEFT-JUSTIFIED.
    ULINE.
  ENDMETHOD.                    "display_attributes
ENDCLASS.                    "lcl_passenger_plane IMPLEMENTATION

*---------------------------------------------------------------------*
*       CLASS lcl_carrier DEFINITION
*---------------------------------------------------------------------*
CLASS lcl_carrier DEFINITION.

  PUBLIC SECTION.

    INTERFACES:
      lif_partner.

    METHODS:
      constructor IMPORTING iv_name TYPE string,

      display_attributes,

      add_airplane IMPORTING io_plane TYPE REF TO lcl_airplane.

  PRIVATE SECTION.

    DATA:
      mv_name      TYPE string,
      mt_airplanes TYPE TABLE OF REF TO lcl_airplane.

    METHODS:
      display_airplanes.

ENDCLASS.                    "lcl_carrier DEFINITION

*---------------------------------------------------------------------*
*       CLASS lcl_carrier IMPLEMENTATION
*---------------------------------------------------------------------*
CLASS lcl_carrier IMPLEMENTATION.

  METHOD constructor.
    mv_name = iv_name.
  ENDMETHOD.                    "constructor

  METHOD display_attributes.
    SKIP 2.
    WRITE: icon_flight AS ICON,
           mv_name.
    ULINE.
    ULINE.
    me->display_airplanes( ).
  ENDMETHOD.                    "display_attributes

  METHOD add_airplane.
    APPEND io_plane TO mt_airplanes.
  ENDMETHOD.                    "add_airplane

  METHOD display_airplanes.
    DATA: lo_plane TYPE REF TO lcl_airplane.
    LOOP AT mt_airplanes INTO lo_plane.
      lo_plane->display_attributes( ).
    ENDLOOP.
  ENDMETHOD.                    "display_airplanes

  METHOD lif_partner~display_partner.
    me->display_attributes( ).
  ENDMETHOD.                    "lif_partner~display_partner

ENDCLASS.                    "lcl_carrier IMPLEMENTATION
