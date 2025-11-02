import sequelize from '../config/db.config.js';
import defineUser from './user.model.js';
import defineFamily from './family.model.js';
import defineRoom from './room.model.js';
import defineUserFamily from './userFamily.model.js';
import defineItem from './item.model.js';
import defineMedication from './medication.model.js';
import defineConversation from './conversation.model.js';
import defineMessage from './message.model.js';
import defineSuperAdmin from './superAdmin.model.js';
import defineAdvertisement from './advertisement.model.js';

const db = {};

db.sequelize = sequelize;

// Define all models
db.User = defineUser(sequelize);
db.Family = defineFamily(sequelize);
db.UserFamily = defineUserFamily(sequelize);
db.Room = defineRoom(sequelize);
db.Item = defineItem(sequelize);
db.Medication = defineMedication(sequelize);
db.Conversation = defineConversation(sequelize);
db.Message = defineMessage(sequelize);
db.SuperAdmin = defineSuperAdmin(sequelize);
db.Advertisement = defineAdvertisement(sequelize);

// --- Define Relationships ---

// User <-> Family (Many-to-Many through UserFamily)
db.User.belongsToMany(db.Family, { through: db.UserFamily, foreignKey: 'user_id', otherKey: 'family_id' });
db.Family.belongsToMany(db.User, { through: db.UserFamily, foreignKey: 'family_id', otherKey: 'user_id', as: 'members' });
db.UserFamily.belongsTo(db.User, { foreignKey: 'user_id' });
db.UserFamily.belongsTo(db.Family, { foreignKey: 'family_id' });

// Family -> Room (One-to-Many)
db.Family.hasMany(db.Room, { foreignKey: 'family_id', onDelete: 'CASCADE' });
db.Room.belongsTo(db.Family, { foreignKey: 'family_id' });

// Room -> Item (One-to-Many)
db.Room.hasMany(db.Item, { foreignKey: 'room_id', onDelete: 'CASCADE' });
db.Item.belongsTo(db.Room, { foreignKey: 'room_id' });

// User -> Item (One-to-Many for added_by and purchased_by)
db.User.hasMany(db.Item, { foreignKey: 'added_by_user_id', as: 'addedItems' });
db.Item.belongsTo(db.User, { foreignKey: 'added_by_user_id', as: 'addedBy' });
db.User.hasMany(db.Item, { foreignKey: 'purchased_by_user_id', as: 'purchasedItems' });
db.Item.belongsTo(db.User, { foreignKey: 'purchased_by_user_id', as: 'purchasedBy' });

// Health Hub Relationships
const { Medication, MedicationSchedule, MedicationInventory, MedicationLog } = defineMedication(sequelize);
db.Medication = Medication;
db.MedicationSchedule = MedicationSchedule;
db.MedicationInventory = MedicationInventory;
db.MedicationLog = MedicationLog;

db.Family.hasMany(db.Medication, { foreignKey: 'family_id', onDelete: 'CASCADE' });
db.Medication.belongsTo(db.Family, { foreignKey: 'family_id' });
db.User.hasMany(db.Medication, { foreignKey: 'user_id', onDelete: 'CASCADE' });
db.Medication.belongsTo(db.User, { foreignKey: 'user_id' });

db.Medication.hasMany(db.MedicationSchedule, { foreignKey: 'medication_id', onDelete: 'CASCADE' });
db.MedicationSchedule.belongsTo(db.Medication, { foreignKey: 'medication_id' });

db.Medication.hasOne(db.MedicationInventory, { foreignKey: 'medication_id', onDelete: 'CASCADE' });
db.MedicationInventory.belongsTo(db.Medication, { foreignKey: 'medication_id' });

db.MedicationSchedule.hasMany(db.MedicationLog, { foreignKey: 'medication_schedule_id', onDelete: 'CASCADE' });
db.MedicationLog.belongsTo(db.MedicationSchedule, { foreignKey: 'medication_schedule_id' });
db.User.hasMany(db.MedicationLog, { foreignKey: 'user_id' });
db.MedicationLog.belongsTo(db.User, { foreignKey: 'user_id' });

// Chat Relationships
db.Family.hasMany(db.Conversation, { foreignKey: 'family_id', onDelete: 'CASCADE' });
db.Conversation.belongsTo(db.Family, { foreignKey: 'family_id' });
db.User.hasMany(db.Conversation, { foreignKey: 'created_by_user_id' });
db.Conversation.belongsTo(db.User, { foreignKey: 'created_by_user_id', as: 'creator' });

const ConversationParticipant = sequelize.define('conversation_participants', {}, { timestamps: false });
db.User.belongsToMany(db.Conversation, { through: ConversationParticipant, foreignKey: 'user_id' });
db.Conversation.belongsToMany(db.User, { through: ConversationParticipant, foreignKey: 'conversation_id' });
db.ConversationParticipant = ConversationParticipant;

db.Conversation.hasMany(db.Message, { foreignKey: 'conversation_id', onDelete: 'CASCADE' });
db.Message.belongsTo(db.Conversation, { foreignKey: 'conversation_id' });
db.User.hasMany(db.Message, { foreignKey: 'sender_id' });
db.Message.belongsTo(db.User, { foreignKey: 'sender_id', as: 'sender' });

const MessageReadReceipt = sequelize.define('message_read_receipts', {
    read_at: { type: sequelize.Sequelize.DATE, allowNull: false, defaultValue: sequelize.Sequelize.NOW }
}, { timestamps: false });
db.Message.belongsToMany(db.User, { through: MessageReadReceipt, foreignKey: 'message_id', as: 'readBy' });
db.User.belongsToMany(db.Message, { through: MessageReadReceipt, foreignKey: 'user_id', as: 'readMessages' });
db.MessageReadReceipt = MessageReadReceipt;


export const {
    User, Family, Room, Item, Conversation, Message,
    SuperAdmin, Advertisement, UserFamily
} = db;

export {
    sequelize, Medication, MedicationSchedule, MedicationInventory, MedicationLog, ConversationParticipant, MessageReadReceipt
};
