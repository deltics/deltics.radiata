
{$i deltics.radiata.inc}

  unit Deltics.Radiata;


interface

  uses
    Deltics.Radiata.Interfaces;


  type
    ILogger = Deltics.Radiata.Interfaces.ILogger;

    TLogLevel = Deltics.Radiata.Interfaces.TLogLevel;
    TLogLevels = Deltics.Radiata.Interfaces.TLogLevels;


  function Log: ILogger; {$ifdef InlineMethods} inline; {$endif}
  function LoggerConfiguration: ILoggerConfiguration;


implementation

  uses
    Deltics.Radiata.Configuration,
    Deltics.Radiata.Logger;


  function Log: ILogger;
  begin
    result := Deltics.Radiata.Logger.Log;
  end;


  function LoggerConfiguration: ILoggerConfiguration;
  begin
    result := Deltics.Radiata.Configuration.LoggerConfiguration;
  end;


end.
