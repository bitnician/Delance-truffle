module.exports = {
  getEpochTime: (deadline = 0) => {
    const now = new Date();
    return Math.round(now.getTime() / 1000) + deadline;
  },
};
