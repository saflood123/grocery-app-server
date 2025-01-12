import Vapor
import Fluent
import FluentPostgresDriver
import JWT


// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    // register routes
    
    if let databaseURL = Environment.get("DATABASE_URL") {
        var tlsConfig: TLSConfiguration = .makeClientConfiguration()
        tlsConfig.certificateVerification = .none
        let nioSSLContext = try NIOSSLContext(configuration: tlsConfig)

        var postgresConfig = try SQLPostgresConfiguration(url: databaseURL)
        postgresConfig.coreConfiguration.tls = .require(nioSSLContext)

        app.databases.use(.postgres(configuration: postgresConfig), as: .psql)
    } else {
        app.databases.use(.postgres(hostname: Environment.get("DB_HOST_NAME") ?? "localhost",  username: Environment.get("DB_USER_NAME") ?? "postgres", password: Environment.get("DB_PASSWORD") ?? "", database: Environment.get("DB_NAME") ?? "grocerydb"), as: .psql)
    }
    
//    app.databases.use(.postgres(hostname: Environment.get("DB_HOST_NAME") ?? "localhost",  username: Environment.get("DB_USER_NAME") ?? "postgres", password: Environment.get("DB_PASSWORD") ?? "", database: Environment.get("DB_NAME") ?? "grocerydb"), as: .psql)
    
//  app.databases.use(.postgres(hostname: "localhost",  username:  "postgres", password:  "", database: "grocerydb"), as: .psql)
    
//    try app.databases.use(.postgres(configuration: SQLPostgresConfiguration(hostname: "localhost", username: "postgres", password: "", database: "grocerydb", tls: .prefer(try .init(configuration: .clientDefault)))), as: .psql)
    
    //register migrations
    app.migrations.add(CreateUsersTableMigration())
    app.migrations.add(CreateGroceryCategoryTableMigration())
    app.migrations.add(CreateGroceryItemTableMigration())
//    app.migrations.add(CreateGroceryItemTableMigration())
    app.migrations.add(CreateExerciseTypeTableMigration())
    
    //register controllers
    try app.register(collection: UserController())
    try app.register(collection: GroceryController())
    
    app.jwt.signers.use(.hs256(key: Environment.get("JWT_SIGN_KEY") ?? "SECRETKEY"))
    
    
    //register routes
    try routes(app)
}
