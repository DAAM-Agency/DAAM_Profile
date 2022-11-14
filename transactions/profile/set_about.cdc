// set_about.cdc

import DAAM_Profile from 0x509abbf4f85f3d73

transaction(about: String?) {
    let about : String?
    let user  : &DAAM_Profile.User

    prepare(signer: AuthAccount) {
        self.about = about
        self.user  = signer.borrow<&DAAM_Profile.User>(from: DAAM_Profile.storagePath)!
    }

    execute {
        self.user.setAbout(self.about)
    }
}