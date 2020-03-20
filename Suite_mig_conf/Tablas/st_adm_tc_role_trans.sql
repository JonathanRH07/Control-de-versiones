CREATE TABLE `st_adm_tc_role_trans` (
  `id_role` int(11) NOT NULL,
  `nombre_role` varchar(50) DEFAULT NULL,
  `descripcion` varchar(250) DEFAULT NULL,
  `id_idioma` int(11) DEFAULT NULL,
  KEY `fk_st_adm_idioma_role_idx` (`id_idioma`),
  KEY `fk_st_adm_role_role_idx` (`id_role`),
  CONSTRAINT `fk_st_adm_idioma_role` FOREIGN KEY (`id_idioma`) REFERENCES `st_adm_tc_idioma` (`id_idioma`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_st_adm_role_role` FOREIGN KEY (`id_role`) REFERENCES `st_adm_tc_role` (`id_role`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;
