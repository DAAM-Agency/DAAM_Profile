// set_avatar.cdc

import MetadataViews from 0x1d7e57aa55817448
import DAAM_Profile  from 0x509abbf4f85f3d73
import DAAM          from 0x7db4d10c78bad30a

// Returns correct MetadataViews.File deping on type of data. Pic, Http, ipfs
pub fun setFile(type: String, data: String, path: String?): AnyStruct{MetadataViews.File} {
    pre { (type == "ipfs" && path != nil) || type != "ipfs" }
    switch type {
        case "http"  : return MetadataViews.HTTPFile(url: data)
        case "https" : return MetadataViews.HTTPFile(url: data)
        case "ipfs"  : return MetadataViews.IPFSFile(cid: data, path: path!)
        default: return DAAM.OnChain(file: data)
    }
}

transaction(avatarType: String, avatar: String, avatar_ipfsPath: String?) {
    let avatar : AnyStruct{MetadataViews.File}?
    let user   : &DAAM_Profile.User

    prepare(signer: AuthAccount) {
        self.user   = signer.borrow<&DAAM_Profile.User>(from: DAAM_Profile.storagePath)!
        self.avatar = setFile(type: avatarType, data: avatar, path: nil) //path: avatar_ipfsPath)
    }

    execute {
        self.user.setAvatar(self.avatar)
    }
}