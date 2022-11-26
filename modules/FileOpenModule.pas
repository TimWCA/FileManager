unit FileOpenModule;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Process;

procedure FileOpen(Path: string);

implementation

procedure FileOpen(Path: string);
begin

  if (ExtractFileExt(Path) = '.exe') then
  begin
    with TProcess.Create(nil) do
      try
        Executable := Path;
        Execute;
      finally
        Free;
      end;
  end;

  if (ExtractFileExt(Path) = '.txt') then
  begin
    with TProcess.Create(nil) do
      try
        Executable := 'notepad.exe';
        Parameters.Add(Path);
        Execute;
      finally
        Free;
      end;
  end;

end;

end.
