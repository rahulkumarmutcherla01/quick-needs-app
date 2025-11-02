import { DataTypes, UUIDV4 } from 'sequelize';

export default (sequelize) => {
  return sequelize.define('rooms', {
    id: {
      type: DataTypes.UUID,
      defaultValue: UUIDV4,
      primaryKey: true,
    },
    family_id: {
      type: DataTypes.UUID,
      allowNull: false,
    },
    room_name: {
      type: DataTypes.STRING(100),
      allowNull: false,
    },
    room_icon: {
      type: DataTypes.STRING(50),
    },
    is_custom: {
      type: DataTypes.BOOLEAN,
      defaultValue: false,
    },
  }, {
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: false, // No updated_at in schema
  });
};
