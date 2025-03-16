namespace IOI.ContractIQ;

using System.IO;
using System.Utilities;

codeunit 70008 "SR Import IOI"
{
    procedure ProcessJson(var TempBlob: Codeunit "Temp Blob"; Progressbar: codeunit "Progressbar IOI")
    var
        SRExtension: record "SR Extension IOI";
        FileStream: InStream;
        JsonText: Text;
        NameSpaceText: Text;
        AppPackageID: Guid;
        AppName: text;
        AppPublisher: text;
        AppVersion: text;
        JsonObject: JsonObject;
        NamespaceArray: JsonArray;
        NamespaceToken: JsonToken;
        SkipText: Text[3];
        UpdateNessesary: Boolean;
    begin
        Progressbar.ProgressbarInit();
        // Read the file content as text
        TempBlob.CreateInStream(FileStream);
        FileStream.Read(SkipText);
        FileStream.Read(JsonText); // Correct method for converting InStream to Text

        // Durchsuche alle Namespaces nach Codeunits und Tables
        if JsonObject.ReadFrom(JsonText) then begin
            AppPackageID := this.GetGuidFromJson(JsonObject, 'AppId', AppPackageID);
            AppName := this.GetTextFromJson(JsonObject, 'Name', AppName);
            AppPublisher := this.GetTextFromJson(JsonObject, 'Publisher', AppPublisher);
            AppVersion := this.GetTextFromJson(JsonObject, 'Version', AppVersion);

            if not SRExtension.Get(AppPackageID) then begin
                SRExtension."App Package ID" := AppPackageID;
                SRExtension.Insert();
                UpdateNessesary := true;
            end;
            if SRExtension."Version" <> CopyStr(AppVersion, 1, MaxStrLen(SRExtension."Version")) then begin
                SRExtension."Publisher" := CopyStr(AppPublisher, 1, MaxStrLen(SRExtension."Publisher"));
                SRExtension."Version" := CopyStr(AppVersion, 1, MaxStrLen(SRExtension."Version"));
                SRExtension.Modify();
                UpdateNessesary := true;
            end;
            //            if UpdateNessesary then begin
            this.DeleteObjectData(AppPackageID);
            if this.GetJsonArray(JsonObject, 'Namespaces', NamespaceArray) then
                foreach NamespaceToken in NamespaceArray do
                    this.DumpNamespaceJsonToTable(NamespaceToken, NameSpaceText, AppPackageID, AppName, Progressbar);
            //            end;
        end;
        Progressbar.ProgressbarClose();
    end;

    local procedure DumpNamespaceJsonToTable(JsonToken: JsonToken; NameSpaceText: Text; AppPackageID: Guid; AppName: Text; Progressbar: codeunit "Progressbar IOI")
    var
        NamespaceArray, CodeunitArray, TableArray : JsonArray;
        NamespaceToken, CodeunitToken, TableToken : JsonToken;
        SubNamespaceText: Text;
    begin
        Progressbar.ProgressbarUpdate(1, NameSpaceText);
        if this.GetJsonArray(JsonToken.AsObject(), 'Namespaces', NamespaceArray) then begin
            SubNamespaceText := this.GetTextFromJson(JsonToken.AsObject(), 'Name', SubNamespaceText);
            foreach NamespaceToken in NamespaceArray do
                if NameSpaceText <> '' then
                    this.DumpNamespaceJsonToTable(NamespaceToken, NameSpaceText + '.' + SubNamespaceText, AppPackageID, AppName, Progressbar)
                else
                    this.DumpNamespaceJsonToTable(NamespaceToken, SubNamespaceText, AppPackageID, AppName, Progressbar)
        end;
        if this.GetJsonArray(JsonToken.AsObject(), 'Codeunits', CodeunitArray) then
            foreach CodeunitToken in CodeunitArray do
                this.DumpCodeunitJsonToTable(CodeunitToken, NameSpaceText, AppPackageID, AppName, Progressbar);
        if this.GetJsonArray(JsonToken.AsObject(), 'Tables', TableArray) then
            foreach TableToken in TableArray do
                this.DumpTableJsonToTable(TableToken, NameSpaceText, AppPackageID, AppName, Progressbar);
        if this.GetJsonArray(JsonToken.AsObject(), 'EnumTypes', TableArray) then
            foreach TableToken in TableArray do
                this.DumpEnumTypesJsonToTable(TableToken, NameSpaceText, AppPackageID, AppName, Progressbar);
    end;

    local procedure DumpEnumTypesJsonToTable(JsonToken: JsonToken; NameSpaceText: Text; AppPackageID: Guid; AppName: Text; Progressbar: codeunit "Progressbar IOI")
    var
        SREnumType: record "SR Object IOI";
        EnumTypeName: Text;
        EnumTypeID: Integer;
        EnumValueArray, PropertyArray : JsonArray;
        EnumValueToken, PropertyToken : JsonToken;
    begin
        EnumTypeName := this.GetTextFromJson(JsonToken.AsObject(), 'Name', EnumTypeName);
        EnumTypeID := this.GetIntegerFromJson(JsonToken.AsObject(), 'Id', EnumTypeID);
        Progressbar.ProgressbarUpdate(2, EnumTypeName);
        Progressbar.ProgressbarUpdate(3, AppName);

        if this.GetJsonArray(JsonToken.AsObject(), 'Values', EnumValueArray) then
            foreach EnumValueToken in EnumValueArray do
                this.DumpEnumValueJsonToTable(EnumValueToken, EnumTypeID);
        if this.GetJsonArray(JsonToken.AsObject(), 'Properties', PropertyArray) then
            foreach PropertyToken in PropertyArray do
                this.DumpPropertyJsonToTable(PropertyToken, EnumTypeID, 0, '');

        if not SREnumType.Get(SREnumType."Object Type"::Enum, EnumTypeID) then begin
            SREnumType."Object Type" := "SR Object Type IOI"::Enum;
            SREnumType."Object ID" := EnumTypeID;
            SREnumType."Object Name" := CopyStr(EnumTypeName, 1, MaxStrLen(SREnumType."Object Name"));
            SREnumType."App Package ID" := AppPackageID;
            SREnumType.Namespace := CopyStr(NameSpaceText, 1, MaxStrLen(SREnumType.Namespace));
            SREnumType.Insert();
        end;
    end;

    local procedure DumpEnumValueJsonToTable(JsonToken: JsonToken; EnumTypeID: Integer)
    var
        SREnumValue: record "SR Object Detail IOI";
        EnumValueName: Text;
        EnumValueID: Integer;
        PropertyArray: JsonArray;
        PropertyToken: JsonToken;
    begin
        EnumValueName := this.GetTextFromJson(JsonToken.AsObject(), 'Name', EnumValueName);
        EnumValueID := this.GetIntegerFromJson(JsonToken.AsObject(), 'Ordinal', EnumValueID);
        if this.GetJsonArray(JsonToken.AsObject(), 'Properties', PropertyArray) then
            foreach PropertyToken in PropertyArray do
                this.DumpPropertyJsonToTable(PropertyToken, EnumTypeID, 0, '');

        if not SREnumValue.Get(SREnumValue."Object Type"::Enum, EnumTypeID, SREnumValue."Detail Type"::EnumValue, EnumValueID, 0, EnumValueName) then begin
            SREnumValue."Object Type" := "SR Object Type IOI"::Enum;
            SREnumValue."Detail Type" := "SR Object Detail Type IOI"::EnumValue;
            SREnumValue."Object ID" := EnumTypeID;
            SREnumValue."Detail ID" := EnumValueID;
            SREnumValue."Detail Name" := CopyStr(EnumValueName, 1, MaxStrLen(SREnumValue."Detail Name"));
            SREnumValue.Insert();
        end;
    end;

    local procedure DumpTableJsonToTable(JsonToken: JsonToken; NameSpaceText: Text; AppPackageID: Guid; AppName: Text; Progressbar: codeunit "Progressbar IOI")
    var
        SRTable: record "SR Object IOI";
        TableName: Text;
        TableID: Integer;
        FieldArray: JsonArray;
        FieldToken: JsonToken;
    begin
        TableName := this.GetTextFromJson(JsonToken.AsObject(), 'Name', TableName);
        TableID := this.GetIntegerFromJson(JsonToken.AsObject(), 'Id', TableID);
        Progressbar.ProgressbarUpdate(2, TableName);
        Progressbar.ProgressbarUpdate(3, AppName);
        if this.GetJsonArray(JsonToken.AsObject(), 'Fields', FieldArray) then
            foreach FieldToken in FieldArray do
                this.DumpFieldJsonToTable(FieldToken, TableID);

        if not SRTable.Get(SRTable."Object Type"::Table, TableID) then begin
            SRTable."Object Type" := "SR Object Type IOI"::Table;
            SRTable."Object ID" := TableID;
            SRTable."Object Name" := CopyStr(TableName, 1, MaxStrLen(SRTable."Object Name"));
            SRTable."App Package ID" := AppPackageID;
            SRTable.Namespace := CopyStr(NameSpaceText, 1, MaxStrLen(SRTable.Namespace));
            SRTable.Insert();
        end;
    end;

    local procedure DumpFieldJsonToTable(JsonToken: JsonToken; TableID: Integer)
    var
        SRField: record "SR Object Detail IOI";
        FieldName: Text;
        FieldID: Integer;
        PropertyArray: JsonArray;
        PropertyToken: JsonToken;
        TypeDefinitionObj: JsonObject;
    begin
        FieldName := this.GetTextFromJson(JsonToken.AsObject(), 'Name', FieldName);
        FieldID := this.GetIntegerFromJson(JsonToken.AsObject(), 'Id', FieldID);
        if this.GetJsonArray(JsonToken.AsObject(), 'Properties', PropertyArray) then
            foreach PropertyToken in PropertyArray do
                this.DumpPropertyJsonToTable(PropertyToken, TableID, FieldID, '');
        if this.GetJsonObject(JsonToken.AsObject(), 'TypeDefinition', TypeDefinitionObj) then
            this.DumpTypeDefinitionJsonToTable(TypeDefinitionObj, "SR Object Type IOI"::Table, TableID, FieldID, FieldName);

        if not SRField.Get(SRField."Object Type"::Table, TableID, SRField."Detail Type"::Field, FieldID, 0, FieldName) then begin
            SRField."Object Type" := "SR Object Type IOI"::Table;
            SRField."Detail Type" := "SR Object Detail Type IOI"::Field;
            SRField."Object ID" := TableID;
            SRField."Detail ID" := FieldID;
            SRField."Detail Name" := CopyStr(FieldName, 1, MaxStrLen(SRField."Detail Name"));
            SRField.Insert();
        end;
    end;

    local procedure DumpTypeDefinitionJsonToTable(JsonObject: JsonObject; ObjectType: enum "SR Object Type IOI"; TableID: Integer; FieldID: Integer; DetailName: Text)
    var
        SRTypeDefinition: record "SR Object Detail IOI";
        TypeDefinitionName: Text;
        TypeDefinitionID: Integer;
        SubTypeObj: JsonObject;
    begin
        TypeDefinitionName := this.GetTextFromJson(JsonObject, 'Name', TypeDefinitionName);
        TypeDefinitionID := this.GetIntegerFromJson(JsonObject, 'Id', TypeDefinitionID);
        if this.GetJsonObject(JsonObject, 'Subtype', SubTypeObj) then
            this.DumpTypeDefinitionJsonToTable(SubTypeObj, ObjectType, TableID, FieldID, TypeDefinitionName);

        if not SRTypeDefinition.Get(ObjectType, TableID, SRTypeDefinition."Detail Type"::TypeDefinition, FieldID, 0, TypeDefinitionName) then begin
            SRTypeDefinition."Object Type" := ObjectType;
            SRTypeDefinition."Detail Type" := "SR Object Detail Type IOI"::TypeDefinition;
            SRTypeDefinition."Object ID" := TableID;
            SRTypeDefinition."Detail ID" := FieldID;
            SRTypeDefinition."Detail Name" := CopyStr(TypeDefinitionName, 1, MaxStrLen(SRTypeDefinition."Object Name"));
            if TypeDefinitionID <> 0 then begin
                SRTypeDefinition."Detail Name" := CopyStr(DetailName, 1, MaxStrLen(SRTypeDefinition."Detail Name"));
                SRTypeDefinition."Detail SubType Name" := CopyStr(TypeDefinitionName, 1, MaxStrLen(SRTypeDefinition."Detail SubType Name"));
                SRTypeDefinition."Detail SubType ID" := TypeDefinitionID;
            end;
            SRTypeDefinition.Insert();
        end;
    end;

    local procedure DumpPropertyJsonToTable(JsonToken: JsonToken; TableID: Integer; FieldID: Integer; KeyName: Text)
    var
        SRProperty: record "SR Object Detail IOI";
        PropertyName, PropertyValue : Text;
    begin
        PropertyName := this.GetTextFromJson(JsonToken.AsObject(), 'Name', PropertyName);
        PropertyValue := this.GetTextFromJson(JsonToken.AsObject(), 'Value', PropertyValue);

        if not SRProperty.Get(SRProperty."Object Type"::Table, TableID, SRProperty."Detail Type"::Property, FieldID, 0, PropertyName) then begin
            SRProperty."Object Type" := "SR Object Type IOI"::Table;
            SRProperty."Detail Type" := "SR Object Detail Type IOI"::Property;
            SRProperty."Object ID" := TableID;
            SRProperty."Detail ID" := FieldID;
            SRProperty."Detail Name" := CopyStr(PropertyName, 1, MaxStrLen(SRProperty."Detail Name"));
            SRProperty."Detail Value" := CopyStr(PropertyValue, 1, MaxStrLen(SRProperty."Detail Value"));
            SRProperty.Insert();
        end;
    end;

    local procedure DumpCodeunitJsonToTable(JsonToken: JsonToken; NameSpaceText: Text; AppPackageID: Guid; AppName: Text; Progressbar: codeunit "Progressbar IOI")
    var
        SRCodeunit: record "SR Object IOI";
        CodeunitName: Text;
        CodeunitID: Integer;
        MethodToken: JsonToken;
        MethodArray: JsonArray;
    begin
        CodeunitName := this.GetTextFromJson(JsonToken.AsObject(), 'Name', CodeunitName);
        CodeunitID := this.GetIntegerFromJson(JsonToken.AsObject(), 'Id', CodeunitID);
        Progressbar.ProgressbarUpdate(2, CodeunitName);
        Progressbar.ProgressbarUpdate(3, AppName);
        if this.GetJsonArray(JsonToken.AsObject(), 'Methods', MethodArray) then
            foreach MethodToken in MethodArray do
                this.DumpMethodJsonToTable(MethodToken, CodeunitID);

        if not SRCodeunit.Get(SRCodeunit."Object Type"::Codeunit, CodeunitID) then begin
            SRCodeunit."Object Type" := "SR Object Type IOI"::Codeunit;
            SRCodeunit."Object ID" := CodeunitID;
            SRCodeunit."Object Name" := CopyStr(CodeunitName, 1, MaxStrLen(SRCodeunit."Object Name"));
            SRCodeunit.Namespace := CopyStr(NameSpaceText, 1, MaxStrLen(SRCodeunit.Namespace));
            SRCodeunit."App Package ID" := AppPackageID;
            SRCodeunit.Insert();
        end;
    end;

    local procedure DumpMethodJsonToTable(JsonToken: JsonToken; CodeunitID: Integer)
    var
        SRMethod: record "SR Object Detail IOI";
        MethodName: Text;
        MethodID: Integer;
        IsInternal: Boolean;
        ReturnTypeDefinitionText: Text;
        ReturnTypeDefinitionObj: JsonObject;
        ParameterArray, AttributeArray : JsonArray;
        ParameterToken, AttributeToken : JsonToken;
    begin
        MethodName := this.GetTextFromJson(JsonToken.AsObject(), 'Name', MethodName);
        MethodID := this.GetIntegerFromJson(JsonToken.AsObject(), 'Id', MethodID);

        if this.GetJsonObject(JsonToken.AsObject(), 'ReturnTypeDefinition', ReturnTypeDefinitionObj) then
            ReturnTypeDefinitionText := this.GetTextFromJson(ReturnTypeDefinitionObj, 'Name', ReturnTypeDefinitionText);
        IsInternal := this.GetBooleanFromJson(JsonToken.AsObject(), 'IsInternal', IsInternal);

        if this.GetJsonArray(JsonToken.AsObject(), 'Parameters', ParameterArray) then
            foreach ParameterToken in ParameterArray do
                this.DumpParameterJsonToTable(ParameterToken, CodeunitID, MethodID);
        if this.GetJsonArray(JsonToken.AsObject(), 'Attributes', AttributeArray) then
            foreach AttributeToken in AttributeArray do
                this.DumpAttributeJsonToTable(AttributeToken, CodeunitID, MethodID);

        if not SRMethod.Get(SRMethod."Object Type"::Codeunit, CodeunitID, SRMethod."Detail Type"::Method, MethodID, 0, MethodName) then begin
            SRMethod."Object Type" := "SR Object Type IOI"::Codeunit;
            SRMethod."Detail Type" := "SR Object Detail Type IOI"::Method;
            SRMethod."Object ID" := CodeunitID;
            SRMethod."Detail ID" := MethodID;
            SRMethod."Detail Name" := CopyStr(MethodName, 1, MaxStrLen(SRMethod."Detail Name"));
            SRMethod.Insert();
        end;
        SRMethod."Detail Type Definition" := CopyStr(ReturnTypeDefinitionText, 1, MaxStrLen(SRMethod."Detail Type Definition"));
        SRMethod."Is Internal Method" := IsInternal;
        SRMethod.Modify();
    end;

    local procedure DumpParameterJsonToTable(JsonToken: JsonToken; CodeunitID: Integer; MethodID: Integer)
    var
        SRParameter: record "SR Object Detail IOI";
        TypeDefinitionObj, SubTypeDefinitionObj : JsonObject;
        ParameterName, ParameterTypeDefinition, ParameterSubTypeDefinition : Text;
        ParameterSubTypeId: Integer;
        LastSortOrder: Integer;
        IsVar: Boolean;
    begin
        ParameterName := this.GetTextFromJson(JsonToken.AsObject(), 'Name', ParameterName);
        ParameterTypeDefinition := this.GetTextFromJson(JsonToken.AsObject(), 'TypeDefinition', ParameterTypeDefinition);
        IsVar := this.GetBooleanFromJson(JsonToken.AsObject(), 'IsVar', IsVar);
        if this.GetJsonObject(JsonToken.AsObject(), 'TypeDefinition', TypeDefinitionObj) then begin
            ParameterTypeDefinition := this.GetTextFromJson(TypeDefinitionObj, 'Name', ParameterTypeDefinition);
            if this.GetJsonObject(TypeDefinitionObj, 'Subtype', SubTypeDefinitionObj) then begin
                ParameterSubTypeDefinition := this.GetTextFromJson(SubTypeDefinitionObj, 'Name', ParameterTypeDefinition);
                ParameterSubTypeId := this.GetIntegerFromJson(SubTypeDefinitionObj, 'Id', ParameterSubTypeId);
            end;
        end;
        SRParameter.SetRange("Object Type", SRParameter."Object Type"::Codeunit);
        SRParameter.SetRange("Object ID", CodeunitID);
        SRParameter.SetRange("Detail Type", SRParameter."Detail Type"::Parameter);
        SRParameter.SetRange("Detail ID", MethodID);
        SRParameter.SetRange("Detail Name", ParameterName);

        if not SRParameter.FindFirst() then begin
            SRParameter.SetRange("Detail Name");
            if SRParameter.FindLast() then
                LastSortOrder := SRParameter."Detail Sortorder ID" + 1
            else
                LastSortOrder := 1;

            Clear(SRParameter);
            SRParameter."Object Type" := "SR Object Type IOI"::Codeunit;
            SRParameter."Detail Type" := "SR Object Detail Type IOI"::Parameter;
            SRParameter."Object ID" := CodeunitID;
            SRParameter."Detail ID" := MethodID;
            SRParameter."Detail Name" := CopyStr(ParameterName, 1, MaxStrLen(SRParameter."Detail Name"));
            SRParameter."Detail SubType Name" := CopyStr(ParameterSubTypeDefinition, 1, MaxStrLen(SRParameter."Detail SubType Name"));
            SRParameter."Detail SubType ID" := ParameterSubTypeId;
            SRParameter."Detail Sortorder ID" := LastSortOrder;
            SRParameter."Is Var" := IsVar;
            SRParameter.Insert();
        end;
        SRParameter."Detail Type Definition" := CopyStr(ParameterTypeDefinition, 1, MaxStrLen(SRParameter."Detail Type Definition"));
        SRParameter.Modify();
    end;

    local procedure DumpAttributeJsonToTable(JsonToken: JsonToken; CodeunitID: Integer; MethodID: Integer)
    var
        SRAttribut: record "SR Object Detail IOI";
        AttributeName, Arguments, Argument : Text;
        JsonArray: JsonArray;
        JsonElement: JsonToken;
    begin
        AttributeName := this.GetTextFromJson(JsonToken.AsObject(), 'Name', AttributeName);

        // Hier holen wir uns das Arguments-Array
        if this.GetJsonArray(JsonToken.AsObject(), 'Arguments', JsonArray) then
            foreach JsonElement in JsonArray do begin
                Argument := this.GetTextFromJson(JsonElement.AsObject(), 'Value', Argument);
                if Arguments = '' then
                    Arguments := Argument
                else
                    Arguments := Arguments + ',' + Argument;
            end;
        if not SRAttribut.Get(SRAttribut."Object Type"::Codeunit, CodeunitID, SRAttribut."Detail Type"::Attribute, MethodID) then begin
            SRAttribut."Object Type" := "SR Object Type IOI"::Codeunit;
            SRAttribut."Detail Type" := "SR Object Detail Type IOI"::Attribute;
            SRAttribut."Object ID" := CodeunitID;
            SRAttribut."Detail ID" := MethodID;
            SRAttribut."Detail Name" := CopyStr(AttributeName, 1, MaxStrLen(SRAttribut."Detail Name"));
            SRAttribut."Detail Arguments" := CopyStr(Arguments, 1, MaxStrLen(SRAttribut."Detail Arguments"));
            SRAttribut.Insert();
        end;
    end;

    local procedure GetJsonArray(JsonObject: JsonObject; JsonKey: Text; var JsonArray: JsonArray): boolean
    var
        JsonToken: JsonToken;
    begin
        if JsonObject.Get(JsonKey, JsonToken) then
            if JsonToken.IsArray then begin
                JsonArray := JsonToken.AsArray();
                exit(true);
            end;
        exit(false);
    end;

    local procedure GetJsonObject(ParentJsonObject: JsonObject; JsonKey: Text; var JsonObject: JsonObject): boolean
    var
        JsonToken: JsonToken;
    begin
        if ParentJsonObject.Get(JsonKey, JsonToken) then
            if JsonToken.IsObject then begin
                JsonObject := JsonToken.AsObject();
                exit(true);
            end;
        exit(false);
    end;

    local procedure GetTextFromJson(JsonObject: JsonObject; JsonKey: Text; var JsonText: Text): Text
    var
        JsonToken: JsonToken;
    begin
        if JsonObject.Get(JsonKey, JsonToken) then
            if JsonToken.IsValue() then begin
                JsonText := JsonToken.AsValue().AsText();
                exit(JsonText);
            end;
        exit(JsonText);
    end;

    local procedure GetIntegerFromJson(JsonObject: JsonObject; JsonKey: Text; var JsonInteger: Integer): Integer
    var
        JsonToken: JsonToken;
    begin
        if JsonObject.Get(JsonKey, JsonToken) then
            if JsonToken.IsValue() then begin
                JsonInteger := JsonToken.AsValue().AsInteger();
                exit(JsonInteger);
            end;
        exit(JsonInteger);
    end;

    local procedure GetGuidFromJson(JsonObject: JsonObject; JsonKey: Text; var JsonGuid: Guid): Guid
    var
        JsonToken: JsonToken;
    begin
        if JsonObject.Get(JsonKey, JsonToken) then
            if JsonToken.IsValue() then begin
                Evaluate(JsonGuid, JsonToken.AsValue().AsText());
                exit(JsonGuid);
            end;
        exit(JsonGuid);
    end;

    local procedure GetBooleanFromJson(JsonObject: JsonObject; JsonKey: Text; var JsonBoolean: Boolean): Boolean
    var
        JsonToken: JsonToken;
    begin
        if JsonObject.Get(JsonKey, JsonToken) then
            if JsonToken.IsValue() then begin
                JsonBoolean := JsonToken.AsValue().AsBoolean();
                exit(JsonBoolean);
            end;
        exit(JsonBoolean);
    end;

    local procedure DeleteObjectData(AppPackageID: Guid)
    var
        SRObject: record "SR Object IOI";
        SRObjectDetail: record "SR Object Detail IOI";
    begin
        SRObject.SetRange("App Package ID", AppPackageID);
        if SRObject.FindSet() then
            repeat
                SRObjectDetail.SetRange("Object ID", SRObject."Object ID");
                SRObjectDetail.SetRange("Object Type", SRObject."Object Type");
                SRObjectDetail.DeleteAll();
                SRObject.Delete();
            until SRObject.Next() = 0;
    end;
}
