const { DataTypes } = require("sequelize");
const sequelize = require("../config/database");
const User = require("./User");
const Community = require("./Community");

const CommunityMember = sequelize.define(
  "CommunityMember",
  {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true,
    },
    communityId: {
      type: DataTypes.UUID,
      allowNull: false,
    },
    userId: {
      type: DataTypes.UUID,
      allowNull: false,
    },
    joinedAt: {
      type: DataTypes.DATE,
      defaultValue: DataTypes.NOW,
    },
  },
  {
    timestamps: false,
    tableName: "community_members",
    collate: "utf8mb4_unicode_ci",
  },
);

// Associations
CommunityMember.belongsTo(Community, { foreignKey: "communityId" });
CommunityMember.belongsTo(User, { foreignKey: "userId" });

Community.hasMany(CommunityMember, { foreignKey: "communityId" });
User.hasMany(CommunityMember, { foreignKey: "userId" });

module.exports = CommunityMember;
