CREATE TABLE `ic_cat_tr_proveedor_conf` (
  `id_proveedor_conf` int(11) NOT NULL AUTO_INCREMENT,
  `id_proveedor` int(11) DEFAULT NULL,
  `id_grupo_empresa` int(11) DEFAULT NULL,
  `inventario` char(1) DEFAULT NULL,
  `num_dias_credito` int(11) DEFAULT NULL,
  `ctrl_comisiones` char(1) DEFAULT NULL,
  `no_contab_comision` char(1) DEFAULT NULL,
  `estatus` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_proveedor_conf`),
  KEY `fk_proveedor_idx` (`id_proveedor`) USING BTREE,
  KEY `fk_proveedor_conf_usuario_idx` (`id_usuario`) USING BTREE,
  KEY `fk_proveedor_conf_grupo_empre_idx` (`id_grupo_empresa`) USING BTREE,
  CONSTRAINT `fk_proveedor_conf` FOREIGN KEY (`id_proveedor`) REFERENCES `ic_cat_tr_proveedor` (`id_proveedor`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_proveedor_conf_grupo_empre` FOREIGN KEY (`id_grupo_empresa`) REFERENCES `suite_mig_conf`.`st_adm_tr_grupo_empresa` (`id_grupo_empresa`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_proveedor_conf_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `suite_mig_conf`.`st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2327 DEFAULT CHARSET=utf8;
