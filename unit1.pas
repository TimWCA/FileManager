unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ShellCtrls, ComCtrls,
  StdCtrls, ExtCtrls, Buttons, LazUTF8, ShellApi;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    ComboBox1: TComboBox;
    ArrowBack: TImage;
    ArrowForward: TImage;
    Label1: TLabel;
    ShellListView1: TShellListView;
    ShellTreeView1: TShellTreeView;
    StatusBar1: TStatusBar;
    ToolBar1: TToolBar;
    procedure ArrowBackClick(Sender: TObject);
    procedure ArrowForwardClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Select(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure ShellListView1DblClick(Sender: TObject);
    procedure ShellListView1Edited(Sender: TObject; Item: TListItem;
      var AValue: string);
    procedure ShellListView1Editing(Sender: TObject; Item: TListItem;
      var AllowEdit: boolean);
    procedure ShellListView1KeyDown(Sender: TObject; var Key: word;
      Shift: TShiftState);
    procedure ShellListView1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure ShellListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: boolean);
  private

  public

  end;

var
  Form1: TForm1;
  Path, OldName: utf8string;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.ShellListView1SelectItem(Sender: TObject; Item: TListItem;
  Selected: boolean);
begin

  StatusBar1.SimpleText := ShellListView1.GetPathFromItem(Item);
  Path := ShellListView1.GetPathFromItem(Item);

end;

procedure TForm1.ComboBox1Select(Sender: TObject);
begin

  case ComboBox1.ItemIndex of
    0: ShellListView1.ViewStyle := vsIcon;
    1: ShellListView1.ViewStyle := vsList;
    2: ShellListView1.ViewStyle := vsReport;
    3: ShellListView1.ViewStyle := vsSmallIcon;
  end;

end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin

  {Alt + Стрелка влево}
  if ((key = $25) and (ssAlt in Shift)) then
    try
      ShellListView1.Root := ExtractFileDir(ShellListView1.Root);
    except
    end;

  {Alt + Стрелка вправо}
  if ((key = $27) and (ssAlt in Shift)) then
  begin
    if (ExtractFileExt(Path) = '') then
      try
        ShellListView1.Root := ExtractFileDir(ExtractFileDir(Path));
      except
      end;
  end;

end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin

  {Mouse XButton1}
  if (Button = mbExtra2) then
  begin
    if (ExtractFileExt(Path) = '') then
      try
        ShellListView1.Root := ExtractFileDir(ExtractFileDir(Path));
      except
      end;
  end;

  {Mouse XButton2}
  if (Button = mbExtra1) then
    try
      ShellListView1.Root := ExtractFileDir(ShellListView1.Root);
    except
    end;

end;

procedure TForm1.ShellListView1DblClick(Sender: TObject);
begin

  {Открытие папки}
  // Надо поискать другой способ для проверки на папку, ИМХО.
  // Возможна ситуация, что будет файл без расширения.
  if (ExtractFileExt(Path) = '') then
  begin
    ShellListView1.Root := Path;
  end

  {Открытие файлов}
  else
    ShellExecute(0, nil,  PChar('"' + UTF8ToWinCP(Path) + '"'), nil, nil, 0);

end;

procedure TForm1.ShellListView1Edited(Sender: TObject; Item: TListItem;
  var AValue: string);
begin

  {Переименование}
  RenameFile(ExtractFilePath(Path) + OldName, ExtractFilePath(Path) + AValue);

end;

procedure TForm1.ShellListView1Editing(Sender: TObject; Item: TListItem;
  var AllowEdit: boolean);
begin

  {Имя для переименования}
  OldName := ExtractFileName(Path);

end;

procedure TForm1.ShellListView1KeyDown(Sender: TObject; var Key: word;
  Shift: TShiftState);
begin

  {Alt + Стрелка влево}
  if ((key = $25) and (ssAlt in Shift)) then
    try
      ShellListView1.Root := ExtractFileDir(ShellListView1.Root);
    except
    end;

  {Alt + Стрелка вправо}
  if ((key = $27) and (ssAlt in Shift)) then
  begin
    if (ExtractFileExt(Path) = '') then
      try
        ShellListView1.Root := ExtractFileDir(ExtractFileDir(Path));
      except
      end;
  end;

end;

procedure TForm1.ShellListView1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin

  {Mouse XButton1}
  if (Button = mbExtra2) then
  begin
    if (ExtractFileExt(Path) = '') then
      try
        ShellListView1.Root := ExtractFileDir(ExtractFileDir(Path));
      except
      end;
  end;

  {Mouse XButton2}
  if (Button = mbExtra1) then
    try
      ShellListView1.Root := ExtractFileDir(ShellListView1.Root);
    except
    end;

end;

procedure TForm1.Button1Click(Sender: TObject);
begin

  //showmessage(ExtractFileDir(ExtractFileDir(ExtractFileDir(Path))));
  ShowMessage(ShellListView1.Root + '\' + ExtractFileName(Path));
  //showmessage(extractfiledir(extractfiledir(path)));
  try
    ShellListView1.Root := StatusBar1.SimpleText;
  except
    on E: EInvalidPath do
      ShowMessage('Я ещё не умею открывать файлы :(');
  end;

end;

procedure TForm1.ArrowBackClick(Sender: TObject);
begin

  {Стрелка назад}
  try
    ShellListView1.Root := ExtractFileDir(ShellListView1.Root);
  except
  end;

end;

procedure TForm1.ArrowForwardClick(Sender: TObject);
begin

  {Стрелка вперед}
  if (ExtractFileExt(Path) = '') then
    try
      ShellListView1.Root := ExtractFileDir(ExtractFileDir(Path));
    except
    end;

end;

end.
