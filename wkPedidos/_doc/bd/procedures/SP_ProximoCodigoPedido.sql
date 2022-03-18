DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ProximoCodigoPedido`(OUT ProximoCod INT)
begin
    SELECT 
		MAX(NumeroPedido)
        INTO ProximoCod
	FROM tbpedidosdadosgerais;
    
end$$
DELIMITER ;
