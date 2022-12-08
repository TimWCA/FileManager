unit FileSystemModule;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

procedure CleateFolder(Root: string);
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
    CreateDir(Root + '\Новая папка (' +
      IntToStr(i) + ')');
  end;
end;

end.

