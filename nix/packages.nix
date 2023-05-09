{ lib, stdenv, fetchFromGitHub, buildLigoPackage, bash }:

rec {
  ligo-fa = buildLigoPackage {
    pname = "@ligo/fa";
    version = "1.0.5";

    src = fetchFromGitHub {
      owner = "ligolang";
      repo = "contract-catalogue";
      rev = "e715e9614e61e538dfb68c7ead0a3e4eaeda2434";
      sha256 = "sha256-SN8kjoH0iMRs65H7KN+Dg+FPnxrvn0BJn+S+QYKEhqU=";
    };

    mainFile = "lib/fa2/nft/NFT.mligo";
    entrypoint = "NFT_mligo";
  };

  ligo-bigarray = buildLigoPackage rec {
    pname = "@ligo/bigarray";
    version = "1.0.0";

    src = fetchFromGitHub {
      owner = "ligolang";
      repo = "bigarray-cameligo";
      rev = "${version}";
      sha256 = "sha256-8WeJiAtv5owLwkFC8OgLtQfYwI9qxzWTeObb3EGs+fU=";
    };
  };

  ligo-math-lib = buildLigoPackage rec {
    pname = "@ligo/math-lib";
    version = "1.0.0";

    src = fetchFromGitHub {
      owner = "ligolang";
      repo = "math-lib-cameligo";
      rev = "${version}";
      sha256 = "sha256-/Ohmkj597l3HEXaOmqh+ryy88vT6z9lHU734kiBcADk=";
    };
  };

  ligo-permit = buildLigoPackage rec {
    pname = "@ligo/permit";
    version = "1.0.0";

    src = fetchFromGitHub {
      owner = "ligolang";
      repo = "permit-cameligo";
      rev = "${version}";
      sha256 = "sha256-zUYItOBpImdBbCgunjQnU+H/AK2Nq9QwwpIeGWnKGDE=";
    };

    postPatch = ''
      substituteInPlace ./Makefile --replace "/bin/bash" "${bash}/bin/bash"
    '';

    propagatedBuildInputs = [
      ligo-extendable-fa2
    ];

    entrypoint = "taco_shop_token";
  };

  ligo-extendable-fa2 = buildLigoPackage rec {
    pname = "ligo-extendable-fa2";
    version = "1.0.4";

    src = fetchFromGitHub {
      owner = "smart-chain-fr";
      repo = "ligoExtendableFA2";
      rev = "91f564d96be404687739426a2e8477d294f69365";
      sha256 = "sha256-ihY/q/Ixm1Vj8B+DfTbh3ahWghN5VY+hefvCpgrRoAo=";
    };

    postPatch = ''
      substituteInPlace ./Makefile --replace "/bin/bash" "${bash}/bin/bash"
    '';
  };
}
