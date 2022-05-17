class ZCX_11_INVALID_PLANETYPE definition
  public
  inheriting from CX_STATIC_CHECK
  create private .

public section.

  interfaces IF_T100_DYN_MSG .
  interfaces IF_T100_MESSAGE .

  data PLANETYPE type S_PLANETYE .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !PLANETYPE type S_PLANETYE optional .
protected section.
private section.
ENDCLASS.



CLASS ZCX_11_INVALID_PLANETYPE IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
me->PLANETYPE = PLANETYPE .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = IF_T100_MESSAGE=>DEFAULT_TEXTID.
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
  endmethod.
ENDCLASS.
