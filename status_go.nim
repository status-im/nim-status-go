
# This module (see also `./status_go/impl.nim`) wraps the API supplied by
# status-go when it is compiled into `libstatus.a|dll|dylib|so`.

# It is expected that this module will be consumed as an import in another Nim
# module; when doing so, it is not necessary to separately compile
# `./status_go/impl.nim` but it is the responsibility of the user to link
# status-go compiled to `libstatus` into the final executable.

import ./status_go/impl as go_shim

export SignalCallback

proc hashMessage*(message: string): string =
  var funcOut = go_shim.hashMessage(message.cstring)
  defer: go_shim.free(funcOut)
  return $funcOut

proc initKeystore*(keydir: string): string =
  var funcOut = go_shim.initKeystore(keydir.cstring)
  defer: go_shim.free(funcOut)
  return $funcOut

proc openAccounts*(datadir: string): string =
  var funcOut = go_shim.openAccounts(datadir.cstring)
  defer: go_shim.free(funcOut)
  return $funcOut

proc multiAccountGenerateAndDeriveAddresses*(paramsJSON: string): string =
  var funcOut = go_shim.multiAccountGenerateAndDeriveAddresses(paramsJSON.cstring)
  defer: go_shim.free(funcOut)
  return $funcOut

proc multiAccountStoreDerivedAccounts*(paramsJSON: string): string =
  var funcOut = go_shim.multiAccountStoreDerivedAccounts(paramsJSON.cstring)
  defer: go_shim.free(funcOut)
  return $funcOut

proc multiAccountImportMnemonic*(paramsJSON: string): string =
  var funcOut = go_shim.multiAccountImportMnemonic(paramsJSON.cstring)
  defer: go_shim.free(funcOut)
  return $funcOut

proc multiAccountImportPrivateKey*(paramsJSON: string): string =
  var funcOut = go_shim.multiAccountImportPrivateKey(paramsJSON.cstring)
  defer: go_shim.free(funcOut)
  return $funcOut

proc multiAccountDeriveAddresses*(paramsJSON: string): string =
  var funcOut = go_shim.multiAccountDeriveAddresses(paramsJSON.cstring)
  defer: go_shim.free(funcOut)
  return $funcOut

proc saveAccountAndLogin*(accountData: string, password: string, settingsJSON: string, configJSON: string, subaccountData: string): string =
  var funcOut = go_shim.saveAccountAndLogin(accountData.cstring, password.cstring, settingsJSON.cstring, configJSON.cstring, subaccountData.cstring)
  defer: go_shim.free(funcOut)
  return $funcOut

proc deleteMultiAccount*(keyUID: string, keyStoreDir: string): string =
  var funcOut = go_shim.deleteMultiAccount(keyUID.cstring, keyStoreDir.cstring)
  defer: go_shim.free(funcOut)
  return $funcOut

proc callRPC*(inputJSON: string): string =
  var funcOut = go_shim.callRPC(inputJSON.cstring)
  defer: go_shim.free(funcOut)
  return $funcOut

proc callPrivateRPC*(inputJSON: string): string =
  var funcOut = go_shim.callPrivateRPC(inputJSON.cstring)
  defer: go_shim.free(funcOut)
  return $funcOut

proc addPeer*(peer: string): string =
  var funcOut = go_shim.addPeer(peer.cstring)
  defer: go_shim.free(funcOut)
  return $funcOut

proc setSignalEventCallback*(callback: SignalCallback) =
  go_shim.setSignalEventCallback(callback)

proc sendTransaction*(jsonArgs: string, password: string): string =
  var funcOut = go_shim.sendTransaction(jsonArgs.cstring, password.cstring)
  defer: go_shim.free(funcOut)
  return $funcOut

proc generateAlias*(pk: string): string =
  var funcOut = go_shim.generateAlias(pk)
  defer: go_shim.free(funcOut)
  return $funcOut

proc isAlias*(value: string): string =
  var funcOut = go_shim.isAlias(value)
  defer: go_shim.free(funcOut)
  return $funcOut

proc identicon*(pk: string): string =
  var funcOut = go_shim.identicon(pk)
  defer: go_shim.free(funcOut)
  return $funcOut

proc emojiHash*(pk: string): string =
  var funcOut = go_shim.emojiHash(pk)
  defer: go_shim.free(funcOut)
  return $funcOut

proc colorHash*(pk: string): string =
  var funcOut = go_shim.colorHash(pk)
  defer: go_shim.free(funcOut)
  return $funcOut

proc colorID*(pk: string): string =
  var funcOut = go_shim.colorID(pk)
  defer: go_shim.free(funcOut)
  return $funcOut

proc login*(accountData: string, password: string): string =
  var funcOut = go_shim.login(accountData.cstring, password.cstring)
  defer: go_shim.free(funcOut)
  return $funcOut

proc loginWithConfig*(accountData: string, password: string, nodeCfg: string): string =
  var funcOut = go_shim.loginWithConfig(accountData.cstring, password.cstring, nodeCfg.cstring)
  defer: go_shim.free(funcOut)
  return $funcOut

proc logout*(): string =
  var funcOut = go_shim.logout()
  defer: go_shim.free(funcOut)
  return $funcOut

proc verifyAccountPassword*(keyStoreDir: string, address: string, password: string): string =
  var funcOut = go_shim.verifyAccountPassword(keyStoreDir.cstring, address.cstring, password.cstring)
  defer: go_shim.free(funcOut)
  return $funcOut

proc changeDatabasePassword*(keyUID: string, password: string, newPassword: string): string =
  var funcOut = go_shim.changeDatabasePassword(keyUID.cstring, password.cstring, newPassword.cstring)
  defer: go_shim.free(funcOut)
  return $funcOut

proc validateMnemonic*(mnemonic: string): string =
  var funcOut = go_shim.validateMnemonic(mnemonic.cstring)
  defer: go_shim.free(funcOut)
  return $funcOut

proc saveAccountAndLoginWithKeycard*(accountData: string, password: string, settingsJSON: string, configJSON: string, subaccountData: string, keyHex: string): string =
  var funcOut = go_shim.saveAccountAndLoginWithKeycard(accountData.cstring, password.cstring, settingsJSON.cstring, configJSON.cstring, subaccountData.cstring, keyHex.cstring)
  defer: go_shim.free(funcOut)
  return $funcOut

proc hashTransaction*(txArgsJSON: string): string =
  var funcOut = go_shim.hashTransaction(txArgsJSON.cstring)
  defer: go_shim.free(funcOut)
  return $funcOut

proc extractGroupMembershipSignatures*(signaturePairsStr: string): string =
  var funcOut = go_shim.extractGroupMembershipSignatures(signaturePairsStr.cstring)
  defer: go_shim.free(funcOut)
  return $funcOut

proc connectionChange*(typ: string, expensive: string) =
  go_shim.connectionChange(typ.cstring, expensive.cstring)

proc multiformatSerializePublicKey*(key: string, outBase: string): string =
  var funcOut = go_shim.multiformatSerializePublicKey(key.cstring, outBase.cstring)
  defer: go_shim.free(funcOut)
  return $funcOut

proc multiformatDeserializePublicKey*(key: string, outBase: string): string =
  var funcOut = go_shim.multiformatDeserializePublicKey(key.cstring, outBase.cstring)
  defer: go_shim.free(funcOut)
  return $funcOut

proc validateNodeConfig*(configJSON: string): string =
  var funcOut = go_shim.validateNodeConfig(configJSON.cstring)
  defer: go_shim.free(funcOut)
  return $funcOut

proc loginWithKeycard*(accountData: string, password: string, keyHex: string): string =
  var funcOut = go_shim.loginWithKeycard(accountData.cstring, password.cstring, keyHex.cstring)
  defer: go_shim.free(funcOut)
  return $funcOut

proc recover*(rpcParams: string): string =
  var funcOut = go_shim.recover(rpcParams.cstring)
  defer: go_shim.free(funcOut)
  return $funcOut

proc writeHeapProfile*(dataDir: string): string =
  var funcOut = go_shim.writeHeapProfile(dataDir.cstring)
  defer: go_shim.free(funcOut)
  return $funcOut

proc hashTypedData*(data: string): string =
  var funcOut = go_shim.hashTypedData(data.cstring)
  defer: go_shim.free(funcOut)
  return $funcOut

proc resetChainData*(): string =
  var funcOut = go_shim.resetChainData()
  defer: go_shim.free(funcOut)
  return $funcOut

proc signMessage*(rpcParams: string): string =
  var funcOut = go_shim.signMessage(rpcParams.cstring)
  defer: go_shim.free(funcOut)
  return $funcOut

proc signTypedData*(data: string, address: string, password: string): string =
  var funcOut = go_shim.signTypedData(data.cstring, address.cstring, password.cstring)
  defer: go_shim.free(funcOut)
  return $funcOut

proc stopCPUProfiling*(): string =
  var funcOut = go_shim.stopCPUProfiling()
  defer: go_shim.free(funcOut)
  return $funcOut

proc getNodesFromContract*(rpcEndpoint: string, contractAddress: string): string =
  var funcOut = go_shim.getNodesFromContract(rpcEndpoint.cstring, contractAddress.cstring)
  defer: go_shim.free(funcOut)
  return $funcOut

proc exportNodeLogs*(): string =
  var funcOut = go_shim.exportNodeLogs()
  defer: go_shim.free(funcOut)
  return $funcOut

proc chaosModeUpdate*(on: int): string =
  var funcOut = go_shim.chaosModeUpdate(on.cint)
  defer: go_shim.free(funcOut)
  return $funcOut

proc signHash*(hexEncodedHash: string): string =
  var funcOut = go_shim.signHash(hexEncodedHash.cstring)
  defer: go_shim.free(funcOut)
  return $funcOut

proc sendTransactionWithSignature*(txtArgsJSON: string, sigString: string): string =
  var funcOut = go_shim.sendTransactionWithSignature(txtArgsJSON.cstring, sigString.cstring)
  defer: go_shim.free(funcOut)
  return $funcOut

proc startCPUProfile*(dataDir: string): string =
  var funcOut = go_shim.startCPUProfile(dataDir.cstring)
  defer: go_shim.free(funcOut)
  return $funcOut

proc appStateChange*(state: string) =
  go_shim.appStateChange(state.cstring)

proc signGroupMembership*(content: string): string =
  var funcOut = go_shim.signGroupMembership(content.cstring)
  defer: go_shim.free(funcOut)
  return $funcOut

proc multiAccountStoreAccount*(paramsJSON: string): string =
  var funcOut = go_shim.multiAccountStoreAccount(paramsJSON.cstring)
  defer: go_shim.free(funcOut)
  return $funcOut

proc multiAccountLoadAccount*(paramsJSON: string): string =
  var funcOut = go_shim.multiAccountLoadAccount(paramsJSON.cstring)
  defer: go_shim.free(funcOut)
  return $funcOut

proc multiAccountGenerate*(paramsJSON: string): string =
  var funcOut = go_shim.multiAccountGenerate(paramsJSON.cstring)
  defer: go_shim.free(funcOut)
  return $funcOut

proc multiAccountReset*(): string =
  var funcOut = go_shim.multiAccountReset()
  defer: go_shim.free(funcOut)
  return $funcOut

proc migrateKeyStoreDir*(accountData: string, password: string, oldKeystoreDir: string, multiaccountKeystoreDir: string): string =
  var funcOut = go_shim.migrateKeyStoreDir(accountData.cstring, password.cstring, oldKeystoreDir.cstring, multiaccountKeystoreDir.cstring)
  defer: go_shim.free(funcOut)
  return $funcOut

proc startWallet*(watchNewBlocks: bool): string =
  var funcOut = go_shim.startWallet(watchNewBlocks)
  defer: go_shim.free(funcOut)
  return $funcOut

proc stopWallet*(): string =
  var funcOut = go_shim.stopWallet()
  defer: go_shim.free(funcOut)
  return $funcOut

proc startLocalNotifications*(): string =
  var funcOut = go_shim.startLocalNotifications()
  defer: go_shim.free(funcOut)
  return $funcOut

proc stopLocalNotifications*(): string =
  var funcOut = go_shim.stopLocalNotifications()
  defer: go_shim.free(funcOut)
  return $funcOut

proc getNodeConfig*(): string =
  var funcOut = go_shim.getNodeConfig()
  defer: go_shim.free(funcOut)
  return $funcOut

proc imageServerTLSCert*(): string =
  var funcOut = go_shim.imageServerTLSCert()
  defer: go_shim.free(funcOut)
  return $funcOut

proc getPasswordStrength*(paramsJSON: string): string =
  var funcOut = go_shim.getPasswordStrength(paramsJSON.cstring)
  defer: go_shim.free(funcOut)
  return $funcOut

proc getPasswordStrengthScore*(paramsJSON: string): string =
  var funcOut = go_shim.getPasswordStrengthScore(paramsJSON.cstring)
  defer: go_shim.free(funcOut)
  return $funcOut

proc switchFleet*(newFleet: string, configJSON: string): string =
  var funcOut = go_shim.switchFleet(newFleet.cstring, configJSON.cstring)
  defer: go_shim.free(funcOut)
  return $funcOut

proc generateImages*(imagePath: string, aX: int, aY: int, bX: int, bY: int): string =
  var funcOut = go_shim.generateImages(imagePath.cstring, aX.cint, aY.cint, bX.cint, bY.cint)
  defer: go_shim.free(funcOut)
  return $funcOut