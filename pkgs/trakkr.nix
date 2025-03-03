{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  makeDesktopItem,
  nodejs_20,
  electron_32
}:
buildNpmPackage rec {
  pname = "Trakkr";
  version = "unstable-2025-03-03";
  nodejs = nodejs_20;

  src = fetchFromGitHub {
    owner = "skybreakdigital";
    repo = "${pname}-app";
    rev = "edb838bd839f06cfd045d9bc2a46ed4d2533b8e1";
    hash = "sha256-qlSnZnsMJq0sfpv8hGiJrIi1Mbiq8RhjjLgEEG03Ig0=";
  };
  
  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
  
  # patches = [
  #   ./turn_off_dev.patch
  # ];

  makeCacheWritable = true;

  npmDepsHash = "sha256-qKnyFw2wnSTywKQIFADEAF/D8HsENICjqbSI4yWsZAU=";

  # The prepack script runs the build script, which we'd rather do in the build phase.
  # npmPackFlags = [ "--ignore-scripts" ];

  # NODE_OPTIONS = "--openssl-legacy-provider";
  # npmBuildScript = "build-no-pack";

  buildPhase = ''
    runHook preBuild

    npm run build-no-pack

    # NOTE: Upstream explicitly opts to not build an ASAR as it would cause all
    # text to disappear in the app.
    npm exec electron-builder -- \
      --dir \
      -c.electronDist=${electron_32.dist} \
      -c.electronVersion=${electron_32.version} \
      --publish=never

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 ${src}/public/icon.png $out/share/icons/hicolor/256x256/apps/Trakkr.png
    install -Dm644 ${src}/public/favicon-16x16.png $out/share/icons/hicolor/16x16/apps/Trakkr.png
    install -Dm644 ${src}/public/favicon-32x32.png $out/share/icons/hicolor/32x32/apps/Trakkr.png

    mkdir -p "$out/share/lib/Trakkr"
    cp -r ./dist/*-unpacked/{locales,resources{,.pak}} "$out/share/lib/Trakkr"
    cp ./dist/index.html "$out/share/lib/Trakkr"

    makeWrapper '${electron_32}/bin/electron' "$out/bin/Trakkr" \
      --add-flags "$out/share/lib/Trakkr/resources/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --set ELECTRON_FORCE_IS_PACKAGED=1 \
      --inherit-argv0

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Trakkr";
      exec = "Trakkr";
      icon = "Trakkr";
      desktopName = "Trakkr";
      categories = [
        "Game"
        "Utility"
      ];
      comment = meta.description;
      terminal = false;
    })
  ];

  meta = {
    broken = true;
    description = "Trakkr is specifically designed to assist Elite Dangerous missions, offering tailored support to enhance the efficiency and management of their operations.";
    homepage = "https://github.com/skybreakdigital/trakkr-app";
    mainProgram = "Trakkr";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ jiriks74 ];
  };
}
