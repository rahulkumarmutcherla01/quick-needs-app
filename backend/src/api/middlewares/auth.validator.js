import { z } from 'zod';

export const registerUserSchema = z.object({
  email: z
    .string({ required_error: 'Email is required' })
    .email('Invalid email address'),
  password: z
    .string({ required_error: 'Password is required' })
    .min(8, 'Password must be at least 8 characters long'),
  first_name: z.string({ required_error: 'First name is required' }).min(1, 'First name cannot be empty'),
  last_name: z.string().optional(),
  phone_number: z.string().optional(),
});

export const loginUserSchema = z.object({
  email: z
    .string({ required_error: 'Email is required' })
    .email('Invalid email address'),
  password: z
    .string({ required_error: 'Password is required' }),
});