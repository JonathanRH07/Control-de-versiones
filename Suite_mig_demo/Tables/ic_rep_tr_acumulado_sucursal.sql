CREATE TABLE `ic_rep_tr_acumulado_sucursal` (
  `id_grupo_empresa` int(11) DEFAULT NULL,
  `id_sucursal` int(11) DEFAULT NULL,
  `monto_tarifa_base` decimal(15,2) DEFAULT '0.00',
  `monto_usd` decimal(15,2) DEFAULT '0.00',
  `monto_eur` decimal(15,2) DEFAULT '0.00',
  `egresos_moneda_base` decimal(15,2) DEFAULT '0.00',
  `egresos_usd` decimal(15,2) DEFAULT '0.00',
  `egresos_eur` decimal(15,2) DEFAULT '0.00',
  `venta_neta_moneda_base` decimal(15,2) DEFAULT '0.00',
  `venta_neta_usd` decimal(15,2) DEFAULT '0.00',
  `venta_neta_eur` decimal(15,2) DEFAULT '0.00',
  `acumulado_moneda_base` decimal(16,2) DEFAULT '0.00',
  `acumulado_usd` decimal(16,2) DEFAULT '0.00',
  `acumulado_eur` decimal(16,2) DEFAULT '0.00',
  `fecha` varchar(25) DEFAULT NULL,
  `fecha_act` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
