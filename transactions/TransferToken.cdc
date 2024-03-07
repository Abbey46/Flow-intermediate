import FungibleToken from 0x05
import SunCoin from 0x05

transaction(receiverAccount: Address, amount: UFix64) {

    // Define references for the sender's and receiver's vaults
    let signerVault: &SunCoin.Vault
    let receiverVault: &SunCoin.Vault{FungibleToken.Receiver}

    prepare(acct: AuthAccount) {
        // Borrow references and handle errors
        self.signerVault = acct.borrow<&SunCoin.Vault>(from: /storage/VaultStorage)
            ?? panic("Sender's vault not available")

        self.receiverVault = getAccount(receiverAccount)
            .getCapability(/public/Vault)
            .borrow<&SunCoin.Vault{FungibleToken.Receiver}>()
            ?? panic("Receiver's vault not available")
    }

    execute {
        // Withdraw tokens from the sender's vault and deposit them into the receiver's vault
        self.receiverVault.deposit(from: <-self.signerVault.withdraw(amount: amount))
        log("Tokens successfully transferred")
    }
}