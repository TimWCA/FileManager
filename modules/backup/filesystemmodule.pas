unit FileSystemModule;

{$mode ObjFPC}{$H+}

interface
procedure CleateFolder(Root: string);
uses
  Classes, SysUtils;

implementation

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

