
  unit Deltics.Radiata.Logger.Sinks.Console;

interface

  uses
    Deltics.Classes,
    Deltics.Radiata.Interfaces;


  type
    TConsoleSink = class(TComInterfacedObject, ILoggerSink)
    private
      procedure Emit(const aEvent: ILogEvent);
    private
      fMessageTemplate: IMessageTemplate;
    public
      constructor Create(const aTemplate: String = DEFAULT_MESSAGE_TEMPLATE);
    end;


implementation

  uses
    Deltics.Console,
    Deltics.Strings,
    Deltics.Radiata.MessageTemplate;


{ TConsoleSink }

  constructor TConsoleSink.Create(const aTemplate: String);
  begin
    inherited Create;

    fMessageTemplate := TMessageTemplate.Create(aTemplate);
  end;


  procedure TConsoleSink.Emit(const aEvent: ILogEvent);
  const
    COLOR: array[TLogLevel] of String = (
      'silver', // debug
      'white',  // verbose
      'white',  // info
      'green',  // hint
      'yellow', // warning
      'red',    // error
      'red'     // FATAL
    );
  var
    msg: String;
  begin
    msg := fMessageTemplate.Render(aEvent);

    Console.WriteLn('@' + COLOR[aEvent.Level] + '(' + msg + ')');
  end;



end.
