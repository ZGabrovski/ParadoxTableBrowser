unit uMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, paradox, DB, fpcsvexport, Forms, Controls, Graphics,
  Dialogs, DBGrids, StdCtrls, ExtCtrls, LConvEncoding, fpDBExport;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    Button1: TButton;
    Button2: TButton;
    CSVExporter1: TCSVExporter;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Image1: TImage;
    OpenDialog1: TOpenDialog;
    Paradox1: TParadox;
    SaveDialog1: TSaveDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Paradox1GetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure Paradox1IntGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure Paradox1DateTimeGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
  private

  public

  end;
Type

    { TCSVFormatSettingsHelper }

    TCSVFormatSettingsHelper = class helper for TCSVFormatSettings
       Public
       Procedure SetUseDisplayFormat( Format : Boolean);
       end;

type
  CP1251String = type AnsiString(1251); // note the extra "type"
var
  frmMain: TfrmMain;

implementation

{$R *.lfm}

{ TCSVFormatSettingsHelper }

procedure TCSVFormatSettingsHelper.SetUseDisplayFormat(Format: Boolean);
begin
  //
INherited UseDisplayText:=Format;
end;

{ TfrmMain }

procedure TfrmMain.Button1Click(Sender: TObject);
var
  i: Integer;
begin
{$IFDEF UNIX}
Paradox1.PxLibrary := '/usr/local/lib/libpx.so.0';
{$ELSE}
Paradox1.PxLibrary := 'pxlib.dll';
{$ENDIF}
if Paradox1.Active then
  Paradox1.Close;
if OpenDialog1.Execute then begin
  try

  Paradox1.FileName := OpenDialog1.FileName;
  Paradox1.Open;

  for i := 0 to Paradox1.Fields.Count - 1 do begin
    if Paradox1.Fields[ i ].DataType = ftString then
      TStringField( Paradox1.Fields[ i ] ).OnGetText:=@Paradox1GetText ;
    if Paradox1.Fields[ i ].DataType = ftinteger then
      TStringField( Paradox1.Fields[ i ] ).OnGetText:=@Paradox1intGetText ;
    if (Paradox1.Fields[ i ].DataType = ftDate ) or (Paradox1.Fields[ i ].DataType = ftDateTime ) then
      TStringField( Paradox1.Fields[ i ] ).OnGetText:=@Paradox1DateTimeGetText ;

    if Paradox1.Fields[ i ].DataType = ftFloat then
      TFloatField( Paradox1.Fields[ i ] ).DisplayFormat:='0.00';

    if Paradox1.Fields[ i ].DataType = ftBCD then
      TFloatField( Paradox1.Fields[ i ] ).DisplayFormat:='0.0000';

    end;

  except
  ShowMessage('Unable to load a table.');
  end;
  end;

end;

procedure TfrmMain.Button2Click(Sender: TObject);
begin
  if SaveDialog1.Execute then begin
    Paradox1.First;
    CSVExporter1.FormatSettings.SetUseDisplayFormat( True );
    CSVExporter1.FileName := SaveDialog1.FileName;
    CSVExporter1.Execute;
  end;
end;

procedure TfrmMain.Image1Click(Sender: TObject);
begin

end;

procedure TfrmMain.Paradox1GetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
var
  S : RawByteString;
begin
  //
S := Sender.AsString;
atext := CP1251ToUTF8( S );

end;

procedure TfrmMain.Paradox1IntGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  //
if Sender.AsInteger=-2147483648 then  // Paradox NULL flag
  atext :=''
else
  aText := Sender.AsString;
end;

procedure TfrmMain.Paradox1DateTimeGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
var D1 : TDateTime;
  i : Int64;
begin
D1 := Sender.AsDateTime;
i := Trunc(D1);
if i <= 0 then
  aText := ''
else
  begin
  if Sender.DataType = ftDate then
    aText := FormatDateTime('dd.mm.yyyy', Sender.AsDateTime )
  else
    if Sender.DataType = ftDateTime then
      aText := FormatDateTime('dd.mm.yyyy hh:nn:ss:zzz ', Sender.AsDateTime );

  end;
DisplayText := True;
end;

end.

