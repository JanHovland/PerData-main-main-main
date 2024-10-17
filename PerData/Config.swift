//
//  Config.swift
//

enum Config {
    /// iCloud container identifier.
    static let containerIdentifier = "iCloud.com.janhovland.PerData"
}

///
/// I understand that all schema information in the development environment will be replaced after importing this schema.
///

/// Lag en  Security Role som heter "admin" og har avhuking på:
///     Create, Read og Write
///
/// Gå inn på denne og * legg til de tabellene som skal ha de tilgangene.
/// Ved eksport av Schema fil du se dette for aktuelle tabeller:
/// GRANT READ, CREATE, WRITE TO admin
///
/// **NB. IKKE LEGG DETTE INN I "DEFINE SCHEMA", DET MEDFØRER FEILMELDING!
///

///
/// Nå bruker jeg jeg :
/// database = CKContainer(identifier: Config.containerIdentifier).publicCloudDatabase
///
/// Har problem med:
/// database = CKContainer(identifier: Config.containerIdentifier).privatecCloudDatabase
///  Meldt som problem til Apple Support onsdag 10. november 2021
///  Avventer svar (ikke hørt noe fredag 12. november 02:25()
///

/*
 DEFINE SCHEMA

     RECORD TYPE Cabin (
         "___createTime" TIMESTAMP QUERYABLE SORTABLE,
         "___createdBy"  REFERENCE,
         "___etag"       STRING,
         "___modTime"    TIMESTAMP,
         "___modifiedBy" REFERENCE,
         "___recordID"   REFERENCE QUERYABLE,
         fromDate        INT64 QUERYABLE SORTABLE,
         name            STRING QUERYABLE SEARCHABLE SORTABLE,
         toDate          INT64 QUERYABLE SORTABLE,
         GRANT WRITE TO "_creator",
         GRANT CREATE TO "_icloud",
         GRANT READ TO "_world"
     );

     RECORD TYPE Cottage (
         "___createTime" TIMESTAMP QUERYABLE SORTABLE,
         "___createdBy"  REFERENCE,
         "___etag"       STRING,
         "___modTime"    TIMESTAMP,
         "___modifiedBy" REFERENCE,
         "___recordID"   REFERENCE QUERYABLE,
         fromDate        INT64 QUERYABLE SORTABLE,
         name            STRING QUERYABLE SEARCHABLE SORTABLE,
         toDate          INT64 QUERYABLE SORTABLE,
         GRANT WRITE TO "_creator",
         GRANT CREATE TO "_icloud",
         GRANT READ TO "_world"
     );

     RECORD TYPE Json (
         "___createTime" TIMESTAMP QUERYABLE,
         "___createdBy"  REFERENCE,
         "___etag"       STRING,
         "___modTime"    TIMESTAMP,
         "___modifiedBy" REFERENCE,
         "___recordID"   REFERENCE QUERYABLE,
         jsaonData       ASSET,
         GRANT WRITE TO "_creator",
         GRANT CREATE TO "_icloud",
         GRANT READ TO "_world"
     );

     RECORD TYPE Person (
         "___createTime"    TIMESTAMP QUERYABLE SORTABLE,
         "___createdBy"     REFERENCE,
         "___etag"          STRING,
         "___modTime"       TIMESTAMP,
         "___modifiedBy"    REFERENCE,
         "___recordID"      REFERENCE QUERYABLE,
         address            STRING QUERYABLE SEARCHABLE SORTABLE,
         city               STRING QUERYABLE SEARCHABLE SORTABLE,
         cityNumber         STRING QUERYABLE SEARCHABLE SORTABLE,
         dateMonthDay       STRING QUERYABLE SEARCHABLE SORTABLE,
         dateOfBirth        TIMESTAMP QUERYABLE SORTABLE,
         firstName          STRING QUERYABLE SEARCHABLE SORTABLE,
         gender             INT64 QUERYABLE SORTABLE,
         image              ASSET,
         lastName           STRING QUERYABLE SEARCHABLE SORTABLE,
         municipality       STRING QUERYABLE SEARCHABLE SORTABLE,
         municipalityNumber STRING QUERYABLE SEARCHABLE SORTABLE,
         personEmail        STRING QUERYABLE SEARCHABLE SORTABLE,
         phoneNumber        STRING QUERYABLE SEARCHABLE SORTABLE,
         GRANT WRITE TO "_creator",
         GRANT CREATE TO "_icloud",
         GRANT READ TO "_world"
     );

     RECORD TYPE ZipCode (
         "___createTime"    TIMESTAMP QUERYABLE SORTABLE,
         "___createdBy"     REFERENCE,
         "___etag"          STRING,
         "___modTime"       TIMESTAMP,
         "___modifiedBy"    REFERENCE,
         "___recordID"      REFERENCE QUERYABLE,
         category           STRING QUERYABLE SEARCHABLE SORTABLE,
         municipalityName   STRING QUERYABLE SEARCHABLE SORTABLE,
         municipalityNumber STRING QUERYABLE SEARCHABLE SORTABLE,
         postalName         STRING QUERYABLE SEARCHABLE SORTABLE,
         postalNumber       STRING QUERYABLE SEARCHABLE SORTABLE,
         GRANT WRITE TO "_creator",
         GRANT CREATE TO "_icloud",
         GRANT READ TO "_world"
     );

     RECORD TYPE User (
         "___createTime" TIMESTAMP QUERYABLE SORTABLE,
         "___createdBy"  REFERENCE,
         "___etag"       STRING,
         "___modTime"    TIMESTAMP,
         "___modifiedBy" REFERENCE,
         "___recordID"   REFERENCE QUERYABLE,
         email           STRING QUERYABLE SEARCHABLE SORTABLE,
         image           ASSET,
         name            STRING QUERYABLE SEARCHABLE SORTABLE,
         passWord        STRING QUERYABLE SEARCHABLE SORTABLE,
         GRANT WRITE TO "_creator",
         GRANT CREATE TO "_icloud",
         GRANT READ TO "_world"
     );

     RECORD TYPE Users (
         "___createTime" TIMESTAMP,
         "___createdBy"  REFERENCE,
         "___etag"       STRING,
         "___modTime"    TIMESTAMP,
         "___modifiedBy" REFERENCE,
         "___recordID"   REFERENCE,
         roles           LIST<INT64>,
         GRANT WRITE TO "_creator",
         GRANT READ TO "_world"
     );
 */
