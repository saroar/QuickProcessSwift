import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.views.use(.leaf)


    // register routes
    try routes(app)
}

//purdonmiriam1983@outlook.com:268purdon
//shaniceamano76@outlook.com:vNeigEdm2Kr
//schickrosina761976@outlook.com:84SYYuNb
//trudelalease8373@outlook.com:1162Alease
//mertiedoster332@outlook.com:99c3pd8d
//zinrivkin7070@outlook.com:i2Nm8aTE
//magdalenjacklin755@outlook.com:6disCRepancy
//ryleekoerb1978@outlook.com:q7iwlV921mi
//muthermerrilee972@outlook.com:DId1LumI03
//meldak593@outlook.com:i0qWpbIqh
//steelybrittany744@outlook.com:wIT2H9hOld
//verdiedaws8@outlook.com:416eotoli416
//nylzadie948@outlook.com:3948Zadie
//leonardafredrick@outlook.com:209ruyyyceu
//sacconetemperance9@outlook.com:SACCONE1971
