# API Documentation

This document provides documentation for all the available API routes in the QuickNeeds application.

## Admin API

### POST /api/admin/login

*   **Description:** Logs in a super admin.
*   **Request Body:**
    ```json
    {
      "username": "string",
      "password": "string"
    }
    ```
*   **Response:**
    ```json
    {
      "token": "string"
    }
    ```

### GET /api/admin/advertisements

*   **Description:** Gets all advertisements.
*   **Request Body:** None
*   **Response:**
    ```json
    [
      {
        "id": "uuid",
        "title": "string",
        "image_url": "string",
        "target_url": "string",
        "display_locations": [
          "string"
        ],
        "is_active": "boolean"
      }
    ]
    ```

### POST /api/admin/advertisements

*   **Description:** Creates a new advertisement.
*   **Request Body:**
    ```json
    {
      "title": "string",
      "image_url": "string",
      "target_url": "string",
      "display_locations": [
        "string"
      ],
      "is_active": "boolean"
    }
    ```
*   **Response:**
    ```json
    {
      "id": "uuid",
      "title": "string",
      "image_url": "string",
      "target_url": "string",
      "display_locations": [
        "string"
      ],
      "is_active": "boolean"
    }
    ```

### PUT /api/admin/advertisements/:adId

*   **Description:** Updates an advertisement.
*   **Request Body:**
    ```json
    {
      "title": "string",
      "image_url": "string",
      "target_url": "string",
      "display_locations": [
        "string"
      ],
      "is_active": "boolean"
    }
    ```
*   **Response:**
    ```json
    {
      "id": "uuid",
      "title": "string",
      "image_url": "string",
      "target_url": "string",
      "display_locations": [
        "string"
      ],
      "is_active": "boolean"
    }
    ```

### DELETE /api/admin/advertisements/:adId

*   **Description:** Deletes an advertisement.
*   **Request Body:** None
*   **Response:**
    ```json
    {
      "message": "Advertisement deleted successfully"
    }
    ```

## Auth API

### POST /api/auth/register

*   **Description:** Registers a new user.
*   **Request Body:**
    ```json
    {
      "email": "string (required, must be a valid email)",
      "password": "string (required, min 8 characters)",
      "first_name": "string (required)",
      "last_name": "string (optional)",
      "phone_number": "string (optional)"
    }
    ```
*   **Response:**
    ```json
    {
      "id": "uuid",
      "email": "string",
      "first_name": "string",
      "last_name": "string",
      "phone_number": "string",
      "created_at": "datetime",
      "updated_at": "datetime"
    }
    ```

### POST /api/auth/login

*   **Description:** Logs in a user.
*   **Request Body:**
    ```json
    {
      "email": "string (required, must be a valid email)",
      "password": "string (required)"
    }
    ```
*   **Response:**
    ```json
    {
      "user": {
        "id": "uuid",
        "email": "string",
        "first_name": "string",
        "last_name": "string",
        "phone_number": "string",
        "created_at": "datetime",
        "updated_at": "datetime"
      },
      "accessToken": "string (jwt)"
    }
    ```

### GET /api/auth/me

*   **Description:** Gets the current user's information.
*   **Request Body:** None
*   **Response:**
    ```json
    {
      "id": "uuid",
      "email": "string",
      "first_name": "string",
      "last_name": "string",
      "phone_number": "string",
      "created_at": "datetime",
      "updated_at": "datetime"
    }
    ```

## Chat API

### GET /api/chat/conversations

*   **Description:** Gets all conversations for the current user.
*   **Request Body:** None
*   **Response:**
    ```json
    [
      {
        "id": "uuid",
        "family_id": "uuid",
        "type": "string (GROUP, DIRECT, CONFIDENTIAL_THREAD)",
        "created_by_user_id": "uuid"
      }
    ]
    ```

### POST /api/chat/conversations

*   **Description:** Starts a new conversation.
*   **Request Body:**
    ```json
    {
      "family_id": "uuid",
      "type": "string (GROUP, DIRECT, CONFIDENTIAL_THREAD)",
      "participant_ids": ["uuid"]
    }
    ```
*   **Response:**
    ```json
    {
      "id": "uuid",
      "family_id": "uuid",
      "type": "string (GROUP, DIRECT, CONFIDENTIAL_THREAD)",
      "created_by_user_id": "uuid"
    }
    ```

### GET /api/chat/conversations/:conversationId/messages

*   **Description:** Gets all messages for a specific conversation.
*   **Request Body:** None
*   **Response:**
    ```json
    [
      {
        "id": "uuid",
        "conversation_id": "uuid",
        "sender_id": "uuid",
        "content_type": "string",
        "content": "string",
        "created_at": "datetime"
      }
    ]
    ```

### POST /api/chat/conversations/:conversationId/messages

*   **Description:** Sends a message in a conversation.
*   **Request Body:**
    ```json
    {
      "content_type": "string",
      "content": "string"
    }
    ```
*   **Response:**
    ```json
    {
      "id": "uuid",
      "conversation_id": "uuid",
      "sender_id": "uuid",
      "content_type": "string",
      "content": "string",
      "created_at": "datetime"
    }
    ```

## Family API

### POST /api/family/create

*   **Description:** Creates a new family.
*   **Request Body:**
    ```json
    {
      "family_name": "string (required)",
      "family_surname": "string (optional)",
      "city": "string (optional)"
    }
    ```
*   **Response:**
    ```json
    {
      "id": "uuid",
      "family_name": "string",
      "family_surname": "string",
      "city": "string",
      "family_code": "string",
      "created_at": "datetime",
      "updated_at": "datetime"
    }
    ```

### POST /api/family/join

*   **Description:** Joins an existing family.
*   **Request Body:**
    ```json
    {
      "family_code": "string (required, 8 characters)"
    }
    ```
*   **Response:**
    ```json
    {
      "familyId": "uuid"
    }
    ```

### GET /api/family/:familyId

*   **Description:** Gets the details of a specific family.
*   **Request Body:** None
*   **Response:**
    ```json
    {
      "id": "uuid",
      "family_name": "string",
      "family_surname": "string",
      "city": "string",
      "family_code": "string",
      "created_at": "datetime",
      "updated_at": "datetime",
      "members": [
        {
          "id": "uuid",
          "first_name": "string",
          "last_name": "string",
          "email": "string"
        }
      ]
    }
    ```

## Health API

### POST /api/health/medications

*   **Description:** Adds a new medication for a family member.
*   **Request Body:**
    ```json
    {
      "user_id": "uuid",
      "medicine_name": "string",
      "dosage": "string",
      "instructions": "string"
    }
    ```
*   **Response:**
    ```json
    {
      "id": "uuid",
      "family_id": "uuid",
      "user_id": "uuid",
      "medicine_name": "string",
      "dosage": "string",
      "instructions": "string"
    }
    ```

### GET /api/health/medications

*   **Description:** Gets all medications for the family.
*   **Request Body:** None
*   **Response:**
    ```json
    [
      {
        "id": "uuid",
        "family_id": "uuid",
        "user_id": "uuid",
        "medicine_name": "string",
        "dosage": "string",
        "instructions": "string"
      }
    ]
    ```

### POST /api/health/medications/:medicationId/schedule

*   **Description:** Adds a new medication schedule.
*   **Request Body:**
    ```json
    {
      "times_of_day": ["string (HH:MM:SS)"],
      "start_date": "string (YYYY-MM-DD)",
      "end_date": "string (YYYY-MM-DD)"
    }
    ```
*   **Response:**
    ```json
    {
      "id": "uuid",
      "medication_id": "uuid",
      "times_of_day": ["string (HH:MM:SS)"],
      "start_date": "string (YYYY-MM-DD)",
      "end_date": "string (YYYY-MM-DD)"
    }
    ```

### POST /api/health/schedules/:scheduleId/log

*   **Description:** Logs a medication dose.
*   **Request Body:**
    ```json
    {
      "user_id": "uuid"
    }
    ```
*   **Response:**
    ```json
    {
      "id": "uuid",
      "medication_schedule_id": "uuid",
      "user_id": "uuid",
      "taken_at": "datetime"
    }
    ```

### GET /api/health/schedules/:scheduleId/logs

*   **Description:** Gets all medication logs for a schedule.
*   **Request Body:** None
*   **Response:**
    ```json
    [
      {
        "id": "uuid",
        "medication_schedule_id": "uuid",
        "user_id": "uuid",
        "taken_at": "datetime"
      }
    ]
    ```

## Item API

### POST /api/items/rooms

*   **Description:** Adds a new room.
*   **Request Body:**
    ```json
    {
      "room_name": "string",
      "room_icon": "string",
      "family_id": "uuid"
    }
    ```
*   **Response:**
    ```json
    {
      "id": "uuid",
      "family_id": "uuid",
      "room_name": "string",
      "room_icon": "string",
      "is_custom": "boolean",
      "created_at": "datetime"
    }
    ```

### GET /api/items/rooms

*   **Description:** Gets all rooms for the family.
*   **Request Body:** None
*   **Query Params:**
    *   `family_id`: "uuid" (required)
*   **Response:**
    ```json
    [
      {
        "id": "uuid",
        "family_id": "uuid",
        "room_name": "string",
        "room_icon": "string",
        "is_custom": "boolean",
        "created_at": "datetime"
      }
    ]
    ```

### POST /api/items/rooms/:roomId/items

*   **Description:** Adds a new item to a room.
*   **Request Body:**
    ```json
    {
      "item_name": "string",
      "quantity": "integer",
      "cost": "decimal"
    }
    ```
*   **Response:**
    ```json
    {
      "id": "uuid",
      "room_id": "uuid",
      "item_name": "string",
      "status": "string (NEEDED, IN_CART, PURCHASED)",
      "added_by_user_id": "uuid",
      "purchased_by_user_id": "uuid",
      "quantity": "integer",
      "cost": "decimal",
      "last_purchased_at": "datetime",
      "created_at": "datetime",
      "updated_at": "datetime"
    }
    ```

### GET /api/items/rooms/:roomId/items

*   **Description:** Gets all items in a room.
*   **Request Body:** None
*   **Response:**
    ```json
    [
      {
        "id": "uuid",
        "room_id": "uuid",
        "item_name": "string",
        "status": "string (NEEDED, IN_CART, PURCHASED)",
        "added_by_user_id": "uuid",
        "purchased_by_user_id": "uuid",
        "quantity": "integer",
        "cost": "decimal",
        "last_purchased_at": "datetime",
        "created_at": "datetime",
        "updated_at": "datetime"
      }
    ]
    ```

### PUT /api/items/:itemId

*   **Description:** Updates an item.
*   **Request Body:**
    ```json
    {
      "item_name": "string",
      "status": "string (NEEDED, IN_CART, PURCHASED)",
      "quantity": "integer",
      "cost": "decimal"
    }
    ```
*   **Response:**
    ```json
    {
      "id": "uuid",
      "room_id": "uuid",
      "item_name": "string",
      "status": "string (NEEDED, IN_CART, PURCHASED)",
      "added_by_user_id": "uuid",
      "purchased_by_user_id": "uuid",
      "quantity": "integer",
      "cost": "decimal",
      "last_purchased_at": "datetime",
      "created_at": "datetime",
      "updated_at": "datetime"
    }
    ```
