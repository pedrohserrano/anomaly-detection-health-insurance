/*========================================
       Participantes - Siniestro
=========================================*/

--Relaciona el historial de los siniestros con los todos participantes adyacentes al siniestro

--SELECT * FROM (
SELECT SINIESTR.nsiniest,
TO_DATE((CASE WHEN SUBSTR(SINIESTR.fechasin ,1,1) = '1' THEN CONCAT(CONCAT(SUBSTR(SINIESTR.fechasin ,6,2),CONCAT('/',SUBSTR(SINIESTR.fechasin ,4,2))),CONCAT('/',CONCAT('20',SUBSTR(SINIESTR.fechasin ,2,2)))) 
ELSE CONCAT(CONCAT(SUBSTR(SINIESTR.fechasin ,6,2),CONCAT('/',SUBSTR(SINIESTR.fechasin ,4,2))),CONCAT('/',CONCAT('19',SUBSTR(SINIESTR.fechasin ,2,2)))) END),'DD/MM/YYYY') date_sin,
CASE WHEN SINIESTR.nombcont IS NULL THEN 'SV' ELSE SINIESTR.nombcont END policy_name,
CASE WHEN SINIESTR.nombtit IS NULL THEN 'SV' ELSE SINIESTR.nombtit END insured_name,
CASE WHEN POL.nagente_1 IS NULL THEN 'SV' ELSE POL.nagente_1 END agent_id,
CASE WHEN OFI.num_oficina IS NULL THEN 'SV' ELSE OFI.num_oficina END office_id,
CASE WHEN OFI.nom_oficina IS NULL THEN 'SV' ELSE OFI.nom_oficina END office_name,
CASE WHEN RECLAM.rfcmed_1 IS NULL THEN 
CASE WHEN RECLAM.rfcmed_2 IS NULL THEN 
CASE WHEN RECLAM.rfcmed_3 IS NULL THEN 
CASE WHEN RECLAM.rfcmed_4 IS NULL THEN 
CASE WHEN RECLAM.rfcmed_5 IS NULL THEN 'SV'
ELSE RECLAM.rfcmed_5 END
ELSE RECLAM.rfcmed_4 END 
ELSE RECLAM.rfcmed_3 END 
ELSE RECLAM.rfcmed_2 END
ELSE RECLAM.rfcmed_1 END phisycian,
CASE WHEN RECLAM.rfcinst IS NULL THEN 'SV' ELSE RECLAM.rfcinst END  hosp_id,
CASE WHEN INST.nombinst IS NULL THEN 'SV' ELSE INST.nombinst END hosp_name,
CASE WHEN RECLAM.idcapt IS NULL THEN 'SV' ELSE RECLAM.idcapt END  dictamin
--
FROM DWHRAW.ST_SINI_SINIESTR SINIESTR,
DWHRAW.S_SABE_POLIZA POL,
DWHRAW.S_CUA_TOFICINAADN OFI,
DWHRAW.ST_SINI_RECLAM RECLAM,
DWHRAW.S_SABE_INSTITUC INST
--
WHERE 1=1
--
AND POL.ramsubramo = SINIESTR.ramsubramo
AND POL.npoliza = SINIESTR.npoliza
AND OFI.cve_age = POL.nagente_1
AND RECLAM.nsiniest = SINIESTR.nsiniest
AND INST.rfcinst = RECLAM.rfcinst
--
AND POL.estatus_ind = 1
AND INST.estatus_ind = 1
/*) WHERE 1=1
AND NSINIEST<> 'SV'
AND POLICY_NAME <> 'SV'
AND INSURED_NAME <> 'SV'
AND AGENT_ID <> 'SV'
AND OFFICE_ID <> 'SV'
AND OFFICE_NAME <> 'SV'
AND PHISYCIAN <> 'SV'
AND HOSP_ID <> 'SV'
AND HOSP_NAME <> 'SV'
AND DICTAMIN <> 'SV'
*/