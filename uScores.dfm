object frmScores: TfrmScores
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Scores'
  ClientHeight = 457
  ClientWidth = 463
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lvScores: TListView
    Left = 0
    Top = 0
    Width = 463
    Height = 369
    Align = alTop
    Columns = <
      item
        Caption = 'Username'
        Width = 150
      end
      item
        Caption = 'Passed level'
        Width = 80
      end
      item
        Caption = 'Passed time'
        Width = 110
      end
      item
        Caption = 'Game mode'
        Width = 110
      end>
    ReadOnly = True
    SortType = stText
    TabOrder = 0
    ViewStyle = vsReport
    OnColumnClick = lvScoresColumnClick
    OnCompare = lvScoresCompare
  end
  object btnBack: TButton
    Left = 176
    Top = 392
    Width = 75
    Height = 25
    Caption = 'Back to menu'
    TabOrder = 1
    OnClick = btnBackClick
  end
end
