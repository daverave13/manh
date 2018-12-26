create or replace FUNCTION XXNBL_SHIPMENT_ID (
   P_ORDER_ID   VARCHAR2)
   RETURN NUMBER
IS
   V_RETVAL       VARCHAR2(100) := NULL;
BEGIN

    SELECT DISTINCT SHIPMENT_ID INTO V_RETVAL
    FROM LPN
    WHERE TC_ORDER_ID = P_ORDER_ID;

    RETURN V_RETVAL;
    
EXCEPTION
WHEN OTHERS
THEN RETURN NULL;
   
END XXNBL_SHIPMENT_ID;