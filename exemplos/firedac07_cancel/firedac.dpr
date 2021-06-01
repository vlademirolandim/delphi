program firedac;

{
  Esse programa :
  1. cria uma conexão SEM USAR o FDManager
  2. testa se a conexão está correta.
  3. Buscar por um valor
  4. Após achar o valor altera o mesmo
  5. Cancela as alterações efetuadas
}

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,FireDAC.Comp.Client,
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.ConsoleUI.Wait, FireDac.Dapt ,FireDac.Stan.Param,
  Data.DB, TypInfo,
  Classes;   // Classes para o TStringList
var
  conexao: TFDConnection;
  qry: TFDQuery;

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }


      conexao := TFDConnection.Create(nil);

      conexao.Params.Clear;
      conexao.Params.Add(Format('DriverID=%s',['FB']));
      conexao.Params.Add(Format('Database=%s',['C:\projetos\console\banco\EMPLOYEE.FDB']));
      conexao.Params.Add(Format('User_Name=%s',['SYSDBA']));
      conexao.Params.Add(Format('Password=%s',['masterkey']));
      conexao.Params.Add(Format('Protocol=%s',['TCPIP']));
      conexao.Params.Add(Format('Server=%s',['localhost']));
      conexao.ConnectionName :='Pooled';
      conexao.Connected := true;

      if conexao.Connected then
        begin
          writeln('Connection succeeded.');
        end
      else
        begin
            writeln('Connection Failed.');
        end;

      qry := TFDQuery.Create(conexao);
      try
          qry.Connection := conexao;
          qry.SQL.Text := 'select COUNTRY, CURRENCY from COUNTRY';
          qry.Open;
          writeln(Format('Estado: %s', [GetEnumName(TypeInfo(TDataSetState),Ord(qry.State))]));

          // qry.Edit aqui dá erro, porque ainda não é o registro selecionado
          if qry.Locate('COUNTRY','Brazil',[]) then
          begin
            writeln('Achei o registro');
            qry.Edit; // Seleciona o registro para edição
            writeln(Format('Estado: %s', [GetEnumName(TypeInfo(TDataSetState),Ord(qry.State))]));
            qry.FieldByName('COUNTRY').AsString := 'Brazil 22';
            writeln('Acabei de alterar o valor');
          end
          else
            writeln('Não encontrei o registro para edição');

          writeln('O valor do registro e : ', qry.FieldByName('COUNTRY').AsString );
          writeln('Agora vou cancelar as alteracoes');

          qry.Cancel; // Cancelei
          writeln(Format('Estado: %s', [GetEnumName(TypeInfo(TDataSetState),Ord(qry.State))]));
          writeln('O valor do registro e : ', qry.FieldByName('COUNTRY').AsString );
          qry.Close;

          writeln('Cancel OK');

      finally
          qry.Free;
      end;


  except

    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  readln;
end.
