object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'frmMain'
  ClientHeight = 231
  ClientWidth = 443
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object btnNewGame: TButton
    Left = 176
    Top = 32
    Width = 75
    Height = 25
    Caption = 'New game'
    TabOrder = 0
    OnClick = btnNewGameClick
  end
  object btnLoad: TButton
    Left = 176
    Top = 63
    Width = 75
    Height = 25
    Caption = 'Load game'
    TabOrder = 1
    OnClick = btnLoadClick
  end
  object btnDesigner: TButton
    Left = 176
    Top = 94
    Width = 75
    Height = 25
    Caption = 'Designer'
    TabOrder = 2
    OnClick = btnDesignerClick
  end
  object btnScore: TButton
    Left = 176
    Top = 125
    Width = 75
    Height = 25
    Caption = 'Score'
    TabOrder = 3
  end
  object dlgOpenFile: TOpenTextFileDialog
    Filter = 'Levels files (*.dat)|*.dat|All files (*.*)|*.*'
    Left = 376
    Top = 40
  end
end
