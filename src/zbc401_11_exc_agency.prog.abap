*---------------------------------------------------------------------*
*       INTERFACE lif_partners
*&---------------------------------------------------------------------*
*INTERFACE lif_partner.
*  METHODS:
*    display_partner.
*  EVENTS:
*    partner_created.
*ENDINTERFACE.                    "lif_partners
*---------------------------------------------------------------------*
*       CLASS lcl_travel_agency DEFINITION
*---------------------------------------------------------------------*
CLASS lcl_travel_agency DEFINITION.

  PUBLIC SECTION.

    METHODS:
      constructor IMPORTING iv_name TYPE string,

      display_agency_partners,

      display_attributes.

  PRIVATE SECTION.

    DATA:
      mv_name     TYPE string,
      mt_partners TYPE TABLE OF REF TO if_partner.

    METHODS:
      on_partner_created FOR EVENT partner_created
                                OF if_partner
                         IMPORTING sender.


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
      lo_partner TYPE REF TO if_partner.

    WRITE 'Here are the partners of the travel agency:'(008).
    ULINE.
    LOOP AT mt_partners INTO lo_partner.
      lo_partner->display_partner( ).
    ENDLOOP.

  ENDMETHOD.                    "display_agency_partners

  METHOD  constructor.
    mv_name = iv_name.
    SET HANDLER on_partner_created FOR ALL INSTANCES.
  ENDMETHOD.                    "constructor

  METHOD  on_partner_created.
    APPEND sender TO mt_partners.
  ENDMETHOD.                    "on_partner_created

ENDCLASS.                    "lcl_travel_agency IMPLEMENTATION
