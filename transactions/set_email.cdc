// set_email.cdc

import DAAM_Profile from 0x192440c99cb17282

transaction(email: String?) {
    let email : String?
    let user  : &DAAM_Profile.User

    prepare(signer: AuthAccount) {
        self.email = email
        self.user  = signer.borrow<&DAAM_Profile.User>(from: DAAM_Profile.storagePath)!
    }

    execute {
        self.user.setEmail(self.email)
    }
}