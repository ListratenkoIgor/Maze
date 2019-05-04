unit uDesigner;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.Buttons,
  Vcl.Samples.Spin, Vcl.StdCtrls, Vcl.ExtCtrls, System.ImageList, Vcl.ImgList,Unit4,
  System.Actions, Vcl.ActnList;

type
  TfmDesigner = class(TForm)
    Bevel2: TBevel;
    Label8: TLabel;
    Label9: TLabel;
    lbComment: TLabel;
    Label11: TLabel;
    edComment: TEdit;
    edTitle: TEdit;
    cmbLevel: TComboBox;
    btnAddLevel: TButton;
    edEnergy: TSpinEdit;
    Bevel3: TBevel;
    SaveBtn: TBitBtn;
    BitBtn2: TBitBtn;
    Button1: TButton;
    SaveAs: TBitBtn;
    OpenDialog1: TOpenDialog;
    dlgSaveFile: TSaveDialog;
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label12: TLabel;
    Label14: TLabel;
    btFillMap: TButton;
    BitMapListDesigner: TImageList;
    ActionList1: TActionList;
    Free: TAction;
    Wall: TAction;
    Water: TAction;
    InvFree: TAction;
    InvWall: TAction;
    Heart: TAction;
    Energy: TAction;
    Exit: TAction;
    Ball: TAction;
    spdbtnFree: TSpeedButton;
    spdbtnWall: TSpeedButton;
    spdbtnWater: TSpeedButton;
    spdbtnInvFree: TSpeedButton;
    spdbtnBall: TSpeedButton;
    spdbtnInvWall: TSpeedButton;
    spdbtnHeart: TSpeedButton;
    spdbtnEnergy: TSpeedButton;
    spdbtnExit: TSpeedButton;
    pbDesignerGrid: TPaintBox;
    btnDelete: TButton;
    procedure BtnElementClick(Sender: TObject);
    procedure pbDesignerGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btFillMapClick(Sender: TObject);
//    procedure pbDesignerGridMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure pbDesignerGridPaint(Sender: TObject);
    procedure btnAddLevelClick(Sender: TObject);
    procedure cmbLevelChange(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure SaveAsClick(Sender: TObject);
    procedure edCommentChange(Sender: TObject);
    procedure edTitleChange(Sender: TObject);
    procedure edEnergyChange(Sender: TObject);
  protected

  private
    { Private declarations }
     function CheckLevels():Boolean;
     procedure SaveFile(FileName: string);
     procedure AddLevel();
     procedure DeleteLevel();

     procedure DrawMap();
     procedure HighLightCell(CoordX,CoordY: Integer;Color: TColor);
     procedure DrawCell(CoordX,CoordY: Integer; IsEmpty: Boolean);


  public
    { Public declarations }
  end;

//TTypeFile = file of TLevel;

EBallNonExist = class(Exception);
//EHeartNonExist = class(Exception);
EExitNonExist = class(Exception);
ETooMuchBalls = class(Exception);

var
  fmDesigner: TfmDesigner;
  Element: TElement;
  CurrentLevel: Integer;
  CoordX,CoordY,PredX,PredY: Integer;
  //FreeMap: array[0..29,0..19] of TElement;

implementation

{$R *.dfm}

{Model-----------------------------------------------------------------------------------------------------}
procedure TfmDesigner.AddLevel();
begin
   CurrentLevel := Length(LevelArray)+1;
   SetLength(LevelArray,CurrentLevel);
   cmbLevel.AddItem(IntToStr(CurrentLevel),nil);
   cmbLevel.Text := IntToStr(CurrentLevel);
   edComment.Text := 'Write here the comment for the level';
   edTitle.Text := 'Title';
   edEnergy.Text := '1';

   Self.edCommentChange(Self);
   Self.edTitleChange(Self);
   Self.edEnergyChange(Self);

   Self.cmbLevelChange(Self);
end;

procedure TfmDesigner.DeleteLevel();
var
   i: Integer;
begin
   cmbLevel.Items.Delete(CurrentLevel - 1);
   for i := CurrentLevel - 1  to High(LevelArray)-1 do
      LevelArray[i]:= LevelArray[i+1];
   SetLength(LevelArray,Length(LevelArray)-1);
   cmbLevel.Items.Clear;
   for i := 1 to Length(LevelArray) do
      cmbLevel.AddItem(IntToStr(i),nil);
   if CurrentLevel > 1 then
      Dec(CurrentLevel);
   edTitle.Text := LevelArray[CurrentLevel-1].Title;
   edComment.Text := LevelArray[CurrentLevel-1].Comment;
   edEnergy.Text := IntToStr(LevelArray[CurrentLevel-1].StartEnergy);
   cmbLevel.Text := IntToStr(CurrentLevel);
   //Self.cmbLevelChange(Self);
end;

function TfmDesigner.CheckLevels():Boolean;
var
   LevelIndex,i,j: Integer;
   IsBallExist,IsExitExist:Boolean;
begin
   try
      for LevelIndex := 0 to High(LevelArray) do
      begin
         IsBallExist := False;
         IsExitExist := False;
         for i := 0 to MapHeight - 1 do
            for j := 0 to MapWidth - 1 do
            begin
               case LevelArray[levelIndex].LevelMap[i,j] of
                  elBall:
                  begin
                     if IsBallExist then
                     begin
                        raise ETooMuchBalls.Create('');
                     end
                     else
                     begin
                        IsBallExist := True;
                        LevelArray[levelIndex].InitialX := i;
                        LevelArray[LevelIndex].InitialY := j;
                     end;
                  end;
                  elHeart:
                  begin
                     Inc(LevelArray[levelIndex].TotalHearts);
                  end;
                  elExit:
                  begin
                     IsExitExist := True;
                  end;
               end;
            end;
         if not IsBallExist then
            raise EBallNonExist.Create('');
         if not IsExitExist then
            raise EExitNonExist.Create('');
      end;
      CheckLevels := True;
   except
      on E: EBallNonExist do
         MessageBox(Self.Handle,PWideChar('Error.Ball not exist in map: '+IntToStr(LevelIndex+1)),'Error',mb_Ok+mb_IconError+mb_ApplModal);
      on E: ETooMuchBalls do
         MessageBox(Self.Handle,PWideChar('Error.Must be only 1 ball on the map.Too much balls in map: '+IntToStr(LevelIndex+1)),'Error',mb_Ok+mb_IconError+mb_ApplModal);
      on E: EExitNonExist do
         MessageBox(Self.Handle,PWideChar('Error.Ball not exist in map: '+IntToStr(LevelIndex+1)),'Error',mb_Ok+mb_IconError+mb_ApplModal);
      else
         MessageBox(Self.Handle,PWideChar('Unexpected error'),'Error',mb_Ok+mb_IconError+mb_ApplModal);
      CheckLevels := False;
   end;
end;
{   TLevel = record
      CurrentLevel: Integer;
      TotalHearts: Integer;
      StartEnergy: Integer;
      InitialX: Integer;
      InitialY: Integer;
      LevelMap: TMap;
      Comment: string[30];
      Title: string[25];
   end;}
procedure TfmDesigner.SaveFile(FileName: string);
var
   ResultFile: Textfile;
   LevelIndex,i,j: Integer;
begin
   //Initialize LevelArray
   try
      AssignFile(ResultFile,FileName);
      //fileexists check
      Rewrite(ResultFile);
      Writeln(ResultFile,Length(LevelArray));
      for LevelIndex := 0 to High(LevelArray) do
      begin
         Writeln(ResultFile,LevelArray[LevelIndex].TotalHearts);
         Writeln(ResultFile,LevelArray[LevelIndex].StartEnergy);
         Writeln(ResultFile,LevelArray[LevelIndex].InitialX);
         Writeln(ResultFile,LevelArray[LevelIndex].InitialY);
         //Writeln(ResultFile);
         for i := 0 to MapHeight - 1 do
         begin
            for j := 0 to MapWidth - 1 do
            begin
               Write(ResultFile,ord(LevelArray[LevelIndex].LevelMap[i,j]),' ');
            end;
            Writeln(ResultFile);
         end;
         Writeln(ResultFile,LevelArray[LevelIndex].Comment);
         Writeln(ResultFile,LevelArray[LevelIndex].Title);
      end;
   finally
      CloseFile(ResultFile);
   end;
end;

{View---------------------------------------------------------------------------------------------------}
procedure TfmDesigner.DrawMap();
var
   i,j:integer;
begin
   for i := 0 to MapHeight - 1 do
      for j := 0 to MapWidth - 1 do
      begin
         DrawCell(i,j,False);
         //HighLightCell(i*16,j*16,clBlack);
      end;

end;


procedure TfmDesigner.DrawCell(CoordX: Integer; CoordY: Integer; IsEmpty: Boolean);
var
   MyRect: TRect;
begin

      MyRect.Left :=  16 * CoordX;
      MyRect.Top :=  16 * CoordY;
      MyRect.Right := MyRect.Left + 15;
      MyRect.Bottom := MyRect.Top + 15;
      BitMapListDesigner.Draw(pbDesignerGrid.Canvas,myRect.Left,myRect.Top,ord(elFree), True);
      if not IsEmpty then
      begin
         BitMapListDesigner.Draw(pbDesignerGrid.Canvas,myRect.Left,myRect.Top,ord(LevelArray[CurrentLevel - 1].LevelMap[CoordX,CoordY]), True);
      end;
end;

procedure TfmDesigner.HighLightCell(CoordX: Integer; CoordY: Integer; Color: TColor);
begin
   with pbDesignerGrid.Canvas do
   begin
      Pen.Color := Color;
      MoveTo(CoordX,CoordY);
      LineTo(CoordX,CoordY+16);
      LineTo(CoordX+16,CoordY+16);
      LineTo(CoordX+16,CoordY);
      LineTo(CoordX,CoordY);
   end;
end;



procedure TfmDesigner.pbDesignerGridPaint(Sender: TObject);
begin
   DrawMap();
end;

{Control--------------------------------------------------------------------------------------------------}
procedure TfmDesigner.pbDesignerGridMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   //CoordX := (X)-X mod 16;//div 16;   // - pbDesignerGrid.Left
  // CoordY := (Y)-Y mod 16;//div 16;   //- pbDesignerGrid.Top
   CoordX := (X)div 16;   // - pbDesignerGrid.Left
   CoordY := (Y)div 16;   //- pbDesignerGrid.Top
   if Button = mbLeft then
   begin
      LevelArray[CurrentLevel - 1].LevelMap[CoordX,CoordY] := Element;
      DrawCell(CoordX,CoordY,False);
   end;
   if Button = mbRight then
   begin
      LevelArray[CurrentLevel - 1].LevelMap[CoordX,CoordY] := elFree;
      DrawCell(CoordX,CoordY,True);
   end;
end;

{procedure TfmDesigner.pbDesignerGridMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
   PredX := CoordX;
   PredY := CoordY;
   HighLightCell(CoordX,CoordY,clBlack);
   //DrawCell(PredX,PredY,False);
   CoordX := (X)-X mod 16;//div 16;   // - pbDesignerGrid.Left
   CoordY := (Y)-Y mod 16;//div 16;   //- pbDesignerGrid.Top
   HighLightCell(CoordX,CoordY,clRed);
end;                   }




procedure TfmDesigner.SaveAsClick(Sender: TObject);
begin
   if CheckLevels() then
   begin
      if dlgSaveFile.Execute then
         SaveFile(dlgSaveFile.FileName);
   end;
end;

procedure TfmDesigner.btnAddLevelClick(Sender: TObject);
begin
   if Length(LevelArray) < MaxLevel then
   begin
      AddLevel();
   end;
end;

procedure TfmDesigner.btnDeleteClick(Sender: TObject);
begin
   if Length(LevelArray) > 1 then
   begin
      DeleteLevel();
   end;
end;

procedure TfmDesigner.BtnElementClick(Sender: TObject);
begin
   if Sender is TSpeedButton then
      with Sender as TSpeedButton do
      case Tag of
         0:Element := elFree;
         1:Element := elWall;
         2:Element := elWater;
         3:Element := elInvFree;
         4:Element := elInvWall;
         5:Element := elHeart;
         6:Element := elEnergy;
         7:Element := elExit;
         8:Element := elBall;
      end;
end;

procedure TfmDesigner.cmbLevelChange(Sender: TObject);
begin
   LevelArray[CurrentLevel-1].Comment := edComment.Text;
   LevelArray[CurrentLevel-1].Title := edTitle.Text;
   LevelArray[CurrentLevel-1].StartEnergy := StrToInt(edEnergy.Text);
   CurrentLevel := StrToInt(cmbLevel.Text);
   edComment.Text := LevelArray[CurrentLevel-1].Comment;
   edTitle.Text := LevelArray[CurrentLevel-1].Title;
   edEnergy.Text := IntToStr(LevelArray[CurrentLevel-1].StartEnergy);



   pbDesignerGrid.Repaint;
   //DrawMap();
end;

procedure TfmDesigner.edCommentChange(Sender: TObject);
begin
   LevelArray[CurrentLevel-1].Comment:=edComment.Text;
end;


procedure TfmDesigner.edTitleChange(Sender: TObject);
begin
   LevelArray[CurrentLevel-1].Title:=edTitle.Text;
end;

procedure TfmDesigner.edEnergyChange(Sender: TObject);
begin
   LevelArray[CurrentLevel-1].StartEnergy := StrToInt(edEnergy.Text);
end;

procedure TfmDesigner.btFillMapClick(Sender: TObject);
var
   i,j: integer;
begin
   for i := 0 to MapHeight - 1 do
      for j := 0 to MapWidth - 1 do
         LevelArray[CurrentLevel - 1].LevelMap[i,j] := Element;
   DrawMap();
end;

{init-----------------------------------------------------------------------------------------}
procedure TfmDesigner.FormActivate(Sender: TObject);
begin
   LevelArray := nil;
   AddLevel();
   Element:=elFree;
   //btFillMap.Click;
//   SetLength(LevelArray,1);
//   cmbLevel.AddItem('1',nil);
//   CurrentLevel := 1;
{   for i := 0 to 8 do
      cmbLevel.AddItem(IntToStr(i+1),nil);
      cmbLevel.Items.Delete(cmbLevel.Items.Count-1);}

end;



end.



