// check_profile.cdc

import DAAM_Profile from 0x509abbf4f85f3d73

pub fun main(address: Address): Bool {
    return DAAM_Profile.check(address)
}
