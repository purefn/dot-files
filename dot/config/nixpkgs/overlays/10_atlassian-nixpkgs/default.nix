self: super:

{
  cloudtoken = super.python3Packages.callPackage ./cloudtoken {};

  laas-cli = super.callPackage ./laas-cli {};

  micros-cli = super.callPackage ./micros-cli {};

  stride = super.callPackage ./stride {};
}
