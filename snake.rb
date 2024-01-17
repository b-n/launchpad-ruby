
class Snake

  module Direction
    NORTH = 1
    EAST = 2
    SOUTH = 3
    WEST = 4
  end

  def initialize(display)
    @display = display

    @time_between_ticks = 250.0
    @body = [[4,4]]
    3.times { @body.push @body[0] }

    @dir = Direction::NORTH
    @ticks = 0
    @paused = false
  end

  def >>(speed)
    @time_between_ticks += speed
  end

  def <<(speed)
    @time_between_ticks -= speed if @time_between_ticks > speed
  end

  def start(background: false)
    send_to_display(nil)
    @thread = Thread.new do
      begin
        tick_loop
      rescue Exception => e
        Thread.main.raise(e)
      end
    end

    puts 'Lets Go!'
    @thread.join unless background
  end

  def change_direction(direction)
    @dir = direction
  end

  def toggle_pause
    @paused = !@paused
  end

  private

  def tick
    return if @paused
    removed = move_snake
    send_to_display([removed])
    @ticks += 1
  end

  def move_snake
    x, y = @body[0]
    case @dir
    when Direction::NORTH
      @body.unshift wrap_pos(x, y - 1)
    when Direction::EAST
      @body.unshift wrap_pos(x + 1, y)
    when Direction::SOUTH
      @body.unshift wrap_pos(x, y + 1)
    when Direction::WEST
      @body.unshift wrap_pos(x - 1, y)
    end
    @body.pop
  end

  def wrap_pos(x, y)
    x = x < 0 ? 7 : x 
    x = x > 7 ? 0 : x
    y = y < 0 ? 7 : y
    y = y > 7 ? 0 : y
    [x, y]
  end

  def send_to_display(removed)
    removed.each { |pos| draw(pos, 0) } if removed
    @body.each { |pos| draw(pos, 127) }
  end

  def draw(pos, color)
    @display.set_position_color(pos[0], pos[1], color)
  end

    
  def tick_loop
    loop do
      tick
      sleep(@time_between_ticks / 1000)
    end
  end

end
