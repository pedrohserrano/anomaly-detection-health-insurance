/*====================================

              DWH AND SCHEMA
====================================*/

--Source tables, both schemes craw and homologated
select * from all_tables where OWNER = 'DWHRAW' ;
select * from all_tables where OWNER = 'DWHHOM' ;

--All schemas
select OWNER, count(TABLE_NAME) tablas from all_tables group by OWNER;

/*====================================
              POLICIES
====================================*/

--Number of policies among the population
--1,618,673
SELECT COUNT(*) FROM DWHRAW.H_SABE_POLIZA;
SELECT COUNT(*) FROM DWHRAW.S_SABE_POLIZA WHERE ESTATUS_IND=1; 
--let's try the difference is H and S
--It corresponds to HUB schema of SABE system, thus belongs to GMM policies
--We know that raw system is all integrated on DWHHOM
--Anyway it has a small error because the frequency of upgrades are every month, let's see
SELECT COUNT(*), SOURCE_CD FROM DWHHOM.HUB_POLIZA WHERE SOURCE_CD = 'SABE' GROUP BY SOURCE_CD;
--1,618,656 There's only a very small difference actually

--One of the main problems we want to know  is the policie's status, is important to analyze all those which are actives, injured, reactivated
--That's why we shall know the policie's status helped with this following catalog
SELECT * FROM DWHRAW.S_SABE_CLAVES WHERE DATO='STPOLIZA' ORDER BY DATO DESC;

--We're wondering at this point which of those policies are active, but SABE_CLAVES table it seems do not have a key to match with SABE_POLIZA
--There's a field on S_SABE_POLIZA called ST_POLIZA it seems to be policie estatus
SELECT STPOLIZA, ('0'+STPOLIZA), COUNT(*) FROM DWHRAW.S_SABE_POLIZA GROUP BY STPOLIZA, ('0'+STPOLIZA);

--As we thought are the different status, but now we need a proper description about it, so we make the join
SELECT ('0'+pol.STPOLIZA) STATUS, cve.INTMEDIA, COUNT(*) policies
FROM DWHRAW.S_SABE_POLIZA pol 
--We do the left join on isolated query about the policy status description
LEFT JOIN (SELECT ('0'+VALOR) STAT, INTMEDIA FROM DWHRAW.S_SABE_CLAVES WHERE DATO='STPOLIZA'GROUP BY VALOR, INTMEDIA, ('0'+VALOR)) cve 
ON cve.STAT=('0'+pol.STPOLIZA) --We use the 0 trick to make the variables equal
GROUP BY pol.STPOLIZA, cve.INTMEDIA, ('0'+pol.STPOLIZA)
ORDER BY STATUS;
/*0	TRAMITE	       6017
1	CALCULADO	  17
2	AUTORIZADO	188
3	EN VIGOR	        1545860
4	CANCELADA  	767156
5	TERMINADA	  311912*/
--With the help of this last fact table we can consult the active policies or flagging the terminated ones

--What if we study the number of valid and not valid policies throught the time in order to see time series of policies
SELECT 
EXTRACT(year FROM pol.FSTAT) "Year",
EXTRACT(month FROM pol.FSTAT) "Month",
COUNT(*) policies
FROM DWHRAW.S_SABE_POLIZA pol 
WHERE pol.STPOLIZA='03'
AND ESTATUS_IND=1
GROUP BY EXTRACT(year FROM pol.FSTAT),
EXTRACT(month FROM pol.FSTAT)
ORDER BY "Year"DESC, "Month" DESC;
--There's something happening, because the fields are not very clear to describe the date ,  is it right to say, how many policies do I have on each month??
--What if we compatre this number with new contracts (emisión)


--But what about the product type, if we want to study this we need group by RAMO/SUBRAMO
SELECT RAMSUBRAMO, COUNT(*) policies FROM DWHRAW.S_SABE_POLIZA GROUP BY RAMSUBRAMO ORDER BY policies DESC;
--It seems there's 332 different RAMSUBRAMO values, let's see what's the description of each one
--To do this is needed the catalog of products
SELECT pol.RAMSUBRAMO, COUNT(*) Policies, cat.NOMBREL Product
FROM DWHRAW.S_SABE_POLIZA pol 
LEFT JOIN DWHRAW.C_SABE_CATRAMOS cat
ON pol.RAMSUBRAMO=cat.RAMSUBRAMO_ID
GROUP BY pol.RAMSUBRAMO, cat.NOMBREL
ORDER BY policies DESC;
--The first thing we can notice is that there's some products using different RAMSUBRAMO keys, for instance we see the top 3
/*00110	    4444776	SEGURO DE ACCIDENTES BANORTE  
00220	    2149904	PROTECCION EXTRA              
00113	    1482768	SEGURO DE ACCIDENTES BANORTE  */
--In the other hand, we are interested to study the behaviour of Health Insurance Not Life Insurance, therefore the goal here is to separate Health and Life Policies
--How can we? Yes, there's a list in plain text that separes the type of every product.

--What if we get inmersed on how much do they have paid in history, we should be able to create an indicator prime/claims
--1,516,323 SELECT COUNT(*) FROM (
SELECT RAMSUBRAMO,  NPOLIZA, SUM(PMAANUAL) acumprime 
FROM DWHRAW.S_SABE_POLIZA GROUP BY RAMSUBRAMO,  NPOLIZA
ORDER BY  acumprime DESC;

--Very related with the product itself is the type of covertures on the policies, but we have to remember that there's a bunch of covertures on every single policy 
--(in fact we might count the number of covertures on every policy)
--The main idea here is understamd that every policy has many insured, and every insured has many covertures, and every coverture has their own catalog, so let's see

--A little example here, we tried to join the policies along insured and covertures, in order to count the covertures
/*NOT FINISHED YET*/
SELECT COUNT(*)
FROM DWHRAW.S_SABE_POLIZA pol 
LEFT JOIN DWHRAW.S_SABE_ASEGURPL aseg ON pol.RAMSUBRAMO = aseg.RAMSUBRAMO AND pol.NPOLIZA = aseg.NPOLIZA;


SELECT catcob.TIPOADIC, catcob.CVCOB_ID, catcob.NOMBREL, COUNT(*) 
    FROM DWHRAW.S_SABE_COBASEPL cob
    LEFT JOIN DWHRAW.S_SABE_ASEGURPL aseg 
        ON aseg.RAMSUBRAMO=cob.RAMSUBRAMO_ID
        AND aseg.NPOLIZA=cob.NPOLIZA_ID
        AND aseg.NASEG=cob.NASEG_ID
        AND aseg.NDEPEND=cob.NDEPEND_ID
        AND aseg.FOLENDOSO=cob.FOLENDOSO_ID
    LEFT JOIN DWHRAW.C_SABE_NORMACOB catcob
        ON catcob.CVCOB_ID=cob.CVCOB_ID
        AND catcob.TIPOADIC=cob.TIPOADIC_ID
GROUP BY catcob.TIPOADIC, catcob.CVCOB_ID, catcob.NOMBREL
        ;
--HAY QUE INTENTAR UN EJERCICIO ALTERNO
--CUANTAS COBERTURAS TIENE UN ASEGURADO
--CUANTOS ASEGURADOS TIENE UNA POLIZA

--How many insured has every policy?
SELECT RAMSUBRAMO,  NPOLIZA, COUNT(NASEG) insured
FROM DWHRAW.S_SABE_ASEGURPL
GROUP BY RAMSUBRAMO, NPOLIZA ORDER BY insured DESC;
--For instance, who is this policy holder 0431207? who has 15,211,865 of insured


--How many sinister a policy has in total in history, let's groupying
--If we make the total count 45,606, tells the number of uniques policies had been injured in history (theorically)
--SELECT COUNT(*) FROM (
--If we link the sinisters to policies we need  NPOLIZA, RAMSUBRAMO
SELECT pol.RAMSUBRAMO,  pol.NPOLIZA, COUNT(sin.NSINIEST) sinisters
FROM DWHRAW.S_SABE_POLIZA pol, DWHRAW.ST_SINI_SINIESTR sin
WHERE pol.RAMSUBRAMO=sin.RAMSUBRAMO
AND pol.NPOLIZA=sin.NPOLIZA
GROUP BY pol.RAMSUBRAMO,  pol.NPOLIZA
ORDER BY sinisters DESC;




/*====================================
              SINISTER
====================================*/

--Number of sinister
--587,825
SELECT COUNT(*) FROM DWHRAW.ST_SINI_SINIESTR;
--Are they unique?
SELECT COUNT(*) FROM(
  SELECT NSINIEST, COUNT(*) SINIESTROS FROM DWHRAW.ST_SINI_SINIESTR GROUP BY NSINIEST HAVING COUNT(*) > 1 ORDER BY SINIESTROS DESC
  );
--No, there are 4,359 cases where a NSINIEST is appearing more than once
--For analysis proposes problably we doesn't  count them because there are just a few
SELECT COUNT(*) FROM DWHRAW.ST_SINI_SINIESTR 
WHERE NSINIEST NOT IN (SELECT NSINIEST FROM DWHRAW.ST_SINI_SINIESTR GROUP BY NSINIEST HAVING COUNT(*) >1);
--579,070
--This way we eliminate all those which has one on more registers, in case we do not which one choose
--The first 5 fields are the first key, then the next 3 set up the second key

--After this we know the total amount of sinisters, now we want to analyze the pattern throutht the time.
SELECT SUBSTR(FECHASIN,2,2) "Year", SUBSTR(FECHASIN,4,2) "Month", COUNT(*) "Sinisters"
FROM DWHRAW.ST_SINI_SINIESTR
GROUP BY SUBSTR(FECHASIN,2,2), SUBSTR(FECHASIN,4,2)
ORDER BY "Year" DESC, "Month" DESC;
--This is perfect, the number of sinisters every single month
--Just for curiosity.. Which has been the worst month?
/*Year Month Sinisters
12	  01	  10,964
13	  01	  7,273
12	  05	  7,159
13	  10	  6,347
13	  03	  6,051*/

--It's assumed that if there's a sinister should have a police, so all the sinisters should belong to policies
SELECT COUNT(*) FROM(
SELECT SIN.RAMSUBRAMO , SIN.NPOLIZA
FROM DWHRAW.ST_SINI_SINIESTR SIN, 
DWHRAW.H_SABE_POLIZA POL
WHERE SIN.RAMSUBRAMO=POL.RAMSUBRAMO
AND SIN.NPOLIZA=POL.NPOLIZA
);
 --471,229, it seems not, is less than 100,000 of difference
--Why this approach does not work?

--On the other hand we can just count uniques policies from sinister table
SELECT COUNT(DISTINCT(NPOLIZA)) POLICIES
FROM DWHRAW.ST_SINI_SINIESTR;
--59,694 Is the number of policies among all 1,618,673 which means the 3.68% of injured policies, Does it make any sense for the business?
--There's some other interesting fields on ST_SINI_SINIESTR table, let's see unique Insured people
SELECT COUNT(DISTINCT(NASEG)) INSURED
FROM DWHRAW.ST_SINI_SINIESTR;
--145,557 Is the number of different insured people in history
--Is very important track this number through the time, and making a series on every month or week 
--//Bussines question: what is the rate insured/polices, in other words how many insured people on every policy on average
--With this fisrt query we have: 0.41,  almost 2 persons for every policy
--//Which are the big contractors among the portfolio that makes the average skewed
--And what about the agents
SELECT COUNT(DISTINCT(NAGENTE)) AGENTS
FROM DWHRAW.ST_SINI_SINIESTR;
--3,066 Is the number of agents that have had injured policies
--//What is the total number of agents, number of agents through the time?, group by ramo
SELECT RAMSUBRAMO, COUNT(DISTINCT(NAGENTE)) agents
FROM DWHRAW.ST_SINI_SINIESTR
GROUP BY RAMSUBRAMO
ORDER BY agents DESC;
/*RAMOSUBRAMO AGENTS
01001	      1090
01052	      1086
01011	      922
01059	      704
01050	      545*/
--Actually this is the top 5, but we have to be clear that this count it is helping to make a gaze about how many different agents do we have on injured policies
--What about the oposite, we can wondering how many sinisters aggregated by agent
SELECT NAGENTE, COUNT(DISTINCT(NSINIEST)) sinisters
FROM DWHRAW.ST_SINI_SINIESTR
GROUP BY NAGENTE
ORDER BY sinisters DESC;
--//Do we have a catalog for agents, we only have to make the difference between them
--So it is a good idea to make an analysis about the table of agents
SELECT TIPO_AGE, COUNT(*) agents FROM DWHRAW.S_CUA_TAGENTESADN
GROUP BY TIPO_AGE ORDER BY agents DESC;
/*TIPO_AGE    AGENTS
01	    21596
06	    2419
02	    1453
03	    66*/
--It seems there's 4 types of agents 
--//We need a catalog of agents type



--Every policy has many covers, and sometimes they change over the time, and all those covers can apply on every sinister, that is why it could be a good idea
--counting the number of covers on every sinister, the maximum is actually 8
SELECT NSINIEST, COUNT(DISTINCT(TIPOADIC)) covers 
FROM DWHRAW.ST_SINI_COBSIN GROUP BY  NSINIEST 
HAVING COUNT(*) > 1
ORDER BY covers;

--Let's call the cataloge of branhces and insurance types, is gonna help also to isolate heatlh insurance only
SELECT LPAD(GUIARAMORAMSUBRAMO,5,'0') as RAMSUBRAMO, DESCRIPCION ramo, DESCRIPCIONLARGA subramo 
FROM DWHRAW.ST_SINI_GUIARAMO;

--At claim level exist a table that shows the payment details, we can use those mounts summarizing to set a new variable to the sinister train set 
--but fisrt we have to analyze the type of payments because of the taxes and currency
--//The currency type of day is difficult to understand, meatime, we gonna use 15 
--there's an aditional assumption, we are excuding all the payments in UDIS currency
SELECT NSINIEST,
SUM(CASE WHEN MONEDA=2 THEN IMPRECMO*15 ELSE 0 END) dolars_claim,
SUM(CASE WHEN MONEDA=1 THEN IMPRECMO+0 ELSE 0 END) pesos_claim,
SUM(CASE WHEN MONEDA=2 THEN IMPRECMO*15 ELSE 0 END) + SUM(CASE WHEN MONEDA=1 THEN IMPRECMO+0 ELSE 0 END) total_claim,
SUM(CASE WHEN MONEDA=2 THEN IMPPAGMO*15 ELSE 0 END) dolars_paid,
SUM(CASE WHEN MONEDA=1 THEN IMPPAGMO+0 ELSE 0 END) pesos_paid,
SUM(CASE WHEN MONEDA=2 THEN IMPPAGMO*15 ELSE 0 END) + SUM(CASE WHEN MONEDA=1 THEN IMPPAGMO+0 ELSE 0 END) total_paid,
SUM(CASE WHEN MONEDA=2 THEN IMPRECMO*15 ELSE 0 END) + SUM(CASE WHEN MONEDA=1 THEN IMPRECMO+0 ELSE 0 END) -
SUM(CASE WHEN MONEDA=2 THEN IMPPAGMO*15 ELSE 0 END) + SUM(CASE WHEN MONEDA=1 THEN IMPPAGMO+0 ELSE 0 END) diff_mount
FROM DWHRAW.ST_SINI_RECLAMD
GROUP BY NSINIEST
ORDER BY diff_mount DESC
;
--The results are so crazy at a fisrt gaze it doesnt make any sense, the top sinister has a total amount of payment 22947594480
--A short version of it
SELECT NSINIEST,
SUM(CASE WHEN MONEDA=2 THEN IMPRECMO*15 ELSE 0 END) + SUM(CASE WHEN MONEDA=1 THEN IMPRECMO+0 ELSE 0 END) total_claim,
SUM(CASE WHEN MONEDA=2 THEN IMPPAGMO*15 ELSE 0 END) + SUM(CASE WHEN MONEDA=1 THEN IMPPAGMO+0 ELSE 0 END) total_paid,
SUM(CASE WHEN MONEDA=2 THEN IMPRECMO*15 ELSE 0 END) + SUM(CASE WHEN MONEDA=1 THEN IMPRECMO+0 ELSE 0 END) -
SUM(CASE WHEN MONEDA=2 THEN IMPPAGMO*15 ELSE 0 END) + SUM(CASE WHEN MONEDA=1 THEN IMPPAGMO+0 ELSE 0 END) diff_mount
FROM DWHRAW.ST_SINI_RECLAMD
GROUP BY NSINIEST
;


/*====================================
        SINISTERS TRAINING DATASET V1
====================================*/
--SELECT COUNT(*) FROM(
SELECT claim.NSINIEST, claim.NPOLIZA, claim.RAMSUBRAMO, 
branch.ramo, branch.subramo,
TO_DATE('20'||SUBSTR(FINIVIG,2,2)||'-'||SUBSTR(FINIVIG,4,2)||'-'||SUBSTR(FINIVIG,6,2), 'YYYY-MM-DD') date_init,
CAST(sinister.AAVIG as INT) INI_ANIO, sinister.CRITEMIS individual,
states.EDO, states.NOM_EDO state_name, city.CIUDAD city, city.NOMBREPOB city_name,
sinister.NASEG, sinister.NOMBTIT,
insured.CVSEXO gender, insured.CVNFUMA, insured.RIESGOCUP, insured.CVEDOCIV, CAST(insured.EDADCALC as INT) age,
TO_DATE('20'||SUBSTR(FECHASIN,2,2)||'-'||SUBSTR(FECHASIN,4,2)||'-'||SUBSTR(FECHASIN,6,2), 'YYYY-MM-DD') sinister_date,
catsin.TIPOSIN, catsin.SIN_DESC sin_decription, DESCACC_1 dis_description,
cover.COVERS, total_claim, total_paid, diff_mount,
COUNT (claim.NRECLAM) claims
FROM DWHRAW.ST_SINI_RECLAM claim 
LEFT JOIN (SELECT LPAD(GUIARAMORAMSUBRAMO,5,'0') as RAMSUBRAMO, DESCRIPCION ramo, DESCRIPCIONLARGA subramo from DWHRAW.st_sini_guiaramo) branch 
ON branch.RAMSUBRAMO=claim.RAMSUBRAMO
LEFT JOIN (SELECT SUBSTR(VALOR ,2,2)as EDO, INTMINIM as NOM_EDO FROM DWHRAW.ST_SINI_CLAVES WHERE DATO='EDO' ) states 
ON claim.EDO=states.EDO
LEFT JOIN DWHRAW.ST_SINI_CIUDADES city 
ON claim.EDO=city.EDO AND claim.CIUDAD=city.CIUDAD 
LEFT JOIN DWHRAW.ST_SINI_SINIESTR sinister 
ON claim.RAMSUBRAMO=sinister.RAMSUBRAMO AND claim.NPOLIZA=sinister.NPOLIZA AND claim.NSINIEST=sinister.NSINIEST
LEFT JOIN DWHRAW.ST_SINI_ASEGSIN insured 
ON insured.NSINIEST=sinister.NSINIEST AND insured.NPOLIZA=sinister.NPOLIZA AND insured.RAMSUBRAMO=sinister.RAMSUBRAMO
LEFT JOIN (SELECT VALOR as TIPOSIN, INTMEDIA as SIN_DESC FROM DWHRAW.ST_SINI_CLAVES WHERE DATO='TIPOSIN' ) catsin 
ON sinister.TIPOSIN=catsin.TIPOSIN
LEFT JOIN (SELECT NSINIEST, COUNT(DISTINCT(TIPOADIC)) COVERS FROM DWHRAW.ST_SINI_COBSIN GROUP BY  NSINIEST) cover
ON sinister.NSINIEST=cover.NSINIEST
LEFT JOIN (SELECT NSINIEST,
SUM(CASE WHEN MONEDA=2 THEN IMPRECMO*15 ELSE 0 END) + SUM(CASE WHEN MONEDA=1 THEN IMPRECMO+0 ELSE 0 END) total_claim,
SUM(CASE WHEN MONEDA=2 THEN IMPPAGMO*15 ELSE 0 END) + SUM(CASE WHEN MONEDA=1 THEN IMPPAGMO+0 ELSE 0 END) total_paid,
SUM(CASE WHEN MONEDA=2 THEN IMPRECMO*15 ELSE 0 END) + SUM(CASE WHEN MONEDA=1 THEN IMPRECMO+0 ELSE 0 END) -
SUM(CASE WHEN MONEDA=2 THEN IMPPAGMO*15 ELSE 0 END) + SUM(CASE WHEN MONEDA=1 THEN IMPPAGMO+0 ELSE 0 END) diff_mount
FROM DWHRAW.ST_SINI_RECLAMD
GROUP BY NSINIEST) amount
ON sinister.NSINIEST=amount.NSINIEST
WHERE sinister.NSINIEST NOT IN (SELECT NSINIEST FROM DWHRAW.ST_SINI_SINIESTR GROUP BY NSINIEST HAVING COUNT(*) >1)  --excluding duplicate sinisters
AND branch.RAMO <> 'VIDA'
AND CAST(SUBSTR(FECHASIN,2,2) AS INT) BETWEEN 0 AND 17
AND CAST(SUBSTR(FECHASIN,4,2) AS INT) BETWEEN 1 AND 12
AND CAST(SUBSTR(FECHASIN,6,2) AS INT) BETWEEN 1 AND 30
AND CAST(SUBSTR(FINIVIG,2,2) AS INT) BETWEEN 0 AND 17
AND CAST(SUBSTR(FINIVIG,4,2) AS INT) BETWEEN 1 AND 12
AND CAST(SUBSTR(FINIVIG,6,2) AS INT) BETWEEN 1 AND 30
GROUP BY  claim.NSINIEST, claim.NPOLIZA, claim.RAMSUBRAMO, branch.ramo, branch.subramo,
TO_DATE('20'||SUBSTR(FINIVIG,2,2)||'-'||SUBSTR(FINIVIG,4,2)||'-'||SUBSTR(FINIVIG,6,2), 'YYYY-MM-DD'),
CAST(sinister.AAVIG as INT), sinister.CRITEMIS, states.EDO, states.NOM_EDO, city.CIUDAD, city.NOMBREPOB,
sinister.NASEG, sinister.NOMBTIT, insured.CVSEXO, insured.CVNFUMA, insured.RIESGOCUP, insured.CVEDOCIV, 
CAST(insured.EDADCALC as INT), TO_DATE('20'||SUBSTR(FECHASIN,2,2)||'-'||SUBSTR(FECHASIN,4,2)||'-'||SUBSTR(FECHASIN,6,2), 'YYYY-MM-DD'),
catsin.TIPOSIN, catsin.SIN_DESC, DESCACC_1, cover.COVERS, total_claim, total_paid, diff_mount
;
--ORDER BY claims DESC;



/*====================================
              CLAIMS
====================================*/

--Number of claims
--1,498,749
SELECT COUNT(*) FROM DWHRAW.ST_SINI_RECLAM;
--Are there uniques?
--This is the minimum aggregation that matters, most of the studies are based on claims
SELECT COUNT(*) FROM (
SELECT DISTINCT NRECLAM, NSINIEST FROM DWHRAW.ST_SINI_RECLAM
);
--Yes, Is compound with 2 keys that makes one key, 
--In total, there's 12 variables for 3 keys

--Reproducing the same aproach as we made in sinisters, we want to find out the the behaviour of claims throught the time
SELECT 
TO_DATE('20'||SUBSTR(FECHAREC,2,2)||'-'||SUBSTR(FECHAREC,4,2)||'-'||SUBSTR(FECHAREC,6,2), 'YYYY-MM-DD') "Date",
  COUNT(*) "Claims"
FROM DWHRAW.ST_SINI_RECLAM
WHERE CAST(SUBSTR(FECHAREC,2,2) AS INT) BETWEEN 0 AND 17
AND CAST(SUBSTR(FECHAREC,4,2) AS INT) BETWEEN 1 AND 12
AND CAST(SUBSTR(FECHAREC,6,2) AS INT) BETWEEN 1 AND 30
GROUP BY 
TO_DATE('20'||SUBSTR(FECHAREC,2,2)||'-'||SUBSTR(FECHAREC,4,2)||'-'||SUBSTR(FECHAREC,6,2), 'YYYY-MM-DD')
ORDER BY "Date" DESC;
--//DATASET READY 
--We should notice that the frecuency of events it depends of how many policies and insured people we have.
--So throught the time the number of claims and sinisters should be proportional to the business growing, otherwise it is an outlier

--Very interesting to see the average time spent at the hospital
--SELECT  TRUNC(AVG("Days"),2) "Mean" 
--FROM (
SELECT 
TO_DATE('20'||SUBSTR(FINGHOSP,2,2)||'-'||SUBSTR(FINGHOSP,4,2)||'-'||SUBSTR(FINGHOSP,6,2), 'YYYY-MM-DD') "In",
TO_DATE('20'||SUBSTR(FEGRHOSP,2,2)||'-'||SUBSTR(FEGRHOSP,4,2)||'-'||SUBSTR(FEGRHOSP,6,2), 'YYYY-MM-DD') "Out",
TO_DATE('20'||SUBSTR(FEGRHOSP,2,2)||'-'||SUBSTR(FEGRHOSP,4,2)||'-'||SUBSTR(FEGRHOSP,6,2), 'YYYY-MM-DD') -
TO_DATE('20'||SUBSTR(FINGHOSP,2,2)||'-'||SUBSTR(FINGHOSP,4,2)||'-'||SUBSTR(FINGHOSP,6,2), 'YYYY-MM-DD') "Days"
FROM DWHRAW.ST_SINI_RECLAM
WHERE CAST(SUBSTR(FEGRHOSP,2,2) AS INT) BETWEEN 0 AND 17
AND CAST(SUBSTR(FEGRHOSP,4,2) AS INT) BETWEEN 1 AND 12
AND CAST(SUBSTR(FEGRHOSP,6,2) AS INT) BETWEEN 1 AND 30
AND CAST(SUBSTR(FINGHOSP,2,2) AS INT) BETWEEN 0 AND 17
AND CAST(SUBSTR(FINGHOSP,4,2) AS INT) BETWEEN 1 AND 12
AND CAST(SUBSTR(FINGHOSP,6,2) AS INT) BETWEEN 1 AND 30
AND 
TO_DATE('20'||SUBSTR(FINGHOSP,2,2)||'-'||SUBSTR(FINGHOSP,4,2)||'-'||SUBSTR(FINGHOSP,6,2), 'YYYY-MM-DD') <>
TO_DATE('20'||SUBSTR(FEGRHOSP,2,2)||'-'||SUBSTR(FEGRHOSP,4,2)||'-'||SUBSTR(FEGRHOSP,6,2), 'YYYY-MM-DD')
;
--//DATASET READY TO ANALYSE
--4.55
--The first assumption we made it was that all those values with 0 days of hospitalization it means that actually there's  no hospitalization
--There's many issues here, first of all, the dates are written in a string format, with some strange rules, so we have to cast into a proper date 
--Then there is a problem with some months that do not allow to integrate 31 days
--We are making the query all over the table of claims, but we have to remember that a claim is not necesary an hospitalization, thus we ought to filter it out 
--To achieve that we need to be sure the assumption we made is true
--Then we can build aggregation by physician, office, hospital, and so on.

--There's an interesting thing about doctors, and labs studies. There are cases in claims that individuals has second opinion, also on blood tests for instance.
--Because of this, we want to count the percentage of the people with more than 1 doctor opinion to evaluate if is a good idea to include more that one field


--This table has a relation with sinister from 1 to N, and we ordered by number of claims
SELECT NSINIEST, COUNT(NRECLAM) claims
FROM DWHRAW.ST_SINI_RECLAM 
GROUP BY NSINIEST ORDER BY claims DESC;
--There's such a sinisters with many claims, the top 4 are higher that 200 claims each
--//We have to studie the types of claims and types of sinisters
SELECT si.NSINIEST, si.RAMSUBRAMO, 
si.EDO, si.CIUDAD, ci.NOMBREPOB, 
COUNT(NRECLAM) claims
FROM DWHRAW.ST_SINI_RECLAM si LEFT JOIN DWHRAW.ST_SINI_CIUDADES ci
ON si.EDO=ci.EDO AND si.CIUDAD=ci.CIUDAD 
GROUP BY si.NSINIEST, si.RAMSUBRAMO, si.EDO, si.CIUDAD, ci.NOMBREPOB ORDER BY claims DESC;

--This is a similar exercice, but with the difference that we measure the payment not the number
SELECT NSINIEST, SUM(PAGOTOTAL) payment
FROM DWHRAW.ST_SINI_RECLAM 
GROUP BY NSINIEST ORDER BY payment DESC;
--We notice that the payment variable does not have much sense
--//Business question: que es litigio?

--Currently we do not know the variety of the claims, a claim correspond an event, and an event on this matter involves a diseasse or an accident
SELECT * FROM DWHRAW.ST_SINI_CATPADOI;
--This is the catalog of diseasse
--CAPPADEM
--GPADEM
--SGPADEM
--The keys
--We should merge this one as well
SELECT * FROM DWHRAW.ST_SINI_ASEGSIN;


DWHRAW.ST_SINI_BENEFPAGOS

--Detalle ubicación de personas
SELECT SOURCE_CD, COUNT(*) FROM DWHHOM.SAT_SEPOMEX GROUP BY SOURCE_CD;





/*====================================
              PARTICIPANT
====================================*/

--By now we do not know information about the participants around a policy
--The main goal to create a dataset of participants a relations is to build a netwroking graph in order to understand if there is communities involved
--First of all let's count 30,015,274 (Is this correct?)
SELECT COUNT(*) FROM DWHHOM.SAT_PERSONA WHERE SOURCE_CD = 'SABE';
--In fact there's not only unique persons 29,634,157
SELECT COUNT(DISTINCT(PERSONA_CD)) FROM DWHHOM.SAT_PERSONA WHERE SOURCE_CD = 'SABE';

--Is this the gender?
SELECT TIPO_PARTICIPANTE_CD, COUNT(DISTINCT(PERSONA_CD)) participants 
FROM DWHHOM.SAT_PERSONA WHERE SOURCE_CD = 'SABE'
GROUP BY TIPO_PARTICIPANTE_CD ORDER BY participants DESC;
/*F	    26982771
M	    2672741*/
