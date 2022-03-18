USE wkdb;
DELIMITER $$
DROP PROCEDURE IF exists SP_ProximoCodigoItem $$
CREATE PROCEDURE SP_ProximoCodigoItem(in pNumeroPedido INT, OUT ProximoCod INT)
begin
    SELECT 
		MAX(Autoincrem)
        INTO ProximoCod
	FROM tbpedidosprodutos
    WHERE NumeroPedido = pNumeroPedido;    
end $$

DELIMITER ;
