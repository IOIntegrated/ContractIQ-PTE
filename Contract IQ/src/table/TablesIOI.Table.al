namespace IOI.ContractIQ;
table 70002 "Tables IOI"
{
    Caption = 'Tables';
    DataClassification = CustomerContent;
    DataCaptionFields = "No.", Name;

    fields
    {
        field(1; ID; Guid)
        {
            Caption = 'ID';
            DataClassification = CustomerContent;
        }
        field(2; "No."; integer)
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(3; Name; Text[30])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(4; Caption; Text[2048])
        {
            Caption = 'Caption';
            DataClassification = CustomerContent;
        }
        field(5; DataClassification; Enum "App Data Classification IOI")
        {
            Caption = 'DataClassification';
            DataClassification = CustomerContent;
        }
        field(6; Usage; enum "Usage IOI")
        {
            Caption = 'Usage';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; ID, "No.", Usage)
        {
            Clustered = true;
        }
    }
    trigger OnDelete()
    var
        Fields: Record "Fields IOI";
        Translations: Record "Translation IOI";
    begin
        Translations.SetRange("Unique ID", Rec.SystemId);
        Translations.DeleteAll();
        Fields.SetRange(ID, ID);
        Fields.SetRange("Table No.", Rec."No.");
        if Fields.FindSet() then
            repeat
                Translations.SetRange("Unique ID", Fields.SystemId);
                Translations.DeleteAll();
                Fields.Delete();
            until Fields.Next() = 0;
    end;
}
