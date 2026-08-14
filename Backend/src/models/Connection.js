const { DataTypes } = require("sequelize");
const sequelize = require("../config/database");
const User = require("./User");

const Connection = sequelize.define(
  "Connection",
  {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true,
    },
    userId: {
      type: DataTypes.UUID,
      allowNull: false,
    },
    connectedUserId: {
      type: DataTypes.UUID,
      allowNull: false,
    },
    status: {
      type: DataTypes.ENUM("pending", "accepted", "rejected", "blocked"),
      defaultValue: "pending",
    },
    matchPercentage: {
      type: DataTypes.FLOAT,
      defaultValue: 0,
    },
    connectedAt: {
      type: DataTypes.DATE,
      defaultValue: DataTypes.NOW,
    },
  },
  {
    timestamps: true,
    tableName: "connections",
    collate: "utf8mb4_unicode_ci",
  },
);

// Associations
Connection.belongsTo(User, { foreignKey: "userId", as: "user" });
Connection.belongsTo(User, {
  foreignKey: "connectedUserId",
  as: "connectedUser",
});

module.exports = Connection;
