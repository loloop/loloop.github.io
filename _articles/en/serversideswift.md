---
title: Let's talk about Swift on Linux?
thumbnail: 
description: Swift on Linux is an area little explored by Apple platform developers, but it can be a very useful tool and an immense source of knowledge, and it is very worth learning.
publish: false
layout: article
header: /img/serverswift/tux.png
date: 2023-10-25 00:00:00
---

Swift on Linux is an area little explored by Apple platform developers, but it can be a very useful tool and an immense source of knowledge, and it is very worth learning.

{% assign img = "/img/serverswift" %}

We all already understand writing code, and seeing the result of our creation is not very different from other platforms when we are on the server, but one thing that I personally have always had a lot of problems with is: How do I make my code available to other people? We already know how to upload an app to the App Store, but what about uploading an open service on the internet? There are so many ways, all correct, each in its own way and it is almost impossible to choose one

## The Project

I created [@F1LandinhoBot](https://t.me/F1LandinhoBot) with the purpose of helping me remember the times of Formula 1 races in a group of friends, accessing Telegram’s API and sending messages so that we would not miss any races whatsoever.

![]({{img}}/telegram.png)

And everything worked fine running directly on my Mac, but I don't want to leave my Mac on all the time running this code for the bot to work and I don't even want to think about how I'm going to guarantee that it will work all the time. Where I live, power outages are pretty common, and it seems like a waste of my computer's processing power anyway.

So I decided to put this code to run on my Amazon server, which I've already had running a [Quake server](https://quake.host) for a few years, so I wouldn't need to pay a single penny more than I already paid for it to get the service up and running. The Swift setup on Linux is fully detailed on [Swift.org](https://swift.org) and despite being a little long, it is easy to follow. I cloned the code from GitHub and I wasn't expecting what came next:

![]({{img}}/wont-build.png)
<p class="center muted caption">OpenCombine is a library made specifically for us to use Combine on Linux, how come it doesn't exist? Since when is URLSession an AnyObject?</p>

## Swift on Linux

There are some speed bumps along the way to server-side Swift that are rarely mentioned, mainly because they are abstracted by the famous frameworks, but that you will encounter very quickly if you go the route of writing “pure” code. They all exist because Swift on Mac does not have the same libraries as Swift on Linux. The Foundation, which we are quite used to using in the Apple world, is not the same Foundation that exists in Linux, and this is [not documented](https://forums.swift.org/t/what-are-best-practices-to-write-a-linux-software-on-macos/) anywhere. It's a problem that is [not going to last long]((https://www.swift.org/blog/future-of-foundation/)), but it's still a problem.

![]({{img}}/urlsession.png)
<p class="center muted caption">URLSession is on a completely different library on Linux, that does not even exists on macOS!</p>

## Publishing our work

Once these problems were solved, I finally had my project compiling and running on the server! But now, how do I leave it running there? I can't just close the ssh in my terminal, because it will stop the code from executing. To solve this problem, I've used `systemd`, which is Ubuntu's default service manager.

My configuration file is very simple, I asked GPT to create a base and I customized it with my needs, like my environment variables (don't put them directly in your code!) and what my service would have to do if a problem occurred.

```
[Unit]
Description=Landinho formula one schedule telegram bot
After=network-online.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/home/ubuntu/LandinhoBot
ExecStart=/home/ubuntu/swift/swift-5.7.3-RELEASE-ubuntu22.04/usr/bin/swift run
Environment="TELEGRAM_TOKEN=6103171:AAHrN7p7rTJPgeNoeYRo"
Environment=“DEBUG_CHAT=-123131234"
Restart=always

[Install]
WantedBy=multi-user.target
```

After that, I still need to enter the server, download the code, compile and run the service. This whole process is very boring to do, and as it is not part of our daily lives, we may even forget what all these steps are like, so I wrote a very simple deploy script, to make the process easier. It downloads the code, compiles it and restarts the service:

```swift {% comment %} O highlight fica esquisito com a opção de bash {% endcomment %}
#!/bin/bash

git fetch
git pull origin main
(
  cd telegram
  swift build
  sudo systemctl restart landinho.service
)
```

But I still have to log into the server, run the script and check if everything is ok. It can be better. To solve this, after talking to a friend who is full-stack, I decided to go for the simplest route possible: Automate the process that I was already doing manually, through GitHub Actions.

``` {% comment %} syntax highlight de yaml fica ruim aqui tb {% endcomment %}
on:
  push:
    branches:
    - main
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - name: configure-ssh
      run: |
          mkdir -p ~/.ssh/
          echo "$key" > ~/.ssh/server.key
          chmod 400 ~/.ssh/server.key
          cat >>~/.ssh/config <<END
          Host server
            HostName $host
            User $username
            IdentityFile ~/.ssh/server.key
            StrictHostKeyChecking no
          END
    - name: run-deploy-script
      run: ssh server 'cd LandinhoBot; sh deploy.sh'
    env:
      host: ${% raw %}{{secrets.SSH_HOST}}{% endraw %}
      username: ${% raw %}{{secrets.SSH_USERNAME}}{% endraw %}
      key: ${% raw %}{{secrets.SSH_KEY}}{% endraw %}
``` 

It's important to thank [@flpms](https://twitter.com/flpms), the friend I mentioned during the article. The part of the configuration that creates the SSH configuration file for GitHub Actions is his authorship.

Dissecting the Actions configuration, we have a job that will be executed every time a push happens on my `main` branch, with a step to configure SSH and a step to execute our deploy script.

And that's it! This way you can automate the execution of your code on any Linux machine that you have access to the terminal. But there is another alternative:

## Platform as a Service

An easier way to do  this entire process is using a platform like [Render](https://render.com) (or thousands of other services that do the same thing), which will abstract the entire process of configuring the environment, deploying it when there is a merge, and it will give you other perks, such as database backups and so on. This ease of use has its costs ($), and if you want to upgrade another service, the costs will rise way faster.

![]({{img}}/render.png)

There's not much to say about these platforms, as each one will have its own specifics, but it's an alternative that I really enjoy using! The less time we spend on infrastructure, the more we can invest in the product itself, and that's what matters in the end. Until next time!
