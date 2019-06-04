object frmUserInfo: TfrmUserInfo
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Maze'
  ClientHeight = 241
  ClientWidth = 515
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clHighlightText
  Font.Height = -15
  Font.Name = 'Ink Free'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 19
  object imBackground: TImage
    Left = 0
    Top = 0
    Width = 513
    Height = 241
    Stretch = True
    Transparent = True
  end
  object lbEnterName: TLabel
    Left = 184
    Top = 8
    Width = 118
    Height = 21
    ParentCustomHint = False
    BiDiMode = bdLeftToRight
    Caption = 'Enter your name'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlightText
    Font.Height = -17
    Font.Name = 'Ink Free'
    Font.Style = []
    ParentBiDiMode = False
    ParentColor = False
    ParentFont = False
    ParentShowHint = False
    ShowHint = False
    Transparent = True
    Visible = False
    WordWrap = True
  end
  object edUserName: TEdit
    Left = 184
    Top = 27
    Width = 121
    Height = 27
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlightText
    Font.Height = -15
    Font.Name = 'Ink Free'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    TextHint = 'Enter your name'
  end
  object btnSave: TButton
    Left = 207
    Top = 192
    Width = 75
    Height = 25
    Caption = 'Accept'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlightText
    Font.Height = -20
    Font.Name = 'Gabriola'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = btnSaveClick
  end
  object PopupMenu1: TPopupMenu
    Left = 496
  end
end
