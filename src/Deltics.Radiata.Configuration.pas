
{$i deltics.radiata.inc}

  unit Deltics.Radiata.Configuration;


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
      procedure InstallLogger;
      procedure InstallNullLogger;
      function MinimumLevel(const aLevel: TLogLevel): ILoggerConfiguration;
      function Send: ILoggerSinkConfiguration;
    private // ILoggerSinkConfiguration
      function ToConsole: ILoggerConfiguration; overload;
      function ToConsole(const aTemplate: String): ILoggerConfiguration; overload;
      function ToDebugger: ILoggerConfiguration; overload;
      function ToDebugger(const aTemplate: String): ILoggerConfiguration; overload;
      function ToEventLog: ILoggerConfiguration;
      function ToFile(const aFilename: String): ILoggerConfiguration;
      function ToSink(const aSink: ILoggerSink): ILoggerConfiguration;
    public
      constructor Create;
    end;


  function LoggerConfiguration: ILoggerConfiguration;


implementation

  uses
    Deltics.Exceptions,
    Deltics.Radiata.Logger,
    Deltics.Radiata.Logger.Null,
    Deltics.Radiata.Sinks.Console,
    Deltics.Radiata.Sinks.Debug;


  function LoggerConfiguration: ILoggerConfiguration;
  begin
    result := TLoggerConfiguration.Create;
  end;


{ TLoggerConfiguration }

  function TLoggerConfiguration.ToFile(const aFilename: String): ILoggerConfiguration;
  begin
    raise ENotImplemented.Create('File-based log sinks are not yet supported');
  end;


  procedure TLoggerConfiguration.AddSink(const aSink: ILoggerSink);
  begin
    SetLength(fSinks, Length(fSinks) + 1);
    fSinks[High(fSinks)] := aSink;
  end;


  function TLoggerConfiguration.ToConsole: ILoggerConfiguration;
  begin
    AddSink(TConsoleSink.Create);
  end;


  function TLoggerConfiguration.ToConsole(const aTemplate: String): ILoggerConfiguration;
  begin
    AddSink(TConsoleSink.Create(aTemplate));
  end;


  constructor TLoggerConfiguration.Create;
  begin
    inherited Create;

    fMinimumLevel := lvInfo;
  end;


  procedure TLoggerConfiguration.InstallLogger;
  begin
    Deltics.Radiata.Logger.InstallLogger(TLogger.Create(fMinimumLevel, fSinks));
  end;


  procedure TLoggerConfiguration.InstallNullLogger;
  begin
    Deltics.Radiata.Logger.InstallLogger(TNullLogger.Create);
  end;


  function TLoggerConfiguration.CreateLogger: ILogger;
  begin
    result := TLogger.Create(fMinimumLevel, fSinks);
  end;


  function TLoggerConfiguration.ToDebugger: ILoggerConfiguration;
  begin
    AddSink(TDebugSink.Create);
  end;


  function TLoggerConfiguration.ToDebugger(const aTemplate: String): ILoggerConfiguration;
  begin
    AddSink(TDebugSink.Create(aTemplate));
  end;


  function TLoggerConfiguration.ToEventLog: ILoggerConfiguration;
  begin
    raise ENotImplemented.Create('Windows EventLog sink is not yet supported');
  end;


  function TLoggerConfiguration.MinimumLevel(const aLevel: TLogLevel): ILoggerConfiguration;
  begin
    fMinimumLevel := aLevel;
  end;


  function TLoggerConfiguration.ToSink(const aSink: ILoggerSink): ILoggerConfiguration;
  begin
    raise ENotImplemented.Create('Custom log sinks are not yet supported');
  end;


  function TLoggerConfiguration.Send: ILoggerSinkConfiguration;
  begin
    result := self;
  end;



end.
