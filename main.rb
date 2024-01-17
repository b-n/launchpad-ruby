require './display'
require './snake'
require 'midi-eye'
require 'concurrent'

require 'snake/snake'

hi = Snake::Main.new

@midi_input = UniMIDI::Input.use(1)
@midi_output = UniMIDI::Output.use(1)

display = Display.new(@midi_output)
display.reset(0.02)

game = Snake.new(display)

MIDIEye::Listener.new(@midi_input).tap do |listener|
  listener.listen_for do |event|
    message = event[:message]
    if message.is_a?(MIDIMessage::ControlChange)
      index, value = message.data
      next unless value == 127
      case index
      when 91
        game.change_direction(Snake::Direction::WEST)
      when 92
        game.change_direction(Snake::Direction::EAST)
      when 19
        game.change_direction(Snake::Direction::SOUTH)
      when 29
        game.change_direction(Snake::Direction::NORTH)
      when 89
        game<<10
      when 79
        game>>10
      when 69
        game.toggle_pause
      when 59
        display.reset(0)
      end
      next
    end
    next unless message.velocity == 127

    x, y = display.get_note_position(message.note)

    for i in 0..7
      display.set_position_color(i, y, 127)
    end

    for i in 0..7
      display.set_position_color(x, i, 126)
    end

    display.set_position_color(x, y, 63)
  end
end.run(background: true)

display.run_render_loop(background: true)
game.start
