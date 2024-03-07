// Import FungibleToken and SunCoin contracts from version 0x05
import FungibleToken from 0x05
import SunCoin from 0x05

// Create Suncoin Vault Transaction
transaction () {

    // Define references
    let userVault: &SunCoin.Vault{FungibleToken.Balance, 
        FungibleToken.Provider, 
        FungibleToken.Receiver, 
        SunCoin.VaultInterface}?
    let account: AuthAccount

    prepare(acct: AuthAccount) {

        // Borrow the vault capability and set the account reference
        self.userVault = acct.getCapability(/public/Vault)
            .borrow<&SunCoin.Vault{FungibleToken.Balance, FungibleToken.Provider, FungibleToken.Receiver, SunCoin.VaultInterface}>()
        self.account = acct
    }

    execute {
        if self.userVault == nil {
            // Create and link an empty vault if none exists
            let emptyVault <- SunCoin.createEmptyVault()
            self.account.save(<-emptyVault, to: /storage/VaultStorage)
            self.account.link<&SunCoin.Vault{FungibleToken.Balance, 
                FungibleToken.Provider, 
                FungibleToken.Receiver, 
                SunCoin.VaultInterface}>(/public/Vault, target: /storage/VaultStorage)
            log("Empty vault created")
        } else {
            log("Vault already available")
        }
    }
}