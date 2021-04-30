CREATE TABLE `ic_cat_tr_departamento` (
  `id_departamento` int(11) NOT NULL AUTO_INCREMENT,
  `id_centro_costo` int(11) NOT NULL,
  `cve_departamento` char(10) DEFAULT NULL,
  `nom_departamento` varchar(255) DEFAULT NULL,
  `estatus_departamento` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_mod_departamento` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_departamento`),
  KEY `fk_departamento_centro_cost_idx` (`id_centro_costo`),
  KEY `idx_departamento` (`cve_departamento`,`nom_departamento`) USING BTREE,
  CONSTRAINT `fk_departamento_centro_cost` FOREIGN KEY (`id_centro_costo`) REFERENCES `ic_cat_tr_centro_costo` (`id_centro_costo`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
