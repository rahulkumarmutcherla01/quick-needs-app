import dotenv from 'dotenv';
import { createServer } from 'http';
import { Server } from 'socket.io';
import app from './app.js';
import { sequelize } from './models/index.js';
import initializeSocketIO from './sockets/index.js';
import { startCronJobs } from './jobs.js';

dotenv.config();

const PORT = process.env.PORT || 8000;
// const PORT = '0.0.0.0';

const httpServer = createServer(app);
const io = new Server(httpServer, {
  cors: {
    origin: process.env.CORS_ORIGIN || '*',
    methods: ['GET', 'POST'],
  },
});

// Initialize Socket.IO
initializeSocketIO(io);

// Connect to the database and start the server
sequelize
  .sync({ alter: true }) // Use { force: true } in dev to drop and recreate tables
  .then(() => {
    console.log('✅ Database connected and models synchronized.');
    httpServer.listen(PORT,"0.0.0.0", () => {
      console.log(`🚀 Server is running at http://localhost:${PORT}`);
      // Start scheduled jobs
      startCronJobs();
    });
  })
  .catch((err) => {
    console.error('❌ Unable to connect to the database:', err);
  });
