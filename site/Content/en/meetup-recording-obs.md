---
title: Recording Your Meetup with OBS Studio
description: A practical guide for meetup organizers on setting up a simple but effective recording system using OBS Studio and minimal hardware investment.
published: false
layout: ArticleLayout
date: 2025-09-01 00:00:00
language: en
---

After years of recording meetups, I've learned that you don't need expensive equipment or a complex setup to capture quality content for your community. The biggest barrier isn't technical—it's just getting started. This guide will show you exactly what hardware to buy and how to configure OBS Studio to record or stream your events, based on the setup I use for my own meetups.

## Why record your meetup?

Before diving into the how, let's talk about the why. Recording your meetups creates a permanent resource for your community. People who couldn't attend can watch later, speakers have a portfolio piece, and you're building a knowledge base that grows with each event. Plus, once you have the setup, the marginal effort for each recording is minimal.

## The hardware shopping list

Here's the minimum viable setup that I've been using successfully:

### USB Capture Card (~$20-40)
This little device is the magic that lets you capture the presenter's screen directly. Look for any HDMI to USB capture card that supports 1080p. You don't need the expensive ones—the generic ones work perfectly fine for meetup recording. The presenter connects their laptop to the capture card via HDMI, and the capture card connects to your recording laptop via USB.

### Wireless Lavalier Microphone (~$30-50)
Audio quality matters more than video quality. A wireless lav mic gives your presenter freedom to move around while ensuring clear audio. I use a simple USB wireless lav mic that the presenter can clip to their shirt. The receiver plugs directly into my MacBook running OBS.

### Your Laptop
You'll need a laptop to run OBS Studio. I use my MacBook Pro, but any decent laptop from the last 5 years will work. The processing requirements aren't heavy unless you're streaming at very high quality.

### iPhone + Tripod (~$15-30 for the tripod)
You probably already have an iPhone. Add a simple tripod (the phone holder type), and you have a second camera angle. This captures the presenter and adds a human element to your recordings. Position it to show the presenter from the side or at an angle where they're naturally looking.

### HDMI Cable
One extra HDMI cable for connecting the presenter's laptop to your capture card. Always have a spare—they have a talent for disappearing right before events.

**Total investment: ~$65-120** (excluding devices you already own)

## Setting up OBS Studio

OBS Studio is free, open-source, and surprisingly powerful. Here's how to configure it for meetup recording:

### Step 1: Download and install OBS
Get it from [obsproject.com](https://obsproject.com). Install it and go through the initial setup wizard, choosing "Optimize for recording" rather than streaming (you can always change this later).

### Step 2: Configure your scenes
I use a simple two-scene setup:

**Scene 1: "Presentation"**
- Main source: Video Capture Device (your USB capture card)
- Secondary source: iPhone camera feed (using EpocCam or similar app)
- Audio: Your wireless mic

**Scene 2: "Break"** 
- A simple image or text saying "We'll be right back"
- Useful for breaks or technical difficulties

### Step 3: Add your sources

Click the + button in Sources and add:

1. **Video Capture Device**: Select your USB capture card. This will show the presenter's screen.

2. **Window Capture** (for iPhone): Use an app like EpocCam or Camo to turn your iPhone into a webcam. Add it as a window capture or second video device.

3. **Audio Input Capture**: Select your wireless mic receiver.

### Step 4: Arrange your layout

For the presentation scene, make the screen capture take up most of the canvas. Add the iPhone feed as a small picture-in-picture in the bottom corner. You can resize and position sources by clicking and dragging them in the preview.

### Step 5: Configure recording settings

Go to Settings > Output:
- Recording Format: mp4 (universal compatibility)
- Recording Quality: "High Quality, Medium File Size"
- Recording Path: Create a dedicated folder for your meetup recordings

For more control:
- Video Bitrate: 6000 Kbps (good balance of quality and file size)
- Audio Bitrate: 160

## The recording workflow

### Before the event

1. **Arrive 30 minutes early**: Setup always takes longer than expected.

2. **Test everything**: 
   - Connect the presenter's laptop to your capture card
   - Check that OBS is receiving the video signal
   - Test audio levels with the wireless mic
   - Position and connect your iPhone on the tripod
   - Do a 30-second test recording

3. **Presenter checklist**:
   - Set their display to 1080p (higher resolutions might not work with cheaper capture cards)
   - Disable notifications
   - Close unnecessary applications
   - Use presentation mode if showing slides

### During the event

1. **Start recording before the talk begins**: You can trim later, but you can't recover what wasn't recorded.

2. **Monitor audio levels**: Keep an eye on the audio meter in OBS. It should peak in the yellow, never in the red.

3. **Stay near your laptop**: Be ready to switch scenes during breaks or if technical issues arise.

4. **Don't stress about perfection**: A slightly imperfect recording is infinitely better than no recording.

### After the event

1. **Stop recording**: Don't forget this step—I've lost recordings by closing OBS without stopping the recording first.

2. **Back up immediately**: Copy the file to cloud storage or an external drive before leaving the venue.

3. **Basic editing** (optional): 
   - Trim the beginning and end
   - Add a title card
   - Normalize audio if needed

I use DaVinci Resolve (free) for quick edits, but even uploading the raw file is valuable for your community.

## Common issues and solutions

**"The capture card isn't showing anything"**
- Check the HDMI cable connection at both ends
- Have the presenter change their display resolution to 1080p
- Try unplugging and reconnecting the USB capture card
- Some capture cards need the presenter to mirror displays rather than extend

**"The audio is echoing"**
- Mute the presenter's laptop microphone
- In OBS, make sure you're only capturing audio from your wireless mic, not the capture card

**"The recording is choppy"**
- Lower your recording quality settings
- Close other applications on your recording laptop
- Make sure your laptop is plugged in and not in power-saving mode

**"The presenter's screen looks stretched or cut off"**
- Right-click the video source in OBS and select "Resize output (source size)"
- Adjust the presenter's display resolution

## Going live: Streaming instead of recording

Once you're comfortable recording, streaming is just a small step further. The same setup works perfectly for live streaming to YouTube or Twitch. The only addition is a stable internet connection at your venue. In OBS, you'll just need to:

1. Go to Settings > Stream
2. Select your platform (YouTube, Twitch, etc.)
3. Enter your stream key
4. Click "Start Streaming" instead of "Start Recording"

Pro tip: You can stream AND record simultaneously for the best of both worlds.

## The most important advice

Just start. Your first recording won't be perfect, and that's okay. The community values the content over production quality. Each event, you'll get a little better at the setup, develop your own workflow, and before you know it, recording will just be a natural part of your meetup routine.

The setup I've described here has worked reliably for dozens of events. It's simple enough that you can set it up quickly, affordable enough that it won't break your budget, and good enough that your community will appreciate having access to the content.

Remember: the best recording setup is the one you'll actually use. Start simple, be consistent, and improve over time. Your future community members will thank you for it.