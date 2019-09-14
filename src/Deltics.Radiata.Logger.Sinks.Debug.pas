
  unit Deltics.Radiata.Logger.Sinks.Debug;

interface

  uses
    Deltics.Classes,
    Deltics.Radiata.Interfaces;


  type
    TDebugSink = class(TComInterfacedObject, ILoggerSink)
    private
      procedure Emit(const aEvent: ILogEvent);
    private
      fMessageTemplate: IMessageTemplate;
    public
      constructor Create(const aTemplate: String = DEFAULT_MESSAGE_TEMPLATE);
    end;


implementation

  uses
    Windows,
    Deltics.Radiata.MessageTemplate;


{ TConsoleSink }

  constructor TDebugSink.Create(const aTemplate: String);
  begin
    inherited Create;

    fMessageTemplate := TMessageTemplate.Create(aTemplate);
  end;


  procedure TDebugSink.Emit(const aEvent: ILogEvent);
  var
    msg: String;
  begin
    msg := fMessageTemplate.Render(aEvent);

    OutputDebugString(PChar(msg));
  end;



end.
