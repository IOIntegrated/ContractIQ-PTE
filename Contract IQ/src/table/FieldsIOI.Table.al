namespace IOI.ContractIQ;

table 70003 "Fields IOI"
{
    Caption = 'App Fields';
    DataClassification = ToBeClassified;
    DataCaptionFields = "Table Name", "No.", Name;

    fields
    {
        field(1; ID; Guid)
        {
            Caption = 'ID';
            DataClassification = ToBeClassified;
        }
        field(2; "Table No."; integer)
        {
            Caption = 'Table No.';
            DataClassification = ToBeClassified;
        }
        field(3; "No."; integer)
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
        }
        field(4; IsPk; Boolean)
        {
            Caption = 'PK';
            DataClassification = ToBeClassified;
        }
        field(5; Name; text[30])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
        }
        field(6; Type; enum "App Fields Type IOI")
        {
            Caption = 'App Fields Type';
            DataClassification = ToBeClassified;
        }

        field(7; Length; Integer)
        {
            Caption = 'Length';
            DataClassification = ToBeClassified;
        }

        field(8; "Table Name"; Text[250])
        {
            Caption = 'Table name';
            Editable = false;
            TableRelation = "Tables IOI"."No.";
            FieldClass = FlowField;
            CalcFormula = lookup("Tables IOI"."Name" where("No." = field("Table No.")));
        }

        field(9; Caption; Text[2048])
        {
            Caption = 'Caption';
            DataClassification = ToBeClassified;
        }
        field(10; DataClassification; Enum "App Data Classification IOI")
        {
            Caption = 'DataClassification';
            DataClassification = ToBeClassified;
        }
        field(11; Usage; enum "Usage IOI")
        {
            Caption = 'Usage';
            DataClassification = CustomerContent;
        }


    }
    keys
    {
        key(PK; id, "Table No.", "No.", Usage)
        {
            Clustered = true;
        }
    }
    trigger OnDelete()
    var
        Translations: Record "Translation IOI";
    begin
        Translations.SetRange("Unique ID", Rec.SystemId);
        Translations.DeleteAll();
    end;

}
