unit FileSystemModule;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, Controls, ShellApi, LazUTF8;

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
  if MessageDlg('Удалить?',
    'Вы уверены, что хотите удалить этот файл?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    //if DirectoryExists(Path) then
      ShellExecute(0, nil, PChar('cmd'),
        PChar(UTF8toWinCP('/с rd /S /Q' + '"C:\Users\Timofei\Desktop\Новая папка"')), nil, 0)
    //else
    //  DeleteFile(Path);
end;

end.
