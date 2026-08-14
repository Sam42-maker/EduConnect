const { DataTypes } = require("sequelize");
const sequelize = require("../config/database");

const User = sequelize.define(
  "User",
  {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true,
    },
    fullName: {
      type: DataTypes.STRING(255),
      allowNull: false,
    },
    email: {
      type: DataTypes.STRING(255),
      allowNull: false,
      unique: true,
      validate: {
        isEmail: true,
      },
    },
    password: {
      type: DataTypes.STRING(255),
      allowNull: false,
    },
    phone: {
      type: DataTypes.STRING(20),
      defaultValue: "",
    },
    role: {
      type: DataTypes.ENUM("Student", "Mentor"),
      defaultValue: "Student",
    },

    // OTP / Verification Fields
    isVerified: {
      type: DataTypes.BOOLEAN,
      defaultValue: false,
    },
    otp: {
      type: DataTypes.STRING(10),
      allowNull: true,
    },
    otpExpires: {
      type: DataTypes.DATE,
      allowNull: true,
    },

    // Profile Fields
    university: {
      type: DataTypes.STRING(255),
      defaultValue: "",
    },
    major: {
      type: DataTypes.STRING(255),
      defaultValue: "",
    },
    semester: {
      type: DataTypes.STRING(50),
      defaultValue: "",
    },
    studyPhase: {
      type: DataTypes.STRING(100),
      defaultValue: "",
    },
    collaborationGoal: {
      type: DataTypes.STRING(255),
      defaultValue: "",
    },

    // MySQL JSON fields for arrays
    interestedSubjects: {
      type: DataTypes.JSON,
      defaultValue: [],
      comment: "Array of objects: [{tag: string, isTop: boolean}]",
    },
    availability: {
      type: DataTypes.JSON,
      defaultValue: [],
    },

    // Profile completion
    profileCompletion: {
      type: DataTypes.FLOAT,
      defaultValue: 0.68,
    },
  },
  {
    timestamps: true,
    tableName: "users",
    collate: "utf8mb4_unicode_ci",
  },
);

module.exports = User;
