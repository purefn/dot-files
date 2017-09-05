self: super:

{
  awscli-saml-auth = super.callPackage ./awscli-saml-auth {};

  laas-cli = super.callPackage ./laas-cli {};

  stride = super.callPackage ./stride {};
}
