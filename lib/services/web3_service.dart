import 'dart:io';
import 'dart:math'; //used for the random number generator
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

const apiUrl = "https://data-seed-prebsc-1-s1.binance.org:8545";
var httpClient = Client();
var ethClient = Web3Client(apiUrl, httpClient);

class Web3Service {
  static final Web3Service _singleton = Web3Service._internal();

  factory Web3Service() {
    return _singleton;
  }

  Web3Service._internal();

  Future<String> createWallet(String privateKey) async {
    EthPrivateKey privKey = EthPrivateKey.fromHex(privateKey);
    Uint8List pubKey = privateKeyToPublic(privKey.privateKeyInt);

    Uint8List address = publicKeyToAddress(pubKey);
    String addressHex =
    bytesToHex(address, include0x: true, forcePadLength: 40);
    var random = Random.secure();
    Wallet wallet = Wallet.createNew(privKey, "password", random);
    await writeWallet(wallet.toJson());
    return addressHex;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/wallet.json');
  }

  Future<File> writeWallet(String text) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(text);
  }

  Future<String> readWallet() async {
    try {
      final file = await _localFile;

      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      return "";
    }
  }

  Future<double> getBalance() async {
    String content = await readWallet();
    Wallet wallet = Wallet.fromJson(content, "password");
    var credentials = EthPrivateKey.fromHex(wallet.privateKey.address.hex);

    EtherAmount balance = await ethClient.getBalance(credentials.address);
    return balance.getValueInUnit(EtherUnit.ether).toDouble();
  }

  Future<Wallet?> getWallet() async {
    try {
      String content = await readWallet();
      Wallet wallet = Wallet.fromJson(content, "password");
      return wallet;
    } catch (e) {
      return null;
    }
  }

  Future<String> getAddress() async {
    try {
      Wallet? wallet = await getWallet();
      var credentials =
      EthPrivateKey.fromHex(wallet?.privateKey.address.hex ?? "");
      return credentials.address.hex;
    } catch (e) {
      return '';
    }
  }

  Future<String> getPrivateKey() async {
    try {
      Wallet? wallet = await getWallet();
      return wallet?.privateKey.address.hex ?? "";
    } catch (e) {
      return '';
    }
  }

  Future<String> sendTransaction(String toAddress, double value) async {
    Wallet? wallet = await getWallet();
    Credentials credentials =
    EthPrivateKey.fromHex(wallet?.privateKey.address.hex ?? "");

    String result = await ethClient.sendTransaction(
      credentials,
      Transaction(
        to: EthereumAddress.fromHex(toAddress),
        gasPrice: EtherAmount.inWei(BigInt.from(10000000000)),
        maxGas: 250000,
        value: EtherAmount.fromUnitAndValue(
            EtherUnit.wei, BigInt.from(value * 1e18)),
      ),
      chainId: 97,
    );
    return result;
  }
}