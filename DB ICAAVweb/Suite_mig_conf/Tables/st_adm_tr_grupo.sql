CREATE TABLE `st_adm_tr_grupo` (
  `id_grupo` int(11) NOT NULL AUTO_INCREMENT,
  `nom_grupo` varchar(45) DEFAULT NULL,
  `no_licencias` int(11) DEFAULT '0',
  `estatus_grupo` tinyint(1) DEFAULT '1',
  `fecha_mod_grupo` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_grupo`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;
