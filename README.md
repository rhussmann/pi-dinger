# raspberry-pi-bell-dinger

Your office needs a bell.

This project allows ringing a bell with varying sequences from a Raspberry Pi
using a solenoid. A [Hubot](https://github.com/github/hubot) plugin is
provided so that you can ring the bell from inside [Slack](https://slack.com/).
The Hubot plugin drops a message in [Amazon SQS](https://aws.amazon.com/sqs/)
so that your Raspberry Pi can live behind a NAT without any networking changes.

## Hardware requirements

- Bell
- A solenoid such as https://www.sparkfun.com/products/11015. You could
  order https://www.sparkfun.com/products/10391 if you want a much louder ring.
- A transistor or relay so that the solenoid runs on a separate power supply
  from the Raspberry Pi. Warning: Hooking the solenoid directly to your GPIO
  pins can damaged your Pi.
- The solenoid will need to be mounted next to the bell. For the time being, this is
  done with cardboard and zip ties. 3D-printed mount coming soon from @nyxcharon.

## Software installation on the Raspberry Pi

This was tested on the latest Raspbian based on Debian Jessie:

- Install dependencies: `sudo apt-get install awscli`.
- Add the user that this will run as to the gpio group:
  `sudo usermod -a -G gpio USERNAME`.
- Edit the paths and credential environment variables in the systemd service file
  _raspberry-pi/bell-dinger-sqs.service_.
- Install systemd service:
  - `sudo cp raspberry-pi/bell-dinger-sqs.service /etc/systemd/system/`
  - `sudo systemctl daemon-reload`
  - `sudo systemctl start bell-dinger-sqs.service`

## Slack integration

There is a [Hubot](https://github.com/github/hubot) script provided under [hubot/ding.coffe](./hubot/ding.coffee). You can use the [hubot-slack](https://github.com/slackhq/hubot-slack) adapter to integrate with your Slack account. If you need a host you can use [Heroku](https://gist.github.com/trey/9690729).

Once you have installed the [ding.coffee](./hubot/ding.coffee) script for hubot you will be able to active the bell by messaging your hubot `ding`.

##### Example log

```
Alexander Paz [10:28 PM] 
@hubot: ding

hubot [10:28 PM] 
:bellhop_bell:
```

You can also specify a parameter to pass to the ding program (e.g. a stronger ding)

```
@hubot ding
@hubot ding {strength}
```

## Team Members

* [Brian Masney](https://github.com/masneyb)
* [Alex Paz](https://github.com/alexjpaz) - Slack integration
* [Bobby Martin](https://github.com/nyxcharon) - 3D printed mount coming soon

## Images

![Raspberry Pi with a bell](images/dinger.jpg)

