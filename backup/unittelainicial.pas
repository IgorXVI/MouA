unit unitTelaInicial;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

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
    procedure EditVarChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RadioButtonAChange(Sender: TObject);
    procedure RadioButtonMChange(Sender: TObject);
    procedure Checka(c, c1 :Char);
  private

  public

  end;

var
  FormMouA: TFormMouA;
  LengthVelho: Integer;

implementation

{$R *.lfm}

{ TFormMouA }

uses UnitHistorico;

procedure TFormMouA.Checka(c, c1 :Char);
var
  i :integer;
  s :string;
begin
  s := EditVar.Text;
  for i := 1 to s.Length do if(s[i] = c1) then s[i] := c;
  EditVar.Text := s;
  if (EditVar.Text = 'Operação Inválida!') then EditVar.Text := '';
  LabelVar.Caption := 'Variáveis';
  EditVar.ReadOnly := False;
  EditVar.Cursor := crDefault;
  EditVar.Font.Bold := False;
end;

procedure TFormMouA.ButtonCalcClick(Sender: TObject);
var
  ss, s: string;
  arr: array of real;
  invalido: boolean;
  resultado: real;
  i, q, aux: longint;
  hh, mm, sec, ms: word;
begin
  s := EditVar.Text;
  aux := s.Length;
  invalido := False;
  SetLength(arr, s.Length);
  s := s + ' +';
  q := 0;
  aux := 1;
  if (s = '') or (not (RadioButtonA.Checked or RadioButtonM.Checked)) then
    invalido := True
  else
    for i := 1 to s.Length do
    begin

      if ( (i < s.Length) and (s[i] = ' ') and (s[i + 1] = ' ') ) or
      not( (s[i] in ['0'..'9']) or (s[i] = ' ') or (s[i] = ',') or (s[i] = '+')
      or (s[i] = '*') ) or ( ( (i = s.Length - 2) or (i = 1) )
      and not(s[i] in ['0'..'9']) ) then
      begin
        invalido := true;
        break;
      end;

      if (s[i] = '+') or (s[i] = '*') then
      begin
        ss := copy(s, aux, i - aux - 1);
        arr[q] := StrToFloat(ss);
        ShowMessage(ss);
        aux := i + 2;
        q := q + 1;
      end;

    end;
  if (invalido) then
    EditVar.Text := 'Operação Inválida!'
  else
  begin
    aux := s.Length - 2;
    s := copy(s, 1, aux);
    if (RadioButtonA.Checked) then
    begin
      resultado := 0;
      for i := 0 to q - 1 do resultado := resultado + arr[i];
    end
    else
    begin
      resultado := 1;
      for i := 0 to q - 1 do resultado := resultado * arr[i];
    end;
    DecodeTime(Time, hh, mm, sec, ms);
    ss := Format('%.2d:%.2d:%.2d', [hh, mm, sec]);
    s := s + ' = ' + FloatToStr(resultado);
    FormHistorico.ValueListEditorHist.InsertRow(ss, s, True);
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

procedure TFormMouA.EditVarChange(Sender: TObject);
var
  s :string;
  pos :integer;
begin
  s := EditVar.Text;
  pos := s.Length;
  if(pos > LengthVelho) and (s[pos] = ' ') and (s[pos - 1] in ['0'..'9']) then
  begin
    if(RadioButtonA.checked) then s := s + '+ '
    else s := s + '* ';
    EditVar.Text := s;
    EditVar.SelStart := s.Length;
  end;
  LengthVelho := s.Length;
end;

procedure TFormMouA.FormCreate(Sender: TObject);
begin
  LengthVelho := 0;
end;

procedure TFormMouA.RadioButtonAChange(Sender: TObject);
begin
  if (RadioButtonA.Checked) then
  begin
    RadioButtonM.Checked := False;
    Checka('+','*');
  end;
end;

procedure TFormMouA.RadioButtonMChange(Sender: TObject);
begin
  if (RadioButtonM.Checked) then
  begin
    RadioButtonA.Checked := False;
    Checka('*','+');
  end;
end;

end.
