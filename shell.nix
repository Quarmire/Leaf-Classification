let
  pkgs = import <nixpkgs> {};
  python = pkgs.python313;
  pythonPackages = python.pkgs;
  lib-path = with pkgs; lib.makeLibraryPath [
    stdenv.cc.cc
  ];
in with pkgs; mkShell {
  packages = [
    pythonPackages.pandas
    pythonPackages.numpy
    pythonPackages.matplotlib
    pythonPackages.scikit-learn
    pythonPackages.scikit-image
    pythonPackages.scipy
    pythonPackages.distutils
    pythonPackages.seaborn
    pythonPackages.torch
    pythonPackages.torchvision
    pythonPackages.requests
    pythonPackages.jupyter-core
    pythonPackages.notebook
    pythonPackages.opencv4
  ];

  buildInputs = [
    git
  ];

  shellHook = ''
    SOURCE_DATE_EPOCH=$(date +%s)
    export "LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${lib-path}"
    VENV=.venv

    if test ! -d $VENV; then
      python3.13 -m venv $VENV
    fi
    source ./$VENV/bin/activate
    export PYTHONPATH=`pwd`/$VENV/${python.sitePackages}/:$PYTHONPATH
  '';
}
