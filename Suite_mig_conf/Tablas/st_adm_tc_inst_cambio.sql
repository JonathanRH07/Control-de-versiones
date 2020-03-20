CREATE TABLE `st_adm_tc_inst_cambio` (
  `id_inst_cambio` int(11) NOT NULL AUTO_INCREMENT,
  `id_pais` int(11) DEFAULT NULL,
  `nombre_inst_cambio` varchar(100) DEFAULT NULL,
  `dolar` decimal(17,4) DEFAULT NULL,
  `euro` decimal(17,4) DEFAULT NULL,
  `peso_colombiano` decimal(17,4) DEFAULT NULL,
  PRIMARY KEY (`id_inst_cambio`),
  KEY `idx_id_pais` (`id_pais`) USING BTREE,
  CONSTRAINT `fk_id_pais` FOREIGN KEY (`id_pais`) REFERENCES `suite_mig_demo`.`ct_glob_tc_pais` (`id_pais`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
