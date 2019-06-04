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


   TListNodes = class(TObject)
   private

      function ReadFromFile(): Boolean;
   public
      EntryPoint: PUserNode;
      Tail: PUserNode;
      constructor Create();
      destructor Destroy();override;
      procedure Add(UserInfo: TUserInfo);
      procedure DeleteList();
      function IsEmpty(): Boolean;
      procedure WriteToFile();
   end;

//types classes



   EMyExceptions = class(Exception);
   EIncorrectFileFormat = class(EMyExceptions);
   EIncorrectFileData = class(EMyExceptions);
   ECriticalDataLoss = class(EMyExceptions);
   EBallNonExist = class(EMyExceptions);
   EExitNonExist = class(EMyExceptions);
   ETooMuchBalls = class(EMyExceptions);


resourcestring
   MainFile = 'Blip.dat';
   RecordsFile = 'Scores.bur';
   LevelsFileFormat = '.dat';
   TypeFileFormat = '.bur';
   sEOF = 'Попытка чтения за границами файла';
   sNotAssigned = 'Файл не назначен';
   sNotOpen = 'Файл не был открыт';
   sNotRead = 'Файл не был открыт для ввода';
   sNotWrite = 'Файл не был открыт для вывода';
   sBadRead = 'Ошибка входного формата';
   sFileNotExist = 'Файл с таким именем не найден';
   sIncorrectFileFormat = 'Неверный формат файла';
   sIncorrectFileData = 'Файл повреждён или содержит неверные данные';
   sCriticalDataLoss = 'Критическоие повреждения файлов игры.Пожалуйста перестановите игру';
   sBallNonExist =  'Error.Ball not exist in map: ';
   sTooMuchBalls = 'Error.Must be only 1 ball on the map.Too much balls in map: ';
   sExitNonExist = 'Error.Exit not exist in map: ';
//global const
const
   cnstEnergyValue = 20;
   cnstMaxEnergy = 200;
   cnstEnergyLoss = 5;
   cnstMaxLevel = 15;
   ValidNameSymbols = ['A'..'Z','a'..'z','А'..'Я','а'..'я','0'..'9','_','-'];

//global variables
var
   LevelArray: TLevelArray;
   MapWidth: Integer = 20;
   MapHeight: Integer = 30;
   GameMode: TGameMode;
   ListNodes: TListNodes;
//Common methods
procedure AppEventsException(Sender: TObject; E: Exception);



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
     Application.ShowException(E);
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
//   Dispose(Tail);
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
      EntryPoint^.Next := Temp^.Next;
      Dispose(Temp);
   end;
end;



function TListNodes.ReadFromFile():Boolean;
var
   IsFileOpen:Boolean;
   UserFile: TTypeFile;
   Temp: TUserInfo;
begin
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
            //AppEventsException(Self,E);
            CloseFile(UserFile);
            Result := False;
            Exit;
         end;
      end;
   end
   else
   begin
//      MessageBox(Self.Handle,PWideChar(sFileNotExist),'Error',mb_Ok+mb_IconError+mb_ApplModal);
      Rewrite(UserFile);
      CloseFile(UserFile);
      Result := False;
   end;
   if IsFileOpen then
   begin
      try
         Result := True;
      {I+}
      //ioresultCheck
         Seek(UserFile,0);
         while not Eof(UserFile) do
         begin
            Read(UserFile,Temp);
            //raise
            Add(Temp);

         end;

      except
         DeleteList();
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
      abort;
end.
