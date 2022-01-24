CREATE TABLE `st_adm_tr_permiso_emp_modulo` (
  `id_permiso_emp_modulo` int(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` int(11) NOT NULL,
  `id_modulo` int(11) NOT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_vencimiento` date DEFAULT NULL,
  PRIMARY KEY (`id_permiso_emp_modulo`),
  KEY `fk_st_adm_tr_permiso_emp_modulo_st_adm_tr_empresa1_idx` (`id_empresa`) USING BTREE,
  KEY `fk_st_adm_tr_permiso_emp_modulo_st_adm_tc_modulo1_idx` (`id_modulo`) USING BTREE,
  CONSTRAINT `fk_st_adm_tr_permiso_emp_modulo_st_adm_tc_modulo1` FOREIGN KEY (`id_modulo`) REFERENCES `st_adm_tc_modulo` (`id_modulo`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_st_adm_tr_permiso_emp_modulo_st_adm_tr_empresa1` FOREIGN KEY (`id_empresa`) REFERENCES `st_adm_tr_empresa` (`id_empresa`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=186 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
