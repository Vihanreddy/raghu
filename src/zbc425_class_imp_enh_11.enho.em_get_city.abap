METHOD GET_CITY .
  SELECT SINGLE city FROM scustom
 INTO rv_city
 WHERE id = iv_id.

 IF sy-subrc <> 0.
 CLEAR rv_city.
 ENDIF.
ENDMETHOD.
