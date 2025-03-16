table 70001 "App Meta Files IOI"
{
    Caption = 'App Meta Files';
    DataClassification = ToBeClassified;
    DataCaptionFields = name, version;

    fields
    {
        field(1; id; Guid)
        {
            Caption = 'id';
            DataClassification = ToBeClassified;
        }
        field(2; version; Text[50])
        {
            Caption = 'version';
            DataClassification = ToBeClassified;
        }
        field(3; name; Text[250])
        {
            Caption = 'name';
            DataClassification = ToBeClassified;
        }
        field(4; type; Enum "App Meta Files Type IOI")
        {
            Caption = 'path';
            DataClassification = ToBeClassified;
        }

        field(5; fileextension; enum "FileExtensions IOI")
        {
            DataClassification = ToBeClassified;
        }

        field(6; Content; Blob)
        {
            DataClassification = ToBeClassified;
        }

    }
    keys
    {
        key(PK; id, version, name, type)
        {
            Clustered = true;
        }
    }

}
