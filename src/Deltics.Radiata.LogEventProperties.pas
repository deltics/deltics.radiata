
  unit Deltics.Radiata.LogEventProperties;

interface

  uses
    SysUtils,
    Deltics.Classes,
    Deltics.Strings,
    Deltics.Radiata.Interfaces;


  type
    TLogEventProperties = class(TComInterfacedObject, ILogEventProperties)
    private
      fItems: IInterfaceList;
      function get_AsJson: String;
      function get_AsKV: String;
      function get_Count: Integer;
      function get_ItemByName(const aName: String): ILogEventProperty;
      function get_Item(const aIndex: Integer): ILogEventProperty;
      procedure Add(const aName: String; const aValue: TVarRec); overload;
      procedure Add(const aName: String; const aValue: Boolean); overload;
      procedure Add(const aName: String; const aValue: Double); overload;
      procedure Add(const aName: String; const aValue: Cardinal); overload;
      procedure Add(const aName: String; const aValue: Integer); overload;
      procedure Add(const aName: String; const aValue: String); overload;
      procedure Add(const aName: String; const aValue: TDateTime); overload;
      procedure Add(const aProperty: ILogEventProperty); overload;
    public
      constructor Create; overload;
      procedure Parse(const aMessage: String; aArgs: array of const; var aReferenceList: IStringList);
    end;


implementation

  uses
    Deltics.Radiata.LogEventProperty,
    Deltics.Radiata.Utils;


{ TLogEventProperties }

  constructor TLogEventProperties.Create;
  begin
    inherited;

    fItems := TInterfaceList.Create;
  end;


  procedure TLogEventProperties.Parse(const aMessage: String;
                                            aArgs: array of const;
                                      var   aReferenceList: IStringList);
  var
    i: Integer;
    name: String;
    format: String;
    names: IStringList;
    argIndex: Integer;
    maxArgIndex: Integer;
  begin
    aReferenceList := Radiata.ParsePropertyReferences(aMessage);

    names := TComInterfacedStringList.Create;
    names.Sorted := TRUE;

    argIndex    := 0;
    maxArgIndex := Pred(Length(aArgs));

    for i := 0 to Pred(aReferenceList.Count) do
    begin
      STR.Split(aReferencelist[i], ':', name, format);
      if name.Contains('.') then
        CONTINUE;

      name := name.ToLower;
      if names.Contains(name) then
        CONTINUE;

      if argIndex > maxArgIndex then
        raise EArgumentException.CreateFmt('Insufficient arguments for message (''%s'').', [aMessage]);

      Add(name, aArgs[argIndex]);
      Inc(argIndex);
    end;
  end;


  procedure TLogEventProperties.Add(const aName: String;
                                    const aValue: TVarRec);
  begin
    fItems.Add(TLogEventProperty.Create(aName, aValue));
  end;


  procedure TLogEventProperties.Add(const aName: String;
                                    const aValue: Double);
  begin
    fItems.Add(TLogEventDoubleProperty.Create(aName, aValue));
  end;


  procedure TLogEventProperties.Add(const aName: String;
                                    const aValue: Boolean);
  begin
    fItems.Add(TLogEventBooleanProperty.Create(aName, aValue));
  end;


  procedure TLogEventProperties.Add(const aName: String;
                                    const aValue: Integer);
  begin
    fItems.Add(TLogEventIntegerProperty.Create(aName, aValue));
  end;


  procedure TLogEventProperties.Add(const aName: String;
                                    const aValue: TDateTime);
  begin
    fItems.Add(TLogEventDateTimeProperty.Create(aName, aValue));
  end;


  procedure TLogEventProperties.Add(const aName: String;
                                    const aValue: Cardinal);
  begin
    fItems.Add(TLogEventIntegerProperty.Create(aName, aValue));
  end;


  procedure TLogEventProperties.Add(const aName: String;
                                    const aValue: String);
  begin
    fItems.Add(TLogEventStringProperty.Create(aName, aValue));
  end;


  function TLogEventProperties.get_AsJson: String;
  var
    i: Integer;
    prop: ILogEventProperty;
  begin
    result := '{ ';

    for i := 0 to Pred(fItems.Count) do
    begin
      prop    := get_Item(i);
      result  := result + '"' + prop.Name + '": "' + prop.AsString + '", ';
    end;

    if fItems.Count > 0 then
      SetLength(result, Length(result) - 2);

    result := result + ' }';
  end;


  function TLogEventProperties.get_AsKV: String;
  var
    i: Integer;
    prop: ILogEventProperty;
  begin
    result := '';

    for i := 0 to Pred(fItems.Count) do
    begin
      prop    := get_Item(i);
      result  := result + prop.Name + ' = ' + prop.AsString + #13;
    end;

    if fItems.Count > 0 then
      SetLength(result, Length(result) - 1);
  end;


  function TLogEventProperties.get_Count: Integer;
  begin
    result := fItems.Count;
  end;


  function TLogEventProperties.get_ItemByName(const aName: String): ILogEventProperty;
  var
    i: Integer;
  begin
    for i := 0 to Pred(fItems.Count) do
    begin
      result := (fItems[i] as ILogEventProperty);
      if STR.SameText(result.Name, aName) then
        EXIT;
    end;

    result := NIL;
  end;


  function TLogEventProperties.get_Item(const aIndex: Integer): ILogEventProperty;
  begin
    result := (fItems[aIndex] as ILogEventProperty);
  end;


  procedure TLogEventProperties.Add(const aProperty: ILogEventProperty);
  begin
    fItems.Add(aProperty);
  end;




end.
