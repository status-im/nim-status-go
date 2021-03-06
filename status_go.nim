# This module (see also `./status_go/impl.nim`) wraps the API supplied by
# status-go when it is compiled into `libstatus.a|dll|dylib|so`.

# It is expected that this module will be consumed as an import in another Nim
# module; when doing so, it is not necessary to separately compile
# `./status_go/impl.nim` but it is the responsibility of the user to link
# status-go compiled to `libstatus` into the final executable.

import ./status_go/impl as go_shim

export SignalCallback

proc hashMessage*(message: string): string =
  $go_shim.hashMessage(message.cstring)

proc initKeystore*(keydir: string): string =
  $go_shim.initKeystore(keydir.cstring)

proc openAccounts*(datadir: string): string =
  $go_shim.openAccounts(datadir.cstring)

proc multiAccountGenerateAndDeriveAddresses*(paramsJSON: string): string =
  $go_shim.multiAccountGenerateAndDeriveAddresses(paramsJSON.cstring)

proc multiAccountStoreDerivedAccounts*(paramsJSON: string): string =
  $go_shim.multiAccountStoreDerivedAccounts(paramsJSON.cstring)

proc multiAccountImportMnemonic*(paramsJSON: string): string =
  $go_shim.multiAccountImportMnemonic(paramsJSON.cstring)

proc multiAccountImportPrivateKey*(paramsJSON: string): string =
  $go_shim.multiAccountImportPrivateKey(paramsJSON.cstring)

proc multiAccountDeriveAddresses*(paramsJSON: string): string =
  $go_shim.multiAccountDeriveAddresses(paramsJSON.cstring)

proc saveAccountAndLogin*(accountData: string, password: string, settingsJSON: string, configJSON: string, subaccountData: string): string =
  $go_shim.saveAccountAndLogin(accountData.cstring, password.cstring, settingsJSON.cstring, configJSON.cstring, subaccountData.cstring)

proc deleteMultiAccount*(keyUID: string, keyStoreDir: string): string =
  $go_shim.deleteMultiAccount(keyUID.cstring, keyStoreDir.cstring)

proc callRPC*(inputJSON: string): string =
  $go_shim.callRPC(inputJSON.cstring)

proc callPrivateRPC*(inputJSON: string): string =
  $go_shim.callPrivateRPC(inputJSON.cstring)

proc addPeer*(peer: string): string =
  $go_shim.addPeer(peer.cstring)

proc setSignalEventCallback*(callback: SignalCallback) =
  go_shim.setSignalEventCallback(callback)

proc sendTransaction*(jsonArgs: string, password: string): string =
  $go_shim.sendTransaction(jsonArgs.cstring, password.cstring)

proc generateAlias*(pk: string): string =
  $go_shim.generateAlias(pk)

proc identicon*(pk: string): string =
  $go_shim.identicon(pk)

proc login*(accountData: string, password: string): string =
  $go_shim.login(accountData.cstring, password.cstring)

proc logout*(): string =
  $go_shim.logout()

proc verifyAccountPassword*(keyStoreDir: string, address: string, password: string): string =
  $go_shim.verifyAccountPassword(keyStoreDir.cstring, address.cstring, password.cstring)

proc changeDatabasePassword*(keyUID: string, password: string, newPassword: string): string =
  $go_shim.changeDatabasePassword(keyUID.cstring, password.cstring, newPassword.cstring)

proc validateMnemonic*(mnemonic: string): string =
  $go_shim.validateMnemonic(mnemonic.cstring)

proc saveAccountAndLoginWithKeycard*(accountData: string, password: string, settingsJSON: string, configJSON: string, subaccountData: string, keyHex: string): string =
  $go_shim.saveAccountAndLoginWithKeycard(accountData.cstring, password.cstring, settingsJSON.cstring, configJSON.cstring, subaccountData.cstring, keyHex.cstring)

proc hashTransaction*(txArgsJSON: string): string =
  $go_shim.hashTransaction(txArgsJSON.cstring)

proc extractGroupMembershipSignatures*(signaturePairsStr: string): string =
  $go_shim.extractGroupMembershipSignatures(signaturePairsStr.cstring)

proc connectionChange*(typ: string, expensive: string) =
  go_shim.connectionChange(typ.cstring, expensive.cstring)

proc multiformatSerializePublicKey*(key: string, outBase: string): string =
  $go_shim.multiformatSerializePublicKey(key.cstring, outBase.cstring)

proc multiformatDeserializePublicKey*(key: string, outBase: string): string =
  $go_shim.multiformatDeserializePublicKey(key.cstring, outBase.cstring)

proc validateNodeConfig*(configJSON: string): string =
  $go_shim.validateNodeConfig(configJSON.cstring)

proc loginWithKeycard*(accountData: string, password: string, keyHex: string): string =
  $go_shim.loginWithKeycard(accountData.cstring, password.cstring, keyHex.cstring)

proc recover*(rpcParams: string): string =
  $go_shim.recover(rpcParams.cstring)

proc writeHeapProfile*(dataDir: string): string =
  $go_shim.writeHeapProfile(dataDir.cstring)

proc hashTypedData*(data: string): string =
  $go_shim.hashTypedData(data.cstring)

proc resetChainData*(): string =
  $go_shim.resetChainData()

proc signMessage*(rpcParams: string): string =
  $go_shim.signMessage(rpcParams.cstring)

proc signTypedData*(data: string, address: string, password: string): string =
  $go_shim.signTypedData(data.cstring, address.cstring, password.cstring)

proc stopCPUProfiling*(): string =
  $go_shim.stopCPUProfiling()

proc getNodesFromContract*(rpcEndpoint: string, contractAddress: string): string =
  $go_shim.getNodesFromContract(rpcEndpoint.cstring, contractAddress.cstring)

proc exportNodeLogs*(): string =
  $go_shim.exportNodeLogs()

proc chaosModeUpdate*(on: int): string =
  $go_shim.chaosModeUpdate(on.cint)

proc signHash*(hexEncodedHash: string): string =
  $go_shim.signHash(hexEncodedHash.cstring)

proc sendTransactionWithSignature*(txtArgsJSON: string, sigString: string): string =
  $go_shim.sendTransactionWithSignature(txtArgsJSON.cstring, sigString.cstring)

proc startCPUProfile*(dataDir: string): string =
  $go_shim.startCPUProfile(dataDir.cstring)

proc appStateChange*(state: string) =
  go_shim.appStateChange(state.cstring)

proc signGroupMembership*(content: string): string =
  $go_shim.signGroupMembership(content.cstring)

proc multiAccountStoreAccount*(paramsJSON: string): string =
  $go_shim.multiAccountStoreAccount(paramsJSON.cstring)

proc multiAccountLoadAccount*(paramsJSON: string): string =
  $go_shim.multiAccountLoadAccount(paramsJSON.cstring)

proc multiAccountGenerate*(paramsJSON: string): string =
  $go_shim.multiAccountGenerate(paramsJSON.cstring)

proc multiAccountReset*(): string =
  $go_shim.multiAccountReset()

proc migrateKeyStoreDir*(accountData: string, password: string, oldKeystoreDir: string, multiaccountKeystoreDir: string): string =
  $go_shim.migrateKeyStoreDir(accountData.cstring, password.cstring, oldKeystoreDir.cstring, multiaccountKeystoreDir.cstring)

proc startWallet*(watchNewBlocks: bool): string =
  $go_shim.startWallet(watchNewBlocks)

proc stopWallet*(): string =
  $go_shim.stopWallet()

proc startLocalNotifications*(): string =
  $go_shim.startLocalNotifications()

proc stopLocalNotifications*(): string =
  $go_shim.stopLocalNotifications()

proc getNodeConfig*(): string =
  $go_shim.getNodeConfig()
