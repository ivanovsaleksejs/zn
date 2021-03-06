{ mkDerivation, aeson, array, async, base, base64-bytestring
, bytestring, case-insensitive, conduit, conduit-combinators
, conduit-extra, connection, containers, data-default, exceptions
, extra, http-client, http-client-tls, http-types, ini, irc-client
, irc-conduit, lens, megaparsec, mtl, network, process, regex-tdfa
, regex-tdfa-text, retry, safe, split, stdenv, stm, stm-chans
, streaming-commons, strict, strptime, tagged, tagsoup
, template-haskell, text, text-format, time, tls, transformers
, uglymemo, unix, unix-time, x509-system, xml-conduit, hspec
, pkgs
}:

let deps = [
    aeson array async base base64-bytestring bytestring
    case-insensitive conduit conduit-combinators conduit-extra
    connection containers data-default exceptions extra http-client
    http-client-tls http-types ini irc-client irc-conduit lens
    megaparsec mtl network process regex-tdfa regex-tdfa-text retry
    safe split stm stm-chans streaming-commons strict strptime tagged
    tagsoup template-haskell text text-format time tls transformers
    uglymemo unix unix-time x509-system xml-conduit hspec
    pkgs.git pkgs.coreutils
  ];

in mkDerivation {
    pname = "zn";
    version = "0.1.0.0";
    src = ./..;
    isLibrary = false;
    isExecutable = true;
    enableSharedExecutables = false;
    enableSharedLibraries   = false;
    executableHaskellDepends = deps;
    testHaskellDepends = deps;
    description = "IRC bot";
    license = stdenv.lib.licenses.unfree;
}
