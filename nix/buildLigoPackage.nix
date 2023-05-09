{ lib, stdenv, fetchFromGitHub, ligo, cacert }:

{ pname
, version
, src
, nativeBuildInputs ? [ ]
, propagatedBuildInputs ? [ ]
, entrypoint ? ""
, mainFile ? ""
, ...
}@args:

let
  drvInputs = drv:
    (drv.propagatedBuildInputs or [ ]);
  recursive = input:
    if input != null && builtins.isAttrs input then
      [ input (builtins.map recursive (drvInputs input)) ]
    else [ ];
  allPropagatedBuildInputs = p: lib.lists.unique (lib.lists.flatten (builtins.map recursive p));
  toLibraries = p:
    lib.optionalString (propagatedBuildInputs != [ ])
      (lib.concatMapStrings
        builtins.toString
        (lib.intersperse "," (allPropagatedBuildInputs p)));
  libraries =
    toLibraries propagatedBuildInputs;
  library_flag =
    lib.optionalString (libraries != "") "--library ${libraries}";
in

stdenv.mkDerivation (rec {
  inherit src version propagatedBuildInputs;

  dontAddStaticConfigureFlags = true;
  configurePlatforms = [ ];

  LIGO = "${ligo}/bin/ligo";
  CI = "true";

  passthru.libraries = toLibraries;

  buildPhase =
    if entrypoint == "" then
      ''
        runHook preBuild

        echo "skip build"

        runHook postBuild
      ''
    else
      ''
        runHook preBuild

        mkdir -p ./compiled

        ${LIGO} compile contract \
          ${library_flag} \
          --project-root . \
          ${if mainFile != "" then mainFile else (lib.importJSON "${src}/package.json").main} \
          -o ./compiled/${entrypoint}.tz
   
        runHook postBuild
      '';

  checkPhase = ''
    runHook preCheck
    
    make test ligo_compiler=${LIGO}
    
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
      
    mkdir -p $out/${pname}

    rm -rf .ligo

    cp -r ./ $out/${pname}/

    runHook postInstall
  '';

  strictDeps = true;
} // args // {

  name = "ligo-${pname}-${version}";

  nativeBuildInputs = [ ligo cacert ] ++ nativeBuildInputs;

  meta = (args.meta or { }) // { platforms = args.meta.platforms or ligo.meta.platforms; };
})
