unit uUserInfo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  uMethodsData, Vcl.Menus;

type
  TfrmUserInfo = class(TForm)
    edUserName: TEdit;
    btnSave: TButton;
    Label1: TLabel;
    Label2: TLabel;
    PopupMenu1: TPopupMenu;
    procedure btnSaveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function CheckUserName(UserName: string): Boolean;
  end;

var
  frmUserInfo: TfrmUserInfo;

implementation

{$R *.dfm}

uses
   uGame;




procedure TfrmUserInfo.btnSaveClick(Sender: TObject);
var
   UserInfo: TUserInfo;
   UserName: TUserName;
begin
   UserName := edUserName.Text;
   if CheckUserName(UserName) then
   begin
      UserInfo.UserName := UserName;
      UserInfo.UserPassedTime := frmGame.TotalGameTime;
      UserInfo.UserPassedLevels := frmGame.CurrentLevel;
      UserInfo.UserGameMode := GameMode;
      ListNodes.Add(UserInfo);
      ListNodes.WriteToFile();
   end
   else
   begin

   end;

end;

function TfrmUserInfo.CheckUserName(UserName: string): Boolean;
var
   IsCorrect: Boolean;
   i: Integer;
begin
   IsCorrect := Length(UserName) <= cnstMaxNameLength;
   i := 1;
   while IsCorrect and (i <= Length(UserName)) do
   begin
      IsCorrect := UserName[i] in ValidNameSymbols;
      Inc(i);
   end;
   CheckUserName := IsCorrect;
end;


end.
