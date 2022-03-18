unit wkPedidos.model.interfaces.PedidosDadosGerais;

interface

type
  iPedidosDadosGeraisModel = interface
    ['{0AA4EA8D-3601-45E3-B220-5F52AB08C0B6}']

    function NumeroPedido(Value : Integer) : iPedidosDadosGeraisModel; overload;
    function NumeroPedido : Integer; overload;

    function DataEmissao(Value : string) : iPedidosDadosGeraisModel; overload;
    function DataEmissao : string; overload;

    function CodigoCliente(Value : Integer) : iPedidosDadosGeraisModel;
      overload;
    function CodigoCliente : Integer; overload;

    function NomeCliente(Value : string) : iPedidosDadosGeraisModel; overload;
    function NomeCliente : string; overload;

    function ValorTotal(Value : Double) : iPedidosDadosGeraisModel; overload;
    function ValorTotal : Double; overload;
end;

  iPedidosDadosGeraisFactory = interface
    ['{D7393DD8-5302-4BA8-A847-7E882FF819D2}']
    function PedidosDadosGerais : iPedidosDadosGeraisModel;
  end;

implementation

end.
