unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ShellCtrls, ComCtrls,
  StdCtrls, ExtCtrls, Buttons, Menus, LazUTF8, ShellApi;

type

  { TForm1 }

  TForm1 = class(TForm)
    GoButton: TButton;
    MainMenu1: TMainMenu;
    CreateMenuItem: TMenuItem;
    ViewMenuItem: TMenuItem;
    CleateFolder: TMenuItem;
    ViewIcon: TMenuItem;
    ViewList: TMenuItem;
    ViewReport: TMenuItem;
    ViewSmallIcon: TMenuItem;
    PathEdit: TEdit;
    ArrowBack: TImage;
    ArrowForward: TImage;
    ShellListView1: TShellListView;
    ShellTreeView1: TShellTreeView;
    StatusBar1: TStatusBar;
    procedure ArrowBackClick(Sender: TObject);
    procedure ArrowForwardClick(Sender: TObject);
    procedure GoButtonClick(Sender: TObject);
    procedure ShellListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: boolean);
    procedure ShellTreeView1Click(Sender: TObject);
    procedure ShellTreeView1SelectionChanged(Sender: TObject);
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
    procedure ViewIconClick(Sender: TObject);
    procedure ViewListClick(Sender: TObject);
    procedure ViewReportClick(Sender: TObject);
    procedure ViewSmallIconClick(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  Path, OldName: string;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.ShellListView1SelectItem(Sender: TObject; Item: TListItem;
  Selected: boolean);
begin
  StatusBar1.SimpleText := ShellListView1.GetPathFromItem(Item);
  Path := ShellListView1.GetPathFromItem(Item);
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin

  {Alt + Стрелка влево}
  if ((key = $25) and (ssAlt in Shift)) then
    try
      ShellListView1.Root := ExtractFileDir(ShellListView1.Root);
      PathEdit.Text := ShellListView1.Root;
    except
    end;

  {Alt + Стрелка вправо}
  if ((key = $27) and (ssAlt in Shift)) then
  begin
    if (ExtractFileExt(Path) = '') then
      try
        ShellListView1.Root := ExtractFileDir(ExtractFileDir(Path));
        PathEdit.Text := ShellListView1.Root;
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
        PathEdit.Text := ShellListView1.Root;
      except
      end;
  end;

  {Mouse XButton2}
  if (Button = mbExtra1) then
    try
      ShellListView1.Root := ExtractFileDir(ShellListView1.Root);
      PathEdit.Text := ShellListView1.Root;
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
    PathEdit.Text := ShellListView1.Root;
  end

  {Открытие файлов}
  else
    ShellExecute(0, nil, PChar('"' + UTF8ToWinCP(Path) + '"'), nil, nil, 0);

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

(* Меню "Вид" *)
// Значки
procedure TForm1.ViewIconClick(Sender: TObject);
begin
  ShellListView1.ViewStyle := vsIcon;
end;
// Список
procedure TForm1.ViewListClick(Sender: TObject);
begin
  ShellListView1.ViewStyle := vsList;
end;
// Таблица
procedure TForm1.ViewReportClick(Sender: TObject);
begin
  ShellListView1.ViewStyle := vsReport;
end;
// Мелкие значки
procedure TForm1.ViewSmallIconClick(Sender: TObject);
begin
  ShellListView1.ViewStyle := vsSmallIcon;
end;

procedure TForm1.ShellTreeView1Click(Sender: TObject);
begin
  PathEdit.Text := ShellListView1.Root;
end;

procedure TForm1.ShellTreeView1SelectionChanged(Sender: TObject);
begin

end;

procedure TForm1.ArrowBackClick(Sender: TObject);
begin

  {Стрелка назад}
  try
    ShellListView1.Root := ExtractFileDir(ShellListView1.Root);
    PathEdit.Text := ShellListView1.Root;
  except
  end;

end;

procedure TForm1.ArrowForwardClick(Sender: TObject);
begin

  {Стрелка вперед}
  if (ExtractFileExt(Path) = '') then
    try
      ShellListView1.Root := ExtractFileDir(ExtractFileDir(Path));
      PathEdit.Text := ShellListView1.Root;
    except
    end;

end;

procedure TForm1.GoButtonClick(Sender: TObject);
begin
  try
    ShellListView1.Root := PathEdit.Text;
  except
    on E: EInvalidPath do
      MessageDlg('Ошибка', 'Некорректный путь!',
        mtError, mbOkCancel, '');
  end;
end;

end.
