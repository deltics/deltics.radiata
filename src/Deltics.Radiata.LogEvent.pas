
{$i deltics.radiata.inc}

  unit Deltics.Radiata.LogEvent;


interface

  uses
    SysUtils,
    Deltics.InterfacedObjects,
    Deltics.StringLists,
    Deltics.Strings,
    Deltics.Radiata.Interfaces;


  type
    TLogEvent = class(TComInterfacedObject, ILogEvent)
    private
      fException: Exception;
      fLevel: TLogLevel;
      fMessage: String;
      fMessageTemplate: IMessageTemplate;
      fProperties: ILogEventProperties;
      fPropertyReferences: IStringList;
      fUtcTimeStamp: TDateTime;
      function get_Exception: Exception;
      function get_Level: TLogLevel;
      function get_Message: String;
      function get_MessageTemplate: String;
      function get_Properties: ILogEventProperties;
      function get_PropertyReferences: IStringList;
      function get_UtcTimeStamp: TDateTime;
    public
      constructor Create(const aLevel: TLogLevel; const aMessage: String); overload;
      constructor Create(const aLevel: TLogLevel; const aMessage: String; aArgs: array of const); overload;
    end;


implementation

  uses
    TypInfo,
    Windows,
    Deltics.Datetime,
    Deltics.Radiata.LogEventProperties,
    Deltics.Radiata.LogEventProperty,
    Deltics.Radiata.MessageTemplate,
    Deltics.Radiata.Utils;


{ TLogEvent }

  constructor TLogEvent.Create(const aLevel: TLogLevel;
                               const aMessage: String);
  begin
    Create(aLevel, aMessage, []);
  end;


  constructor TLogEvent.Create(const aLevel: TLogLevel;
                               const aMessage: String;
                                     aArgs: array of const);
  var
    props: TLogEventProperties;
  begin
    inherited Create;

    fLevel        := aLevel;
    fUtcTimeStamp := UtcNow;

    // The 'aMessage" param is actually a template so we initialise the template
    //  member but we don't initialise the message member.  This will be initialized
    //  later, after any Radiata enrichers have run

    fMessageTemplate  := TMessageTemplate.Create(aMessage);

    props := TLogEventProperties.Create;
    props.Parse(aMessage, aArgs, fPropertyReferences);

    fProperties := props;
    fProperties.Add(TLogEventLogLevelProperty.Create('Event.Level', aLevel));
    fProperties.Add('Event.MessageTemplate',  aMessage);
    fProperties.Add('Event.TimeStamp',        fUtcTimeStamp);
    fProperties.Add('Process.Name',           ExtractFileName(ParamStr(0)));
    fProperties.Add('Process.ThreadId',       GetCurrentThreadId);
  end;


  function TLogEvent.get_Exception: Exception;
  begin
    result := fException;
  end;


  function TLogEvent.get_Level: TLogLevel;
  begin
    result := fLevel;
  end;


  function TLogEvent.get_Message: String;
  begin
    if fMessage = '' then
      fMessage := fMessageTemplate.Render(self);

    result := fMessage;
  end;


  function TLogEvent.get_MessageTemplate: String;
  begin
    result := fMessageTemplate.Template;
  end;


  function TLogEvent.get_Properties: ILogEventProperties;
  begin
    result := fProperties;
  end;


  function TLogEvent.get_PropertyReferences: IStringList;
  begin
    result := fPropertyReferences;
  end;


  function TLogEvent.get_UtcTimeStamp: TDateTime;
  begin
    result := fUtcTimeStamp;
  end;

end.
