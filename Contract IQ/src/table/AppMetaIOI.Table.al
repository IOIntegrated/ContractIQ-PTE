table 70000 "App Meta IOI"
{
    Caption = 'App Meta';
    DataCaptionFields = name, version;
    DataClassification = ToBeClassified;

    fields
    {
        field(1; id; Guid)
        {
            Caption = 'id';
            DataClassification = ToBeClassified;
        }
        field(2; name; Text[250])
        {
            Caption = 'name';
            DataClassification = ToBeClassified;
        }
        field(3; publisher; Text[250])
        {
            Caption = 'publisher';
            DataClassification = ToBeClassified;
        }
        field(4; version; Text[50])
        {
            Caption = 'version';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                If (xRec.version <> Rec.version) then
                    IF xRec.version <> '' THEN
                        ERROR('Version cannot be changed. Please create a new App Meta through the function in the navigation bar instead.')
            end;
        }

        field(5; sys_version; Enum "Versions IOI")
        {
            DataClassification = ToBeClassified;
        }

        field(6; Logo; Blob)
        {
            DataClassification = ToBeClassified;
        }

        field(7; ObjectRangeFrom; Integer)
        {
            DataClassification = ToBeClassified;
        }

        field(8; ObjectRangeTo; Integer)
        {
            DataClassification = ToBeClassified;
        }



    }


    keys
    {
        key(PK; id, name, version)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()

    begin
        Rec.id := CREATEGUID();
        IF Rec.version = '' THEN
            Rec.version := '1.0.0.0';
        InsertAppMetaFiles();
    end;

    local procedure InsertAppMetaFiles()
    var
        AppMetaFiles: Record "App Meta Files IOI";
    begin
        AppMetaFiles.Init();
        AppMetaFiles.id := Rec.id;
        AppMetaFiles.version := Rec.version;
        AppMetaFiles.name := '[Content_Types]';
        AppMetaFiles.fileextension := AppMetaFiles.fileextension::xml;
        AppMetaFiles.type := AppMetaFiles.type::Structure;
        AppMetaFiles.Insert();

        AppMetaFiles.Init();
        AppMetaFiles.id := Rec.id;
        AppMetaFiles.version := Rec.version;
        AppMetaFiles.name := 'DocComments';
        AppMetaFiles.fileextension := AppMetaFiles.fileextension::xml;
        AppMetaFiles.type := AppMetaFiles.type::Structure;
        AppMetaFiles.Insert();

        AppMetaFiles.Init();
        AppMetaFiles.id := Rec.id;
        AppMetaFiles.version := Rec.version;
        AppMetaFiles.name := 'MediaIdListing';
        AppMetaFiles.fileextension := AppMetaFiles.fileextension::xml;
        AppMetaFiles.type := AppMetaFiles.type::Structure;
        AppMetaFiles.Insert();

        AppMetaFiles.Init();
        AppMetaFiles.id := Rec.id;
        AppMetaFiles.version := Rec.version;
        AppMetaFiles.name := 'NavxManifest';
        AppMetaFiles.fileextension := AppMetaFiles.fileextension::xml;
        AppMetaFiles.type := AppMetaFiles.type::Structure;
        AppMetaFiles.Insert();

        AppMetaFiles.Init();
        AppMetaFiles.id := Rec.id;
        AppMetaFiles.version := Rec.version;
        AppMetaFiles.name := 'navigation';
        AppMetaFiles.fileextension := AppMetaFiles.fileextension::xml;
        AppMetaFiles.type := AppMetaFiles.type::Structure;
        AppMetaFiles.Insert();

        AppMetaFiles.Init();
        AppMetaFiles.id := Rec.id;
        AppMetaFiles.version := Rec.version;
        AppMetaFiles.name := 'SymbolReference';
        AppMetaFiles.fileextension := AppMetaFiles.fileextension::json;
        AppMetaFiles.type := AppMetaFiles.type::Structure;
        AppMetaFiles.Insert();

    end;

}
