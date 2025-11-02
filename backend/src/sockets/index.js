const initializeSocketIO = (io) => {
  io.on('connection', (socket) => {
    console.log(`🔌 New client connected: ${socket.id}`);

    // --- Room/List Events ---
    socket.on('joinFamilyRoom', (familyId) => {
      socket.join(`family-${familyId}`);
      console.log(`Socket ${socket.id} joined family room: ${familyId}`);
    });

    // Example: When an item is updated, broadcast to the family
    // This would be called from your controller after updating the DB
    // io.to(`family-${familyId}`).emit('itemUpdated', updatedItem);


    // --- Chat Events ---
    socket.on('joinConversation', (conversationId) => {
        socket.join(`conversation-${conversationId}`);
        console.log(`Socket ${socket.id} joined conversation: ${conversationId}`);
    });

    socket.on('sendMessage', (messageData) => {
        // The controller should save the message to the DB first,
        // then emit it back to the clients in the conversation room.
        io.to(`conversation-${messageData.conversation_id}`).emit('newMessage', messageData);
    });

    socket.on('typing', ({ conversationId, user }) => {
        socket.to(`conversation-${conversationId}`).emit('userTyping', user);
    });

    socket.on('stopTyping', ({ conversationId, user }) => {
        socket.to(`conversation-${conversationId}`).emit('userStoppedTyping', user);
    });


    socket.on('disconnect', () => {
      console.log(`🔥 Client disconnected: ${socket.id}`);
    });
  });
};

export default initializeSocketIO;
