unit uUserInfo;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  uMethodsData, Vcl.Menus, Vcl.ExtCtrls, Vcl.Imaging.jpeg , PngImage;

type
  TEndState = (estLose,estWin);
  TfrmUserInfo = class(TForm)
    edUserName: TEdit;
    btnSave: TButton;
    lbEnterName: TLabel;
    PopupMenu1: TPopupMenu;
    imBackground: TImage;
    procedure btnSaveClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  frmUserInfo: TfrmUserInfo;
  EndState: TEndState;



implementation

{$R *.dfm}

uses uGame;




procedure TfrmUserInfo.btnSaveClick(Sender: TObject);
var
   UserInfo: TUserInfo;
   UserName: TUserName;
   InvalidUserName: string;
begin
   UserName := edUserName.Text;
   if ListNodes.CheckUserName(UserName) then
   begin
      UserInfo.UserName := UserName;
      UserInfo.UserPassedTime := frmGame.TotalGameTime;
      UserInfo.UserPassedLevels := frmGame.CurrentLevel - 1;
      UserInfo.UserGameMode := GameMode;
      ListNodes.Add(UserInfo);
      ListNodes.WriteToFile();
      Self.Close;
   end
   else
   begin
      if not (Length(UserName) <= cnstMaxNameLength) and (Length(UserName) > 0) then
         InvalidUserName := sInvalidUserNameLength
      else
         InvalidUserName := sInvalidUserNameSymbols;
      MessageBox(Self.Handle,PWideChar(InvalidUserName),'Error',msgErrorProperty);
   end;

end;




procedure TfrmUserInfo.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
//
end;

procedure TfrmUserInfo.FormShow(Sender: TObject);
var
   imPNG: TPngImage;
begin
   btnSave.SetFocus;
   btnSave.Left := edUserName.Left + (edUserName.Width - btnSave.Width) div 2;
   imPNG := TPngImage.Create;
   if EndState = estLose then
      imPng.LoadFromResourceName(HInstance,'imGameOver')
   else
      imPng.LoadFromResourceName(HInstance,'imVictory');
   imBackground.Picture.Graphic := imPng;
   imPng.Free;
end;

end.
