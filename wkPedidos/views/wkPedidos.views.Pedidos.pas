unit wkPedidos.views.Pedidos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Buttons, Vcl.ExtCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.DBCtrls,
  Vcl.StdCtrls, uWkUtils, wkPedidos.controller.PedidoVenda.Controller;

type
  EnumFormState = (sfsInicial,sfsInsert);

type
  TfrmPedidos = class(TForm)
    Panel1: TPanel;
    sbAbrirPedido: TSpeedButton;
    Panel2: TPanel;
    Panel5: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel6: TPanel;
    DBNavigator1: TDBNavigator;
    dbgProdutos: TDBGrid;
    edtValorTotalPedido: TEdit;
    Label1: TLabel;
    edtNumeroPedido: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    edtDtaEmissao: TEdit;
    Label5: TLabel;
    edtCodCliente: TEdit;
    edtNomeCliente: TEdit;
    Label6: TLabel;
    edtCodProduto: TEdit;
    edtDescricaoProduto: TEdit;
    sbGravarPedido: TSpeedButton;
    Label8: TLabel;
    edtQtdProduto: TEdit;
    edtVlrUnitarioProduto: TEdit;
    Label9: TLabel;
    sbIniciar: TSpeedButton;
    Panel7: TPanel;
    sbDeletarProduto: TSpeedButton;
    sbInserirProduto: TSpeedButton;
    sbCancelar: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure sbIniciarClick(Sender: TObject);
    procedure sbCancelarClick(Sender: TObject);
    procedure sbAbrirPedidoClick(Sender: TObject);
    procedure edtCodClienteExit(Sender: TObject);
    procedure edtNomeClienteExit(Sender: TObject);
  private
    { Private declarations }
    FPedidoVenda : iPedidoVendaController;
    procedure FormControl(Value : EnumFormState);
    procedure CarregarPedidos;
    procedure CancelaInsercaoPedidos;
    procedure Iniciar;
    procedure BuscarCodigoCliente;
    procedure BuscarNomeCliente;
    procedure InserirPedido;
    procedure InserirPedidoProduto;
  public
    { Public declarations }
  end;

var
  frmPedidos: TfrmPedidos;

implementation

{$R *.dfm}

{ TfrmPedidos }

procedure TfrmPedidos.BuscarCodigoCliente;
begin
  with FPedidoVenda.PedidosDadosGeraisFactory.PedidosDadosGerais do
  begin
    CodigoCliente(0).
    NomeCliente(edtNomeCliente.Text);
    FPedidoVenda.BuscarCliente;
    edtCodCliente.Text := IntToStr(CodigoCliente);
  end;
end;

procedure TfrmPedidos.BuscarNomeCliente;
begin
  with FPedidoVenda.PedidosDadosGeraisFactory.PedidosDadosGerais do
  begin
    CodigoCliente(StrToIntDef(edtCodCliente.Text,0))
    .NomeCliente('');
    FPedidoVenda.BuscarCliente;
    edtNomeCliente.Text := NomeCliente;
  end;
end;

procedure TfrmPedidos.CancelaInsercaoPedidos;
begin
  FormControl(sfsInicial);
end;

procedure TfrmPedidos.CarregarPedidos;
begin
  if edtCodCliente.Text <> '' then
  begin
    ShowMessage(MESSAGECARREGAPEDIDOSVALCLIENTE);
    Exit;
  end;
end;

procedure TfrmPedidos.edtCodClienteExit(Sender: TObject);
begin
  BuscarNomeCliente;
end;

procedure TfrmPedidos.edtNomeClienteExit(Sender: TObject);
begin
  BuscarCodigoCliente;
end;

procedure TfrmPedidos.FormControl(Value: EnumFormState);
var
  i : Integer;
begin
  try
    for I := 0 to Self.ComponentCount -1 do
    begin
       if (Self.Components[i] is TEdit) then
       begin
         TEdit(Self.Components[i]).Clear;
         TEdit(Self.Components[i]).Enabled := (Value = sfsInsert);
       end;
     end;
     edtNumeroPedido.Enabled := (Value = sfsInicial);
  except on E : Exception do
    ShowMessage(MESSAGEEXCEPCOMPCONTROL + E.Message);
  end;
end;

procedure TfrmPedidos.FormCreate(Sender: TObject);
begin
  FormControl(sfsInicial);
  FPedidoVenda := TPedidoVendaControler.New;
end;

procedure TfrmPedidos.Iniciar;
begin
  edtNumeroPedido.Text := IntToStr(FPedidoVenda.ProximoCodigoPedido);
end;

procedure TfrmPedidos.InserirPedido;
begin
  if NOT FPedidoVenda.ExistePedido then
  begin
    with FPedidoVenda.PedidosDadosGeraisFactory.PedidosDadosGerais do
    begin
      NumeroPedido(StrToIntDef(edtNumeroPedido.Text,0)).
      CodigoCliente(StrToIntDef(edtCodCliente.Text,0));
      FPedidoVenda.InserirPedido;
    end;
  end;
end;

procedure TfrmPedidos.InserirPedidoProduto;
begin
{  with FPedidoVenda.PedidosProdutosFactory.PedidosProdutos do
    begin
      NumeroPedido(StrToIntDef(edtNumeroPedido.Text,0)).
      CodigoCliente(StrToIntDef(edtCodCliente.Text,0));
      FPedidoVenda.InserirPedido;
    end;}
end;

procedure TfrmPedidos.sbAbrirPedidoClick(Sender: TObject);
begin
  CarregarPedidos;
end;

procedure TfrmPedidos.sbCancelarClick(Sender: TObject);
begin
  FormControl(sfsInicial);
end;

procedure TfrmPedidos.sbIniciarClick(Sender: TObject);
begin
  FormControl(sfsInsert);
  Iniciar;
end;

end.


















