with import ./pin.nix { };
mkShell rec {
  buildInputs = [ elmPackages.elm nodePackages.uglify-js build ];

  build = writeShellScriptBin "build" ''
    set -e
    elm make --optimize --output=elm.js src/Main.elm
    uglifyjs elm.js --compress "pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe" | uglifyjs --mangle > elm.min.js
    rm elm.js
  '';
}
