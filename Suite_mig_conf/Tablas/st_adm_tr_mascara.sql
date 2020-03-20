CREATE TABLE `st_adm_tr_mascara` (
  `id_mascara` int(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` int(11) DEFAULT NULL,
  `id_tipo_mascara` int(11) DEFAULT NULL,
  `nivel1` int(11) DEFAULT NULL,
  `nivel2` int(11) DEFAULT NULL,
  `nivel3` int(11) DEFAULT NULL,
  `nivel4` int(11) DEFAULT NULL,
  `nivel5` int(11) DEFAULT NULL,
  `nivel6` int(11) DEFAULT NULL,
  `nivel7` int(11) DEFAULT NULL,
  `nivel8` int(11) DEFAULT NULL,
  `nivel9` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_mascara`),
  KEY `fk_tipo_mascara_idx` (`id_tipo_mascara`) USING BTREE,
  KEY `fk_emp_mascara_idx` (`id_empresa`) USING BTREE,
  CONSTRAINT `fk_emp_mascara` FOREIGN KEY (`id_empresa`) REFERENCES `st_adm_tr_empresa` (`id_empresa`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_tipo_mascara` FOREIGN KEY (`id_tipo_mascara`) REFERENCES `st_adm_tc_tipo_mascara` (`id_tipo_mascara`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
