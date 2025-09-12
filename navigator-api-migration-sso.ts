import BaseSchema from '@ioc:Adonis/Lucid/Schema'

export default class AddSsoFieldsToUsers extends BaseSchema {
  protected tableName = 'users'

  public async up() {
    this.schema.alterTable(this.tableName, (table) => {
      table.string('provider').defaultTo('local')
      table.string('provider_id').nullable()
      table.boolean('email_verified').defaultTo(false)
      table.timestamp('last_login_at').nullable()
      table.jsonb('sso_profile').nullable()
    })
  }

  public async down() {
    this.schema.alterTable(this.tableName, (table) => {
      table.dropColumn('provider')
      table.dropColumn('provider_id')
      table.dropColumn('email_verified')
      table.dropColumn('last_login_at')
      table.dropColumn('sso_profile')
    })
  }
}
