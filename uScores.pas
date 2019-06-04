unit uScores;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls
  ,uMethodsData, Vcl.StdCtrls;

type
   TfrmScores = class(TForm)
      lvScores: TListView;
    btnBack: TButton;
      procedure FormClose(Sender: TObject; var Action: TCloseAction);
      procedure lvScoresColumnClick(Sender: TObject; Column: TListColumn);
      procedure lvScoresCompare(Sender: TObject; Item1, Item2: TListItem;
         Data: Integer; var Compare: Integer);
    procedure FormShow(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
   private
      { Private declarations }
      SortedColumn: Integer;
      Descending: Boolean;
   public
      { Public declarations }
   end;



var
  frmScores: TfrmScores;

implementation

{$R *.dfm}

uses
   uMainMenu;


//start methods to Form
procedure TfrmScores.btnBackClick(Sender: TObject);
begin
   Self.Close;
end;

procedure TfrmScores.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   frmMain.Show;
end;


procedure TfrmScores.FormShow(Sender: TObject);
function SecToTime(Seconds: LongInt): string;
begin
   SecToTime := IntToStr(Seconds div 3600)+':'+IntToStr((Seconds mod 3600)div 60)+':'+IntToStr(Seconds mod 60);
end;
var
   TempNode: PUserNode;
begin

  lvScores.Clear;
  TempNode := ListNodes.EntryPoint.Next;
  while TempNode <> nil do
  begin
    with lvScores.Items.Add do
    begin
      Caption := TempNode.UserInfo.UserName;
      SubItems.Add(IntToStr(TempNode.UserInfo.UserPassedLevels));
      SubItems.Add(SecToTime(TempNode.UserInfo.UserPassedTime));
      if TempNode.UserInfo.UserGameMode = gmStory then
         SubItems.Add('Story mode')
      else
         SubItems.Add('User mode');
    end;
    TempNode := TempNode^.Next;
  end;
end;

procedure TfrmScores.lvScoresColumnClick(Sender: TObject; Column: TListColumn);
begin
  TListView(Sender).SortType := stNone;
  if Column.Index <> SortedColumn then
  begin
    SortedColumn := Column.Index;
    Descending := False;
  end
  else
    Descending := not Descending;
  TListView(Sender).SortType := stText;
end;

procedure TfrmScores.lvScoresCompare(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
begin
   if SortedColumn = 0 then
   begin
      Compare := uMethodsData.CompareTextAsInteger(Item1.Caption, Item2.Caption);
   end
   else
    Compare := CompareTextAsInteger(Item1.SubItems[SortedColumn - 1],Item2.SubItems[SortedColumn - 1]);
   if Descending then
      Compare := -Compare;
end;

end.
