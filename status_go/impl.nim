# go functions do not raise nim exceptions and do not interact with the Nim gc
{.push raises: [], gcsafe.}

type SignalCallback* = proc(signal: cstring): void {.cdecl.}

# All procs start with lowercase because the compiler will also need to import
# status-go, and it will complain of duplication of function names

proc hashMessage*(message: cstring): cstring {.importc: "HashMessage".}

proc initializeApplication*(paramsJSON: cstring): cstring {.importc: "InitializeApplication".}

proc toggleCentralizedMetrics*(paramsJSON: cstring): cstring {.importc: "ToggleCentralizedMetrics".}

proc addCentralizedMetric*(paramsJSON: cstring): cstring {.importc: "AddCentralizedMetric".}

proc centralizedMetricsInfo*(): cstring {.importc: "CentralizedMetricsInfo".}

proc createAccountFromMnemonicAndDeriveAccountsForPaths*(paramsJSON: cstring): cstring {.importc: "CreateAccountFromMnemonicAndDeriveAccountsForPaths".}

proc createAccountFromPrivateKey*(paramsJSON: cstring): cstring {.importc: "CreateAccountFromPrivateKey".}

proc multiAccountImportPrivateKey*(paramsJSON: cstring): cstring {.importc: "MultiAccountImportPrivateKey".}

proc multiAccountDeriveAddresses*(paramsJSON: cstring): cstring {.importc: "MultiAccountDeriveAddresses".}

proc deleteMultiAccount*(keyUID: cstring, keyStoreDir: cstring): cstring {.importc: "DeleteMultiaccount".}

proc callRPC*(inputJSON: cstring): cstring {.importc: "CallRPC".}

proc callPrivateRPC*(inputJSON: cstring): cstring {.importc: "CallPrivateRPC".}

proc addPeer*(peer: cstring): cstring {.importc: "AddPeer".}

proc setSignalEventCallback*(callback: SignalCallback) {.importc: "SetSignalEventCallback".}

proc sendTransaction*(jsonArgs: cstring, password: cstring): cstring {.importc: "SendTransaction".}

proc sendTransactionWithChainId*(chainId: cint, jsonArgs: cstring, password: cstring): cstring {.importc: "SendTransactionWithChainID".}

proc generateAlias*(pk: cstring): cstring {.importc: "GenerateAlias".}

proc isAlias*(value: cstring): cstring {.importc: "IsAlias".}

proc identicon*(pk: cstring): cstring {.importc: "Identicon".}

proc emojiHash*(pk: cstring): cstring {.importc: "EmojiHash".}

proc colorHash*(pk: cstring): cstring {.importc: "ColorHash".}

proc colorID*(pk: cstring): cstring {.importc: "ColorID".}

proc login*(accountData: cstring, password: cstring): cstring {.importc: "Login".}

proc logout*(): cstring {.importc: "Logout".}

proc verifyAccountPassword*(address: cstring, password: cstring): cstring {.importc: "VerifyAccountPassword".}

proc verifyDatabasePassword*(keyUID: cstring, password: cstring): cstring {.importc: "VerifyDatabasePassword".}

proc changeDatabasePassword*(keyUID: cstring, password: cstring, newPassword: cstring): cstring {.importc: "ChangeDatabasePassword".}

proc validateMnemonic*(mnemonic: cstring): cstring {.importc: "ValidateMnemonic".}

proc hashTransaction*(txArgsJSON: cstring): cstring {.importc: "HashTransaction".}

proc extractGroupMembershipSignatures*(signaturePairsStr: cstring): cstring {.importc: "ExtractGroupMembershipSignatures".}

proc connectionChange*(typ: cstring, expensive: cstring) {.importc: "ConnectionChange".}

proc multiformatSerializePublicKey*(key: cstring, outBase: cstring): cstring {.importc: "MultiformatSerializePublicKey".}

proc multiformatDeserializePublicKey*(key: cstring, outBase: cstring): cstring {.importc: "MultiformatDeserializePublicKey".}

proc decompressPublicKey*(key: cstring): cstring {.importc: "DecompressPublicKey".}

proc compressPublicKey*(key: cstring): cstring {.importc: "CompressPublicKey".}

proc validateNodeConfig*(configJSON: cstring): cstring {.importc: "ValidateNodeConfig".}

proc loginWithKeycard*(accountData: cstring, password: cstring, keyHex: cstring, confNode: cstring): cstring {.importc: "LoginWithKeycard".}

func convertToKeycardAccount*(accountData: cstring, settingsJSON: cstring, keycardUid: cstring, password: cstring, newPassword: cstring): cstring {.importc: "ConvertToKeycardAccount".}

func convertToRegularAccount*(mnemonic: cstring, currPassword: cstring, newPassword: cstring): cstring {.importc: "ConvertToRegularAccount".}

proc recover*(rpcParams: cstring): cstring {.importc: "Recover".}

proc writeHeapProfile*(dataDir: cstring): cstring {.importc: "WriteHeapProfile".}

proc hashTypedData*(data: cstring): cstring {.importc: "HashTypedData".}

proc hashTypedDataV4*(data: cstring): cstring {.importc: "HashTypedDataV4".}

proc resetChainData*(): cstring {.importc: "ResetChainData".}

proc signMessage*(rpcParams: cstring): cstring {.importc: "SignMessage".}

proc signTypedData*(data: cstring, address: cstring, password: cstring): cstring {.importc: "SignTypedData".}

proc stopCPUProfiling*(): cstring {.importc: "StopCPUProfiling".}

proc getNodesFromContract*(rpcEndpoint: cstring, contractAddress: cstring): cstring {.importc: "GetNodesFromContract".}

proc exportNodeLogs*(): cstring {.importc: "ExportNodeLogs".}

proc chaosModeUpdate*(on: cint): cstring {.importc: "ChaosModeUpdate".}

proc signHash*(hexEncodedHash: cstring): cstring {.importc: "SignHash".}

proc sendTransactionWithSignature*(txtArgsJSON: cstring, sigString: cstring): cstring {.importc: "SendTransactionWithSignature".}

proc startCPUProfile*(dataDir: cstring): cstring {.importc: "StartCPUProfile".}

proc appStateChange*(state: cstring) {.importc: "AppStateChange".}

proc signGroupMembership*(content: cstring): cstring {.importc: "SignGroupMembership".}

proc multiAccountStoreAccount*(paramsJSON: cstring): cstring {.importc: "MultiAccountStoreAccount".}

proc multiAccountLoadAccount*(paramsJSON: cstring): cstring {.importc: "MultiAccountLoadAccount".}

proc multiAccountGenerate*(paramsJSON: cstring): cstring {.importc: "MultiAccountGenerate".}

proc multiAccountReset*(): cstring {.importc: "MultiAccountReset".}

proc migrateKeyStoreDir*(accountData: cstring, password: cstring, oldKeystoreDir: cstring, multiaccountKeystoreDir: cstring): cstring {.importc: "MigrateKeyStoreDir".}

proc startWallet*(watchNewBlocks: bool): cstring {.importc: "StartWallet".}

proc stopWallet*(): cstring {.importc: "StopWallet".}

proc startLocalNotifications*(): cstring {.importc: "StartLocalNotifications".}

proc stopLocalNotifications*(): cstring {.importc: "StopLocalNotifications".}

proc getNodeConfig*(): cstring {.importc: "GetNodeConfig".}

proc free*(param: pointer) {.importc: "Free".}

proc imageServerTLSCert*(): cstring {.importc: "ImageServerTLSCert".}

proc getPasswordStrength*(paramsJSON: cstring): cstring {.importc: "GetPasswordStrength".}

proc getPasswordStrengthScore*(paramsJSON: cstring): cstring {.importc: "GetPasswordStrengthScore".}

proc switchFleet*(newFleet: cstring, configJSON: cstring): cstring{.importc: "SwitchFleet".}

proc generateImages*(imagePath: cstring, aX: cint, aY: cint, bX: cint, bY: cint): cstring {.importc: "GenerateImages".}

proc getConnectionStringForBeingBootstrapped*(configJSON: cstring) : cstring {.importc: "GetConnectionStringForBeingBootstrapped".}

proc getConnectionStringForBootstrappingAnotherDevice*(configJSON: cstring) : cstring {.importc: "GetConnectionStringForBootstrappingAnotherDevice".}

proc inputConnectionStringForBootstrapping*(connectionString: cstring, configJSON: cstring) : cstring {.importc: "InputConnectionStringForBootstrapping".}

proc validateConnectionString*(connectionString: cstring) : cstring {.importc: "ValidateConnectionString".}

proc getConnectionStringForExportingKeypairsKeystores*(configJSON: cstring) : cstring {.importc: "GetConnectionStringForExportingKeypairsKeystores".}

proc inputConnectionStringForImportingKeypairsKeystores*(connectionString: cstring, configJSON: cstring) : cstring {.importc: "InputConnectionStringForImportingKeypairsKeystores".}

proc loginAccount*(requestJSON: cstring): cstring {.importc: "LoginAccount".}

proc createAccountAndLogin*(requestJSON: cstring): cstring {.importc: "CreateAccountAndLogin".}

proc restoreAccountAndLogin*(requestJSON: cstring): cstring {.importc: "RestoreAccountAndLogin".}
