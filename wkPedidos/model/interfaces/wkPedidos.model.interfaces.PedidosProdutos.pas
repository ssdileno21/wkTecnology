unit wkPedidos.model.interfaces.PedidosProdutos;

interface

type
  iPedidosProdutosModel = interface
    ['{99495AFC-1768-49F6-AB0C-EA163C9AC36F}']

    function Autoincrem(Value : Integer) : iPedidosProdutosModel; overload;
    function Autoincrem : Integer; overload;

    function NumeroPedido(Value : Integer) : iPedidosProdutosModel; overload;
    function NumeroPedido : Integer; overload;

    function CodigoProduto(Value : Integer) : iPedidosProdutosModel; overload;
    function CodigoProduto : Integer; overload;

    function DescricaoProduto(Value : String) : iPedidosProdutosModel; overload;
    function DescricaoProduto : String; overload;

    function Quantidade(Value : Integer) : iPedidosProdutosModel; overload;
    function Quantidade : Integer; overload;

    function VlrUnitario(Value : Double) : iPedidosProdutosModel; overload;
    function VlrUnitario : Double; overload;

    function VlrTotal(Value : Double) : iPedidosProdutosModel; overload;
    function VlrTotal : Double; overload;
end;

  iPedidosProdutosFactory = interface
    ['{14D44AB8-DD4B-4079-B40A-2CA3C6B1C2EA}']
    function PedidosProdutos : iPedidosProdutosModel;
  end;

implementation

end.
