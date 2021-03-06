
{$i deltics.radiata.inc}

  unit Deltics.Radiata.Utils;


interface

  uses
    Deltics.StringLists,
    Deltics.Radiata.Interfaces;


  type
    Radiata = class
    public
      class function ParsePropertyNames(const aMessage: String): IStringList;
      class function ParsePropertyReferences(const aMessage: String): IStringList;
    end;


implementation

  uses
    Deltics.Strings;


{ Radiata }

  class function Radiata.ParsePropertyNames(const aMessage: String): IStringList;
  var
    i: Integer;
    refs: IStringList;
    name: String;
    format: String;
  begin
    refs := ParsePropertyReferences(aMessage);

    result := TStringList.CreateManaged;
    result.Unique := TRUE;

    for i := 0 to Pred(refs.Count) do
    begin
      Str.Split(refs[i], ':', name, format);
      result.Add(name);
    end;
  end;


  class function Radiata.ParsePropertyReferences(const aMessage: String): IStringList;
  var
    i: Integer;
    msgLen: Integer;
    inPropertyRef: Boolean;
    propertyRef: String;
  begin
    inPropertyRef := FALSE;
    propertyRef   := '';

    result := TStringList.CreateManaged;

    i       := 1;
    msgLen  := Length(aMessage);
    while i <= msgLen do
    begin
      if inPropertyRef and (aMessage[i] = '}') then
      begin
        inPropertyRef := FALSE;

        result.Add(STR.Lowercase(propertyRef));
      end
      else if (aMessage[i] = '{') then
      begin
        if (i < msgLen) and (aMessage[i + 1] <> '{') then
        begin
          inPropertyRef := TRUE;
          propertyRef   := '';
        end
        else
          Inc(i);
      end
      else if (aMessage[i] = '}') then
      begin
        if (i < msgLen) and (aMessage[i + 1] = '}') then
          Inc(i)
        else
          raise ERadiataLoggerException.CreateFmt('Error in interpolated string ''%s''.'#13'Found ''}'' at %d but but expected ''}}''.', [aMessage, i]);
      end
      else
        propertyRef := propertyRef + aMessage[i];

      Inc(i);
    end;
  end;


end.
