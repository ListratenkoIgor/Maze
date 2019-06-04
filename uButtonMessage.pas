unit uButtonMessage;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type
  TfrmButtonMessage = class(TForm)
    pnlBackground: TPanel;
    lbComment: TLabel;
    bitbtnAccept: TBitBtn;
    procedure bitbtnAcceptClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmButtonMessage: TfrmButtonMessage;

implementation

{$R *.dfm}
uses
   uGame;

procedure TfrmButtonMessage.bitbtnAcceptClick(Sender: TObject);
begin
///   frmGame.Timer.Enabled := True;
   frmGame.Enabled := True;
   Self.Close;
end;

procedure TfrmButtonMessage.FormShow(Sender: TObject);
begin
   Self.Left := frmGame.Left+(frmGame.Width - Self.Width) div 2;
   Self.Top := frmGame.Top+(frmGame.Height - Self.Height) div 2;
   lbComment.Left := (pnlBackGround.Width-lbComment.Width) div 2;
end;

end.
