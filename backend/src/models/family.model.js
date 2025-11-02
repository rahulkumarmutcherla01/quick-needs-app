import { DataTypes, UUIDV4 } from 'sequelize';

export default (sequelize) => {
  return sequelize.define('families', {
    id: {
      type: DataTypes.UUID,
      defaultValue: UUIDV4,
      primaryKey: true,
    },
    family_name: {
      type: DataTypes.STRING(255),
      allowNull: false,
    },
    family_surname: {
      type: DataTypes.STRING(100),
    },
    city: {
      type: DataTypes.STRING(100),
    },
    profile_picture_url: {
      type: DataTypes.TEXT,
    },
    family_code: {
      type: DataTypes.STRING(8),
      allowNull: false,
      unique: true,
    },
  }, {
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: 'updated_at',
  });
};
