CREATE TABLE `ct_glob_tc_tipo_auto` (
  `id_tipo_auto` int(11) NOT NULL AUTO_INCREMENT,
  `tipo_auto` varchar(45) DEFAULT NULL,
  `estatus` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_tipo_auto`),
  KEY `tipo_auto` (`tipo_auto`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
