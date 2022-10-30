// set_description.cdc

import DAAM_Profile from 0x192440c99cb17282

transaction(description: String?) {
    let description : String?
    let user  : &DAAM_Profile.User

    prepare(signer: AuthAccount) {
        self.description = description
        self.user        = signer.borrow<&DAAM_Profile.User>(from: DAAM_Profile.storagePath)!
    }

    execute {
        self.user.setDescription(self.description)
    }
}
 