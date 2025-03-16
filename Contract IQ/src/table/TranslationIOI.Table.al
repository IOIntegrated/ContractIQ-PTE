namespace IOI.ContractIQ;

table 70005 "Translation IOI"
{
    Caption = 'Translation';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Table No."; Integer)
        {
            Caption = 'Table No.';
        }
        field(2; "Field No."; Integer)
        {
            Caption = 'Field No.';
        }
        field(3; "Unique ID"; Guid)
        {
            Caption = 'Unique ID';
        }
        field(4; Language; Code[10])
        {
            Caption = 'Language';
        }
        field(5; Translation; Text[250])
        {
            Caption = 'Translation';
        }
    }
    keys
    {
        key(PK; "Table No.", "Field No.", "Unique ID", Language)
        {
            Clustered = true;
        }
    }
    procedure AssitEdit(var Caption: Text[2048]; TableNo: Integer; FieldNo: Integer; UniqueID: Guid): text[2048]
    var
        Translations: record "Translation IOI";
        TranslationListPage: Page "Translation List IOI";
        TranslationText: Text;
        TranslationEntry: Text[250];
        TranslationLanguage: Code[10];
        SingleTranslation: Text[250];
        i: Integer;
    begin
        // Read the Caption field and update the Translation IOI table
        if not (Caption = '') then
            TranslationText := Caption + ';';
        i := 1;
        while StrPos(TranslationText, ';') > 0 do begin
            TranslationEntry := CopyStr(CopyStr(TranslationText, 1, StrPos(TranslationText, ';') - 1), 1, MaxStrLen(TranslationEntry));
            TranslationText := CopyStr(DelStr(TranslationText, 1, StrPos(TranslationText, ';')), 1, MaxStrLen(TranslationText));
            TranslationLanguage := CopyStr(CopyStr(TranslationEntry, 1, StrPos(TranslationEntry, '=') - 1), 1, MaxStrLen(Language));
            SingleTranslation := CopyStr(CopyStr(TranslationEntry, StrPos(TranslationEntry, '=') + 1), 1, MaxStrLen(Translation));
            if not Translations.Get(TableNo, FieldNo, UniqueID, TranslationLanguage) then begin
                Translations.Init();
                Translations."Table No." := TableNo;
                Translations."Field No." := FieldNo;
                Translations."Unique ID" := UniqueID;
                Translations.Language := TranslationLanguage;
                Translations.Insert();
            end;
            if Translations.Translation <> SingleTranslation then begin
                Translations.Translation := SingleTranslation;
                Translations.Modify(true);
            end;
            i := i + 1;
        end;

        Commit();
        // Open the Translation List IOI page
        Translations.SetRange("Table No.", TableNo);
        Translations.SetRange("Field No.", FieldNo);
        Translations.SetRange("Unique ID", UniqueID);
        TranslationListPage.SetTableView(Translations);
        TranslationListPage.LookupMode := true;
        if TranslationListPage.RunModal() = Action::LookupOK then begin
            TranslationText := '';
            if Translations.FindSet() then
                repeat
                    if TranslationText <> '' then
                        TranslationText := TranslationText + '; ';
                    TranslationText := TranslationText + Translations.Language + '=' + Translations.Translation;
                until Translations.Next() = 0;

            Caption := CopyStr(TranslationText, 1, MaxStrLen(Caption));
        end;
        exit(Caption);
    end;

}
