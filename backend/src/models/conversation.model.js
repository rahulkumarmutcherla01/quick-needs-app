import { DataTypes, UUIDV4 } from 'sequelize';

export default (sequelize) => {
  return sequelize.define('conversations', {
    id: {
      type: DataTypes.UUID,
      defaultValue: UUIDV4,
      primaryKey: true,
    },
    family_id: {
      type: DataTypes.UUID,
      allowNull: false,
    },
    type: {
      type: DataTypes.STRING(50),
      allowNull: false,
      validate: {
        isIn: [['GROUP', 'DIRECT', 'CONFIDENTIAL_THREAD']],
      },
    },
    created_by_user_id: {
      type: DataTypes.UUID,
      allowNull: false,
    },
  }, { timestamps: false });
};
