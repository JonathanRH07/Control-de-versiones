CREATE TABLE `sat_paises` (
  `c_Pais` char(3) NOT NULL DEFAULT '',
  `descripcion` varchar(255) DEFAULT NULL,
  `formato_cp` varchar(100) DEFAULT NULL,
  `formato_reg_trib` varchar(100) DEFAULT NULL,
  `validacion_reg_trib` varchar(100) DEFAULT NULL,
  `agrupaciones` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`c_Pais`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
