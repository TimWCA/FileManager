unit FileSystemModule;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, Controls, ShellCtrls, LazFileUtils, FileUtil,
  Forms;

procedure CreateFolder(Root: string);
procedure CreateAccess(Root: string);
procedure CreatePicture(Root: string);
procedure CreateWord(Root: string);
procedure CreatePowerPoint(Root: string);
procedure CreateText(Root: string);
procedure CreateExcel(Root: string);
procedure Cut(PathFromList: TStringList; PathTo: string);
procedure Copy(PathFromList: TStringList; PathTo: string);
procedure CopyDir(PathFrom: string; PathTo: string);
procedure Delete(Path: string);
procedure Refresh(ShellListView: TShellListView);

implementation

// Создаёт Папки
procedure CreateFolder(Root: string);
var
  i: integer = 2;
begin
  if not DirectoryExists(Root + '\Новая папка') then
    CreateDir(Root + '\Новая папка')
  else
  begin
    while DirectoryExists(Root + '\Новая папка (' +
        IntToStr(i) + ')') do
      Inc(i);
    CreateDir(Root + '\Новая папка (' + IntToStr(i) + ')');
  end;
end;

// Создает Microsoft Access Базы данных
procedure CreateAccess(Root: string);
var
  f: TextFile;
  i: integer = 2;
begin
  if not FileExists(Root + '\Microsoft Access База данных' + '.accdb') then
  begin
    AssignFile(f, Root + '\Microsoft Access База данных' + '.accdb');
    Rewrite(f);
    CloseFile(f);
  end
  else
  begin
    while FileExists(Root + '\Microsoft Access База данных (' +
        IntToStr(i) + ')' + '.accdb') do
      Inc(i);
    AssignFile(f, Root + '\Microsoft Access База данных (' +
      IntToStr(i) + ')' + '.accdb');
    Rewrite(f);
    CloseFile(f);
  end;
end;

// Создает Точечные рисунки
procedure CreatePicture(Root: string);
var
  f: TextFile;
  i: integer = 2;
begin
  if not FileExists(Root + '\Новый точечный рисунок' + '.bmp') then
  begin
    AssignFile(f, Root + '\Новый точечный рисунок' + '.bmp');
    Rewrite(f);
    CloseFile(f);
  end
  else
  begin
    while FileExists(Root + '\Новый точечный рисунок (' +
        IntToStr(i) + ')' + '.bmp') do
      Inc(i);
    AssignFile(f, Root + '\Новый точечный рисунок (' +
      IntToStr(i) + ')' + '.bmp');
    Rewrite(f);
    CloseFile(f);
  end;
end;

// Создает Документы Microsoft Word
procedure CreateWord(Root: string);
var
  f: TextFile;
  i: integer = 2;
begin
  if not FileExists(Root + '\Документ Microsoft Word' + '.docx') then
  begin
    AssignFile(f, Root + '\Документ Microsoft Word' + '.docx');
    Rewrite(f);
    CloseFile(f);
  end
  else
  begin
    while FileExists(Root + '\Документ Microsoft Word (' +
        IntToStr(i) + ')' + '.docx') do
      Inc(i);
    AssignFile(f, Root + '\Документ Microsoft Word (' +
      IntToStr(i) + ')' + '.docx');
    Rewrite(f);
    CloseFile(f);
  end;
end;

// Создает Презентации Microsoft PowerPoint
procedure CreatePowerPoint(Root: string);
var
  f: TextFile;
  i: integer = 2;
begin
  if not FileExists(Root + '\Презентация Microsoft PowerPoint' + '.pptx') then
  begin
    AssignFile(f, Root + '\Презентация Microsoft PowerPoint' + '.pptx');
    Rewrite(f);
    CloseFile(f);
  end
  else
  begin
    while FileExists(Root + '\Презентация Microsoft PowerPoint (' +
        IntToStr(i) + ')' + '.pptx') do
      Inc(i);
    AssignFile(f, Root + '\Презентация Microsoft PowerPoint (' +
      IntToStr(i) + ')' + '.pptx');
    Rewrite(f);
    CloseFile(f);
  end;
end;

// Создает Текстовые документы
procedure CreateText(Root: string);
var
  f: TextFile;
  i: integer = 2;
begin
  if not FileExists(Root + '\Новый текстовый документ' +
    '.txt') then
  begin
    AssignFile(f, Root + '\Новый текстовый документ' + '.txt');
    Rewrite(f);
    CloseFile(f);
  end
  else
  begin
    while FileExists(Root + '\Новый текстовый документ (' +
        IntToStr(i) + ')' + '.txt') do
      Inc(i);
    AssignFile(f, Root + '\Новый текстовый документ (' +
      IntToStr(i) + ')' + '.txt');
    Rewrite(f);
    CloseFile(f);
  end;
end;

// Создает Листы Microsoft Excel
procedure CreateExcel(Root: string);
var
  f: TextFile;
  i: integer = 2;
begin
  if not FileExists(Root + '\Лист Microsoft Excel' + '.xlsx') then
  begin
    AssignFile(f, Root + '\Лист Microsoft Excel' + '.xlsx');
    Rewrite(f);
    CloseFile(f);
  end
  else
  begin
    while FileExists(Root + '\Лист Microsoft Excel (' + IntToStr(i) +
        ')' + '.xlsx') do
      Inc(i);
    AssignFile(f, Root + '\Лист Microsoft Excel (' + IntToStr(i) +
      ')' + '.xlsx');
    Rewrite(f);
    CloseFile(f);
  end;
end;

// Вырезает файлы
procedure Cut(PathFromList: TStringList; PathTo: string);
var
  i: integer;
  j: integer = 2;
begin
  for i := 0 to PathFromList.Count - 1 do
    if not FileExists(PathTo + '\' + ExtractFileName(PathFromList[i])) then
      RenameFileUTF8(PathFromList[i], PathTo + '\' + ExtractFileName(PathFromList[i]))
    else
    begin
      while FileExists(PathTo + '\' + ExtractFileName(
          LazFileUtils.ExtractFileNameWithoutExt(PathFromList[i])) +
          ' (' + IntToStr(j) + ')' + ExtractFileExt(PathFromList[i])) do
        Inc(j);
      RenameFile(PathFromList[i], PathTo + '\' +
        ExtractFileName(LazFileUtils.ExtractFileNameWithoutExt(PathFromList[i])) +
        ' (' + IntToStr(j) + ')' + ExtractFileExt(PathFromList[i]));
    end;
end;

// Копирует файлы
procedure Copy(PathFromList: TStringList; PathTo: string);
var
  i: integer;
  j: integer = 2;
begin
  for i := 0 to PathFromList.Count - 1 do
    if DirectoryExists(PathFromList[i]) then
      CopyDir(PathFromList[i], PathTo)
    else
    if not FileExists(PathTo + '\' + ExtractFileName(PathFromList[i])) then
      CopyFile(PathFromList[i], PathTo + '\' + ExtractFileName(PathFromList[i]))
    else
    begin
      while FileExists(PathTo + '\' + ExtractFileName(
          LazFileUtils.ExtractFileNameWithoutExt(PathFromList[i])) +
          ' (' + IntToStr(j) + ')' + ExtractFileExt(PathFromList[i])) do
        Inc(j);
      CopyFile(PathFromList[i], PathTo + '\' +
        ExtractFileName(LazFileUtils.ExtractFileNameWithoutExt(PathFromList[i])) +
        ' (' + IntToStr(j) + ')' + ExtractFileExt(PathFromList[i]));
    end;
end;

// Копирует одну папку
procedure CopyDir(PathFrom: string; PathTo: string);
var
  j: integer = 2;
begin
  if not DirectoryExists(PathTo + '\' + ExtractFileName(PathFrom)) then
    CopyDirTree(PathFrom, PathTo + '\' + ExtractFileName(PathFrom))
  else
  begin
    while DirectoryExists(PathTo + '\' + ExtractFileName(PathFrom) +
        ' (' + IntToStr(j) + ')') do
      Inc(j);
    CopyDirTree(PathFrom, PathTo + '\' + ExtractFileName(PathFrom) +
      ' (' + IntToStr(j) + ')');
  end;
end;

// Удаляет файлы и папки
procedure Delete(PathList: TStringList);
var
  i: integer;
begin
  if MessageDlg('Удалить?',
    'Вы уверены, что хотите безвозвратно удалить ' +
    IntToStr(PathList.Count) + ' файлов (папок)?', mtConfirmation,
    [mbYes, mbNo], 0) = mrYes then
    for i := 0 to PathList.Count - 1 do
    if DirectoryExists(PathList[i]) then
      DeleteDirectory(PathList[i], False)
    else
      DeleteFile(PathList[i]);
end;

// Обновляет содержимое ShellListView
procedure Refresh(ShellListView: TShellListView);
var
  tempPath: string;
begin
  tempPath := ShellListView.Root;
  ShellListView.Root := '';
  ShellListView.Root := tempPath;
end;

end.
