unit FileSystemModule;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, Controls, ShellApi, FileUtil, Forms, ShellCtrls;

procedure CleateFolder(Root: string);
procedure CleateAccess(Root: string);
procedure CleatePicture(Root: string);
procedure CleateWord(Root: string);
procedure CleatePowerPoint(Root: string);
procedure CleateText(Root: string);
procedure CleateExcel(Root: string);
procedure Delete(Path: string);
procedure Refresh(ShellListView: TShellListView);
procedure Copy(PathFrom: string; PathTo: String);
procedure Copy(PathFromArray: array of string; PathTo: string);

implementation

// Создаёт Папки
procedure CleateFolder(Root: string);
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
procedure CleateAccess(Root: string);
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
procedure CleatePicture(Root: string);
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
procedure CleateWord(Root: string);
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
procedure CleatePowerPoint(Root: string);
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
procedure CleateText(Root: string);
var
  f: TextFile;
  i: integer = 2;
begin
  if not FileExists(Root + '\Новый текстовый документ' + '.txt') then
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
procedure CleateExcel(Root: string);
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
    while FileExists(Root + '\Лист Microsoft Excel (' +
        IntToStr(i) + ')' + '.xlsx') do
      Inc(i);
    AssignFile(f, Root + '\Лист Microsoft Excel (' +
      IntToStr(i) + ')' + '.xlsx');
    Rewrite(f);
    CloseFile(f);
  end;
end;

// Удаляет файлы и папки
procedure Delete(Path: string);
begin
  if MessageDlg('Удалить?',
    'Вы уверены, что хотите удалить этот файл?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    if DirectoryExists(Path) then
      DeleteDirectory(Path, False)
    else
      DeleteFile(Path);
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

procedure Copy(PathFrom: String; PathTo:String);
var
  i: integer = 2;
begin
  if not FileExists(PathTo + ExtractFileName(PathFrom)) then
    CopyFile(PathFrom, PathTo + ExtractFileName(PathFrom))
  else
  begin
    while FileExists(PathTo + ExtractFileName(PathFrom) + inttostr(i)) do
      Inc(i);
    CopyFile(PathFrom, PathTo + ExtractFileName(PathFrom) + inttostr(i));
  end;
end;

procedure Copy(PathFromArray: array of string; PathTo: string);
end.
