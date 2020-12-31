
{$i deltics.radiata.inc}

  unit Deltics.Radiata.Logger.Null;


interface

  uses
    Deltics.Radiata.Interfaces,
    Deltics.Radiata.Logger;


  type
    TNullLogger = class(TLogger)
    protected
      procedure DoEmit(const aEvent: ILogEvent); override;
      procedure DoLog(const aLevel: TLogLevel; const aMessage: String; aArgs: array of const); override;
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


  procedure TNullLogger.DoEmit(const aEvent: ILogEvent);
  begin
    // NO-OP
  end;


  procedure TNullLogger.DoLog(const aLevel: TLogLevel; const aMessage: String; aArgs: array of const);
  begin
    // NO-OP
  end;



end.
