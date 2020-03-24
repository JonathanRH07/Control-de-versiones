CREATE TABLE `ic_cat_tc_ine_ent_fed` (
  `cve_entidad_federativa` char(3) NOT NULL,
  `entidad_federativa` varchar(45) DEFAULT NULL,
  `circunscripcion` int(1) DEFAULT '0',
  PRIMARY KEY (`cve_entidad_federativa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
