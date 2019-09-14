
  unit Deltics.Radiata;

interface

  uses
    Deltics.Radiata.Interfaces;


  type
    ILogger = Deltics.Radiata.Interfaces.ILogger;

    TLogLevel = Deltics.Radiata.Interfaces.TLogLevel;
    TLogLevels = Deltics.Radiata.Interfaces.TLogLevels;


  function Log: ILogger;
  function LoggerConfiguration: ILoggerConfiguration;


implementation

  uses
    Deltics.Radiata.Logger,
    Deltics.Radiata.Logger.Configuration;


  function Log: ILogger;
  begin
    result := Deltics.Radiata.Logger.Log;
  end;


  function LoggerConfiguration: ILoggerConfiguration;
  begin
    result := Deltics.Radiata.Logger.Configuration.LoggerConfiguration;
  end;


end.
