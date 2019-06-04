unit uMainMenu;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtDlgs,Vcl.MPlayer
  ,uGame,uHelp,uDesigner,uScores,uMethodsData,PngImage, Vcl.ExtCtrls,
  Vcl.Buttons, Vcl.Imaging.jpeg;

type
   TfrmMain = class(TForm)
    dlgOpenFile: TOpenTextFileDialog;
    Image1: TImage;
    spdbtnExit: TSpeedButton;
    spdbtnHelp: TSpeedButton;
    spdbtnLoadGame: TSpeedButton;
    spdbtnScore: TSpeedButton;
    spdbtnDesigner: TSpeedButton;
    spdbtnNewGame: TSpeedButton;
    procedure btnNewGameClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure btnDesignerClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnScoreClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure imQuestionClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
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
      raise EIncorrectFileData.Create('');
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



procedure TfrmMain.btnExitClick(Sender: TObject);
begin
   Self.Close;
end;

procedure TfrmMain.btnLoadClick(Sender: TObject);
begin
   if dlgOpenFile.Execute then
   begin
      if ReadFromFile(dlgOpenFile.FileName) then
      begin
         GameMode := gmUser;
         Self.Visible := False;
         frmGame.Show;
      end;
   end;
end;

procedure TfrmMain.btnNewGameClick(Sender: TObject);
begin
   if FileExists(MainFile) then
   begin
      ReadFromFile(MainFile);
      GameMode := gmStory;
      Self.Visible := False;
      frmGame.ShowModal;
   end
   else
   begin
      raise ECriticalDataLoss.Create(sCriticalDataLoss);
   end;
end;

procedure TfrmMain.btnScoreClick(Sender: TObject);
begin
   //Self.Hide;
   Self.Visible := False;
   frmScores.ShowModal;
end;

procedure TfrmMain.btnHelpClick(Sender: TObject);
begin
//   Self.Visible := False;
   frmHelp.ShowModal;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   ListNodes.Destroy;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
   CanClose := Application.MessageBox(PWideChar(sExit),'Exit', msgQuestionProperty) = mrYes;
end;

procedure TfrmMain.FormShow(Sender: TObject);
var
   imPNG: TPngImage;
begin

   Self.SetFocus;
end;

procedure TfrmMain.imQuestionClick(Sender: TObject);
begin
   frmHelp.ShowModal;
end;

procedure TfrmMain.btnDesignerClick(Sender: TObject);
begin
   Self.Hide;
   frmDesigner.Show;
end;

end.
