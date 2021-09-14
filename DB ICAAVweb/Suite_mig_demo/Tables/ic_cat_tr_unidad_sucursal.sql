CREATE TABLE `ic_cat_tr_unidad_sucursal` (
  `id_unidad_sucursal` int(11) NOT NULL AUTO_INCREMENT,
  `id_sucursal` int(11) NOT NULL,
  `id_unidad_negocio` int(11) NOT NULL,
  `estatus_unidad_sucursal` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_mod_unidad_sucursal` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_unidad_sucursal`),
  KEY `fk_ic_cat_tr_unidad_sucursal_ic_cat_tr_sucursal_idx` (`id_sucursal`),
  KEY `fk_ic_cat_tr_unidad_sucursal_ic_cat_tc_unidad_negocio_idx` (`id_unidad_negocio`),
  CONSTRAINT `fk_ic_cat_tr_unidad_sucursal_ic_cat_tc_unidad_negocio` FOREIGN KEY (`id_unidad_negocio`) REFERENCES `ic_cat_tc_unidad_negocio` (`id_unidad_negocio`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_ic_cat_tr_unidad_sucursal_ic_cat_tr_sucursal` FOREIGN KEY (`id_sucursal`) REFERENCES `ic_cat_tr_sucursal` (`id_sucursal`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
