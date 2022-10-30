// check_profile.cdc

import DAAM_Profile from 0x192440c99cb17282

pub fun main(address: Address): Bool {
    return DAAM_Profile.check(address)
}