*&---------------------------------------------------------------------*
*&  Include           ZBC401_11_PLANE
*&---------------------------------------------------------------------*
CLASS lcl_airplane DEFINITION.
  PUBLIC SECTION.
    METHODS: set_attributes IMPORTING i_name      TYPE string
                                      i_planetype TYPE saplane-planetype,
      display_attributes.
    CLASS-METHODS: display_n_o_airplanes,
      get_n_o_airplanes RETURNING VALUE(r_count) TYPE i.

  PRIVATE SECTION.
    CONSTANTS pos TYPE i VALUE 30.
    DATA: mv_name      TYPE string, mv_planetype TYPE saplane-planetype.
    CLASS-DATA: gv_n_o_airplanes TYPE i.
ENDCLASS.

CLASS lcl_airplane IMPLEMENTATION.
  METHOD set_attributes.
    mv_name = i_name.
    mv_planetype = i_planetype.
    ADD 1 TO gv_n_o_airplanes.
  ENDMETHOD.

  METHOD display_attributes.
    WRITE:/ icon_ws_plane AS ICON,
            'Name of airplane:', AT pos mv_name,
            / 'Aircraft type:', AT pos mv_planetype.
  ENDMETHOD.

  METHOD display_n_o_airplanes.
    WRITE:/ 'Number of airplanes:', AT pos gv_n_o_airplanes.
  ENDMETHOD.

  METHOD get_n_o_airplanes.
    r_count = gv_n_o_airplanes.
  ENDMETHOD.
ENDCLASS.
