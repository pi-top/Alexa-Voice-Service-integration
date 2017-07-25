# pi-top's Alexa Voice Service integration

## Table of Contents
* [Quick Start](#quick-start)
* [Overview](#overview)
	* [Linking your <b>pi-top</b> account to your Amazon account](#overview-linking-accounts)
* [Software](#software)
	* [Alexa on <b>pi-top</b>OS](#software-pt-os)
	* [Alexa on Raspbian](#software-raspbian)
* [Documentation & Support](#support)
	* [Links](#support-links)
	* [Troubleshooting](#support-troubleshooting)

## Quick Start <a name="quick-start"></a>
---
**NOTE:** You will need to have a [<b>pi-top</b>PULSE](https://github.com/pi-top/pi-topPULSE) connected to your Raspberry Pi.

---
### pi-topOS

* Log into <b>pi-top</b>DASHBOARD
* Click the microphone icon at the top
	* If you have not yet linked Amazon account with <b>pi-top</b> account, follow the on-screen instructions
	* Once you have linked accounts, clicking the microphone icon will allow you to immediately start communicating with Alexa!

### Raspbian
* Run the following commands in the terminal (with an internet connection) to install the demo:

```
sudo apt-get update
sudo apt-get install pt-avs-demo pt-pulse
```

* On any computer, [log into your <b>pi-top</b> account](https://pi-top.com/account) and link your Amazon account to your <b>pi-top</b> account

* Run the following command in the terminal to copy the demo program to your home directory: `cp /usr/lib/pt-avs/demo/demo.sh ~/alexa.sh`

* Run the demo program: `~/alexa.sh`

---
**NOTE:** *If you are experiencing any difficulties with your <b>pi-top</b>PULSE, see [here](https://github.com/pi-top/pi-topPULSE) for instructions on setting things up.*

---

## Overview <a name="overview"></a>

Using the microphone and speaker of a <b>pi-top</b>PULSE, it is possible to interact with Amazon's Alexa Voice Service. This implementation has been designed to abstract away much of the internal operations involved, allowing users to record an audio file containing a question; send this to Alexa; and download and play the Alexa response.

This requires that an Amazon account is paired with a <b>pi-top</b> account.


## Software <a name="software"></a>

### Using Alexa on <b>pi-top</b>OS <a name="software-pt-os"></a>
![Alexa Icon](https://static.pi-top.com/images/alexa_icon.png "Alexa Icon")

On the latest release of <b>pi-top</b>OS (July 2017) onwards, <b>pi-top</b>PULSE and support for Amazon Alexa are provided 'out of the box'. When you log into your <b>pi-top</b> account in <b>pi-top</b>DASHBOARD, a microphone button will appear in the navigation bar.

![Alexa Setup](https://static.pi-top.com/images/alexa_setup.png "Alexa Setup")

The first time you attempt to use the microphone button you will be prompted to link your accounts, if you have not already done so. This linking happens in your web browser; when you return to the dashboard, you may find you have to re-log in.

![Alexa Listening](https://static.pi-top.com/images/alexa_listening.png "Alexa Listening")

Once you have linked your <b>pi-top</b> and Amazon accounts, the microphone button in the navbar can be used to record a question for Alexa and hear the response...

Download the latest version of <b>pi-top</b>OS [here](https://pi-top.com/products/os#download).


### Using Alexa on Raspbian <a name="software-raspbian"></a>

#### Installing Dependencies

The scripts in this repository have the following dependencies:

* `jq` for parsing JSON responses
* `mpg123` for playing audio
* `python-pt-pulse`, for recording audio using <b>pi-top</b>PULSE hardware

These can be installed using the Raspbian package manager (Add / Remove Software), or by running the following command in the terminal:

`sudo apt-get install jq mpg123 python-pt-pulse`

#### Setup

In order for this implementation to work, `pt-avs` in the `bin` directory of this repo, is required to be installed in a location that is in your PATH environment variable. For simplicity, it is most easily placed into `/usr/bin` (with executable permissions).

In order to make use of this service, you must link an Amazon account with your <b>pi-top</b> account. This can be done by going to your [account page on the <b>pi-top</b> website](https://pi-top.com/account). You will use your <b>pi-top</b> account details in the following steps.

#### Speaking to Alexa

A [demonstration script](https://github.com/pi-top/Alexa-Voice-Service-Integration/blob/master/example/demo.sh) is included in this repository. This shows the steps required to record a question for Alexa, upload this to Amazon, download the response and play it back. The demonstration script is simply tying together a series of calls to the previously mentioned **pt-avs** executable. Below is an brief description of each step in the demo script. These steps can be repurposed as required (e.g. this could be triggered by a button or web event).

1. The first part of the process is to log in with your <b>pi-top</b> credentials:
   
   `pt-avs pt-access-token $MY_PT_USERNAME $MY_PT_PASSWORD`
   
2. The response will provide you with a **<b>pi-top</b> user ID** and **access token**. These can then be used to get an Alexa Voice Service *access token*:
   
   `pt-avs avs-access-token -u "$PT_USER_ID" -t "$PT_ACCESS_TOKEN"`
   
3. Provided that this was successful, you are now able to upload your audio recording to Amazon's Alexa Voice Service:
   
   `pt-avs upload -t "$AVS_ACCESS_TOKEN"`
   
4. When this is complete, you can play the Alexa response:
   
   `pt-avs playback`

## Support <a name="support"></a>

### Links <a name="support-links"></a>

* [Support](https://support.pi-top.com/)

### Troubleshooting FAQ <a name="support-troubleshooting"></a>

#### Why is Alexa not responding?

* There are a few reasons that this is happening - be sure to check the error response that you get.
	* Common problems include:
		* Invalid <b>pi-top</b> login credentials
		* No Amazon account is paired with the <b>pi-top</b> account
		* A bad internet connection
