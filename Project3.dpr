program Project3;

uses
  Vcl.Forms,
  uDesigner in 'uDesigner.pas' {fmDesigner},
  uGame in 'uGame.pas' {fmGame},
  Unit4 in 'Unit4.pas',
  uMainMenu in 'uMainMenu.pas' {Form3},
  Unit2 in 'Unit2.pas' {fmMessages};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TfmGame, fmGame);
  Application.CreateForm(TfmDesigner, fmDesigner);
  Application.CreateForm(TfmMessages, fmMessages);
  Application.Run;
end.
