namespace IOI.ContractIQ;
table 70004 "ContractIQ Settings IOI"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "ContractIQ Setting List IOI";
    LookupPageId = "ContractIQ Setting Card IOI";

    fields
    {
        field(1; ID; GUID)
        {
            DataClassification = SystemMetadata;
        }
        field(2; Name; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(3; Publisher; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(4; Version; Text[20])
        {
            DataClassification = CustomerContent;
        }
        field(5; Brief; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(6; Description; Text[1024])
        {
            DataClassification = CustomerContent;
        }
        field(7; "Privacy Statement"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(8; EULA; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(9; "Help URL"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(10; Website; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(11; "ID Range from"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(12; "ID Range to"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(13; "Input Type"; enum "Input Type IOI")
        {
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "ID") { Clustered = true; }
    }


    fieldgroups
    {
        fieldgroup(DropDown; Name, Publisher)
        {
        }
        fieldgroup(Brick; Name, Publisher)
        {
        }
    }

    trigger OnInsert()
    var
        HandleDefaultsIOI: codeunit "Handle Defaults IOI";
    begin
        ID := CreateGuid();
        HandleDefaultsIOI.CheckInputStructure(ID);
    end;

    trigger OnDelete()
    var
        Tables: Record "Tables IOI";
        Fields: Record "Fields IOI";
        Translations: Record "Translation IOI";
    begin
        Tables.SetRange(ID, ID);
        if Tables.FindSet() then
            repeat
                Tables.Delete();
                Translations.SetRange("Unique ID", Tables.SystemId);
                Translations.DeleteAll();
            until Tables.Next() = 0;

        Fields.SetRange(ID, ID);
        if Fields.FindSet() then
            repeat
                Translations.SetRange("Unique ID", Fields.SystemId);
                Translations.DeleteAll();
                Fields.Delete();
            until Fields.Next() = 0;
    end;
}