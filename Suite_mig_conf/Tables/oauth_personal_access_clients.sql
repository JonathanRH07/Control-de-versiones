CREATE TABLE `oauth_personal_access_clients` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `client_id` int(11) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
