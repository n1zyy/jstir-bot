require 'cinch'
require 'twitter'

class OpenStack
  include Cinch::Plugin

  match(/(.*)openstack(.*)/i, {:prefix => ''})

  def execute(m)
    case m.message
    when /openstack/
      pass
    when /OpenStack/
      pass
    end
    m.reply "#{m.user.nick}: ITYM 'OpenStack'."
  end
end

class Twit
  @@bot ||= Twitter::REST::Client.new do |config|
    config.consumer_key        = "FIXME"
    config.consumer_secret     = "FIXME"
    config.access_token        = "FIXME"
    config.access_token_secret = "FIXME"
  end

  def self.tweet(text)
    @@bot.update(text)
  end
end



    # !chanslap <nick>:
    # - rename jstir to JSTIR_THE_CHANNEL_NAZI
    # - halibut the offender
    # - tell them to take the conversation upstream
    # - add a random insult
    # - rename back
    class ChanSlap
      include Cinch::Plugin
     
      match /chanslap\s+(\w+)/
     
      def execute(m, slappee)
        insults = [
          "DIAF",
          "you dummy",
          "you're like a forty degree day!",
          "you're an aeolus developer",
          "YOUR MOM",
          "Klaus would be disappointed",
          "If you don't behave, I'll tell lifeless",
          "you look exactly like tzumainn"
        ]
     
        prev_nick = bot.nick
        bot.nick = 'JSTIR_THE_CHANNEL_NAZI'
        m.reply "><}}}*> #{slappee}"
        m.reply "#{slappee}: you need take this upstream, $gender."
        m.reply "#{slappee}: #{insults.sample}"
        sleep(0.5)  # let's see if this fixses the broken action order 
        bot.nick = prev_nick
      end
    end



bot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.example.com"
    c.nick = "jstir"
    c.channels = ["#gabelstaplerfahrer"]
    #c.channels = ["#maw-test"]
    c.plugins.plugins = [OpenStack, ChanSlap]
  end

  # Halibut match -- FIXME -- move this out of here
  on :message, /^!halibut (.+)/ do |msg, target|
    target = "#{msg.user.nick} :-P" if target == 'jstir'
    msg.reply "><}}}*> #{target}"
  end

  # Let's be sassy if people nick-mention us:
  on :message, /^jstir:/ do |msg|
    replies = ["Whatever.", "That's nice.", "DIAF", "YOUR FACE", "I don't know.", "The Pope?",
               "That's what she said.", "Absolutely. 110%.", "Why do you still work here?"]
    msg.reply "#{msg.user.nick}: #{replies.sample}"
  end

  # Twitter!
  on :message, /^!tweet (.+)/ do |prefix, body|
    Twit.tweet(body)
  end

end

bot.start
