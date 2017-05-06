/*========================================
		Ubucaciones-Póliza
=========================================*/

--Relaciona la póliza con la ubicación registrada con los campos geográficos

SELECT 
POL.ramsubramo AS RAMSUBRAMO_POL,
POL.npoliza AS NPOLIZA_POL,
POL.colonia AS  COLONIA_POL,
POL.poblacion AS POBLACION_POL,
NVL((SELECT CLAVES.intlarga
FROM DWHRAW.S_SABE_CLAVES CLAVES
WHERE TO_NUMBER(CLAVES.valor) = TO_NUMBER(POL.edo)
AND LTRIM(RTRIM(CLAVES.dato)) = 'EDO'
AND CLAVES.estatus_ind = 1),'NO IDENTIFICADO') AS ENTIDAD_FEDERATIVA_POL,
POL.codpost AS CODIGO_POSTAL_POL, 
SEPOMEX.lat_dir_desc AS LATITUD_POL,
SEPOMEX.long_dir_desc AS LONGITUD_POL,
TO_NUMBER(POL.pmaanual) AS PRIMA_ANUAL_POL,
ASE.conteo_aseg NUMERO_ASEGURADOS_POL
--
FROM DWHRAW.S_SABE_POLIZA POL,
DWHHOM.SAT_SEPOMEX SEPOMEX,
(SELECT ASE.ramsubramo AS RAMSUBRAMO, ASE.npoliza AS NPOLIZA, ASE.naseg AS NASEG, ASE.ndepend AS NDEPEND, ASE.folendoso AS FOLENDOSO, COUNT(1) AS CONTEO_ASEG
FROM DWHRAW.S_SABE_ASEGURPL ASE
WHERE 1=1
AND ASE.estatus_ind = 1
AND ASE.stbaja = '0'
AND ASE.stalta = '1'
GROUP BY ASE.ramsubramo, ASE.npoliza, ASE.naseg, ASE.ndepend, ASE.folendoso) ASE
WHERE 1=1
AND ASE.ramsubramo = POL.ramsubramo
AND ASE.npoliza = POL.npoliza
--
AND SEPOMEX.cve_codigo_postal_cd = POL.codpost
AND POL.estatus_ind = 1
--AND rownum < 10000
;
