import { Sequelize } from 'sequelize';
import config from './index.js';

// const sequelize = new Sequelize(config.db.name, config.db.user, config.db.password, {
//   host: config.db.host,
//   port: config.db.port,
//   dialect: 'postgres',
//   logging: false, // Set to console.log to see SQL queries
//   pool: {
//     max: 5,
//     min: 0,
//     acquire: 30000,
//     idle: 10000,
//   },
// });
const sequelize = new Sequelize(
  process.env.DB_NAME,
  process.env.DB_USER,
  process.env.DB_PASSWORD,
  {
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    dialect: 'postgres',
    dialectOptions: {
      ssl: {
        require: true,          // Enforce SSL
        rejectUnauthorized: false, // Accept self-signed certs if needed (use with caution)
      },
    },
  }
);
export default sequelize;
