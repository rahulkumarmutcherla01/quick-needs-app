import { DataTypes, UUIDV4 } from 'sequelize';

export default (sequelize) => {
  const Medication = sequelize.define('medications', {
    id: { type: DataTypes.UUID, defaultValue: UUIDV4, primaryKey: true },
    family_id: { type: DataTypes.UUID, allowNull: false },
    user_id: { type: DataTypes.UUID, allowNull: false },
    medicine_name: { type: DataTypes.STRING(255), allowNull: false },
    dosage: { type: DataTypes.STRING(100) },
    instructions: { type: DataTypes.TEXT },
  }, { timestamps: false });

  const MedicationSchedule = sequelize.define('medication_schedules', {
    id: { type: DataTypes.UUID, defaultValue: UUIDV4, primaryKey: true },
    medication_id: { type: DataTypes.UUID, allowNull: false },
    times_of_day: { type: DataTypes.ARRAY(DataTypes.TIME), allowNull: false },
    start_date: { type: DataTypes.DATEONLY, allowNull: false },
    end_date: { type: DataTypes.DATEONLY },
  }, { timestamps: false });

  const MedicationInventory = sequelize.define('medication_inventory', {
    id: { type: DataTypes.UUID, defaultValue: UUIDV4, primaryKey: true },
    medication_id: { type: DataTypes.UUID, allowNull: false, unique: true },
    initial_quantity: { type: DataTypes.INTEGER, allowNull: false },
    current_quantity: { type: DataTypes.INTEGER, allowNull: false },
    refill_alert_threshold: { type: DataTypes.INTEGER, defaultValue: 5 },
  }, {
    timestamps: true,
    createdAt: false,
    updatedAt: 'updated_at',
  });

  const MedicationLog = sequelize.define('medication_logs', {
    id: { type: DataTypes.UUID, defaultValue: UUIDV4, primaryKey: true },
    medication_schedule_id: { type: DataTypes.UUID, allowNull: false },
    user_id: { type: DataTypes.UUID, allowNull: false },
    taken_at: { type: DataTypes.DATE, allowNull: false, defaultValue: DataTypes.NOW },
  }, { timestamps: false });

  return { Medication, MedicationSchedule, MedicationInventory, MedicationLog };
};
