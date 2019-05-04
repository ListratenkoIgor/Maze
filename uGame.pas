unit uGame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.Buttons,
  Vcl.Samples.Spin, Vcl.StdCtrls, Vcl.ExtCtrls, System.ImageList, Vcl.ImgList,unit4,
  Vcl.Menus,uDesigner,Unit2;
type
   TMessage = (msgPause,msgLevelLose,msgGameOver,msgLevelWin,msgGameWin,msgLoading,msgWaiting);
   TState = (stPause,stPlay,stNewLevel,stGameEnd);
type
  TfmGame = class(TForm)
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
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure pbPlaygroundPaint(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DesignerClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure pbLivesPaint(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
//    procedure Button1Click(Sender: TObject);

  private
    { Private declarations }
    procedure StartLevel(CurrentLevel: Integer);
    function CheckMove(FinalX,FinalY: LongInt):Boolean;
    procedure Move(FinalX,FinalY: LongInt);
    procedure SetEnergy();
//    Procedure SetHearts();
    procedure CheckExit(Hearts,TotalHearts:Integer;var Lives: Integer);
    procedure Die();
    procedure EndGame();


    procedure DrawMap();
    procedure DrawCell(CoordX,CoordY: Integer);
    procedure SetMessage(MessageType:TMessage);

  public
    { Public declarations }
  end;


const
   BitmapSize = 15;

var
  fmGame: TfmGame;
  BitMap: TBitMap;
  InitialX,InitialY:Integer;
  Hearts,Energy,TotalHearts,Lives: Integer;
  Map:TMap;
  State:TState;


implementation

{$R *.dfm}

uses
   uMainMenu;


{Model---------------------------------------------------------------------------    }
procedure TfmGame.StartLevel(CurrentLevel: Integer);
var
   i,j:Integer;
begin
   //IsPlay := False;
   //IsGameEnded := False;
  // with LevelArray[CurrentLevel -1].LevelMap as TMap do
   for i := 0 to  MapHeight - 1 do
      for j := 0 to MapWidth -1 do
         Map[i,j] := LevelArray[CurrentLevel-1].LevelMap[i,j];
   lbLevel.Caption :='Уровень: '+ IntToStr(CurrentLevel);
   Hearts := 0;
   TotalHearts := LevelArray[CurrentLevel -1].TotalHearts;
   lbHearts.Caption :='Сердца: '+IntToStr(Hearts)+'/'+ IntToStr(TotalHearts);
   Energy := LevelArray[CurrentLevel -1].StartEnergy;
   SetEnergy();
   InitialX :=LevelArray[CurrentLevel -1].InitialX;
   InitialY := LevelArray[CurrentLevel -1].InitialY;
   lbComment.Caption := LevelArray[CurrentLevel -1].Comment;
//   pbPlayground.Invalidate;
   DrawMap();
   //SetMessage(msgWaiting);
end;


function TfmGame.CheckMove(FinalX,FinalY: LongInt):Boolean;
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

procedure TfmGame.Move(FinalX,FinalY: LongInt);
begin
   case Map[InitialX,InitialY] of
      elWaterBall:
         Map[InitialX,InitialY] := elWater;

     {Pit:
         Map[InitialX,InitialY] := Pit;
      Teleport:
         Map[InitialX,InitialY] := TeleportBall;
         }
   else
      Map[InitialX,InitialY] := elFree;
   end;
   DrawCell(InitialX,InitialY);
      case Map[FinalX,FinalY] of
      elWater:
      begin
         Map[FinalX,FinalY] := elWaterBall;
      end;
      elInvWall:
      begin
         Map[FinalX,FinalY] := elWall;
      end;
      elEnergy:
      begin
         Map[FinalX,FinalY] := elBall;
         Inc(Energy,EnergyValue);
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


procedure TfmGame.SetEnergy();
begin
   if Energy > MaxEnergy then
      Energy := MaxEnergy;
   lbEnergy.Caption := 'Энергия: '+ IntToStr(Energy);
   if Energy <= 0 then
   begin
      SetMessage(msgLevelLose);
      Die();
   end;
end;

procedure TfmGame.CheckExit(Hearts,TotalHearts:Integer; var Lives: Integer);
begin
   Timer.Enabled := False;
   //IsPlay := False;
   State := stNewLevel;
   if Hearts = TotalHearts then
   begin
      //NextLevel
      SetMessage(msgLevelWin);
      if CurrentLevel = Length(LevelArray) then
      begin
         State := stGameEnd;
         SetMessage(msgGameWin);
      end
      else
      begin
         SetMessage(msgWaiting);
         Inc(CurrentLevel);
         //StartLevel(CurrentLevel);
      end;
   end
   else
   begin
      //missed hearts
      //GameOver();
      //SetMessage(msgGameOver);
      Die();
   end;
end;

procedure TfmGame.Die();
begin
   Timer.Enabled := False;

   if Lives > 0 then
   begin
      Dec(Lives);
      pbLives.Repaint;
      State := stNewLevel;
      SetMessage(msgWaiting);
      //StartLevel(CurrentLevel);
   end
   else
   begin
      //IsGameEnded := True;
      State := stGameEnd;
      SetMessage(msgGameOver);

      //EndGame();
   end;
end;

procedure TfmGame.EndGame();
begin
   Timer.Enabled := False;
end;






// TElement = (elFree,elWall,elWater,elInvFree,elInvWall,elBall,elWaterBall,elEnergy,elHeart,elExit);//pit,pitExit,teleport














{View----------------------------------------------------------------}

procedure TfmGame.SetMessage(MessageType:TMessage);
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
     msgLevelWin:
     begin
        pnlMessages.Caption := 'LEVEL COMPLETED !!';
        pnlMessages.Font.Color := clBlue;
     end;
     msgGameWin:
     begin
        pnlMessages.Caption := 'ALL LEVELS COMPLETED !!';
        pnlMessages.Font.Color := clBlue;
     end;
     msgWaiting:
     begin
        pnlMessages.Caption := 'PRESS F2 TO PLAY';
        pnlMessages.Font.Color := clBlue;
     end;
  end;
  pnlMessages.Visible := True;
  //Application.ProcessMessages;
//  Self.Enabled:=False;
//  fmMessages.ShowModal;
//  fmMessages.SetFocus;
end;

procedure TfmGame.TimerTimer(Sender: TObject);
begin
   Dec(Energy);
   SetEnergy();
end;

procedure TfmGame.pbLivesPaint(Sender: TObject);
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
      BitMapList.Draw(pbLives.Canvas,myRect.Left,myRect.Top,ord(High(TElement)), True);

   MyRect.Left :=  Left + Gap ;
   MyRect.Right := MyRect.Left;
   if Lives > 1 then
      BitMapList.Draw(pbLives.Canvas,myRect.Left,myRect.Top,ord(High(TElement)), True);

   MyRect.Left :=  Left + Gap * 2;
   MyRect.Right := MyRect.Left + BitMapSize;
   if Lives > 2 then
      BitMapList.Draw(pbLives.Canvas,myRect.Left,myRect.Top,ord(High(TElement)), True);
end;

procedure TfmGame.pbPlaygroundPaint(Sender: TObject);
var
   MyRect:TRect;
   i, j: Integer;
begin


   //DrawMap();
       {
          MyRect.Left :=  16 * InitialX;
          MyRect.Top :=  16 * InitialY;
          MyRect.Right := MyRect.Left + 15;
          MyRect.Bottom := MyRect.Top + 15;
          BitMapList.Draw(pbPlayground.Canvas,myRect.Left,myRect.Top,ord(elFree), True);
          BitMapList.Draw(pbPlayground.Canvas,myRect.Left,myRect.Top,ord(Map[InitialX,InitialY]), True);
  }
end;

procedure TfmGame.DrawMap();
var
   i,j: Longint;
begin

    { dgPlayGround.TopRow := 0;
     dgPlayground.LeftCol := 0;   }
     for i := 0 to  MapHeight - 1 do
       for j := 0 to MapWidth -1 do
          DrawCell(i,j);
//   Bitmap.Free;
//   fuck;
end;

procedure TfmGame.DesignerClick(Sender: TObject);
begin
   fmDesigner.ShowModal;
end;

procedure TfmGame.DrawCell(CoordX,CoordY: Integer);
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
{procedure TfmGame.Button1Click(Sender: TObject);
begin
   //mem.Text :=mem.Text+ 'TopRow: '+IntToStr(dgPlayground.TopRow)+#13#10+'LeftCol: '+IntToStr(dgPlayground.LeftCol);

    DrawMap();
    button1.Enabled:=False;
   //mem.Text := mem.Text+'TopRow: '+IntToStr(dgPlayground.TopRow)+#13#10+'LeftCol: '+IntToStr(dgPlayground.LeftCol);
    //   dgPlayground.Width := round(fmGame.Width * 481 / 672);
  // dgPlayground.Height := round(fmGame.Height * 321 / 550);
end;   }












{ if CheckMove(xyxy);
     Move(xyxy);
}


{init---------------------------------------------------------------}

procedure TfmGame.FormActivate(Sender: TObject);
begin
   Lives := 3;
   State := stNewLevel;
   SetMessage(msgWaiting);
   //StartLevel(CurrentLevel);


  //DrawMap();
  //dgPlayground.SetFocus;
end;

procedure TfmGame.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Form3.Close;
end;

procedure TfmGame.FormCreate(Sender: TObject);
begin
//   dgPlayGround.Width := dgPlayGround.RowCount*16;
//   dgPlayGround.Height := dgPlayground.ColCount*16;
{   InitialX:=2;
   InitialY:=2;
   Hearts:=0;
   TotalHearts:=36;
   Energy := 30;
   Lives := 3;
   lbHearts.Caption := 'Сердца: '+IntToStr(Hearts)+'/'+IntToStr(TotalHearts);
}   //mem.Text := 'TopRow: '+IntToStr(dgPlayground.TopRow)+#13#10+'LeftCol: '+IntToStr(dgPlayground.LeftCol);
 //  ScaleBy(3,4);
  // ScaleControls(3,4);
end;
procedure TfmGame.FormKeyDown(Sender: TObject; var Key: Word;
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
       if State = stNewLevel then
       begin
          State := stPlay;
          Timer.Enabled := True;
          pnlMessages.Visible:=False;
          StartLevel(CurrentLevel);
       end;
    end;


   end;
         //pnlMessages.Visible := not IsPlay;



  //pbPlayground.Invalidate;
end;

procedure TfmGame.FormShow(Sender: TObject);
begin
  DrawMap();
  //pbPlayground;
end;

end.
