class ZBC401_11_DYT_TYPES definition
  public
  create public .

public section.

*"* public components of class ZBC401_11_DYT_TYPES
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



CLASS ZBC401_11_DYT_TYPES IMPLEMENTATION.


method WRITE_ANY_TABLE.
  FIELD-SYMBOLS <fs_line> TYPE any.
 LOOP AT it_table ASSIGNING <fs_line>.
   WRITE:/
      write_any_struct( <fs_line> ).
    ENDLOOP.


endmethod.
ENDCLASS.
