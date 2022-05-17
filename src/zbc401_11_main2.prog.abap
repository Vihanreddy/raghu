*&---------------------------------------------------------------------*
*& Report  SAPBC401_BAS_S4                                             *
*&---------------------------------------------------------------------*
*&       call constructor of class lcl_airplane                        *
*&       define, raise and handle classical exception                 *
*&---------------------------------------------------------------------*
REPORT  zbc401_11_main2.

TYPE-POOLS icon.

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
      display_n_o_airplanes,
      get_n_o_airplanes
        RETURNING value(rv_count) TYPE i.

  PRIVATE SECTION.

    CONSTANTS:
      c_pos_1 TYPE i VALUE 30.

    DATA:
      mv_name      TYPE string,
      mv_planetype TYPE saplane-planetype,
      mv_weight    TYPE saplane-weight,
      mv_tankcap   TYPE saplane-tankcap.

    CLASS-DATA:
      gv_n_o_airplanes TYPE i.

ENDCLASS.                    "lcl_airplane DEFINITION

*------------------------------------------------------------------*
*       CLASS lcl_airplane IMPLEMENTATION                          *
*------------------------------------------------------------------*
CLASS lcl_airplane IMPLEMENTATION.

  METHOD constructor.

    DATA: ls_planetype TYPE saplane.

    mv_name      = iv_name.
    mv_planetype = iv_planetype.

    SELECT SINGLE * FROM saplane
                    INTO ls_planetype
                   WHERE planetype = iv_planetype.

    IF sy-subrc <> 0.
      RAISE wrong_planetype.
    ELSE.
      mv_weight  = ls_planetype-weight.
      mv_tankcap = ls_planetype-tankcap.
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
ENDCLASS.                    "lcl_airplane IMPLEMENTATION

DATA:
  go_airplane  TYPE REF TO lcl_airplane,
  gt_airplanes TYPE TABLE OF REF TO lcl_airplane,
  gv_count     TYPE i.

START-OF-SELECTION.
*******************

  lcl_airplane=>display_n_o_airplanes( ).

  CREATE OBJECT go_airplane
    EXPORTING
      iv_name         = 'LH Berlin'
      iv_planetype    = 'A321'
    EXCEPTIONS
      wrong_planetype = 1.
  IF sy-subrc = 0.
    APPEND go_airplane TO gt_airplanes.
  ENDIF.

  CREATE OBJECT go_airplane
    EXPORTING
      iv_name         = 'AA New York'
      iv_planetype    = '747-400'
    EXCEPTIONS
      wrong_planetype = 1.
  IF sy-subrc = 0.
    APPEND go_airplane TO gt_airplanes.
  ENDIF.

  CREATE OBJECT go_airplane
    EXPORTING
      iv_name         = 'US Hercules'
      iv_planetype    = '747-200F'
    EXCEPTIONS
      wrong_planetype = 1.
  IF sy-subrc = 0.
    APPEND go_airplane TO gt_airplanes.
  ENDIF.

  LOOP AT gt_airplanes INTO go_airplane.
    go_airplane->display_attributes( ).
  ENDLOOP.

  gv_count = lcl_airplane=>get_n_o_airplanes( ).

  SKIP 2.
  WRITE: / 'Number of airplanes'(ca1), gv_count.
