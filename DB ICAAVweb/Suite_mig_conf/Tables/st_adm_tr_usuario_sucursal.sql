CREATE TABLE `st_adm_tr_usuario_sucursal` (
  `id_usuario_sucursal` int(11) NOT NULL AUTO_INCREMENT,
  `id_usuario` int(11) NOT NULL,
  `id_sucursal` int(11) DEFAULT NULL,
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_usuario_mod` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_usuario_sucursal`),
  KEY `fk_st_adm_tr_usuario_sucursal_st_adm_tr_usuario1_idx` (`id_usuario`) USING BTREE,
  KEY `idx_id_sucursal` (`id_sucursal`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1218 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
