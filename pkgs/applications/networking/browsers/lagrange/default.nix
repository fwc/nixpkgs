{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, nix-update-script
, cmake
, pkg-config
, fribidi
, harfbuzz
, libwebp
, mpg123
, SDL2
, the-foundation
, AppKit
, zip
, enableTUI ? false, ncurses, sealcurses
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lagrange";
  version = "1.16.3";

  src = fetchFromGitHub {
    owner = "skyjake";
    repo = "lagrange";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DpgCxnwkNP2mZNYygxFLMufEijYoLr4qor0DYCmbps8=";
  };

  patches = [
    # fixes `lagrange-tui`
    # remove when 1.64.4 comes out
    (fetchpatch {
      name = "tui-fixed-build-after-changes-to-text-init.patch";
      url = "https://github.com/skyjake/lagrange/commit/1c811221acc5b8eb47210fba90dc3a789a093e9b.patch";
      hash = "sha256-K0njCcEOOYAwo3FI8eBg53Qo8J/iNBqCn3WCKQb0cgk=";
    })
  ];

  nativeBuildInputs = [ cmake pkg-config zip ];

  buildInputs = [ the-foundation ]
    ++ lib.optionals (!enableTUI) [ fribidi harfbuzz libwebp mpg123 SDL2 ]
    ++ lib.optionals enableTUI [ ncurses sealcurses ]
    ++ lib.optional stdenv.isDarwin AppKit;

  cmakeFlags = lib.optionals enableTUI [
    "-DENABLE_TUI=YES"
    "-DENABLE_MPG123=NO"
    "-DENABLE_WEBP=NO"
    "-DENABLE_FRIBIDI=NO"
    "-DENABLE_HARFBUZZ=NO"
    "-DENABLE_POPUP_MENUS=NO"
    "-DENABLE_IDLE_SLEEP=NO"
    "-DCMAKE_INSTALL_DATADIR=${placeholder "out"}/share"
  ];

  installPhase = lib.optionalString (stdenv.isDarwin && !enableTUI) ''
    mkdir -p $out/Applications
    mv Lagrange.app $out/Applications
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "A Beautiful Gemini Client";
    homepage = "https://gmi.skyjake.fi/lagrange/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
})
