
{$i deltics.radiata.inc}

  unit Deltics.Radiata.Sinks;


interface

  uses
    Deltics.InterfacedObjects,
    Deltics.Radiata.Interfaces;


  type
    TLoggerSink = class(TComInterfacedObject, ILoggerSink)
    private
      fMinimumLevel: TLogLevel;
      function get_MinimumLevel: TLogLevel;
    protected
      procedure DoEmit(const aEvent: ILogEvent); virtual; abstract;
    protected
      procedure Emit(const aEvent: ILogEvent);
    end;



implementation

{ TLoggerSink }

  procedure TLoggerSink.Emit(const aEvent: ILogEvent);
  begin
    if aEvent.Level < fMinimumLevel then
      EXIT;

    DoEmit(aEvent);
  end;


  function TLoggerSink.get_MinimumLevel: TLogLevel;
  begin
    result := fMinimumLevel;
  end;



end.
