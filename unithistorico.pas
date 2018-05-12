unit unitHistorico;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ValEdit;

type

  { TFormHistorico }

    TFormHistorico = class(TForm)
    ButtonLimp: TButton;
    ValueListEditorHist: TValueListEditor;
    procedure ButtonLimpClick(Sender: TObject);
  private

  public

  end;

var
  FormHistorico: TFormHistorico;

implementation

{$R *.lfm}

{ TFormHistorico }

procedure TFormHistorico.ButtonLimpClick(Sender: TObject);
begin
  ValueListEditorHist.Clear;
end;

end.

