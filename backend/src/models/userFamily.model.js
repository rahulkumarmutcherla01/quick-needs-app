import { DataTypes, UUIDV4 } from 'sequelize';

export default (sequelize) => {
  return sequelize.define('user_families', {
    id: {
      type: DataTypes.UUID,
      defaultValue: UUIDV4,
      primaryKey: true,
    },
    user_id: {
      type: DataTypes.UUID,
      allowNull: false,
      references: {
        model: 'users',
        key: 'id',
      },
    },
    family_id: {
      type: DataTypes.UUID,
      allowNull: false,
      references: {
        model: 'families',
        key: 'id',
      },
    },
    role: {
      type: DataTypes.STRING(50),
      allowNull: false,
      defaultValue: 'MEMBER',
      validate: {
        isIn: [['ADMIN', 'MEMBER']],
      },
    },
  }, { timestamps: true, createdAt: 'created_at', updatedAt: 'updated_at' });
};