
  unit Deltics.Radiata.Logger;

interface

  uses
    Deltics.Classes,
    Deltics.Radiata.Interfaces,
    Deltics.Radiata.Logger.Base;


  type
    TLogger = class(TBaseLogger)
    protected
      procedure Emit(const aEvent: ILogEvent); override;
    end;


  var
    Log: ILogger;
    LogConfigured: Boolean = FALSE;


implementation

  uses
    Deltics.Radiata.LogEvent,
    Deltics.Radiata.Logger.Configuration,
    Deltics.Radiata.Logger.Unconfigured;



{ TLogger }

  procedure TLogger.Emit(const aEvent: ILogEvent);
  var
    i: Integer;
  begin
    for i := 0 to Pred(SinkCount) do
      Sinks[i].Emit(aEvent);
  end;




initialization
  Log := TUnconfiguredLogger.Create;
end.
