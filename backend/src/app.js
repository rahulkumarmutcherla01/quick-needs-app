import express from 'express';
import cors from 'cors';
import { errorHandler } from './api/middlewares/errorHandler.middleware.js';
import mainRouter from './api/routes/index.js';

const app = express();

// Global Middlewares
app.use(
  cors({
    origin: process.env.CORS_ORIGIN || '*',
    credentials: true,
  })
);
app.use(express.json({ limit: '16kb' }));
app.use(express.urlencoded({ extended: true, limit: '16kb' }));
app.use(express.static('public'));

// API Routes
app.use('/api/v1', mainRouter);

// Health check route
app.get('/', (req, res) => {
    res.status(200).json({
        status: "success",
        message: "QuickNeeds API is running!"
    });
});


// Global Error Handler
app.use(errorHandler);

export default app;
