unit uMethodsData;

interface

uses
    Vcl.Forms,Winapi.Windows,System.SysUtils;

const
   cnstMaxNameLength = 30;

type
//types mytypes
   TElement = (elFree,elWall,elWater,elInvFree,elInvWall,elHeart,elEnergy,elExit,elBall,elWaterBall);//pit,pitExit,teleport
   TGameMode = (gmStory,gmUser);
   TMap = array [0..29,0..19] of TElement ;
//types records
   TLevel = record
      TotalHearts: Integer;
      StartEnergy: Integer;
      InitialX: Integer;
      InitialY: Integer;
      LevelMap: TMap;
      Comment: string;
      Title: string;
   end;
   TLevelArray = array of TLevel;

   TUserName = string[cnstMaxNameLength];
   TUserInfo = record
      UserName: TUserName;
      UserPassedTime: Integer;
      UserPassedLevels: Integer;
      UserGameMode: TGameMode;
   end;

   TTypeFile = file of TUserInfo;

   PUserNode = ^TUserNode;
   TUserNode = record
      UserInfo: TUserInfo;
      Next: PUserNode;
   end;


   TListNodes = class
   private
      function CheckRecord(const Node:TUserInfo): Boolean;
      function IsEmpty(): Boolean;
      function ReadFromFile(): Boolean;
   public
      EntryPoint: PUserNode;
      Tail: PUserNode;
      constructor Create();
      destructor Destroy();override;
      procedure Add(UserInfo: TUserInfo);
      procedure DeleteList();
      function CheckUserName(UserName: string): Boolean;
      procedure WriteToFile();
   end;

   EMyExceptions = class(Exception);
   EIncorrectFileFormat = class(EMyExceptions);
   EIncorrectFileData = class(EMyExceptions);
   ECriticalDataLoss = class(EMyExceptions);
   EIncorrectFileRecords = class(EMyExceptions);
   EBallNonExist = class(EMyExceptions);
   ETooMuchBalls = class(EMyExceptions);
   EExitNonExist = class(EMyExceptions);
   EIncorrectEnergy = class(EMyExceptions);

resourcestring
   MainFile = 'blip.dat';
   RecordsFile = 'Scores.mur';
   LevelsFileFormat = '.dat';
   TypeFileFormat = '.mur';
   sExit = 'Are you sure you want to quit?';
   sProgressLoss = 'Current progress will be lost.';
   sSaveResult = 'Do you want to save the results?';
   sEOF = 'Attempt to read beyond file bounds';
   sNotAssigned = 'File not assigned';
   sNotOpen = 'The file hasn`t been opened.';
   sNotRead = 'The file hasn`t been opened to input.';
   sNotWrite = 'The file hasn`t been opened to output.';
   sBadRead = 'Input format error';
   sFileNotExist = 'No file with this name was found.';
   sIncorrectFileFormat = 'Invalid file format';
   sIncorrectFileData = 'The file is corrupt or contains invalid data.';
   sIncorrectFileRecords = 'The file with user records was damaged. It will be overwritten.';
   sCriticalDataLoss = 'Critical damage to game files. Please reinstall the game.';
   sInvalidUserNameSymbols = 'Username should contain valid symbols: A - Z,a - z,0 - 9,''_'',''-''';
   sInvalidUserNameLength = 'Username should contain 1 or more symbols,but no more 30';
   sBallNonExist =  'Error.Ball not exist in map: ';
   sTooMuchBalls = 'Error.Must be only 1 ball on the map.Too much balls in map: ';
   sExitNonExist = 'Error.Exit not exist in map: ';
   sIncorrectEnergy = 'Error.Invalid energy value in map: ';
//global const
const
   cnstEnergyValue = 20;
   cnstMaxEnergy = 200;
   cnstEnergyLoss = 5;
   cnstMaxLevel = 15;
   ValidNameSymbols = ['A'..'Z','a'..'z','0'..'9','_','-'];

//global variables
var
   LevelArray: TLevelArray;
   MapWidth: Integer = 20;
   MapHeight: Integer = 30;
   msgQuestionProperty: Integer = MB_YESNO+MB_ICONQUESTION+MB_DEFBUTTON2;
   msgErrorProperty: Integer = MB_OK+MB_ICONERROR+MB_APPLMODAL;
   GameMode: TGameMode;
   ListNodes: TListNodes;

//Common methods
procedure AppEventsException(Sender: TObject; E: Exception);
function CompareTextAsInteger(const S1,S2: string):Integer;
function TryStrToInt(const S1: string): Boolean;

implementation
//start block of common methods
procedure AppEventsException(Sender: TObject; E: Exception);
begin
   if E is EInOutError then
   case EInOutError(E).ErrorCode of
      100: E.Message := sEOF;
      101: E.Message := SysErrorMessage(Error_Disk_Full);
      102: E.Message := sNotAssigned;
      103: E.Message := sNotOpen;
      104: E.Message := sNotRead;
      105: E.Message := sNotWrite;
      106: E.Message := SBadRead;
   else
      E.Message := SysErrorMessage(EInOutError(E).ErrorCode);
   end;
   if E is EIncorrectFileFormat then
      E.Message := sIncorrectFileFormat;
   if E is EIncorrectFileData then
      E.Message := sIncorrectFileData;
   if E is ECriticalDataLoss then
      E.Message := sCriticalDataLoss;
   if E is EIncorrectFileRecords then
      E.Message := sIncorrectFileRecords;
   Application.ShowException(E);
end;

function TryStrToInt(const S1: string): Boolean;
begin
   try
      StrToInt(S1);
      Result := True;
   except
      Result := False;
   end;
end;

function CompareTextAsInteger(const S1,S2: string):Integer;
begin
   if TryStrToInt(S1) and TryStrToInt(S2) then
      if (StrToInt(S1) < StrToInt(S2)) then
         CompareTextAsInteger := 1
      else
         CompareTextAsInteger := -1
   else
      CompareTextAsInteger := CompareText(S1,S2);
end;

//start block methods for TListNode
constructor TListNodes.Create();
begin
   New(EntryPoint);
   EntryPoint.Next := nil;
   New(Tail);
   Tail := nil;
end;

destructor TListNodes.Destroy();
begin
   inherited;
   DeleteList();
   Dispose(EntryPoint);
end;

function TListNodes.IsEmpty():Boolean;
begin
   IsEmpty := EntryPoint.Next = nil;
end;

procedure TListNodes.Add(UserInfo: TUserInfo);
var
   Temp: PUserNode;
begin
   New(Temp);
   Temp.UserInfo := UserInfo;
   Temp.Next := nil;
   if IsEmpty() then
      EntryPoint.Next := Temp
   else
      Tail.Next := Temp;
   Tail := Temp;
end;

procedure TListNodes.DeleteList();
var
   Temp: PUserNode;
begin
   while not IsEmpty() do
   begin
      Temp := EntryPoint^.Next;
      if Temp = Tail then
         Tail := EntryPoint;
      EntryPoint^.Next := Temp^.Next;
      Dispose(Temp);
   end;
end;

function TListNodes.CheckUserName(UserName: string): Boolean;
var
   IsCorrect: Boolean;
   i: Integer;
begin
   IsCorrect := (Length(UserName) <= cnstMaxNameLength) and (Length(UserName) > 0);
   i := 1;
   while IsCorrect and (i <= Length(UserName)) do
   begin
      IsCorrect := UserName[i] in ValidNameSymbols;
      Inc(i);
   end;
   CheckUserName := IsCorrect;
end;

function TListNodes.CheckRecord(const Node: TUserInfo):Boolean;
begin
   CheckRecord := CheckUserName(Node.UserName) and (Node.UserPassedTime >= 0) and (Node.UserPassedLevels >= 0);
end;

function TListNodes.ReadFromFile():Boolean;
var
   IsFileOpen:Boolean;
   UserFile: TTypeFile;
   Temp: TUserInfo;
begin
   {I-}
   IsFileOpen:=False;
   AssignFile(UserFile,RecordsFile);
   if FileExists(RecordsFile) then
   begin
      try
         Reset(UserFile);
         IsFileOpen := True;
      except
         on E: Exception do
         begin
            CloseFile(UserFile);
            Result := False;
         end;
      end;
   end
   else
   begin
      Rewrite(UserFile);
      CloseFile(UserFile);
      Result := True;
      IsFileOpen := False;
   end;
   if IsFileOpen then
   begin
      try
         Result := True;
      {I+}
         Seek(UserFile,0);
         while not Eof(UserFile) do
         begin
            Read(UserFile,Temp);
            if not CheckRecord(Temp) then
               raise EIncorrectFileRecords.Create('');
            Add(Temp);
         end;
      except
         on E:EMyExceptions do
         begin
            AppEventsException(Self,E);
            DeleteList();
            CloseFile(UserFile);
            Rewrite(UserFile);
         end;
      end;
      CloseFile(UserFile);
   end;
end;

procedure TListNodes.WriteToFile();
var
   IsFileOpen: Boolean;
   UserFile: TTypeFile;
   Temp: PUserNode;
begin
   AssignFile(UserFile,RecordsFile);
   try
      Rewrite(UserFile);
      Temp := EntryPoint.Next;
      while Temp <> nil do
      begin
         Write(UserFile,Temp.UserInfo);
         Temp := Temp.Next;
      end;
   except

   end;
   CloseFile(UserFile);
end;

begin
   ListNodes := TListNodes.Create();
   if not ListNodes.ReadFromFile()then
      Abort;
end.
