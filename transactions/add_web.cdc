// add_web.cdc

import DAAM_Profile  from 0x192440c99cb17282

transaction(web: String) {
    let web  : String
    let user : &DAAM_Profile.User

    prepare(signer: AuthAccount) {
        self.web  = web
        self.user = signer.borrow<&DAAM_Profile.User>(from: DAAM_Profile.storagePath)!
    }

    execute {
        self.user.addWeb(self.web)
    }
}