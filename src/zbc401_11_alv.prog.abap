*&---------------------------------------------------------------------*
*& Report  SAPBC401_ALV_S1                                           *
*&---------------------------------------------------------------------*
*& Demo on ALV-Grid event-processing of double_click                   *
*&---------------------------------------------------------------------*

REPORT  zbc401_11_alv.

*---------------------------------------------------------------------*
*       CLASS lcl_event_handler DEFINITION
*---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.

    METHODS on_double_click FOR EVENT double_click
                                   OF cl_gui_alv_grid
                            IMPORTING es_row_no e_column.
ENDCLASS.                    "lcl_event_handler DEFINITION

*---------------------------------------------------------------------*
*       CLASS lcl_event_handler IMPLEMENTATION
*---------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.

  METHOD on_double_click.

    MESSAGE i010(bc401) WITH es_row_no-row_id e_column-fieldname.

  ENDMETHOD.                    "handler_method
ENDCLASS.                    "lcl_event_handler IMPLEMENTATION

************** Types and Data Definitions ************************
TYPES: ty_spfli TYPE STANDARD TABLE OF spfli
                     WITH NON-UNIQUE KEY carrid connid.

DATA: ok_code TYPE sy-ucomm.

DATA: go_handler TYPE REF TO lcl_event_handler,
      go_container TYPE REF TO cl_gui_custom_container,
      go_alv_grid  TYPE REF TO cl_gui_alv_grid.

DATA: gt_spfli TYPE ty_spfli.

START-OF-SELECTION.
********************

  SELECT * FROM spfli INTO TABLE gt_spfli.

  CALL SCREEN '0100'.

*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'DYNPROSTATUS'.
  SET TITLEBAR  'TITLE1'.
ENDMODULE.                 " STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  ALV_GRID  OUTPUT
*&---------------------------------------------------------------------*
MODULE alv_grid OUTPUT.
*** Create object of class CL_GUI_CUSTOM_CAONTAINER to manage data !
  IF go_container IS NOT BOUND.
    CREATE OBJECT go_container
      EXPORTING
        container_name = 'CONTAINER_1'
      EXCEPTIONS
        others         = 6.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

*** create object of class cl_gui_alv_grid to visualize data !
    CREATE OBJECT go_alv_grid
      EXPORTING
        i_parent = go_container
      EXCEPTIONS
        others   = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

*** create handler instance and register handler method *******
    CREATE OBJECT go_handler.
    SET HANDLER   go_handler->on_double_click FOR go_alv_grid.

*** Call method to visualize data of internal table ************
    CALL METHOD go_alv_grid->set_table_for_first_display
      EXPORTING
        i_structure_name = 'SPFLI'
      CHANGING
        it_outtab        = gt_spfli
      EXCEPTIONS
        OTHERS           = 4.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDIF.

ENDMODULE.                 " ALV_GRID  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE ok_code.
    WHEN 'BACK'.
      SET SCREEN 0.
    WHEN 'EXIT'.
      LEAVE PROGRAM.

  ENDCASE.

ENDMODULE.                 " USER_COMMAND_0100  INPUT
