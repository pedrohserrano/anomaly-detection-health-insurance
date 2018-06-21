SELECT /*+ ALL_ROWS */ 
--/*+ PARALLEL(LPPR, 4) */ 
  HP.llave_poliza_01_cd,
  HP.llave_poliza_02_cd,
  HP.llave_poliza_03_cd,
  HP.llave_poliza_04_cd,
  HP.llave_poliza_05_cd,
  SEP.estatus_poliza_desc,
  SDP.numero_poliza_id,
  SDP.emision_dt,
  SDP.vig_ini_dt,
  SDP.vig_fin_dt,
  SPER.rfc_cd,
  SPER.rfc_calc_cd,
  STP.tipo_participante_desc,
  SPER.nombre_completo_desc,
  SPER.nacimiento_dt,
  SPER.nacimiento_calc_dt,
  SPER.genero_id,
  SPER.genero_calc_id,
  SPER.sic_cd,
  SPER.curp_desc,
  SPER.nss_desc,
  SR.rol_desc,
  HP.source_cd,
  SD.calle_desc,
  SD.num_int_desc,
  SD.col_dir_desc,
  SD.cd_pob_desc,
  SD.mpo_del_desc,
  SD.zona_post_desc,
  SD.pais_dir_desc,
  SDC.correo_electronico_desc
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
  --
  DWHHOM.LINK_PART_MECANISMO_CONT_ROL LPMCRC,
  DWHHOM.HUB_MECANISMO_CONTACTO HMCC,
  --
  DWHHOM.SAT_DIRECCION SD,
  DWHHOM.SAT_DIRECCION_CORREO SDC,
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
AND LPMCRC.lsid_participante_rol (+) = LPPR.lsid_participante_rol
AND HMCC.hsid_mecanismo_contacto (+) = LPMCRC.hsid_mecanismo_contacto
AND SDC.hsid_mecanismo_contacto  (+) = HMCC.hsid_mecanismo_contacto
AND HMCC.tipo_mecanismo_cd       (+) = 'MAIL'
--
AND LPPR.source_cd = 'ACSEL'
ANd LPE.source_cd = 'ACSEL'
AND SPER.source_cd = 'ACSEL'
--
AND LPPR.estatus_ind            = 1
AND LPE.estatus_ind             = 1
AND SDP.estatus_ind             = 1
AND SEP.estatus_ind             = 1
AND SPER.estatus_ind            = 1
AND SD.estatus_ind              = 1
AND SDC.estatus_ind             = 1
AND ROWNUM < 100
;
