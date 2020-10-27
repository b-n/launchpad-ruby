class Display
  DISPLAY_FPS = 1.0 / 120
  
  def initialize(output)
    @output = output
    @note_mapping = [
      [*(81..88)],
      [*(71..78)],
      [*(61..68)],
      [*(51..58)],
      [*(41..48)],
      [*(31..38)],
      [*(21..28)],
      [*(11..18)]
    ]

    p @note_mapping

    @note_positions = []
    @note_mapping.each_with_index { |arr, y|
      arr.each_with_index { |note, x|
        @note_positions[note] = [x, y]
      }
    }
    @note_velocities = {}
    @note_velocities_buffer = {}
  end

  def get_position_velocity(x, y)
    get_note_velocity(@note_mapping[y][x])
  end

  def get_note_velocity(note)
    @note_velocities[note] || 0
  end

  def get_note_position(note)
    @note_positions[note] 
  end

  def get_note_at_position(x, y)
    @note_mapping[y][x]
  end

  def reset(sleep_timer)
    @note_mapping.each do |arr|
      arr.each do |note|
        set_note_color(note, 0, immediate: true)
        sleep(sleep_timer) if sleep_timer
      end
    end
  end

  def set_position_color(x, y, velocity, immediate: false)
    set_note_color(
      get_note_at_position(x, y),
      velocity,
      immediate: immediate
    )
  end

  def set_note_color(note, velocity, immediate: false)
    @note_velocities_buffer[note] = velocity
    if immediate
      @note_velocities[note] = velocity
      write_to_midi(note, velocity)
    end
  end

  def draw_buffer
   @note_velocities_buffer.each do |note, velocity|
     write_to_midi(note, velocity) if @note_velocities[note] != velocity
     @note_velocities[note] = velocity
   end
  end

  def run_render_loop(background: false)
    @render_loop = Thread.new do
      begin
        render_buffer_loop
      rescue Exception => e
        Thread.main.raise(e)
      end
    end

    @render_loop.join unless background
  end

  private 

  def write_to_midi(note, velocity)
    @output.puts(MIDIMessage::NoteOn.new(
      0,
      note,
      velocity
    ))
  end

  def render_buffer_loop
    loop do
      draw_buffer
      sleep(DISPLAY_FPS)
    end
  end
end
