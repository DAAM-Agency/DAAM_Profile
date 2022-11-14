// create_profile.cdc
// Used to create a DAAM_Profile.

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

transaction(name: String, emailName: String?, emailAt:String?, emailDot: String?, about: String?, description: String?, web: String?, social: {String:String}?, notes: {String:String}?,
    avatarType: String, avatar: String?, avatar_ipfsPath: String?,
    heroImageType: String, heroImage: String?, heroImage_ipfsPath: String?
    )
{
    let signer: AuthAccount
    let name  : String
    let about : String?
    
    let emailName : String?
    let emailAt   : String?
    let emailDot  : String?

    let description: String?

    let web      : String?
    let social   : {String:String}?
    let avatar   : AnyStruct{MetadataViews.File}?
    let heroImage: AnyStruct{MetadataViews.File}?
    let notes    : {String:String}?

    prepare(signer: AuthAccount) {
        self.signer = signer
        self.name   = name
        self.about  = about
        
        self.emailName  = emailName
        self.emailAt    = emailAt 
        self.emailDot   = emailDot

        self.description = description

        self.web       = web
        self.social    = social
        self.avatar    = (avatar == nil) ? nil : setFile(type: avatarType, data: avatar!, path: nil) //path: avatar_ipfsPath)
        self.heroImage = (heroImage == nil) ? nil : setFile(type: heroImageType, data: heroImage!, path: nil)//path: heroImage_ipfsPath)
        self.notes     = notes        
    }

    pre {
        (avatarType != "ipfs" && avatar_ipfsPath == nil) || (avatarType == "ipfs" && avatar_ipfsPath != nil) : "Avator Setting are Incorrect."
        (heroImageType != "ipfs" && heroImage_ipfsPath == nil) || (heroImageType == "ipfs" && heroImage_ipfsPath != nil) : "Hero image Settings are Incorrect."
        (emailName==nil && emailAt==nil && emailDot==nil) || (emailName!=nil && emailAt!=nil && emailDot!=nil) : "Invalid Email Entered"
    }

    execute {
        let profile <- DAAM_Profile.createProfile(
            name:self.name, about:self.about, description:self.description, web:self.web, social:self.social,
            avatar:self.avatar, heroImage:self.heroImage, notes:self.notes
        )
        profile.setEmail(name: self.emailName, at: self.emailAt, dot: self.emailDot)
        
        self.signer.save<@DAAM_Profile.User>(<-profile, to: DAAM_Profile.storagePath)
        self.signer.link<&DAAM_Profile.User{DAAM_Profile.Public}>(DAAM_Profile.publicPath, target: DAAM_Profile.storagePath)
        log("DAAM Profile Created: ".concat(self.signer.address.toString()))
    }
}
 