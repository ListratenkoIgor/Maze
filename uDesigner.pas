unit uDesigner;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.Buttons,Vcl.Samples.Spin, Vcl.StdCtrls,
  Vcl.ExtCtrls, System.ImageList, Vcl.ImgList,System.Actions, Vcl.ActnList,
  uMethodsData, Vcl.Menus, uHelp;

type
  TfrmDesigner = class(TForm)
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
    bitbtnSave: TBitBtn;
    bitbtnCancel: TBitBtn;
    btnLoad: TButton;
    bitbtnSaveAs: TBitBtn;
    dlgOpenFile: TOpenDialog;
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
    MainMenu1: TMainMenu;
    miMenu: TMenuItem;
    miHelp: TMenuItem;
    PopupMenu1: TPopupMenu;
    procedure btnElementClick(Sender: TObject);
    procedure pbDesignerGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btFillMapClick(Sender: TObject);
    procedure pbDesignerGridPaint(Sender: TObject);
    procedure btnAddLevelClick(Sender: TObject);
    procedure cmbLevelChange(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure bitbtnSaveAsClick(Sender: TObject);
    procedure SaveLevelInfo(Sender: TObject);
    procedure pbDesignerGridMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure btnLoadClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure bitbtnSaveClick(Sender: TObject);
    procedure edEnergyChange(Sender: TObject);
    procedure edTitleChange(Sender: TObject);
    procedure edCommentChange(Sender: TObject);
    procedure bitbtnCancelClick(Sender: TObject);
    procedure miHelpClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  protected

  private
    { Private declarations }
//     LevelArray: TLevelArray;
     Element: TElement;
     CurrentLevel: Integer;
     CoordX,CoordY: Integer;
     function CheckLevels():Boolean;
     procedure SaveFile(FileName: string);
     procedure AddLevel();
     procedure DeleteLevel();

     procedure DrawMap();
     procedure DrawCell(CoordX,CoordY: Integer; IsEmpty: Boolean);


  public
    //procedure HighLightCell(Sender:TObject;CoordX,CoordY: Integer;Color: TColor);
    { Public declarations }
  end;

//TTypeFile = file of TLevel;

var
   frmDesigner: TfrmDesigner;
   LastFileName: string;
   IsModified: Boolean;

implementation

{$R *.dfm}
uses uMainMenu;
{Model-----------------------------------------------------------------------------------------------------}
procedure TfrmDesigner.AddLevel();
begin
//   Self.SaveLevelInfo(Self);
   IsModified := True;
   CurrentLevel := Length(LevelArray)+1;
   SetLength(LevelArray,CurrentLevel);
   cmbLevel.AddItem(IntToStr(CurrentLevel),nil);
   cmbLevel.Text := IntToStr(CurrentLevel);
   edComment.Text := 'Write here the comment for the level';
   edTitle.Text := 'Title';
   edEnergy.Text := '1';

   Self.SaveLevelInfo(Self);


   Self.cmbLevelChange(Self);
end;

procedure TfrmDesigner.DeleteLevel();
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
   //pbDesignerGrid.Repaint;
   Self.cmbLevelChange(Self);
end;

function TfrmDesigner.CheckLevels():Boolean;
var
   LevelIndex,i,j: Integer;
   IsBallExist,IsExitExist:Boolean;
begin
   CheckLevels := False;
   try
      for LevelIndex := 0 to High(LevelArray) do
      begin
         IsBallExist := False;
         IsExitExist := False;
         LevelArray[levelIndex].TotalHearts := 0;
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
         if not (LevelArray[levelIndex].StartEnergy in [1..cnstMaxEnergy]) then
            raise EIncorrectEnergy.Create('');
      end;
      CheckLevels := True;
   except
      on E: EBallNonExist do
         MessageBox(Self.Handle,PWideChar(sBallNonExist+IntToStr(LevelIndex+1)),'Error',msgErrorProperty);
      on E: ETooMuchBalls do
         MessageBox(Self.Handle,PWideChar(sTooMuchBalls+IntToStr(LevelIndex+1)),'Error',msgErrorProperty);
      on E: EExitNonExist do
         MessageBox(Self.Handle,PWideChar(sExitNonExist+IntToStr(LevelIndex+1)),'Error',msgErrorProperty);
      on E: EIncorrectEnergy do
         MessageBox(Self.Handle,PWideChar(sIncorrectEnergy+IntToStr(LevelIndex+1)),'Error',msgErrorProperty);
      else
         MessageBox(Self.Handle,PWideChar('Unexpected error'),'Error',msgErrorProperty);
   end;
end;

procedure TfrmDesigner.SaveFile(FileName: string);
var
   ResultFile: TextFile;
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
      IsModified := False;
      LastFileName := FileName;
   finally
      CloseFile(ResultFile);
   end;
end;

{View---------------------------------------------------------------------------------------------------}
procedure TfrmDesigner.DrawMap();
var
   i,j:integer;
begin
   for i := 0 to MapHeight - 1 do
      for j := 0 to MapWidth - 1 do
      begin
         DrawCell(i,j,False);
        // HighLightCell(pbDesignerGrid,i*16,j*16,clBlack);
      end;

end;


procedure TfrmDesigner.edCommentChange(Sender: TObject);
begin
   LevelArray[CurrentLevel-1].Comment:=edComment.Text;
end;

procedure TfrmDesigner.edEnergyChange(Sender: TObject);
begin
   if edEnergy.Text <> '' then
      LevelArray[CurrentLevel-1].StartEnergy := StrToInt(edEnergy.Text)
   else
      LevelArray[CurrentLevel-1].StartEnergy := 0;
end;

procedure TfrmDesigner.edTitleChange(Sender: TObject);
begin
   LevelArray[CurrentLevel-1].Title:=edTitle.Text;
end;

procedure TfrmDesigner.DrawCell(CoordX: Integer; CoordY: Integer; IsEmpty: Boolean);
var
   MyRect: TRect;
begin
   with MyRect do
   begin
      Left :=  16 * CoordX;
      Top :=  16 * CoordY;
      Right := Left + 15;
      Bottom := Top + 15;
   end;
   BitMapListDesigner.Draw(pbDesignerGrid.Canvas,myRect.Left,myRect.Top,ord(elFree), True);
   if not IsEmpty then
   begin
      BitMapListDesigner.Draw(pbDesignerGrid.Canvas,myRect.Left,myRect.Top,ord(LevelArray[CurrentLevel - 1].LevelMap[CoordX,CoordY]), True);
   end;
end;
{
procedure TfmDesigner.HighLightCell(Sender:TObject;CoordX: Integer; CoordY: Integer; Color: TColor);
begin
   with Sender as TPaintBox do
   begin
      Canvas.Pen.Color := Color;
      Canvas.MoveTo(CoordX,CoordY);
      Canvas.LineTo(CoordX,CoordY+16);
      Canvas.LineTo(CoordX+16,CoordY+16);
      Canvas.LineTo(CoordX+16,CoordY);
      Canvas.LineTo(CoordX,CoordY);
   end;
end;  }

procedure TfrmDesigner.pbDesignerGridPaint(Sender: TObject);
begin
   DrawMap();
end;

{Control--------------------------------------------------------------------------------------------------}
procedure TfrmDesigner.pbDesignerGridMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
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

procedure TfrmDesigner.pbDesignerGridMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
   Button:TMouseButton;
begin
   if (ssRight in Shift) or (ssLeft in Shift) then
   begin
      if ssRight in Shift then
         Button :=  mbRight
      else
         Button := mbLeft;
      pbDesignerGridMouseDown(Self,Button,Shift,X,Y);
   end;
end;

procedure TfrmDesigner.bitbtnCancelClick(Sender: TObject);
begin
   Self.Close;
end;

procedure TfrmDesigner.bitbtnSaveAsClick(Sender: TObject);
begin
   if CheckLevels() then
   begin
      if dlgSaveFile.Execute then
         SaveFile(dlgSaveFile.FileName);
   end;
end;

procedure TfrmDesigner.bitbtnSaveClick(Sender: TObject);
begin
   if LastFileName = '' then
   begin
      bitbtnSaveAs.Click;
   end
   else
   begin
      if CheckLevels() then
         SaveFile(LastFileName);
   end;
end;

procedure TfrmDesigner.btnAddLevelClick(Sender: TObject);
begin
   if Length(LevelArray) < cnstMaxLevel then
   begin
      AddLevel();
   end;
end;

procedure TfrmDesigner.btnDeleteClick(Sender: TObject);
begin
   if Length(LevelArray) > 1 then
   begin
      DeleteLevel();
   end;
end;

procedure TfrmDesigner.btnElementClick(Sender: TObject);
begin
   IsModified := True;
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

procedure TfrmDesigner.btnLoadClick(Sender: TObject);
var
   i: Integer;
   FileName: string;
begin
//   LevelArray := nil;
   if dlgOpenFile.Execute then
   begin
      FileName := dlgOpenFile.FileName;
      if frmMain.ReadFromFile(FileName) then
      begin
         cmbLevel.Clear;
         for i := 1 to Length(LevelArray) do
            cmbLevel.AddItem(IntToStr(i),nil);
         CurrentLevel := 1;
         cmbLevel.Text := '1';
        // Self.SaveLevelInfo(Self);
         Self.cmbLevelChange(Self);
      end;
   end;
end;

procedure TfrmDesigner.cmbLevelChange(Sender: TObject);
begin

   CurrentLevel := StrToInt(cmbLevel.Text);
   edComment.Text := LevelArray[CurrentLevel-1].Comment;
   edTitle.Text := LevelArray[CurrentLevel-1].Title;
   edEnergy.Text := IntToStr(LevelArray[CurrentLevel-1].StartEnergy);
   pbDesignerGrid.Repaint;
   //DrawMap();
end;

procedure TfrmDesigner.SaveLevelInfo(Sender: TObject);
begin
   LevelArray[CurrentLevel-1].Comment:=edComment.Text;
   LevelArray[CurrentLevel-1].Title:=edTitle.Text;
   if edEnergy.Text <> '' then
      LevelArray[CurrentLevel-1].StartEnergy := StrToInt(edEnergy.Text)
   else
      LevelArray[CurrentLevel-1].StartEnergy := 0;
end;




procedure TfrmDesigner.btFillMapClick(Sender: TObject);
var
   i,j: integer;
begin
   IsModified := True;
   for i := 0 to MapHeight - 1 do
      for j := 0 to MapWidth - 1 do
         LevelArray[CurrentLevel - 1].LevelMap[i,j] := Element;
   DrawMap();
end;

{init-----------------------------------------------------------------------------------------}
procedure TfrmDesigner.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   LevelArray := nil;
   frmMain.Visible := True;
end;

procedure TfrmDesigner.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
   sModified: string;
begin
   sModified := '';
   if IsModified then
      sModified := #13#10'Все несохранённые данные будут утеряны';
   CanClose := Application.MessageBox(PWideChar(sExit+sModified),'Exit', msgQuestionProperty) = mrYes
end;

procedure TfrmDesigner.FormShow(Sender: TObject);
begin
   IsModified := False;
   LastFileName:='';
   LevelArray := nil;
   cmbLevel.Items.Clear;
   AddLevel();
   Element:=elFree;
end;

procedure TfrmDesigner.miHelpClick(Sender: TObject);
begin
   frmHelp.Show;
   frmHelp.pgcHelp.ActivePageIndex := 1;
end;

end.



