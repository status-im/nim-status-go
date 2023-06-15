
# This module (see also `./status_go/impl.nim`) wraps the API supplied by
# status-go when it is compiled into `libstatus.a|dll|dylib|so`.

# It is expected that this module will be consumed as an import in another Nim
# module; when doing so, it is not necessary to separately compile
# `./status_go/impl.nim` but it is the responsibility of the user to link
# status-go compiled to `libstatus` into the final executable.

import ./status_go/impl as go_shim

export SignalCallback

template cstringToString(goFuncStatement: untyped) =
  var funcOut = goFuncStatement
  defer: go_shim.free(funcOut)
  return $funcOut

proc hashMessage*(message: string): string =
  cstringToString go_shim.hashMessage(message.cstring)

proc initKeystore*(keydir: string): string =
  cstringToString go_shim.initKeystore(keydir.cstring)

proc openAccounts*(datadir: string): string =
  cstringToString go_shim.openAccounts(datadir.cstring)

proc multiAccountGenerateAndDeriveAddresses*(paramsJSON: string): string =
  cstringToString go_shim.multiAccountGenerateAndDeriveAddresses(paramsJSON.cstring)

proc multiAccountStoreDerivedAccounts*(paramsJSON: string): string =
  cstringToString go_shim.multiAccountStoreDerivedAccounts(paramsJSON.cstring)

proc multiAccountImportMnemonic*(paramsJSON: string): string =
  cstringToString go_shim.multiAccountImportMnemonic(paramsJSON.cstring)

proc createAccountFromMnemonicAndDeriveAccountsForPaths*(paramsJSON: string): string =
  cstringToString go_shim.createAccountFromMnemonicAndDeriveAccountsForPaths(paramsJSON.cstring)

proc createAccountFromPrivateKey*(paramsJSON: string): string =
  cstringToString go_shim.createAccountFromPrivateKey(paramsJSON.cstring)

proc multiAccountImportPrivateKey*(paramsJSON: string): string =
  cstringToString go_shim.multiAccountImportPrivateKey(paramsJSON.cstring)

proc multiAccountDeriveAddresses*(paramsJSON: string): string =
  cstringToString go_shim.multiAccountDeriveAddresses(paramsJSON.cstring)

proc saveAccountAndLogin*(accountData: string, password: string, settingsJSON: string, configJSON: string, subaccountData: string): string =
  cstringToString go_shim.saveAccountAndLogin(accountData.cstring, password.cstring, settingsJSON.cstring, configJSON.cstring, subaccountData.cstring)

proc deleteMultiAccount*(keyUID: string, keyStoreDir: string): string =
  cstringToString go_shim.deleteMultiAccount(keyUID.cstring, keyStoreDir.cstring)

proc callRPC*(inputJSON: string): string =
  cstringToString go_shim.callRPC(inputJSON.cstring)

proc callPrivateRPC*(inputJSON: string): string =
  cstringToString go_shim.callPrivateRPC(inputJSON.cstring)

proc addPeer*(peer: string): string =
  cstringToString go_shim.addPeer(peer.cstring)

proc setSignalEventCallback*(callback: SignalCallback) =
  go_shim.setSignalEventCallback(callback)

proc sendTransaction*(jsonArgs: string, password: string): string =
  cstringToString go_shim.sendTransaction(jsonArgs.cstring, password.cstring)

proc sendTransactionWithChainId*(chainId: int, jsonArgs: string, password: string): string =
  cstringToString go_shim.sendTransactionWithChainId(chainId.cint, jsonArgs.cstring, password.cstring)

proc generateAlias*(pk: string): string =
  cstringToString go_shim.generateAlias(pk)

proc isAlias*(value: string): string =
  cstringToString go_shim.isAlias(value)

proc identicon*(pk: string): string =
  cstringToString go_shim.identicon(pk)

proc emojiHash*(pk: string): string =
  cstringToString go_shim.emojiHash(pk)

proc colorHash*(pk: string): string =
  cstringToString go_shim.colorHash(pk)

proc colorID*(pk: string): string =
  cstringToString go_shim.colorID(pk)

proc login*(accountData: string, password: string): string =
  cstringToString go_shim.login(accountData.cstring, password.cstring)

proc loginWithConfig*(accountData: string, password: string, nodeCfg: string): string =
  cstringToString go_shim.loginWithConfig(accountData.cstring, password.cstring, nodeCfg.cstring)

proc logout*(): string =
  cstringToString go_shim.logout()

proc verifyAccountPassword*(keyStoreDir: string, address: string, password: string): string =
  cstringToString go_shim.verifyAccountPassword(keyStoreDir.cstring, address.cstring, password.cstring)

proc verifyDatabasePassword*(keyUID: string, password: string): string =
  cstringToString go_shim.verifyDatabasePassword(keyUID.cstring, password.cstring)

proc changeDatabasePassword*(keyUID: string, password: string, newPassword: string): string =
  cstringToString go_shim.changeDatabasePassword(keyUID.cstring, password.cstring, newPassword.cstring)

proc validateMnemonic*(mnemonic: string): string =
  cstringToString go_shim.validateMnemonic(mnemonic.cstring)

proc saveAccountAndLoginWithKeycard*(accountData: string, password: string, settingsJSON: string, configJSON: string, subaccountData: string, keyHex: string): string =
  cstringToString go_shim.saveAccountAndLoginWithKeycard(accountData.cstring, password.cstring, settingsJSON.cstring, configJSON.cstring, subaccountData.cstring, keyHex.cstring)

proc hashTransaction*(txArgsJSON: string): string =
  cstringToString go_shim.hashTransaction(txArgsJSON.cstring)

proc extractGroupMembershipSignatures*(signaturePairsStr: string): string =
  cstringToString go_shim.extractGroupMembershipSignatures(signaturePairsStr.cstring)

proc connectionChange*(typ: string, expensive: string) =
  go_shim.connectionChange(typ.cstring, expensive.cstring)

proc multiformatSerializePublicKey*(key: string, outBase: string): string =
  cstringToString go_shim.multiformatSerializePublicKey(key.cstring, outBase.cstring)

proc multiformatDeserializePublicKey*(key: string, outBase: string): string =
  cstringToString go_shim.multiformatDeserializePublicKey(key.cstring, outBase.cstring)

proc decompressPublicKey*(key: string): string =
  cstringToString go_shim.decompressPublicKey(key.cstring)

proc compressPublicKey*(key: string): string =
  cstringToString go_shim.compressPublicKey(key.cstring)

proc validateNodeConfig*(configJSON: string): string =
  cstringToString go_shim.validateNodeConfig(configJSON.cstring)

proc loginWithKeycard*(accountData: string, password: string, keyHex: string): string =
  cstringToString go_shim.loginWithKeycard(accountData.cstring, password.cstring, keyHex.cstring)

proc convertToKeycardAccount*(accountData: string, settingsJSON: string, keycardUid: string, password: string, newPassword: string): string =
  cstringToString go_shim.convertToKeycardAccount(accountData.cstring, settingsJSON.cstring, keycardUid.cstring, password.cstring, newPassword.cstring)

proc convertToRegularAccount*(mnemonic: string, currPassword: string, newPassword: string): string =
  cstringToString go_shim.convertToRegularAccount(mnemonic.cstring, currPassword.cstring, newPassword.cstring)

proc recover*(rpcParams: string): string =
  cstringToString go_shim.recover(rpcParams.cstring)

proc writeHeapProfile*(dataDir: string): string =
  cstringToString go_shim.writeHeapProfile(dataDir.cstring)

proc hashTypedData*(data: string): string =
  cstringToString go_shim.hashTypedData(data.cstring)

proc resetChainData*(): string =
  cstringToString go_shim.resetChainData()

proc signMessage*(rpcParams: string): string =
  cstringToString go_shim.signMessage(rpcParams.cstring)

proc signTypedData*(data: string, address: string, password: string): string =
  cstringToString go_shim.signTypedData(data.cstring, address.cstring, password.cstring)

proc stopCPUProfiling*(): string =
  cstringToString go_shim.stopCPUProfiling()

proc getNodesFromContract*(rpcEndpoint: string, contractAddress: string): string =
  cstringToString go_shim.getNodesFromContract(rpcEndpoint.cstring, contractAddress.cstring)

proc exportNodeLogs*(): string =
  cstringToString go_shim.exportNodeLogs()

proc chaosModeUpdate*(on: int): string =
  cstringToString go_shim.chaosModeUpdate(on.cint)

proc signHash*(hexEncodedHash: string): string =
  cstringToString go_shim.signHash(hexEncodedHash.cstring)

proc sendTransactionWithSignature*(txtArgsJSON: string, sigString: string): string =
  cstringToString go_shim.sendTransactionWithSignature(txtArgsJSON.cstring, sigString.cstring)

proc startCPUProfile*(dataDir: string): string =
  cstringToString go_shim.startCPUProfile(dataDir.cstring)

proc appStateChange*(state: string) =
  go_shim.appStateChange(state.cstring)

proc signGroupMembership*(content: string): string =
  cstringToString go_shim.signGroupMembership(content.cstring)

proc multiAccountStoreAccount*(paramsJSON: string): string =
  cstringToString go_shim.multiAccountStoreAccount(paramsJSON.cstring)

proc multiAccountLoadAccount*(paramsJSON: string): string =
  cstringToString go_shim.multiAccountLoadAccount(paramsJSON.cstring)

proc multiAccountGenerate*(paramsJSON: string): string =
  cstringToString go_shim.multiAccountGenerate(paramsJSON.cstring)

proc multiAccountReset*(): string =
  cstringToString go_shim.multiAccountReset()

proc migrateKeyStoreDir*(accountData: string, password: string, oldKeystoreDir: string, multiaccountKeystoreDir: string): string =
  cstringToString go_shim.migrateKeyStoreDir(accountData.cstring, password.cstring, oldKeystoreDir.cstring, multiaccountKeystoreDir.cstring)

proc startWallet*(watchNewBlocks: bool): string =
  cstringToString go_shim.startWallet(watchNewBlocks)

proc stopWallet*(): string =
  cstringToString go_shim.stopWallet()

proc startLocalNotifications*(): string =
  cstringToString go_shim.startLocalNotifications()

proc stopLocalNotifications*(): string =
  cstringToString go_shim.stopLocalNotifications()

proc getNodeConfig*(): string =
  cstringToString go_shim.getNodeConfig()

proc imageServerTLSCert*(): string =
  cstringToString go_shim.imageServerTLSCert()

proc getPasswordStrength*(paramsJSON: string): string =
  cstringToString go_shim.getPasswordStrength(paramsJSON.cstring)

proc getPasswordStrengthScore*(paramsJSON: string): string =
  cstringToString go_shim.getPasswordStrengthScore(paramsJSON.cstring)

proc switchFleet*(newFleet: string, configJSON: string): string =
  cstringToString go_shim.switchFleet(newFleet.cstring, configJSON.cstring)

proc generateImages*(imagePath: string, aX: int, aY: int, bX: int, bY: int): string =
  cstringToString go_shim.generateImages(imagePath.cstring, aX.cint, aY.cint, bX.cint, bY.cint)

proc getConnectionStringForBeingBootstrapped*(configJSON: string): string =
  cstringToString go_shim.getConnectionStringForBeingBootstrapped(configJSON.cstring)

proc getConnectionStringForBootstrappingAnotherDevice*(configJSON: string): string =
  cstringToString go_shim.getConnectionStringForBootstrappingAnotherDevice(configJSON.cstring)

proc inputConnectionStringForBootstrapping*(connectionString: string, configJSON: string): string =
  cstringToString go_shim.inputConnectionStringForBootstrapping(connectionString.cstring, configJSON.cstring)

proc validateConnectionString*(connectionString: string): string =
  cstringToString go_shim.validateConnectionString(connectionString.cstring)
