unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ShellCtrls, ComCtrls,
  StdCtrls, ExtCtrls, Buttons, Menus, LazUTF8, ShellApi, Windows;

type

  { TForm1 }

  TForm1 = class(TForm)
    GoButton: TButton;
    MainMenu1: TMainMenu;
    CreateMenuItem: TMenuItem;
    DeleteMenuItem: TMenuItem;
    CreatePicture: TMenuItem;
    CreateWord: TMenuItem;
    CreatePowerPoint: TMenuItem;
    CreateText: TMenuItem;
    CreateExcel: TMenuItem;
    CreateAccess: TMenuItem;
    CopyMenuItem: TMenuItem;
    CutMenuItem: TMenuItem;
    CreatePopupMenuItem: TMenuItem;
    CreateFolderPopup: TMenuItem;
    CreateAccessPopup: TMenuItem;
    CreatePicturePupup: TMenuItem;
    CreateWordPopup: TMenuItem;
    CreatePowerPointPopup: TMenuItem;
    CreateTextPopup: TMenuItem;
    CreateExcelPopup: TMenuItem;
    CutPopupMenuItem: TMenuItem;
    CopyPopupMenuItem: TMenuItem;
    DeletePopupMenuItem: TMenuItem;
    PropertiesPopupMenuItem: TMenuItem;
    SortNonePopupMenuItem: TMenuItem;
    SortTextPopupMenuItem: TMenuItem;
    SortDataPopupMenuItem: TMenuItem;
    SortBothPopupMenuItem: TMenuItem;
    SortPopupMenuItem: TMenuItem;
    OpenPopupMenuItem: TMenuItem;
    SortMenuItem: TMenuItem;
    SortNone: TMenuItem;
    SortText: TMenuItem;
    SortData: TMenuItem;
    SortBoth: TMenuItem;
    Separator1: TMenuItem;
    ViewPopupMenuItem: TMenuItem;
    ViewIconPopup: TMenuItem;
    ViewListPopup: TMenuItem;
    ViewReportPopup: TMenuItem;
    ViewSmallIconPopup: TMenuItem;
    RefreshPopupMenuItem: TMenuItem;
    ShellListViewPopup: TPopupMenu;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    ViewMenuItem: TMenuItem;
    CreateFolder: TMenuItem;
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
    procedure CreateAccessClick(Sender: TObject);
    procedure CreateExcelClick(Sender: TObject);
    procedure CreateFolderClick(Sender: TObject);
    procedure CreatePictureClick(Sender: TObject);
    procedure CreatePowerPointClick(Sender: TObject);
    procedure CreateTextClick(Sender: TObject);
    procedure CreateWordClick(Sender: TObject);
    procedure CutMenuItemClick(Sender: TObject);
    procedure CopyMenuItemClick(Sender: TObject);
    procedure DeleteMenuItemClick(Sender: TObject);
    procedure PropertiesPopupMenuItemClick(Sender: TObject);
    procedure GoButtonClick(Sender: TObject);
    procedure RefreshPopupMenuItemClick(Sender: TObject);
    procedure ShellListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: boolean);
    procedure ShellListViewPopupPopup(Sender: TObject);
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
    procedure SortBothClick(Sender: TObject);
    procedure SortDataClick(Sender: TObject);
    procedure SortNoneClick(Sender: TObject);
    procedure SortTextClick(Sender: TObject);
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
  FwdPathArray: array of string; // Путь для кнопки вперёд

procedure goBack;
procedure goFwd;

implementation

uses FileSystemModule;

{$R *.lfm}

{ TForm1 }

// Выполняется при переходе на папку назад
procedure goBack;
begin
  try
    SetLength(FwdPathArray, Length(FwdPathArray) + 1);
    FwdPathArray[Length(FwdPathArray) - 1] := Form1.ShellListView1.Root;
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
      if Length(FwdPathArray) - 1 > 0 then
        Form1.ShellListView1.Root := FwdPathArray[Length(FwdPathArray) - 1];
      if Length(FwdPathArray) - 1 >= 0 then
        SetLength(FwdPathArray, Length(FwdPathArray) - 1);
      Form1.PathEdit.Text := Form1.ShellListView1.Root;
    except
    end;
end;

// Выполняется при выделении объека в ShellListView
procedure TForm1.ShellListView1SelectItem(Sender: TObject; Item: TListItem;
  Selected: boolean);
begin
  Path := ShellListView1.GetPathFromItem(Item);
  // Путь выделенного объекта
  StatusBar1.SimpleText := Path;
end;

// Выполняется при появлении контекстного меню
procedure TForm1.ShellListViewPopupPopup(Sender: TObject);
begin
  try
    // Если выделен файл
    if (ShellListView1.Selected <> nil) then
    begin
      OpenPopupMenuItem.Visible := True;
      CutPopupMenuItem.Visible := True;
      CopyPopupMenuItem.Visible := True;
      DeletePopupMenuItem.Visible := True;
      ViewPopupMenuItem.Visible := False;
      SortPopupMenuItem.Visible := False;
      CreatePopupMenuItem.Visible := False;
      RefreshPopupMenuItem.Visible := False;
    end

    // Если не выделен файл
    else
    begin
      OpenPopupMenuItem.Visible := False;
      CutPopupMenuItem.Visible := False;
      CopyPopupMenuItem.Visible := False;
      DeletePopupMenuItem.Visible := False;
      ViewPopupMenuItem.Visible := True;
      SortPopupMenuItem.Visible := True;
      CreatePopupMenuItem.Visible := True;
      RefreshPopupMenuItem.Visible := True;
    end;
  except
  end;
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

(* Меню "Сортировать" *)

// Не сортировать
procedure TForm1.SortNoneClick(Sender: TObject);
begin
  ShellListView1.SortType := stNone;
end;
// По имени
procedure TForm1.SortTextClick(Sender: TObject);
begin
  ShellListView1.SortType := stText;
end;
// По размеру
procedure TForm1.SortDataClick(Sender: TObject);
begin
  ShellListView1.SortType := stData;
end;
// По имени и размеру
procedure TForm1.SortBothClick(Sender: TObject);
begin
  ShellListView1.SortType := stBoth;
end;

(* Меню "Создать" *)
// Создание Папки
procedure TForm1.CreateFolderClick(Sender: TObject);
begin
  FileSystemModule.CreateFolder(ShellListView1.Root);
  FileSystemModule.Refresh(ShellListView1);
end;

// Создание Microsoft Access Базы данных
procedure TForm1.CreateAccessClick(Sender: TObject);
begin
  FileSystemModule.CreateAccess(ShellListView1.Root);
  FileSystemModule.Refresh(ShellListView1);
end;

// Создание Точечного рисунка
procedure TForm1.CreatePictureClick(Sender: TObject);
begin
  FileSystemModule.CreatePicture(ShellListView1.Root);
  FileSystemModule.Refresh(ShellListView1);
end;

// Создание Документа Microsoft Word
procedure TForm1.CreateWordClick(Sender: TObject);
begin
  FileSystemModule.CreateWord(ShellListView1.Root);
  FileSystemModule.Refresh(ShellListView1);
end;

// Создание Презентации Microsoft PowerPoint
procedure TForm1.CreatePowerPointClick(Sender: TObject);
begin
  FileSystemModule.CreatePowerPoint(ShellListView1.Root);
  FileSystemModule.Refresh(ShellListView1);
end;

// Создание Текстового документа
procedure TForm1.CreateTextClick(Sender: TObject);
begin
  FileSystemModule.CreateText(ShellListView1.Root);
  FileSystemModule.Refresh(ShellListView1);
end;

// Создание Листа Microsoft Excel
procedure TForm1.CreateExcelClick(Sender: TObject);
begin
  FileSystemModule.CreateExcel(ShellListView1.Root);
  FileSystemModule.Refresh(ShellListView1);
end;

(* Вырезать *)
procedure TForm1.CutMenuItemClick(Sender: TObject);
var
  i: integer;
  FilesList: TStringList;
begin
  FilesList := TStringList.Create;
  for i := 0 to ShellListView1.Items.Count - 1 do
  begin
    if ShellListView1.Items[i].Selected then
      FilesList.Add(ShellListView1.GetPathFromItem(ShellListView1.Items[i]));
  end;
  if SelectDirectoryDialog1.Execute then
    FileSystemModule.Cut(FilesList, SelectDirectoryDialog1.FileName);
  FileSystemModule.Refresh(ShellListView1);
end;

(* Копировать *)
procedure TForm1.CopyMenuItemClick(Sender: TObject);
var
  i: integer;
  FilesList: TStringList;
begin
  FilesList := TStringList.Create;
  for i := 0 to ShellListView1.Items.Count - 1 do
  begin
    if ShellListView1.Items[i].Selected then
      FilesList.Add(ShellListView1.GetPathFromItem(ShellListView1.Items[i]));
  end;
  if SelectDirectoryDialog1.Execute then
    FileSystemModule.Copy(FilesList, SelectDirectoryDialog1.FileName);
end;

(* Удалить *)
procedure TForm1.DeleteMenuItemClick(Sender: TObject);
var
  i: integer;
  Fileslist: TStringList;
begin
  FilesList := TStringList.Create;
  for i := 0 to ShellListView1.Items.Count - 1 do
  begin
    if ShellListView1.Items[i].Selected then
      FilesList.Add(ShellListView1.GetPathFromItem(ShellListView1.Items[i]));
  end;
  FileSystemModule.Delete(FilesList);
  FileSystemModule.Refresh(ShellListView1);
end;

(* Свойства *)
procedure TForm1.PropertiesPopupMenuItemClick(Sender: TObject);
var
  Properties: SHELLEXECUTEINFOW;
begin
  ZeroMemory(@Properties, SizeOf(Properties));
  with Properties do
  begin
    cbSize := SizeOf(Properties);
    if (ShellListView1.Selected <> nil) then
      lpFile := PWideChar(WideString(Path)) // путь к папке
    else
      lpFile := PWideChar(WideString(ShellListView1.Root)); // путь к папке
    nShow := SW_SHOW;
    fMask := SEE_MASK_INVOKEIDLIST;
    lpVerb := 'Properties';
  end;
  ShellExecuteExW(@Properties);
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

procedure TForm1.RefreshPopupMenuItemClick(Sender: TObject);
begin
  FileSystemModule.Refresh(ShellListView1);
end;

end.
