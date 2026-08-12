const { Op } = require('sequelize');
const User = require('../models/User');

exports.getDiscoverFeed = async (req, res) => {
  try {
    const currentUser = await User.findByPk(req.user.id);
    if (!currentUser) {
      return res.status(404).json({ message: 'User not found' });
    }

    // Ambil semua mahasiswa selain user yang sedang login
    const allUsers = await User.findAll({
      where: {
        id: {
          [Op.ne]: req.user.id
        },
        role: 'Student'
      }
    });

    const matches = allUsers.map(user => {
      let percentage = 55;
      let isSameMajor = false;
      let isSamePhase = false;
      let isSameGoal = false;

      // Cek BASE POOL
      if (user.major && user.major === currentUser.major) {
        isSameMajor = true;
        percentage += 12;
      }
      if (user.studyPhase && user.studyPhase === currentUser.studyPhase) {
        isSamePhase = true;
        percentage += 9;
      }
      if (user.collaborationGoal && user.collaborationGoal === currentUser.collaborationGoal) {
        isSameGoal = true;
        percentage += 7;
      }

      const isBasePool = isSameMajor && isSamePhase && isSameGoal;

      // Cek Irisan Minat (Tags)
      let sharedTagsCount = 0;
      let topInterestMatch = false;

      const myTags = currentUser.interestedSubjects || [];
      const theirTags = user.interestedSubjects || [];

      // Cari Top Interest milik user saat ini
      const myTopInterestObj = myTags.find(t => t.isTop === true);
      const myTopInterest = myTopInterestObj ? myTopInterestObj.tag : null;

      theirTags.forEach(theirTagObj => {
        const theirTag = theirTagObj.tag;
        const matchingMyTag = myTags.find(t => t.tag === theirTag);
        
        if (matchingMyTag) {
          sharedTagsCount++;
          percentage += 6;
          
          if (theirTag === myTopInterest) {
            topInterestMatch = true;
          }
        }
      });

      if (topInterestMatch) {
        percentage += 8;
      }

      if (percentage > 99) percentage = 99;

      // Tentukan Tier
      let tier = 3; // Relevant Match
      if (isBasePool) {
         if (topInterestMatch || sharedTagsCount >= 3) {
            tier = 1; // Top Match
         } else if (sharedTagsCount === 2) {
            tier = 2; // Strong Match
         }
      }

      return {
        id: user.id,
        fullName: user.fullName,
        university: user.university,
        major: user.major,
        tier: tier,
        percentage: percentage,
        sharedTagsCount: sharedTagsCount,
        topInterestMatch: topInterestMatch,
        interestedSubjects: user.interestedSubjects,
        studyPhase: user.studyPhase,
        collaborationGoal: user.collaborationGoal
      };
    });

    // Urutkan berdasarkan persentase tertinggi
    matches.sort((a, b) => b.percentage - a.percentage);

    res.json({ matches });
  } catch (error) {
    console.error('Error fetching discover feed:', error);
    res.status(500).json({ message: 'Terjadi kesalahan pada server' });
  }
};

exports.sendConnectionRequest = async (req, res) => {
  // TODO: Implementasi logika mengirim koneksi nanti (Fase 3/4)
  res.json({ message: 'Request sent successfully' });
};
