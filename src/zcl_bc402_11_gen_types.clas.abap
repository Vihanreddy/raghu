class ZCL_BC402_11_GEN_TYPES definition
  public
  create public .

public section.

*"* public components of class ZCL_BC402_11_GEN_TYPES
*"* do not include other source files here!!!
  class-methods WRITE_ANY_STRUCT
    importing
      !IS_STRUCT type ANY .
  class-methods WRITE_ANY_TABLE
    importing
      !IT_TABLE type ANY TABLE .
protected section.
*"* protected components of class CL_BC402_DYS_GENERIC_WRITE
*"* do not include other source files here!!!
private section.
*"* private components of class CL_BC402_DYS_GENERIC_WRITE
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_BC402_11_GEN_TYPES IMPLEMENTATION.


method WRITE_ANY_STRUCT.
  FIELD-SYMBOLS : <fs> TYPE simple.
  DO.
    ASSIGN COMPONENT sy-index OF STRUCTURE is_struct TO <fs>.
    IF sy-subrc = 0.
      WRITE <fs>.
    ELSE.
      EXIT.
    ENDIF.
  ENDDO.
ENDMETHOD.


method WRITE_ANY_TABLE.
  FIELD-SYMBOLS <fs_line> TYPE any.
  LOOP AT it_table ASSIGNING <fs_line>.
    WRITE:/.
    write_any_struct( <fs_line> ).
  ENDLOOP.
ENDMETHOD.
ENDCLASS.
