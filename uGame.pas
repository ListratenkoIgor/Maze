unit uGame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.Buttons,Vcl.Samples.Spin,
  Vcl.StdCtrls, Vcl.ExtCtrls, System.ImageList, Vcl.ImgList, Vcl.Menus, Vcl.MPlayer, MMSystem,
  uMethodsData,uUserInfo,uButtonMessage;
type
   TMessage = (msgPause,msgLevelWin,msgGameWin,msgGameOver,msgLoading,msgWaiting,msgStartLevel,msgMissHearts,msgOutEnergy);
   TState = (stPause,stPlay,stNewGame,stNewLevel,stGameEnd);
type
  TfrmGame = class(TForm)
    BitmapList: TImageList;
    pbPlayground: TPaintBox;
    pnlMessages: TPanel;
    Panel1: TPanel;
    bvlEnergy: TBevel;
    lbEnergy: TLabel;
    lbComment: TLabel;
    lbHearts: TLabel;
    lbLevel: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    MainMenu1: TMainMenu;
    Designer: TMenuItem;
    Timer: TTimer;
    pbLives: TPaintBox;
    Panel2: TPanel;
    lbTitle: TLabel;
    mpSound: TMediaPlayer;
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TimerTimer(Sender: TObject);
    procedure pbLivesPaint(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
//    procedure Button1Click(Sender: TObject);

  private
    { Private declarations }
    InitialX,InitialY,Hearts,Energy,TotalHearts,Lives: Integer;
    Map: TMap;
    State: TState;
    LevelTime: Integer;

    procedure StartGame();
    procedure StartLevel(CurrentLevel: Integer);
    function  CheckMove(FinalX,FinalY: LongInt):Boolean;
    procedure Move(FinalX,FinalY: LongInt);
    procedure SetEnergy();
    procedure CheckExit(Hearts,TotalHearts:Integer;var Lives: Integer);
    procedure Die();
    procedure EndGame();

    procedure DrawMap();
    procedure DrawCell(CoordX,CoordY: Integer);
    procedure SetMessage(MessageType: TMessage);
    procedure SetButtonMessage(MessageType: TMessage);

  public
    { Public declarations }
    TotalGameTime: Integer;
    CurrentLevel: Integer;
  end;


const
   BitmapSize = 15;

var
  frmGame: TfrmGame;
  IsNowDied: Boolean = False;
implementation

{$R *.dfm}

uses
   uMainMenu;


{Model---------------------------------------------------------------------------    }
procedure TfrmGame.StartGame();
begin
   State := stNewGame;
   Lives := 3;
   CurrentLevel := 2;
   TotalGameTime := 0;
   SetMessage(msgWaiting);
end;

procedure FreeMap(var Map:TMap);
var
   i,j:Integer;
begin
   for i := 0 to  MapHeight - 1 do
      for j := 0 to MapWidth -1 do
         Map[i,j] := elFree;
end;
procedure TfrmGame.StartLevel(CurrentLevel: Integer);
var
   i,j:Integer;
begin
   //IsPlay := False;
   //IsGameEnded := False;
  // with LevelArray[CurrentLevel -1].LevelMap as TMap do
//   FreeMap(Map);
   for i := 0 to  MapHeight - 1 do
      for j := 0 to MapWidth -1 do
         Map[i,j] := LevelArray[CurrentLevel-1].LevelMap[i,j];
   lbLevel.Caption :='Уровень: '+ IntToStr(CurrentLevel);
   InitialX :=LevelArray[CurrentLevel -1].InitialX;
   InitialY := LevelArray[CurrentLevel -1].InitialY;
   lbComment.Caption := LevelArray[CurrentLevel -1].Comment;
   lbTitle.Caption := LevelArray[CurrentLevel -1].Title;
   Hearts := 0;
   TotalHearts := LevelArray[CurrentLevel -1].TotalHearts;
   lbHearts.Caption :='Сердца: '+IntToStr(Hearts)+'/'+ IntToStr(TotalHearts);
   Energy := LevelArray[CurrentLevel -1].StartEnergy;
   SetEnergy();

//   pbPlayground.Invalidate;
   LevelTime := 0;
   pbLives.Repaint;
   DrawMap();
   SetButtonMessage(msgStartLevel);
   State := stPlay;
   Timer.Enabled := True;
   //SetMessage(msgWaiting);
end;


function TfrmGame.CheckMove(FinalX,FinalY: LongInt):Boolean;
begin
   case Map[FinalX,FinalY] of
      elWall:
         CheckMove := False;
      elInvWall:
      begin
         CheckMove := False;
         Map[FinalX,FinalY] := elWall;
         DrawCell(FinalX,FinalY);{special drawcell}
      end;
      else
         CheckMove := True;
   end;
end;

procedure TfrmGame.Move(FinalX,FinalY: LongInt);
begin
   IsNowDied := False;
   case Map[InitialX,InitialY] of
      elWaterBall:
         Map[InitialX,InitialY] := elWater;
   else
      Map[InitialX,InitialY] := elFree;
   end;
   DrawCell(InitialX,InitialY);
   case Map[FinalX,FinalY] of
      elWater:
      begin
         Map[FinalX,FinalY] := elWaterBall;
         Dec(Energy,cnstEnergyLoss);
         SetEnergy();
         if IsNowDied then
         begin
            Exit;
         end;
      end;
      elInvWall:
      begin
         Map[FinalX,FinalY] := elWall;
      end;
      elEnergy:
      begin
         Map[FinalX,FinalY] := elBall;
         Inc(Energy,cnstEnergyValue);
         SetEnergy();

      end;
      elHeart:
      begin
         Map[FinalX,FinalY] := elBall;
         Inc(Hearts);
         lbHearts.Caption := 'Сердца: '+IntToStr(Hearts)+'/'+IntToStr(TotalHearts);
      end;
      elExit:
      begin
         CheckExit(Hearts,TotalHearts,Lives);
         Exit;
      end;
     {Pit:
         Map[FinalX,FinalY] := PitBall;     ???
      Teleport:
         Map[FinalX,FinalY] := TeleportBall;
         }
   else
      Map[FinalX,FinalY] := elBall;
   end;
   //mem.Text :='TopRow: '+IntToStr(dgPlayground.TopRow)+#13#10+'LeftCol: '+IntToStr(dgPlayground.LeftCol);
   DrawCell(FinalX,FinalY);
   InitialX := FinalX;
   InitialY := FinalY;
//   drawmap();
end;


procedure TfrmGame.SetEnergy();
begin
   if Energy > cnstMaxEnergy then
      Energy := cnstMaxEnergy;
   lbEnergy.Caption := 'Энергия: '+ IntToStr(Energy);
   if Energy <= 0 then
   begin
      IsNowDied := True;
      Timer.Enabled := False;
      State := stGameEnd;
      SetButtonMessage(msgOutEnergy);
      CheckExit(0,0,Lives);
   end;
end;

procedure TfrmGame.CheckExit(Hearts,TotalHearts:Integer; var Lives: Integer);
begin
   Timer.Enabled := False;
   //IsPlay := False;
   State := stGameEnd;
   if Energy <= 0 then
   begin
      Die();
      Exit;
   end;
   if Hearts = TotalHearts then
   begin
      //NextLevel
      TotalGameTime:= TotalGameTime + LevelTime;
//      SetMessage(msgLevelWin);
      if CurrentLevel = Length(LevelArray) then
      begin
         SetMessage(msgGameWin);
         EndGame();
      end
      else
      begin

         Inc(CurrentLevel);
         StartLevel(CurrentLevel);
      end;
   end
   else
   begin
      //missed hearts
      SetButtonMessage(msgMissHearts);
      //GameOver();
      //SetMessage(msgGameOver);
      Die();
   end;


end;

procedure TfrmGame.Die();
begin
   if Lives > 0 then
   begin
      Dec(Lives);
      StartLevel(CurrentLevel);
      Exit;
   end
   else
   begin
      SetMessage(msgGameOver);
      TotalGameTime := TotalGameTime + LevelTime;
      EndGame();
   end;
end;

procedure TfrmGame.EndGame();
var
   UserInfo: TUserInfo;
begin
   if Application.MessageBox('Хотите ли вы сохранить результаты?','', MB_YESNO+MB_ICONQUESTION+MB_DEFBUTTON2) = mrYes then
   begin
      frmUserInfo.ShowModal;
   end;
   //Timer.Enabled := False;
end;







// TElement = (elFree,elWall,elWater,elInvFree,elInvWall,elBall,elWaterBall,elEnergy,elHeart,elExit);//pit,pitExit,teleport














{View----------------------------------------------------------------}



procedure TfrmGame.SetMessage(MessageType:TMessage);
begin
  case MessageType of
     msgPause: begin
        pnlMessages.Caption := 'GAME PAUSED - PRESS P';
        pnlMessages.Font.Color := clBlue;
     end;
     msgLoading:
     begin
        pnlMessages.Caption := 'PLEASE WAIT...';
        pnlMessages.Font.Color := clNavy;
     end;
     msgGameOver:
     begin
        pnlMessages.Caption := 'GAME OVER';
        pnlMessages.Font.Color := clRed;
     end;
     msgWaiting:
     begin
        pnlMessages.Caption := 'PRESS F2 TO PLAY';
        pnlMessages.Font.Color := clBlue;
     end;
  end;
  pnlMessages.Visible := True;
  Application.ProcessMessages;
//  Self.Enabled:=False;
//  fmMessages.ShowModal;
//  fmMessages.SetFocus;
end;

procedure TfrmGame.SetButtonMessage(MessageType: TMessage);
begin
   Self.Timer.Enabled := False;
   Self.Enabled := False;
   with frmButtonMessage do
   begin
      case MessageType of
         msgStartLevel:
         begin
            lbComment.Caption := 'STARTING LEVEL: '+ IntToStr(CurrentLevel);
            lbComment.Font.Color := clNavy;
         end;
         msgMissHearts:
         begin
            lbComment.Caption := 'YOU MISSED SOME HEARTS';
            lbComment.Font.Color := clRed;
         end;
         msgOutEnergy:
         begin
            lbComment.Caption := 'OUT OF ENERGY';
            lbComment.Font.Color := clRed;
         end;
         msgGameOver:
         begin
            lbComment.Caption := 'YOU LOSE !!';
            lbComment.Font.Color := clRed;
         end;
         msgLevelWin:
         begin
            lbComment.Caption := 'LEVEL COMPLETED !!';
            lbComment.Font.Color := clBlue;
         end;
         msgGameWin:
         begin
            lbComment.Caption := 'ALL LEVELS COMPLETED !!';
            lbComment.Font.Color := clBlue;
         end;
      end;
      ShowModal;
      Exit;
   end;
   //Application.ProcessMessages;
end;


procedure TfrmGame.pbLivesPaint(Sender: TObject);
const
   Top = 3;
   Left = 6;
   Gap = 7 + BitMapSize;
var
   MyRect: TRect;
begin
   MyRect.Top :=  Top;
   MyRect.Bottom := MyRect.Top + BitMapSize;

   MyRect.Left :=  Left;
   MyRect.Right := MyRect.Left + BitMapSize;
   if Lives > 0 then
      BitMapList.Draw(pbLives.Canvas,myRect.Left,myRect.Top,ord(elBall), True);

   MyRect.Left :=  Left + Gap ;
   MyRect.Right := MyRect.Left;
   if Lives > 1 then
      BitMapList.Draw(pbLives.Canvas,myRect.Left,myRect.Top,ord(elBall), True);

   MyRect.Left :=  Left + Gap * 2;
   MyRect.Right := MyRect.Left + BitMapSize;
   if Lives > 2 then
      BitMapList.Draw(pbLives.Canvas,myRect.Left,myRect.Top,ord(elBall), True);
end;


procedure TfrmGame.DrawMap();
var
   i,j: Longint;
begin

    { dgPlayGround.TopRow := 0;
     dgPlayground.LeftCol := 0;   }
     for i := 0 to  MapHeight - 1 do
       for j := 0 to MapWidth -1 do
       begin
          DrawCell(i,j);

       end;
//   Bitmap.Free;
//   fuck;
end;

procedure TfrmGame.DrawCell(CoordX,CoordY: Integer);
var
   MyRect:TRect;
begin

          MyRect.Left :=  16 * CoordX;
          MyRect.Top :=  16 * CoordY;
          MyRect.Right := MyRect.Left + BitMapSize;
          MyRect.Bottom := MyRect.Top + BitMapSize;
          BitMapList.Draw(pbPlayground.Canvas,myRect.Left,MyRect.Top,ord(elFree), True);
          BitMapList.Draw(pbPlayground.Canvas,myRect.Left,MyRect.Top,ord(Map[CoordX,CoordY]), True);
          //pbPlayground.Invalidate;
    //         BitMapList.GetBitmap(ord(Map[i,j]),Bitmap);
          //dgPlayground.Canvas.Draw(MyRect.Left,MyRect.Top,BitMap);
          //BitMapList.Draw(dgPlayground.Canvas,myRect.Left,myRect.Top,ord(Map[j,i]), True);
 //         dgPlayground.Canvas.StretchDraw(MyRect,BitMap);
end;
{Control-----------------------------------------------------------------}
procedure TfrmGame.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if State = stPlay then
   case Key of
      VK_LEFT:
      begin
         if InitialX > 0 then
            if CheckMove(InitialX-1,InitialY)then
               Move(InitialX-1,InitialY);
      end;
      VK_UP:
      begin
         if InitialY > 0 then
            if CheckMove(InitialX,InitialY-1) then
               Move(InitialX,InitialY-1);
      end;
      VK_RIGHT:
      begin
         if InitialX < MapHeight - 1 then
            if CheckMove(InitialX+1,InitialY) then
               Move(InitialX+1,InitialY);
      end;
      VK_DOWN:
      begin
         if InitialY < MapWidth - 1 then
            if CheckMove(InitialX,InitialY+1) then
               Move(InitialX,InitialY+1);
      end;

   end;
   case Key of
      $50:
      case State of
         stPause:
         begin
            State := stPlay;
            Timer.Enabled := True;
            pnlMessages.Hide;
            DrawMap();
         end;
         stPlay:
         begin
            State := stPause;
            Timer.Enabled := False;
            SetMessage(msgPause);
         end;
      end;
      VK_F2:
      begin
         if (State = stNewLevel) or (State = stNewGame) then
         begin
            State := stPlay;
            Timer.Enabled := True;
            pnlMessages.Visible:=False;
            StartLevel(CurrentLevel);
         end;
      end;
   end;
end;

procedure TfrmGame.TimerTimer(Sender: TObject);
begin
   Inc(LevelTime);
   Dec(Energy);
   SetEnergy();
end;
{init---------------------------------------------------------------}


procedure TfrmGame.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   frmMain.Show;
end;




procedure TfrmGame.FormShow(Sender: TObject);
begin
//DrawMap();
   StartGame();
  //pbPlayground;
end;

end.
