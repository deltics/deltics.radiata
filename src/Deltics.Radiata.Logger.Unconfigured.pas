
{$i deltics.radiata.inc}

  unit Deltics.Radiata.Logger.Unconfigured;


interface

  uses
    Deltics.Radiata.Interfaces,
    Deltics.Radiata.Logger;


  type
    TUnconfiguredLogger = class(TLogger)
    protected
      procedure DoEmit(const aEvent: ILogEvent); override;
    public
      constructor Create;
    end;


implementation


{ TUnconfiguredLogger }


  constructor TUnconfiguredLogger.Create;
  var
    noSinks: TLoggerSinkArray;
  begin
    inherited Create(lvDebug, noSinks);
  end;


  procedure TUnconfiguredLogger.DoEmit(const aEvent: ILogEvent);

  begin
    raise ERadiataLoggerException.Create('This application uses Deltics Radiata for logging '
                                       + 'but tried to log something before configuring a logger '
                                       + '(or does not configure any logger).');
  end;



end.
