# pi-dinger

This project allows ringing a bell with varying sequences from a Raspberry Pi
using a solenoid. A [Hubot](https://github.com/github/hubot) plugin is
provided so that you can ring the bell from inside a chat room. The Hubot
plugin uses [Amazon SQS](https://aws.amazon.com/sqs/) so that
your Raspberry Pi can live behind a NAT without any networking changes.

## Hardware requirements

- Bell
- A solenoid such as https://www.sparkfun.com/products/11015.
- A transistor or relay so that the solenoid runs on a separate power supply
  from the Raspberry Pi. Warning: Hooking the solenoid directly to your GPIO
  pins can damaged your Pi.
- The solenoid will need to be mounted next to the bell. For the time being, this is
  done using cardboard and zip ties. 3D-printed mount coming soon from @nyxcharon.

## Software installation on the Raspberry Pi

This was tested on the latest
[Raspbian based on Debian Jessie](https://www.raspberrypi.org/downloads/raspbian/):

- Install AWS CLI: `sudo apt-get install awscli`.
- Add the user that this will run as to the gpio group:
  `sudo usermod -a -G gpio USERNAME`.
- Edit the paths and credential environment variables in the systemd service file
  _raspberry-pi/bell-dinger-sqs.service_.
- Install systemd service:
  - `sudo cp raspberry-pi/bell-dinger-sqs.service /etc/systemd/system/`
  - `sudo systemctl daemon-reload`
  - `sudo systemctl start bell-dinger-sqs.service`
  - `sudo systemctl enable bell-dinger-sqs.service`

## Slack / Hubot integration

There is a [Hubot](https://github.com/github/hubot) script provided under [hubot/ding.coffe](./hubot/ding.coffee). You can use the [hubot-slack](https://github.com/slackhq/hubot-slack) adapter to integrate with your Slack account. If you need a host you can use [Heroku](https://gist.github.com/trey/9690729).

You will need to provide some envrionment variables to your hubot to access your AWS SQS:

```
export HUBOT_ACCESS_KEY_ID=YOUR_ACCESS_KEY_ID
export HUBOT_SECRET_ACCESS_KEY=YOUR_SECRET_ACCESS_KEY_ID
export HUBOT_AWS_REGION=YOUR_REGION
export HUBOT_AWS_SQS_URL=YOUR_SQS_URL
```

Once you have installed the [ding.coffee](./hubot/ding.coffee) script for hubot you will be able to ring the bell by messaging your hubot `ding`.

##### Example log

```
Alexander Paz [10:28 PM]
@hubot: ding

hubot [10:28 PM]
:bellhop_bell:
```

You can also specify a parameter that will be a sequence of dings.


```
@hubot ding
@hubot ding 1001
```

The number determines the position of the solenoid. The example shown
will strike the bell for 1/10th of a second, wait 2/10ths of a second,
and strike the bell again for 1/10th of a second. The code only allows
20 numbers inside a single message.

## SQS Message Structure

As mentioned above, The timing of striking the bell is coded into the queue
message body. To manually drive the queue you would need only to send a message
with correct body structure. For example, rather than driving the bell through
Slack, you could achieve the same result by placing a message on the queue being
monitored with the message body `1001`.


## Team Members

* [Brian Masney](https://github.com/masneyb)
* [Alex Paz](https://github.com/alexjpaz) - Hubot / Slack integration
* [Bobby Martin](https://github.com/nyxcharon) - 3D printed mount coming soon

## Images

![Raspberry Pi with a bell](images/dinger.jpg)
