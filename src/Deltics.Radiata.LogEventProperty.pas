
{$i deltics.radiata.inc}

  unit Deltics.Radiata.LogEventProperty;


interface

  uses
    SysUtils,
    Deltics.InterfacedObjects,
    Deltics.Radiata.Interfaces;


  type
    TLogEventProperty = class(TComInterfacedObject, ILogEventProperty)
    private
      fName: String;
      function get_Name: String;
      function Format(const aFormat: String): String;
    protected
      function get_AsString: String; virtual; abstract;
      function DoFormat(const aFormat: String): String; virtual;
    public
      class function Create(const aName: String; aValue: TVarRec): ILogEventProperty; overload;
      constructor Create(const aName: String); overload;
      property AsString: String read get_AsString;
    end;


    TLogEventBooleanProperty = class(TLogEventProperty, ILogEventBooleanProperty)
    private
      fValue: Boolean;
      function get_Value: Boolean;
    protected
      function get_AsString: String; override;
      function DoFormat(const aFormat: String): String; override;
    public
      constructor Create(const aName: String; const aValue: Boolean);
    end;


    TLogEventLogLevelProperty = class(TLogEventProperty, ILogEventProperty)
    private
      fValue: TLogLevel;
    protected
      function get_AsString: String; override;
      function DoFormat(const aFormat: String): String; override;
    public
      constructor Create(const aName: String; const aValue: TLogLevel);
    end;


    TLogEventDateTimeProperty = class(TLogEventProperty, ILogEventDateTimeProperty)
    private
      fValue: TDateTime;
      function get_Value: TDateTime;
    protected
      function get_AsString: String; override;
      function DoFormat(const aFormat: String): String; override;
    public
      constructor Create(const aName: String; const aValue: TDateTime);
    end;


    TLogEventDoubleProperty = class(TLogEventProperty, ILogEventDoubleProperty)
    private
      fValue: Double;
      function get_Value: Double;
    protected
      function get_AsString: String; override;
    public
      constructor Create(const aName: String; const aValue: Double);
    end;


    TLogEventIntegerProperty = class(TLogEventProperty, ILogEventIntegerProperty)
    private
      fValue: Int64;
      function get_Value: Int64;
    protected
      function get_AsString: String; override;
    public
      constructor Create(const aName: String; const aValue: Integer);
    end;


    TLogEventStringProperty = class(TLogEventProperty, ILogEventStringProperty)
    private
      fValue: String;
      function get_Value: String;
    protected
      function get_AsString: String; override;
      function DoFormat(const aFormat: String): String; override;
    public
      constructor Create(const aName: String; const aValue: String);
    end;


implementation

  uses
    TypInfo,
    Deltics.Exceptions,
    Deltics.Pointers,
    Deltics.Strings,
    Deltics.Strings.Parsers.WIDE,
    Deltics.Strings.Parsers.WIDE.AsInteger;


{ TLogEventProperty }

  class function TLogEventProperty.Create(const aName: String;
                                                aValue: TVarRec): ILogEventProperty;
{$ifdef UNICODE}
  var
    s: String;
{$endif}
  begin
    case aValue.VType of
      vtBoolean,
      vtObject,
      vtClass,
      vtInterface:
        raise ENotSupported.Create('Unable to render const array value as string');

      vtInteger:
        result := TLogEventIntegerProperty.Create(aName, aValue.VInteger);

      vtWideChar,
      vtChar:
        if aValue.VType = vtChar then
          result := TLogEventStringProperty.Create(aName, STR.FromANSI(ANSIChar(aValue.VChar)))
        else
          result := TLogEventStringProperty.Create(aName, STR.FromWIDE(WIDEChar(aValue.VWideChar)));

      vtExtended, vtCurrency:
        raise ENotSupported.Create('Unable to render const array value as string');

      vtPointer:
        result := TLogEventStringProperty.Create(aName, IntToHex(IntPointer(aValue.VPointer), SizeOf(Pointer) * 2));

      vtPChar:
        result := TLogEventStringProperty.Create(aName, STR.FromANSI(AnsiString(aValue.VPChar)));

      vtPWideChar:
        result := TLogEventStringProperty.Create(aName, STR.FromBuffer(aValue.VPWideChar));

    {$ifNdef NEXTGEN}
      vtString:
        result := TLogEventStringProperty.Create(aName, UnicodeString(PShortString(aValue.VAnsiString)^));

      vtAnsiString:
        result := TLogEventStringProperty.Create(aName, STR.FromANSI(ANSIString(aValue.VAnsiString^)));

      vtWideString:
        result := TLogEventStringProperty.Create(aName, STR.FromWIDE(PWIDEChar(aValue.VWideString)));
    {$endif !NEXTGEN}

      vtVariant:
      {$ifdef DELPHI2010__}
       if Assigned(System.VarToUStrProc) then
        begin
          System.VarToUStrProc(s, TVarData(aValue.VVariant^));
          result := TLogEventStringProperty.Create(aName, s);
        end
        else
      {$endif}
        raise ENotSupported.Create('Unsupported type');

      vtInt64:
        result := TLogEventIntegerProperty.Create(aName, aValue.VInt64^);

    {$ifdef UNICODE}
      vtUnicodeString:
        result := TLogEventStringProperty.Create(aName, UnicodeString(aValue.VUnicodeString));
    {$endif}

    else
      raise ENotSupported.Create('Unsupported type');
    end;
  end;


  constructor TLogEventProperty.Create(const aName: String);
  begin
    inherited Create;

    fName := aName;
  end;


  function TLogEventProperty.DoFormat(const aFormat: String): String;
  begin
    result := get_AsString;
  end;


  function TLogEventProperty.Format(const aFormat: String): String;
  begin
    if Length(aFormat) > 0 then
      result := DoFormat(aFormat)
    else
      result := get_AsString;
  end;


  function TLogEventProperty.get_Name: String;
  begin
    result := fName;
  end;


(*
  function TLogEventProperty.get_Type: TLogEventPropertyType;
  begin
    result := fType;
  end;
*)





{ TLogEventBooleanProperty }

  constructor TLogEventBooleanProperty.Create(const aName: String;
                                              const aValue: Boolean);
  begin
    inherited Create(aName);

    fValue := aValue;
  end;


  function TLogEventBooleanProperty.DoFormat(const aFormat: String): String;
  begin
    result := get_AsString;

    if Length(aFormat) > 0 then
      case aFormat[1] of
        'l', 'L': result := STR.Lowercase(result);
        'u', 'U': result := STR.Uppercase(result);

        'n', 'N': if fValue then
                    result := '1'
                  else
                    result := '0';
      end;
  end;


  function TLogEventBooleanProperty.get_AsString: String;
  begin
    if fValue then
      result := 'true'
    else
      result := 'false';
  end;


  function TLogEventBooleanProperty.get_Value: Boolean;
  begin
    result := fValue;
  end;



{ TLogEventDateTimeProperty }

  constructor TLogEventDateTimeProperty.Create(const aName: String;
                                               const aValue: TDateTime);
  begin
    inherited Create(aName);

    fValue := aValue;
  end;


  function TLogEventDateTimeProperty.DoFormat(const aFormat: String): String;
  begin
    result := FormatDateTime(aFormat, fValue);
  end;


  function TLogEventDateTimeProperty.get_AsString: String;
  begin
    result := DateTimeToStr(fValue);
  end;


  function TLogEventDateTimeProperty.get_Value: TDateTime;
  begin
    result := fValue;
  end;




{ TLogEventDoubleProperty }

  constructor TLogEventDoubleProperty.Create(const aName: String; const aValue: Double);
  begin
    inherited Create(aName);

    fValue := aValue;
  end;


  function TLogEventDoubleProperty.get_AsString: String;
  begin
    result := FloatToStr(fValue);
  end;


  function TLogEventDoubleProperty.get_Value: Double;
  begin
    result := fValue;
  end;

{ TLogEventIntegerProperty }

  constructor TLogEventIntegerProperty.Create(const aName: String;
                                              const aValue: Integer);
  begin
    inherited Create(aName);

    fValue := aValue;
  end;


  function TLogEventIntegerProperty.get_AsString: String;
  begin
    result := IntToStr(fValue);
  end;


  function TLogEventIntegerProperty.get_Value: Int64;
  begin
    result := fValue;
  end;



{ TLogEventStringProperty }

  constructor TLogEventStringProperty.Create(const aName, aValue: String);
  begin
    inherited Create(aName);

    fValue := aValue;
  end;


  function TLogEventStringProperty.DoFormat(const aFormat: String): String;
  begin
    result := get_AsString;

    if Length(aFormat) > 0 then
      case aFormat[1] of
        'l', 'L': result := STR.Lowercase(result);
        'u', 'U': result := STR.Uppercase(result);
    end;
  end;


  function TLogEventStringProperty.get_AsString: String;
  begin
    result := fValue;
  end;


  function TLogEventStringProperty.get_Value: String;
  begin
    result := fValue;
  end;



{ TLogEventLogLevelProperty }

  constructor TLogEventLogLevelProperty.Create(const aName: String;
                                               const aValue: TLogLevel);
  begin
    inherited Create(aName);

    fValue := aValue;
  end;


  function TLogEventLogLevelProperty.DoFormat(const aFormat: String): String;
  const
    LEVEL_OF_LENGTH: array[1..7] of array[TLogLevel] of String = (
                        ('D', 'V', 'I', 'H', 'W', 'E', 'F'),
                        ('DB', 'VB', 'IN', 'HI', 'WN', 'ER', 'FT'),
                        ('DBG', 'VRB', 'INF', 'HNT', 'WRN', 'ERR', 'FTL'),
                        ('DEBG', 'VERB', 'INFO', 'HINT', 'WARN', 'ERR!', 'FTL!'),
                        ('DEBUG', 'VRBOS', 'INFRM', 'HINT', 'WARN', 'ERROR', 'FATAL'),
                        ('DEBUG', 'VERBOS', 'INFORM', 'HINT', 'WARN', 'ERROR', 'FATAL'),
                        ('DEBUG', 'VERBOSE', 'INFORM', 'HINT', 'WARN', 'ERROR', 'FATAL')
                      );
  var
    len: Integer;
    just: Char;
    caseChar: Char;
  begin
    len       := -1;
    just      := #0;
    caseChar  := #0;

    if Length(aFormat) >= 3 then
      just := STR.Uppercase(aFormat[3]);

    if Length(aFormat) >= 2 then
      len := STR.Parse.AsInteger(aFormat[2]);

    if Length(aFormat) >= 1 then
      caseChar := STR.Uppercase(aFormat[1]);

    case len of
      1..7  : result := LEVEL_OF_LENGTH[len][fValue];
    else
      result := AsString;
    end;

    case caseChar of
      'L': result := STR.Lowercase(result);
      'U': result := STR.Uppercase(result);
    end;

    case just of
      'L': result := STR.PadLeft(result, len);
      'R': result := STR.PadRight(result, len);
    end;
  end;


  function TLogEventLogLevelProperty.get_AsString: String;
  begin
    result := GetEnumName(TypeInfo(TLogLevel), Ord(fValue));
    STR.DeleteLeft(result, 2);
  end;



end.
