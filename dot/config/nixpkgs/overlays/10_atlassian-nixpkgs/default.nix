self: super:

{
  awscli-saml-auth = super.callPackage ./awscli-saml-auth {};

  laas-cli = super.callPackage ./laas-cli {};

  micros-cli = super.callPackage ./micros-cli {};

  stride = super.callPackage ./stride {};
}
