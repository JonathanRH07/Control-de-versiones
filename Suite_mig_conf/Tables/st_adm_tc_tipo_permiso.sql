CREATE TABLE `st_adm_tc_tipo_permiso` (
  `id_tipo_permiso` int(11) NOT NULL AUTO_INCREMENT,
  `nom_tipo_permiso` varchar(20) DEFAULT NULL,
  `traduccion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_tipo_permiso`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;
