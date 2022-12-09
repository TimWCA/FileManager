unit FileSystemModule;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, Controls, ShellApi, FileUtil, Forms, ShellCtrls;

procedure CleateFolder(Root: string);
procedure Delete(Path: string);
procedure Refresh(ShellListView: TShellListView);

implementation

// Создаёт папки
procedure CleateFolder(Root: string);
var
  i: integer = 1;
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
var tempPath: string;
begin
  tempPath := ShellListView.Root;
  ShellListView.Root := '';
  ShellListView.Root := tempPath;
end;

end.
