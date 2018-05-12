unit unitTelaInicial;

{$mode objfpc}{$H+}

interface

uses
  Classes, StrUtils, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TFormMouA }

  TFormMouA = class(TForm)
    ButtonHist: TButton;
    ButtonCalc: TButton;
    EditVar: TEdit;
    LabelVar: TLabel;
    RadioButtonA: TRadioButton;
    RadioButtonM: TRadioButton;
    procedure ButtonCalcClick(Sender: TObject);
    procedure ButtonHistClick(Sender: TObject);
    procedure RadioButtonAChange(Sender: TObject);
    procedure RadioButtonMChange(Sender: TObject);
    procedure Checka;
  private

  public

  end;

var
  FormMouA: TFormMouA;

implementation

{$R *.lfm}

{ TFormMouA }

uses UnitHistorico;

procedure TFormMouA.Checka;
begin
  if (EditVar.Text = 'Operação Inválida!') then EditVar.Text := '';
  LabelVar.Caption := 'Variáveis';
  EditVar.ReadOnly := False;
  EditVar.Cursor := crDefault;
  EditVar.Font.Bold := False;
end;

procedure TFormMouA.ButtonCalcClick(Sender: TObject);
var
  ss, s, sc: string;
  arr: array of real;
  invalido: boolean;
  resultado: real;
  i, q, aux: longint;
  hh, mm, sec, ms: word;
begin
  s := EditVar.Text;
  invalido := False;
  if (s = '') or (not (RadioButtonA.Checked or RadioButtonM.Checked)) then
    invalido := True
  else
    for i := 1 to s.Length do
    begin
      if not( (s[i] in ['0'..'9']) or (s[i] = ' ') or (s[i] = ',') ) then
      begin
        invalido := True;
        break;
      end;
    end;
  if (invalido) then
    EditVar.Text := 'Operação Inválida!'
  else
  begin
    SetLength(arr, s.Length);
    i := 1;
    while (i <= s.length) do
    begin
      if (s[i] = ' ') and ((s[i + 1] = ' ') or (i = 1) or (i = s.Length)) then
      begin
        Delete(s, i, 1);
        i := 0;
      end;
      i := i + 1;
    end;
    s := s + ' ';
    q := 0;
    aux := 1;
    for i := 1 to s.Length do
    begin
      if (s[i] = ' ') then
      begin
        ss := copy(s, aux, i - aux);
        arr[q] := StrToFloat(ss);
        aux := i + 1;
        q := q + 1;
      end;
    end;
    sc := '';
    if (RadioButtonA.Checked) then
    begin
      resultado := 0;
      for i := 1 to s.Length - 1 do
      begin
        if (s[i] = ' ') then sc := sc + ' + '
        else sc := sc + s[i];
      end;
      resultado := 0;
      for i := 0 to q - 1 do
      begin
        resultado := resultado + arr[i];
      end;
    end
    else
    begin
      for i := 1 to s.Length - 1 do
      begin
        if (s[i] = ' ') then sc := sc + ' * '
        else sc := sc + s[i];
      end;
      resultado := 1;
      for i := 0 to q - 1 do
      begin
        resultado := resultado * arr[i];
      end;
    end;
    DecodeTime(Time, hh, mm, sec, ms);
    ss := Format('%.2d:%.2d:%.2d', [hh, mm, sec]);
    sc := sc + ' = ' + FloatToStr(resultado);
    FormHistorico.ValueListEditorHist.InsertRow(ss, sc, True);
    LabelVar.Caption := 'Número de Possibilidades';
    EditVar.Text := FloatToStr(resultado);
  end;
  EditVar.Font.Bold := True;
  RadioButtonM.Checked := False;
  RadioButtonA.Checked := False;
  EditVar.Cursor := crNo;
  EditVar.ReadOnly := True;
end;

procedure TFormMouA.ButtonHistClick(Sender: TObject);
begin
  FormHistorico.Show;
end;

procedure TFormMouA.RadioButtonAChange(Sender: TObject);
begin
  if (RadioButtonA.Checked) then
  begin
    RadioButtonM.Checked := False;
    Checka;
  end;
end;

procedure TFormMouA.RadioButtonMChange(Sender: TObject);
begin
  if (RadioButtonM.Checked) then
  begin
    RadioButtonA.Checked := False;
    Checka;
  end;
end;

end.
