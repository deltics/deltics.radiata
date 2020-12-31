
{$i deltics.radiata.inc}

  unit Deltics.Radiata.Sinks.Debug;


interface

  uses
    Deltics.InterfacedObjects,
    Deltics.Radiata.Interfaces,
    Deltics.Radiata.Sinks;


  type
    TDebugSink = class(TLoggerSink)
    private
      fMessageTemplate: IMessageTemplate;
    protected
      procedure DoEmit(const aEvent: ILogEvent); override;
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


  procedure TDebugSink.DoEmit(const aEvent: ILogEvent);
  var
    msg: String;
  begin
    msg := fMessageTemplate.Render(aEvent);

    OutputDebugString(PChar(msg));
  end;



end.
