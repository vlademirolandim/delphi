program firedac;

{
  Esse programa :

  Usa uma classe para realizar operações de busca na tabela.
  
}

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Classes,
  U_DM in 'U_DM.pas' {DM: TDataModule},
  U_Employee in 'U_Employee.pas';

var
  oEmployee: TEmployee;
begin
  try
    { TODO -oUser -cConsole Main : Insert code here }



      writeln('Antes de abrir');
      DM := Tdm.Create (nil);   { Necessário criar o DM }
      DM.FDConn.Open;
      writeln('Abriu a conexao');


      try
        oEmployee := TEmployee.Create();
        oEmployee.ListALL();
        writeln;
        writeln;
        writeln('Listando apenas funcionarios contendo "Ke"' );
        oEmployee.ListALLByName( 'Ke' );
        writeln;
        writeln;
        writeln('OK');

      finally
          DM.qryEmployee.Free;
      end;


  except

    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  readln;
end.
