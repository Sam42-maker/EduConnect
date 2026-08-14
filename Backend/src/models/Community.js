const { DataTypes } = require("sequelize");
const sequelize = require("../config/database");
const User = require("./User");

const Community = sequelize.define(
  "Community",
  {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true,
    },
    name: {
      type: DataTypes.STRING(255),
      allowNull: false,
    },
    description: {
      type: DataTypes.TEXT,
      allowNull: true,
    },
    icon: {
      type: DataTypes.STRING(255),
      allowNull: true,
    },
    memberCount: {
      type: DataTypes.INTEGER,
      defaultValue: 0,
    },
    isVerified: {
      type: DataTypes.BOOLEAN,
      defaultValue: true,
    },
    category: {
      type: DataTypes.STRING(100),
      defaultValue: "",
    },
  },
  {
    timestamps: true,
    tableName: "communities",
    collate: "utf8mb4_unicode_ci",
  },
);

module.exports = Community;
