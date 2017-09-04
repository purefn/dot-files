self: super:

{
  stride = super.callPackage ./stride {};

  laas-cli = super.callPackage ./laas-cli {};
}
