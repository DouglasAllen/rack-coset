# Thanks for looking at my code.
#
# Copyright (C) 2002, 2004  Christian Neukirchen <chneukirchen@gmail.com>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License.

require 'enumerator'
STDOUT.sync = true

class XMasHack2005
  HEIGHT = 6
  WIDTH = 60

  HOME = "\e[H"
  CLEAR ="\e[H\e[2J"

  def initialize
    @snow = [0] * WIDTH
    message = ["MERRY CHRISTMAS\nAND A\nHAPPY NEW YEAR!"]
    @message = message.map { |line|
      line.chomp.gsub(//, ' ').center(WIDTH)
    }

    2.times {
      @m1 = @message.unshift " "*WIDTH
      @m2 = @m1.push " "*WIDTH
    }

    @m3 = Marshal.dump @m2.reverse.map { |l|
      l.unpack("C*")
    }.transpose
  end
    
  def run
    print CLEAR

    until snow_over?
      snowdrop!
      puts to_s
      print HOME
      sleep 0.05
    end

    puts to_s
    ticker "brought to you by chris2"
    puts
    puts

  end

  def snow_over?
    @snow.all? { |a| a >= HEIGHT-1 }
  end
  
  def snowdrop!
    loc = rand(WIDTH - 1)
    @snow[loc] += 1
  
    changed = true

    while changed
      changed = false

      @snow.each_with_index do |e, i|
        next  if i == WIDTH - 1

        if @snow[i+1]+1 < e
          @snow[i] -= 1
          @snow[i+1] += 1
          changed = true
        end

        next  if i == 0

        if @snow[i-1]+1 < e
          @snow[i] -= 1
          @snow[i-1] += 1
          changed = true
        end

        @snow[i] = 0   if @snow[i] < 0

        if @snow[i] > HEIGHT-1
          @snow[i] = HEIGHT-1
          changed = true
        end
      end

    end
    
    @snow

  end

  def make_message(message)



  end

  def to_s
    l = ""

    @snow.each_cons(2) { |a, b|
      l << "_\\/"[a <=> b]
    }

    l << "_"

    r = Marshal.load(@message)

    @snow.each_with_index { |h, i|
      o = (l[i] == ?\\) ? 0 : 1
      r[i][h+o] = h+o == HEIGHT ? ?_ : l[i]
      (h+o+1).upto(HEIGHT) { |j| r[i][j] = (rand > 0.75) ? ?* : 32 }
    }


    r.each { |n| n.reverse! }

    r.transpose.map { |n| n.pack("C*") }.join("\n")

  end

  def ticker(message)
    print " " * ((WIDTH-message.size)/2)
    message.each_byte { |b| putc b; sleep 0.2 }
    puts
  end

end

XMasHack2005.new.run
