CREATE TABLE `st_adm_tc_tipo_paquete` (
  `id_tipo_paquete` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(55) NOT NULL,
  `descripcion` text,
  `espacio_almacenamiento` decimal(16,2) DEFAULT NULL COMMENT 'Espacion de almacenamiento expresado en gigabyte',
  `numero_folios` int(11) DEFAULT NULL,
  `numero_usuarios` int(11) DEFAULT NULL,
  `id_subsistema` int(11) DEFAULT '1',
  PRIMARY KEY (`id_tipo_paquete`),
  KEY `fk_tipo_paquete_sistema_idx` (`id_subsistema`),
  CONSTRAINT `fk_tipo_paquete_sistema` FOREIGN KEY (`id_subsistema`) REFERENCES `st_adm_tr_sistema` (`id_sistema`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
