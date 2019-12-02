DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_abc`()
BEGIN

	SELECT
		'Carol',
        'Adrian',
        'Mario',
        'Kido',
        'Roots',
        'Rocio'
	FROM dual;

END$$
DELIMITER ;
