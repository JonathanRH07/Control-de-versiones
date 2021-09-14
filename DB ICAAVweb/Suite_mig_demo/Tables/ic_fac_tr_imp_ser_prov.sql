CREATE TABLE `ic_fac_tr_imp_ser_prov` (
  `id_imp_ser_prov` int(11) NOT NULL AUTO_INCREMENT,
  `id_impuesto` int(11) NOT NULL,
  `id_prove_servicio` int(11) NOT NULL,
  PRIMARY KEY (`id_imp_ser_prov`),
  KEY `fk_imp_ser_prov_impuesto_idx` (`id_impuesto`),
  KEY `fk_imp_ser_prov_servicio_prod_idx` (`id_prove_servicio`),
  CONSTRAINT `fk_imp_ser_prov_servicio_prod` FOREIGN KEY (`id_prove_servicio`) REFERENCES `ic_fac_tr_prove_servicio` (`id_prove_servicio`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
