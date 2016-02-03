# Description:
# Ding
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#
# hubot ding
#

AWS = require 'aws-sdk'

key = process.env.HUBOT_ACCESS_KEY_ID
secret = process.env.HUBOT_SECRET_ACCESS_KEY
region = process.env.HUBOT_AWS_REGION
url = process.env.HUBOT_AWS_SQS_URL

AWS.config.update({
  accessKeyId: key,
  secretAccessKey: secret,
  region: region
})

queue = new AWS.SQS({params: {QueueUrl: url}})

module.exports = (robot) ->
  robot.respond /ding( .*)?/, (res) ->
    sequence = res.match[1] || "1"
    body = sequence.trim();
    queue.sendMessage {MessageBody: body}, (err, data) ->
      if !err
        res.send ":bellhop_bell:"
