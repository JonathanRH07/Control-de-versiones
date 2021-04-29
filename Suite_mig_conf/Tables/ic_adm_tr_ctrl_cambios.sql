CREATE TABLE `ic_adm_tr_ctrl_cambios` (
  `id_ctrl_cambios` int(11) NOT NULL AUTO_INCREMENT,
  `id_ctrl_cambios_cat` int(11) NOT NULL,
  `id_registro` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `tipo_accion` enum('ALTA','ACTIVO','INACTIVO','CAMBIO','CANCELACION','UPDATE') NOT NULL,
  `fecha_hora` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `info_json` text,
  PRIMARY KEY (`id_ctrl_cambios`),
  KEY `idx_registro` (`id_registro`) USING BTREE,
  KEY `idx_usuario` (`id_usuario`) USING BTREE,
  KEY `fk_catalogos_ctrl_idx` (`id_ctrl_cambios_cat`) USING BTREE,
  KEY `fk_ctrl_cambios_usuario_idx` (`id_usuario`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=20617 DEFAULT CHARSET=utf8;
