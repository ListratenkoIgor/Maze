object frmButtonMessage: TfrmButtonMessage
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'frmButtonMessage'
  ClientHeight = 91
  ClientWidth = 242
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBackground: TPanel
    Left = 0
    Top = 0
    Width = 242
    Height = 91
    Align = alClient
    ShowCaption = False
    TabOrder = 0
    object lbComment: TLabel
      Left = 32
      Top = 24
      Width = 175
      Height = 13
      Caption = 'YOU MISSED SOME HEARTS!'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object bitbtnAccept: TBitBtn
      Left = 80
      Top = 43
      Width = 75
      Height = 25
      Cursor = crHandPoint
      DragCursor = crHandPoint
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
      OnClick = bitbtnAcceptClick
    end
  end
end
