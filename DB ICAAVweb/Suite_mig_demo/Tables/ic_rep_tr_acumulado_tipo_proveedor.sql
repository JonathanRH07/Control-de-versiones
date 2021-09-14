CREATE TABLE `ic_rep_tr_acumulado_tipo_proveedor` (
  `id_grupo_empresa` int(11) NOT NULL,
  `id_tipo_proveedor` int(11) NOT NULL,
  `id_sucursal` int(11) NOT NULL,
  `monto_moneda_base` decimal(15,2) NOT NULL DEFAULT '0.00',
  `monto_usd` decimal(15,2) NOT NULL DEFAULT '0.00',
  `monto_eur` decimal(15,2) NOT NULL DEFAULT '0.00',
  `egresos_moneda_base` decimal(15,2) NOT NULL DEFAULT '0.00',
  `egresos_usd` decimal(15,2) NOT NULL DEFAULT '0.00',
  `egresos_eur` decimal(15,2) NOT NULL DEFAULT '0.00',
  `venta_neta_moneda_base` decimal(15,2) NOT NULL DEFAULT '0.00',
  `venta_neta_usd` decimal(15,2) NOT NULL DEFAULT '0.00',
  `venta_neta_eur` decimal(15,2) NOT NULL DEFAULT '0.00',
  `acumulado_moneda_base` decimal(15,2) NOT NULL DEFAULT '0.00',
  `acumulado_usd` decimal(15,2) NOT NULL DEFAULT '0.00',
  `acumulado_eur` decimal(15,2) NOT NULL DEFAULT '0.00',
  `fecha` varchar(7) CHARACTER SET utf8 DEFAULT NULL,
  `fecha_act` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
