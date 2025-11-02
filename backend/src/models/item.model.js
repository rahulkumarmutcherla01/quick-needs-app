import { DataTypes, UUIDV4 } from 'sequelize';

export default (sequelize) => {
  return sequelize.define('items', {
    id: {
      type: DataTypes.UUID,
      defaultValue: UUIDV4,
      primaryKey: true,
    },
    room_id: {
      type: DataTypes.UUID,
      allowNull: false,
    },
    item_name: {
      type: DataTypes.STRING(255),
      allowNull: false,
    },
    status: {
      type: DataTypes.STRING(50),
      allowNull: false,
      defaultValue: 'NEEDED',
      validate: {
        isIn: [['NEEDED', 'IN_CART', 'PURCHASED']],
      },
    },
    added_by_user_id: {
      type: DataTypes.UUID,
      allowNull: false,
    },
    purchased_by_user_id: {
      type: DataTypes.UUID,
    },
    quantity: {
      type: DataTypes.INTEGER,
      defaultValue: 1,
    },
    cost: {
      type: DataTypes.DECIMAL(10, 2),
      defaultValue: 0.0,
    },
    last_purchased_at: {
      type: DataTypes.DATE,
    },
  }, {
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: 'updated_at',
  });
};
