CREATE TABLE `ic_glob_tr_ctrl_cambios` (
  `id_ctrl_cambios` int(11) NOT NULL AUTO_INCREMENT,
  `id_ctrl_cambios_cat` int(11) NOT NULL,
  `id_registro` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `tipo_accion` enum('ALTA','ACTIVO','INACTIVO','CAMBIO','CANCELACION','UPDATE') NOT NULL,
  `fecha_hora` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `info_json` text,
  PRIMARY KEY (`id_ctrl_cambios`),
  KEY `fk_catalogos_ctrl_idx` (`id_ctrl_cambios_cat`),
  KEY `fk_ctrl_cambios_usuario_idx` (`id_usuario`),
  KEY `idx_registro` (`id_registro`),
  CONSTRAINT `fk_ctrl_cambios_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `suite_mig_conf`.`st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=121849 DEFAULT CHARSET=utf8;
