CREATE TABLE `ic_gds_tr_analisis` (
  `id_gds_analisis` int(11) NOT NULL AUTO_INCREMENT,
  `id_gds_general` int(11) DEFAULT NULL,
  `no_analisis` char(3) DEFAULT NULL,
  `descripcion` varchar(50) DEFAULT NULL,
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_gds_analisis`),
  KEY `fk_analisis_gds_general_idx` (`id_gds_general`),
  KEY `fk_analisis_usuario_idx` (`id_usuario`),
  CONSTRAINT `fk_analisis_gds_general` FOREIGN KEY (`id_gds_general`) REFERENCES `ic_gds_tr_general` (`id_gds_generall`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_analisis_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `suite_mig_conf`.`st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1702 DEFAULT CHARSET=latin1;
