final: prev: {
  # Needs unreleased `--library` flag
  ligo = prev.ligo.overrideAttrs (o: {
    version = "0.64.3";
    src = prev.fetchFromGitLab {
      owner = "ligolang";
      repo = "ligo";
      rev = "e1ba699deb4622f59241dc057abbe0ff0bacc24d";
      sha256 = "sha256-2ralD+bXjKNmKeka7cMjIvkTybOf232vjDLp3UQ+jwE=";
      fetchSubmodules = true;
    };

    postPatch = ''
      substituteInPlace "vendors/tezos-ligo/src/lib_hacl/hacl.ml" \
        --replace \
          "Hacl.NaCl.Noalloc.Easy.secretbox ~pt:msg ~n:nonce ~key ~ct:cmsg" \
          "Hacl.NaCl.Noalloc.Easy.secretbox ~pt:msg ~n:nonce ~key ~ct:cmsg ()" \
        --replace \
          "Hacl.NaCl.Noalloc.Easy.box_afternm ~pt:msg ~n:nonce ~ck:k ~ct:cmsg" \
          "Hacl.NaCl.Noalloc.Easy.box_afternm ~pt:msg ~n:nonce ~ck:k ~ct:cmsg ()"
      
      substituteInPlace "vendors/tezos-ligo/src/lib_crypto/crypto_box.ml" \
        --replace \
          "secretbox_open ~key ~nonce ~cmsg ~msg" \
          "secretbox_open ~key ~nonce ~cmsg ~msg ()" \
        --replace \
          "Box.box_open ~k ~nonce ~cmsg ~msg" \
          "Box.box_open ~k ~nonce ~cmsg ~msg ()"
    '';
  });

  buildLigoPackage = final.callPackage ./buildLigoPackage.nix { };

  ligoPackages = final.callPackage ./packages.nix { };
}
