import { samlConfig } from '../config/saml'
import passport from 'passport'
import { Strategy as SamlStrategy } from 'passport-saml'

export class SamlAuthService {
  private static strategy: SamlStrategy

  public static configure() {
    this.strategy = new SamlStrategy(samlConfig, (profile, done) => {
      // Handle user profile from JumpCloud
      const userProfile = {
        id: profile.nameID,
        email: profile.nameID,
        firstName: profile.firstName || profile['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname'],
        lastName: profile.lastName || profile['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname'],
        displayName: profile.displayName,
        groups: profile.groups || profile['http://schemas.xmlsoap.org/claims/Group'],
      }

      return done(null, userProfile)
    })

    passport.use('saml', this.strategy)
    passport.serializeUser((user, done) => done(null, user))
    passport.deserializeUser((user, done) => done(null, user))
  }

  public static getStrategy(): SamlStrategy {
    return this.strategy
  }

  public static generateLoginUrl(): string {
    return this.strategy.generateServiceProviderMetadata().loginRequestUrl
  }

  public static generateMetadata(): string {
    return this.strategy.generateServiceProviderMetadata()
  }
}
