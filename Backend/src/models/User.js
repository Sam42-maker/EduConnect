const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const User = sequelize.define('User', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true,
  },
  fullName: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  email: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true,
    validate: {
      isEmail: true,
    }
  },
  password: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  phone: {
    type: DataTypes.STRING,
    defaultValue: '',
  },
  role: {
    type: DataTypes.ENUM('Student', 'Mentor'),
    defaultValue: 'Student',
  },
  
  // M2FA / OTP Fields
  isVerified: {
    type: DataTypes.BOOLEAN,
    defaultValue: false,
  },
  otp: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  otpExpires: {
    type: DataTypes.DATE,
    allowNull: true,
  },

  // Phase 2: Profile Wizard Fields
  university: {
    type: DataTypes.STRING,
    defaultValue: '',
  },
  major: {
    type: DataTypes.STRING,
    defaultValue: '',
  },
  semester: {
    type: DataTypes.STRING,
    defaultValue: '',
  },
  studyPhase: {
    type: DataTypes.STRING,
    defaultValue: '',
  },
  collaborationGoal: {
    type: DataTypes.STRING,
    defaultValue: '',
  },
  // MySQL tidak mendukung native ARRAY, jadi kita gunakan tipe data JSON
  interestedSubjects: {
    type: DataTypes.JSON,
    defaultValue: [],
  },
  availability: {
    type: DataTypes.JSON,
    defaultValue: [],
  }
}, {
  timestamps: true,
  tableName: 'users'
});

module.exports = User;
