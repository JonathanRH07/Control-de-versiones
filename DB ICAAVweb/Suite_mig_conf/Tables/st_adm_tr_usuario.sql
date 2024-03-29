CREATE TABLE `st_adm_tr_usuario` (
  `id_usuario` int(11) NOT NULL AUTO_INCREMENT,
  `id_grupo_empresa` int(11) NOT NULL,
  `id_role` int(11) NOT NULL,
  `id_estilo_empresa` int(11) DEFAULT '1',
  `id_idioma` int(11) DEFAULT NULL,
  `usuario` varchar(100) NOT NULL,
  `password_usuario` varchar(256) DEFAULT NULL,
  `nombre_usuario` varchar(45) DEFAULT NULL,
  `paterno_usuario` varchar(45) DEFAULT NULL,
  `materno_usuario` varchar(45) DEFAULT NULL,
  `correo` char(50) DEFAULT NULL,
  `inicio_sesion` tinyint(1) DEFAULT '0',
  `primer_ingreso` int(11) DEFAULT '1',
  `intentos_ingreso` tinyint(1) DEFAULT '0',
  `fecha_desbloqueo` datetime DEFAULT NULL,
  `hora_acceso_ini` time DEFAULT NULL,
  `hora_acceso_fin` time DEFAULT NULL,
  `acceso_ip` tinyint(1) DEFAULT '0',
  `acceso_horario` tinyint(1) DEFAULT '0',
  `fecha_ult_conexion` datetime DEFAULT NULL,
  `estatus_usuario` enum('ACTIVO','INACTIVO','SLICENCIA','FALTAPAGO') DEFAULT 'ACTIVO',
  `registra_usuario` varchar(100) DEFAULT NULL,
  `tipo_usuario` tinyint(4) DEFAULT '1' COMMENT '1 = Usuario Sistema, 2 = Usuario soporte',
  `fecha_registro_usuario` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `id_usuario_mod` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `usuario_UNIQUE` (`usuario`) USING BTREE,
  UNIQUE KEY `correo_UNIQUE` (`correo`) USING BTREE,
  KEY `fk_st_adm_tr_usuario_st_adm_tr_grupo_idx` (`id_grupo_empresa`) USING BTREE,
  KEY `fk_st_adm_tr_usuario_st_adm_tc_role_idx` (`id_role`) USING BTREE,
  KEY `idx_idioma` (`id_idioma`) USING BTREE,
  KEY `fk_usuario_estilo_idx` (`id_estilo_empresa`),
  CONSTRAINT `fk_adm_usuario_idioma` FOREIGN KEY (`id_idioma`) REFERENCES `st_adm_tc_idioma` (`id_idioma`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_usuario_estilo` FOREIGN KEY (`id_estilo_empresa`) REFERENCES `st_adm_tr_estilo_empresa` (`id_estilo_empresa`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `st_adm_tr_usuario_ibfk_1` FOREIGN KEY (`id_role`) REFERENCES `st_adm_tc_role` (`id_role`) ON UPDATE CASCADE,
  CONSTRAINT `st_adm_tr_usuario_ibfk_2` FOREIGN KEY (`id_grupo_empresa`) REFERENCES `st_adm_tr_grupo_empresa` (`id_grupo_empresa`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1527 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;
