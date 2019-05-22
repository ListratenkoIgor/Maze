unit uMainMenu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtDlgs,Vcl.MPlayer
  ,uGame,uDesigner,uScores,uMethodsData;

type
   TfrmMain = class(TForm)
      btnNewGame: TButton;
      btnLoad: TButton;
    dlgOpenFile: TOpenTextFileDialog;
    btnDesigner: TButton;
    btnScore: TButton;
    procedure btnNewGameClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure btnDesignerClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
   private
      { Private declarations }

   public
      { Public declarations }
      function ReadFromFile(FileName: string):Boolean;


   end;

TLevelState = (lvlstUser,lvlstDesigner);

var
  frmMain: TfrmMain;
//  CurrentLevel: Integer;

implementation

{$R *.dfm}


function TfrmMain.ReadFromFile(FileName: string): Boolean;
function OrdToElement(Temp: Byte): TElement;
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
   else
//      raise EIncorrectFileData.Create('');
   end;
end;
var
   UserFile: TextFile;
   LevelIndex,LevelCount,i,j: Integer;
   TempOrdElement: Byte;
   TempTotalHearts,TempInitialX,TempInitialY: Integer;
   IsFileOpen,IsBallExist,IsExitExist: Boolean;
   TempLevelArray: TLevelArray;
begin
   IsFileOpen:=False;
   if FileExists(FileName) then
   begin
      AssignFile(UserFile,FileName);
      try
         if Copy(FileName,Length(FileName)-3,4) <> LevelsFileFormat then
            raise EIncorrectFileFormat.Create('');
         Reset(UserFile);
         IsFileOpen := True;
      except
         on E: Exception do
         begin
            uMethodsData.AppEventsException(Self,E);
            ReadFromFile := False;
         end;
      end;
   end
   else
   begin
      ReadFromFile := False;
      MessageBox(Self.Handle,PWideChar(sFileNotExist),'Error',mb_Ok+mb_IconError+mb_ApplModal);
   end;
   if IsFileOpen then
   begin
      try
         Read(UserFile,LevelCount);
         if not (LevelCount in [1..cnstMaxLevel]) then
            raise EIncorrectFileData.Create('');
         Setlength(TempLevelArray,LevelCount);
         for LevelIndex := 0 to High(TempLevelArray) do
         begin
            Readln(UserFile,TempLevelArray[LevelIndex].TotalHearts);
            Readln(UserFile,TempLevelArray[LevelIndex].StartEnergy);
            Readln(UserFile,TempLevelArray[LevelIndex].InitialX);
            Readln(UserFile,TempLevelArray[LevelIndex].InitialY);
            IsBallExist := False;
            IsExitExist := False;
            TempTotalHearts := 0;
            for i := 0 to MapHeight - 1 do
            begin
               for j := 0 to MapWidth - 1 do
               begin
                  Read(UserFile,TempOrdElement);
                  TempLevelArray[LevelIndex].LevelMap[i,j] := OrdToElement(TempOrdElement);
                  case TempLevelArray[LevelIndex].LevelMap[i,j] of
                     elHeart:
                     begin
                        Inc(TempTotalHearts);
                     end;
                     elBall:
                     begin
                        if not IsBallExist then
                        begin
                           IsBallExist := True;
                           TempInitialX := i;
                           TempInitialY := j;
                        end
                        else
                           raise EIncorrectFileData.Create('');
                     end;
                     elWaterBall:
                     begin
                        if not IsBallExist then
                        begin
                           IsBallExist := True;
                           TempInitialX := i;
                           TempInitialY := j;
                        end
                        else
                           raise EIncorrectFileData.Create('');
                     end;
                     elExit:
                     begin
                        IsExitExist := True;
                     end;
                     //check this
                  end;
               end;
               Readln(UserFile);
            end;
            if TempTotalHearts <> TempLevelArray[LevelIndex].TotalHearts then
               raise EIncorrectFileData.Create('');
            if not (IsBallExist and IsExitExist) then
               raise EIncorrectFileData.Create('');
            if not(TempLevelArray[LevelIndex].StartEnergy in [1..cnstMaxEnergy]) then
               raise EIncorrectFileData.Create('');
            if TempInitialX <> TempLevelArray[LevelIndex].InitialX then
               raise EIncorrectFileData.Create('');
            if TempInitialY <> TempLevelArray[LevelIndex].InitialY then
               raise EIncorrectFileData.Create('');
            Readln(UserFile,TempLevelArray[LevelIndex].Comment);
            Readln(UserFile,TempLevelArray[LevelIndex].Title);
         end;
         ReadFromFile := True;
         LevelArray := TempLevelArray;
      {I+}
      //ioresultCheck
      except
          //myexception;
         on E: Exception do
         begin
            ReadFromFile := False;
            AppEventsException(Self,E);
         end;
      end;
      CloseFile(Userfile);
   end;
end;



procedure TfrmMain.btnLoadClick(Sender: TObject);
begin
   if dlgOpenFile.Execute then
   begin
      if ReadFromFile(dlgOpenFile.FileName) then
      begin
         //Exit;
         GameMode := gmUser;
         Self.Hide;
         frmGame.Show;

      end;
//      Lives := 3;
//      CurrentLevel := 1;

   end;



end;

procedure TfrmMain.btnNewGameClick(Sender: TObject);
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
   if FileExists(MainFile) then
   begin
      ReadFromFile(MainFile);
//      Lives := 3;
//      CurrentLevel := 1;
      GameMode := gmStory;
      Self.Hide;
      frmGame.Show;
   end
   else
   begin
      raise ECriticalDataLoss.Create(sCriticalDataLoss);
   end;
   //Self.Show;
   //Self.Enabled:= True;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   ListNodes.Destroy;
end;

procedure TfrmMain.btnDesignerClick(Sender: TObject);
begin
   Self.Hide;
   frmDesigner.Show;
end;

end.
