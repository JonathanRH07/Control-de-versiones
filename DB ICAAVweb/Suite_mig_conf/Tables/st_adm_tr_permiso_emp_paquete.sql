CREATE TABLE `st_adm_tr_permiso_emp_paquete` (
  `id_permiso_emp_paquete` int(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` int(11) NOT NULL,
  `id_tipo_paquete` int(11) NOT NULL,
  PRIMARY KEY (`id_permiso_emp_paquete`),
  KEY `fk_permiso_emp_paquete_empresa_idx` (`id_empresa`),
  KEY `fk_permiso_emp_paquete_tipo_paquete_idx` (`id_tipo_paquete`),
  CONSTRAINT `fk_permiso_emp_paquete_empresa` FOREIGN KEY (`id_empresa`) REFERENCES `st_adm_tr_empresa` (`id_empresa`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_permiso_emp_paquete_tipo_paquete` FOREIGN KEY (`id_tipo_paquete`) REFERENCES `st_adm_tc_tipo_paquete` (`id_tipo_paquete`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
