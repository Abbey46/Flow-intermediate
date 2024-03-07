import FungibleToken from 0x05
import SunCoin from 0x05

pub fun main(account: Address) {

    // Attempt to borrow PublicVault capability
    let publicVault: &SunCoin.Vault{FungibleToken.Balance, 
    FungibleToken.Receiver,SunCoin.VaultInterface}? =
        getAccount(account).getCapability(/public/Vault)
            .borrow<&SunCoin.Vault{FungibleToken.Balance, 
            FungibleToken.Receiver,SunCoin.VaultInterface}>()

    if (publicVault == nil) {
        // Create and link an empty vault if capability is not present
        let newVault <-SunCoin.createEmptyVault()
        getAuthAccount(account).save(<-newVault, to: /storage/VaultStorage)
        getAuthAccount(account).link<&SunCoin.Vault{FungibleToken.Balance, 
        FungibleToken.Receiver,SunCoin.VaultInterface}>(
            /public/Vault,
            target: /storage/VaultStorage
        )
        log("Empty vault created and linked")
        
        // Borrow the vault capability again to display its balance
        let retrievedVault: &SunCoin.Vault{FungibleToken.Balance}? =
            getAccount(account).getCapability(/public/Vault)
                .borrow<&SunCoin.Vault{FungibleToken.Balance}>()
        log("Balance of the new vault: ")
        log(retrievedVault?.balance)
    } else {
        log("Vault already available")
        
        // Borrow the vault capability for further checks
        let checkVault: &SunCoin.Vault{FungibleToken.Balance, 
        FungibleToken.Receiver,SunCoin.VaultInterface} =
            getAccount(account).getCapability(/public/Vault)
                .borrow<&SunCoin.Vault{FungibleToken.Balance, 
                FungibleToken.Receiver,SunCoin.VaultInterface}>()
                ?? panic("Vault capability absent")
        
        // Check if the vault's UUID is in the list of vaults
        if SunCoin.vaults.contains(checkVault.uuid) {     
            log("Balance of the existing vault:")       
            log(publicVault?.balance)
            log("This is a SunCoin vault")
        } else {
            log("This is not a SunCoin vault")
        }
    }
}
