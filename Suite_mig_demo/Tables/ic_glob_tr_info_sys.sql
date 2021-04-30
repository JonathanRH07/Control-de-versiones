CREATE TABLE `ic_glob_tr_info_sys` (
  `id_grupo_empresa` int(11) NOT NULL AUTO_INCREMENT,
  `conta` char(1) DEFAULT NULL,
  `markup` char(1) DEFAULT NULL,
  `ine` char(1) DEFAULT NULL,
  `consolidada` char(1) DEFAULT NULL,
  `remarks_especiales` char(1) DEFAULT NULL,
  `cambia_sucursal` char(1) DEFAULT NULL,
  PRIMARY KEY (`id_grupo_empresa`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;
