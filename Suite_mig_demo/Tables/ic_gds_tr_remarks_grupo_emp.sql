CREATE TABLE `ic_gds_tr_remarks_grupo_emp` (
  `id_remarks_grupo_emp` int(11) NOT NULL AUTO_INCREMENT,
  `id_grupo_empresa` int(11) DEFAULT NULL,
  `cve_gds` char(2) DEFAULT NULL,
  `remark` varchar(10) DEFAULT NULL,
  `valor_remark` varchar(30) DEFAULT NULL,
  `obligatorio` char(1) DEFAULT 'N',
  `id_stat` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `item` int(1) DEFAULT NULL,
  `separador` char(1) DEFAULT NULL,
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_usuario` int(11) NOT NULL,
  PRIMARY KEY (`id_remarks_grupo_emp`),
  KEY `fk_remarks_grupo_empresa_idx` (`id_grupo_empresa`),
  KEY `fk_remarks_grupo_emp_usuario_idx` (`id_usuario`),
  CONSTRAINT `fk_remarks_grupo_emp_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `suite_mig_conf`.`st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_remarks_grupo_empresa` FOREIGN KEY (`id_grupo_empresa`) REFERENCES `suite_mig_conf`.`st_adm_tr_grupo_empresa` (`id_grupo_empresa`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8;
