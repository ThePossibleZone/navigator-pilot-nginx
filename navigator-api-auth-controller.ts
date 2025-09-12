import { HttpContextContract } from '@ioc:Adonis/Core/HttpContext'
import { SamlAuthService } from 'App/Services/SamlStrategy'
import User from 'App/Models/User'

export default class AuthController {
  public async login({ response }: HttpContextContract) {
    const loginUrl = SamlAuthService.generateLoginUrl()
    return response.redirect(loginUrl)
  }

  public async jumpcloudCallback({ request, response, auth }: HttpContextContract) {
    try {
      const samlResponse = request.body()

      // Verify SAML response
      const profile = await new Promise((resolve, reject) => {
        SamlAuthService.getStrategy()._verify(
          samlResponse.SAMLResponse,
          (err, profile) => {
            if (err) reject(err)
            else resolve(profile)
          }
        )
      })

      // Find or create user
      let user = await User.findBy('email', profile.email)

      if (!user) {
        user = await User.create({
          email: profile.email,
          firstName: profile.firstName,
          lastName: profile.lastName,
          displayName: profile.displayName,
          provider: 'jumpcloud',
          providerId: profile.id,
          isActive: true,
          emailVerified: true, // Trust JumpCloud verification
        })

        // Assign default role
        await user.related('roles').attach([1]) // Default student role
      }

      // Generate JWT token
      const token = await auth.use('api').generate(user, {
        expiresIn: '24hours'
      })

      // Redirect to frontend with token
      const redirectUrl = `${process.env.FRONTEND_URL}/auth/callback?token=${token.token}&refreshToken=${token.refreshToken}`

      return response.redirect(redirectUrl)

    } catch (error) {
      console.error('SAML authentication error:', error)
      return response.status(500).json({ error: 'Authentication failed' })
    }
  }

  public async logout({ auth, response }: HttpContextContract) {
    await auth.use('api').revoke()
    return response.json({ message: 'Logged out successfully' })
  }

  public async me({ auth }: HttpContextContract) {
    return auth.user
  }

  public async metadata({ response }: HttpContextContract) {
    const metadata = SamlAuthService.generateMetadata()
    response.header('Content-Type', 'application/xml')
    return response.send(metadata)
  }
}
