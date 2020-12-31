
{$i deltics.radiata.inc}

  unit Deltics.Radiata.Logger.Null;


interface

  uses
    Deltics.Radiata.Interfaces,
    Deltics.Radiata.Logger.Base;


  type
    TNullLogger = class(TBaseLogger)
    protected
      procedure Emit(const aEvent: ILogEvent); override;
      procedure Log(const aLevel: TLogLevel; const aMessage: String; aArgs: array of const); override;
    public
      constructor Create;
    end;


implementation


{ TUnconfiguredLogger }


  constructor TNullLogger.Create;
  var
    noSinks: TLoggerSinkArray;
  begin
    inherited Create(lvDebug, noSinks);
  end;


  procedure TNullLogger.Emit(const aEvent: ILogEvent);
  begin
    // NO-OP
  end;


  procedure TNullLogger.Log(const aLevel: TLogLevel; const aMessage: String; aArgs: array of const);
  begin
    // NO-OP
  end;



end.
