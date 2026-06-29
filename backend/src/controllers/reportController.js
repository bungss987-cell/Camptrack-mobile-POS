const reportService = require('../services/reportService');

const getMonthlyReport = async (req, res, next) => {
  try {
    const csvData = await reportService.generateMonthlyReport();

    res.setHeader('Content-Type', 'text/csv');
    res.setHeader(
      'Content-Disposition',
      `attachment; filename=camptrack-report-${Date.now()}.csv`
    );

    return res.status(200).send(csvData);
  } catch (err) {
    next(err);
  }
};

module.exports = { getMonthlyReport };