unit uHelp;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, JPEG,
  Vcl.ExtCtrls,PngImage;

type
  TfrmHelp = class(TForm)
    pgcHelp: TPageControl;
    pgGameHelp: TTabSheet;
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    Memo4: TMemo;
    Memo5: TMemo;
    Memo6: TMemo;
    Memo7: TMemo;
    Memo8: TMemo;
    txtElements: TStaticText;
    pgDesignerHelp: TTabSheet;
    imDesigner: TImage;
    txtUserHelp: TStaticText;
    imFree: TImage;
    imEskela: TImage;
    imWall: TImage;
    imWater: TImage;
    imInvFree: TImage;
    imHeart: TImage;
    imEnergy: TImage;
    imExit: TImage;
    imInvWall: TImage;
    Memo9: TMemo;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    procedure FormShow(Sender: TObject);
    procedure pgDesignerHelpShow(Sender: TObject);
    procedure MemoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MemoDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmHelp: TfrmHelp;

implementation

{$R *.dfm}

procedure TfrmHelp.FormShow(Sender: TObject);

begin
   pgcHelp.ActivePageIndex := 0;

   Memo1.Clear;Memo2.Clear;Memo3.Clear;Memo4.Clear;Memo5.Clear;Memo6.Clear;Memo7.Clear;Memo8.Clear;
   Memo1.Lines.Add('');
   Memo1.Lines.Add('');
   Memo1.Lines[0] := 'Hello! It`s me - Marrrrrio...Oh wait...It`s another universe.My name is Eskela.Well at least I remember my name.I quarreled a little with one witch.She stole my heart,turned into some ';
   Memo1.Lines[2] := 'kind of ball and threw in this strange place.I fell tired and don`t know where am i and where to go. Could this day get any worse?';
   Memo2.Lines[0] := 'It is free cells and i actually can pass,run,jump,and dance on them.';
   Memo3.Lines[0] := 'It`s wall...In childhood I ran into one and wasn`t very pleased.Head buzzed all day.';
   Memo4.Lines.Add('');
   Memo4.Lines[0] := 'It`s water. I very don`t like swim. It`s hard and energy-intensive.';
   Memo4.Lines[1] := '(Spend 5 energy in water for every move)';
   Memo5.Lines.Add('');
   Memo5.Lines[0] := 'Mother told me about some magical anomalies, when seemingly ordinary passage turned';
   Memo5.Lines[1] := 'out to be a wall. And vice versa. It was easy to walk through the wall without effort.';
   Memo6.Lines.Add('');
   Memo6.Lines[0] := 'My heart...Or rather part of it. Plague-Del-Cake (i know funny name for wicked witch) tore';
   Memo6.Lines[1] := 'my heart into Horcruses. And if i don`t put them together, i will die.';
   Memo7.Lines.Add('');
   Memo7.Lines[0] := 'Energy. it`s the one that allows me to go further and doesn`t allow me to "deflate".';
   Memo7.Lines[1] := '(gives 20 energy and sorry for this pun)';
   Memo8.Lines.Add('');
   Memo8.Lines[0] := 'Exit (I hope). It is a teleport that will throw me somewhere else. The Main thing in not forget';
   Memo8.Lines[1] := 'to collect all pieces of my heart.';

end;

procedure TfrmHelp.MemoDblClick(Sender: TObject);
begin
   if Sender is TMemo then
      with Sender as TMemo do
      begin
         Enabled := False;
         Enabled := True;
      end;
end;

procedure TfrmHelp.MemoMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   if Sender is TMemo then
      with Sender as TMemo do
      begin
         Enabled := False;
         Enabled := True;
      end;
end;

procedure TfrmHelp.pgDesignerHelpShow(Sender: TObject);
var
   imPNG: TPngImage;
begin
   imPNG := TPngImage.Create;
   imPng.LoadFromResourceName(HInstance,'imDesignerExample');
   imDesigner.Picture.Graphic := imPng;
   imPng.Free;
end;

end.
