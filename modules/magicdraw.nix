{den, ...}: {
  den.aspects.magicdraw = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [ 
        (stdenv.mkDerivation {
          name = "magicdraw";
          buildInputs = [ unzip ];
          nativeBuildInputs = [ openjdk8 ];
          src = /home/jcranney/MagicDraw_190_sp2_no_install.zip;
          unpackPhase = ''
            mkdir tmp
            unzip $src -d tmp
          '';
          installPhase = ''
            cp -r tmp $out
            rm $out/bin/submit_issue
            echo "JAVA_HOME=${pkgs.openjdk8}" >> $out/bin/magicdraw.properties
          '';
        })
      ];
    };
  };
}