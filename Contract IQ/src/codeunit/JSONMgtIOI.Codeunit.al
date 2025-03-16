namespace IOI.ContractIQ;

codeunit 70001 "JSON Mgt. IOI"
{
    procedure GenerateSymbolref(AppMeta: Record "App Meta IOI"): Text
    var
        AppFields: Record "Fields IOI";
        AppFieldsKeys: Record "Fields IOI";
        AppTables: Record "Tables IOI";
        Body: JsonObject;
        txt: Text;
        JObject: JsonObject;
        JObject2: JsonObject;
        JObject3: JsonObject;
        JObject4: JsonObject;
        JObject5: JsonObject;
        JObject6: JsonObject;
        JObject7: JsonObject;
        JArray: JsonArray;
        JArray2: JsonArray;
        JArray3: JsonArray;
        JArray4: JsonArray;
        JArray5: JsonArray;
        JArray6: JsonArray;
        JValue: JsonValue;
        EmptyArray: JsonArray;
        TableName: Text;
        TableNameLbl: Label '%1.Table.al', Comment = '%1 = Table name';
        i: Integer;
    begin
        //Tables +++
        AppTables.RESET();
        AppTables.SetRange(id, AppMeta.id);
        if AppTables.FindSet() then
            REPEAT

                CLEAR(JObject);
                CLEAR(JArray2);


                //Fields +++
                AppFields.Reset();
                AppFields.SetRange(id, AppTables.id);
                AppFields.SetRange("Table Name", AppTables.Name);
                if AppFields.FindSet() then
                    repeat

                        CLEAR(JObject2);
                        CLEAR(JObject3);
                        CLEAR(JObject4);
                        CLEAR(JObject6);
                        CLEAR(JObject7);
                        CLEAR(JArray3);
                        CLEAR(JArray4);

                        CLEAR(JArray5);
                        CLEAR(JArray6);

                        JObject3.Add('Name', 'Text[50]'); //Field type + length
                        JObject3.Add('Temporary', 'false'); //
                        JObject2.Add('TypeDefinition', JObject3);

                        //Fields.Properties +++
                        CLEAR(JObject5);
                        JObject5.Add('Value', AppFields.DataClassification.Names.Get(AppFields.DataClassification.Ordinals.IndexOf(AppFields.DataClassification.AsInteger())));
                        JObject5.Add('Name', 'DataClassification'); //field property name
                        JArray3.Add(JObject5);
                        CLEAR(JObject5);
                        JObject5.Add('Value', AppFields.caption);
                        JObject5.Add('Name', 'Caption'); //field property name
                        JArray3.Add(JObject5);
                        JObject2.Add('Properties', JArray3); //Field properties
                        //Fields.Properties ---

                        JObject2.Add('Id', AppFields."No."); //field id
                        JObject2.Add('Name', AppFields.name); //Fieldname
                        JArray2.Add(JObject2);
                        //Fields ---

                        //Keys+++
                        i := 0;
                        AppFieldsKeys.Reset();
                        AppFieldsKeys.SetRange(id, AppFields.id);
                        AppFieldsKeys.SetRange("Table Name", AppFields."Table Name");
                        AppFieldsKeys.SetRange(IsPK, true);
                        if AppFieldsKeys.FindSet() then
                            repeat
                                CLEAR(JValue);
                                JValue.SetValue(AppFieldsKeys.name);
                                JArray6.Insert(i, JValue);
                                i += 1;
                            UNTIL AppFieldsKeys.Next() = 0;
                        JObject6.Add('Value', '1');
                        JObject6.Add('Name', 'Clustered');
                        JArray5.Add(JObject6);

                        CLEAR(JObject6);
                        JObject6.Add('FieldNames', JArray6);
                        JObject6.Add('Properties', JArray5);
                        JObject6.Add('Name', 'PK');
                        JArray4.Add(JObject6);
                        //Keys---

                        //Properties +++
                        CLEAR(JArray5);
                        CLEAR(JObject6);
                        JObject6.Add('Value', AppTables.caption);
                        JObject6.Add('Name', 'Caption');
                        JArray5.Add(JObject6);
                        CLEAR(JObject6);
                        JObject6.Add('Value', AppTables.DataClassification.Names.Get(AppTables.DataClassification.Ordinals.IndexOf(AppTables.DataClassification.AsInteger())));
                        JObject6.Add('Name', 'DataClassification');
                        JArray5.Add(JObject6);
                    //Properties ---

                    UNTIL AppFields.Next() = 0;

                JObject.Add('Fields', JArray2);
                JObject.Add('Keys', JArray4);
                TableName := StrSubstNo(TableNameLbl, AppTables.name);
                JObject.Add('ReferenceSourceFileName', 'src/table/' + TableName);
                JObject.Add('Properties', JArray5);
                JObject.Add('Id', AppTables."No.");
                JObject.Add('Name', AppTables.name);
                JArray.Add(JObject);

            UNTIL AppTables.Next() = 0;
        Body.Add('Tables', JArray);




        // //Codeunits +++
        // For i := 1 TO idx DO BEGIN
        //     CLEAR(JObject);
        //     CLEAR(JArray2);
        //     CLEAR(JObject7);
        //     Clear(JArray4);

        //     //Variables +++
        //     For j := 1 TO idx DO BEGIN
        //         CLEAR(JObject6);
        //         CLEAR(JObject3);
        //         CLEAR(JObject2);
        //         JObject6.Add('Name', 'Tempo Connector Setup MAI');
        //         JObject6.Add('Id', '70677575');
        //         JObject6.Add('IsEmpty', 'false');

        //         JObject3.Add('Name', 'Record');
        //         JObject3.Add('Temporary', 'false');
        //         JObject3.Add('Subtype', JObject6);
        //         JObject2.Add('TypeDefinition', JObject3);
        //         JObject2.Add('Protected', 'false');
        //         JObject2.Add('Name', 'TempoConnectorSetupMAI');
        //         JArray2.Add(JObject2);
        //     end;

        //     //Variables ---

        //     CLEAR(JArray2);

        //     //Methods +++
        //     For j := 1 TO idx DO BEGIN
        //         CLEAR(JObject3);
        //         CLEAR(JObject2);
        //         CLEAR(JObject5);
        //         CLEAR(JObject6);
        //         Clear(JArray3);

        //         JObject3.Add('Name', 'Text');
        //         JObject3.Add('Temporary', 'false');
        //         JObject2.Add('ReturnTypeDefinition', JObject3);
        //         JObject2.Add('MethodKind', '0');

        //         JObject5.Add('Name', 'Text');
        //         JObject5.Add('Temporary', 'false');

        //         JObject6.Add('Name', 'IssueID');
        //         JObject6.Add('TypeDefinition', JObject5);
        //         JArray3.add(JObject6);
        //         JObject2.Add('Parameters', JArray3);

        //         JObject2.Add('Id', '903721437');
        //         JObject2.Add('Name', 'GetJiraIssue');
        //         JArray2.Add(JObject2);
        //     end;
        //     JObject.Add('Methods', JArray2);


        //     //Methods ---

        //     JObject.Add('Variables', JArray2);
        //     JObject.Add('ReferenceSourceFileName', 'src/codeunit/CaptionMgt.Codeunit.al');


        //     JObject7.add('Value', 'Name/Value Buffer');
        //     JObject7.add('Name', 'TableNo');
        //     JArray4.Add(JObject7);
        //     JObject.Add('Properties', JArray4);

        //     JObject.Add('ID', '70677578');
        //     JObject.Add('Name', 'Caption Mgt MAI');

        //     JArray.Add(JObject);
        // END;


        // Body.Add('Codeunits', JArray);
        // //Codeunits ---

        //meta +++
        Body.Add('Codeunits', EmptyArray);
        Body.Add('Pages', EmptyArray);
        Body.Add('PageExtensions', EmptyArray);
        Body.Add('PageCustomizations', EmptyArray);
        Body.Add('TableExtensions', EmptyArray);
        Body.Add('Reports', EmptyArray);
        Body.Add('XmlPorts', EmptyArray);
        Body.Add('Queries', EmptyArray);
        Body.Add('Profiles', EmptyArray);
        Body.Add('ProfileExtensions', EmptyArray);
        Body.Add('ControlAddIns', EmptyArray);
        Body.Add('EnumTypes', EmptyArray);
        Body.Add('EnumExtensionTypes', EmptyArray);
        Body.Add('DotNetPackages', EmptyArray);
        Body.Add('Interfaces', EmptyArray);
        Body.Add('PermissionSets', EmptyArray);
        Body.Add('PermissionSetExtensions', EmptyArray);
        Body.Add('ReportExtensions', EmptyArray);
        Body.Add('InternalsVisibleToModules', EmptyArray);
        Body.Add('AppId', '9f2c1a90-55dd-4ab5-8d9f-7df3e13c2c16');
        Body.Add('Name', 'TEMPO');
        Body.Add('Publisher', 'Marquardt Informatik');
        Body.Add('Version', '1.0.0.0');
        //meta ---
        Body.WriteTo(txt);
        txt += NewLine();
        exit(txt);
    end;

    local procedure NewLine(): Text
    var
        Char10: Char;
    begin
        Char10 := 10;
        exit(Format(Char10));
    end;

}


