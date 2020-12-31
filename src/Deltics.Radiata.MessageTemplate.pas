
{$i deltics.radiata.inc}

  unit Deltics.Radiata.MessageTemplate;


interface

  uses
    SysUtils,
    StrUtils,
    Deltics.InterfacedObjects,
    Deltics.Strings,
    Deltics.Radiata.Interfaces;


  type
    TMessageTemplate = class(TComInterfacedObject, IMessageTemplate)
    private
      fPropertyReferences: IStringList;
      fTemplate: String;
      function get_Template: String;
      function Render(const aEvent: ILogEvent): String;
    public
      constructor Create(const aTemplate: String);
    end;



implementation

  uses
    Deltics.DateUtils,
    Deltics.Radiata.Utils;


{ TMessageTemplate }

  constructor TMessageTemplate.Create(const aTemplate: String);
  begin
    inherited Create;

    if aTemplate = '' then
//      fTemplate := '{Event.TimeStamp@yyyy-mm-dd hh:nn:ss.zzz} [{Event.Level@U3}] {Event.Message}'
      fTemplate := '{Event.TimeStamp:yyyy-mm-dd hh:nn:ss.zzz} [{Event.Level}] {Event.Message}'
    else
      fTemplate := aTemplate;

    fPropertyReferences := Radiata.ParsePropertyReferences(fTemplate);
  end;


  function TMessageTemplate.get_Template: String;
  begin
    result := fTemplate;
  end;


  function TMessageTemplate.Render(const aEvent: ILogEvent): String;
  var
    i: Integer;
    prop: ILogEventProperty;
    props: ILogEventProperties;
    ref: String;
    name: String;
    format: String;
  begin
    result := fTemplate;

    props := aEvent.Properties;

    for i := 0 to Pred(fPropertyReferences.Count) do
    begin
      ref := fPropertyReferences[i];

      STR.Split(ref, '@', name, format);

      prop := props.ItemByName[name];
      if Assigned(prop) then
        result := STR.ReplaceText(result, '{' + ref + '}', prop.Format(format));
    end;
  end;




end.
