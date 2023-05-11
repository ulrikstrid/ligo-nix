final: prev: {
  # Needs unreleased `--library` flag
  ligo = prev.ligo.overrideAttrs (o: rec {
    version = "0.65.0";
    src = prev.fetchFromGitLab {
      owner = "ligolang";
      repo = "ligo";
      rev = version;
      sha256 = "sha256-vBvgagXK9lOXRI+iBwkPKmUvncZjrqHpKI3UAqOzHvc=";
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
