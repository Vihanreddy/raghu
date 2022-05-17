*&---------------------------------------------------------------------*
*&  Include           BC401_INT_S2_AGENCY
*&---------------------------------------------------------------------*
INTERFACE lif_partner.

  METHODS:
    display_partner.

ENDINTERFACE.                    "lif_partner
*---------------------------------------------------------------------*
*       CLASS lcl_travel_agency DEFINITION
*---------------------------------------------------------------------*
CLASS lcl_travel_agency DEFINITION.

  PUBLIC SECTION.

    METHODS:
      constructor IMPORTING iv_name TYPE string,

      add_partner IMPORTING io_partner TYPE REF TO lif_partner,

      display_agency_partners,

      display_attributes.

  PRIVATE SECTION.

    DATA:
      mv_name     TYPE string,
      mt_partners TYPE TABLE OF REF TO lif_partner.

ENDCLASS.                    "lcl_travel_agency DEFINITION

*---------------------------------------------------------------------*
*       CLASS lcl_travel_agency IMPLEMENTATION
*---------------------------------------------------------------------*
CLASS lcl_travel_agency IMPLEMENTATION.

  METHOD display_attributes.
    WRITE: / icon_private_files AS ICON,
             'Travel Agency:'(007), mv_name.
    SKIP.
    display_agency_partners( ).
  ENDMETHOD.                    "display_attributes

  METHOD display_agency_partners.
    DATA:
      lo_partner TYPE REF TO lif_partner.

    WRITE 'Here are the partners of the travel agency:'(008).
    ULINE.
    LOOP AT mt_partners INTO lo_partner.
      lo_partner->display_partner( ).
    ENDLOOP.

  ENDMETHOD.                    "display_agency_partners

  METHOD  constructor.
    mv_name = iv_name.
  ENDMETHOD.                    "constructor

  METHOD  add_partner.
    APPEND io_partner TO mt_partners.
  ENDMETHOD.                    "add_partner

ENDCLASS.                    "lcl_travel_agency IMPLEMENTATION
