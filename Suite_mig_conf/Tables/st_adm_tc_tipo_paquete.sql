CREATE TABLE `st_adm_tc_tipo_paquete` (
  `id_tipo_paquete` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(55) NOT NULL,
  `descripcion` text,
  `espacio_almacenamiento` decimal(16,2) DEFAULT NULL COMMENT 'Espacion de almacenamiento expresado en gigabyte',
  `numero_folios` int(11) DEFAULT NULL,
  `numero_usuarios` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_tipo_paquete`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
