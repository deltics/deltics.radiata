
{$i deltics.radiata.inc}

  unit Deltics.Radiata.Interfaces;


interface

  uses
    SysUtils,
    Deltics.Strings;


  type
    ERadiataLoggerException   = class;
    ILogger                   = interface;
    ILoggerConfiguration      = interface;
    ILoggerSink               = interface;
    ILoggerSinkConfiguration  = interface;
    ILogEvent                 = interface;
    ILogEventProperties       = interface;
    ILogEventProperty         = interface;
    IMessageTemplate          = interface;


    TLogLevel = (lvDebug, lvVerbose, lvInfo, lvHint, lvWarning, lvError, lvFatal);
    TLogLevels = set of TLogLevel;

    TLogEventPropertyType = (ptBoolean, ptDateTime, ptDouble, ptInteger, ptString);

    TLoggerSinkArray = array of ILoggerSink;


    ILogger = interface
    ['{9D1918C9-810D-435D-BAFE-1ABD934285AC}']
      procedure Debug(const aMessage: String); overload;
      procedure Debug(const aMessage: String; aArgs: array of const); overload;
      procedure Verbose(const aMessage: String); overload;
      procedure Verbose(const aMessage: String; aArgs: array of const); overload;
      procedure Info(const aMessage: String); overload;
      procedure Info(const aMessage: String; aArgs: array of const); overload;
      procedure Hint(const aMessage: String); overload;
      procedure Hint(const aMessage: String; aArgs: array of const); overload;
      procedure Warning(const aMessage: String); overload;
      procedure Warning(const aMessage: String; aArgs: array of const); overload;
      procedure Error(const aMessage: String); overload;
      procedure Error(const aMessage: String; aArgs: array of const); overload;
      procedure Fatal(const aMessage: String); overload;
      procedure Fatal(const aMessage: String; aArgs: array of const); overload;
    end;


    ILoggerConfiguration = interface
    ['{1A70C239-DC79-4CA3-8518-C58CD757FE76}']
      procedure InstallLogger;
      procedure InstallNullLogger;
      function CreateLogger: ILogger;
      function Send: ILoggerSinkConfiguration;
      function MinimumLevel(const aLevel: TLogLevel): ILoggerConfiguration;
    end;


    ILoggerSink = interface
    ['{49E80DEC-8BE5-44D9-8F01-CF39317D85CC}']
      procedure Emit(const aEvent: ILogEvent);
      function get_MinimumLevel: TLogLevel;
      property MinimumLevel: TLogLevel read get_MinimumLevel;
    end;


    ILoggerSinkConfiguration = interface
    ['{A4B21BE9-20A6-420A-B6DC-8A4BBDF9D645}']
      function ToConsole: ILoggerConfiguration; overload;
      function ToConsole(const aTemplate: String): ILoggerConfiguration; overload;
      function ToDebugger: ILoggerConfiguration; overload;
      function ToDebugger(const aTemplate: String): ILoggerConfiguration; overload;
      function ToEventLog: ILoggerConfiguration;
      function ToFile(const aFilename: String): ILoggerConfiguration;
      function ToSink(const aSink: ILoggerSink): ILoggerConfiguration;
    end;


    ILogEvent = interface
    ['{6E50BE49-9229-478F-9A4A-4BEB6C50EABF}']
      function get_Exception: Exception;
      function get_Level: TLogLevel;
      function get_Message: String;
      function get_MessageTemplate: String;
      function get_Properties: ILogEventProperties;
      function get_PropertyReferences: IStringList;
      function get_UtcTimeStamp: TDateTime;
      property Exception: Exception read get_Exception;
      property Level: TLogLevel read get_Level;
      property Message: String read get_Message;
      property Properties: ILogEventProperties read get_Properties;
      property PropertyReferences: IStringList read get_PropertyReferences;
      property UtcTimeStamp: TDateTime read get_UtcTimeStamp;
    end;


    ILogEventProperties = interface
    ['{AAC01531-D0C1-4112-93C1-B7CCB1EE9F4C}']
      function get_AsJson: String;
      function get_AsKV: String;
      function get_Count: Integer;
      function get_Item(const aIndex: Integer): ILogEventProperty;
      function get_ItemByName(const aName: String): ILogEventProperty;
      procedure Add(const aName: String; const aValue: TVarRec); overload;
      procedure Add(const aName: String; const aValue: Boolean); overload;
      procedure Add(const aName: String; const aValue: Cardinal); overload;
      procedure Add(const aName: String; const aValue: Double); overload;
      procedure Add(const aName: String; const aValue: Integer); overload;
      procedure Add(const aName: String; const aValue: String); overload;
    {$ifdef EnhancedOverloads}
      procedure Add(const aName: String; const aValue: TDateTime); overload;
    {$else}
      procedure AddDatetime(const aName: String; const aValue: TDateTime); overload;
    {$endif}
      procedure Add(const aProperty: ILogEventProperty); overload;
      property AsJson: String read get_AsJson;
      property AsKV: String read get_AsKV;
      property Count: Integer read get_Count;
      property ItemByName[const aName: String]: ILogEventProperty read get_ItemByName;
      property Items[const aIndex: Integer]: ILogEventProperty read get_Item; default;
    end;


    ILogEventProperty = interface
    ['{86E55532-7B9E-462F-B020-7DE32078D066}']
      function get_AsString: String;
      function get_Name: String;
      function Format(const aFormat: String): String;
      property Name: String read get_Name;
      property AsString: String read get_AsString;
    end;


    ILogEventBooleanProperty = interface(ILogEventProperty)
    ['{5F567DA5-564D-4AE0-B26E-DA93B790D98E}']
      function get_Value: Boolean;
      property Value: Boolean read get_Value;
    end;


    ILogEventDateTimeProperty = interface(ILogEventProperty)
    ['{5F567DA5-564D-4AE0-B26E-DA93B790D98E}']
      function get_Value: TDateTime;
      property Value: TDateTime read get_Value;
    end;


    ILogEventDoubleProperty = interface(ILogEventProperty)
    ['{5F567DA5-564D-4AE0-B26E-DA93B790D98E}']
      function get_Value: Double;
      property Value: Double read get_Value;
    end;


    ILogEventIntegerProperty = interface(ILogEventProperty)
    ['{46855243-98A1-44B4-93D0-EF384C6E01F3}']
      function get_Value: Int64;
      property Value: Int64 read get_Value;
    end;


    ILogEventStringProperty = interface(ILogEventProperty)
    ['{AE735F45-F686-4DEF-B4BD-3CF6057630FC}']
      function get_Value: String;
      property Value: String read get_Value;
    end;


    IMessageTemplate = interface
    ['{36391540-3452-48C3-943C-FFEBF01264C4}']
      function get_Template: String;
      function Render(const aEvent: ILogEvent): String;
      property Template: String read get_Template;
    end;


    ERadiataLoggerException = class(Exception);

  const
    DEFAULT_MESSAGE_TEMPLATE = '{Event.TimeStamp@hh:mm:ss} [{Event.Level}] {Event.Message}';


implementation

end.
