//
//  ToDoView.swift
//  PerData
//
//  Created by Jan Hovland on 04/11/2021.
//

import SwiftUI

//
//  ToDoView.swift
//  PersonalOverView
//
//  Created by Jan Hovland on 24/09/2020.
//

import SwiftUI

struct toDoView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var toDo =
    """
    
      1. 🟢 Oppdatere underteksten på "OPPDATER POSTNUMMER" til "Have uncommented the actual function!".
      2. 🟢 Legg inn ActivityIndicator (Ikke en del av SwiftUI).
      3. 🟢 Rette søk på postnummer, finne alle steder som begynner på f.eks. Varh .
      4. 🟢 Lagt inn 2 eksport parametre: func findPersons() async -> (err: LocalizedStringKey, person: [Person]).
      5. 🟢 Byttet over til Public Database fordi det er problemer med Private.
            Sendt epost til Apple Support.
      6. 🟢 Postnummer virker ikke i PersonalView (Utsettes: må skrives om for iOS 15).
      7. 🟢 Aktivere en bryter for å kunne oppdatere ZipCode tabellen:
            . 🟢 Activity Indicator.
      8. 🟢 Oppdatere Person tabellen fra Json:
            . 🟢 Selve oppdateringen fra Json backup filen.
            . 🟢 Activity Indicator.
            . 🟢 Antall personer som er oppdatert fra Json backup: viser nå riktig antall.
            . 🟢 Beskrive oppdatering fra Json save/modify.
      9. 🟢 Personer.
            . 🟢 Søkefelt på personer.
     10. 🟢 Kan ikke scrolle på oppgavene i Xcode.
     11. 🟢 Sjekk om Internet er tilkoplet.
     12. 🟢 Legge inn knapperekken på hver person.
            . 🟢 Kart
            . 🟢 Telefon
            . 🟢 Melding
            . 🟢 e-Post
            . 🟢 Hytte
     13. 🟢 Rette CloudKit for hytta (Cabin table)
     14. 🟢 Hyttereservasjon skrevet om.
     15. 🟢 CloudKit UserRecord:
            . 🟢 Oppdatert CloudKit og Cloud Helper.
            . 🟢 Skrive om UserRecordOverView()
     16. 🟢 Oppdatere åpningsbildet SignInView()
     17. 🟢 Oppdatere åpningsbildet SignUpView()
     18. 🟢 Nytt meny oppsett
     19. 🟢 Gjøre oppfriskingen av Person / UserRecord / Cabin etc. raskere.
            for record in result .matchResults {
            var person = Person()
            ///
            /// Slik hentes de enkelte feltene ut:
            ///
            let per  = try record.1.get()
     20. 🟢 Legg in overskrift på oversikt hyttereservasjon
     21. 🟢 Ascii
            . 🟢 Hente postkoder fra ascii
     22. 🟢 Encrypted fields in CloudKit
            Kan ikke brukes på Public Database, kun på Private og Shared Database!
     23. 🟢 Ved oppdatering av UserRecordDetailView():
            . Bildet fra viewet og ved oppfrisking i UserRecordOverView
              kommer bildet frem igjen.
            . Dersom en velger nytt bilde, er alt OK.
     24. 🟢 Endre tilsvarende getAllPersons()
            . 🟢 getAllCabins()
            . 🟢 getAllZipCodes
     25. 🟢 Kun store bokstaver i feltet "By" PersonUpdateView()
            . 🔴 Løsningen virker ikke å iMac. (Slik PerData prosjektet er satt opp nå,
                 er det enten iPhone eller iPad og ikke sammen med macOS).
     26. 🟢 Sentrere fornavn,etternavn etc (i dag er bildet og de andre tekstene sentrert)
     27. 🟢 Json:
            . 🟢 Lagre person i Json
                 . 🟢 Finne json filen (du kan legge inn url i Safari og se innholdet)
                 . 🟢 For å få tak i filen som blir opprette og kunne se denne i "Filer" på iPhone:
                        Legg til disse i Info.plist:
                            Application supports iTunes file sharing     YES
                            Supports opening documents in place          YES
            . 🟢 Hente person fra Json
            . 🟢 Lagre userRecord i Json
            . 🟢 Hente userRecord fra Json
            . 🟢 Lagre hyttereservasjoner i Json
            . 🟢 Hente hyttereservasjoner fra Json
     28. 🟢 Sjekk visning av fødselsdato når denne blir endret.
     29. 🟢 Indexed table view:
            . 🟢 Person
            . 🟢 Brukere
     30. 🟢 Bruker detaljer:
            . 🟢 Lagt inn meny med oppdatering og sletting.
            . 🟢 Passord lagres ikke CloudKit for "Ny bruker". (SignUpView()
            . 🟢 Kan ikke oppdatere image for brukern.
            . 🟢 Må *ikke* kunne oppdatere for- og etternavn (Text field).
            . 🟢 Ta bort "Velg app"
     31. 🟢 PerDataIndexed():
            . 🟢 Legge menyen på navigation baren.
            . 🟢 Legg inn + (ny person) i menyen på navigation baren.
            . 🟢 Legg inn "frisk opp" i menyen.
     32. 🟢 PerDataIndexed():
            . 🟢 Vise postnr og poststed på samme linje
            . 🟢 Vurdere ny font på "Velg".
     33. 🟢 PersonNewView():
            . 🟢 Melding: Det må være verdier i for- og etternavn
            . 🟢 Legg inn save og modify CloudKit
     34. 🟢 PersonUpdateView():
            . 🟢 Ikke kunne endre for- og etternavn, vise dem som Text.
            . 🟢 Meny:
                 . 🟢 Legg inn Meny.
                 . 🟢 Legg inn sletting av person i Menyen.
                      . 🟢 Bildet må også slettes
     35. 🟢 Oversikt fødselsdager.
     36. 🟢 Rettet feil med søking på personer og brukere.
     37. 🔴 Se om sending av e-post kan gjøres på SwiftUI vis. (Ikke mer fokus på dette!)
     38. 🔴 Ser ut som oppdatering av Person lager et duplikat
     39. 🔴 .

    """
    
    var body: some View {
        NavigationView {
            ScrollView (.vertical, showsIndicators: false) {
                VStack (alignment: .leading) {
                    Text(toDo)
                    Spacer()
                }
                .multilineTextAlignment(.leading)
                .padding()
                .navigationViewStyle(StackNavigationViewStyle())
                .navigationBarTitle("ToDo", displayMode: .inline)
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarLeading) {
                        ControlGroup {
                            Button {
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                ReturnFromMenuView(text: "PersonOverView")
                            }
                        }
                        .controlGroupStyle(.navigation)
                    }
                })
            }
        }
    }
}

