require "./resources"

class Game::World
  property ts : Int64

  def initialize(@ts = 0)
    @map = Map.new
    @resources = Resources.new
    @tasks = Queue.new
  end

  getter ts
  getter resources
  getter map

  def push(command : Command)
    dur = command.start(self)
    done_at = @ts + dur.to_i64
    @tasks.push(done_at, command)
  end

  def run(ts : Int64)
    loop do
      item = @tasks.pop(ts)
      if item.nil?
        break
      end
      command = item.command
      @ts = item.ts
      command.finish(self)
    end
    @ts = ts
  end
end
