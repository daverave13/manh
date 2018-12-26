create or replace FUNCTION       XXNBL_SHIP_CONFIRM 
(
p_fac varchar2,
p_shipment VARCHAR2
)
RETURN VARCHAR2
AS
pragma autonomous_transaction;

v_output VARCHAR2(100);

V_SHIPMENT_ID NUMBER;
V_FACILITY_ID NUMBER;
V_USER_ID     VARCHAR2(50);
V_BATCH_CTRL_NBR  NUMBER;

BEGIN

v_output := '0';

SELECT DISTINCT S.SHIPMENT_ID, OO.O_FACILITY_ID, OO.CREATED_SOURCE, OO.BATCH_CTRL_NBR
INTO V_SHIPMENT_ID, V_FACILITY_ID, V_USER_ID, V_BATCH_CTRL_NBR
FROM OUTPT_ORDERS OO, OUTPT_LPN OL, SHIPMENT S
WHERE OL.TC_SHIPMENT_ID = p_shipment
AND S.TC_SHIPMENT_ID = OL.TC_SHIPMENT_ID
AND OL.TC_ORDER_ID = OO.TC_ORDER_ID
AND ROWNUM <= 1;


INSERT INTO OM_SCHED_EVENT 
SELECT SEQ_EVENT_ID.NEXTVAL, SYSDATE
, '{idType=SHIPMENT, idForExport=' || V_SHIPMENT_ID ||', invoiceBatchNumber=' 
|| V_BATCH_CTRL_NBR
|| ', shipperPk=1, facilityId=' 
|| V_FACILITY_ID
|| ', userId=' || V_USER_ID 
|| ', eventProcessorClass=com.manh.wmos.services.communication.service.ShipConfirmExportService}'
, SYSDATE, NULL, 0, NULL, 0, 0, 0, NULL, 0, 0, 0
FROM DUAL;

commit;
   RETURN v_output;

END XXNBL_SHIP_CONFIRM;
--adding a comment 03:12:55 12.26.2018