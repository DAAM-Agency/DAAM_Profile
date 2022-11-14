// get_profile.cdc

import DAAM_Profile from 0x509abbf4f85f3d73

pub fun main(address: Address): DAAM_Profile.UserHandler? {
    let ref = getAccount(address)
        .getCapability<&DAAM_Profile.User{DAAM_Profile.Public}>(DAAM_Profile.publicPath)
        .borrow()

    return ref?.getProfile()
}
