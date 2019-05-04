unit Unit4;

interface

uses
   Vcl.Grids,Vcl.Controls,System.SysUtils;
type
   TElement = (elFree,elWall,elWater,elInvFree,elInvWall,elHeart,elEnergy,elExit,elBall,elWaterBall);//pit,pitExit,teleport
   TMap = array [0..29,0..19] of TElement ;


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


   EMyExceptions = class(Exception);
   EBallNonExist = class(EMyExceptions);
//EHeartNonExist = class(Exception);
   EExitNonExist = class(EMyExceptions);
   ETooMuchBalls = class(EMyExceptions);
const
   EnergyValue = 20;
   MaxEnergy = 200;
resourcestring
   sEOF = 'Попытка чтения за границами файла';
   sNotAssigned = 'Файл не назначен';
   sNotOpen = 'Файл не был открыт';
   sNotRead   = 'Файл не был открыт для ввода';
   sNotWrite  = 'Файл не был открыт для вывода';
   sBadRead   = 'Ошибка входного формата';
   sBallNonExist =  'Error.Ball not exist in map: ';
   sTooMuchBalls = 'Error.Must be only 1 ball on the map.Too much balls in map: ';
   sExitNonExist = 'Error.Ball not exist in map: ';

var
   ElementList: TImageList;
   LevelArray: TLevelArray;
   Element: TElement;
   MapWidth: Integer = 20;
   MapHeight: Integer = 30;
   MaxLevel: Integer = 15;
   myMap: TMap  =         {
  ((elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall),
   (elWall,elFree,elFree,elFree,elFree,elFree,elWall,elExit,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall),
   (elWall,elFree,elFree,elFree,elWater,elWater,elWall,elFree,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall),
   (elWall,elFree,elFree,elBall,elFree,elWall,elFree,elFree,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall),
   (elWall,elFree,elFree,elFree,elFree,elFree,elWall,elFree,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall),
   (elWall,elFree,elFree,elFree,elFree,elFree,elWall,elFree,elWall,elWall,elEnergy,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall),
   (elWall,elFree,elFree,elFree,elFree,elFree,elWall,elFree,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall),
   (elWall,elFree,elFree,elFree,elFree,elFree,elWall,elFree,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall),
   (elWall,elFree,elFree,elFree,elFree,elFree,elWall,elFree,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall),
   (elWall,elFree,elFree,elFree,elFree,elFree,elWall,elFree,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall),
   (elWall,elFree,elFree,elFree,elFree,elFree,elFree,elFree,elFree,elFree,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall),
   (elWall,elFree,elFree,elFree,elFree,elFree,elWall,elFree,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall),
   (elWall,elFree,elFree,elFree,elFree,elFree,elWall,elFree,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall),
   (elWall,elFree,elFree,elFree,elFree,elFree,elWall,elFree,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall),
   (elWall,elFree,elFree,elFree,elFree,elFree,elWall,elFree,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall),
   (elWall,elFree,elFree,elFree,elFree,elFree,elWall,elFree,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall),
   (elWall,elFree,elFree,elFree,elFree,elFree,elWall,elFree,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall),
   (elWall,elFree,elFree,elFree,elFree,elFree,elWall,elFree,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall),
   (elWall,elFree,elFree,elFree,elFree,elFree,elWall,elFree,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall),
   (elWall,elFree,elFree,elFree,elFree,elFree,elWall,elFree,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall),
   (elWall,elFree,elFree,elFree,elFree,elFree,elWall,elFree,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall),
   (elWall,elFree,elFree,elFree,elFree,elFree,elWall,elFree,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall),
   (elWall,elFree,elFree,elFree,elFree,elFree,elWall,elFree,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall),
   (elWall,elFree,elFree,elFree,elFree,elFree,elWall,elFree,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall),
   (elWall,elFree,elFree,elFree,elFree,elFree,elWall,elFree,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall),
   (elWall,elFree,elFree,elFree,elFree,elFree,elWall,elFree,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall),
   (elWall,elFree,elFree,elFree,elFree,elFree,elWall,elFree,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall),
   (elWall,elFree,elFree,elFree,elFree,elFree,elWall,elFree,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall),
   (elWall,elFree,elFree,elFree,elFree,elFree,elWall,elFree,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall),
   (elWall,elFree,elFree,elFree,elFree,elFree,elWall,elFree,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall));
}
((elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall),
(elWall,elFree,elFree,elFree,elFree,elWall,elFree,elFree,elFree, elFree,elFree,elFree,elFree,elWall,elFree,elFree,elFree,elFree,elFree,elWall),
(elWall,elFree,elBall,elFree,elFree,elWall,elFree,elFree,elHeart,elHeart,elFree,elWall,elFree,elWall,elFree,elFree,elHeart,elHeart,elFree,elWall),
(elWall,elFree,elFree,elFree,elFree,elWall,elFree,elFree,elHeart,elHeart,elFree,elWall,elFree,elWall,elFree,elFree,elHeart,elHeart,elFree,elWall),
(elWall,elFree,elFree,elFree,elFree,elWall,elFree,elFree,elFree, elFree,elFree,elWall,elFree,elFree,elFree,elFree,elFree,elFree,elFree,elWall),
(elWall,elFree,elFree,elFree,elFree,elWall,elFree,elFree,elFree, elFree,elFree,elWall,elFree,elWall,elFree,elFree,elFree,elEnergy,elFree,elWall),
(elWall,elFree,elFree,elFree,elFree,elWall,elWall,elWall,elWall, elWall,elWall,elWall,elFree,elWall,elFree,elFree,elFree,elFree,elFree,elWall),
(elWall,elFree,elWall,elWall,elWall,elWall,elFree,elFree,elFree, elFree,elFree,elFree,elFree,elWall,elWall,elWall,elWall,elWall,elWall,elWall),
(elWall,elFree,elFree,elFree,elFree,elFree,elFree,elWall,elWall, elWall,elWall,elWall,elFree,elFree,elWall,elHeart,elHeart,elFree,elFree,elWall),
(elWall,elWall,elWall,elWall,elWall,elWall,elWall,elFree,elFree, elFree,elFree,elFree,elWall,elFree,elWall,elHeart,elHeart,elFree,elFree,elWall),
(elWall,elFree,elFree,elFree,elFree,elFree,elWall,elFree,elHeart,elHeart,elFree,elFree,elWall,elFree,elWall,elFree,elFree,elFree,elFree,elWall),
(elWall,elFree,elFree,elFree,elFree,elFree,elWall,elFree,elHeart,elHeart,elFree,elFree,elFree,elFree,elWall,elWall,elWall,elFree,elFree,elWall),
(elWall,elFree,elHeart,elHeart,elFree,elFree,elWall,elFree,elFree,elFree,elFree,elFree,elWall{},elFree,elWall,elFree,elFree,elFree,elFree,elWall),
(elWall,elFree,elHeart,elHeart,elFree,elFree,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elFree{},elWall,elFree,elWall,elFree,elFree,elWall),
(elWall,elFree,elFree,elFree,elFree,elFree,elWall,elFree,elWall, elFree,elFree,elFree,elFree,elFree,elFree,elFree,elWall,elFree,elFree,elWall),
(elWall,elFree,elFree,elFree,elFree,elFree,elFree,elFree,elWall, elFree,elFree,elFree,elFree,elFree,elWall,elFree,elWall,elFree,elFree,elWall),
(elWall,elFree,elFree,elFree,elFree,elFree,elWall,elFree,elWall, elFree,elFree,elFree,elFree,elFree,elWall,elFree,elWall,elFree,elFree,elWall),
(elWall,elWall,elWall,elWall,elWall,elWall,elWall,elFree,elWall, elWall,elHeart,elHeart,elWall,elWall,elWall,elFree,elWall,elWall,elFree,elWall),
(elWall,elFree,elFree,elFree,elFree,elFree,elFree,elFree,elFree, elWall,elHeart,elHeart,elWall,elFree,elFree,elFree,elFree,elFree,elFree,elWall),
(elWall,elFree,elWall,elWall,elWall,elWall,elWall,elWall,elFree, elWall,elWall,elWall,elWall,elFree,elWall,elWall,elWall,elWall,elWall,elWall),
(elWall,elFree,elFree,elFree,elFree,elFree,elFree,elWall,elFree,elFree,elFree,elFree,elFree,elFree,elFree,elFree,elFree,elFree,elFree,elWall),
(elWall,elFree,elFree,elFree,elFree,elFree,elFree,elWall,elFree,elWall,elWall,elWall,elFree,elFree,elWall,elWall,elWall,elWall,elFree,elWall),
(elWall,elFree,elFree,elFree,elFree,elFree,elFree,elWall,elFree,elWall,elFree,elFree,elFree,elFree,elWall,elFree,elFree,elFree,elFree,elWall),
(elWall,elFree,elFree,elHeart,elHeart,elFree,elFree,elWall,elFree,elWall,elFree,elFree,elFree,elFree,elWall,elFree,elFree,elFree,elFree,elWall),
(elWall,elFree,elFree,elHeart,elHeart,elFree,elWall,elFree,elFree,elWall,elFree,elFree,elFree,elFree,elWall,elFree,elEnergy,elFree,elFree,elWall),
(elWall,elFree,elFree,elFree,elFree,elFree,elWall,elFree,elWall,elWall,elFree,elFree,elFree,elFree,elWall,elFree,elFree,elFree,elFree,elWall),
(elWall,elFree,elFree,elFree,elFree,elFree,elWall,elFree,elWall,elFree,elFree,elFree,elFree,elFree,elWall,elFree,elHeart,elHeart,elFree,elWall),
(elWall,elWall,elWall,elWall,elWall,elWall,elWall,elFree,elWall,elHeart,elHeart,elFree,elFree,elFree,elWall,elFree,elHeart,elHeart,elFree,elWall),
(elWall,elExit,elFree,elFree,elFree,elFree,elFree,elFree,elWall,elHeart,elHeart,elFree,elFree,elFree,elWall,elFree,elFree,elFree,elFree,elWall),
(elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall,elWall));


MyLevel:TLevel;

implementation

begin



end.
