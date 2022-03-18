unit wkPedidos.model.PedidoVenda.Dao;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, FireDAC.Phys.MySQLDef,
  FireDAC.Phys.MySQL, Vcl.Forms, Vcl.Dialogs, uWkUtils,

  wkPedidos.model.interfaces.PedidosDadosGerais,
  wkPedidos.model.interfaces.PedidosProdutos
  ;

type
  TPedidoVendaDao = class(TDataModule)
    FDQuery1: TFDQuery;
    MemPedido: TFDMemTable;
    MemPedidoProdutos: TFDMemTable;
    FDStoredProc1: TFDStoredProc;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    FDConnection1: TFDConnection;
    MemPedidoNumeroPedido: TIntegerField;
    MemPedidoDataEmissao: TDateTimeField;
    MemPedidoCodigoCliente: TIntegerField;
    MemPedidoValorTotal: TFloatField;
    MemPedidoProdutosAutoincrem: TIntegerField;
    MemPedidoProdutosNPedido: TIntegerField;
    MemPedidoProdutosCodigoProduto: TIntegerField;
    MemPedidoProdutosQuantidade: TIntegerField;
    MemPedidoProdutosVlrTotal: TFloatField;
    MemPedidoProdutosDescricao: TStringField;
    dsMemPedidoProdutos: TDataSource;
    MemPedidoProdutosVlrUnitario2: TFloatField;
    procedure FDConnection1BeforeConnect(Sender: TObject);
  private
    { Private declarations }
    procedure ExecutaComando(Value : string; pTipo : Integer=0);
    procedure InserirPedido(Value : iPedidosDadosGeraisModel);
    procedure InserirProduto;
  public
    { Public declarations }
    function ExistePedido : Boolean;
    function ExistemPedidoItens : Boolean;
    procedure ProximoCodigoPedido(Value : iPedidosDadosGeraisModel);
    procedure ProximoCodigoItem(Value : iPedidosProdutosModel);
    procedure AbrirPedido(Value : iPedidosDadosGeraisModel; pNumeroPedido :
      Integer);
    procedure GravaPedidoTemp(Value : iPedidosDadosGeraisModel);
    procedure GravaPedidoProdutosTemp(Value : iPedidosProdutosModel);
    procedure BuscarCliente(Value : iPedidosDadosGeraisModel);
    procedure BuscarProduto(Value : iPedidosProdutosModel);
    procedure DeletarProduto(Value : iPedidosProdutosModel);
    procedure GravarPedido(Value : iPedidosDadosGeraisModel);


  end;

var
  PedidoVendaDao: TPedidoVendaDao;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TPedidoVendaDao.AbrirPedido(Value: iPedidosDadosGeraisModel;
  pNumeroPedido: Integer);
begin

end;

procedure TPedidoVendaDao.BuscarCliente(Value: iPedidosDadosGeraisModel);
begin
  FDConnection1.Connected := true;
  FDConnection1.StartTransaction;
  try
    FDStoredProc1.Close;
    FDStoredProc1.Active := False;
    FDStoredProc1.Connection := FDConnection1;
    FDStoredProc1.StoredProcName := 'SP_BuscaCliente';
    FDStoredProc1.Prepare;
    if Value.CodigoCliente > 0 then
      FDStoredProc1.ParamByName('pCodigo').AsInteger := Value.CodigoCliente;
    if Value.NomeCliente <> '' then
      FDStoredProc1.ParamByName('pNome').AsString := Value.NomeCliente;
    FDStoredProc1.Open;
    FDStoredProc1.Active := True;
    if NOT FDStoredProc1.IsEmpty then
    begin
      Value.CodigoCliente(FDStoredProc1.FieldByName('Codigo').AsInteger);
      Value.NomeCliente(FDStoredProc1.FieldByName('Nome').AsString);
    end;
    FDConnection1.Commit;
  except on E : Exception do
    begin
        FDConnection1.Rollback;
        ShowMessage(MESSAGEFIXO1 +#13+
                    'Classe do erro: '+E.ClassName+#13+
                    'Mensagem de erro: '+E.Message);
    end;
  end;
  FDConnection1.Connected := False;
end;

procedure TPedidoVendaDao.BuscarProduto(Value: iPedidosProdutosModel);
begin
  FDConnection1.Connected := true;
  FDConnection1.StartTransaction;
  try
    FDStoredProc1.Connection := FDConnection1;
    FDStoredProc1.StoredProcName := 'SP_BuscaProduto';
    FDStoredProc1.Prepare;
    if Value.CodigoProduto > 0 then
      FDStoredProc1.ParamByName('pCodigo').AsInteger := Value.CodigoProduto;
    if Value.DescricaoProduto <> '' then
      FDStoredProc1.ParamByName('pDescricao').AsString :=
        Value.DescricaoProduto;
    FDStoredProc1.Open;
    FDStoredProc1.Active := True;
    if NOT FDStoredProc1.IsEmpty then
    begin
      Value.CodigoProduto(FDStoredProc1.FieldByName('Codigo').AsInteger);
      Value.DescricaoProduto(FDStoredProc1.FieldByName('Descricao').AsString);
      Value.VlrUnitario(FDStoredProc1.FieldByName('PrecoVenda').AsFloat);
    end;
    FDConnection1.Commit;
  except on E : Exception do
    begin
        FDConnection1.Rollback;
        ShowMessage(MESSAGEFIXO1 +#13+
                    'Classe do erro: '+E.ClassName+#13+
                    'Mensagem de erro: '+E.Message);
    end;
  end;
  FDConnection1.Connected := False;
end;

procedure TPedidoVendaDao.DeletarProduto(Value: iPedidosProdutosModel);
begin

end;

procedure TPedidoVendaDao.ExecutaComando(Value: string; pTipo : Integer);
begin
  FDConnection1.Connected := true;
  FDConnection1.StartTransaction;
  try
    FDQuery1.SQL.Clear;
    FDQuery1.SQL.Text := Value;

    FDConnection1.Commit;
  except on E : Exception do
    begin
        FDConnection1.Rollback;
        ShowMessage(MESSAGEFIXO1 +#13+
                    'Classe do erro: '+E.ClassName+#13+
                    'Mensagem de erro: '+E.Message);
    end;
  end;

end;

function TPedidoVendaDao.ExistemPedidoItens : Boolean;
begin
  Result := (NOT MemPedidoProdutos.IsEmpty);
end;

function TPedidoVendaDao.ExistePedido: Boolean;
begin
  Result := (NOT MemPedidoProdutos.IsEmpty);
end;

procedure TPedidoVendaDao.FDConnection1BeforeConnect(Sender: TObject);
begin
  FDPhysMySQLDriverLink1.VendorLib :=
    ExtractFilePath(Application.ExeName) + 'libmysql.dll';
end;

procedure TPedidoVendaDao.GravaPedidoProdutosTemp(Value: iPedidosProdutosModel);
begin
  try
    //MemPedidoProdutos.Close;
    MemPedidoProdutos.Open;
    with MemPedidoProdutos do
    begin
      Append;
      FieldByName('Autoincrem').AsInteger := Value.Autoincrem;
      FieldByName('NumeroPedido').AsInteger := Value.NumeroPedido;
      FieldByName('CodigoProduto').AsInteger := Value.CodigoProduto;
      FieldByName('Descricao').AsString := Value.DescricaoProduto;
      FieldByName('Quantidade').AsInteger := Value.Quantidade;
      FieldByName('VlrUnitario').AsFloat := Value.VlrUnitario;
      FieldByName('VlrTotal').AsFloat := (Value.Quantidade * Value.VlrUnitario);
      Post;
      Refresh;
      Value.DsPedidosProdutos(dsMemPedidoProdutos);
    end;
  except on E : Exception do
    begin
        FDConnection1.Rollback;
        ShowMessage(MESSAGEFIXO1 +#13+
                    'Classe do erro: '+E.ClassName+#13+
                    'Mensagem de erro: '+E.Message);
    end;
  end;
end;

procedure TPedidoVendaDao.GravaPedidoTemp(Value : iPedidosDadosGeraisModel);
begin
  try
    MemPedido.Close;
    MemPedido.Open;
    with MemPedido do
    begin
      Append;
      FieldByName('NumeroPedido').AsInteger := Value.NumeroPedido;
      FieldByName('CodigoCliente').AsInteger := Value.CodigoCliente;
      FieldByName('ValorTotal').AsFloat := Value.ValorTotal;
      Post;
    end;

  except on E : Exception do
    begin
        FDConnection1.Rollback;
        ShowMessage(MESSAGEFIXO1 +#13+
                    'Classe do erro: '+E.ClassName+#13+
                    'Mensagem de erro: '+E.Message);
    end;
  end;
end;

procedure TPedidoVendaDao.GravarPedido(Value : iPedidosDadosGeraisModel);
begin
   //INSERIR PRODUTOS
  InserirProduto;
  //GRAVA PEDIDO
  InserirPedido(Value);
end;

procedure TPedidoVendaDao.InserirPedido(Value : iPedidosDadosGeraisModel);
begin
   FDConnection1.Connected := true;
  FDConnection1.StartTransaction;
  try
    with FDStoredProc1 do
    begin
      Connection := FDConnection1;
      StoredProcName := 'SP_InserirPedido';
      Prepare;
      ParamByName('pNumeroPedido').AsInteger := Value.NumeroPedido;
      ParamByName('pCodigoCliente').AsInteger := Value.CodigoCliente;
      ExecProc;
      Active := True;
      Commit;
    end;
    ShowMessage(MESSAGEGRAVARD);
  except on E : Exception do
    begin
        FDConnection1.Rollback;
        ShowMessage(MESSAGEFIXO1 +#13+
                    'Classe do erro: '+E.ClassName+#13+
                    'Mensagem de erro: '+E.Message);
    end;
  end;
  FDConnection1.Connected := False;
end;

procedure TPedidoVendaDao.InserirProduto;
var
  vAutoincrem, vNumeroPedido, vCodigoProduto, vQuantidade : Integer;
  vVlrUnitario, vVlrTotal : Double;
begin
  FDConnection1.Connected := true;
  FDConnection1.StartTransaction;
  try
    FDStoredProc1.Connection := FDConnection1;
    FDStoredProc1.StoredProcName := 'SP_InserirPedidoProduto';
    MemPedidoProdutos.First;
    while NOT MemPedidoProdutos.Eof do
    begin
      vAutoincrem := MemPedidoProdutos.FieldByName('Autoincrem').AsInteger;
      vNumeroPedido := MemPedidoProdutos.FieldByName('NumeroPedido').AsInteger;
      vCodigoProduto := MemPedidoProdutos.FieldByName('CodigoProduto').AsInteger;
      vQuantidade := MemPedidoProdutos.FieldByName('Quantidade').AsInteger;
      vVlrUnitario := (MemPedidoProdutos.FieldByName('VlrUnitario').AsFloat);
      vVlrTotal := MemPedidoProdutos.FieldByName('VlrTotal').AsFloat;

      FDStoredProc1.Prepare;
      FDStoredProc1.ParamByName('pAutoincrem').AsInteger := vAutoincrem;
      FDStoredProc1.ParamByName('pNumeroPedido').AsInteger := vNumeroPedido;
      FDStoredProc1.ParamByName('pCodigoProduto').AsInteger := vCodigoProduto;
      FDStoredProc1.ParamByName('pQuantidade').AsInteger := vQuantidade;
      FDStoredProc1.ParamByName('pVlrUnitario').AsBCD := vVlrUnitario;
      FDStoredProc1.ParamByName('pVlrTotal').AsBCD := vVlrTotal;
      FDStoredProc1.ExecProc;
      FDStoredProc1.Active := True;
      FDConnection1.Commit;
    end;
  except on E : Exception do
    begin
        FDConnection1.Rollback;
        ShowMessage(MESSAGEFIXO1 +#13+
                    'Classe do erro: '+E.ClassName+#13+
                    'Mensagem de erro: '+E.Message);
    end;
  end;
  FDConnection1.Connected := False;
end;

procedure TPedidoVendaDao.ProximoCodigoItem(Value: iPedidosProdutosModel);
var
  cont : Integer;
begin
  FDConnection1.Connected := true;
  FDConnection1.StartTransaction;
  try
    FDStoredProc1.Connection := FDConnection1;
    FDStoredProc1.StoredProcName := 'SP_ProximoCodigoItem';
    FDStoredProc1.Prepare;
    FDStoredProc1.Open;
    FDStoredProc1.Active := True;
    cont := FDStoredProc1.FieldByName('ProximoCod').AsInteger;
    if cont = 0 then
      Inc(cont);
    Value.Autoincrem(cont);
    FDConnection1.Commit;
  except on E : Exception do
    begin
        FDConnection1.Rollback;
        ShowMessage(MESSAGEFIXO1 +#13+
                    'Classe do erro: '+E.ClassName+#13+
                    'Mensagem de erro: '+E.Message);
    end;
  end;
  FDConnection1.Connected := False;
end;

procedure TPedidoVendaDao.ProximoCodigoPedido(Value: iPedidosDadosGeraisModel);
var
  cont : Integer;
begin
  FDConnection1.Connected := true;
  FDConnection1.StartTransaction;
  try
    FDStoredProc1.Connection := FDConnection1;
    FDStoredProc1.StoredProcName := 'SP_ProximoCodigoPedido';
    FDStoredProc1.Prepare;
    FDStoredProc1.Open;
    FDStoredProc1.Active := True;
    cont := FDStoredProc1.FieldByName('ProximoCod').AsInteger;
    if cont = 0 then
      Inc(cont);
    Value.NumeroPedido(cont);
    FDConnection1.Commit;
  except on E : Exception do
    begin
        FDConnection1.Rollback;
        ShowMessage(MESSAGEFIXO1 +#13+
                    'Classe do erro: '+E.ClassName+#13+
                    'Mensagem de erro: '+E.Message);
    end;
  end;
  FDConnection1.Connected := False;
end;

end.
