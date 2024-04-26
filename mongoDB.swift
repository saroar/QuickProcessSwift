//mongo-init.js

print('Start #################################################################');

// Connect to the admin database
db = db.getSiblingDB('admin');


// Create or switch to the 'qvp_pro' database
use qvp_pro;
db = db.getSiblingDB('qvp_pro');

// Create a new user with readWrite role on 'qvp_pro'
// Ensure this user doesn't exist across other databases with different passwords
db.createUser({
  user: 'qvp_pro_admin',
  pwd: 'Lk=vHr_vqVx*#369',
  roles: [{ role: "readWrite", db: 'qvp_pro' }]
});


// If you need to create a user with access to another database, such as 'qvp_staging'
// Ensure the username is unique or manage roles for multi-database access
db = db.getSiblingDB('qvp_staging');
db.createUser({
  user: 'qvp_staging_admin',
  pwd: 'Prt=vHr_vqVx*#369',
  roles: [{ role: 'readWrite', db: 'qvp_staging' }],
});

print('END #################################################################');

MONGO_DB_PRODUCTION_URL="mongodb://qvp_pro_admin:Lk=vHr_vqVx*#369@mongo/qvp_pro?authSource=qvp_pro"

mongo -u qvp_pro_admin -p 'Lk=vHr_vqVx*#369' --authenticationDatabase qvp_pro --authenticationMechanism SCRAM-SHA-256

db.updateUser("qvp_pro_admin", {
    pwd: "Lk=vHr_vqVx*#369"
});

db.updateUser("qvp_staging_admin", {
    pwd: "Prt=vHr_vqVx*#369"
});

MONGO_DB_PRODUCTION_URL="mongodb://qvp_pro_admin:Lk=vHr_vqVx*#3@mongo/qvp_pro?authSource=qvp_pro"
mongodb://addame:Lk=vHr_vqVx*#369@mongo/qvp_pro?authSource=qvp_pro
MONGO_DB_PRODUCTION_URL="mongodb://qvp_pro_admin:Lk=vHr_vqVx*#369@mongo:27018/qvp_pro?authSource=qvp_pro"

# use for docker mongo -u qvp_pro_admin -p Lk=vHr_vqVx*#369@mongo --authenticationDatabase qvp_pro

MONGODB_ADMIN_USER = "qvp-root"
MONGODB_ADMIN_PASS = "qvp-password-04"
MONGODB_USER_PRODUCTION = "qvp"
MONGODB_DATABASE_PRODUCTION = "qvp_pro"
MONGODB_PASS_PRODUCTION: "Lk=vHr_vqVx*#3qvp"

