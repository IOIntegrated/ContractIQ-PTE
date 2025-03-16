namespace IOI.ContractIQ;

codeunit 70006 "WriteTableCode IOI"
{
    procedure WriteCode(AppTables: Record "Tables IOI"): Text
    var
        ALCode: Text;
    begin
        ALCode += WriteFirstLines(AppTables);
        ALCode += NewLine();
        ALCode += WriteProperties(AppTables);
        ALCode += NewLine();
        ALCode += WriteFields(AppTables);
        ALCode += NewLine();
        ALCode += WriteKeys(AppTables);
        ALCode += NewLine();
        ALCode += WriteLastLines();
        ALCode += NewLine();

        Exit(ALCode);
    end;

    local procedure WriteFirstLines(AppTables: Record "Tables IOI"): Text
    var
        ALCode: Text;
        TableNameNoLbl: Label 'table %1 "%2"', Comment = '%1 = Table no, %2 = Table name';

    begin
        ALCode += StrSubstNo(TableNameNoLbl, AppTables."No.", AppTables.Name);
        ALCode += NewLine();
        ALCode += '{';
        ALCode += NewLine();

        exit(ALCode);
    end;

    local procedure WriteProperties(AppTables: Record "Tables IOI"): Text
    var
        ALCode: Text;
        Char39: Char;
    begin
        Char39 := 39;

        //Caption
        ALCode += 'Caption = ';
        ALCode += Char39;
        ALCode += AppTables.caption;
        ALCode += Char39;
        ALCode += ';';

        ALCode += NewLine();

        //DataClassification;
        ALCode += 'DataClassification = ';
        ALCode += AppTables.DataClassification.Names.Get(AppTables.DataClassification.Ordinals.IndexOf(AppTables.DataClassification.AsInteger()));
        ALCode += ';';
        ALCode += NewLine();

        exit(ALCode);
    end;

    local procedure WriteFields(AppTables: Record "Tables IOI"): Text
    var
        AppFields: Record "Fields IOI";
        ALCode: Text;
        Char39: Char;
        FieldInfoLbl: Label '(%1; "%2"; %3)', Comment = '%1 = field no, %2 = field name, %3 = field type';

    begin
        Char39 := 39;
        ALCode += 'fields';
        ALCode += NewLine();
        ALCode += '{';
        ALCode += NewLine();

        AppFields.Reset();
        AppFields.SetRange(id, AppTables.id);
        AppFields.SetRange("Table Name", AppTables.name);
        If AppFields.FindSet() then
            repeat
                ALCode += 'field';
                If AppFields.length = 0 then
                    ALCode += StrSubstNo(FieldInfoLbl, AppFields."No.", AppFields.name, AppFields.Type.Names.Get(AppFields.Type.Ordinals.IndexOf(AppFields.Type.AsInteger())))
                ELSE
                    ALCode += StrSubstNo(FieldInfoLbl, AppFields."No.", AppFields.name, AppFields.Type.Names.Get(AppFields.Type.Ordinals.IndexOf(AppFields.Type.AsInteger())) + '[' + FORMAT(AppFields.length) + ']');
                ALCode += NewLine();
                ALCode += '{';
                ALCode += NewLine();

                //Caption
                ALCode += 'Caption = ';
                ALCode += Char39;
                ALCode += AppFields.caption;
                ALCode += Char39;
                ALCode += ';';

                ALCode += NewLine();

                //DataClassification;
                ALCode += 'DataClassification = ';
                ALCode += AppFields.DataClassification.Names.Get(AppFields.DataClassification.Ordinals.IndexOf(AppFields.DataClassification.AsInteger()));
                ALCode += ';';
                ALCode += NewLine();
                ALCode += '}';
                ALCode += NewLine();
            until AppFields.Next() = 0;
        ALCode += NewLine();
        ALCode += '}';
        ALCode += NewLine();

        exit(ALCode);
    end;

    local procedure WriteKeys(AppTables: Record "Tables IOI"): Text
    var
        AppFields: Record "Fields IOI";
        ALCode: Text;
        Keys: Text;
    begin
        ALCode += 'keys';
        ALCode += NewLine();
        ALCode += '{';
        ALCode += NewLine();
        ALCode += 'key(PK;';

        AppFields.Reset();
        AppFields.SetRange(id, AppTables.id);
        AppFields.SetRange("Table Name", AppTables.Name);
        AppFields.SetRange(IsPk, TRUE);
        If AppFields.FindSet() then
            repeat
                Keys += '"' + AppFields.name + '"' + ',';
            until AppFields.next() = 0;
        ALCode += Keys.TrimEnd(',');
        ALCode += ')';
        ALCode += NewLine();
        ALCode += '{';
        ALCode += NewLine();
        ALCode += 'Clustered = true;';
        ALCode += NewLine();
        ALCode += '}';
        ALCode += NewLine();
        ALCode += '}';
        ALCode += NewLine();

        exit(ALCode);
    end;

    local procedure WriteLastLines(): Text
    var
        ALCode: Text;
    begin
        ALCode += '}';
        exit(ALCode);
    end;

    local procedure NewLine(): Text
    var
        Char10: Char;
    begin
        Char10 := 10;
        exit(Format(Char10));
    end;


}
