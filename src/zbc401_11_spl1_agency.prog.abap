*---------------------------------------------------------------------*
*       CLASS lcl_travel_agency DEFINITION
*---------------------------------------------------------------------*
CLASS lcl_travel_agency DEFINITION FINAL CREATE PRIVATE.

  PUBLIC SECTION.

    CLASS-METHODS:
      get_instance
        RETURNING
          value(ro_instance) TYPE REF TO lcl_travel_agency.

    METHODS:
      display_agency_partners,
      display_attributes.

  PRIVATE SECTION.

    DATA:
      mv_name     TYPE string,
      mt_partners TYPE TABLE OF REF TO if_partner.

    CLASS-DATA:
       go_instance TYPE REF TO lcl_travel_agency.

    METHODS:
      constructor
        IMPORTING
          iv_name TYPE string,
      on_partner_created FOR EVENT partner_created
                                OF if_partner
                         IMPORTING sender.

ENDCLASS.                    "lcl_travel_agency DEFINITION

*---------------------------------------------------------------------*
*       CLASS lcl_travel_agency IMPLEMENTATION
*---------------------------------------------------------------------*
CLASS lcl_travel_agency IMPLEMENTATION.

  METHOD get_instance.

    IF go_instance IS NOT BOUND.
      CREATE OBJECT go_instance
        EXPORTING
          iv_name = 'Book & Smile'.
    ENDIF.

    ro_instance = go_instance.

  ENDMETHOD.                    "get_instance

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
