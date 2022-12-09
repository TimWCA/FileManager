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
    DeleteMenuItem: TMenuItem;
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
    procedure CleateFolderClick(Sender: TObject);
    procedure DeleteMenuItemClick(Sender: TObject);
    procedure GoButtonClick(Sender: TObject);
    procedure ShellListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: boolean);
    procedure ShellTreeView1Click(Sender: TObject);
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
  Path: string; // Путь выделенного объекта
  OldName: string; // Старое имя при переименовании

procedure goBack;
procedure goFwd;
procedure Refresh;

implementation

uses FileSystemModule;

{$R *.lfm}

{ TForm1 }

// Выполняется при переходе на папку назад
procedure goBack;
begin
  try
    Form1.ShellListView1.Root := ExtractFileDir(Form1.ShellListView1.Root);
    Form1.PathEdit.Text := Form1.ShellListView1.Root;
  except
  end;
end;

// Выполняется при переходе на папку вперёд
procedure goFwd;
begin
  if (ExtractFileExt(Path) = '') then
    try
      Form1.ShellListView1.Root := ExtractFileDir(ExtractFileDir(Path));
      Form1.PathEdit.Text := Form1.ShellListView1.Root;
    except
    end;
end;

// Обновляет содержимое ShellListView
procedure Refresh;
var
  tempPath: string;
begin
  tempPath := Form1.ShellListView1.Root;
  Form1.ShellListView1.Root := '';
  Form1.ShellListView1.Root := tempPath;
end;

// Выполняется при выделении объека в ShellListView
procedure TForm1.ShellListView1SelectItem(Sender: TObject; Item: TListItem;
  Selected: boolean);
begin
  Path := ShellListView1.GetPathFromItem(Item);
  // Путь выделенного объекта
  StatusBar1.SimpleText := Path;
end;

// Выполняется при нажатии на форме компбинаций клавиш...
procedure TForm1.FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin

  // ...Alt + Стрелка влево
  if ((key = $25) and (ssAlt in Shift)) then
    goBack;

  // ...Alt + Стрелка вправо
  if ((key = $27) and (ssAlt in Shift)) then
    goFwd;

end;

// Выполняется при нажатии на форме кнопок мыши...
procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin

  // ...Mouse XButton1
  if (Button = mbExtra2) then
    goBack;

  // ...Mouse XButton2
  if (Button = mbExtra1) then
    goFwd;

end;

// Выполняется при нажатии на ShellListView компбинаций клавиш...
procedure TForm1.ShellListView1KeyDown(Sender: TObject; var Key: word;
  Shift: TShiftState);
begin

  // ...Alt + Стрелка влево
  if ((key = $25) and (ssAlt in Shift)) then
    goBack;

  // ...Alt + Стрелка вправо
  if ((key = $27) and (ssAlt in Shift)) then
    goFwd;

end;

// Выполняется при нажатии на форме кнопок мыши...
procedure TForm1.ShellListView1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin

  // ...Mouse XButton1
  if (Button = mbExtra2) then
    goBack;

  // ...Mouse XButton2
  if (Button = mbExtra1) then
    goFwd;

end;

// Выполняется при нажатии на кнопку-стрелку "Назад"
procedure TForm1.ArrowBackClick(Sender: TObject);
begin
  goBack;
end;

// Выполняется при нажатии на кнопку-стрелку "Вперёд"
procedure TForm1.ArrowForwardClick(Sender: TObject);
begin
  goFwd;
end;

// Выполняется при нажатии на элемент ShellTreeView
procedure TForm1.ShellTreeView1Click(Sender: TObject);
begin
  PathEdit.Text := ShellListView1.Root;
end;

// Выполняется при двойном клике по ShellListView
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

// Выполняется во время изменения имени объекта ShellListView
procedure TForm1.ShellListView1Editing(Sender: TObject; Item: TListItem;
  var AllowEdit: boolean);
begin

  {Имя для переименования}
  OldName := ExtractFileName(Path);

end;

// Выполняется после изменения имени объекта ShellListView
procedure TForm1.ShellListView1Edited(Sender: TObject; Item: TListItem;
  var AValue: string);
begin

  {Переименование}
  RenameFile(ExtractFilePath(Path) + OldName, ExtractFilePath(Path) + AValue);

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

(* Меню "Создать" *)
// Создание папки
procedure TForm1.CleateFolderClick(Sender: TObject);
begin
  FileSystemModule.CleateFolder(ShellListView1.Root);
  Refresh;
end;

(* Удалить *)
procedure TForm1.DeleteMenuItemClick(Sender: TObject);
begin
  FileSystemModule.Delete(Path);
  Refresh;
end;

// Выполняется при нажатии кнопки "Перейти"
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
