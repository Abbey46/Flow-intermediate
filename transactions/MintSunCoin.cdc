import FungibleToken from 0x05
import SunCoin from 0x05

transaction(receiver: Address, amount: UFix64) {

    prepare(signer: AuthAccount) {
        // Borrow the SunCoin Minter reference
        let minter = signer.borrow<&SunCoin.Minter>(from: /storage/MinterStorage)
            ?? panic("You are not authorised")
        
        // Borrow the receiver's SunCoin Vault capability
        let receiverVault = getAccount(receiver)
            .getCapability<&SunCoin.Vault{FungibleToken.Receiver}>(/public/Vault)
            .borrow()
            ?? panic("Error: Check SunCoin Vault status")
        
        // Minted tokens reference
        let mintedTokens <- minter.mintToken(amount: amount)

        // Deposit minted tokens into the receiver's SunCoin Vault
        receiverVault.deposit(from: <-mintedTokens)
    }

    execute {
        log("SunCoin minted and deposited")
        log("Tokens minted and deposited: ".concat(amount.toString()))
    }
}