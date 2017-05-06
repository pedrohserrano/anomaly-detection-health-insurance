/*========================================
       Póliza - Póliza
=========================================*/

--Relaciona el historial de las pólizas con los asegurados de la misma

SELECT /*+ ALL_ROWS */ 
--/*+ PARALLEL(LPPR, 4) */ 
  HP.llave_poliza_01_cd, --ramosubramo
  HP.llave_poliza_02_cd, --npoliza
  SEP.estatus_poliza_desc,
  SDP.numero_poliza_id,
  SDP.emision_dt,
  SDP.vig_ini_dt,
  SDP.vig_fin_dt,
  SPER.rfc_calc_cd,
  STP.tipo_participante_desc,
  SPER.nombre_completo_desc,
  CASE WHEN SPER.nacimiento_calc_dt IS NULL THEN SPER.nacimiento_dt ELSE NULL END nac_dt,
  CASE WHEN SPER.genero_calc_id IS NULL THEN SPER.genero_id ELSE NULL END nac_dt,
  SPER.sic_cd,
  SEP.estatus_poliza_desc,
  SR.rol_desc,
  SD.cd_pob_desc,
  SD.mpo_del_desc,
  SD.zona_post_desc,
  SD.pais_dir_desc
FROM DWHHOM.LINK_PARTICIPANTE_ROL LPR,
  DWHHOM.LINK_POLIZA_PART_ROL LPPR,
  DWHHOM.LINK_POLIZA_ESTATUS LPE,
  DWHHOM.LINK_PARTICIPANTE_TIPO LPT,
  DWHHOM.HUB_POLIZA HP,
  DWHHOM.HUB_ESTATUS_POLIZA HEP,
  DWHHOM.SAT_DETALLE_POLIZA SDP,
  DWHHOM.HUB_PARTICIPANTE HPART,
  DWHHOM.SAT_PERSONA SPER,
  DWHHOM.SAT_ESTATUS_POLIZA SEP,
  DWHHOM.HUB_ROL HR,
  DWHHOM.SAT_ROL SR,
  DWHHOM.HUB_MECANISMO_CONTACTO HMC,
  DWHHOM.LINK_PART_MECANISMO_CONT_ROL LPMCR,
  DWHHOM.SAT_DIRECCION SD,
  DWHHOM.SAT_TIPO_PARTICIPANTE STP
--
WHERE 1=1
AND LPR.lsid_participante_rol   = LPPR.lsid_participante_rol
AND HP.hsid_poliza              = LPPR.hsid_poliza
AND SDP.hsid_poliza             = HP.hsid_poliza
AND LPE.hsid_poliza             = LPPR.hsid_poliza
AND HEP.hsid_estatus_poliza     = LPE.hsid_estatus_poliza
ANd SEP.hsid_estatus_poliza     = HEP.hsid_estatus_poliza
AND HPART.hsid_participante     = LPR.hsid_participante 
AND SPER.Hsid_Participante      = HPART.hsid_participante
AND HR.hsid_rol                 = LPR.hsid_rol
AND SR.hsid_rol                 = HR.hsid_rol  
--
AND LPT.hsid_participante       = LPR.hsid_participante 
AND STP.hsid_tipo_participante  = LPT.hsid_tipo_participante
--
AND LPMCR.lsid_participante_rol (+) = LPPR.lsid_participante_rol
AND HMC.hsid_mecanismo_contacto (+) = LPMCR.hsid_mecanismo_contacto
AND SD.hsid_mecanismo_contacto  (+) = HMC.hsid_mecanismo_contacto
AND HMC.tipo_mecanismo_cd       (+) = 'DIRE'
--
AND LPPR.source_cd = 'SABE'
ANd LPE.source_cd = 'SABE'
AND SPER.source_cd = 'SABE'
--
AND LPPR.estatus_ind            = 1
AND LPE.estatus_ind             = 1
AND SDP.estatus_ind             = 1
AND SEP.estatus_ind             = 1
AND SPER.estatus_ind            = 1
AND SD.estatus_ind              = 1
;

