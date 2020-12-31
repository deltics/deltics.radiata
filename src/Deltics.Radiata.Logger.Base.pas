
{$i deltics.radiata.inc}

  unit Deltics.Radiata.Logger.Base;


interface

  uses
    Deltics.InterfacedObjects,
    Deltics.Radiata.Interfaces;


  type
    TBaseLogger = class(TComInterfacedObject, ILogger)
    private
      fMinimumLevel: TLogLevel;
      fSinks: TLoggerSinkArray;
      function get_Sink(const aIndex: Integer): ILoggerSink;
      function get_SinkCount: Integer;
    private
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
    protected
      procedure Emit(const aEvent: ILogEvent); virtual; abstract;
      procedure Log(const aLevel: TLogLevel; const aMessage: String); overload;
      procedure Log(const aLevel: TLogLevel; const aMessage: String; aArgs: array of const); overload;
    public
      constructor Create(const aMinimumLevel: TLogLevel; const aSinks: TLoggerSinkArray);
      property MinimumLevel: TLogLevel read fMinimumLevel;
      property SinkCount: Integer read get_SinkCount;
      property Sinks[const aIndex: Integer]: ILoggerSink read get_Sink;
    end;


implementation

  uses
    SysUtils,
    Deltics.Strings,
    Deltics.Radiata.LogEvent,
    Deltics.Radiata.LogEventProperties,
    Deltics.Radiata.MessageTemplate;



{ TBaseLogger }

  constructor TBaseLogger.Create(const aMinimumLevel: TLogLevel;
                                 const aSinks: TLoggerSinkArray);
  begin
    inherited Create;

    fMinimumLevel := aMinimumLevel;
    fSinks        := aSinks;
  end;


  procedure TBaseLogger.Debug(const aMessage: String; aArgs: array of const);
  begin
    Log(lvDebug, aMessage, aArgs);
  end;


  procedure TBaseLogger.Debug(const aMessage: String);
  begin
    Log(lvDebug, aMessage);
  end;


  procedure TBaseLogger.Error(const aMessage: String);
  begin
    Log(lvError, aMessage);
  end;


  procedure TBaseLogger.Error(const aMessage: String; aArgs: array of const);
  begin
    Log(lvError, aMessage, aArgs);
  end;


  procedure TBaseLogger.Fatal(const aMessage: String; aArgs: array of const);
  begin
    Log(lvFatal, aMessage, aArgs);
  end;


  function TBaseLogger.get_Sink(const aIndex: Integer): ILoggerSink;
  begin
    result := fSinks[aIndex];
  end;


  function TBaseLogger.get_SinkCount: Integer;
  begin
    result := Length(fSinks);
  end;


  procedure TBaseLogger.Fatal(const aMessage: String);
  begin
    Log(lvFatal, aMessage);
  end;


  procedure TBaseLogger.Hint(const aMessage: String; aArgs: array of const);
  begin
    Log(lvHint, aMessage, aArgs);
  end;


  procedure TBaseLogger.Hint(const aMessage: String);
  begin
    Log(lvHint, aMessage);
  end;


  procedure TBaseLogger.Info(const aMessage: String);
  begin
    Log(lvInfo, aMessage);
  end;


  procedure TBaseLogger.Info(const aMessage: String; aArgs: array of const);
  begin
    Log(lvInfo, aMessage, aArgs);
  end;


  procedure TBaseLogger.Log(const aLevel: TLogLevel;
                            const aMessage: String);
  begin
    Log(aLevel, aMessage, []);
  end;


  procedure TBaseLogger.Log(const aLevel: TLogLevel;
                            const aMessage: String;
                                  aArgs: array of const);
  var
    event: ILogEvent;
  begin
    if fMinimumLevel > aLevel then EXIT;

    event := TLogEvent.Create(aLevel, aMessage, aArgs);

    // TODO: Enrichment is applied HERE!

    event.Properties.Add('Event.Message', event.Message);

    Emit(event);
  end;


  procedure TBaseLogger.Verbose(const aMessage: String; aArgs: array of const);
  begin
    Log(lvVerbose, aMessage, aArgs);
  end;


  procedure TBaseLogger.Verbose(const aMessage: String);
  begin
    Log(lvVerbose, aMessage);
  end;


  procedure TBaseLogger.Warning(const aMessage: String; aArgs: array of const);
  begin
    Log(lvWarning, aMessage, aArgs);
  end;


  procedure TBaseLogger.Warning(const aMessage: String);
  begin
    Log(lvWarning, aMessage);
  end;

end.
