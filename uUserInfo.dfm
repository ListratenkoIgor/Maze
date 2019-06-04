object frmUserInfo: TfrmUserInfo
  Left = 0
  Top = 0
  Caption = 'frmUserInfo'
  ClientHeight = 231
  ClientWidth = 505
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 184
    Top = 77
    Width = 3
    Height = 13
  end
  object Label2: TLabel
    Left = 200
    Top = 8
    Width = 74
    Height = 13
    Caption = 'Enter yor name'
  end
  object edUserName: TEdit
    Left = 176
    Top = 27
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'User1'
  end
  object btnSave: TButton
    Left = 200
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 1
    OnClick = btnSaveClick
  end
  object PopupMenu1: TPopupMenu
    Left = 432
    Top = 72
  end
end
