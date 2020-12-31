
{$i deltics.radiata.inc}

  unit Deltics.Radiata.Logger.Configuration;


interface

  uses
    Deltics.InterfacedObjects,
    Deltics.Radiata.Interfaces;


  type
    TLoggerConfiguration = class(TComInterfacedObject, ILoggerConfiguration,
                                                       ILoggerSinkConfiguration)
    private
      fMinimumLevel: TLogLevel;
      fSinks: TLoggerSinkArray;
      procedure AddSink(const aSink: ILoggerSink);
    private // ILoggerConfiguration
      function CreateLogger: ILogger;
      procedure CreateDefaultLogger;
      function MinimumLevel(const aLevel: TLogLevel): ILoggerConfiguration;
      function WriteTo: ILoggerSinkConfiguration;
    private // ILoggerSinkConfiguration
      function Console: ILoggerConfiguration; overload;
      function Console(const aTemplate: String): ILoggerConfiguration; overload;
      function Debug: ILoggerConfiguration; overload;
      function Debug(const aTemplate: String): ILoggerConfiguration; overload;
      function EventLog: ILoggerConfiguration;
      function &File(const aFilename: String): ILoggerConfiguration;
      function Sink(const aSink: ILoggerSink): ILoggerConfiguration;
    public
      constructor Create;
    end;


  function LoggerConfiguration: ILoggerConfiguration;


implementation

  uses
    Deltics.Exceptions,
    Deltics.Radiata.Logger,
    Deltics.Radiata.Logger.Sinks.Console,
    Deltics.Radiata.Logger.Sinks.Debug;


  function LoggerConfiguration: ILoggerConfiguration;
  begin
    result := TLoggerConfiguration.Create;
  end;


{ TLoggerConfiguration }

  function TLoggerConfiguration.&File(const aFilename: String): ILoggerConfiguration;
  begin
    raise ENotImplemented.Create('File-based log sinks are not yet supported');
  end;


  procedure TLoggerConfiguration.AddSink(const aSink: ILoggerSink);
  begin
    SetLength(fSinks, Length(fSinks) + 1);
    fSinks[High(fSinks)] := aSink;
  end;


  function TLoggerConfiguration.Console: ILoggerConfiguration;
  begin
    AddSink(TConsoleSink.Create);
  end;


  function TLoggerConfiguration.Console(const aTemplate: String): ILoggerConfiguration;
  begin
    AddSink(TConsoleSink.Create(aTemplate));
  end;


  constructor TLoggerConfiguration.Create;
  begin
    inherited Create;

    fMinimumLevel := lvInfo;
  end;


  procedure TLoggerConfiguration.CreateDefaultLogger;
  begin
    if Deltics.Radiata.Logger.LogConfigured then
      raise EInvalidOperation.Create('Radiata Log has already been configured');

    Deltics.Radiata.Logger.Log            := TLogger.Create(fMinimumLevel, fSinks);
    Deltics.Radiata.Logger.LogConfigured  := TRUE;
  end;


  function TLoggerConfiguration.CreateLogger: ILogger;
  begin
    result := TLogger.Create(fMinimumLevel, fSinks);
  end;


  function TLoggerConfiguration.Debug: ILoggerConfiguration;
  begin
    AddSink(TDebugSink.Create);
  end;


  function TLoggerConfiguration.Debug(const aTemplate: String): ILoggerConfiguration;
  begin
    AddSink(TDebugSink.Create(aTemplate));
  end;


  function TLoggerConfiguration.EventLog: ILoggerConfiguration;
  begin
    raise ENotImplemented.Create('Windows EventLog sink is not yet supported');
  end;


  function TLoggerConfiguration.MinimumLevel(const aLevel: TLogLevel): ILoggerConfiguration;
  begin
    fMinimumLevel := aLevel;
  end;


  function TLoggerConfiguration.Sink(const aSink: ILoggerSink): ILoggerConfiguration;
  begin
    raise ENotImplemented.Create('Custom log sinks are not yet supported');
  end;


  function TLoggerConfiguration.WriteTo: ILoggerSinkConfiguration;
  begin
    result := self;
  end;



end.
