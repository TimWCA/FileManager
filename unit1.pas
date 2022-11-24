unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ShellCtrls, ComCtrls,
  StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    ComboBox1: TComboBox;
    Label1: TLabel;
    ShellListView1: TShellListView;
    ShellTreeView1: TShellTreeView;
    StatusBar1: TStatusBar;
    ToolBar1: TToolBar;
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Select(Sender: TObject);
    procedure ShellListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.ShellListView1SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  StatusBar1.SimpleText:=ShellListView1.GetPathFromItem(Item);

end;

procedure TForm1.ComboBox1Select(Sender: TObject);
begin
  case ComboBox1.ItemIndex of
  0: ShellListView1.ViewStyle:=vsIcon;
  1: ShellListView1.ViewStyle:=vsList;
  2: ShellListView1.ViewStyle:=vsReport;
  3: ShellListView1.ViewStyle:=vsSmallIcon;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  try
    ShellListView1.Root:=StatusBar1.SimpleText;
  except
    on E: EInvalidPath do
      ShowMessage('Я ещё не умею открывать файлы :(');
  end;
end;


end.

