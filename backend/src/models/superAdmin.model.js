import { DataTypes, UUIDV4 } from 'sequelize';
import bcrypt from 'bcryptjs';

export default (sequelize) => {
  const SuperAdmin = sequelize.define('super_admins', {
    id: {
      type: DataTypes.UUID,
      defaultValue: UUIDV4,
      primaryKey: true,
    },
    username: {
      type: DataTypes.STRING(100),
      allowNull: false,
      unique: true,
    },
    password_hash: {
      type: DataTypes.TEXT,
      allowNull: false,
    },
  }, {
    timestamps: false,
    hooks: {
      beforeCreate: async (admin) => {
        if (admin.password_hash) {
          admin.password_hash = await bcrypt.hash(admin.password_hash, 10);
        }
      },
    },
  });

  SuperAdmin.prototype.isPasswordCorrect = async function(password) {
    return await bcrypt.compare(password, this.password_hash);
  };

  return SuperAdmin;
};
