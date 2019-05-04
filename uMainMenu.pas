unit uMainMenu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,uGame,Unit4;

type
  TForm3 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;
  CurrentLevel: Integer;

implementation

{$R *.dfm}

procedure TForm3.Button1Click(Sender: TObject);
begin
   MyLevel.TotalHearts := 36;
   MyLevel.StartEnergy := 50;
   MyLevel.InitialX := 2;
   MyLevel.InitialY := 2;
   MyLevel.LevelMap := MyMap;
   MyLevel.Comment := 'Это должно быть легко))))))))))))))';
   MyLevel.Title := 'Здесь могла быть ваша реклама';
   Self.Enabled:= False;
   CurrentLevel := 1;
   Setlength(LevelArray,2);
   LevelArray[0]:=MyLevel;//
   LevelArray[1]:=MyLevel;//
   //Self.Hide;
   fmGame.ShowModal;
   //Self.Show;
   Self.Enabled:= True;
end;

end.
