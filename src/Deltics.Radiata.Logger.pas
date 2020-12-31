
{$i deltics.radiata.inc}

  unit Deltics.Radiata.Logger;


interface

  uses
    Deltics.InterfacedObjects,
    Deltics.Radiata.Interfaces;


  type
    TLogger = class(TComInterfacedObject, ILogger)
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
      procedure DoEmit(const aEvent: ILogEvent); virtual;
      procedure DoLog(const aLevel: TLogLevel; const aMessage: String; aArgs: array of const); virtual;
      procedure Emit(const aEvent: ILogEvent);
      procedure Log(const aLevel: TLogLevel; const aMessage: String); overload;
      procedure Log(const aLevel: TLogLevel; const aMessage: String; aArgs: array of const); overload;
    public
      constructor Create(const aMinimumLevel: TLogLevel; const aSinks: TLoggerSinkArray);
      property MinimumLevel: TLogLevel read fMinimumLevel;
      property SinkCount: Integer read get_SinkCount;
      property Sinks[const aIndex: Integer]: ILoggerSink read get_Sink;
    end;


  var
    Log: ILogger;

  procedure InstallLogger(aLogger: ILogger);


implementation

  uses
    SysUtils,
    Deltics.Exceptions,
    Deltics.Radiata.LogEvent,
    Deltics.Radiata.Logger.Unconfigured;


  procedure InstallLogger(aLogger: ILogger);
  var
    logger: IInterfacedObject;
  begin
    if Assigned(Log) then
    begin
      // If the current logger is the initial Unconfigured logger then we
      //  can simply remove that to make way for the configured logger we
      //  wish to install

      if Supports(Log, IInterfacedObject, logger) and (logger.AsObject is TUnconfiguredLogger) then
        Log := NIL
      else
        raise EInvalidOperation.Create('Radiata Log has already been configured');
    end;

    Log := aLogger;
  end;



{ TLogger }

  constructor TLogger.Create(const aMinimumLevel: TLogLevel;
                             const aSinks: TLoggerSinkArray);
  begin
    inherited Create;

    fMinimumLevel := aMinimumLevel;
    fSinks        := aSinks;
  end;


  procedure TLogger.Debug(const aMessage: String; aArgs: array of const);
  begin
    Log(lvDebug, aMessage, aArgs);
  end;


  procedure TLogger.Debug(const aMessage: String);
  begin
    Log(lvDebug, aMessage);
  end;


  procedure TLogger.Error(const aMessage: String);
  begin
    Log(lvError, aMessage);
  end;


  procedure TLogger.Error(const aMessage: String; aArgs: array of const);
  begin
    Log(lvError, aMessage, aArgs);
  end;


  procedure TLogger.Fatal(const aMessage: String; aArgs: array of const);
  begin
    Log(lvFatal, aMessage, aArgs);
  end;


  function TLogger.get_Sink(const aIndex: Integer): ILoggerSink;
  begin
    result := fSinks[aIndex];
  end;


  function TLogger.get_SinkCount: Integer;
  begin
    result := Length(fSinks);
  end;


  procedure TLogger.Fatal(const aMessage: String);
  begin
    Log(lvFatal, aMessage);
  end;


  procedure TLogger.Hint(const aMessage: String; aArgs: array of const);
  begin
    Log(lvHint, aMessage, aArgs);
  end;


  procedure TLogger.Hint(const aMessage: String);
  begin
    Log(lvHint, aMessage);
  end;


  procedure TLogger.Info(const aMessage: String);
  begin
    Log(lvInfo, aMessage);
  end;


  procedure TLogger.Info(const aMessage: String; aArgs: array of const);
  begin
    Log(lvInfo, aMessage, aArgs);
  end;


  procedure TLogger.DoEmit(const aEvent: ILogEvent);
  var
    i: Integer;
  begin
    for i := 0 to Pred(SinkCount) do
      Sinks[i].Emit(aEvent);
  end;


  procedure TLogger.DoLog(const aLevel: TLogLevel; const aMessage: String; aArgs: array of const);
  var
    event: ILogEvent;
  begin
    if fMinimumLevel > aLevel then EXIT;

    event := TLogEvent.Create(aLevel, aMessage, aArgs);

    // TODO: Enrichment is applied HERE!

    event.Properties.Add('Event.Message', event.Message);

    Emit(event);
  end;


  procedure TLogger.Emit(const aEvent: ILogEvent);
  begin
    DoEmit(aEvent);
  end;


  procedure TLogger.Log(const aLevel: TLogLevel;
                            const aMessage: String);
  begin
    Log(aLevel, aMessage, []);
  end;


  procedure TLogger.Log(const aLevel: TLogLevel;
                            const aMessage: String;
                                  aArgs: array of const);
  begin
    DoLog(aLevel, aMessage, aArgs);
  end;


  procedure TLogger.Verbose(const aMessage: String; aArgs: array of const);
  begin
    Log(lvVerbose, aMessage, aArgs);
  end;


  procedure TLogger.Verbose(const aMessage: String);
  begin
    Log(lvVerbose, aMessage);
  end;


  procedure TLogger.Warning(const aMessage: String; aArgs: array of const);
  begin
    Log(lvWarning, aMessage, aArgs);
  end;


  procedure TLogger.Warning(const aMessage: String);
  begin
    Log(lvWarning, aMessage);
  end;




initialization
  Log := TUnconfiguredLogger.Create;
end.
