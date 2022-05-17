*&---------------------------------------------------------------------*
*& Report ZBC401_11_MAIN6
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBC401_11_MAIN6.

*------------------------------------------------------------------*
*       CLASS lcl_airplane DEFINITION                              *
*------------------------------------------------------------------*
CLASS lcl_airplane DEFINITION.

  PUBLIC SECTION.
    TYPES: ty_planetypes TYPE TABLE OF saplane WITH KEY planetype.
    METHODS:
      constructor IMPORTING  iv_name      TYPE string
                             iv_planetype TYPE saplane-planetype
                  EXCEPTIONS invalid_planetype,
      display_attributes.

    CLASS-METHODS:
      display_n_o_airplanes,
      get_n_o_airplanes
        RETURNING VALUE(rv_count) TYPE i,
      class_constructor.
  PROTECTED SECTION.
    CONSTANTS:
       c_pos_1 TYPE i VALUE 30.

  PRIVATE SECTION.

    DATA:
      mv_name      TYPE string,
      mv_planetype TYPE saplane-planetype,
      mv_weight    TYPE saplane-weight,
      mv_tankcap   TYPE saplane-tankcap.

    CLASS-DATA:
      gt_planetypes    TYPE ty_planetypes,
      gv_n_o_airplanes TYPE i.
    CLASS-METHODS: get_technical_attributes IMPORTING  i_planetype TYPE saplane-planetype
                                            EXPORTING  e_weight    TYPE saplane-weight
                                                       e_tankcap   TYPE saplane-tankcap
                                            EXCEPTIONS invalid_planetype.
ENDCLASS.                    "lcl_airplane DEFINITION

*------------------------------------------------------------------*
*       CLASS lcl_airplane IMPLEMENTATION                          *
*------------------------------------------------------------------*
CLASS lcl_airplane IMPLEMENTATION.

  METHOD constructor.

    mv_name      = iv_name.
    mv_planetype = iv_planetype.
*    SELECT SINGLE weight tankcap FROM saplane INTO (mv_weight, mv_tankcap) WHERE planetype = iv_planetype.
    get_technical_attributes( EXPORTING i_planetype = iv_planetype
                              IMPORTING e_weight = mv_weight
                                        e_tankcap = mv_tankcap
                              EXCEPTIONS invalid_planetype = 1 ).
    IF sy-subrc NE 0.
      RAISE invalid_planetype.
    ENDIF.
    gv_n_o_airplanes = gv_n_o_airplanes + 1.

  ENDMETHOD.                    "set_attributes

  METHOD display_attributes.

    WRITE:
      / icon_ws_plane AS ICON,
      / 'Name of Airplane'(001) ,   AT c_pos_1 mv_name,
      / 'Type of Airplane:'(002),   AT c_pos_1 mv_planetype,
      / 'Weight:',                  AT c_pos_1 mv_weight,
      / 'Tank Capacity:',           AT c_pos_1 mv_tankcap.

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

  METHOD class_constructor.
    SELECT * FROM saplane INTO TABLE gt_planetypes.
  ENDMETHOD.

  METHOD get_technical_attributes.
    DATA: wa_planetype LIKE LINE OF gt_planetypes.
    READ TABLE gt_planetypes INTO wa_planetype WITH TABLE KEY planetype = i_planetype.
    IF sy-subrc = 0.
      e_weight = wa_planetype-weight.
      e_tankcap = wa_planetype-tankcap.
    ELSE.
      RAISE  invalid_planetype.
    ENDIF.
  ENDMETHOD.
ENDCLASS.                    "lcl_airplane IMPLEMENTATION

CLASS lcl_passenger_plane DEFINITION INHERITING FROM lcl_airplane.
  PUBLIC SECTION.
    METHODS: constructor IMPORTING  iv_name      TYPE string
                                    iv_planetype TYPE saplane-planetype
                                    iv_seats     TYPE sflight-seatsmax
                         EXCEPTIONS invalid_planetype,
      display_attributes REDEFINITION.
  PRIVATE SECTION.
    DATA: mv_seats TYPE saplane-seatsmax.
ENDCLASS.

CLASS lcl_passenger_plane IMPLEMENTATION.

  METHOD constructor.
    super->constructor( EXPORTING iv_name = iv_name iv_planetype = iv_planetype  EXCEPTIONS invalid_planetype = 1 ).
    IF sy-subrc = 1.
      RAISE invalid_planetype.
    ENDIF.
    mv_seats = iv_seats.
  ENDMETHOD.
  METHOD display_attributes.
    super->display_attributes( ).
    WRITE:/ 'Seats:', AT c_pos_1 mv_seats COLOR COL_KEY.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_cargo_plane DEFINITION INHERITING FROM lcl_airplane.
  PUBLIC SECTION.
    METHODS: constructor IMPORTING  iv_name      TYPE string
                                    iv_planetype TYPE saplane-planetype
                                    iv_cargo     TYPE scplane-cargomax
                         EXCEPTIONS invalid_planetype,
      display_attributes REDEFINITION.
  PRIVATE SECTION.
    DATA: mv_cargo TYPE scplane-cargomax.
ENDCLASS.

CLASS lcl_cargo_plane IMPLEMENTATION.

  METHOD constructor.
    super->constructor( EXPORTING iv_name = iv_name iv_planetype = iv_planetype  EXCEPTIONS invalid_planetype = 1 ).
    IF sy-subrc = 1.
      RAISE invalid_planetype.
    ENDIF.
    mv_cargo = iv_cargo.
  ENDMETHOD.
  METHOD display_attributes.
    super->display_attributes( ).
    WRITE:/ 'Cargo :', AT c_pos_1 mv_cargo COLOR COL_HEADING.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_carrier DEFINITION.

  PUBLIC SECTION.

    METHODS:
      constructor IMPORTING iv_name TYPE string,
      add_airplane IMPORTING iv_plane TYPE REF TO lcl_airplane,
      display_attributes.

  PRIVATE SECTION.
    METHODS:  display_airplanes.
    DATA:
      mv_name      TYPE string,
      mt_airplanes TYPE TABLE OF REF TO lcl_airplane.

ENDCLASS.                    "lcl_carrier DEFINITION

*---------------------------------------------------------------------*
*       CLASS lcl_carrier IMPLEMENTATION
*---------------------------------------------------------------------*
CLASS lcl_carrier IMPLEMENTATION.

  METHOD constructor.
    mv_name = iv_name.
  ENDMETHOD.                    "constructor

  METHOD add_airplane.
    APPEND iv_plane TO mt_airplanes.
  ENDMETHOD.

  METHOD display_airplanes.
    DATA: r_plane TYPE REF TO lcl_airplane.

    LOOP AT mt_airplanes INTO r_plane.
      r_plane->display_attributes( ).
    ENDLOOP.
  ENDMETHOD.

  METHOD display_attributes.
    SKIP 2.
    WRITE: icon_flight AS ICON,
           mv_name.
    ULINE.
    display_airplanes( ).
    ULINE.
  ENDMETHOD.                    "display_attributes


ENDCLASS.                    "lcl_carrier IMPLEMENTATION


DATA:
  go_passplane TYPE REF TO lcl_passenger_plane,
  go_cplane    TYPE REF TO lcl_cargo_plane,
  go_carrier   TYPE REF TO lcl_carrier,
  gv_count     TYPE i.

START-OF-SELECTION.
*******************

  lcl_airplane=>display_n_o_airplanes( ).

  CREATE OBJECT go_carrier EXPORTING iv_name = 'American Airlines'.

  CREATE OBJECT go_passplane EXPORTING iv_name = 'LH Berlin' iv_planetype = 'A321-200' iv_seats = 800 EXCEPTIONS invalid_planetype = 1.
  IF sy-subrc = 1.
    WRITE:/ 'Invalid Planetype!' COLOR COL_NEGATIVE.
  ELSE.
    go_carrier->add_airplane( go_passplane ).
  ENDIF.

  CREATE OBJECT go_passplane EXPORTING iv_name = 'AA San Francisco' iv_planetype = '747-400' iv_seats = 500 EXCEPTIONS invalid_planetype = 1.
  IF sy-subrc = 1.
    WRITE:/ 'Invalid Planetype!' COLOR COL_NEGATIVE.
  ELSE.
    go_carrier->add_airplane( go_passplane ).
  ENDIF.

  CREATE OBJECT go_cplane EXPORTING iv_name = 'AA New York' iv_planetype = '747-400' iv_cargo = 100000 EXCEPTIONS invalid_planetype = 1.
  IF sy-subrc = 1.
    WRITE:/ 'Invalid Planetype!' COLOR COL_NEGATIVE.
  ELSE.
    go_carrier->add_airplane( go_cplane ).
  ENDIF.

  go_carrier->display_attributes( ).
  SKIP 2.
  WRITE: / 'Number of airplanes'(ca1), gv_count.
