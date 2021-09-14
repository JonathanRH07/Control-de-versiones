CREATE TABLE `st_adm_tc_tutoriales` (
  `id_tutorial` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_video` varchar(255) NOT NULL,
  `enlace_video` text NOT NULL,
  `modulo` varchar(60) NOT NULL,
  `fecha_publicacion` datetime NOT NULL,
  `descripcion` longtext,
  `estatus` enum('ACTIVO','INACTIVO') NOT NULL,
  PRIMARY KEY (`id_tutorial`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=latin1;
