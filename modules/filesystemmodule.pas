unit FileSystemModule;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, Controls;

procedure CleateFolder(Root: string);
procedure Delete(Path: string);

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

procedure Delete(Path: string);
begin
  if MessageDlg('Удалить?', 'Вы уверены, что хотите удалить этот файл?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      DeleteFile(Path);
end;

end.
