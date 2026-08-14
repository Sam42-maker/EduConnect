const { DataTypes } = require("sequelize");
const sequelize = require("../config/database");
const User = require("./User");

const Message = sequelize.define(
  "Message",
  {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true,
    },
    senderId: {
      type: DataTypes.UUID,
      allowNull: false,
    },
    senderName: {
      type: DataTypes.STRING(255),
      allowNull: false,
    },
    receiverId: {
      type: DataTypes.UUID,
      allowNull: false,
    },
    content: {
      type: DataTypes.TEXT("long"),
      allowNull: false,
    },
    timestamp: {
      type: DataTypes.DATE,
      defaultValue: DataTypes.NOW,
    },
    isRead: {
      type: DataTypes.BOOLEAN,
      defaultValue: false,
    },
    attachmentUrl: {
      type: DataTypes.STRING(500),
      allowNull: true,
    },
  },
  {
    timestamps: false,
    tableName: "messages",
    collate: "utf8mb4_unicode_ci",
  },
);

// Associations
Message.belongsTo(User, { foreignKey: "senderId", as: "sender" });
Message.belongsTo(User, { foreignKey: "receiverId", as: "receiver" });

module.exports = Message;
