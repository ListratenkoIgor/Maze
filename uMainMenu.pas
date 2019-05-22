unit uMainMenu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,uGame,Unit4;

type
   TForm3 = class(TForm)
      btnNewGame: TButton;
      btnLoad: TButton;
      procedure btnNewGameClick(Sender: TObject);
   private
      { Private declarations }

   public
      { Public declarations }
      function ReadFromFile(FileName: string):Boolean;
      procedure AppEventsException(Sencier: TObject; E: Exception);

   end;

TLevelState = (lvlstUser,lvlstDesigner);

var
  Form3: TForm3;
  CurrentLevel: Integer;

implementation

{$R *.dfm}

procedure TForm3.AppEventsException(Sencier: TObject; E: Exception);
begin
     if E is EInOutError then
     case EInOutError(E).ErrorCode of
        100: E.Message := sEOF;
        101: E.Message := SysErrorMessage(Error_Disk_Full);
        102: E.Message := sNotAssigned;
        103: E.Message := sNotOpen;
        104: E.Message := sNotRead;
        105: E.Message := sNotWrite;
        106: E.Message := SBadRead;
        else E.Message := SysErrorMessage(EInOutError(E).ErrorCode);
     end;
     Application.ShowException(E);
end;

function TForm3.ReadFromFile(FileName: string): Boolean;
function OrdToElement(Temp: Byte):TElement;
begin
   case Temp of
      0:Result := elFree;
      1:Result := elWall;
      2:Result := elWater;
      3:Result := elInvFree;
      4:Result := elInvWall;
      5:Result := elHeart;
      6:Result := elEnergy;
      7:Result := elExit;
      8:Result := elBall;
      9:Result := elWaterBall;
   end;
end;
var
   UserFile: TextFile;
   LevelIndex,LevelCount,i,j: Integer;
   TempOrdElement: Byte;
//   TestChar:Char;
begin
   AssignFile(UserFile,FileName);
   //fileexists check
   {I-}
   try
      Reset(UserFile);
   except
      //CloseFile(UserFile);
      on E:Exception do
         AppEventsException(Self,E);
      else
         //Unexpected   e.rror
      ;
      CloseFile(UserFile);
   end;
   try
//      Read(UserFile,testchar);
      Read(UserFile,LevelCount);
      if not (LevelCount in [1..MaxLevel]) then
         Abort;
      Setlength(LevelArray,LevelCount);
      for LevelIndex := 0 to High(LevelArray) do
      begin
         Readln(UserFile,LevelArray[LevelIndex].TotalHearts);
         Readln(UserFile,LevelArray[LevelIndex].StartEnergy);
         Readln(UserFile,LevelArray[LevelIndex].InitialX);
         Readln(UserFile,LevelArray[LevelIndex].InitialY);
         for i := 0 to MapHeight - 1 do
         begin
            for j := 0 to MapWidth - 1 do
            begin
               Read(UserFile,TempOrdElement);
               LevelArray[LevelIndex].LevelMap[i,j]:=OrdToElement(TempOrdElement);
            end;
            Readln(UserFile);
         end;
         Readln(UserFile,LevelArray[LevelIndex].Comment);
         Readln(UserFile,LevelArray[LevelIndex].Title);
      end;
      Result := True;
   {I+}
   //ioresultCheck
   except
      //myexception;
      Result :=False;
   end;
   CloseFile(Userfile);
end;


procedure TForm3.btnNewGameClick(Sender: TObject);
begin
{   MyLevel.TotalHearts := 36;
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
   LevelArray[1]:=MyLevel;//       }
   //Self.Hide;
   //ReadFromFile('Blip.dat');
   fmGame.ShowModal;
   //Self.Show;
   Self.Enabled:= True;
end;

end.
