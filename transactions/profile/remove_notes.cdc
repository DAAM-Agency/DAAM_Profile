// remove_notes.cdc

import DAAM_Profile from 0x509abbf4f85f3d73

transaction(notes: String ) {
    let notes : String
    let user   : &DAAM_Profile.User

    prepare(signer: AuthAccount) {
        self.notes = notes
        self.user   = signer.borrow<&DAAM_Profile.User>(from: DAAM_Profile.storagePath)!
    }

    execute {
        self.user.removeNotes(self.notes)
    }
}