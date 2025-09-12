import Env from '@ioc:Adonis/Core/Env'

export const samlConfig = {
  entryPoint: Env.get('JUMPCLOUD_SSO_URL'),
  issuer: Env.get('JUMPCLOUD_ENTITY_ID'),
  callbackUrl: `${Env.get('APP_URL')}/auth/jumpcloud/callback`,
  cert: Env.get('JUMPCLOUD_CERTIFICATE'),
  privateKey: Env.get('JUMPCLOUD_PRIVATE_KEY'),
  decryptionPvk: Env.get('JUMPCLOUD_PRIVATE_KEY'),
  signatureAlgorithm: 'sha256',
  digestAlgorithm: 'sha256',
  identifierFormat: 'urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress',
  acceptedClockSkewMs: 5000,
  attributeConsumingServiceIndex: null,
  disableRequestedAuthnContext: true,
  authnContext: 'urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport',
  forceAuthn: false,
  skipRequestCompression: false,
  disableRequestAcsUrl: false,
  wantAssertionsSigned: true,
  wantAuthnResponseSigned: false,
  wantLogoutRequestSigned: false,
  wantLogoutResponseSigned: false,
}
