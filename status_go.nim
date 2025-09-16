
when defined(STATUS_GO_EXTERNAL):
  # External process mode: call status-go HTTP endpoints instead of linked library.
  import std/[httpclient, strformat, json, os]

  # Match existing callback usage which passes cstring from C layer
  type SignalCallback* = proc(event: cstring) {.cdecl, gcsafe, raises: [].}

  var statusGoBase* {.threadvar.}: string
  # Because this is a threadvar, background threads (like the signal poller)
  # start with an empty value. We lazily initialize inside `endpoint` to ensure
  # each thread resolves the base URL (avoids missing scheme like '/statusgo/NextSignals').
  if statusGoBase.len == 0:
    statusGoBase = getEnv("STATUS_GO_URL", "http://127.0.0.1:7779")

  proc httpPost(url, body: string): string {.raises: [], gcsafe.} =
    ## Perform a POST returning body or JSON error. Never propagates exceptions.
    var c: HttpClient
    try:
      c = newHttpClient()
      let resp = c.request(url,
                           httpMethod=HttpPost,
                           body=body,
                           headers=newHttpHeaders({"Content-Type": "application/json"}))
      return resp.body
    except Exception as e:
      echo "HTTP error: " & e.msg
      return $(%*{"error": %*{"code": -32100, "message": "http request failed: " & e.msg}})
    finally:
      if c != nil:
        try:
          c.close()
        except Exception:
          discard

  proc jsonErr(name: string): string =
    let n = %*{
      "error": %*{
        "code": -32099,
        "message": "STATUS_GO_EXTERNAL: not implemented: " & name
      }
    }
    $n

  proc endpoint(name: string): string {.inline, gcsafe.} =
    if statusGoBase.len == 0: # lazy init for any new thread
      statusGoBase = getEnv("STATUS_GO_URL", "http://127.0.0.1:7779")
    statusGoBase & "/statusgo/" & name

  template withReq(name, path: untyped, bodyIdent: untyped) {.gensym.} =
    proc name*(bodyIdent: string): string {.raises: [], gcsafe.} = httpPost(endpoint(path), bodyIdent)

  template withoutReq(name, path: untyped) {.gensym.} =
    proc name*(): string {.raises: [], gcsafe.} = httpPost(endpoint(path), "")

  # Implemented (direct mapping)
  withReq(initializeApplication, "InitializeApplication", paramsJSON)
  withReq(callRPC, "CallRPC", inputJSON)
  withReq(callPrivateRPC, "CallPrivateRPC", inputJSON)
  withoutReq(logout, "Logout")
  withoutReq(getNodeConfig, "GetNodeConfig")
  withReq(changeDatabasePasswordV2, "ChangeDatabasePasswordV2", paramsJSON)
  withReq(writeHeapProfile, "WriteHeapProfile", dataDir) # server expects body
  withReq(startCPUProfile, "StartCPUProfile", dataDir)
  withoutReq(stopCPUProfiling, "StopCPUProfiling")
  withReq(signMessage, "SignMessage", rpcParams)
  withReq(hashTypedData, "HashTypedData", data)
  withReq(hashTypedDataV4, "HashTypedDataV4", data)
  withReq(hashTransaction, "HashTransaction", txArgsJSON)
  withReq(hashMessage, "HashMessage", message)
  withReq(signHash, "SignHash", hexEncodedHash)
  withReq(getPasswordStrength, "GetPasswordStrength", paramsJSON)
  withReq(getPasswordStrengthScore, "GetPasswordStrengthScore", paramsJSON)
  withReq(switchFleet, "SwitchFleetV2", configJSON) # new V2 endpoint
  withoutReq(startLocalNotifications, "StartLocalNotifications")
  withoutReq(stopLocalNotifications, "StopLocalNotifications")
  withoutReq(imageServerTLSCert, "ImageServerTLSCert")
  withoutReq(centralizedMetricsInfo, "CentralizedMetricsInfo")
  withoutReq(performLocalBackup, "PerformLocalBackup")

  # Accounts / multi-account operations required by desktop higher-level modules
  withReq(createAccountFromMnemonicAndDeriveAccountsForPaths, "CreateAccountFromMnemonicAndDeriveAccountsForPaths", paramsJSON)
  withReq(createAccountFromPrivateKey, "CreateAccountFromPrivateKey", paramsJSON)
  withReq(multiAccountImportPrivateKey, "MultiAccountImportPrivateKey", paramsJSON)
  withReq(multiAccountDeriveAddresses, "MultiAccountDeriveAddresses", paramsJSON)
  withReq(deleteMultiAccount, "DeleteMultiAccount", paramsJSON)

  # Mapped to V2 replacements
  # Keycard conversion endpoints: original API accepts multiple arguments. We pack them into JSON objects.
  proc convertToKeycardAccount*(accountData, settings, keycardUid, password, newPassword: string): string {.raises: [], gcsafe.} =
    let body = %*{
      "accountData": accountData,
      "settings": settings,
      "keycardUid": keycardUid,
      "password": password,
      "newPassword": newPassword
    }
    httpPost(endpoint("ConvertToKeycardAccountV2"), $body)

  proc convertToRegularAccount*(mnemonic, currPassword, newPassword: string): string {.raises: [], gcsafe.} =
    let body = %*{
      "mnemonic": mnemonic,
      "currPassword": currPassword,
      "newPassword": newPassword
    }
    httpPost(endpoint("ConvertToRegularAccountV2"), $body)
  withReq(generateImages, "GenerateImagesV2", imagePath)
  proc inputConnectionStringForBootstrapping*(connectionString, configJSON: string): string {.raises: [], gcsafe.} =
    let body = %*{"connectionString": connectionString, "configJSON": configJSON}
    httpPost(endpoint("InputConnectionStringForBootstrappingV2"), $body)
  proc inputConnectionStringForBootstrappingAnotherDevice*(connectionString, configJSON: string): string {.raises: [], gcsafe.} =
    let body = %*{"connectionString": connectionString, "configJSON": configJSON}
    httpPost(endpoint("InputConnectionStringForBootstrappingAnotherDeviceV2"), $body)
  proc inputConnectionStringForImportingKeypairsKeystores*(connectionString, configJSON: string): string {.raises: [], gcsafe.} =
    let body = %*{"connectionString": connectionString, "configJSON": configJSON}
    httpPost(endpoint("InputConnectionStringForImportingKeypairsKeystoresV2"), $body)
  withReq(migrateKeyStoreDir, "MigrateKeyStoreDirV2", accountData)

  # Connection string getters
  withReq(getConnectionStringForBeingBootstrapped, "GetConnectionStringForBeingBootstrapped", configJSON)
  withReq(getConnectionStringForBootstrappingAnotherDevice, "GetConnectionStringForBootstrappingAnotherDevice", configJSON)
  withReq(getConnectionStringForExportingKeypairsKeystores, "GetConnectionStringForExportingKeypairsKeystores", configJSON)
  withReq(validateConnectionString, "ValidateConnectionString", connectionString)

  # Account/login flows (legacy mapping approximation)
  withReq(loginAccount, "LoginAccount", requestJson)
  withReq(createAccountAndLogin, "CreateAccountAndLogin", requestJSON)
  withReq(restoreAccountAndLogin, "RestoreAccountAndLogin", requestJSON)

  # Legacy login() signature mapped to LoginAccount expecting combined JSON.
  proc login*(accountData: string, password: string): string {.raises: [], gcsafe.} =
    let bodyNode = %*{"accountData": accountData, "password": password}
    httpPost(endpoint("LoginAccount"), $bodyNode)

  # Stubs / Not implemented yet
  proc addPeer*(peer: string): string {.raises: [], gcsafe.} = jsonErr("addPeer")
  proc sendTransaction*(jsonArgs: string, password: string): string {.raises: [], gcsafe.} = jsonErr("sendTransaction")
  proc sendTransactionWithChainId*(chainId: int, jsonArgs: string, password: string): string {.raises: [], gcsafe.} = jsonErr("sendTransactionWithChainId")
  proc generateAlias*(pk: string): string {.raises: [], gcsafe.} = jsonErr("generateAlias")
  proc isAlias*(value: string): string {.raises: [], gcsafe.} = jsonErr("isAlias")
  proc identicon*(pk: string): string {.raises: [], gcsafe.} = jsonErr("identicon")
  proc emojiHash*(pk: string): string {.raises: [], gcsafe.} = jsonErr("emojiHash")
  proc colorHash*(pk: string): string {.raises: [], gcsafe.} = jsonErr("colorHash")
  proc colorID*(pk: string): string {.raises: [], gcsafe.} = jsonErr("colorID")
  proc validateMnemonic*(mnemonic: string): string {.raises: [], gcsafe.} = jsonErr("validateMnemonic")
  proc extractGroupMembershipSignatures*(signaturePairsStr: string): string {.raises: [], gcsafe.} = jsonErr("extractGroupMembershipSignatures")
  proc connectionChange*(typ: string, expensive: string) = discard
  proc multiformatSerializePublicKey*(key: string, outBase: string): string {.raises: [], gcsafe.} = jsonErr("multiformatSerializePublicKey")
  proc multiformatDeserializePublicKey*(key: string, outBase: string): string {.raises: [], gcsafe.} = jsonErr("multiformatDeserializePublicKey")
  proc decompressPublicKey*(key: string): string {.raises: [], gcsafe.} = jsonErr("decompressPublicKey")
  proc compressPublicKey*(key: string): string {.raises: [], gcsafe.} = jsonErr("compressPublicKey")
  proc validateNodeConfig*(configJSON: string): string {.raises: [], gcsafe.} = jsonErr("validateNodeConfig")
  proc recover*(rpcParams: string): string {.raises: [], gcsafe.} = jsonErr("recover")
  proc resetChainData*(): string {.raises: [], gcsafe.} = jsonErr("resetChainData")
  proc signTypedData*(data: string, address: string, password: string): string {.raises: [], gcsafe.} = jsonErr("signTypedData")
  proc getNodesFromContract*(rpcEndpoint: string, contractAddress: string): string {.raises: [], gcsafe.} = jsonErr("getNodesFromContract")
  proc exportNodeLogs*(): string {.raises: [], gcsafe.} = jsonErr("exportNodeLogs")
  proc chaosModeUpdate*(on: int): string {.raises: [], gcsafe.} = jsonErr("chaosModeUpdate")
  proc sendTransactionWithSignature*(txtArgsJSON: string, sigString: string): string {.raises: [], gcsafe.} = jsonErr("sendTransactionWithSignature")
  proc appStateChange*(state: string) = discard
  proc signGroupMembership*(content: string): string {.raises: [], gcsafe.} = jsonErr("signGroupMembership")
  proc multiAccountStoreAccount*(paramsJSON: string): string {.raises: [], gcsafe.} = jsonErr("multiAccountStoreAccount")
  proc multiAccountLoadAccount*(paramsJSON: string): string {.raises: [], gcsafe.} = jsonErr("multiAccountLoadAccount")
  proc multiAccountGenerate*(paramsJSON: string): string {.raises: [], gcsafe.} = jsonErr("multiAccountGenerate")
  proc multiAccountReset*(): string {.raises: [], gcsafe.} = jsonErr("multiAccountReset")
  proc startWallet*(watchNewBlocks: bool): string {.raises: [], gcsafe.} = jsonErr("startWallet")
  proc stopWallet*(): string {.raises: [], gcsafe.} = jsonErr("stopWallet")
  proc toggleCentralizedMetrics*(paramsJSON: string): string {.raises: [], gcsafe.} = jsonErr("toggleCentralizedMetrics")
  proc addCentralizedMetric*(paramsJSON: string): string {.raises: [], gcsafe.} = jsonErr("addCentralizedMetric")
  proc loadLocalBackup*(filePath: string): string {.raises: [], gcsafe.} =
    let body = %*{"filePath": filePath}
    httpPost(endpoint("LoadLocalBackup"), $body)

  #############################
  # Signal bridge (polling)
  #############################
  import std/[locks, times, threadpool]

  var signalCallback*: SignalCallback = nil
  var signalPollerStarted = false
  var signalLock: Lock
  var signalThread: Thread[void]  # background polling thread
  initLock(signalLock)

  proc fetchSignals(): seq[string] {.gcsafe.} =
    # Attempt to get batched signals. If endpoint missing, return empty.
    let resp = httpPost(endpoint("NextSignals"), "")
    try:
      let node = parseJson(resp)
      if node.kind == JArray:
        for it in node.items: result.add($it)
      elif node.kind == JObject and node.hasKey("signals"):
        for it in node["signals"].items: result.add($it.getStr)
    except:
      discard

  # Helper to invoke callback without requiring pollSignals itself to be non-gcsafe
  proc invokeCallback(cb: SignalCallback, payload: cstring) {.nimcall.} =
    try:
      cb(payload)
    except:
      discard

  proc pollSignals() {.thread.} =
    var emptyStreak = 0
    const baseInterval = 150   # ms minimum
    const maxInterval = 3000   # ms cap
    while true:
      var cb: SignalCallback
      acquire(signalLock)
      cb = signalCallback
      release(signalLock)
      if cb != nil:
        let sigs = fetchSignals()
        if sigs.len == 0:
          if emptyStreak < 1000: inc emptyStreak
        else:
          emptyStreak = 0
          for sig in sigs:
            invokeCallback(cb, sig.cstring)
      # exponential backoff based on empty streak
      var interval = baseInterval * (1 shl min(emptyStreak, 5)) # up to 32x
      if interval > maxInterval: interval = maxInterval
      sleep(interval)

  proc startPoller() {.gcsafe.} =
    if not signalPollerStarted:
      signalPollerStarted = true
  createThread(signalThread, pollSignals)

  proc setSignalEventCallback*(callback: SignalCallback) =
    acquire(signalLock)
    signalCallback = callback
    release(signalLock)
    startPoller()
  # Duplicate names already defined above are ignored by Nim due to redefinition errors; kept minimal.
else:
  # Linked library mode (original implementation)
  import ./status_go/impl as go_shim
  export SignalCallback
  
  proc hashMessage*(message: string): string =
    var funcOut = go_shim.hashMessage(message.cstring)
    defer: go_shim.free(funcOut)
    return $funcOut
  proc initializeApplication*(paramsJSON: string): string =
    var funcOut = go_shim.initializeApplication(paramsJSON.cstring)
    defer: go_shim.free(funcOut)
    return $funcOut
  proc toggleCentralizedMetrics*(paramsJSON: string): string =
    var funcOut = go_shim.toggleCentralizedMetrics(paramsJSON.cstring)
    defer: go_shim.free(funcOut)
    return $funcOut
  proc addCentralizedMetric*(paramsJSON: string): string =
    var funcOut = go_shim.addCentralizedMetric(paramsJSON.cstring)
    defer: go_shim.free(funcOut)
    return $funcOut
  proc centralizedMetricsInfo*(): string =
    var funcOut = go_shim.centralizedMetricsInfo()
    defer: go_shim.free(funcOut)
    return $funcOut
  proc createAccountFromMnemonicAndDeriveAccountsForPaths*(paramsJSON: string): string =
    var funcOut = go_shim.createAccountFromMnemonicAndDeriveAccountsForPaths(paramsJSON.cstring)
    defer: go_shim.free(funcOut)
    return $funcOut
  proc createAccountFromPrivateKey*(paramsJSON: string): string =
    var funcOut = go_shim.createAccountFromPrivateKey(paramsJSON.cstring)
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
  proc sendTransactionWithChainId*(chainId: int, jsonArgs: string, password: string): string =
    var funcOut = go_shim.sendTransactionWithChainId(chainId.cint, jsonArgs.cstring, password.cstring)
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
  proc logout*(): string =
    var funcOut = go_shim.logout()
    defer: go_shim.free(funcOut)
    return $funcOut
  proc changeDatabasePasswordV2*(paramsJSON: string): string =
    var funcOut = go_shim.changeDatabasePasswordV2(paramsJSON.cstring)
    defer: go_shim.free(funcOut)
    return $funcOut
  proc validateMnemonic*(mnemonic: string): string =
    var funcOut = go_shim.validateMnemonic(mnemonic.cstring)
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
  proc decompressPublicKey*(key: string): string =
    var funcOut = go_shim.decompressPublicKey(key.cstring)
    defer: go_shim.free(funcOut)
    return $funcOut
  proc compressPublicKey*(key: string): string =
    var funcOut = go_shim.compressPublicKey(key.cstring)
    defer: go_shim.free(funcOut)
    return $funcOut
  proc validateNodeConfig*(configJSON: string): string =
    var funcOut = go_shim.validateNodeConfig(configJSON.cstring)
    defer: go_shim.free(funcOut)
    return $funcOut
  proc convertToKeycardAccount*(accountData: string, settingsJSON: string, keycardUid: string, password: string, newPassword: string): string =
    var funcOut = go_shim.convertToKeycardAccount(accountData.cstring, settingsJSON.cstring, keycardUid.cstring, password.cstring, newPassword.cstring)
    defer: go_shim.free(funcOut)
    return $funcOut
  proc convertToRegularAccount*(mnemonic: string, currPassword: string, newPassword: string): string =
    var funcOut = go_shim.convertToRegularAccount(mnemonic.cstring, currPassword.cstring, newPassword.cstring)
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
  proc hashTypedDataV4*(data: string): string =
    var funcOut = go_shim.hashTypedDataV4(data.cstring)
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
  proc getConnectionStringForBeingBootstrapped*(configJSON: string): string =
    var funcOut = go_shim.getConnectionStringForBeingBootstrapped(configJSON.cstring)
    defer: go_shim.free(funcOut)
    return $funcOut
  proc getConnectionStringForBootstrappingAnotherDevice*(configJSON: string): string =
    var funcOut = go_shim.getConnectionStringForBootstrappingAnotherDevice(configJSON.cstring)
    defer: go_shim.free(funcOut)
    return $funcOut
  proc inputConnectionStringForBootstrapping*(connectionString: string, configJSON: string): string =
    var funcOut = go_shim.inputConnectionStringForBootstrapping(connectionString.cstring, configJSON.cstring)
    defer: go_shim.free(funcOut)
    return $funcOut
  proc validateConnectionString*(connectionString: string): string =
    var funcOut = go_shim.validateConnectionString(connectionString.cstring)
    defer: go_shim.free(funcOut)
    return $funcOut
  proc getConnectionStringForExportingKeypairsKeystores*(configJSON: string): string =
    var funcOut = go_shim.getConnectionStringForExportingKeypairsKeystores(configJSON.cstring)
    defer: go_shim.free(funcOut)
    return $funcOut
  proc inputConnectionStringForImportingKeypairsKeystores*(connectionString: string, configJSON: string): string =
    var funcOut = go_shim.inputConnectionStringForImportingKeypairsKeystores(connectionString.cstring, configJSON.cstring)
    defer: go_shim.free(funcOut)
    return $funcOut
  proc loginAccount*(requestJson: string): string =
    var funcOut = go_shim.loginAccount(requestJson.cstring)
    defer: go_shim.free(funcOut)
    return $funcOut
  proc createAccountAndLogin*(requestJSON: string): string =
    var funcOut = go_shim.createAccountAndLogin(requestJSON.cstring)
    defer: go_shim.free(funcOut)
    return $funcOut
  proc restoreAccountAndLogin*(requestJSON: string): string =
    var funcOut = go_shim.restoreAccountAndLogin(requestJSON.cstring)
    defer: go_shim.free(funcOut)
    return $funcOut
  proc performLocalBackup*(): string =
    var funcOut = go_shim.performLocalBackup()
    defer: go_shim.free(funcOut)
    return $funcOut
  proc loadLocalBackup*(filePath: string): string =
    var funcOut = go_shim.loadLocalBackup(filePath)
    defer: go_shim.free(funcOut)
    return $funcOut
