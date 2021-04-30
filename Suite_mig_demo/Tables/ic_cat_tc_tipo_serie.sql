CREATE TABLE `ic_cat_tc_tipo_serie` (
  `cve_tipo_serie` char(4) NOT NULL,
  `cve_tipo_doc` char(4) NOT NULL,
  `descripcion_tipo_serie` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`cve_tipo_serie`),
  KEY `fk_ic_cat_tr_tipo_serie_ic_cat_tr_tipo_doc1_idx` (`cve_tipo_doc`) USING BTREE,
  CONSTRAINT `fk_ic_cat_tr_tipo_serie_ic_cat_tr_tipo_doc1` FOREIGN KEY (`cve_tipo_doc`) REFERENCES `ic_cat_tr_tipo_doc` (`cve_tipo_doc`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
