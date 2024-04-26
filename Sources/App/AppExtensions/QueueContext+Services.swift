//import MongoKitten
//import Mailgun
//
//extension QueueContext {
//    var db: MongoDatabase {
//        application.mongoDB
////        application.mongoDB. = self.logger
//
////        application.databases
////            .database(logger: self.logger, on: self.eventLoop)!
//    }
//    
//    func mailgun() -> MailgunProvider {
//        application.mailgun().delegating(to: self.eventLoop)
//    }
//    
//    func mailgun(_ domain: MailgunDomain? = nil) -> MailgunProvider {
//        application.mailgun(domain).delegating(to: self.eventLoop)
//    }
//    
//    var appConfig: AppConfig {
//        application.config
//    }
//}
