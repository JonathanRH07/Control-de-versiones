CREATE TABLE `ic_glob_tr_inventario_boletos` (
  `id_inventario_boletos` int(11) NOT NULL AUTO_INCREMENT,
  `id_grupo_empresa` int(11) DEFAULT NULL,
  `id_proveedor` int(11) DEFAULT NULL,
  `id_sucursal` int(11) DEFAULT NULL,
  `consolidado` char(1) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `bol_inicial` char(15) DEFAULT NULL,
  `bol_final` char(15) DEFAULT NULL,
  `descripcion` varchar(80) DEFAULT NULL,
  `estatus` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_inventario_boletos`),
  KEY `fk_inventario_boletos_usuario_idx` (`id_usuario`),
  CONSTRAINT `fk_inventario_boletos_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `suite_mig_conf`.`st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=198 DEFAULT CHARSET=utf8;
