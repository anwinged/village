class World
  property ts : Int32

  def initialize
    @ts = 0
    @map = Map.new
    @resources = Resources.new
    @tasks = App::Queue.new
  end

  getter ts
  getter resources
  getter map

  def push(command : Command)
    dur = command.start(self)
    done_at = @ts + dur
    printf "world : %d : plan `%s` at %d\n", @ts, typeof(command), done_at
    @tasks.push(done_at, command)
  end

  def run(ts : Int32)
    loop do
      item = @tasks.pop(ts)
      if item.nil?
        break
      end
      command = item.command
      @ts = item.ts
      command.finish(self)
      printf "world : %d : finish `%s`\n", @ts, typeof(command)
    end
  end
end
