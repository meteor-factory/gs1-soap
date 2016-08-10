if Meteor.isServer
  logger = Winston;
  logger.info('server started, log with winston', new Date())