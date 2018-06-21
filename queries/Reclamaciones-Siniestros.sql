/*========================================
       Póliza - Póliza
=========================================*/

--Relaciona el historial de las pólizas con los asegurados de la misma

SELECT 
claim.NSINIEST, 
claim.NPOLIZA, 
claim.RAMSUBRAMO, 
branch.ramo, 
branch.subramo,
TO_DATE('20'||SUBSTR(FINIVIG,2,2)||'-'||SUBSTR(FINIVIG,4,2)||'-'||SUBSTR(FINIVIG,6,2), 'YYYY-MM-DD') date_init,
CAST(sinister.AAVIG as INT) INI_ANIO, sinister.CRITEMIS individual,
states.EDO, 
states.NOM_EDO state_name, 
city.CIUDAD city, 
city.NOMBREPOB city_name,
sinister.NASEG, 
sinister.NOMBTIT,
insured.CVSEXO gender, 
insured.CVNFUMA, 
insured.RIESGOCUP, 
insured.CVEDOCIV, 
CAST(insured.EDADCALC as INT) age,
TO_DATE('20'||SUBSTR(FECHASIN,2,2)||'-'||SUBSTR(FECHASIN,4,2)||'-'||SUBSTR(FECHASIN,6,2), 'YYYY-MM-DD') sinister_date,
catsin.TIPOSIN, catsin.SIN_DESC sin_decription,
DESCACC_1 dis_description,
cover.COVERS, 
total_claim, 
total_paid, 
diff_mount,
--Cuenta las reclamaciones por cada póliza 
COUNT (claim.NRECLAM) claims
--
--La reclamación es la tabla pivote y todo se pega por la izquierda
FROM DWHRAW.ST_SINI_RECLAM claim 
LEFT JOIN (SELECT LPAD(GUIARAMORAMSUBRAMO,5,'0') as RAMSUBRAMO, DESCRIPCION ramo, DESCRIPCIONLARGA subramo from DWHRAW.st_sini_guiaramo) branch 
ON branch.RAMSUBRAMO=claim.RAMSUBRAMO
--
LEFT JOIN (SELECT SUBSTR(VALOR ,2,2)as EDO, INTMINIM as NOM_EDO FROM DWHRAW.ST_SINI_CLAVES WHERE DATO='EDO' ) states 
ON claim.EDO=states.EDO
--
LEFT JOIN DWHRAW.ST_SINI_CIUDADES city 
ON claim.EDO=city.EDO AND claim.CIUDAD=city.CIUDAD 
--
LEFT JOIN DWHRAW.ST_SINI_SINIESTR sinister 
ON claim.RAMSUBRAMO=sinister.RAMSUBRAMO AND claim.NPOLIZA=sinister.NPOLIZA AND claim.NSINIEST=sinister.NSINIEST
--
LEFT JOIN DWHRAW.ST_SINI_ASEGSIN insured 
ON insured.NSINIEST=sinister.NSINIEST AND insured.NPOLIZA=sinister.NPOLIZA AND insured.RAMSUBRAMO=sinister.RAMSUBRAMO
--
LEFT JOIN (SELECT VALOR as TIPOSIN, INTMEDIA as SIN_DESC FROM DWHRAW.ST_SINI_CLAVES WHERE DATO='TIPOSIN' ) catsin 
ON sinister.TIPOSIN=catsin.TIPOSIN
--
LEFT JOIN (SELECT NSINIEST, COUNT(DISTINCT(TIPOADIC)) COVERS FROM DWHRAW.ST_SINI_COBSIN GROUP BY  NSINIEST) cover
ON sinister.NSINIEST=cover.NSINIEST
--
LEFT JOIN (SELECT NSINIEST,
SUM(CASE WHEN MONEDA=2 THEN IMPRECMO*15 ELSE 0 END) + SUM(CASE WHEN MONEDA=1 THEN IMPRECMO+0 ELSE 0 END) total_claim,
SUM(CASE WHEN MONEDA=2 THEN IMPPAGMO*15 ELSE 0 END) + SUM(CASE WHEN MONEDA=1 THEN IMPPAGMO+0 ELSE 0 END) total_paid,
SUM(CASE WHEN MONEDA=2 THEN IMPRECMO*15 ELSE 0 END) + SUM(CASE WHEN MONEDA=1 THEN IMPRECMO+0 ELSE 0 END) -
SUM(CASE WHEN MONEDA=2 THEN IMPPAGMO*15 ELSE 0 END) + SUM(CASE WHEN MONEDA=1 THEN IMPPAGMO+0 ELSE 0 END) diff_mount
FROM DWHRAW.ST_SINI_RECLAMD
GROUP BY NSINIEST) amount
ON sinister.NSINIEST=amount.NSINIEST
--
WHERE sinister.NSINIEST NOT IN (SELECT NSINIEST FROM DWHRAW.ST_SINI_SINIESTR GROUP BY NSINIEST HAVING COUNT(*) >1)  --excluding duplicate sinisters
AND branch.RAMO <> 'VIDA'
--
AND CAST(SUBSTR(FECHASIN,2,2) AS INT) BETWEEN 0 AND 17
AND CAST(SUBSTR(FECHASIN,4,2) AS INT) BETWEEN 1 AND 12
AND CAST(SUBSTR(FECHASIN,6,2) AS INT) BETWEEN 1 AND 30
AND CAST(SUBSTR(FINIVIG,2,2) AS INT) BETWEEN 0 AND 17
AND CAST(SUBSTR(FINIVIG,4,2) AS INT) BETWEEN 1 AND 12
AND CAST(SUBSTR(FINIVIG,6,2) AS INT) BETWEEN 1 AND 30
--
GROUP BY  claim.NSINIEST, 
claim.NPOLIZA, 
claim.RAMSUBRAMO, 
branch.ramo, 
branch.subramo,
TO_DATE('20'||SUBSTR(FINIVIG,2,2)||'-'||SUBSTR(FINIVIG,4,2)||'-'||SUBSTR(FINIVIG,6,2), 'YYYY-MM-DD'),
CAST(sinister.AAVIG as INT), 
sinister.CRITEMIS, 
states.EDO, 
states.NOM_EDO, 
city.CIUDAD, 
city.NOMBREPOB,
sinister.NASEG, 
sinister.NOMBTIT, 
insured.CVSEXO, 
insured.CVNFUMA, 
insured.RIESGOCUP, 
insured.CVEDOCIV, 
CAST(insured.EDADCALC as INT), 
TO_DATE('20'||SUBSTR(FECHASIN,2,2)||'-'||SUBSTR(FECHASIN,4,2)||'-'||SUBSTR(FECHASIN,6,2), 'YYYY-MM-DD'),
catsin.TIPOSIN, 
catsin.SIN_DESC, 
DESCACC_1, 
cover.COVERS, 
total_claim, 
total_paid, 
diff_mount
;



