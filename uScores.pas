unit uScores;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  uMethodsData;

type
   TfrmScores = class(TForm)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
   private
      { Private declarations }

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
procedure TfrmScores.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   frmMain.Show;
end;


end.
